(* Enrich with some utility functions in Ast *)

(* #filter "fold";; *)

(* #filter "trash";; *)
module type META_LOC = sig
      (** The first location is where to put the returned pattern.
          Generally it's _loc to match with {:patt| ... |} quotations.
          The second location is the one to treat. *)
    val meta_loc_patt : FanLoc.t -> FanLoc.t -> Ast.patt;
      (** The first location is where to put the returned expression.
          Generally it's _loc to match with {:expr| ... |} quotations.
          The second location is the one to treat. *)
    val meta_loc_expr : FanLoc.t -> FanLoc.t -> Ast.expr;
end;

(* open FanUtil; *)
open LibUtil;
module Ast = struct
  include Ast;
  let safe_string_escaped s =
    if String.length s > 2 && s.[0] = '\\' && s.[1] = '$' then s
    else String.escaped s;
end;

include Ast;

(* external loc_of_ctyp : ctyp -> FanLoc.t = "%field0"; *)
(* external loc_of_patt : patt -> FanLoc.t = "%field0"; *)
(* external loc_of_expr : expr -> FanLoc.t = "%field0"; *)
(* external loc_of_module_type : module_type -> FanLoc.t = "%field0"; *)
(* external loc_of_module_expr : module_expr -> FanLoc.t = "%field0"; *)
(* external loc_of_sig_item : sig_item -> FanLoc.t = "%field0"; *)
(* external loc_of_str_item : str_item -> FanLoc.t = "%field0"; *)
(* external loc_of_class_type : class_type -> FanLoc.t = "%field0"; *)
(* external loc_of_class_sig_item : class_sig_item -> FanLoc.t = "%field0"; *)
(* external loc_of_class_expr : class_expr -> FanLoc.t = "%field0"; *)
(* external loc_of_class_str_item : class_str_item -> FanLoc.t = "%field0"; *)
(* external loc_of_with_constr : with_constr -> FanLoc.t = "%field0"; *)
(* external loc_of_binding : binding -> FanLoc.t = "%field0"; *)
(* external loc_of_rec_binding : rec_binding -> FanLoc.t = "%field0"; *)
(* external loc_of_module_binding : module_binding -> FanLoc.t = "%field0"; *)
(* external loc_of_match_case : match_case -> FanLoc.t = "%field0"; *)
(* external loc_of_ident : ident -> FanLoc.t = "%field0"; *)

let ghost = FanLoc.ghost;


(* (\* *)
(*   {[ *)
(*   is_module_longident {:ident| A.B.t |} ;  *)
(*   - : bool = false *)
(*   is_module_longident {:ident| A.B |} ;  *)
(*   - : bool = true *)
(*   ]} *)
(*  *\) *)
(* let rec is_module_longident = fun *)
(*   [ {:ident| $_.$i |} -> is_module_longident i *)
(*   | {:ident| ($i1 $i2) |} -> *)
(*       is_module_longident i1 && is_module_longident i2 *)
(*   | {:ident| $uid:_ |} -> true *)
(*   | _ -> false ]; *)

(* let ident_of_expr = *)
(*   let error () = *)
(*     invalid_arg "ident_of_expr: this expression is not an identifier" in *)
(*   let rec self =  fun *)
(*     [ {:expr@_loc| $e1 $e2 |} -> {:ident| ( $(self e1) $(self e2)) |} *)
(*     | {:expr@_loc| $e1.$e2 |} -> {:ident| $(self e1).$(self e2) |} *)
(*     | {:expr| $lid:_ |} -> error () *)
(*     | {:expr| $id:i |} -> if is_module_longident i then i else error () *)
(*     | _ -> error () ] in *)
(*   fun *)
(*     [ {:expr| $id:i |} -> i *)
(*     | {:expr| $_ $_ |} -> error () *)
(*     | t -> self t ]; *)

(* (\* *)
(*   {[ *)
(*   ident_of_ctyp {:ctyp| list int |} ; ; *)
(*   Exception: Invalid_argument "ident_of_ctyp: this type is not an identifier". *)

(*   ident_of_ctyp {:ctyp| A.B |} ; ;      *)
(*   - : ident = *)
(*   IdAcc (, IdUid (, "A"), *)
(*   IdUid (, "B")) *)

(*   {:ctyp| A.B |} ; ; *)
(*   - : ctyp = *)
(*   TyId (, IdAcc (, IdUid (, "A"), IdUid (, "B"))) *)

(*   ident_of_ctyp {:ctyp| (A B).t |} ; ; *)
(*   - : ident = *)
(*   IdAcc (, IdApp (, IdUid (, "A"), IdUid (, "B")), IdLid (, "t"))  ]} *)
(*  *\) *)
(* let ident_of_ctyp = *)
(*   let error () = *)
(*     invalid_arg "ident_of_ctyp: this type is not an identifier" in *)
(*   let rec self =   fun *)
(*     [ {:ctyp@_loc| $t1 $t2 |} -> {:ident| ( $(self t1) $(self t2) ) |} *)
(*     | {:ctyp| $lid:_ |} -> error () *)
(*     | {:ctyp| $id:i |} -> if is_module_longident i then i else error () *)
(*     | _ -> error () ] in *)
(*     fun *)
(*     [ {:ctyp| $id:i |} -> i *)
(*     | t -> self t ]; *)

(* let ident_of_patt = *)
(*   let error () = *)
(*     invalid_arg "ident_of_patt: this pattern is not an identifier" in *)
(*   let rec self = fun  *)
(*     [ {:patt@_loc| $p1 $p2 |} *)
(*       -> {:ident| ( $(self p1) $(self p2) ) |} *)
(*     | {:patt| $lid:_ |} -> error () *)
(*     | {:patt| $id:i |} -> if is_module_longident i then i else error () *)
(*     | _ -> error () ] in *)
(*     fun *)
(*     [ {:patt| $id:i |} -> i *)
(*     | p -> self p ]; *)


(* let rec is_irrefut_patt = with "patt" *)
(*     fun *)
(*     [ {| $lid:_ |} -> true *)
(*     | {| () |} -> true *)
(*     | {| _ |} -> true *)
(*     | {||} -> true (\* why not *\) *)
(*     | {| ($x as $y) |} -> is_irrefut_patt x && is_irrefut_patt y *)
(*     | {| { $p } |} -> is_irrefut_patt p *)
(*     | {| $_ = $p |} -> is_irrefut_patt p *)
(*     | {| $p1; $p2 |} -> is_irrefut_patt p1 && is_irrefut_patt p2 *)
(*     | {| $p1, $p2 |} -> is_irrefut_patt p1 && is_irrefut_patt p2 *)
(*     | {| $p1 | $p2 |} -> is_irrefut_patt p1 && is_irrefut_patt p2 (\* could be more fine grained *\) *)
(*     | {| $p1 $p2 |} -> is_irrefut_patt p1 && is_irrefut_patt p2 *)
(*     | {| ($p : $_) |} -> is_irrefut_patt p *)
(*     | {| ($tup:pl) |} -> is_irrefut_patt pl *)
(*     | {| ? $_ |} -> true *)
(*     | {| ? $_ : ($_ ) |} -> (\* is_irrefut_patt p *\) true *)
(*     | {| ? $_ : ($_ = $_) |} -> (\* is_irrefut_patt p *\) true *)
(*     | {| ~ $_ |} -> true *)
(*     | {| ~ $_ : $p |} -> is_irrefut_patt p *)
(*     | {| lazy $p |} -> is_irrefut_patt p *)
(*     | {| $id:_ |} -> false (\* here one need to know the arity of constructors *\) *)
(*     | {| (module $_) |} -> true *)
(*     | {| `$_ |} | {| $str:_ |} | {| $_ .. $_ |} | *)
(*       {| $flo:_ |} | {| $nativeint:_ |} | {| $int64:_ |} | *)
(*       {| $int32:_ |} | {| $int:_ |} | {| $chr:_ |} | *)
(*       {| #$_ |} | {| [| $_ |] |} | {| $anti:_ |} -> false *)
(*     ];       *)
      

(* let rec is_constructor =  fun *)
(*     [ {:ident| $_.$i |} -> is_constructor i *)
(*     | {:ident| $uid:_ |} -> true *)
(*     | {:ident| $lid:_ |} | {:ident| ($_ $_) |} -> false *)
(*     | {:ident| $anti:_ |} -> assert false ]; *)

(* let is_patt_constructor = fun *)
(*     [ {:patt| $id:i |} -> is_constructor i *)
(*     | {:patt| `$_ |} -> true *)
(*     | _ -> false ]; *)

(* let rec is_expr_constructor = fun *)
(*     [ {:expr| $id:i |} -> is_constructor i *)
(*     | {:expr| $e1.$e2 |} -> is_expr_constructor e1 && is_expr_constructor e2 *)
(*     | {:expr| `$_ |} -> true *)
(*     | _ -> false ]; *)


(* let rec tyOr_of_list = fun *)
(*     [ [] -> {:ctyp@ghost||} *)
(*     | [t] -> t *)
(*     | [t::ts] -> *)
(*         let _loc = loc_of_ctyp t in {:ctyp| $t | $(tyOr_of_list ts) |} ]; *)

(* let rec tyAnd_of_list = fun *)
(*     [ [] -> {:ctyp@ghost||} *)
(*     | [t] -> t *)
(*     | [t::ts] -> *)
(*         let _loc = loc_of_ctyp t in {:ctyp| $t and $(tyAnd_of_list ts) |} ]; *)

(* let rec tySem_of_list = fun *)
(*     [ [] -> {:ctyp@ghost||} *)
(*     | [t] -> t *)
(*     | [t::ts] -> *)
(*         let _loc = loc_of_ctyp t in {:ctyp| $t ; $(tySem_of_list ts) |} ]; *)

(* let rec tyCom_of_list = fun *)
(*     [ [] -> {:ctyp@ghost||} *)
(*     | [t] -> t *)
(*     | [t::ts] -> *)
(*         let _loc = loc_of_ctyp t in {:ctyp| $t, $(tyCom_of_list ts) |} ]; *)

(* let rec tyAmp_of_list =  fun *)
(*     [ [] -> {:ctyp@ghost||} *)
(*     | [t] -> t *)
(*     | [t::ts] -> *)
(*         let _loc = loc_of_ctyp t in {:ctyp| $t & $(tyAmp_of_list ts) |} ]; *)

(* let rec tySta_of_list =  fun *)
(*     [ [] -> {:ctyp@ghost||} *)
(*     | [t] -> t *)
(*     | [t::ts] -> *)
(*         let _loc = loc_of_ctyp t in {:ctyp| $t * $(tySta_of_list ts) |} ]; *)

(* (\* LA *\)   *)
(* let  tyApp_of_list = fun *)
(*     [ [] -> {:ctyp@ghost||} *)
(*     | [t] -> t *)
(*     | [t::ts] -> *)

(*         List.fold_left *)
(*           (fun x y -> let _loc = loc_of_ctyp  x in {:ctyp| $x $y |}) t ts]; *)

(*         (\* let _loc = loc_of_ctyp t in {:ctyp| $t  $(tyApp_of_list ts) |} ]; *\) *)
(* (\* LA *\) *)
(* let tyVarApp_of_list (_loc,ls)= *)
(*   let  aux = fun  *)
(*     [ [] -> {:ctyp@ghost||} *)
(*     | [t] -> {:ctyp| '$t |} *)
(*     | [t::ts] -> *)
(*         List.fold_left (fun x y -> {:ctyp| $x '$y |}) {:ctyp| '$t |} ts ] in *)
(*   aux ls; *)
  
  
(* let rec stSem_of_list = fun *)
(*     [ [] -> {:str_item@ghost||} *)
(*     | [t] -> t *)
(*     | [t::ts] -> *)
(*         let _loc = loc_of_str_item t in {:str_item| $t ; $(stSem_of_list ts) |} ]; *)
(*   (\* FIXME introduces Nil here *\)     *)
(* let rec sgSem_of_list = fun *)
(*     [ [] -> {:sig_item@ghost||} *)
(*     | [t] -> t *)
(*     | [t::ts] -> *)
(*         let _loc = loc_of_sig_item t in {:sig_item| $t ; $(sgSem_of_list ts) |} ]; *)

(* let rec biAnd_of_list =  fun *)
(*     [ [] -> {:binding@ghost||} *)
(*     | [b] -> b *)
(*     | [b::bs] -> *)
(*         let _loc = loc_of_binding b in {:binding| $b and $(biAnd_of_list bs) |} ]; *)

(* let rec rbSem_of_list =  fun *)
(*     [ [] -> {:rec_binding@ghost||} *)
(*     | [b] -> b *)
(*     | [b::bs] -> *)
(*         let _loc = loc_of_rec_binding b in *)
(*         {:rec_binding| $b; $(rbSem_of_list bs) |} ]; *)

(* let rec wcAnd_of_list = fun *)
(*     [ [] -> {:with_constr@ghost||} *)
(*     | [w] -> w *)
(*     | [w::ws] -> *)
(*         let _loc = loc_of_with_constr w in *)
(*         {:with_constr| $w and $(wcAnd_of_list ws) |} ]; *)

(* let rec idAcc_of_list = fun *)
(*     [ [] -> assert false *)
(*     | [i] -> i *)
(*     | [i::is] -> *)
(*         let _loc = loc_of_ident i in *)
(*         {:ident| $i . $(idAcc_of_list is) |} ]; *)

(* let rec idApp_of_list =  fun *)
(*     [ [] -> assert false *)
(*     | [i] -> i *)
(*     | [i::is] -> *)
(*         let _loc = loc_of_ident i in *)
(*         {:ident| ($i $(idApp_of_list is)) |} ]; *)

(* let rec mcOr_of_list = fun *)
(*     [ [] -> {:match_case@ghost||} *)
(*     | [x] -> x *)
(*     | [x::xs] -> *)
(*         let _loc = loc_of_match_case x in *)
(*         {:match_case| $x | $(mcOr_of_list xs) |} ]; *)
  

(* let rec mbAnd_of_list = fun *)
(*     [ [] -> {:module_binding@ghost||} *)
(*     | [x] -> x *)
(*     | [x::xs] -> *)
(*         let _loc = loc_of_module_binding x in *)
(*         {:module_binding| $x and $(mbAnd_of_list xs) |} ]; *)

(* let rec meApp_of_list = fun *)
(*     [ [] -> assert false *)
(*     | [x] -> x *)
(*     | [x::xs] -> *)
(*         let _loc = loc_of_module_expr x in *)
(*         {:module_expr| $x $(meApp_of_list xs) |} ]; *)

(* let rec ceAnd_of_list =  fun *)
(*     [ [] -> {:class_expr@ghost||} *)
(*     | [x] -> x *)
(*     | [x::xs] -> *)
(*         let _loc = loc_of_class_expr x in *)
(*         {:class_expr| $x and $(ceAnd_of_list xs) |} ]; *)

(* let rec ctAnd_of_list = fun *)
(*     [ [] -> {:class_type@ghost||} *)
(*     | [x] -> x *)
(*     | [x::xs] -> *)
(*         let _loc = loc_of_class_type x in *)
(*         {:class_type| $x and $(ctAnd_of_list xs) |} ]; *)

(* let rec cgSem_of_list = fun *)
(*     [ [] -> {:class_sig_item@ghost||} *)
(*     | [x] -> x *)
(*     | [x::xs] -> *)
(*         let _loc = loc_of_class_sig_item x in *)
(*         {:class_sig_item| $x; $(cgSem_of_list xs) |} ]; *)

(* let rec crSem_of_list = fun *)
(*     [ [] -> {:class_str_item@ghost||} *)
(*     | [x] -> x *)
(*     | [x::xs] -> *)
(*         let _loc = loc_of_class_str_item x in *)
(*         {:class_str_item| $x; $(crSem_of_list xs) |} ]; *)

(* let rec paSem_of_list = fun *)
(*     [ [] -> {:patt@ghost||} *)
(*     | [x] -> x *)
(*     | [x::xs] -> *)
(*         let _loc = loc_of_patt x in *)
(*         {:patt| $x; $(paSem_of_list xs) |} ]; *)

(* let rec paCom_of_list =  fun *)
(*     [ [] -> {:patt@ghost||} *)
(*     | [x] -> x *)
(*     | [x::xs] -> *)
(*         let _loc = loc_of_patt x in *)
(*         {:patt| $x, $(paCom_of_list xs) |} ]; *)

(* let rec exSem_of_list =  fun *)
(*     [ [] -> {:expr@ghost||} *)
(*     | [x] -> x *)
(*     | [x::xs] -> *)
(*         let _loc = loc_of_expr x in *)
(*         {:expr| $x; $(exSem_of_list xs) |} ]; *)

(* let rec exCom_of_list =  fun *)
(*     [ [] -> {:expr@ghost||} *)
(*     | [x] -> x *)
(*     | [x::xs] -> *)
(*         let _loc = loc_of_expr x in *)
(*         {:expr| $x, $(exCom_of_list xs) |} ]; *)
(* (\* LA *\)   *)
(* let  exApp_of_list = fun *)
(*     [ [] -> {:expr@ghost||} *)
(*     | [t] -> t *)
(*     | [t::ts] -> *)
(*         List.fold_left *)
(*           (fun x y -> let _loc = loc_of_expr  x in {:expr| $x $y |}) t ts]; *)

(* let ty_of_stl = fun *)
(*     [ (_loc, s, []) -> {:ctyp| $uid:s |} *)
(*     | (_loc, s, tl) -> {:ctyp| $uid:s of $(tyAnd_of_list tl) |} ]; *)

(* let ty_of_sbt = fun *)
(*     [ (_loc, s, true, t) -> {:ctyp| $lid:s : mutable $t |} *)
(*     | (_loc, s, false, t) -> {:ctyp| $lid:s : $t |} ]; *)

(* let bi_of_pe (p, e) = let _loc = loc_of_patt p in {:binding| $p = $e |}; *)
(* let sum_type_of_list l = tyOr_of_list (List.map ty_of_stl l); *)
(* let record_type_of_list l = tySem_of_list (List.map ty_of_sbt l); *)
(* let binding_of_pel l = biAnd_of_list (List.map bi_of_pe l); *)

(* let rec pel_of_binding =  fun *)
(*     [ {:binding| $b1 and $b2 |} -> pel_of_binding b1 @ pel_of_binding b2 *)
(*     | {:binding| $p = $e |} -> [(p, e)] *)
(*     | _ -> assert false ]; *)

(* let rec list_of_binding x acc = *)
(*     match x with *)
(*     [ {:binding| $b1 and $b2 |} -> *)
(*          list_of_binding b1 (list_of_binding b2 acc) *)
(*     | t -> [t :: acc] ]; *)

(* let rec list_of_rec_binding x acc =  match x with *)
(*     [ {:rec_binding| $b1; $b2 |} -> *)
(*          list_of_rec_binding b1 (list_of_rec_binding b2 acc) *)
(*     | t -> [t :: acc] ]; *)

(* let rec list_of_with_constr x acc = match x with *)
(*   [ {:with_constr| $w1 and $w2 |} -> *)
(*     list_of_with_constr w1 (list_of_with_constr w2 acc) *)
(*   | t -> [t :: acc] ]; *)

(* let rec list_of_ctyp x acc =  match x with *)
(*   [ {:ctyp||} -> acc *)
(*   | {:ctyp| $x & $y |} | {:ctyp| $x, $y |} | *)
(*     {:ctyp| $x * $y |} | {:ctyp| $x; $y |} | *)
(*     {:ctyp| $x and $y |} | {:ctyp| $x | $y |} -> *)
(*         list_of_ctyp x (list_of_ctyp y acc) *)
(*   | x -> [x :: acc] ]; *)

(* let rec list_of_patt x acc = match x with *)
(*   [ {:patt||} -> acc *)
(*   | {:patt| $x, $y |} | {:patt| $x; $y |} -> *)
(*         list_of_patt x (list_of_patt y acc) *)
(*   | x -> [x :: acc] ]; *)

(* let rec list_of_expr x acc =  match x with *)
(*   [ {:expr||} -> acc *)
(*   | {:expr| $x, $y |} | {:expr| $x; $y |} -> *)
(*       list_of_expr x (list_of_expr y acc) *)
(*   | x -> [x :: acc] ]; *)

(* let rec list_of_str_item x acc = match x with *)
(*   [ {:str_item||} -> acc *)
(*   | {:str_item| $x; $y |} -> *)
(*       list_of_str_item x (list_of_str_item y acc) *)
(*   | x -> [x :: acc] ]; *)

(* let rec list_of_sig_item x acc = match x with *)
(*   [ {:sig_item||} -> acc *)
(*   | {:sig_item| $x; $y |} -> *)
(*         list_of_sig_item x (list_of_sig_item y acc) *)
(*   | x -> [x :: acc] ]; *)

(* let rec list_of_class_sig_item x acc =  match x with *)
(*   [ {:class_sig_item||} -> acc *)
(*   | {:class_sig_item| $x; $y |} -> *)
(*       list_of_class_sig_item x (list_of_class_sig_item y acc) *)
(*   | x -> [x :: acc] ]; *)

(* let rec list_of_class_str_item x acc =  match x with *)
(*   [ {:class_str_item||} -> acc *)
(*   | {:class_str_item| $x; $y |} -> *)
(*       list_of_class_str_item x (list_of_class_str_item y acc) *)
(*   | x -> [x :: acc] ]; *)

(* let rec list_of_class_type x acc =  match x with *)
(*   [ {:class_type| $x and $y |} -> *)
(*     list_of_class_type x (list_of_class_type y acc) *)
(*   | x -> [x :: acc] ]; *)

(* let rec list_of_class_expr x acc = match x with *)
(*   [ {:class_expr| $x and $y |} -> *)
(*     list_of_class_expr x (list_of_class_expr y acc) *)
(*   | x -> [x :: acc] ]; *)

(* let rec list_of_module_expr x acc = match x with *)
(*   [ {:module_expr| $x $y |} -> *)
(*     list_of_module_expr x (list_of_module_expr y acc) *)
(*   | x -> [x :: acc] ]; *)

(* let rec list_of_match_case x acc =  match x with *)
(*   [ {:match_case||} -> acc *)
(*   | {:match_case| $x | $y |} -> *)
(*       list_of_match_case x (list_of_match_case y acc) *)
(*   | x -> [x :: acc] ]; *)

(* let rec list_of_ident x acc = match x with *)
(*     [ {:ident| $x . $y |} | {:ident| ($x $y) |} -> *)
(*       list_of_ident x (list_of_ident y acc) *)
(*     | x -> [x :: acc] ]; *)

(* let rec list_of_module_binding x acc = match x with *)
(*   [ {:module_binding| $x and $y |} -> *)
(*     list_of_module_binding x (list_of_module_binding y acc) *)
(*   | x -> [x :: acc] ]; *)

module Camlp4Trash = struct
    INCLUDE "src/Ast.ml";
end;

(* class map = Camlp4MapGenerator.generated; *)

(* class fold = Camlp4FoldGenerator.generated; *)

(* let map_expr f = object *)
(*   inherit FanAst.map as super; *)
(*   method! expr x = f (super#expr x); *)
(* end; *)
(* let map_patt f = object *)
(*   inherit map as super; *)
(*   method! patt x = f (super#patt x); *)
(* end; *)
(* let map_ctyp f = object *)
(*   inherit map as super; *)
(*   method! ctyp x = f (super#ctyp x); *)
(* end; *)
(* let map_str_item f = object *)
(*   inherit map as super; *)
(*   method! str_item x = f (super#str_item x); *)
(* end; *)
(* let map_sig_item f = object *)
(*   inherit map as super; *)
(*   method! sig_item x = f (super#sig_item x); *)
(* end; *)
(* let map_loc f = object *)
(*   inherit map as super; *)
(*   method! loc x = f (super#loc x); *)
(* end; *)

(* class clean_ast = object *)
    
(*   inherit map as super; *)
(*   method! with_constr wc = *)
(*     with "with_constr" *)
(*     match super#with_constr wc with *)
(*     [ {| $({@_l||})  and $wc |} | *)
(*       {| $wc and $({@_l||} ) |} -> wc *)
(*     | wc -> wc ]; *)
(*   method! expr e = *)
(*     with "expr" *)
(*     match super#expr e with *)
(*     [ {| let $rec:_ $({:binding@_l||}) in $e |} | *)
(*       {| { ($e) with $({:rec_binding@_l||})  } |} | *)
(*       {| $({@_l||} ), $e |} | *)
(*       {| $e, $({@_l||} ) |} | *)
(*       {| $({@_l||}); $e |} | *)
(*       {| $e; $({@_l||} ) |} -> e *)
(*     | e -> e ]; *)
(*   method! patt p = *)
(*     with "patt" *)
(*     match super#patt p with *)
(*     [ {| ( $p as $({@_l||} ) ) |} | *)
(*       {| $({@_l||}) | $p |} | *)
(*       {| $p | $({@_l||} ) |} | *)
(*       {| $({@_l||} ), $p |} | *)
(*       {| $p, $({@_l||} ) |} | *)
(*       {| $({@_l||} ); $p |} | *)
(*       {| $p; $({@_l||} ) |} -> p *)
(*     | p -> p ]; *)
(*   method! match_case mc = *)
(*     with "match_case" *)
(*     match super#match_case mc with *)
(*     [ {| $({@_l||} ) | $mc |} | *)
(*       {| $mc | $({@_l||} ) |} -> mc *)
(*     | mc -> mc ]; *)
(*   method! binding bi = *)
(*     with "binding" *)
(*     match super#binding bi with *)
(*     [ {| $({@_l||} ) and $bi |} | *)
(*       {| $bi and $({@_l||} ) |} -> bi *)
(*     | bi -> bi ]; *)
(*   method! rec_binding rb = *)
(*     with "rec_binding" *)
(*     match super#rec_binding rb with *)
(*     [ {| $({@_l||} ) ; $bi |} | {| $bi ; $({@_l||} ) |} -> bi *)
(*     | bi -> bi ]; *)

(*   method! module_binding mb = *)
(*     with "module_binding" *)
(*     match super#module_binding mb with *)
(*     [ {| $({@_l||} ) and $mb |} | *)
(*       {| $mb and $({@_l||} ) |} -> mb *)
(*     | mb -> mb ]; *)

(*   method! ctyp t = *)
(*     with "ctyp" *)
(*     match super#ctyp t with *)
(*     [ {| ! $({@_l||} ) . $t |} | *)
(*       {| $({@_l||} ) as $t |} | *)
(*       {| $t as $({@_l||} ) |} | *)
(*       {| $t -> $({@_l||} ) |} | *)
(*       {| $({@_l||} ) -> $t |} | *)
(*       {| $({@_l||} ) | $t |} | *)
(*       {| $t | $({@_l||} ) |} | *)
(*       {| $t of $({@_l||} ) |} | *)
(*       {| $({@_l||} ) and $t |} | *)
(*       {| $t and $({@_l||} ) |} | *)
(*       {| $t; $({@_l||} ) |} | *)
(*       {| $({@_l||} ); $t |} | *)
(*       {| $({@_l||}), $t |} | *)
(*       {| $t, $({@_l||} ) |} | *)
(*       {| $t & $({@_l||} ) |} | *)
(*       {| $({@_l||} ) & $t |} | *)
(*       {| $({@_l||} ) * $t |} | *)
(*       {| $t * $({@_l||} ) |} -> t *)
(*     | t -> t ]; *)

(*   method! sig_item sg = *)
(*     with "sig_item" *)
(*     match super#sig_item sg with *)
(*     [ {| $({@_l||}); $sg |} | {| $sg; $({@_l||} ) |} -> sg *)
(*     | {| type $({:ctyp@_l||} ) |} -> {||} *)
(*     | sg -> sg ]; *)

(*   method! str_item st = *)
(*     with "str_item" *)
(*     match super#str_item st with *)
(*     [ {| $({@_l||} ); $st |} | {| $st; $({@_l||} ) |} -> st *)
(*     | {| type $({:ctyp@_l||} ) |} -> {||} *)
(*     | {| let $rec:_ $({:binding@_l||} ) |} -> {||} *)
(*     | st -> st ]; *)

(*   method! module_type mt = *)
(*     match super#module_type mt with *)
(*     [ {:module_type| $mt with $({:with_constr@_l||} ) |} -> mt *)
(*     | mt -> mt ]; *)

(*   method! class_expr ce = *)
(*     with "class_expr" *)
(*     match super#class_expr ce with *)
(*     [ {| $({@_l||} ) and $ce |} | {| $ce and $({@_l||} ) |} -> ce *)
(*     | ce -> ce ]; *)

(*   method! class_type ct = *)
(*     with "class_type" *)
(*     match super#class_type ct with *)
(*     [ {| $({@_l||} ) and $ct |} | {| $ct and $({@_l||} ) |} -> ct *)
(*     | ct -> ct ]; *)

(*   method! class_sig_item csg = *)
(*     with "class_sig_item" *)
(*     match super#class_sig_item csg with *)
(*     [ {| $({@_l||} ); $csg |} | {| $csg; $({@_l||} ) |} -> csg *)
(*     | csg -> csg ]; *)

(*   method! class_str_item cst = *)
(*     with "class_str_item" *)
(*     match super#class_str_item cst with *)
(*     [ {| $({@_l||} ); $cst |} | {| $cst; $({@_l||} ) |} -> cst *)
(*     | cst -> cst ]; *)
(* end; *)

(* (\* change all the [loc] to [ghost] *\)     *)
(* class reloc _loc = object *)
(*   inherit map ; *)
(*   method! loc _ = _loc; *)
(* end; *)

(* (\* *)
(*   {[]} *)
(*  *\)   *)
(* let wildcarder = object (self) *)
(*   inherit map as super; *)
(*   method! patt = fun *)
(*   [ {:patt| $lid:_ |} -> {:patt| _ |} *)
(*   | {:patt| ($p as $_) |} -> self#patt p *)
(*   | p -> super#patt p ]; *)
(* end; *)

(* (\* let normalize = object (self) *\) *)
(* (\*   inherit fold as super; *\) *)
(* (\* end; *\) *)

(* let match_pre = object (self) *)
(*   inherit map; (\* as super; *\) *)
(*   method! match_case = with "match_case" fun *)
(*    [ {| $pat:p -> $e |} -> {| $pat:p -> fun () -> $e |} *)
(*    | {| $pat:p when $e -> $e1 |} -> {| $pat:p when $e -> fun () -> $e1 |} *)
(*    | {| $a1 | $a2 |} -> {| $(self#match_case a1) | $(self#match_case a2) |} *)
(*    | {| |} -> {| |} *)
(*    | {| $anti:x |} -> {| $(anti: add_context x "lettry" ) |} ]; *)
(* end; *)