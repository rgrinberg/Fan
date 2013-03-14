
open AstLoc;
open LibUtil;



type warning = FanLoc.t -> string -> unit;
let default_warning loc txt = Format.eprintf "<W> %a: %s@." FanLoc.print loc txt;
let current_warning = ref default_warning;
let print_warning loc txt = !current_warning loc txt;


{:create|Gram
  
  a_ident
  aident
  amp_ctyp
  and_ctyp
  case
  case0
  binding
  class_declaration
  class_description
  class_expr class_fun_binding class_fun_def class_info_for_class_expr class_info_for_class_type
  class_longident class_longident_and_param class_name_and_param class_sig_item class_signature
  class_str_item class_structure class_type class_type_declaration
  class_type_longident class_type_longident_and_param
  class_type_plus comma_ctyp comma_expr comma_ipatt comma_patt comma_type_parameter
  constrain constructor_arg_list constructor_declaration constructor_declarations
  ctyp cvalue_binding direction_flag direction_flag_quot
  dummy eq_expr expr expr_eoi field_expr field_expr_list fun_binding
  fun_def ident implem interf ipatt ipatt_tcon patt_tcon
  label_declaration  label_declaration_list label_expr label_expr_list 
  label_patt_list label_patt label_longident
  let_binding meth_list meth_decl module_binding
  module_binding
  module_binding0
  module_expr  module_longident  module_longident_with_app  module_rec_declaration
  module_type  (* package_type *) more_ctyp  name_tags
  (* opt_as_lident *)
  opt_class_self_patt
  opt_class_self_type  opt_comma_ctyp  opt_dot_dot  row_var_flag_quot  (* opt_eq_ctyp *)
  opt_expr  opt_meth_list  opt_mutable  mutable_flag_quot  opt_polyt  opt_private
  private_flag_quot  opt_rec  rec_flag_quot  opt_virtual  virtual_flag_quot  opt_override
  override_flag_quot  patt  patt_as_patt_opt  patt_eoi    (* poly_type *)
  row_field  sem_expr  sem_expr_for_list  sem_patt  sem_patt_for_list  semi  sequence
  sig_item  sig_items  star_ctyp  str_item  str_items  top_phrase  (* type_constraint *)
  type_declaration  type_ident_and_parameters  (* type_kind *)  type_longident  type_longident_and_parameters
  type_parameter  type_parameters  typevars  val_longident  with_constr  expr_quot  patt_quot
  ctyp_quot  str_item_quot  sig_item_quot  class_str_item_quot  class_sig_item_quot  module_expr_quot
  module_type_quot  class_type_quot  class_expr_quot  with_constr_quot  binding_quot  rec_expr_quot
  module_declaration
  type_info
  type_repr
  (infixop0 "or ||")
  (infixop1  "& &&")
  (infixop2 "infix operator (level 2) (comparison operators, and some others)")
  (infixop3 "infix operator (level 3) (start with '^', '@')")
  (infixop4 "infix operator (level 4) (start with '+', '-')")
  (infixop5 "infix operator (level 5) (start with '*', '/', '%')")
  (infixop6 "infix operator (level 6) (start with \"**\") (right assoc)")

  (prefixop "prefix operator (start with '!', '?', '~')")
  (case_quot "quotation of case (try/match/function case)")

  module_longident_dot_lparen  sequence'  fun_def  
  module_binding_quot ident_quot string_list     
  method_opt_override  value_val_opt_override  unquoted_typevars  lang
  (* for the grammar module *)  
  symbol
  rule
  meta_rule
  rule_list
  psymbol
  level
  level_list
  entry
  extend_body
  delete_rule_body
  rules
  dot_lstrings
  a_string
  a_lident
  a_uident
  luident

  uident
  
  astr
  dot_namespace
|};
  
let antiquot_expr = Gram.eoi_entry expr ; 
let antiquot_patt = Gram.eoi_entry patt;
let antiquot_ident = Gram.eoi_entry ident; 
let parse_expr loc str = Gram.parse_string antiquot_expr ~loc str;
let parse_patt loc str = Gram.parse_string antiquot_patt ~loc str;
let parse_ident loc str = Gram.parse_string antiquot_ident ~loc str;
let anti_filter = Ant.antiquot_expander  ~parse_expr  ~parse_patt;
let expr_filter (x:ep) = (anti_filter#expr (x:>expr));
let patt_filter (x:ep) = (anti_filter#patt (x:>patt));  

let wrap directive_handler pa init_loc cs =
  let rec loop loc =
    let (pl, stopped_at_directive) = pa loc cs in
    match stopped_at_directive with
    [ Some new_loc ->
      (* let _ = Format.eprintf "Stopped at %a for directive processing@." FanLoc.print new_loc in *)
      let pl =
        match List.rev pl with
        [ [] -> assert false
        | [x :: xs] ->
            match directive_handler x with
            [ None -> xs
            | Some x -> [x :: xs] ] ]
      in (List.rev pl) @ (loop (FanLoc.join_end new_loc))
    | None -> pl ]
  in loop init_loc;
let parse_implem ?(directive_handler = fun _ -> None) _loc cs =
  let l = wrap directive_handler (Gram.parse implem) _loc cs in
  match l with
  [ [] -> None
  | l -> Some (sem_of_list l) ];


let parse_interf ?(directive_handler = fun _ -> None) _loc cs =
  let l = wrap directive_handler (Gram.parse interf) _loc cs in
  match l with
  [ [] -> None   
  | l -> Some (sem_of_list l)] ;
    
let print_interf ?input_file:(_) ?output_file:(_) _ = failwith "No interface printer";
let print_implem ?input_file:(_) ?output_file:(_) _ = failwith "No implementation printer";


  

module Options = struct
  type spec_list = list (string * FanArg.spec * string);
  let init_spec_list = ref [];
  let init spec_list = init_spec_list := spec_list;
  let add (name, spec, descr) =
   init_spec_list := !init_spec_list @ [(name, spec, descr)];
  let adds ls =
    init_spec_list := !init_spec_list @ ls ;
end;

