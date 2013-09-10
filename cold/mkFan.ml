open LibUtil
open Format
let just_print_filters () =
  let pp = eprintf in
  let p_tbl f tbl = Hashtbl.iter (fun k  _v  -> fprintf f "%s@;" k) tbl in
  pp "@[for interface:@[<hv2>%a@]@]@." p_tbl AstFilters.interf_filters;
  pp "@[for phrase:@[<hv2>%a@]@]@." p_tbl AstFilters.implem_filters;
  pp "@[for top_phrase:@[<hv2>%a@]@]@." p_tbl AstFilters.topphrase_filters
let just_print_parsers () =
  let pp = eprintf in
  let p_tbl f tbl = Hashtbl.iter (fun k  _v  -> fprintf f "%s@;" k) tbl in
  pp "@[Loaded Parsers:@;@[<hv2>%a@]@]@." p_tbl AstParsers.registered_parsers
let just_print_applied_parsers () =
  let pp = eprintf in
  pp "@[Applied Parsers:@;@[<hv2>%a@]@]@."
    (fun f  q  -> Queue.iter (fun (k,_)  -> fprintf f "%s@;" k) q)
    AstParsers.applied_parsers
type file_kind =  
  | Intf of string
  | Impl of string
  | Str of string
  | ModuleImpl of string
  | IncludeDir of string 
let print_loaded_modules = ref false
let loaded_modules = ref SSet.empty
let add_to_loaded_modules name =
  loaded_modules := (SSet.add name loaded_modules.contents)
let (objext,libext) =
  if Dynlink.is_native then (".cmxs", ".cmxs") else (".cmo", ".cma")
let require name =
  if not (SSet.mem name loaded_modules.contents)
  then (add_to_loaded_modules name; DynLoader.load (name ^ libext))
let _ =
  let open FControl in
    Fgram.unsafe_extend_single (item : 'item Fgram.t )
      (None,
        (None, None,
          [([`Skeyword "require";
            `Stoken
              (((function | `Str _ -> true | _ -> false)),
                (`App ((`Vrn "Str"), `Any)), "`Str _")],
             ("require s\n",
               (Fgram.mk_action
                  (fun (__fan_1 : [> FToken.t])  _  (_loc : FLoc.t)  ->
                     match __fan_1 with
                     | `Str s -> (require s : 'item )
                     | _ -> failwith "require s\n"))))]))
let output_file = ref None
let process_intf name =
  let v =
    match PreCast.parse_file name PreCast.parse_interf with
    | None  -> None
    | Some x -> let x = AstFilters.apply_interf_filters x in Some x in
  PreCast.CurrentPrinter.print_interf ?input_file:(Some name)
    ?output_file:(output_file.contents) v
let process_impl name =
  let v =
    match PreCast.parse_file name PreCast.parse_implem with
    | None  -> None
    | Some x -> let x = AstFilters.apply_implem_filters x in Some x in
  PreCast.CurrentPrinter.print_implem ?input_file:(Some name)
    ?output_file:(output_file.contents) v
let input_file x =
  match x with
  | Intf file_name ->
      (FConfig.compilation_unit :=
         (Some
            (String.capitalize
               (let open Filename in chop_extension (basename file_name))));
       FConfig.current_input_file := file_name;
       process_intf file_name)
  | Impl file_name ->
      (FConfig.compilation_unit :=
         (Some
            (String.capitalize
               (let open Filename in chop_extension (basename file_name))));
       FConfig.current_input_file := file_name;
       process_impl file_name)
  | Str s ->
      let (f,o) = Filename.open_temp_file "from_string" ".ml" in
      (output_string o s;
       close_out o;
       FConfig.current_input_file := f;
       process_impl f;
       at_exit (fun ()  -> Sys.remove f))
  | ModuleImpl file_name -> require file_name
  | IncludeDir dir -> Ref.modify FConfig.dynload_dirs (cons dir)
let initial_spec_list =
  [("-I", (Arg.String ((fun x  -> input_file (IncludeDir x)))),
     "<directory>  Add directory in search patch for object files.");
  ("-intf", (Arg.String ((fun x  -> input_file (Intf x)))),
    "<file>  Parse <file> as an interface, whatever its extension.");
  ("-impl", (Arg.String ((fun x  -> input_file (Impl x)))),
    "<file>  Parse <file> as an implementation, whatever its extension.");
  ("-str", (Arg.String ((fun x  -> input_file (Str x)))),
    "<string>  Parse <string> as an implementation.");
  ("-o", (Arg.String ((fun x  -> output_file := (Some x)))),
    "<file> Output on <file> instead of standard output.");
  ("-unsafe", (Arg.Set FConfig.unsafe),
    "Generate unsafe accesses to array and strings.");
  ("-verbose", (Arg.Set FConfig.verbose), "More verbose in parsing errors.");
  ("-where",
    (Arg.Unit
       ((fun ()  -> print_endline FConfig.fan_plugins_library; exit 0))),
    " Print location of standard library and exit");
  ("-loc", (Arg.Set_string FLoc.name),
    ("<name>   Name of the location variable (default: " ^
       (FLoc.name.contents ^ ").")));
  ("-v",
    (Arg.Unit
       ((fun ()  -> eprintf "Fan version %s@." FConfig.version; exit 0))),
    "Print Fan version and exit.");
  ("-compilation-unit",
    (Arg.Unit
       ((fun ()  ->
           (match FConfig.compilation_unit.contents with
            | Some v -> printf "%s@." v
            | None  -> printf "null");
           exit 0))), "Print the current compilation unit");
  ("-plugin", (Arg.String require), "load plugin cma or cmxs files");
  ("-loaded-modules", (Arg.Set print_loaded_modules),
    "Print the list of loaded modules.");
  ("-loaded-filters", (Arg.Unit just_print_filters),
    "Print the registered filters.");
  ("-loaded-parsers", (Arg.Unit just_print_parsers),
    "Print the loaded parsers.");
  ("-used-parsers", (Arg.Unit just_print_applied_parsers),
    "Print the applied parsers.");
  ("-dlang",
    (Arg.String
       ((fun s  ->
           AstQuotation.default :=
             (FToken.resolve_name FLoc.ghost ((`Sub []), s))))),
    " Set the default language");
  ("-printer",
    (Arg.Symbol
       (["p"; "o"],
         ((fun x  ->
             if x = "o"
             then PreCast.register_text_printer ()
             else PreCast.register_bin_printer ())))),
    "p  for binary and o  for text ")]
let anon_fun name =
  input_file
    (if Filename.check_suffix name ".mli"
     then Intf name
     else
       if Filename.check_suffix name ".ml"
       then Impl name
       else
         if Filename.check_suffix name objext
         then ModuleImpl name
         else
           if Filename.check_suffix name libext
           then ModuleImpl name
           else raise (Arg.Bad ("don't know what to do with " ^ name)))