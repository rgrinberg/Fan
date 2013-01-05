open LibUtil
open Ast
open FSig
open Format
open Lib
module Ast = FanAst
let keep = ref false
type plugin = 
  {
  transform: module_types -> str_item;
  mutable activate: bool;
  position: string option;
  filter: (string -> bool) option} 
let apply_filter f (m : module_types) =
  (let f =
     function
     | `Single (s,_) as x -> if f s then Some x else None
     | `Mutual ls ->
         let x =
           List.filter_map
             (fun ((s,_) as x)  -> if f s then Some x else None) ls in
         (match x with
          | [] -> None
          | x::[] -> Some (`Single x)
          | y -> Some (`Mutual y)) in
   List.filter_map f m : module_types )
type plugin_name = string 
let filters: (plugin_name,plugin) Hashtbl.t = Hashtbl.create 30
let show_code = ref false
let print_collect_module_types = ref false
let register ?filter  ?position  (name,f) =
  if Hashtbl.mem filters name
  then eprintf "Warning:%s filter already exists!@." name
  else
    Hashtbl.add filters name
      { transform = f; activate = false; position; filter }
let show_modules () =
  Hashtbl.iter (fun key  _  -> Format.printf "%s@ " key) filters;
  print_newline ()
let plugin_add plugin =
  (try let v = Hashtbl.find filters plugin in fun ()  -> v.activate <- true
   with
   | Not_found  ->
       (fun ()  -> show_modules (); failwithf "plugins %s not found " plugin))
    ()
let plugin_remove plugin =
  (try let v = Hashtbl.find filters plugin in fun ()  -> v.activate <- false
   with
   | Not_found  ->
       (fun ()  ->
          show_modules ();
          eprintf "plugin %s not found, removing operation ignored" plugin))
    ()
