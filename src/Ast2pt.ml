

(*
  Dump the FanAst to Parsetree, this file should
  introduce minimal dependency or only dependent on those generated files
 *)  
open Parsetree;
open Longident;
open Asttypes;
open LibUtil;
open FanUtil;
open ParsetreeHelper;
open FanLoc;
open FanOps;
open AstLoc;
open FanObjs;
DEFINE ANT_ERROR = error _loc "antiquotation not expected here";


(*
  {[
  
  ]}
 *)
let rec normalize_acc = with ident fun
  [ {| $i1.$i2 |} ->
    {:expr| $(normalize_acc i1).$(normalize_acc i2) |}
  | {| ($i1 $i2) |} ->
      {:expr| $(normalize_acc i1) $(normalize_acc i2) |}
  | {| $anti:_ |} | {@_loc| $uid:_ |} |
    {@_loc| $lid:_ |} as i -> {:expr| $id:i |} ];

(*
  The input is either {|$_.$_|} or {|$(id:{:ident| $_.$_|})|}
  the type of return value and [acc] is
  [(loc* string list * expr) list]

  The [string list] is generally a module path, the [expr] is the last field

  Examples:

  {[
  sep_dot_expr [] {|A.B.g.U.E.h.i|};
  - : (loc * string list * expr) list =
  [(, ["A"; "B"], ExId (, Lid (, "g")));
  (, ["U"; "E"], ExId (, Lid (, "h"))); (, [], ExId (, Lid (, "i")))]

  sep_dot_expr [] {|A.B.g.i|};
  - : (loc * string list * expr) list =
  [(, ["A"; "B"], ExId (, Lid (, "g"))); (, [], ExId (, Lid (, "i")))]

  sep_dot_expr [] {|$(uid:"").i|};
  - : (loc * string list * expr) list =
  [(, [""], ExId (, Lid (, "i")))]

  ]}
 *)

let rec sep_dot_expr acc = with expr fun
  [ {| $e1.$e2|} ->
    sep_dot_expr (sep_dot_expr acc e2) e1
  | {@loc| $uid:s |} as e ->
      match acc with
      [ [] -> [(loc, [], e)]
      | [(loc', sl, e) :: l] -> [(FanLoc.merge loc loc', [s :: sl], e) :: l] ]
  | {| $(id:({:ident@_l| $_.$_ |} as i)) |} ->
      sep_dot_expr acc (normalize_acc i)
  | e -> [(loc_of e, [], e) :: acc] ];

let mkvirtual : virtual_flag  -> Asttypes.virtual_flag = fun 
  [ `Virtual _ -> Virtual
  | `ViNil _  -> Concrete
  | `Ant (_loc,_) -> ANT_ERROR ];

let mkdirection : direction_flag -> Asttypes.direction_flag = fun
  [ `To _ -> Upto
  | `Downto _ -> Downto
  | `Ant (_loc,_) -> ANT_ERROR ];

let mkrf : rec_flag -> Asttypes.rec_flag = fun
  [ `Recursive _  -> Recursive
  | `ReNil _  -> Nonrecursive
  | `Ant(_loc,_) -> ANT_ERROR ];


(*
  val ident_tag: ident -> Longident.t * [> `app | `lident | `uident ]
  {[
  ident_tag {:ident| $(uid:"").B.t|}
  - : Longident.t * [> `app | `lident | `uident ] =
  (Longident.Ldot (Longident.Lident "B", "t"), `lident)

  ident_tag {:ident| A B |}
  (Longident.Lapply (Longident.Lident "A", Longident.Lident "B"), `app)

  ident_tag {:ident| (A B).t|}
  (Longident.Ldot
  (Longident.Lapply (Longident.Lident "A", Longident.Lident "B"), "t"),
  `lident)

  ident_tag {:ident| B.C |}
  (Longident.Ldot (Longident.Lident "B", "C"), `uident)

  ident_tag {:ident| B.u.g|}
  Exception: FanLoc.Exc_located (, Failure "invalid long identifier").

  ]}

  If "", just remove it, this behavior should appear in other identifier as well FIXME
 *)
let ident_tag (i:ident) =
  let rec self i acc = with ident 
    match i with
    [ {| $(lid:"*predef*").$(lid:"option") |} ->
      (Some ((ldot (lident "*predef*") "option"), `lident))
    | {| $i1.$i2 |} ->
        self i2 (self i1 acc) (* take care of the order *)
    | {| ($i1 $i2) |} -> match ((self i1 None), (self i2 None),acc) with
        (* FIXME uid required here, more precise *)
        [ (Some (l,_),Some (r,_),None) ->
          Some(Lapply l r,`app)
        | _ -> errorf (loc_of i) "invalid long identifer %s" (dump_ident i) ]
    | {| $uid:s |} ->
        match (acc,s) with
        [ (None,"") -> None 
        | (None,s) -> Some (lident s ,`uident) 
        | (Some (_, `uident | `app) ,"") -> acc
        | (Some (x, `uident | `app), s) -> Some (ldot x s, `uident)
        | _ ->
            errorf (loc_of i) "invalid long identifier %s"
              (dump_ident i)]
    | {| $lid:s |} ->
          let x = match acc with
            [ None -> lident s 
            | Some (acc, `uident | `app) -> ldot acc s
            | _ ->
                errorf (loc_of i) "invalid long identifier %s" (dump_ident i) ] in
          Some (x, `lident)
    | `Ant(_,_) -> error (loc_of i) "invalid long identifier" ]  in
  match self i None  with
    [Some x -> x | None -> error (loc_of i) "invalid long identifier "];

let ident_noloc i = fst (ident_tag  i);

let ident (i:ident) : Location.loc Longident.t  =
  with_loc (ident_noloc  i) (loc_of i);

let long_lident ~err id =
    match ident_tag id with
    [ (i, `lident) -> i +> (loc_of id)
    | _ -> error (loc_of id) err ];

let long_type_ident :ident -> Location.loc Longident.t =
  long_lident ~err:"invalid long identifier type";
let long_class_ident = long_lident ~err:"invalid class name";

