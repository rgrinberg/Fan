module P = (MakePreCast.Make)(FanLexer.Make)

open P

open FanSig

external
                                                                    not_filtered :
                                                                    ('a ->
                                                                    'a Gram.not_filtered) =
                                                                    "%identity"


let wrap =
 fun parse_fun ->
  fun lb ->
   let () = (iter_and_take_callbacks ( fun (_, f) -> (f () ) )) in
   let not_filtered_token_stream = (Lexer.from_lexbuf lb) in
   let token_stream =
    (Gram.filter ( (not_filtered not_filtered_token_stream) )) in
   (try
     let (__strm : _ Stream.t) = token_stream in
     (match (Stream.peek __strm) with
      | Some (EOI, _) -> ( (Stream.junk __strm) ); (raise End_of_file )
      | _ -> (parse_fun token_stream))
    with
    | (((End_of_file | Sys.Break)
        | FanLoc.Exc_located (_, (End_of_file | Sys.Break))) as x) ->
       (raise x)
    | x ->
       let x =
        (match x with
         | FanLoc.Exc_located (loc, x) ->
            ( (Toploop.print_location Format.err_formatter loc) ); x
         | x -> x) in
       (
       (Format.eprintf "@[<0>%a@]@." FanUtil.ErrorHandler.print x)
       );
       (raise Exit ))

let toplevel_phrase =
                        fun token_stream ->
                         (match
                            (Gram.parse_tokens_after_filter (
                              (Syntax.top_phrase :
                                Ast.str_item option P.Gram.Entry.t) )
                              token_stream) with
                          | Some (str_item) ->
                             let str_item =
                              (Syntax.AstFilters.fold_topphrase_filters (
                                fun t -> fun filter -> (filter t) ) str_item) in
                             (Ast2pt.phrase str_item)
                          | None -> (raise End_of_file ))

let use_file =
                                                            fun token_stream ->
                                                             let (pl0, eoi) =
                                                              let rec loop =
                                                               fun ()
                                                                 ->
                                                                let (pl,
                                                                    stopped_at_directive) =
                                                                 (Gram.parse_tokens_after_filter
                                                                   Syntax.use_file
                                                                   token_stream) in
                                                                if (stopped_at_directive
                                                                    <> None ) then
                                                                 (
                                                                 (match
                                                                    pl with
                                                                  | (Ast.StDir
                                                                    (_,
                                                                    "load",
                                                                    Ast.ExStr
                                                                    (_, s))
                                                                    :: 
                                                                    []) ->
                                                                    (
                                                                    (Topdirs.dir_load
                                                                    Format.std_formatter
                                                                    s)
                                                                    );
                                                                    (loop ()
                                                                    )
                                                                  | (Ast.StDir
                                                                    (_,
                                                                    "directory",
                                                                    Ast.ExStr
                                                                    (_, s))
                                                                    :: 
                                                                    []) ->
                                                                    (
                                                                    (Topdirs.dir_directory
                                                                    s)
                                                                    );
                                                                    (loop ()
                                                                    )
                                                                  | _ ->
                                                                    (pl,
                                                                    false ))
                                                                 )
                                                                else
                                                                 (pl, true ) in
                                                              (loop () ) in
                                                             let pl =
                                                              if eoi then [] 
                                                              else
                                                               let rec loop =
                                                                fun ()
                                                                  ->
                                                                 let 
                                                                  (pl,
                                                                   stopped_at_directive) =
                                                                  (Gram.parse_tokens_after_filter
                                                                    Syntax.use_file
                                                                    token_stream) in
                                                                 if (stopped_at_directive
                                                                    <> None ) then
                                                                  (
                                                                  (pl @ (
                                                                    (loop ()
                                                                    ) ))
                                                                  )
                                                                 else pl in
                                                               (loop () ) in
                                                             (List.map
                                                               Ast2pt.phrase
                                                               ( (pl0 @ pl)
                                                               ))

let _ = (
                                                                   (Toploop.parse_toplevel_phrase
                                                                    := (
                                                                    (wrap
                                                                    toplevel_phrase)
                                                                    ))
                                                                   );
                                                                   (
                                                                   (Toploop.parse_use_file
                                                                    := (
                                                                    (wrap
                                                                    use_file)
                                                                    ))
                                                                   );
                                                                   (
                                                                   (Syntax.current_warning
                                                                    := (
                                                                    fun loc ->
                                                                    fun txt ->
                                                                    (Toploop.print_warning
                                                                    loc
                                                                    Format.err_formatter
                                                                    (
                                                                    (Warnings.Camlp4
                                                                    (txt)) ))
                                                                    ))
                                                                   );
                                                                   (iter_and_take_callbacks
                                                                    (
                                                                    fun 
                                                                    (_, f) ->
                                                                    (f () )
                                                                    ))


let _ = let open
        Camlp4Parsers in
        (
        (pa_r (module P))
        );
        (
        (pa_rp (module P))
        );
        (
        (pa_q (module P))
        );
        (
        (pa_g (module P))
        );
        (
        (pa_l (module P))
        );
        (pa_m (module P))
