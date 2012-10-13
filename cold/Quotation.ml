open Lib

open LibUtil

module type AntiquotSyntax =
                         sig
                          val parse_expr : (FanLoc.t -> (string -> Ast.expr))

                          val parse_patt : (FanLoc.t -> (string -> Ast.patt))

                         end

module type S =
                               sig
                                type 'a expand_fun =
                                 (FanLoc.t ->
                                  (string option -> (string -> 'a)))

                                val add :
                                 (string ->
                                  ('a DynAst.tag -> ('a expand_fun -> unit)))

                                val find :
                                 (string -> ('a DynAst.tag -> 'a expand_fun))

                                val default : string ref

                                val default_tbl : (string, string) Hashtbl.t

                                val default_at_pos :
                                 (string -> (string -> unit))

                                val parse_quotation_result :
                                 ((FanLoc.t -> (string -> 'a)) ->
                                  (FanLoc.t ->
                                   (FanSig.quotation ->
                                    (string -> (string -> 'a)))))

                                val translate : (string -> string) ref

                                val expand :
                                 (FanLoc.t ->
                                  (FanSig.quotation -> ('a DynAst.tag -> 'a)))

                                val dump_file : string option ref

                                val add_quotation :
                                 (string ->
                                  ('a Gram.t ->
                                   ((FanLoc.t -> ('a -> Lib.Expr.Ast.expr))
                                    ->
                                    ((FanLoc.t -> ('a -> Lib.Expr.Ast.patt))
                                     -> unit))))

                                val add_quotation_of_expr :
                                 (name : string ->
                                  (entry : Ast.expr Gram.t -> unit))

                                val add_quotation_of_patt :
                                 (name : string ->
                                  (entry : Ast.patt Gram.t -> unit))

                                val add_quotation_of_class_str_item :
                                 (name : string ->
                                  (entry : Ast.class_str_item Gram.t -> unit))

                                val add_quotation_of_match_case :
                                 (name : string ->
                                  (entry : Ast.match_case Gram.t -> unit))

                               end

open Format

module Make =
                                                  functor (TheAntiquotSyntax : AntiquotSyntax) ->
                                                   (struct
                                                     type 'a expand_fun =
                                                      (FanLoc.t ->
                                                       (string option ->
                                                        (string -> 'a)))

                                                     module Exp_key =
                                                      (DynAst.Pack)
                                                       (struct
                                                         type 'a t = unit

                                                        end)

                                                     module Exp_fun =
                                                      (DynAst.Pack)
                                                       (struct
                                                         type 'a t =
                                                          'a expand_fun

                                                        end)

                                                     let expanders_table =
                                                      ((ref [] ) :
                                                        ((string *
                                                          Exp_key.pack) *
                                                         Exp_fun.pack) list ref)

                                                     let default = (ref "")

                                                     let default_tbl =
                                                      ((Hashtbl.create 50) :
                                                        (string,
                                                         string) Hashtbl.t)

                                                     let translate =
                                                      (ref ( fun x -> x ))

                                                     let default_at_pos =
                                                      fun pos ->
                                                       fun str ->
                                                        (Hashtbl.replace
                                                          default_tbl pos
                                                          str)

                                                     let expander_name =
                                                      fun pos_tag ->
                                                       fun name ->
                                                        let str =
                                                         (DynAst.string_of_tag
                                                           pos_tag) in
                                                        (match
                                                           ((translate.contents)
                                                             name) with
                                                         | "" ->
                                                            (try
                                                              (Hashtbl.find
                                                                default_tbl
                                                                str)
                                                             with
                                                             Not_found ->
                                                              default.contents)
                                                         | name -> name)

                                                     let find =
                                                      fun name ->
                                                       fun tag ->
                                                        let key =
                                                         ((
                                                          (expander_name tag
                                                            name) ), (
                                                          (Exp_key.pack tag
                                                            () ) )) in
                                                        (Exp_fun.unpack tag (
                                                          (List.assoc key (
                                                            expanders_table.contents
                                                            )) ))

                                                     let add =
                                                      fun name ->
                                                       fun tag ->
                                                        fun f ->
                                                         let elt =
                                                          ((name, (
                                                            (Exp_key.pack tag
                                                              () ) )), (
                                                           (Exp_fun.pack tag
                                                             f) )) in
                                                         (expanders_table :=
                                                           (
                                                           ( elt ) ::
                                                            expanders_table.contents
                                                             ))

                                                     let dump_file =
                                                      (ref None )

                                                     type quotation_error_message =
                                                        Finding
                                                      | Expanding
                                                      | ParsingResult of
                                                         FanLoc.t * string

                                                     type quotation_error =
                                                      (string * string *
                                                       quotation_error_message *
                                                       exn)

                                                     exception Quotation of
                                                      quotation_error

                                                     let quotation_error_to_string =
                                                      fun (name, position,
                                                           ctx, exn) ->
                                                       let ppf =
                                                        (Buffer.create 30) in
                                                       let name =
                                                        if (name = "") then
                                                         (
                                                         default.contents
                                                         )
                                                        else name in
                                                       let pp =
                                                        fun x ->
                                                         (bprintf ppf
                                                           "@?@[<2>While %s %S in a position of %S:"
                                                           x name position) in
                                                       let () =
                                                        (match ctx with
                                                         | Finding ->
                                                            (
                                                            (pp
                                                              "finding quotation")
                                                            );
                                                            (
                                                            (bprintf ppf
                                                              "@ @[<hv2>Available quotation expanders are:@\n")
                                                            );
                                                            (
                                                            (List.iter (
                                                              fun ((s, t), _) ->
                                                               (bprintf ppf
                                                                 "@[<2>%s@ (in@ a@ position@ of %a)@]@ "
                                                                 s
                                                                 Exp_key.print_tag
                                                                 t) ) (
                                                              expanders_table.contents
                                                              ))
                                                            );
                                                            (bprintf ppf
                                                              "@]")
                                                         | Expanding ->
                                                            (pp
                                                              "expanding quotation")
                                                         | ParsingResult
                                                            (loc, str) ->
                                                            (
                                                            (pp
                                                              "parsing result of quotation")
                                                            );
                                                            (match
                                                               dump_file.contents with
                                                             | Some
                                                                (dump_file) ->
                                                                let () =
                                                                 (bprintf ppf
                                                                   " dumping result...\n") in
                                                                (try
                                                                  let oc =
                                                                   (open_out_bin
                                                                    dump_file) in
                                                                  (
                                                                  (output_string
                                                                    oc str)
                                                                  );
                                                                  (
                                                                  (output_string
                                                                    oc "\n")
                                                                  );
                                                                  (
                                                                  (flush oc)
                                                                  );
                                                                  (
                                                                  (close_out
                                                                    oc)
                                                                  );
                                                                  (bprintf
                                                                    ppf "%a:"
                                                                    FanLoc.print
                                                                    (
                                                                    (FanLoc.set_file_name
                                                                    dump_file
                                                                    loc) ))
                                                                 with
                                                                 _ ->
                                                                  (bprintf
                                                                    ppf
                                                                    "Error while dumping result in file %S; dump aborted"
                                                                    dump_file))
                                                             | None ->
                                                                (bprintf ppf
                                                                  "\n(consider setting variable Quotation.dump_file, or using the -QD option)"))) in
                                                       let () =
                                                        (bprintf ppf
                                                          "@\n%s@]@." (
                                                          (Printexc.to_string
                                                            exn) )) in
                                                       (Buffer.contents ppf)

                                                     let _ = (Printexc.register_printer
                                                               (
                                                               function
                                                               | Quotation
                                                                  (x) ->
                                                                  (Some
                                                                    (quotation_error_to_string
                                                                    x))
                                                               | _ -> (None)
                                                               ))

                                                     let expand_quotation =
                                                      fun loc ->
                                                       fun expander ->
                                                        fun pos_tag ->
                                                         fun quot ->
                                                          let open
                                                          FanSig in
                                                          let loc_name_opt =
                                                           if (( quot.q_loc )
                                                                = "") then
                                                            None
                                                            
                                                           else
                                                            (Some
                                                              (quot.q_loc)) in
                                                          (try
                                                            (expander loc
                                                              loc_name_opt (
                                                              quot.q_contents
                                                              ))
                                                           with
                                                           | (FanLoc.Exc_located
                                                               (_,
                                                                Quotation (_)) as
                                                              exc) ->
                                                              (raise exc)
                                                           | FanLoc.Exc_located
                                                              (iloc, exc) ->
                                                              let exc1 =
                                                               (Quotation
                                                                 ((
                                                                  quot.q_name
                                                                  ), pos_tag,
                                                                  Expanding ,
                                                                  exc)) in
                                                              (raise (
                                                                (FanLoc.Exc_located
                                                                  (iloc,
                                                                   exc1)) ))
                                                           | exc ->
                                                              let exc1 =
                                                               (Quotation
                                                                 ((
                                                                  quot.q_name
                                                                  ), pos_tag,
                                                                  Expanding ,
                                                                  exc)) in
                                                              (raise (
                                                                (FanLoc.Exc_located
                                                                  (loc, exc1))
                                                                )))

                                                     let parse_quotation_result =
                                                      fun parse ->
                                                       fun loc ->
                                                        fun quot ->
                                                         fun pos_tag ->
                                                          fun str ->
                                                           let open
                                                           FanSig in
                                                           (try
                                                             (parse loc str)
                                                            with
                                                            | FanLoc.Exc_located
                                                               (iloc,
                                                                Quotation
                                                                 (n, pos_tag,
                                                                  Expanding,
                                                                  exc)) ->
                                                               let ctx =
                                                                (ParsingResult
                                                                  (iloc, (
                                                                   quot.q_contents
                                                                   ))) in
                                                               let exc1 =
                                                                (Quotation
                                                                  (n,
                                                                   pos_tag,
                                                                   ctx, exc)) in
                                                               (raise (
                                                                 (FanLoc.Exc_located
                                                                   (iloc,
                                                                    exc1)) ))
                                                            | FanLoc.Exc_located
                                                               (iloc,
                                                                (Quotation
                                                                  (_) as exc)) ->
                                                               (raise (
                                                                 (FanLoc.Exc_located
                                                                   (iloc,
                                                                    exc)) ))
                                                            | FanLoc.Exc_located
                                                               (iloc, exc) ->
                                                               let ctx =
                                                                (ParsingResult
                                                                  (iloc, (
                                                                   quot.q_contents
                                                                   ))) in
                                                               let exc1 =
                                                                (Quotation
                                                                  ((
                                                                   quot.q_name
                                                                   ),
                                                                   pos_tag,
                                                                   ctx, exc)) in
                                                               (raise (
                                                                 (FanLoc.Exc_located
                                                                   (iloc,
                                                                    exc1)) )))

                                                     let expand =
                                                      fun loc ->
                                                       fun quotation ->
                                                        fun tag ->
                                                         let open
                                                         FanSig in
                                                         let pos_tag =
                                                          (DynAst.string_of_tag
                                                            tag) in
                                                         let name =
                                                          quotation.q_name in
                                                         let expander =
                                                          (try
                                                            (find name tag)
                                                           with
                                                           | (FanLoc.Exc_located
                                                               (_,
                                                                Quotation (_)) as
                                                              exc) ->
                                                              (raise exc)
                                                           | FanLoc.Exc_located
                                                              (qloc, exc) ->
                                                              (raise (
                                                                (FanLoc.Exc_located
                                                                  (qloc, (
                                                                   (Quotation
                                                                    (name,
                                                                    pos_tag,
                                                                    Finding ,
                                                                    exc)) )))
                                                                ))
                                                           | exc ->
                                                              (raise (
                                                                (FanLoc.Exc_located
                                                                  (loc, (
                                                                   (Quotation
                                                                    (name,
                                                                    pos_tag,
                                                                    Finding ,
                                                                    exc)) )))
                                                                ))) in
                                                         let loc =
                                                          (FanLoc.join (
                                                            (FanLoc.move
                                                              `start (
                                                              quotation.q_shift
                                                              ) loc) )) in
                                                         (expand_quotation
                                                           loc expander
                                                           pos_tag quotation)

                                                     let parse_quot_string =
                                                      fun entry ->
                                                       fun loc ->
                                                        fun loc_name_opt ->
                                                         fun s ->
                                                          (BatRef.protect
                                                            FanConfig.antiquotations
                                                            true  (
                                                            fun _ ->
                                                             let res =
                                                              (Gram.parse_string
                                                                entry loc s) in
                                                             let () =
                                                              (Lib.Meta.MetaLocQuotation.loc_name
                                                                :=
                                                                loc_name_opt) in
                                                             res ))

                                                     let anti_filter =
                                                      (Expr.antiquot_expander
                                                        ~parse_expr:TheAntiquotSyntax.parse_expr
                                                        ~parse_patt:TheAntiquotSyntax.parse_patt)

                                                     let add_quotation =
                                                      fun name ->
                                                       fun entry ->
                                                        fun mexpr ->
                                                         fun mpatt ->
                                                          let entry_eoi =
                                                           (Gram.eoi_entry
                                                             entry) in
                                                          let expand_expr =
                                                           fun loc ->
                                                            fun loc_name_opt ->
                                                             fun s ->
                                                              ((
                                                                ((
                                                                  (parse_quot_string
                                                                    entry_eoi
                                                                    loc
                                                                    loc_name_opt
                                                                    s) ) |> (
                                                                  (mexpr loc)
                                                                  )) ) |> (
                                                                anti_filter#expr
                                                                )) in
                                                          let expand_str_item =
                                                           fun loc ->
                                                            fun loc_name_opt ->
                                                             fun s ->
                                                              let exp_ast =
                                                               (expand_expr
                                                                 loc
                                                                 loc_name_opt
                                                                 s) in
                                                              (Ast.StExp
                                                                (loc,
                                                                 exp_ast)) in
                                                          let expand_patt =
                                                           fun _loc ->
                                                            fun loc_name_opt ->
                                                             fun s ->
                                                              (BatRef.protect
                                                                FanConfig.antiquotations
                                                                true  (
                                                                fun _ ->
                                                                 let ast =
                                                                  (Gram.parse_string
                                                                    entry_eoi
                                                                    _loc s) in
                                                                 let meta_ast =
                                                                  (mpatt _loc
                                                                    ast) in
                                                                 let exp_ast =
                                                                  (anti_filter#patt
                                                                    meta_ast) in
                                                                 (match
                                                                    loc_name_opt with
                                                                  | None ->
                                                                    exp_ast
                                                                  | Some
                                                                    (name) ->
                                                                    let rec subst_first_loc =
                                                                    function
                                                                    | Ast.PaApp
                                                                    (_loc,
                                                                    Ast.PaId
                                                                    (_,
                                                                    Ast.IdAcc
                                                                    (_,
                                                                    Ast.IdUid
                                                                    (_, "Ast"),
                                                                    Ast.IdUid
                                                                    (_, u))),
                                                                    _) ->
                                                                    (
                                                                    Ast.PaApp
                                                                    (_loc, (
                                                                    (Ast.PaId
                                                                    (_loc, (
                                                                    (Ast.IdAcc
                                                                    (_loc, (
                                                                    (Ast.IdUid
                                                                    (_loc,
                                                                    "Ast"))
                                                                    ), (
                                                                    (Ast.IdUid
                                                                    (_loc, u))
                                                                    ))) )))
                                                                    ), (
                                                                    (Ast.PaId
                                                                    (_loc, (
                                                                    (Ast.IdLid
                                                                    (_loc,
                                                                    name)) )))
                                                                    )))
                                                                    | Ast.PaApp
                                                                    (_loc, a,
                                                                    b) ->
                                                                    (
                                                                    Ast.PaApp
                                                                    (_loc, (
                                                                    (subst_first_loc
                                                                    a) ), b))
                                                                    | 
                                                                    p -> p in
                                                                    (subst_first_loc
                                                                    exp_ast))
                                                                )) in
                                                          (
                                                          (add name
                                                            DynAst.expr_tag
                                                            expand_expr)
                                                          );
                                                          (
                                                          (add name
                                                            DynAst.patt_tag
                                                            expand_patt)
                                                          );
                                                          (add name
                                                            DynAst.str_item_tag
                                                            expand_str_item)

                                                     let add_quotation_of_str_item =
                                                      fun ~name ->
                                                       fun ~entry ->
                                                        (add name
                                                          DynAst.str_item_tag
                                                          (
                                                          (parse_quot_string
                                                            (
                                                            (Gram.eoi_entry
                                                              entry) )) ))

                                                     let add_quotation_of_str_item_with_filter =
                                                      fun ~name ->
                                                       fun ~entry ->
                                                        fun ~filter ->
                                                         (add name
                                                           DynAst.str_item_tag
                                                           (
                                                           (filter (
                                                             (parse_quot_string
                                                               (
                                                               (Gram.eoi_entry
                                                                 entry) )) ))
                                                           ))

                                                     let add_quotation_of_expr =
                                                      fun ~name ->
                                                       fun ~entry ->
                                                        let expand_fun =
                                                         (parse_quot_string (
                                                           (Gram.eoi_entry
                                                             entry) )) in
                                                        let mk_fun =
                                                         fun loc ->
                                                          fun loc_name_opt ->
                                                           fun s ->
                                                            (Ast.StExp
                                                              (loc, (
                                                               (expand_fun
                                                                 loc
                                                                 loc_name_opt
                                                                 s) ))) in
                                                        (
                                                        (add name
                                                          DynAst.expr_tag
                                                          expand_fun)
                                                        );
                                                        (add name
                                                          DynAst.str_item_tag
                                                          mk_fun)

                                                     let add_quotation_of_patt =
                                                      fun ~name ->
                                                       fun ~entry ->
                                                        (add name
                                                          DynAst.patt_tag (
                                                          (parse_quot_string
                                                            (
                                                            (Gram.eoi_entry
                                                              entry) )) ))

                                                     let add_quotation_of_class_str_item =
                                                      fun ~name ->
                                                       fun ~entry ->
                                                        (add name
                                                          DynAst.class_str_item_tag
                                                          (
                                                          (parse_quot_string
                                                            (
                                                            (Gram.eoi_entry
                                                              entry) )) ))

                                                     let add_quotation_of_match_case =
                                                      fun ~name ->
                                                       fun ~entry ->
                                                        (add name
                                                          DynAst.match_case_tag
                                                          (
                                                          (parse_quot_string
                                                            (
                                                            (Gram.eoi_entry
                                                              entry) )) ))

                                                    end : S)
