module Ast = FanAst
open LibUtil
open Format
open Basic
open FSig
let rec to_var_list =
  function
  | `TyApp (_loc,t1,t2) -> (to_var_list t1) @ (to_var_list t2)
  | `TyQuo (_loc,s) -> [s]
  | _ -> assert false
let list_of_opt ot acc =
  match ot with | `TyNil _loc -> acc | t -> Ast.list_of_ctyp t acc
let rec name_tags =
  function
  | `TyApp (_loc,t1,t2) -> (name_tags t1) @ (name_tags t2)
  | `TyVrn (_loc,s) -> [s]
  | _ -> assert false
let rec to_generalized =
  function
  | `TyArr (_loc,t1,t2) ->
      let (tl,rt) = to_generalized t2 in ((t1 :: tl), rt)
  | t -> ([], t)
let to_string =
  ref
    (fun _  ->
       failwith "Ctyp.to_string foward declaration, not implemented yet")
let eprint: (Ast.ctyp -> unit) ref =
  ref
    (fun _  -> failwith "Ctyp.eprint foward declaration, not implemented yet")
let _loc = FanLoc.ghost
let app a b = `TyApp (_loc, a, b)
let comma a b = `TyCom (_loc, a, b)
let (<$) = app
let rec apply acc = function | [] -> acc | x::xs -> apply (app acc x) xs
let sem a b =
  let _loc = FanLoc.merge (Ast.loc_of_ctyp a) (Ast.loc_of_ctyp b) in
  `TySem (_loc, a, b)
let list_of_app ty =
  let rec loop t acc =
    match t with
    | `TyApp (_loc,t1,t2) -> loop t1 (t2 :: acc)
    | `TyNil _loc -> acc
    | i -> i :: acc in
  loop ty []
let list_of_com ty =
  let rec loop t acc =
    match t with
    | `TyCom (_loc,t1,t2) -> t1 :: (loop t2 acc)
    | `TyNil _loc -> acc
    | i -> i :: acc in
  loop ty []
let list_of_sem ty =
  let rec loop t acc =
    match t with
    | `TySem (_loc,t1,t2) -> t1 :: (loop t2 acc)
    | `TyNil _loc -> acc
    | i -> i :: acc in
  loop ty []
let rec view_app acc =
  function | `TyApp (_loc,f,a) -> view_app (a :: acc) f | f -> (f, acc)
let app_of_list = function | [] -> `TyNil _loc | l -> List.reduce_left app l
let com_of_list =
  function | [] -> `TyNil _loc | l -> List.reduce_right comma l
let sem_of_list = function | [] -> `TyNil _loc | l -> List.reduce_right sem l
let tuple_of_list =
  function
  | [] -> invalid_arg "tuple_of_list while list is empty"
  | x::[] -> x
  | xs -> `TyTup (_loc, (com_of_list xs))