let filter_type_defs ?qualified  () =
  object 
    inherit  FanAst.map as super
    val mutable type_defs = let _loc = FanLoc.ghost in `StNil _loc
    method! sig_item =
      function
      | `SgVal (_loc,_,_)|`SgInc (_loc,_)|`SgExt (_loc,_,_,_)|`SgExc (_loc,_)|
          `SgCls (_loc,_)|`SgClt (_loc,_)|`SgDir (_loc,_,`ExNil _)|`SgMod
                                                                    (_loc,_,_)|
          `SgMty (_loc,_,_)|`SgRecMod (_loc,_)|`SgOpn (_loc,_) -> `SgNil _loc
      | `SgTyp (_,(`TyDcl (_loc,name,vars,ctyp,constraints) as x)) ->
          let x =
            match ((Ctyp.qualified_app_list ctyp), qualified) with
            | (Some (`IdAcc (_loc,i,_),ls),Some q) when
                (Ident.eq i q) && (Ctyp.eq_list ls vars) ->
                `TyDcl (_loc, name, vars, (`TyNil _loc), constraints)
            | (_,_) -> super#ctyp x in
          let y = `StTyp (_loc, x) in
          let () = type_defs <- `StSem (_loc, type_defs, y) in
          `SgTyp (_loc, x)
      | `SgTyp (_loc,ty) ->
          let x = super#ctyp ty in
          let () = type_defs <- `StSem (_loc, type_defs, (`StTyp (_loc, x))) in
          `SgTyp (_loc, x)
      | x -> super#sig_item x
    method! ident =
      function
      | `IdAcc (_loc,x,y) as i ->
          (match qualified with
           | Some q when Ident.eq q x -> super#ident y
           | _ -> super#ident i)
      | i -> super#ident i
    method! ctyp =
      function
      | `TyMan (_loc,_,ctyp) -> super#ctyp ctyp
      | ty -> super#ctyp ty
    method get_type_defs = type_defs
  end
class type traversal
  =
  object 
    inherit FanAst.map
    method get_cur_module_types : FSig.module_types
    method get_cur_and_types : FSig.and_types
    method update_cur_and_types : (FSig.and_types -> FSig.and_types) -> unit
    method update_cur_module_types :
      (FSig.module_types -> FSig.module_types) -> unit
  end
let traversal () =
  (object (self : 'self_type)
     inherit  FanAst.map as super
     val module_types_stack = (Stack.create () : module_types Stack.t )
     val mutable cur_and_types = ([] : and_types )
     val mutable and_group = false
     method get_cur_module_types : module_types= Stack.top module_types_stack
     method update_cur_module_types f =
       let open Stack in push (f (pop module_types_stack)) module_types_stack
     method private in_module = Stack.push [] module_types_stack
     method private out_module = (Stack.pop module_types_stack) |> ignore
     method private in_and_types = and_group <- true; cur_and_types <- []
     method private out_and_types = and_group <- false; cur_and_types <- []
     method private is_in_and_types = and_group
     method get_cur_and_types = cur_and_types
     method update_cur_and_types f = cur_and_types <- f cur_and_types
     method! module_expr =
       function
       | `MeStr (_loc,u) ->
           (self#in_module;
            (let res = self#str_item u in
             let module_types = List.rev self#get_cur_module_types in
             if print_collect_module_types.contents
             then eprintf "@[%a@]@." FSig.pp_print_module_types module_types
             else ();
             (let result =
                Hashtbl.fold
                  (fun _  { activate; position; transform; filter }  acc  ->
                     let module_types =
                       match filter with
                       | Some x -> apply_filter x module_types
                       | None  -> module_types in
                     if activate
                     then
                       let code = transform module_types in
                       match position with
                       | Some x ->
                           let (name,f) = Filters.make_filter (x, code) in
                           (AstFilters.register_str_item_filter (name, f);
                            AstFilters.use_implem_filter name;
                            acc)
                       | None  -> `StSem (_loc, acc, code)
                     else acc) filters
                  (if keep.contents then res else `StNil _loc) in
              self#out_module; `MeStr (_loc, result))))
       | x -> super#module_expr x
     method! str_item =
       function
       | `StTyp (_loc,`TyAnd (_,_,_)) as x ->
           (self#in_and_types;
            (let _ = super#str_item x in
             self#update_cur_module_types
               (fun lst  -> (`Mutual (List.rev self#get_cur_and_types)) ::
                  lst);
             self#out_and_types;
             if keep.contents then x else `StNil _loc))
       | `StTyp (_loc,(`TyDcl (_,name,_,_,_) as t)) as x ->
           let item = `Single (name, t) in
           (eprintf "Came across @[%a@]@." FSig.pp_print_types item;
            self#update_cur_module_types (fun lst  -> item :: lst);
            x)
       | `StVal (_loc,`ReNil,_)|`StMty (_loc,_,_)|`StInc (_loc,_)|`StExt
                                                                    (_loc,_,_,_)|
           `StExp (_loc,_)|`StExc (_loc,_,`ONone)|`StDir (_loc,_,_) as x -> x
       | x -> super#str_item x
     method! ctyp =
       function
       | `TyDcl (_,name,_,_,_) as t ->
           (if self#is_in_and_types
            then self#update_cur_and_types (fun lst  -> (name, t) :: lst)
            else ();
            t)
       | t -> super#ctyp t
   end : traversal )
let g = Gram.create_gram ()
let fan_quot = Gram.mk_dynamic g "fan_quot"
let fan_quots = Gram.mk_dynamic g "fan_quots"
let _ =
  Gram.extend (fan_quot : 'fan_quot Gram.t )
    (None,
      [(None, None,
         [([`Skeyword "<+";
           `Stoken
             (((function | `STR (_,_) -> true | _ -> false)),
               (`Normal, "`STR (_,_)"))],
            (Gram.mk_action
               (fun (__fan_1 : [> FanToken.t])  _  (_loc : FanLoc.t)  ->
                  match __fan_1 with
                  | `STR (_,plugin) ->
                      ((plugin_add plugin; `ExNil _loc) : 'fan_quot )
                  | _ -> assert false)));
         ([`Skeyword "<++";
          `Slist1sep
            ((Gram.srules fan_quot
                [([`Stoken
                     (((function | `STR (_,_) -> true | _ -> false)),
                       (`Normal, "`STR (_,_)"))],
                   (Gram.mk_action
                      (fun (__fan_0 : [> FanToken.t])  (_loc : FanLoc.t)  ->
                         match __fan_0 with
                         | `STR (_,x) -> (x : 'e__1 )
                         | _ -> assert false)))]), (`Skeyword ","))],
           (Gram.mk_action
              (fun (plugins : 'e__1 list)  _  (_loc : FanLoc.t)  ->
                 (List.iter plugin_add plugins; `ExNil _loc : 'fan_quot ))));
         ([`Skeyword "clear"],
           (Gram.mk_action
              (fun _  (_loc : FanLoc.t)  ->
                 (Hashtbl.iter (fun _  v  -> v.activate <- false) filters;
                  `ExNil _loc : 'fan_quot ))));
         ([`Skeyword "<--";
          `Slist1sep
            ((Gram.srules fan_quot
                [([`Stoken
                     (((function | `STR (_,_) -> true | _ -> false)),
                       (`Normal, "`STR (_,_)"))],
                   (Gram.mk_action
                      (fun (__fan_0 : [> FanToken.t])  (_loc : FanLoc.t)  ->
                         match __fan_0 with
                         | `STR (_,x) -> (x : 'e__2 )
                         | _ -> assert false)))]), (`Skeyword ","))],
           (Gram.mk_action
              (fun (plugins : 'e__2 list)  _  (_loc : FanLoc.t)  ->
                 (List.iter plugin_remove plugins; `ExNil _loc : 'fan_quot ))));
         ([`Skeyword "keep"; `Skeyword "on"],
           (Gram.mk_action
              (fun _  _  (_loc : FanLoc.t)  ->
                 (keep := true; `ExNil _loc : 'fan_quot ))));
         ([`Skeyword "keep"; `Skeyword "off"],
           (Gram.mk_action
              (fun _  _  (_loc : FanLoc.t)  ->
                 (keep := false; `ExNil _loc : 'fan_quot ))));
         ([`Skeyword "show_code"; `Skeyword "on"],
           (Gram.mk_action
              (fun _  _  (_loc : FanLoc.t)  ->
                 (show_code := true; `ExNil _loc : 'fan_quot ))));
         ([`Skeyword "show_code"; `Skeyword "off"],
           (Gram.mk_action
              (fun _  _  (_loc : FanLoc.t)  ->
                 (show_code := false; `ExNil _loc : 'fan_quot ))))])]);
  Gram.extend (fan_quots : 'fan_quots Gram.t )
    (None,
      [(None, None,
         [([`Slist0
              (Gram.srules fan_quots
                 [([`Snterm (Gram.obj (fan_quot : 'fan_quot Gram.t ));
                   `Skeyword ";"],
                    (Gram.mk_action
                       (fun _  (x : 'fan_quot)  (_loc : FanLoc.t)  ->
                          (x : 'e__3 ))))])],
            (Gram.mk_action
               (fun (xs : 'e__3 list)  (_loc : FanLoc.t)  ->
                  (`ExSeq (_loc, (Ast.exSem_of_list xs)) : 'fan_quots ))))])])
let _ =
  PreCast.Syntax.Options.add
    ("-keep", (FanArg.Set keep), "Keep the included type definitions");
  PreCast.Syntax.Options.add
    ("-loaded-plugins", (FanArg.Unit show_modules), "Show plugins")