let long_uident_noloc  i =
    match ident_tag i with
    [ (Ldot (i, s), `uident) -> ldot i s
    | (Lident s, `uident) -> lident s
    | (i, `app) -> i
    | _ -> error (loc_of i) "uppercase identifier expected" ];

let long_uident  i =
   long_uident_noloc  i +> loc_of i;

let rec ctyp_long_id_prefix (t:ctyp) : Longident.t =
  match t with
  [`Id(_loc,i) -> ident_noloc i
  | `App(_loc,m1,m2) ->
      let li1 = ctyp_long_id_prefix m1 in
      let li2 = ctyp_long_id_prefix m2 in
      Lapply li1 li2
  | t -> errorf (loc_of t) "invalid module expression %s" (dump_ctyp t) ] ;

let ctyp_long_id (t:ctyp) : (bool *  Location.loc Longident.t) =
  match t with
  [  `Id(_loc,i) -> (false, long_type_ident i)
  | `ClassPath (_, i) -> (true, ident i)
  | t -> errorf (loc_of t) "invalid type %s" (dump_ctyp t) ] ;

let predef_option loc =
  `Id (loc, `Dot (loc, `Lid (loc, "*predef*"), `Lid (loc, "option")));

let rec ctyp (x:ctyp) = match x with 
  [`Id(_loc,i)-> let li = long_type_ident i in
    mktyp _loc (Ptyp_constr li [])
  | `Alias(_loc,t1,`Lid(_,s)) -> 
      mktyp _loc (Ptyp_alias (ctyp t1) s)
  | `Any _loc -> mktyp _loc Ptyp_any
  | `App (_loc, _, _) as f ->
      let (f, al) =view_app [] f in
      let (is_cls, li) = ctyp_long_id f in
      if is_cls then mktyp _loc (Ptyp_class li (List.map ctyp al) [])
      else mktyp _loc (Ptyp_constr li (List.map ctyp al))
  | `Arrow (loc, (`Label (_,  `Lid(_,lab), t1)), t2) ->
      mktyp loc (Ptyp_arrow (lab, (ctyp t1), (ctyp t2)))
  | `Arrow (loc, (`OptLabl (loc1, `Lid(_,lab), t1)), t2) ->
      let t1 = `App loc1 (predef_option loc1) t1 in
      mktyp loc (Ptyp_arrow ("?" ^ lab) (ctyp t1) (ctyp t2))
  | `Arrow (loc, t1, t2) -> mktyp loc (Ptyp_arrow "" (ctyp t1) (ctyp t2))
  | `TyObj(_loc,fl,row) ->
      let xs  = match row with
      [`RvNil _ -> []
      | `RowVar _  -> [mkfield _loc Pfield_var]
      | `Ant _ -> ANT_ERROR]  in
      mktyp _loc (Ptyp_object (meth_list fl xs))
        
  | `ClassPath (loc, id) -> mktyp loc (Ptyp_class (ident id) [] [])
  | `Package(_loc,pt) ->
      let (i, cs) = package_type pt in
      mktyp _loc (Ptyp_package i cs)
  | `TyPol (loc, t1, t2) ->
      let rec to_var_list  =
        function
          [ `App (_loc,t1,t2) -> (to_var_list t1) @ (to_var_list t2)
          | `Quote (_loc,`Normal _, `Lid (_,s))
          |`Quote (_loc,`Positive _, `Lid (_,s))
          |`Quote (_loc,`Negative _, `Lid (_,s)) -> [s]
          | _ -> assert false] in 
      mktyp loc (Ptyp_poly (to_var_list t1) (ctyp t2))
  (* QuoteAny should not appear here? *)      
  | `Quote (_loc,`Normal _, `Lid(_,s)) -> mktyp _loc (Ptyp_var s)
  (* | `Quote (_loc, `Normal _, `Some (`Lid (_,s))) -> mktyp _loc (Ptyp_var s) *)
  | `Tup(loc,`Sta(_,t1,t2)) ->
      mktyp loc (Ptyp_tuple (List.map ctyp (list_of_star' t1 (list_of_star' t2 []))))
  | `PolyEq(_loc,t) ->
      mktyp _loc (Ptyp_variant (row_field t []) true None)
  | `PolySup(_loc,t) ->
      mktyp _loc (Ptyp_variant (row_field t []) false None)
  | `PolyInf(_loc,t) ->
      mktyp _loc (Ptyp_variant (row_field t []) true (Some []))
  | `PolyInfSup(_loc,t,t') ->
      let rec name_tags (x:tag_names) =
        match x with 
        [ `App(_,t1,t2) -> name_tags t1 @ name_tags t2
        | `TyVrn (_, `C (_,s))    -> [s]
        | _ -> assert false ] in 
      mktyp _loc (Ptyp_variant (row_field t []) true (Some (name_tags t')))
  |  x -> errorf (loc_of x) "ctyp: %s" (dump_ctyp x) ]
and row_field (x:row_field) acc =
  match x with 
  [`Nil _loc  -> []
  | `TyVrn (_loc,`C(_,i)) -> [Rtag i true [] :: acc]
  (* | `TyOfAmp (_loc,`TyVrn(_,`C(_,i)),t) -> *)
  (*       [Rtag i true (List.map ctyp (list_of_amp' t [])) :: acc ] *)
  (* | `Of(_loc,`TyVrn(_,`C(_,i)),t) -> *)
  (*     [Rtag i false (List.map ctyp (list_of_amp' t [])) :: acc ] *)
  | `TyVrnOf(_loc,`C(_,i),t) ->
      [Rtag i false [ctyp t] :: acc ]
      (* [Rtag i false (List.map ctyp (list_of_amp' t [])) :: acc ] *)
  | `Or(_loc,t1,t2) -> row_field t1 ( row_field t2 acc)
  | `Ant(_loc,_) -> ANT_ERROR
  | `Ctyp(_,t) -> [Rinherit (ctyp t) :: acc]
  | t -> errorf (loc_of t) "row_field: %s" (dump_row_field t)]
and meth_list (fl:name_ctyp) (acc: list core_field_type) : list core_field_type = match fl with
  [`Nil _-> acc
  | `Sem (_loc,t1,t2)
    -> meth_list t1 (meth_list t2 acc)
  | `TyCol(_loc,`Id(_,`Lid(_,lab)),t) ->
      [mkfield _loc (Pfield lab (mkpolytype (ctyp t))) :: acc]
  | x -> errorf (loc_of x) "meth_list: %s" (dump_name_ctyp x )]
    
and package_type_constraints (wc:with_constr)
    (acc: list (Asttypes.loc Longident.t  *core_type))
    : list (Asttypes.loc Longident.t  *core_type) =  match wc with
    [`Nil _ -> acc
    | `TypeEq(_loc,`Id(_,id),ct) -> [(ident id, ctyp ct) :: acc]
    | `And(_loc,wc1,wc2) ->
        package_type_constraints wc1 (package_type_constraints wc2 acc)
    | x -> errorf (loc_of x) "unexpected `with constraint:%s' for a package type"
          (dump_with_constr x) ]

and package_type (x : module_type) = match x with 
    [`With(_loc,`Id(_,i),wc) ->
      (long_uident i, package_type_constraints wc [])
    | `Id(_loc,i) -> (long_uident i, [])
    | mt -> errorf (loc_of mt)
          "unexpected package type: %s"
          (dump_module_type mt)] ;

let mktype loc tl cl ~type_kind ~priv ~manifest =
  let (params, variance) = List.split tl in
  {ptype_params = params;
   ptype_cstrs = cl;
   ptype_kind = type_kind;
   ptype_private = priv;
   ptype_manifest = manifest;
   ptype_loc =  loc;
   ptype_variance = variance} ;
  
let mkprivate' m = if m then Private else Public;

let mkprivate =  fun
  [ `Private _ -> Private
  | `PrNil _ -> Public
  | `Ant(_loc,_)-> ANT_ERROR ];

let mktrecord (x: name_ctyp)= match x with 
  [`TyColMut(_loc,`Id(_,`Lid(sloc,s)),t) ->
    (with_loc s sloc, Mutable, mkpolytype (ctyp t),  _loc)
  | `TyCol(_loc,`Id(_,`Lid(sloc,s)),t) ->
      (with_loc s sloc, Immutable, mkpolytype (ctyp t),  _loc)
  | t -> errorf (loc_of t) "mktrecord %s "
        (dump_name_ctyp t)];
  
let mkvariant (x:or_ctyp) = 
  match x with
  [`Id(_loc,`Uid(sloc,s)) ->
    (with_loc  s sloc, [], None,  _loc)
  | `Of(_loc,`Id(_,`Uid(sloc,s)),t) ->
      (with_loc  s sloc, List.map ctyp (list_of_star' t []), None,  _loc)
  | `TyCol(_loc,`Id(_,`Uid(sloc,s)),`Arrow(_,t,u)) -> (*GADT*)
      (with_loc s sloc, List.map ctyp (list_of_star' t []), Some (ctyp u),  _loc)
  | `TyCol(_loc,`Id(_,`Uid(sloc,s)),t) ->
      (with_loc  s sloc, [], Some (ctyp t),  _loc)
  | t -> errorf (loc_of t) "mkvariant %s " (dump_or_ctyp t) ];

  
(* let rec type_decl (tl: list (option (Asttypes.loc string) * (bool * bool))) *)
(*     (cl: list (core_type * core_type * Location.t)) *)
(*     loc m pflag (x: ctyp) = *)
(*   match x with  *)
(*   [`TyMan(_loc,p1,t1,p2,t2) -> *)
(*     type_decl tl cl loc (Some (ctyp t1)) p1(\* pflag *\) t2 *)

(*   | `Priv(_loc,t) -> *)
(*       if pflag then *)
(*         error _loc "multiple private keyword used, use only one instead" *)
(*       else *)
(*         type_decl tl cl loc m true t *)
(*   | `Record (_loc,t) -> *)
(*       mktype loc tl cl *)
(*         (Ptype_record (List.map mktrecord (list_of_sem' t []))) (mkprivate' pflag) m *)
(*   | `Sum(_loc,t) -> *)
(*       mktype loc tl cl *)
(*         (Ptype_variant (List.map mkvariant (list_of_or' t []))) (mkprivate' pflag) m *)
(*   | t -> *)
(*       if m <> None then *)
(*         errorf loc "only one manifest type allowed by definition %s" *)
(*           (dump_ctyp t) *)
(*       else *)
(*         let m = *)
(*           match t with *)
(*           [`Nil _loc  -> None *)
(*           | _ -> Some (ctyp t) ] in *)
(*         mktype loc tl cl Ptype_abstract (mkprivate' pflag) m ] ; *)

let type_kind (x:type_repr) =
  match x with
  [`Record (_loc,t) ->
    (Ptype_record (List.map mktrecord (list_of_sem' t [])))
  | `Sum(_loc,t) ->
      (Ptype_variant (List.map mkvariant (list_of_or' t [])))
  | `Ant(_loc,_) -> ANT_ERROR
  | `Nil _loc -> failwithf "type_kind nil"
  ];
    
let type_decl tl cl loc (x:type_info) =
  match x with
  [`TyMan(_,t1,p,t2) ->
    mktype loc tl cl
      ~type_kind:(type_kind t2) ~priv:(mkprivate p) ~manifest:(Some (ctyp t1))
  | `TyRepr (_,p1,repr) ->
      mktype loc tl cl
        ~type_kind:(type_kind repr)
        ~priv:(mkprivate p1) ~manifest:None
  | `TyEq (_loc,p1,t1) ->
      mktype loc tl cl ~type_kind:(Ptype_abstract) ~priv:(mkprivate p1)
        ~manifest:(Some (ctyp t1 ))
  | `Ant (_loc,_) -> ANT_ERROR
  | `Nil _ ->
      mktype loc tl cl ~type_kind:(Ptype_abstract) ~priv:(Private)
        ~manifest:None ];
    
(* return a [type_declaration]*)      
(* let type_decl tl cl t loc : Parsetree.type_declaration = *)
(*   type_decl tl cl loc false t; *)

let mkvalue_desc loc t p =
  {pval_type = ctyp t; pval_prim = p; pval_loc =  loc};

let rec list_of_meta_list =fun
  [ `LNil  -> []
  | `LCons (x, xs) -> [x :: list_of_meta_list xs]
  | `Ant (_loc,_) -> ANT_ERROR ];

let mkmutable = fun
  [`Mutable _ -> Mutable
  | `MuNil _ -> Immutable
  | `Ant(_loc,_) -> ANT_ERROR ];

let paolab (lab:string) (p:patt) : string =
  match (lab, p) with
  [ ("", (* {| $lid:i |} *)
     (`Id(_loc,`Lid(_,i)) | `Constraint(_loc,`Id(_,`Lid(_,i)),_)))
        (* | {| ($lid:i : $_) |} *) -> i
  | ("", p) ->
      errorf (loc_of p) "paolab %s" (dump_patt p)

  | _ -> lab ] ;


let quote_map (x:ctyp) =
  match x with
  [`Quote (_loc,p,`Lid(sloc,s)) ->
    let tuple = match p with
    [`Positive _ -> (true,false)
    |`Negative _ -> (false,true)
    |`Normal _ -> (false,false)
    |`Ant (_loc,_) -> ANT_ERROR ] in
    (Some (s+>sloc),tuple)
    (* let s = *)
    (* match s with *)
    (* [`None  -> None *)
    (* |`Some (`Lid (sloc,s)) -> Some (s+>sloc) *)
    (* |`Some (`Ant(_loc,_)) *)
    (* |`Ant (_loc,_) -> ANT_ERROR] in *)
    (* (s,tuple) *)
  |`QuoteAny(_loc,p) ->
    let tuple = match p with
      [`Positive _ -> (true,false)
      |`Negative _ -> (false,true)
      |`Normal _ -> (false,false)
      |`Ant (_loc,_) -> ANT_ERROR ] in
      (None,tuple)
  | t ->
      errorf (loc_of x) "quote_map %s" (dump_ctyp t)]  ;
    
let optional_type_parameters (t:ctyp) = 
  List.map quote_map (list_of_app' t [])(* (FanAst.list_of_ctyp_app t []) *) ;

(* ['a,'b,'c']*)
let  class_parameters (t:type_parameters) =
  List.filter_map
    (fun
      [`Nil _ -> None
      | `Ctyp(_, x) ->
          match quote_map x with
          [(Some x,v) -> Some (x,v)
          | (None,_) ->
              errorf (loc_of t) "class_parameters %s" (dump_type_parameters t)]
      | _ ->  errorf (loc_of t) "class_parameters %s" (dump_type_parameters t) ])
    (list_of_com t []);


let type_parameters_and_type_name t (* acc *) =
  let rec aux t acc = 
  match t with
  [ (* {:ctyp| $t1 $t2 |} *)
    `App(_loc,t1,t2) ->
    aux t1 (optional_type_parameters t2 @ acc)
  | (* {:ctyp| $id:i |} *)
    `Id(_loc,i)
    -> (ident i, acc)
  | x ->
      errorf (loc_of x) "type_parameters_and_type_name %s"
        (dump_ctyp x) ] in aux t [];

  
  
let rec patt_fa al = fun
  [ `App (_,f,a) -> patt_fa [a :: al] f
  | f -> (f, al) ];

let rec deep_mkrangepat loc c1 c2 =
  if c1 = c2 then mkghpat loc (Ppat_constant (Const_char c1))
  else
    mkghpat loc
      (Ppat_or (mkghpat loc (Ppat_constant (Const_char c1)))
         (deep_mkrangepat loc (Char.chr (Char.code c1 + 1)) c2));

let rec mkrangepat loc c1 c2 =
  if c1 > c2 then mkrangepat loc c2 c1
  else if c1 = c2 then mkpat loc (Ppat_constant (Const_char c1))
  else
    mkpat loc
      (Ppat_or (mkghpat loc (Ppat_constant (Const_char c1)))
         (deep_mkrangepat loc (Char.chr (Char.code c1 + 1)) c2));

let rec patt (x:patt) =
  with patt  match x with 
  [ {| $(lid:("true"|"false" as txt)) |}  ->
    let p = Ppat_construct ({txt=Lident txt;loc=_loc}) None false in
    mkpat _loc p 
  | {| $(id:{:ident@sloc| $lid:s |}) |} -> mkpat _loc (Ppat_var (with_loc s sloc))
  | {| $id:i |} ->
      let p = Ppat_construct (long_uident  i) None false 
      in mkpat _loc p
  | (* {| ($p1 as $p2) |} *) `Alias (_loc, p1, x)->
      match x with
      [`Lid (sloc,s) -> mkpat _loc (Ppat_alias ((patt p1), with_loc s sloc))
      | `Ant (_loc,_) -> error _loc "invalid antiquotations"]  
  | `Ant (loc,_) -> error loc "antiquotation not allowed here"
  | {| _ |} -> mkpat _loc Ppat_any
  | {| $(id:{:ident@sloc| $uid:s |}) $(tup:{@loc_any| _ |}) |} ->
      mkpat _loc (Ppat_construct (lident_with_loc  s sloc)
                   (Some (mkpat loc_any Ppat_any)) false)
  | `App (loc, _, _) as f ->
     let (f, al) = patt_fa [] f in
     let al = List.map patt al in
     match (patt f).ppat_desc with
     [ Ppat_construct (li, None, _) ->
         let a =  match al with
         [ [a] -> a
         | _ -> mkpat loc (Ppat_tuple al) ] in
         mkpat loc (Ppat_construct li (Some a) false)
     | Ppat_variant (s, None) ->
         let a =
             match al with
             [ [a] -> a
             | _ -> mkpat loc (Ppat_tuple al) ] in
         mkpat loc (Ppat_variant s (Some a))
     | _ ->
         error (loc_of f)
           "this is not a constructor, it cannot be applied in a pattern" ]
     | `Array (loc,p) -> mkpat loc (Ppat_array (List.map patt (list_of_sem' p []))) (* precise*)
     | `Chr (loc,s) ->
         mkpat loc (Ppat_constant (Const_char (char_of_char_token loc s)))
     | `Int (loc,s) ->
         let i = try int_of_string s with [
           Failure _ -> error loc "Integer literal exceeds the range of representable integers of type int"
         ] in mkpat loc (Ppat_constant (Const_int i))
     | `Int32 (loc, s) ->
         let i32 = try Int32.of_string s with [
           Failure _ -> error loc "Integer literal exceeds the range of representable integers of type int32"
         ] in mkpat loc (Ppat_constant (Const_int32 i32))
     | `Int64 (loc, s) ->
         let i64 = try Int64.of_string s with [
           Failure _ -> error loc "Integer literal exceeds the range of representable integers of type int64"
         ] in mkpat loc (Ppat_constant (Const_int64 i64))
     | `NativeInt (loc,s) ->
         let nati = try Nativeint.of_string s with [
           Failure _ -> error loc "Integer literal exceeds the range of representable integers of type nativeint"
         ] in mkpat loc (Ppat_constant (Const_nativeint nati))
     | `Flo (loc,s) -> mkpat loc (Ppat_constant (Const_float (remove_underscores s)))
     | `Label (loc,_,_) -> error loc "labeled pattern not allowed here"
     (* | `PaOlb (loc, _, _) *) | `PaOlbi (loc,_,_,_) -> error loc "labeled pattern not allowed here"
     | `Or (loc, p1, p2) -> mkpat loc (Ppat_or (patt p1) (patt p2))
     | `PaRng (loc, p1, p2) ->
         match (p1, p2) with
         [ (`Chr (loc1, c1), `Chr (loc2, c2)) ->
           let c1 = char_of_char_token loc1 c1 in
            let c2 = char_of_char_token loc2 c2 in
           mkrangepat loc c1 c2
         | _ -> error loc "range pattern allowed only for characters" ]
         | `Record (loc,p) ->
             let ps = list_of_sem' p [] in (* precise*)
             let is_wildcard = fun [ {| _ |} -> true | _ -> false ] in
             let (wildcards,ps) = List.partition is_wildcard ps in
             let is_closed = if wildcards = [] then Closed else Open in
             mkpat loc (Ppat_record (List.map mklabpat ps, is_closed))
         | `Str (loc,s) ->
             mkpat loc (Ppat_constant (Const_string (string_of_string_token loc s)))
         | {@loc| ($p1, $p2) |} ->
             mkpat loc (Ppat_tuple
                          (List.map patt (list_of_com' p1 (list_of_com' p2 []))))
         | {@loc| ($tup:_) |} -> error loc "singleton tuple pattern"
         | `Constraint (loc,p,t) -> mkpat loc (Ppat_constraint (patt p) (ctyp t))
         | `ClassPath (loc,i) -> mkpat loc (Ppat_type (long_type_ident i))
         | `Vrn (loc,s) -> mkpat loc (Ppat_variant s None)
         | `Lazy (loc,p) -> mkpat loc (Ppat_lazy (patt p))
         | `ModuleUnpack (loc,m,ty) ->
             match m with
             [`Uid(sloc,m) ->
               match ty with
               [`None  ->
                 mkpat loc (Ppat_unpack (with_loc m sloc))
               |`Some (ty) ->
                   mkpat loc
                     (Ppat_constraint
                        (mkpat sloc (Ppat_unpack (with_loc m sloc)))
                        (ctyp ty))
               |`Ant(_loc,_) -> ANT_ERROR]  
             |`Ant(_loc,_) -> ANT_ERROR]  
         (* | `RecBind (_, _, _)  *)| `Sem (_, _, _) | `Com (_, _, _) | `Nil _ as p ->
             error (loc_of p) "invalid pattern" ]

and mklabpat : rec_patt -> (Asttypes.loc Longident.t  * pattern) = with patt fun
  [ `RecBind(_loc,i,p)(* {| $i = $p |} *) -> (ident  i, patt p)
  | p -> error (loc_of p) "invalid pattern" ];
  


let override_flag loc = with override_flag fun
  [ {| ! |} -> Override
  | {||} -> Fresh
  |  _ -> error loc "antiquotation not allowed here" ];

  


(*
  {[
  expr (`Id (_loc, ( (`Dot (_loc, `Uid (_loc, "U"), `Lid(_loc,"g"))) )));;
  - : Parsetree.expression =
  {Parsetree.pexp_desc =
  Parsetree.Pexp_ident
  {Asttypes.txt = Longident.Ldot (Longident.Lident "U", "g"); loc = };
  pexp_loc = }

  expr {:expr| $(uid:"A").b |} ; ;       
  - : Parsetree.expression =
  {Parsetree.pexp_desc =
  Parsetree.Pexp_ident
  {Asttypes.txt = Longident.Ldot (Longident.Lident "A", "b"); loc = };
  pexp_loc = }
  Ast2pt.expr {:expr| $(uid:"").b |} ; 
  - : Parsetree.expression =
  {Parsetree.pexp_desc =
  Parsetree.Pexp_ident
  {Asttypes.txt = Longident.Ldot (Longident.Lident "", "b"); loc = };
  pexp_loc = }
  ]}
 *)
let rec expr (x : expr) = with expr match x with 
  [ `Dot(_loc,_,_)|
    `Id(_loc,`Dot _ ) ->
      let (e, l) =
        match sep_dot_expr [] x with
        [ [(loc, ml, `Id(sloc,`Uid(_,s))) :: l] ->
          (mkexp loc (Pexp_construct (mkli sloc  s ml) None false(* ca *)), l)
        | [(loc, ml, `Id(sloc,`Lid(_,s))) :: l] ->
            (mkexp loc (Pexp_ident (mkli sloc s ml)), l)
        | [(_, [], e) :: l] -> (expr e, l)
        | _ -> errorf (loc_of x) "expr: %s" (dump_expr x) ] in
      let (_, e) =
        List.fold_left
          (fun (loc_bp, e1) (loc_ep, ml, e2) ->
            match e2 with
            [ `Id(sloc,`Lid(_,s)) ->
                let loc = FanLoc.merge loc_bp loc_ep in
                (loc, mkexp loc (Pexp_field e1 (mkli sloc s ml)))
            | _ -> error (loc_of e2) "lowercase identifier expected" ])
          (_loc, e) l in
      e
  | `App (loc, _, _) as f ->
      let (f, al) = view_app [] f in
      let al = List.map label_expr al in
      match (expr f).pexp_desc with
      [ Pexp_construct (li, None, _) ->
        let al = List.map snd al in
          let a = match al with
          [ [a] -> a
          | _ -> mkexp loc (Pexp_tuple al) ] in
          mkexp loc (Pexp_construct li (Some a) false)
      | Pexp_variant (s, None) ->
          let al = List.map snd al in
          let a =
              match al with
              [ [a] -> a
              | _ -> mkexp loc (Pexp_tuple al) ]
          in mkexp loc (Pexp_variant s (Some a))
      | _ -> mkexp loc (Pexp_apply (expr f) al) ]
  | `ArrayDot (loc, e1, e2) ->
      mkexp loc
        (Pexp_apply (mkexp loc (Pexp_ident (array_function loc "Array" "get")))
           [("", expr e1); ("", expr e2)])
  | `Array (loc,e) -> mkexp loc
        (Pexp_array
           (List.map expr (list_of_sem' e []))) (* be more precise*)
  | `ExAsr (loc,e) -> mkexp loc (Pexp_assert (expr e))
  | `ExAsf loc -> mkexp loc Pexp_assertfalse
  | (* {:expr| $e :=  $v|} *) (* FIXME refine to differentiate *)
    `Assign (loc,e,v) ->
      let e =
        match e with
        [ {@loc| $x.contents |} -> (* FIXME *)
          Pexp_apply (mkexp loc (Pexp_ident (lident_with_loc ":=" loc)))
            [("", expr x); ("", expr v)]
        | `Dot (loc,_,_) ->
            match (expr e).pexp_desc with
            [ Pexp_field (e, lab) -> Pexp_setfield e lab (expr v)
            | _ -> error loc "bad record access" ]
            | `ArrayDot (loc, e1, e2) ->
                Pexp_apply (mkexp loc (Pexp_ident (array_function loc "Array" "set")))
                  [("", expr e1); ("", expr e2); ("", expr v)]
            | `Id(_,`Lid(lloc,lab))  ->
                Pexp_setinstvar (with_loc lab lloc) (expr v)
            | `StringDot (loc, e1, e2) ->
                Pexp_apply
                  (mkexp loc (Pexp_ident (array_function loc "String" "set")))
                  [("", expr e1); ("", expr e2); ("", expr v)]
            | x -> errorf loc "bad left part of assignment:%s" (dump_expr x) ] in
      mkexp loc e
  | `Chr (loc,s) ->
      mkexp loc (Pexp_constant (Const_char (char_of_char_token loc s)))
  | `Coercion (loc, e, t1, t2) ->
      let t1 = match t1 with
        [ `Nil _ -> None
        | t -> Some (ctyp t) ] in
      mkexp loc (Pexp_constraint (expr e) t1 (Some (ctyp t2)))
  | `Flo (loc,s) -> mkexp loc (Pexp_constant (Const_float (remove_underscores s)))
  | `For (loc, `Lid(sloc,i), e1, e2, df, el) ->
        let e3 = `Seq loc el in
        mkexp loc (Pexp_for (with_loc i sloc)
                     (expr e1) (expr e2) (mkdirection df) (expr e3))
  |  {@loc|fun [ ~$lid:lab : $po when $w -> $e ] |} -> 
         mkexp loc
           (Pexp_function lab None
              [(patt_of_lab loc lab po, when_expr e w)])
  | {@loc| fun [ ?$lid:lab :($p  = $opt:e1) when $w -> $e2  ] |} -> 
      match e1 with
      [`None  ->
        let lab = paolab lab p in
        mkexp loc
          (Pexp_function ("?" ^ lab) None [(patt_of_lab loc lab p, when_expr e2 w)])
      |`Some (e1) ->
          let lab = paolab lab p in
          mkexp loc
            (Pexp_function ("?" ^ lab) (Some (expr e1)) [(patt p, when_expr e2 w)])
      |`Ant(_loc,_) -> ANT_ERROR]
  | `Fun (loc,a) -> mkexp loc (Pexp_function "" None (match_case a ))
  | `IfThenElse (loc, e1, e2, e3) ->
      mkexp loc (Pexp_ifthenelse (expr e1) (expr e2) (Some (expr e3)))
  | `IfThen (loc,e1,e2) ->
      mkexp loc (Pexp_ifthenelse (expr e1) (expr e2) None)
  | `Int (loc,s) ->
      let i = try int_of_string s with [
        Failure _ -> error loc "Integer literal exceeds the range of representable integers of type int"
      ] in
      mkexp loc (Pexp_constant (Const_int i))
  | `Int32 (loc, s) ->
      let i32 = try Int32.of_string s with [
        Failure _ -> error loc "Integer literal exceeds the range of representable integers of type int32"
      ] in mkexp loc (Pexp_constant (Const_int32 i32))
  | `Int64 (loc, s) ->
      let i64 = try Int64.of_string s with [
        Failure _ -> error loc "Integer literal exceeds the range of representable integers of type int64"
      ] in mkexp loc (Pexp_constant (Const_int64 i64))
  | `NativeInt (loc,s) ->
      let nati = try Nativeint.of_string s with [
        Failure _ -> error loc "Integer literal exceeds the range of representable integers of type nativeint"
      ] in mkexp loc (Pexp_constant (Const_nativeint nati))
  | `Any (_loc) -> errorf _loc "Any should not appear in the position of expression"
  | `Label (loc,_,_) -> error loc "labeled expression not allowed here"
  | `Lazy (loc,e) -> mkexp loc (Pexp_lazy (expr e))
  | `LetIn (loc,rf,bi,e) ->
      mkexp loc (Pexp_let (mkrf rf) (binding bi []) (expr e))
  | `LetModule (loc,`Uid(sloc,i),me,e) ->
         mkexp loc (Pexp_letmodule (with_loc i sloc) (module_expr me) (expr e))
  | `Match (loc,e,a) -> mkexp loc (Pexp_match (expr e) (match_case a (* [] *)))
  | `New (loc,id) -> mkexp loc (Pexp_new (long_type_ident id))
  | `Obj (loc,po,cfl) ->
      let p =
         match po with
         [ `Nil _loc  -> `Any _loc 
         | p -> p ] in
       let cil = class_str_item cfl [] in
       mkexp loc (Pexp_object { pcstr_pat = patt p; pcstr_fields = cil })
  | `OvrInst (loc,iel) -> mkexp loc (Pexp_override (mkideexp iel []))
  | `Record (loc,lel) ->
       match lel with
       [ `Nil _  -> error loc "empty record"
       | _ -> mkexp loc (Pexp_record (mklabexp lel) None) ]
  | `RecordWith(loc,lel,eo) ->
      match lel with
      [`Nil _ -> error loc "empty record"
      | _ -> mkexp loc (Pexp_record (mklabexp lel) (Some (expr eo)))]  
  | `Seq (_loc,e) ->
      let rec loop = fun
        [ [] -> expr {| () |}
        | [e] -> expr e
        | [e :: el] ->
            let _loc = FanLoc.merge (loc_of e) _loc in
            mkexp _loc (Pexp_sequence (expr e) (loop el)) ] in
      loop (list_of_sem' e []) 
  | `Send (loc,e,`Lid(_,s)) -> mkexp loc (Pexp_send (expr e) s)
        
  | `StringDot (loc, e1, e2) ->
      mkexp loc
        (Pexp_apply (mkexp loc (Pexp_ident (array_function loc "String" "get")))
           [("", expr e1); ("", expr e2)])
  | `Str (loc,s) ->
      mkexp loc (Pexp_constant (Const_string (string_of_string_token loc s)))
  | `Try (loc,e,a) -> mkexp loc (Pexp_try (expr e) (match_case a (* [] *)))
  | `Tup (loc,e) ->
      let l = list_of_com' e [] in
      match l with
      [ [] | [_] -> errorf loc "tuple should have at least two items" (dump_expr x)
      | _ -> 
          mkexp loc (Pexp_tuple (List.map expr l))]
   | `Constraint (loc,e,t) -> mkexp loc (Pexp_constraint (expr e) (Some (ctyp t)) None)
   | {| () |} ->
       mkexp _loc (Pexp_construct (lident_with_loc "()" _loc) None true)
   | `Id(_loc,`Lid(_,("true"|"false" as s))) -> 
       mkexp _loc (Pexp_construct (lident_with_loc s _loc) None true)
   | `Id(_,`Lid(_loc,s)) ->
       mkexp _loc (Pexp_ident (lident_with_loc s _loc))
   | `Id(_,`Uid(_loc,s)) ->
       mkexp _loc (Pexp_construct (lident_with_loc  s _loc) None true)
   | `Vrn (loc,s) -> mkexp loc (Pexp_variant  s None)
   | `While (loc, e1, el) ->
       let e2 = `Seq loc el in
       mkexp loc (Pexp_while (expr e1) (expr e2))
   | `LetOpen(_loc,i,e) ->
       mkexp _loc (Pexp_open (long_uident i) (expr e))
   | `Package_expr (_loc,`Constraint(_,me,pt)) -> 
       mkexp _loc
         (Pexp_constraint
            (mkexp _loc (Pexp_pack (module_expr me)),
             Some (mktyp _loc (Ptyp_package (package_type pt))), None))
   | `Package_expr(loc,me) -> 
       mkexp loc (Pexp_pack (module_expr me))
   | `LocalTypeFun (loc,`Lid(_,i),e) -> mkexp loc (Pexp_newtype i (expr e))
   | x -> errorf (loc_of x ) "expr:%s" (dump_expr x) ]
and patt_of_lab _loc lab (x:patt)= match x with 
  [ `Nil _  -> patt (`Id(_loc,`Lid(_loc,lab)))
  | p -> patt p ]
and expr_of_lab _loc lab (x:expr) = match x with
  [ `Nil _  -> expr (`Id(_loc,`Lid(_loc,lab)))
  | e -> expr e ]
and label_expr (x : expr) = match x with 
  [ `Label (loc,`Lid(_,lab),eo) ->
      (lab, expr_of_lab loc lab eo)
  | `OptLabl (loc,`Lid(_,lab),eo) -> ("?" ^ lab, expr_of_lab loc lab eo)
  | e -> ("", expr e) ]
and binding (x:binding) acc =  match x with
  [ `And(_,x,y) ->
    binding x (binding y acc)
  | {:binding@_loc| $(pat: {:patt@sloc| $lid:bind_name |} ) =
    ($e : $(`TyTypePol (_, vs, ty))) |} ->

      let rec id_to_string x = match x with
        [  `Id(_loc,`Lid(_,x)) -> [x]
        | `App(_loc,x,y) -> (id_to_string x) @ (id_to_string y)
        | x -> errorf (loc_of x) "id_to_string %s" (dump_ctyp x)]   in
      let vars = id_to_string vs in
      let ampersand_vars = List.map (fun x -> "&" ^ x) vars in
      let ty' = varify_constructors vars (ctyp ty) in
      let mkexp = mkexp _loc in
      let mkpat = mkpat _loc in
      let e = mkexp (Pexp_constraint (expr e) (Some (ctyp ty)) None) in
      let rec mk_newtypes x =
        match x with
        [ [newtype :: []] -> mkexp (Pexp_newtype(newtype, e))
        | [newtype :: newtypes] ->
            mkexp(Pexp_newtype (newtype,mk_newtypes newtypes))
        | [] -> assert false] in
      let pat =
        mkpat (Ppat_constraint
                 (mkpat (Ppat_var (with_loc bind_name sloc)),
                  mktyp _loc (Ptyp_poly ampersand_vars ty'))) in
      let e = mk_newtypes vars in
      [( pat, e) :: acc]
  | {:binding@_loc| $p = ($e : ! $vs . $ty) |} ->
      [(patt {:patt| ($p : ! $vs . $ty ) |}, expr e) :: acc]
  | `Bind (_,p,e) -> [(patt p, expr e) :: acc]
  | `Nil _  -> acc
  | _ -> assert false ]
and match_case (x:match_case) = 
  let cases = list_of_or' x [] in
  with match_case 
  List.filter_map
    (fun
      [`Nil _ -> None
      | `Case(_,p,w,e) -> Some (patt p, when_expr e w)
      | x -> errorf (loc_of x ) "match_case %s" (dump_match_case x ) ]) cases
and when_expr (e:expr) (w:expr) : expression  =
  match w with 
  [ `Nil _ -> expr e
  | w -> mkexp (loc_of w) (Pexp_when (expr w) (expr e)) ]

and mklabexp (x:rec_expr)  =
  let bindings = list_of_sem x [] in
  with rec_expr 
  List.filter_map
    (fun
      [ `Nil _ -> None
      | `RecBind(_,i,e) ->  Some (ident i, expr e)
      |  x ->errorf (loc_of x) "mklabexp : %s" (dump_rec_expr x) ]) bindings
and mkideexp (x:rec_expr)
    (acc: list (Asttypes.loc string * expression)) :
    list (Asttypes.loc string * expression) = 
  with rec_expr match x with 
  [ `Nil _ -> acc
  | `Sem(_,x,y) ->  mkideexp x (mkideexp y acc)
  | `RecBind(_,`Lid(sloc,s),e) ->
      [(with_loc s sloc, expr e) :: acc]
  | _ -> assert false ]

(* Example:
   {[
   (Lib.Ctyp.of_str_item {:str_item|type u = int and v  = [A of u and b ] |})
     ||> mktype_decl |> AstPrint.default#type_def_list f;
   type u = int 
   and v =  
   | A of u* b
   ]}
   
 *)    
and mktype_decl (x:typedecl)  =
  let tys = list_of_and x [] in
  List.map
    (fun 
      [`TyDcl (cloc,`Lid(sloc,c),tl,td,cl) ->
        let cl = List.map
            (fun (t1,t2) ->
              let loc = t1 <+> t2 in 
              (ctyp t1, ctyp t2, loc)) cl in
        (c+>sloc,
         type_decl
           (List.fold_right (fun x acc -> optional_type_parameters x @ acc) tl [])
           cl cloc td )
      | (t:typedecl) ->
          errorf (loc_of t) "mktype_decl %s" (dump_typedecl t)]) tys
and module_type : Ast.module_type -> Parsetree.module_type =
  let  mkwithc (wc:with_constr)  =
    let mkwithtyp pwith_type loc priv id_tpl ct =
      let (id, tpl) = type_parameters_and_type_name id_tpl in
      let (params, variance) = List.split tpl in
      (id, pwith_type
         {ptype_params = params; ptype_cstrs = [];
          ptype_kind =  Ptype_abstract;
          ptype_private = priv;
          ptype_manifest = Some (ctyp ct);
          ptype_loc =  loc; ptype_variance = variance}) in
    let constrs = list_of_and' wc [] in
    List.filter_map (fun 
      [`TypeEq(_loc,id_tpl,ct) ->
          Some (mkwithtyp (fun x -> Pwith_type x) _loc Public id_tpl ct)
      |`TypeEqPriv(_loc,id_tpl,ct) ->
          Some (mkwithtyp (fun x -> Pwith_type x) _loc Private id_tpl ct)
      | `ModuleEq(_loc,i1,i2) ->
          Some (long_uident i1, Pwith_module (long_uident i2))
      | `TypeSubst(_loc,id_tpl,ct) ->
          Some (mkwithtyp (fun x -> Pwith_typesubst x) _loc Public id_tpl ct )
      | `ModuleSubst(_loc,i1,i2) ->
          Some (long_uident i1, Pwith_modsubst (long_uident i2))
      | t -> errorf (loc_of t) "bad with constraint (antiquotation) : %s" (dump_with_constr t)]) constrs in
     with module_type fun 
     [ `Id(loc,i) -> mkmty loc (Pmty_ident (long_uident i))
     | `MtFun(loc,`Uid(sloc,n),nt,mt) ->
             mkmty loc (Pmty_functor (with_loc n sloc) (module_type nt) (module_type mt))
     | `Sig(loc,sl) ->
         mkmty loc (Pmty_signature (sig_item sl []))
     | `With(loc,mt,wc) ->
         mkmty loc (Pmty_with (module_type mt) (mkwithc wc ))
     | `ModuleTypeOf(_loc,me) ->
         mkmty _loc (Pmty_typeof (module_expr me))
     | t -> errorf (loc_of t) "module_type: %s" (dump_module_type t) ]
and sig_item (s:sig_item) (l:signature) :signature =
  with sig_item match s with 
  [ `Nil _  -> l
  | `Class (loc,cd) ->
      [mksig loc (Psig_class
                    (List.map class_info_class_type (list_of_and' cd []))) :: l]
  | `ClassType (loc,ctd) ->
      [mksig loc (Psig_class_type
                    (List.map class_info_class_type (list_of_and' ctd []))) :: l]
  | `Sem(_,sg1,sg2) -> sig_item sg1 (sig_item sg2 l)
  | `Directive (_,_,_) -> l
  | `Exception(_loc,`Id(_,`Uid(_,s))) ->
      [mksig _loc (Psig_exception (with_loc s _loc) []) :: l]
  | `Exception(_loc,`Of(_,`Id(_,`Uid(sloc,s)),t)) ->
      [mksig _loc (Psig_exception (with_loc s sloc)
                    (List.map ctyp (list_of_star' t []))) :: l]
  | `Exception (_,_) -> assert false (*FIXME*)
  | `External (loc, `Lid(sloc,n), t, sl) ->
      [mksig loc (Psig_value (with_loc n sloc)
                    (mkvalue_desc loc t (list_of_meta_list sl))) :: l]
  | `Include (loc,mt) -> [mksig loc (Psig_include (module_type mt)) :: l]
  | `Module (loc,`Uid(sloc,n),mt) ->
        [mksig loc (Psig_module (with_loc n sloc) (module_type mt)) :: l]
  | `RecModule (loc,mb) ->
      [mksig loc (Psig_recmodule (module_sig_binding mb [])) :: l]
  | `ModuleType (loc,`Uid(sloc,n),mt) ->
      let si =  match mt with
      [ `Nil _ -> Pmodtype_abstract
      | _ -> Pmodtype_manifest (module_type mt) ] in
      [mksig loc (Psig_modtype (with_loc n sloc) si) :: l]
  | `Open (loc,id) ->
      [mksig loc (Psig_open (long_uident id)) :: l]
  | `Type (loc,tdl) -> [mksig loc (Psig_type (mktype_decl tdl )) :: l]
  | `Val (loc,`Lid(sloc,n),t) ->
          [mksig loc (Psig_value (with_loc n sloc) (mkvalue_desc loc t [])) :: l]
  | t -> errorf (loc_of t) "sig_item: %s" (dump_sig_item t)]
and module_sig_binding (x:module_binding) 
        (acc: list (Asttypes.loc string * Parsetree.module_type))  =
    with module_binding match x with 
  [ `And(_,x,y) ->
    module_sig_binding x (module_sig_binding y acc)
  | `Constraint(_loc,`Uid(sloc,s),mt) ->
      [(with_loc s sloc, module_type mt) :: acc]
  | t -> errorf (loc_of t) "module_sig_binding: %s" (dump_module_binding t) ]
and module_str_binding (x:Ast.module_binding) acc =
    match x with 
  [ `And(_,x,y) ->
      module_str_binding x (module_str_binding y acc)
  | `ModuleBind(_loc,`Uid(sloc,s),mt,me)->
        [(with_loc s sloc, module_type mt, module_expr me) :: acc]
  | t -> errorf (loc_of t) "module_str_binding: %s" (dump_module_binding t)]
and module_expr (x:Ast.module_expr)=
  match x with 
  [`Id(loc,i)   -> mkmod loc (Pmod_ident (long_uident i))
  | `App(loc,me1,me2) ->
      mkmod loc (Pmod_apply (module_expr me1) (module_expr me2))
  | `Functor(loc,`Uid(sloc,n),mt,me) ->
      mkmod loc (Pmod_functor (with_loc n sloc) (module_type mt) (module_expr me))
  | `Struct(loc,sl) -> mkmod loc (Pmod_structure (str_item sl []))
  | `Constraint(loc,me,mt) ->
        mkmod loc (Pmod_constraint (module_expr me) (module_type mt))
  | `PackageModule(loc,`Constraint(_,e,`Package(_,pt))) ->
      mkmod loc (Pmod_unpack (
                 mkexp loc (Pexp_constraint
                              (expr e,
                               Some (mktyp loc (Ptyp_package (package_type pt))),
                               None))))
  | `PackageModule(loc,e) ->
      mkmod loc (Pmod_unpack (expr e))
  | t -> errorf (loc_of t) "module_expr: %s" (dump_module_expr t) ]
and str_item (s:str_item) (l:structure) : structure =
  match s with 
  [ `Nil _ -> l
  | `Class (loc,cd) ->
      [mkstr loc (Pstr_class
           (List.map class_info_class_expr (list_of_and' cd []))) :: l]
  | `ClassType (loc,ctd) ->
      [mkstr loc (Pstr_class_type
                    (List.map class_info_class_type (list_of_and' ctd []))) :: l]
  | `Sem(_,st1,st2) -> str_item st1 (str_item st2 l)
  | `Directive (_,_,_) -> l
  | `Exception(loc,`Id(_,`Uid(_,s))) ->
      [mkstr loc (Pstr_exception (with_loc s loc) []) :: l ]
  | `Exception (loc, `Of (_, `Id (_, `Uid (_, s)), t))
    ->
      [mkstr loc (Pstr_exception (with_loc s loc)
                    (List.map ctyp (list_of_star' t []))) :: l ]
   (* TODO *)     
  (* | {@loc| exception $uid:s = $i |} -> *)
  (*     [mkstr loc (Pstr_exn_rebind (with_loc s loc) (ident i)) :: l ] *)
  (* | {@loc| exception $uid:_ of $_ = $_ |} -> *)
  (*     error loc "type in exception alias" *)
  | `Exception (_,_) -> assert false (*FIXME*)
  | `StExp (loc,e) -> [mkstr loc (Pstr_eval (expr e)) :: l]
  | `External(loc,`Lid(sloc,n),t,sl) ->
      [mkstr loc
         (Pstr_primitive (with_loc n sloc) (mkvalue_desc loc t (list_of_meta_list sl))) :: l]
  | `Include (loc,me) -> [mkstr loc (Pstr_include (module_expr me)) :: l]
  | `Module (loc,`Uid(sloc,n),me) ->
      [mkstr loc (Pstr_module (with_loc n sloc) (module_expr me)) :: l]
  | `RecModule (loc,mb) ->
      [mkstr loc (Pstr_recmodule (module_str_binding mb [])) :: l]
  | `ModuleType (loc,`Uid(sloc,n),mt) ->
          [mkstr loc (Pstr_modtype (with_loc n sloc) (module_type mt)) :: l]
  | `Open (loc,id) ->
      [mkstr loc (Pstr_open (long_uident id)) :: l]
  | `Type (loc,tdl) -> [mkstr loc (Pstr_type (mktype_decl tdl )) :: l]
  | `Value (loc,rf,bi) ->
      [mkstr loc (Pstr_value (mkrf rf) (binding bi [])) :: l]
  | x-> errorf (loc_of x) "str_item : %s" (dump_str_item x) ]
and class_type (x:Ast.class_type) = match x with
 [ `CtCon (loc, `ViNil _, id,tl) ->
   mkcty loc
     (Pcty_constr (long_class_ident id)
        (List.map (fun [`Ctyp (_loc,x) -> ctyp x | _ -> assert false]) (list_of_com' tl [])))
  | `CtFun (loc, (`Label (_, `Lid(_,lab), t)), ct) ->
      mkcty loc (Pcty_fun lab (ctyp t) (class_type ct))

  (* | `CtFun (loc, (`TyOlb (loc1, `Lid(_,lab), t)), ct) -> *)
  (*     let t = `App loc1 (predef_option loc1) t in *)
  (*     mkcty loc (Pcty_fun ("?" ^ lab) (ctyp t) (class_type ct)) *)
        
  | `CtFun (loc, (`OptLabl (loc1, `Lid(_,lab), t)), ct) ->
      let t = `App loc1 (predef_option loc1) t in
      mkcty loc (Pcty_fun ("?" ^ lab) (ctyp t) (class_type ct))
        
  | `CtFun (loc,t,ct) -> mkcty loc (Pcty_fun "" (ctyp t) (class_type ct))
  | `CtSig (loc,t_o,ctfl) ->
      let t = match t_o with
        [  `Nil _loc -> `Any loc
        | t -> t ] in
      let cil = class_sig_item ctfl [] in
      mkcty loc (Pcty_signature {
                 pcsig_self = ctyp t;
                 pcsig_fields = cil;
                 pcsig_loc =  loc;})
  |  x -> errorf (loc_of x) "class type: %s" (dump_class_type x) ]
    
and class_info_class_expr (ci:class_expr) =
    match ci with 
    [ `Eq (_, (`CeCon (loc, vir, (`Lid (nloc, name)), params)), ce) ->
      let (loc_params, (params, variance)) =
        match params with
        [`Nil _loc ->
          (loc, ([], []))
        | t -> (loc_of t, List.split (class_parameters t)) ]  in
      {pci_virt = mkvirtual vir;
       pci_params = (params,  loc_params);
       pci_name = with_loc name nloc;
       pci_expr = class_expr ce;
       pci_loc =  loc;
       pci_variance = variance}
  | ce -> errorf  (loc_of ce) "class_info_class_expr: %s" (dump_class_expr ce) ]
and class_info_class_type (ci:class_type) =
    match ci with 
    [ `CtEq (_, (`CtCon (loc, vir, (`Lid (nloc, name)), params)), ct)
    | `CtCol (_, (`CtCon (loc, vir, (`Lid (nloc, name)), params)), ct)
      ->
        let (loc_params, (params, variance)) =
          match params with
          [  `Nil _loc ->
            (loc, ([], []))
          | t -> (loc_of t, List.split (class_parameters t)) ] in
      {pci_virt = mkvirtual vir;
       pci_params = (params,  loc_params);
       pci_name = with_loc name nloc;
       pci_expr = class_type ct;
       pci_loc =  loc;
       pci_variance = variance}
  | ct -> errorf (loc_of ct)
        "bad class/class type declaration/definition %s " (dump_class_type ct)]
and class_sig_item (c:class_sig_item) (l: list class_type_field) : list class_type_field =
    match c with 
    [ `Nil _ -> l
    | `Eq (loc, t1, t2) ->
        [mkctf loc (Pctf_cstr (ctyp t1, ctyp t2)) :: l]
    | `Sem(_,csg1,csg2) -> class_sig_item csg1 (class_sig_item csg2 l)
    | `SigInherit (loc,ct) -> [mkctf loc (Pctf_inher (class_type ct)) :: l]
    | `Method (loc,`Lid(_,s),pf,t) ->
            [mkctf loc (Pctf_meth (s, mkprivate pf, mkpolytype (ctyp t))) :: l]
    | `CgVal (loc, `Lid(_,s), b, v, t) ->
            [mkctf loc (Pctf_val (s, mkmutable b, mkvirtual v, ctyp t)) :: l]
    | `CgVir (loc,`Lid(_,s),b,t) ->
          [mkctf loc (Pctf_virt (s, mkprivate b, mkpolytype (ctyp t))) :: l]
    | t -> errorf (loc_of t) "class_sig_item :%s" (dump_class_sig_item t) ]
and class_expr  (x:Ast.class_expr) = match x with 
  [ `CeApp (loc, _, _) as c ->
    let rec view_app al =
      function [ `CeApp (_loc,ce,a) -> view_app [a :: al] ce | ce -> (ce, al) ]in
    let (ce, el) = view_app [] c in
    let el = List.map label_expr el in
    mkcl loc (Pcl_apply (class_expr ce) el)
  | `CeCon (loc, `ViNil _, id,tl) ->
      mkcl loc
        (Pcl_constr (long_class_ident id)
           (List.map (
            fun [`Ctyp (_loc,x) -> ctyp x | _ -> assert false])
              (list_of_com' tl [])))
  | `CeFun (loc, (`Label (_,`Lid(_loc,lab), po)), ce) ->
      mkcl loc
        (Pcl_fun lab None (patt_of_lab loc lab po) (class_expr ce))
  | `CeFun (loc, (`PaOlbi (_, `Lid(_loc,lab), p, e)), ce) ->
      let lab = paolab lab p in
      match e with
      [`None  ->
        mkcl loc (Pcl_fun ("?" ^ lab) None (patt_of_lab loc lab p) (class_expr ce))
      |`Some (e) ->
          mkcl loc (Pcl_fun ("?" ^ lab) (Some (expr e)) (patt p) (class_expr ce))
      |`Ant(_loc,_) -> ANT_ERROR]  
  | `CeFun (loc,p,ce) -> mkcl loc (Pcl_fun "" None (patt p) (class_expr ce))
  | `CeLet (loc, rf, bi, ce) ->
      mkcl loc (Pcl_let (mkrf rf) (binding bi []) (class_expr ce))
  | `Obj (loc,po,cfl) ->
      let p = match po with
          [ `Nil _loc  -> `Any _loc
          | p -> p ] in
      let cil = class_str_item cfl [] in
      mkcl loc
        (Pcl_structure {
         pcstr_pat = patt p;
         pcstr_fields = cil;
       })
  | `CeTyc (loc,ce,ct) ->
      mkcl loc (Pcl_constraint (class_expr ce) (class_type ct))
  | t -> errorf (loc_of t) "class_expr: %s" (dump_class_expr t)]

and class_str_item (c:class_str_item) l =
  match c with
  [ `Nil _ -> l
  | `Eq (loc, t1, t2) -> [mkcf loc (Pcf_constr (ctyp t1, ctyp t2)) :: l]
  | `Sem(_,cst1,cst2) -> class_str_item cst1 (class_str_item cst2 l)
  | `Inherit (loc, ov, ce, pb) ->
      let opb = match pb with
      [`None  -> None
      |`Some (`Lid (_,x) ) -> Some x
      |`Some (`Ant (_loc,_))
      |`Ant (_loc,_) -> error _loc "antiquotation not allowed here"] in  
      (* let opb = if pb = "" then None else Some pb in *)
      [mkcf loc (Pcf_inher (override_flag loc ov) (class_expr ce) opb) :: l]
  | `Initializer (loc,e) -> [mkcf loc (Pcf_init (expr e)) :: l]
  | `CrMth (loc, `Lid(sloc,s), ov, pf, e, t) ->
      let t = match t with
      [`Nil _ -> None
      | t -> Some (mkpolytype (ctyp t)) ] in
      let e = mkexp loc (Pexp_poly (expr e) t) in
      [mkcf loc (Pcf_meth (with_loc s sloc, mkprivate pf, override_flag loc ov, e)) :: l]
  | `CrVal (loc, `Lid(sloc,s), ov, mf, e) ->
      [mkcf loc (Pcf_val (with_loc s sloc, mkmutable mf, override_flag loc ov, expr e)) :: l]
  | `CrVir (loc,`Lid(sloc,s),pf,t) ->
        [mkcf loc (Pcf_virt (with_loc s sloc, mkprivate pf, mkpolytype (ctyp t))) :: l]
  | `CrVvr (loc,`Lid(sloc,s),mf,t) ->
        [mkcf loc (Pcf_valvirt (with_loc s sloc, mkmutable mf, ctyp t)) :: l]
  | x  -> errorf  (loc_of  x) "class_str_item: %s" (dump_class_str_item x) ];

let sig_item (ast:sig_item) : signature = sig_item ast [];
let str_item ast = str_item ast [];

let directive (x:expr) = with expr  match x with 
  [ `Nil _ -> Pdir_none
  | `Str(_,s) -> Pdir_string s
  | `Int(_,i) -> Pdir_int (int_of_string i)
  | {| true |} -> Pdir_bool true
  | {| false |} -> Pdir_bool false
  | e -> Pdir_ident (ident_noloc (ident_of_expr e)) ] ;

let phrase (x: str_item) =
  match x with 
  [ `Directive (_, `Lid(_,d),dp) -> Ptop_dir d (directive dp)
  | `Directive (_, `Ant(_loc,_),_) -> error _loc "antiquotation not allowed"
  | si -> Ptop_def (str_item si) ];

open Format;
let pp = fprintf;  

let print_expr f  e =
  pp f "@[%a@]@." AstPrint.expression (expr e);
let to_string_expr = to_string_of_printer print_expr;  
(* let p_ident = eprintf "@[%a@]@." opr#ident ;     *)
  
let print_patt f e =
  pp f "@[%a@]@." AstPrint.pattern (patt e);
  
let print_str_item f e =
  pp f "@[%a@]@." AstPrint.structure (str_item e);

(* FIXME allow more interfaces later *)  
(* let p_ident f e = *)
(*   eprintf "@[%a@]@." Pprintast.fmt_longident (ident e) ;     *)
let print_ctyp f e =
  pp f "@[%a@]@." AstPrint.core_type (ctyp e) ;




