open Mktop
let _ =
  Printexc.register_printer Mktop.normal_handler;
  PreCast.register_bin_printer ();
  Printexc.register_printer
    (function
     | FLoc.Exc_located (loc,exn) ->
         Some
           (Format.sprintf "%s:@\n%s" (FLoc.to_string loc)
              (Printexc.to_string exn))
     | _ -> None);
  Foptions.adds MkFan.initial_spec_list;
  Ast_parsers.use_parsers ["revise"; "stream"];
  (try
     Arg.parse_dynamic Foptions.init_spec_list MkFan.anon_fun
       "fan <options> <file>\nOptions are:"
   with
   | exc -> (Format.eprintf "@[<v0>%s@]@." (Printexc.to_string exc); exit 2))