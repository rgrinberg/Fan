
(** Ast Utilities for [Astfn.ep] *)
  
open Astfn

val tuple_of_number : ep -> int -> ep


val of_vstr_number : string -> int -> ep


(** used by [Derive.exp_of_ctyp] to generate patterns *)
val gen_tuple_n :
  ?cons_transform:(string -> string) -> arity:int -> string -> int -> ep


val mk_record : ?arity:int -> Ctyp.col list -> ep

val mk_tuple : arity:int -> number:int -> ep

(**
   A very naive lifting. It does not do any parsing at all
   It is applied to both exp and pat

   {[
   of_str "`A";
   Vrn  "A" || Vrn "A"
   
   of_str "A";
   ExId  (Uid  "A")

   of_str "abs";
   ExId  (Lid  "abs")

   of_str "&&";
   ExId  (Lid  "&&")
   ]}
 *)

val of_str: string -> ep
