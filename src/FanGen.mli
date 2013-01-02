open Ast
val mk_variant_eq : 'a -> FSig.ty_info list -> expr
val mk_tuple_eq : FSig.ty_info list -> expr
val mk_record_eq : FSig.record_col list -> expr
val mk_variant_meta_expr : string -> FSig.ty_info list -> expr
val mk_record_meta_expr : FSig.record_col list -> expr
val mk_tuple_meta_expr : FSig.ty_info list -> expr
val gen_meta_expr : FSig.module_types -> str_item
val mk_variant_meta_patt : string -> FSig.ty_info list -> expr
val mk_record_meta_patt : FSig.record_col list -> expr
val mk_tuple_meta_patt : FSig.ty_info list -> expr


val extract : FSig.ty_info list -> expr list

val mkfmt : string -> string -> string -> string list -> expr

val mk_variant_print : string -> FSig.ty_info list -> expr

val mk_tuple_print : FSig.ty_info list -> expr

val mk_record_print : FSig.record_col list -> expr

val gen_eq : FSig.module_types -> str_item

val gen_fold : FSig.module_types -> str_item

val gen_fold2 : FSig.module_types -> str_item

val gen_map : FSig.module_types -> str_item

val gen_map2 : FSig.module_types -> str_item

val gen_meta_patt : FSig.module_types -> str_item

val gen_print : FSig.module_types -> str_item

val gen_print_obj : FSig.module_types -> str_item