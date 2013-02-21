open Ast
open Format
  
val mkvirtual : virtual_flag -> Asttypes.virtual_flag
val mkdirection : direction_flag -> Asttypes.direction_flag
val mkrf : rec_flag -> Asttypes.rec_flag

val ident_tag : ident -> Longident.t * [> `app | `lident | `uident ]

val ident_noloc : ident -> Longident.t

val ident : ident -> Longident.t Location.loc

val long_lident : err:string -> ident -> Longident.t Location.loc

val long_type_ident : ident -> Longident.t Location.loc

val long_class_ident : ident -> Longident.t Location.loc

val long_uident_noloc : ident -> Longident.t

val long_uident : ident -> Longident.t Location.loc

val ctyp_long_id_prefix : ctyp -> Longident.t

val ctyp_long_id : ctyp -> bool * Longident.t Location.loc

val predef_option : loc -> ctyp

val ctyp : ctyp -> Parsetree.core_type

val row_field : (* ctyp *) row_field -> Parsetree.row_field list -> Parsetree.row_field list

val meth_list :
    name_ctyp ->
      Parsetree.core_field_type list -> Parsetree.core_field_type list

val package_type_constraints :
  with_constr ->
  (Longident.t Asttypes.loc * Parsetree.core_type) list ->
  (Longident.t Asttypes.loc * Parsetree.core_type) list
val package_type : module_type -> Parsetree.package_type

(* val mktype : *)
(*   Location.t -> *)
(*   (string Asttypes.loc option * (bool * bool)) list -> *)
(*   (Parsetree.core_type * Parsetree.core_type * Location.t) list -> *)
(*   Parsetree.type_kind -> *)
(*   Asttypes.private_flag -> *)
(*   Parsetree.core_type option -> Parsetree.type_declaration *)
      
val mkprivate' : bool -> Asttypes.private_flag

val mkprivate : private_flag -> Asttypes.private_flag

val mktrecord :
  name_ctyp ->
  string Location.loc * Asttypes.mutable_flag * Parsetree.core_type *  loc

val mkvariant :
  or_ctyp ->
  string Location.loc * Parsetree.core_type list *
  Parsetree.core_type option * loc

val type_decl :
  (string Asttypes.loc option * (bool * bool)) list ->
  (Parsetree.core_type * Parsetree.core_type * Location.t) list ->
  FanLoc.t -> type_info   -> Parsetree.type_declaration

val mkvalue_desc :
  Location.t -> ctyp -> string list -> Parsetree.value_description
val list_of_meta_list : 'a Ast.meta_list -> 'a list

val mkmutable : mutable_flag -> Asttypes.mutable_flag

val paolab : string -> patt -> string



val optional_type_parameters :
  ctyp ->
  (string Asttypes.loc option * (bool * bool)) list
      
val class_parameters :
  ctyp -> (string Asttypes.loc * (bool * bool)) list
      
val type_parameters_and_type_name :
  ctyp ->
  Longident.t Asttypes.loc *
  (string Asttypes.loc option * (bool * bool)) list

      
val patt_fa :  patt list -> patt -> patt * patt list
      
val deep_mkrangepat : FanLoc.t -> char -> char -> Parsetree.pattern

val mkrangepat : FanLoc.t -> char -> char -> Parsetree.pattern

val patt : patt -> Parsetree.pattern

val mklabpat : rec_patt -> Longident.t Asttypes.loc * Parsetree.pattern

val override_flag :
  FanLoc.t -> override_flag -> Asttypes.override_flag

val expr : expr -> Parsetree.expression

val patt_of_lab : loc -> string -> patt -> Parsetree.pattern

val expr_of_lab : loc -> string -> expr -> Parsetree.expression

val label_expr : expr -> Asttypes.label * Parsetree.expression

val binding :
  binding ->
  (Parsetree.pattern * Parsetree.expression) list ->
  (Parsetree.pattern * Parsetree.expression) list
      
val match_case :
  match_case ->
  (Parsetree.pattern * Parsetree.expression) list

val when_expr : expr -> expr -> Parsetree.expression

val mklabexp :
  rec_expr ->
  (Longident.t Asttypes.loc * Parsetree.expression) list
      
val mkideexp :
  rec_expr ->
  (string Asttypes.loc * Parsetree.expression) list ->
  (string Asttypes.loc * Parsetree.expression) list
      
val mktype_decl :
  typedecl ->
  (string Asttypes.loc * Parsetree.type_declaration) list

val module_type : module_type -> Parsetree.module_type

val module_sig_binding :
  module_binding ->
  (string Asttypes.loc * Parsetree.module_type) list ->
  (string Asttypes.loc * Parsetree.module_type) list
      
val module_str_binding :
  module_binding ->
  (string Asttypes.loc * Parsetree.module_type * Parsetree.module_expr) list ->
  (string Asttypes.loc * Parsetree.module_type * Parsetree.module_expr) list
      
val module_expr : module_expr -> Parsetree.module_expr

val class_type : class_type -> Parsetree.class_type

val class_info_class_expr : class_expr -> Parsetree.class_declaration

val class_info_class_type : class_type -> Parsetree.class_description

val class_sig_item :
  class_sig_item ->
  Parsetree.class_type_field list -> Parsetree.class_type_field list

val class_expr : class_expr -> Parsetree.class_expr

val class_str_item :
  class_str_item ->
  Parsetree.class_field list -> Parsetree.class_field list

val sig_item : sig_item -> Parsetree.signature

val str_item : str_item -> Parsetree.structure

val directive : expr -> Parsetree.directive_argument
    
val phrase : str_item -> Parsetree.toplevel_phrase
val pp : formatter -> ('a, formatter, unit) format -> 'a

val print_expr : formatter -> expr -> unit
val to_string_expr: expr -> string
    
val print_patt : formatter -> patt -> unit

val print_str_item : formatter -> str_item -> unit

val print_ctyp : formatter -> ctyp -> unit
  
