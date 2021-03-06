
(** Dumping Fan's abstract syntax into OCaml's parsetree *)
  
open Astf

  
val mkvirtual : flag -> Asttypes.virtual_flag
val mkdirection : flag -> Asttypes.direction_flag
val mkrf : flag -> Asttypes.rec_flag


(**
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
  Exception: Locf.Exc_located (, Failure "invalid long identifier").
  ]}

  If "", just remove it, this behavior should appear in other identifier as well FIXME

 *)    
val ident_tag : ident -> Longident.t * [> `app | `lident | `uident ]

val ident_noloc : ident -> Longident.t

val ident : ident -> Longident.t Location.loc

val long_lident :  ident -> Longident.t Location.loc

val long_type_ident : ident -> Longident.t Location.loc

val long_class_ident : ident -> Longident.t Location.loc

val long_uident_noloc : ident -> Longident.t

val long_uident : ident -> Longident.t Location.loc

val ctyp_long_id_prefix : ctyp -> Longident.t

val ctyp_long_id : ctyp -> bool * Longident.t Location.loc

val predef_option : loc -> ctyp

val ctyp : ctyp -> Parsetree.core_type

val row_field :  row_field -> Parsetree.row_field list -> Parsetree.row_field list

val meth_list :
    name_ctyp ->
      Parsetree.core_field_type list -> Parsetree.core_field_type list

val package_type_constraints :
  constr ->
    (Longident.t Asttypes.loc * Parsetree.core_type) list ->
      (Longident.t Asttypes.loc * Parsetree.core_type) list

val package_type : mtyp -> Parsetree.package_type

      

val pat : pat -> Parsetree.pattern


val flag :  loc -> flag -> Asttypes.override_flag

(** {[
  exp (`Id (_loc, ( (`Dot (_loc, `Uid (_loc, "U"), `Lid(_loc,"g"))) )));;
  - : Parsetree.expession =
  {Parsetree.pexp_desc =
  Parsetree.Pexp_ident
  {Asttypes.txt = Longident.Ldot (Longident.Lident "U", "g"); loc = };
  pexp_loc = }

  exp {:exp| $(uid:"A").b |} ; ;       
  - : Parsetree.expession =
  {Parsetree.pexp_desc =
  Parsetree.Pexp_ident
  {Asttypes.txt = Longident.Ldot (Longident.Lident "A", "b"); loc = };
  pexp_loc = }
  Ast2pt.exp {:exp| $(uid:"").b |} ; 
  - : Parsetree.expession =
  {Parsetree.pexp_desc =
  Parsetree.Pexp_ident
  {Asttypes.txt = Longident.Ldot (Longident.Lident "", "b"); loc = };
  pexp_loc = }
  ]}
 *)
val exp : exp -> Parsetree.expression

val label_exp : exp -> Asttypes.label * Parsetree.expression

val top_bind :
  bind ->
  (Parsetree.pattern * Parsetree.expression) list
      
val case :
  case ->
  (Parsetree.pattern * Parsetree.expression) list

val mklabexp :
  rec_exp ->
  (Longident.t Asttypes.loc * Parsetree.expression) list


(** Example: {[
   (of_stru {:stru|type u = int and v  = [A of u and b ] |})
   ||> mktype_decl |> AstPrint.default#type_def_list f;
   type u = int 
   and v =  
   | A of u* b]}
 *)    
      
val mktype_decl :
  typedecl ->
  (string Asttypes.loc * Parsetree.type_declaration) list

val mtyp : mtyp -> Parsetree.module_type

val module_sig_bind :
  mbind ->
  (string Asttypes.loc * Parsetree.module_type) list ->
  (string Asttypes.loc * Parsetree.module_type) list
      
val module_str_bind :
  mbind ->
  (string Asttypes.loc * Parsetree.module_type * Parsetree.module_expr) list ->
  (string Asttypes.loc * Parsetree.module_type * Parsetree.module_expr) list
      
val mexp : mexp -> Parsetree.module_expr

val cltyp : cltyp -> Parsetree.class_type

val class_info_clexp : cldecl -> Parsetree.class_declaration

val class_info_cltyp : cltdecl -> Parsetree.class_description

val clsigi :
  clsigi ->
  Parsetree.class_type_field list -> Parsetree.class_type_field list

val clexp : clexp -> Parsetree.class_expr

val clfield :
  clfield ->
  Parsetree.class_field list -> Parsetree.class_field list

val sigi : sigi -> Parsetree.signature_item list

val stru : stru -> Parsetree.structure_item list

val directive : exp -> Parsetree.directive_argument

(** translate Fan's phrase into parsetree, notice that
   some  [directives] are passed to parsetree if not handled *)    
val phrase               : stru -> Parsetree.toplevel_phrase
    

(** Filled by [typehook] module *)  
val generate_type_code   : (Astf.loc -> Astf.typedecl -> Astf.strings -> Astf.stru) ref
(** Filled by [Objs] module *)    
val dump_ident           : (Astf.ident -> string) ref
val dump_row_field       : (Astf.row_field -> string) ref
val dump_name_ctyp       : (Astf.name_ctyp -> string) ref
val dump_constr          : (Astf.constr -> string) ref
val dump_mtyp            : (Astf.mtyp -> string) ref
val dump_ctyp            : (Astf.ctyp -> string) ref
val dump_or_ctyp         : (Astf.or_ctyp -> string) ref
val dump_pat             : (Astf.pat -> string) ref
val dump_type_parameters : (Astf.type_parameters -> string) ref
val dump_exp             : (Astf.exp -> string) ref
val dump_case            : (Astf.case -> string) ref
val dump_rec_exp         : (Astf.rec_exp -> string) ref
val dump_type_constr     : (Astf.type_constr -> string) ref
val dump_typedecl        : (Astf.typedecl -> string) ref
val dump_sigi            : (Astf.sigi -> string) ref
val dump_mbind           : (Astf.mbind -> string) ref
val dump_mexp            : (Astf.mexp -> string) ref
val dump_stru            : (Astf.stru -> string) ref
val dump_cltyp           : (Astf.cltyp -> string) ref
val dump_cldecl          : (Astf.cldecl -> string) ref
val dump_cltdecl         : (Astf.cltdecl -> string) ref
val dump_clsigi          : (Astf.clsigi -> string) ref
val dump_clexp           : (Astf.clexp -> string) ref
val dump_clfield         : (Astf.clfield -> string) ref
    
