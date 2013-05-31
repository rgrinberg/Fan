



let _ =
  begin
    Printexc.register_printer MkFan.normal_handler;
    PreCast.register_text_printer (); (** default *)
    Printexc.register_printer
        (function
          |FLoc.Exc_located (loc, exn) ->
              Some (Format.sprintf "%s:@\n%s" (FLoc.to_string loc) (Printexc.to_string exn))
          | _ -> None );

    Foptions.adds MkFan.initial_spec_list;
    AstParsers.use_parsers [ "revise"; "stream"; "macro";];
    try
      FArg.parse
        Foptions.init_spec_list
        MkFan.anon_fun "fan <options> <file>\nOptions are:\n" (* in *)
    with exc -> begin Format.eprintf "@[<v0>%s@]@." (Printexc.to_string exc); exit 2 end
  end