let arrow a b = `TyArr (_loc, a, b)
let (|->) = arrow
let sta a b = `TySta (_loc, a, b)
let sta_of_list = List.reduce_right sta
let arrow_of_list = List.reduce_right arrow
let app_arrow lst acc = List.fold_right arrow lst acc
let tuple_sta_of_list =
  function
  | [] -> invalid_arg "tuple_sta__of_list while list is empty"
  | x::[] -> x
  | xs -> `TyTup (_loc, (sta_of_list xs))
let (<+) names ty =
  List.fold_right
    (fun name  acc  -> `TyArr (_loc, (`TyQuo (_loc, name)), acc)) names ty
let (+>) params base = List.fold_right arrow params base
let name_length_of_tydcl =
  function
  | `TyDcl (_,name,tyvars,_,_) -> (name, (List.length tyvars))
  | tydcl ->
      invalid_arg
        ((sprintf "name_length_of_tydcl {|%s|}\n") &
           (to_string.contents tydcl))
let gen_quantifiers ~arity  n =
  ((List.init arity
      (fun i  -> List.init n (fun j  -> `TyQuo (_loc, (allx ~off:i j)))))
     |> List.concat)
    |> app_of_list
let of_id_len ~off  (id,len) =
  apply (`TyId (_loc, id))
    (List.init len (fun i  -> `TyQuo (_loc, (allx ~off i))))
let of_name_len ~off  (name,len) =
  let id = `IdLid (_loc, name) in of_id_len ~off (id, len)
let ty_name_of_tydcl =
  function
  | `TyDcl (_,name,tyvars,_,_) ->
      apply (`TyId (_loc, (`IdLid (_loc, name)))) tyvars
  | tydcl ->
      invalid_arg &
        ((sprintf "ctyp_of_tydcl{|%s|}\n") & (to_string.contents tydcl))
let gen_ty_of_tydcl ~off  tydcl =
  (tydcl |> name_length_of_tydcl) |> (of_name_len ~off)
let list_of_record ty =
  try
    (ty |> list_of_sem) |>
      (List.map
         (function
          | `TyCol (_loc,`TyId (_,`IdLid (_,label)),`TyMut (_,ctyp)) ->
              { label; ctyp; is_mutable = true }
          | `TyCol (_loc,`TyId (_,`IdLid (_,label)),ctyp) ->
              { label; ctyp; is_mutable = false }
          | t0 -> raise & (Unhandled t0)))
  with
  | Unhandled t0 ->
      invalid_arg &
        (sprintf "list_of_record inner: {|%s|} outer: {|%s|}"
           (to_string.contents t0) (to_string.contents ty))
let gen_tuple_n ty n = (List.init n (fun _  -> ty)) |> tuple_sta_of_list
let repeat_arrow_n ty n = (List.init n (fun _  -> ty)) |> arrow_of_list
let mk_method_type ~number  ~prefix  (id,len) (k : obj_dest) =
  let prefix =
    List.map (fun s  -> String.drop_while (fun c  -> c = '_') s) prefix in
  let app_src =
    app_arrow (List.init number (fun _  -> of_id_len ~off:0 (id, len))) in
  let result_type = `TyQuo (_loc, "result")
  and self_type = `TyQuo (_loc, "self_type") in
  let (quant,dst) =
    match k with
    | Obj (Map ) -> (2, (of_id_len ~off:1 (id, len)))
    | Obj (Iter ) -> (1, result_type)
    | Obj (Fold ) -> (1, self_type)
    | Str_item  -> (1, result_type) in
  let params =
    List.init len
      (fun i  ->
         let app_src =
           app_arrow
             (List.init number (fun _  -> `TyQuo (_loc, (allx ~off:0 i)))) in
         match k with
         | Obj u ->
             let dst =
               match u with
               | Map  -> `TyQuo (_loc, (allx ~off:1 i))
               | Iter  -> result_type
               | Fold  -> self_type in
             self_type |-> (prefix <+ (app_src dst))
         | Str_item  -> prefix <+ (app_src result_type)) in
  let base = prefix <+ (app_src dst) in
  if len = 0
  then base
  else
    (let quantifiers = gen_quantifiers ~arity:quant len in
     `TyPol (_loc, quantifiers, (params +> base)))
let mk_method_type_of_name ~number  ~prefix  (name,len) (k : obj_dest) =
  let id = `IdLid (_loc, name) in mk_method_type ~number ~prefix (id, len) k
let mk_obj class_name base body =
  `StCls
    (_loc,
      (`CeEq
         (_loc,
           (`CeCon (_loc, `ViNil, (`IdLid (_loc, class_name)), (`TyNil _loc))),
           (`CeStr
              (_loc,
                (`PaTyc
                   (_loc, (`PaId (_loc, (`IdLid (_loc, "self")))),
                     (`TyQuo (_loc, "self_type")))),
                (`CrSem
                   (_loc,
                     (`CrInh
                        (_loc, `OvNil,
                          (`CeCon
                             (_loc, `ViNil, (`IdLid (_loc, base)),
                               (`TyNil _loc))), "")), body)))))))
let is_recursive ty_dcl =
  match ty_dcl with
  | `TyDcl (_,name,_,ctyp,_) ->
      let obj =
        object (self : 'self_type)
          inherit  FanAst.fold as super
          val mutable is_recursive = false
          method! ctyp =
            function
            | `TyId (_loc,`IdLid (_,i)) when i = name ->
                (is_recursive <- true; self)
            | x -> if is_recursive then self else super#ctyp x
          method is_recursive = is_recursive
        end in
      (obj#ctyp ctyp)#is_recursive
  | `TyAnd (_loc,_,_) -> true
  | _ ->
      invalid_arg
        ("is_recursive not type declartion" ^ (to_string.contents ty_dcl))
let qualified_app_list =
  function
  | `TyApp (_loc,_,_) as x ->
      (match list_of_app x with
       | (`TyId (_loc,`IdLid (_,_)))::_ -> None
       | (`TyId (_loc,i))::ys -> Some (i, ys)
       | _ -> None)
  | `TyId (_loc,`IdLid (_,_))|`TyId (_loc,`IdUid (_,_)) -> None
  | `TyId (_loc,i) -> Some (i, [])
  | _ -> None
let is_abstract =
  function | `TyDcl (_,_,_,`TyNil _loc,_) -> true | _ -> false
let abstract_list =
  function
  | `TyDcl (_,_,lst,`TyNil _loc,_) -> Some (List.length lst)
  | _ -> None
let eq t1 t2 =
  let strip_locs t = (FanAst.map_loc (fun _  -> FanLoc.ghost))#ctyp t in
  (strip_locs t1) = (strip_locs t2)
let eq_list t1 t2 =
  let rec loop =
    function
    | ([],[]) -> true
    | (x::xs,y::ys) -> (eq x y) && (loop (xs, ys))
    | (_,_) -> false in
  loop (t1, t2)
let mk_transform_type_eq () =
  object (self : 'self_type)
    val transformers = Hashtbl.create 50
    inherit  FanAst.map as super
    method! str_item =
      function
      | `StTyp (_loc,`TyDcl (_,_name,vars,ctyp,_)) as x ->
          (match qualified_app_list ctyp with
           | Some (i,lst) ->
               if not (eq_list vars lst)
               then super#str_item x
               else
                 (let src = i and dest = Ident.map_to_string i in
                  Hashtbl.replace transformers dest (src, (List.length lst));
                  `StNil _loc)
           | None  -> super#str_item x)
      | x -> super#str_item x
    method! ctyp x =
      match qualified_app_list x with
      | Some (i,lst) ->
          let lst = List.map (fun ctyp  -> self#ctyp ctyp) lst in
          let src = i and dest = Ident.map_to_string i in
          (Hashtbl.replace transformers dest (src, (List.length lst));
           app_of_list ((`TyId (_loc, (`IdLid (_loc, dest)))) :: lst))
      | None  ->
          (match x with
           | `TyMan (_loc,x,ctyp) -> `TyMan (_loc, x, (super#ctyp ctyp))
           | _ -> super#ctyp x)
    method type_transformers =
      Hashtbl.fold (fun dest  (src,len)  acc  -> (dest, src, len) :: acc)
        transformers []
  end
let transform_module_types lst =
  let obj = mk_transform_type_eq () in
  let item1 =
    List.map
      (function
       | `Mutual ls ->
           `Mutual (List.map (fun (s,ty)  -> (s, (obj#ctyp ty))) ls)
       | `Single (s,ty) -> `Single (s, (obj#ctyp ty))) lst in
  let new_types = obj#type_transformers in (new_types, item1)
let reduce_data_ctors (ty : Ast.ctyp) (init : 'a)
  (f : string -> Ast.ctyp list -> 'e) =
  let open ErrorMonad in
    let rec loop acc t =
      match t with
      | `TyOf (_loc,`TyId (_,`IdUid (_,cons)),tys) ->
          f cons (Ast.list_of_ctyp tys []) acc
      | `TyOf (_loc,`TyVrn (_,cons),tys) ->
          f ("`" ^ cons) (Ast.list_of_ctyp tys []) acc
      | `TyId (_loc,`IdUid (_,cons)) -> f cons [] acc
      | `TyVrn (_loc,cons) -> f ("`" ^ cons) [] acc
      | `TyOr (_loc,t1,t2) -> loop (loop acc t1) t2
      | `TySum (_loc,ty)|`TyVrnEq (_loc,ty)|`TyVrnInf (_loc,ty)|`TyVrnSup
                                                                  (_loc,ty)
          -> loop acc ty
      | `TyNil _loc -> acc
      | t -> raise (Unhandled t) in
    try return & (loop init ty)
    with
    | Unhandled t0 ->
        fail
          (sprintf "reduce_data_ctors inner {|%s|} outer {|%s|}"
             (to_string.contents t0) (to_string.contents ty))
let of_str_item =
  function | `StTyp (_loc,x) -> x | _ -> invalid_arg "Ctyp.of_str_item"