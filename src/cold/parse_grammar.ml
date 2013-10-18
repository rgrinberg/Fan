let gm = Gram_gen.gm
let grammar_module_name = Gram_gen.grammar_module_name
let text_of_functorial_extend = Gram_gen.text_of_functorial_extend
let mk_name = Gram_gen.mk_name
let mk_entry = Gram_gen.mk_entry
let mk_level = Gram_gen.mk_level
let retype_rule_list_without_patterns =
  Gram_gen.retype_rule_list_without_patterns
let mk_rule = Gram_gen.mk_rule
let check_not_tok = Gram_gen.check_not_tok
let mk_slist = Gram_gen.mk_slist
let mk_symbol = Gram_gen.mk_symbol
let token_of_simple_pat = Gram_gen.token_of_simple_pat
let sem_of_list = Ast_gen.sem_of_list
let loc_of = Ast_gen.loc_of
let seq_sem = Ast_gen.seq_sem
let tuple_com = Ast_gen.tuple_com
open FAst
open Util
let g =
  Fgram.create_lexer ~annot:"Grammar's lexer"
    ~keywords:["`";
              "(";
              ")";
              ",";
              "as";
              "|";
              "_";
              ":";
              ".";
              ";";
              "{";
              "}";
              "let";
              "[";
              "]";
              "SEP";
              "LEVEL";
              "S";
              "EOI";
              "Lid";
              "Uid";
              "Ant";
              "Quot";
              "DirQuotation";
              "Str";
              "Label";
              "Optlabel";
              "Chr";
              "Int";
              "Int32";
              "Int64";
              "Int64";
              "Nativeint";
              "Flo"] ()
let extend_header = Fgram.mk_dynamic g "extend_header"
let qualuid: vid Fgram.t = Fgram.mk_dynamic g "qualuid"
let qualid: vid Fgram.t = Fgram.mk_dynamic g "qualid"
let t_qualid: vid Fgram.t = Fgram.mk_dynamic g "t_qualid"
let entry_name:
  ([ `name of Ftoken.name option | `non]* Gram_def.name) Fgram.t =
  Fgram.mk_dynamic g "entry_name"
let entry = Fgram.mk_dynamic g "entry"
let position = Fgram.mk_dynamic g "position"
let assoc = Fgram.mk_dynamic g "assoc"
let name = Fgram.mk_dynamic g "name"
let string = Fgram.mk_dynamic g "string"
let rules = Fgram.mk_dynamic g "rules"
let symbol = Fgram.mk_dynamic g "symbol"
let rule = Fgram.mk_dynamic g "rule"
let meta_rule = Fgram.mk_dynamic g "meta_rule"
let rule_list = Fgram.mk_dynamic g "rule_list"
let psymbol = Fgram.mk_dynamic g "psymbol"
let level = Fgram.mk_dynamic g "level"
let level_list = Fgram.mk_dynamic g "level_list"
let entry: Gram_def.entry Fgram.t = Fgram.mk_dynamic g "entry"
let extend_body = Fgram.mk_dynamic g "extend_body"
let unsafe_extend_body = Fgram.mk_dynamic g "unsafe_extend_body"
let simple: Gram_pat.t Fgram.t = Fgram.mk_dynamic g "simple"
let _ =
  let grammar_entry_create x = Fgram.mk_dynamic g x in
  let internal_pat: 'internal_pat Fgram.t =
    grammar_entry_create "internal_pat" in
  Fgram.extend_single (simple : 'simple Fgram.t )
    (None,
      (None, None,
        [([`Skeyword "`"; `Skeyword "EOI"],
           ("`Vrn (_loc, \"EOI\")\n",
             (Fgram.mk_action
                (fun _  _  (_loc : Locf.t)  ->
                   (`Vrn (_loc, "EOI") : 'simple )))));
        ([`Skeyword "`";
         `Skeyword "Lid";
         `Stoken
           (((function | `Str _ -> true | _ -> false)),
             (`App ((`Vrn "Str"), `Any)), "`Str _")],
          ("`App (_loc, (`Vrn (_loc, \"Lid\")), (`Str (_loc, v)))\n",
            (Fgram.mk_action
               (fun (__fan_2 : [> Ftoken.t])  _  _  (_loc : Locf.t)  ->
                  match __fan_2 with
                  | `Str v ->
                      (`App (_loc, (`Vrn (_loc, "Lid")), (`Str (_loc, v))) : 
                      'simple )
                  | _ ->
                      failwith
                        "`App (_loc, (`Vrn (_loc, \"Lid\")), (`Str (_loc, v)))\n"))));
        ([`Skeyword "`";
         `Skeyword "Uid";
         `Stoken
           (((function | `Str _ -> true | _ -> false)),
             (`App ((`Vrn "Str"), `Any)), "`Str _")],
          ("`App (_loc, (`Vrn (_loc, \"Uid\")), (`Str (_loc, v)))\n",
            (Fgram.mk_action
               (fun (__fan_2 : [> Ftoken.t])  _  _  (_loc : Locf.t)  ->
                  match __fan_2 with
                  | `Str v ->
                      (`App (_loc, (`Vrn (_loc, "Uid")), (`Str (_loc, v))) : 
                      'simple )
                  | _ ->
                      failwith
                        "`App (_loc, (`Vrn (_loc, \"Uid\")), (`Str (_loc, v)))\n"))));
        ([`Skeyword "`";
         `Skeyword "Lid";
         `Stoken
           (((function | `Lid _ -> true | _ -> false)),
             (`App ((`Vrn "Lid"), `Any)), "`Lid _")],
          ("`App (_loc, (`Vrn (_loc, \"Lid\")), (`Lid (_loc, x)))\n",
            (Fgram.mk_action
               (fun (__fan_2 : [> Ftoken.t])  _  _  (_loc : Locf.t)  ->
                  match __fan_2 with
                  | `Lid x ->
                      (`App (_loc, (`Vrn (_loc, "Lid")), (`Lid (_loc, x))) : 
                      'simple )
                  | _ ->
                      failwith
                        "`App (_loc, (`Vrn (_loc, \"Lid\")), (`Lid (_loc, x)))\n"))));
        ([`Skeyword "`";
         `Skeyword "Uid";
         `Stoken
           (((function | `Lid _ -> true | _ -> false)),
             (`App ((`Vrn "Lid"), `Any)), "`Lid _")],
          ("`App (_loc, (`Vrn (_loc, \"Uid\")), (`Lid (_loc, x)))\n",
            (Fgram.mk_action
               (fun (__fan_2 : [> Ftoken.t])  _  _  (_loc : Locf.t)  ->
                  match __fan_2 with
                  | `Lid x ->
                      (`App (_loc, (`Vrn (_loc, "Uid")), (`Lid (_loc, x))) : 
                      'simple )
                  | _ ->
                      failwith
                        "`App (_loc, (`Vrn (_loc, \"Uid\")), (`Lid (_loc, x)))\n"))));
        ([`Skeyword "`";
         `Skeyword "Quot";
         `Stoken
           (((function | `Lid _ -> true | _ -> false)),
             (`App ((`Vrn "Lid"), `Any)), "`Lid _")],
          ("`App (_loc, (`Vrn (_loc, \"Quot\")), (`Lid (_loc, x)))\n",
            (Fgram.mk_action
               (fun (__fan_2 : [> Ftoken.t])  _  _  (_loc : Locf.t)  ->
                  match __fan_2 with
                  | `Lid x ->
                      (`App (_loc, (`Vrn (_loc, "Quot")), (`Lid (_loc, x))) : 
                      'simple )
                  | _ ->
                      failwith
                        "`App (_loc, (`Vrn (_loc, \"Quot\")), (`Lid (_loc, x)))\n"))));
        ([`Skeyword "`";
         `Skeyword "Label";
         `Stoken
           (((function | `Lid _ -> true | _ -> false)),
             (`App ((`Vrn "Lid"), `Any)), "`Lid _")],
          ("`App (_loc, (`Vrn (_loc, \"Label\")), (`Lid (_loc, x)))\n",
            (Fgram.mk_action
               (fun (__fan_2 : [> Ftoken.t])  _  _  (_loc : Locf.t)  ->
                  match __fan_2 with
                  | `Lid x ->
                      (`App (_loc, (`Vrn (_loc, "Label")), (`Lid (_loc, x))) : 
                      'simple )
                  | _ ->
                      failwith
                        "`App (_loc, (`Vrn (_loc, \"Label\")), (`Lid (_loc, x)))\n"))));
        ([`Skeyword "`";
         `Skeyword "DirQuotation";
         `Stoken
           (((function | `Lid _ -> true | _ -> false)),
             (`App ((`Vrn "Lid"), `Any)), "`Lid _")],
          ("`App (_loc, (`Vrn (_loc, \"DirQuotation\")), (`Lid (_loc, x)))\n",
            (Fgram.mk_action
               (fun (__fan_2 : [> Ftoken.t])  _  _  (_loc : Locf.t)  ->
                  match __fan_2 with
                  | `Lid x ->
                      (`App
                         (_loc, (`Vrn (_loc, "DirQuotation")),
                           (`Lid (_loc, x))) : 'simple )
                  | _ ->
                      failwith
                        "`App (_loc, (`Vrn (_loc, \"DirQuotation\")), (`Lid (_loc, x)))\n"))));
        ([`Skeyword "`";
         `Skeyword "Optlabel";
         `Stoken
           (((function | `Lid _ -> true | _ -> false)),
             (`App ((`Vrn "Lid"), `Any)), "`Lid _")],
          ("`App (_loc, (`Vrn (_loc, \"Optlabel\")), (`Lid (_loc, x)))\n",
            (Fgram.mk_action
               (fun (__fan_2 : [> Ftoken.t])  _  _  (_loc : Locf.t)  ->
                  match __fan_2 with
                  | `Lid x ->
                      (`App
                         (_loc, (`Vrn (_loc, "Optlabel")), (`Lid (_loc, x))) : 
                      'simple )
                  | _ ->
                      failwith
                        "`App (_loc, (`Vrn (_loc, \"Optlabel\")), (`Lid (_loc, x)))\n"))));
        ([`Skeyword "`";
         `Skeyword "Str";
         `Stoken
           (((function | `Lid _ -> true | _ -> false)),
             (`App ((`Vrn "Lid"), `Any)), "`Lid _")],
          ("`App (_loc, (`Vrn (_loc, \"Str\")), (`Lid (_loc, x)))\n",
            (Fgram.mk_action
               (fun (__fan_2 : [> Ftoken.t])  _  _  (_loc : Locf.t)  ->
                  match __fan_2 with
                  | `Lid x ->
                      (`App (_loc, (`Vrn (_loc, "Str")), (`Lid (_loc, x))) : 
                      'simple )
                  | _ ->
                      failwith
                        "`App (_loc, (`Vrn (_loc, \"Str\")), (`Lid (_loc, x)))\n"))));
        ([`Skeyword "`";
         `Skeyword "Chr";
         `Stoken
           (((function | `Lid _ -> true | _ -> false)),
             (`App ((`Vrn "Lid"), `Any)), "`Lid _")],
          ("`App (_loc, (`Vrn (_loc, \"Chr\")), (`Lid (_loc, x)))\n",
            (Fgram.mk_action
               (fun (__fan_2 : [> Ftoken.t])  _  _  (_loc : Locf.t)  ->
                  match __fan_2 with
                  | `Lid x ->
                      (`App (_loc, (`Vrn (_loc, "Chr")), (`Lid (_loc, x))) : 
                      'simple )
                  | _ ->
                      failwith
                        "`App (_loc, (`Vrn (_loc, \"Chr\")), (`Lid (_loc, x)))\n"))));
        ([`Skeyword "`";
         `Skeyword "Int";
         `Stoken
           (((function | `Lid _ -> true | _ -> false)),
             (`App ((`Vrn "Lid"), `Any)), "`Lid _")],
          ("`App (_loc, (`Vrn (_loc, \"Int\")), (`Lid (_loc, x)))\n",
            (Fgram.mk_action
               (fun (__fan_2 : [> Ftoken.t])  _  _  (_loc : Locf.t)  ->
                  match __fan_2 with
                  | `Lid x ->
                      (`App (_loc, (`Vrn (_loc, "Int")), (`Lid (_loc, x))) : 
                      'simple )
                  | _ ->
                      failwith
                        "`App (_loc, (`Vrn (_loc, \"Int\")), (`Lid (_loc, x)))\n"))));
        ([`Skeyword "`";
         `Skeyword "Int32";
         `Stoken
           (((function | `Lid _ -> true | _ -> false)),
             (`App ((`Vrn "Lid"), `Any)), "`Lid _")],
          ("`App (_loc, (`Vrn (_loc, \"Int32\")), (`Lid (_loc, x)))\n",
            (Fgram.mk_action
               (fun (__fan_2 : [> Ftoken.t])  _  _  (_loc : Locf.t)  ->
                  match __fan_2 with
                  | `Lid x ->
                      (`App (_loc, (`Vrn (_loc, "Int32")), (`Lid (_loc, x))) : 
                      'simple )
                  | _ ->
                      failwith
                        "`App (_loc, (`Vrn (_loc, \"Int32\")), (`Lid (_loc, x)))\n"))));
        ([`Skeyword "`";
         `Skeyword "Int64";
         `Stoken
           (((function | `Lid _ -> true | _ -> false)),
             (`App ((`Vrn "Lid"), `Any)), "`Lid _")],
          ("`App (_loc, (`Vrn (_loc, \"Int64\")), (`Lid (_loc, x)))\n",
            (Fgram.mk_action
               (fun (__fan_2 : [> Ftoken.t])  _  _  (_loc : Locf.t)  ->
                  match __fan_2 with
                  | `Lid x ->
                      (`App (_loc, (`Vrn (_loc, "Int64")), (`Lid (_loc, x))) : 
                      'simple )
                  | _ ->
                      failwith
                        "`App (_loc, (`Vrn (_loc, \"Int64\")), (`Lid (_loc, x)))\n"))));
        ([`Skeyword "`";
         `Skeyword "Nativeint";
         `Stoken
           (((function | `Lid _ -> true | _ -> false)),
             (`App ((`Vrn "Lid"), `Any)), "`Lid _")],
          ("`App (_loc, (`Vrn (_loc, \"Nativeint\")), (`Lid (_loc, x)))\n",
            (Fgram.mk_action
               (fun (__fan_2 : [> Ftoken.t])  _  _  (_loc : Locf.t)  ->
                  match __fan_2 with
                  | `Lid x ->
                      (`App
                         (_loc, (`Vrn (_loc, "Nativeint")), (`Lid (_loc, x))) : 
                      'simple )
                  | _ ->
                      failwith
                        "`App (_loc, (`Vrn (_loc, \"Nativeint\")), (`Lid (_loc, x)))\n"))));
        ([`Skeyword "`";
         `Skeyword "Flo";
         `Stoken
           (((function | `Lid _ -> true | _ -> false)),
             (`App ((`Vrn "Lid"), `Any)), "`Lid _")],
          ("`App (_loc, (`Vrn (_loc, \"Flo\")), (`Lid (_loc, x)))\n",
            (Fgram.mk_action
               (fun (__fan_2 : [> Ftoken.t])  _  _  (_loc : Locf.t)  ->
                  match __fan_2 with
                  | `Lid x ->
                      (`App (_loc, (`Vrn (_loc, "Flo")), (`Lid (_loc, x))) : 
                      'simple )
                  | _ ->
                      failwith
                        "`App (_loc, (`Vrn (_loc, \"Flo\")), (`Lid (_loc, x)))\n"))));
        ([`Skeyword "`"; `Skeyword "Lid"; `Skeyword "_"],
          ("`App (_loc, (`Vrn (_loc, \"Lid\")), (`Any _loc))\n",
            (Fgram.mk_action
               (fun _  _  _  (_loc : Locf.t)  ->
                  (`App (_loc, (`Vrn (_loc, "Lid")), (`Any _loc)) : 'simple )))));
        ([`Skeyword "`"; `Skeyword "Uid"; `Skeyword "_"],
          ("`App (_loc, (`Vrn (_loc, \"Uid\")), (`Any _loc))\n",
            (Fgram.mk_action
               (fun _  _  _  (_loc : Locf.t)  ->
                  (`App (_loc, (`Vrn (_loc, "Uid")), (`Any _loc)) : 'simple )))));
        ([`Skeyword "`";
         `Skeyword "Ant";
         `Skeyword "(";
         `Slist1sep
           ((`Snterm (Fgram.obj (internal_pat : 'internal_pat Fgram.t ))),
             (`Skeyword ","));
         `Skeyword ")"],
          ("Ast_gen.appl_of_list ((`Vrn (_loc, \"Ant\")) :: v)\n",
            (Fgram.mk_action
               (fun _  (v : 'internal_pat list)  _  _  _  (_loc : Locf.t)  ->
                  (Ast_gen.appl_of_list ((`Vrn (_loc, "Ant")) :: v) : 
                  'simple )))));
        ([`Skeyword "`";
         `Skeyword "Uid";
         `Skeyword "(";
         `Slist1sep
           ((`Snterm (Fgram.obj (internal_pat : 'internal_pat Fgram.t ))),
             (`Skeyword ","));
         `Skeyword ")"],
          ("Ast_gen.appl_of_list ((`Vrn (_loc, \"Uid\")) :: v)\n",
            (Fgram.mk_action
               (fun _  (v : 'internal_pat list)  _  _  _  (_loc : Locf.t)  ->
                  (Ast_gen.appl_of_list ((`Vrn (_loc, "Uid")) :: v) : 
                  'simple )))))]));
  Fgram.extend (internal_pat : 'internal_pat Fgram.t )
    (None,
      [((Some "as"), None,
         [([`Sself;
           `Skeyword "as";
           `Stoken
             (((function | `Lid _ -> true | _ -> false)),
               (`App ((`Vrn "Lid"), `Any)), "`Lid _")],
            ("`Alias (_loc, p1, (`Lid (_loc, s)))\n",
              (Fgram.mk_action
                 (fun (__fan_2 : [> Ftoken.t])  _  (p1 : 'internal_pat) 
                    (_loc : Locf.t)  ->
                    match __fan_2 with
                    | `Lid s ->
                        (`Alias (_loc, p1, (`Lid (_loc, s))) : 'internal_pat )
                    | _ -> failwith "`Alias (_loc, p1, (`Lid (_loc, s)))\n"))))]);
      ((Some "|"), None,
        [([`Sself; `Skeyword "|"; `Sself],
           ("`Bar (_loc, p1, p2)\n",
             (Fgram.mk_action
                (fun (p2 : 'internal_pat)  _  (p1 : 'internal_pat) 
                   (_loc : Locf.t)  -> (`Bar (_loc, p1, p2) : 'internal_pat )))))]);
      ((Some "simple"), None,
        [([`Stoken
             (((function | `Str _ -> true | _ -> false)),
               (`App ((`Vrn "Str"), `Any)), "`Str _")],
           ("`Str (_loc, s)\n",
             (Fgram.mk_action
                (fun (__fan_0 : [> Ftoken.t])  (_loc : Locf.t)  ->
                   match __fan_0 with
                   | `Str s -> (`Str (_loc, s) : 'internal_pat )
                   | _ -> failwith "`Str (_loc, s)\n"))));
        ([`Stoken
            (((function | `Lid _ -> true | _ -> false)),
              (`App ((`Vrn "Lid"), `Any)), "`Lid _")],
          ("`Lid (_loc, x)\n",
            (Fgram.mk_action
               (fun (__fan_0 : [> Ftoken.t])  (_loc : Locf.t)  ->
                  match __fan_0 with
                  | `Lid x -> (`Lid (_loc, x) : 'internal_pat )
                  | _ -> failwith "`Lid (_loc, x)\n"))))])])
let simple_meta = Gentry.map ~name:"simple_meta" token_of_simple_pat simple
let _ =
  let grammar_entry_create x = Fgram.mk_dynamic g x in
  let str: 'str Fgram.t = grammar_entry_create "str"
  and psymbols: 'psymbols Fgram.t = grammar_entry_create "psymbols"
  and opt_action: 'opt_action Fgram.t = grammar_entry_create "opt_action"
  and tmp_lid: 'tmp_lid Fgram.t = grammar_entry_create "tmp_lid"
  and brace_pattern: 'brace_pattern Fgram.t =
    grammar_entry_create "brace_pattern"
  and sep_symbol: 'sep_symbol Fgram.t = grammar_entry_create "sep_symbol"
  and level_str: 'level_str Fgram.t = grammar_entry_create "level_str" in
  Fgram.extend_single (str : 'str Fgram.t )
    (None,
      (None, None,
        [([`Stoken
             (((function | `Str _ -> true | _ -> false)),
               (`App ((`Vrn "Str"), `Any)), "`Str _")],
           ("y\n",
             (Fgram.mk_action
                (fun (__fan_0 : [> Ftoken.t])  (_loc : Locf.t)  ->
                   match __fan_0 with
                   | `Str y -> (y : 'str )
                   | _ -> failwith "y\n"))))]));
  Fgram.extend_single (extend_header : 'extend_header Fgram.t )
    (None,
      (None, None,
        [([`Skeyword "(";
          `Snterm (Fgram.obj (qualid : 'qualid Fgram.t ));
          `Skeyword ":";
          `Snterm (Fgram.obj (t_qualid : 't_qualid Fgram.t ));
          `Skeyword ")"],
           ("let old = gm () in let () = grammar_module_name := t in ((Some i), old)\n",
             (Fgram.mk_action
                (fun _  (t : 't_qualid)  _  (i : 'qualid)  _  (_loc : Locf.t)
                    ->
                   (let old = gm () in
                    let () = grammar_module_name := t in ((Some i), old) : 
                   'extend_header )))));
        ([`Snterm (Fgram.obj (qualuid : 'qualuid Fgram.t ))],
          ("let old = gm () in let () = grammar_module_name := t in (None, old)\n",
            (Fgram.mk_action
               (fun (t : 'qualuid)  (_loc : Locf.t)  ->
                  (let old = gm () in
                   let () = grammar_module_name := t in (None, old) : 
                  'extend_header )))));
        ([],
          ("(None, (gm ()))\n",
            (Fgram.mk_action
               (fun (_loc : Locf.t)  -> ((None, (gm ())) : 'extend_header )))))]));
  Fgram.extend_single (extend_body : 'extend_body Fgram.t )
    (None,
      (None, None,
        [([`Snterm (Fgram.obj (extend_header : 'extend_header Fgram.t ));
          `Slist1 (`Snterm (Fgram.obj (entry : 'entry Fgram.t )))],
           ("let (gram,old) = rest in\nlet res = text_of_functorial_extend _loc gram el in\nlet () = grammar_module_name := old in res\n",
             (Fgram.mk_action
                (fun (el : 'entry list)  (rest : 'extend_header) 
                   (_loc : Locf.t)  ->
                   (let (gram,old) = rest in
                    let res = text_of_functorial_extend _loc gram el in
                    let () = grammar_module_name := old in res : 'extend_body )))))]));
  Fgram.extend_single (unsafe_extend_body : 'unsafe_extend_body Fgram.t )
    (None,
      (None, None,
        [([`Snterm (Fgram.obj (extend_header : 'extend_header Fgram.t ));
          `Slist1 (`Snterm (Fgram.obj (entry : 'entry Fgram.t )))],
           ("let (gram,old) = rest in\nlet res = text_of_functorial_extend ~safe:false _loc gram el in\nlet () = grammar_module_name := old in res\n",
             (Fgram.mk_action
                (fun (el : 'entry list)  (rest : 'extend_header) 
                   (_loc : Locf.t)  ->
                   (let (gram,old) = rest in
                    let res =
                      text_of_functorial_extend ~safe:false _loc gram el in
                    let () = grammar_module_name := old in res : 'unsafe_extend_body )))))]));
  Fgram.extend_single (psymbols : 'psymbols Fgram.t )
    (None,
      (None, None,
        [([`Slist0sep
             ((`Snterm (Fgram.obj (psymbol : 'psymbol Fgram.t ))),
               (`Skeyword ";"))],
           ("sl\n",
             (Fgram.mk_action
                (fun (sl : 'psymbol list)  (_loc : Locf.t)  ->
                   (sl : 'psymbols )))))]));
  Fgram.extend_single (qualuid : 'qualuid Fgram.t )
    (None,
      (None, None,
        [([`Stoken
             (((function | `Uid _ -> true | _ -> false)),
               (`App ((`Vrn "Uid"), `Any)), "`Uid _");
          `Skeyword ".";
          `Sself],
           ("`Dot (_loc, (`Uid (_loc, x)), xs)\n",
             (Fgram.mk_action
                (fun (xs : 'qualuid)  _  (__fan_0 : [> Ftoken.t]) 
                   (_loc : Locf.t)  ->
                   match __fan_0 with
                   | `Uid x ->
                       (`Dot (_loc, (`Uid (_loc, x)), xs) : 'qualuid )
                   | _ -> failwith "`Dot (_loc, (`Uid (_loc, x)), xs)\n"))));
        ([`Stoken
            (((function | `Uid _ -> true | _ -> false)),
              (`App ((`Vrn "Uid"), `Any)), "`Uid _")],
          ("`Uid (_loc, x)\n",
            (Fgram.mk_action
               (fun (__fan_0 : [> Ftoken.t])  (_loc : Locf.t)  ->
                  match __fan_0 with
                  | `Uid x -> (`Uid (_loc, x) : 'qualuid )
                  | _ -> failwith "`Uid (_loc, x)\n"))))]));
  Fgram.extend_single (qualid : 'qualid Fgram.t )
    (None,
      (None, None,
        [([`Stoken
             (((function | `Uid _ -> true | _ -> false)),
               (`App ((`Vrn "Uid"), `Any)), "`Uid _");
          `Skeyword ".";
          `Sself],
           ("`Dot (_loc, (`Uid (_loc, x)), xs)\n",
             (Fgram.mk_action
                (fun (xs : 'qualid)  _  (__fan_0 : [> Ftoken.t]) 
                   (_loc : Locf.t)  ->
                   match __fan_0 with
                   | `Uid x -> (`Dot (_loc, (`Uid (_loc, x)), xs) : 'qualid )
                   | _ -> failwith "`Dot (_loc, (`Uid (_loc, x)), xs)\n"))));
        ([`Stoken
            (((function | `Lid _ -> true | _ -> false)),
              (`App ((`Vrn "Lid"), `Any)), "`Lid _")],
          ("`Lid (_loc, i)\n",
            (Fgram.mk_action
               (fun (__fan_0 : [> Ftoken.t])  (_loc : Locf.t)  ->
                  match __fan_0 with
                  | `Lid i -> (`Lid (_loc, i) : 'qualid )
                  | _ -> failwith "`Lid (_loc, i)\n"))))]));
  Fgram.extend_single (t_qualid : 't_qualid Fgram.t )
    (None,
      (None, None,
        [([`Stoken
             (((function | `Uid _ -> true | _ -> false)),
               (`App ((`Vrn "Uid"), `Any)), "`Uid _");
          `Skeyword ".";
          `Sself],
           ("`Dot (_loc, (`Uid (_loc, x)), xs)\n",
             (Fgram.mk_action
                (fun (xs : 't_qualid)  _  (__fan_0 : [> Ftoken.t]) 
                   (_loc : Locf.t)  ->
                   match __fan_0 with
                   | `Uid x ->
                       (`Dot (_loc, (`Uid (_loc, x)), xs) : 't_qualid )
                   | _ -> failwith "`Dot (_loc, (`Uid (_loc, x)), xs)\n"))));
        ([`Stoken
            (((function | `Uid _ -> true | _ -> false)),
              (`App ((`Vrn "Uid"), `Any)), "`Uid _");
         `Skeyword ".";
         `Stoken
           (((function | `Lid "t" -> true | _ -> false)),
             (`App ((`Vrn "Lid"), (`Str "t"))), "`Lid \"t\"")],
          ("`Uid (_loc, x)\n",
            (Fgram.mk_action
               (fun (__fan_2 : [> Ftoken.t])  _  (__fan_0 : [> Ftoken.t]) 
                  (_loc : Locf.t)  ->
                  match (__fan_2, __fan_0) with
                  | (`Lid "t",`Uid x) -> (`Uid (_loc, x) : 't_qualid )
                  | _ -> failwith "`Uid (_loc, x)\n"))))]));
  Fgram.extend_single (name : 'name Fgram.t )
    (None,
      (None, None,
        [([`Snterm (Fgram.obj (qualid : 'qualid Fgram.t ))],
           ("mk_name _loc il\n",
             (Fgram.mk_action
                (fun (il : 'qualid)  (_loc : Locf.t)  ->
                   (mk_name _loc il : 'name )))))]));
  Fgram.extend_single (entry_name : 'entry_name Fgram.t )
    (None,
      (None, None,
        [([`Snterm (Fgram.obj (qualid : 'qualid Fgram.t ));
          `Sopt (`Snterm (Fgram.obj (str : 'str Fgram.t )))],
           ("let x =\n  match name with\n  | Some x ->\n      let old = Ast_quotation.default.contents in\n      (match Ast_quotation.resolve_name ((`Sub []), x) with\n       | None  -> Locf.failf _loc \"DDSL `%s' not resolved\" x\n       | Some x -> (Ast_quotation.default := (Some x); `name old))\n  | None  -> `non in\n(x, (mk_name _loc il))\n",
             (Fgram.mk_action
                (fun (name : 'str option)  (il : 'qualid)  (_loc : Locf.t) 
                   ->
                   (let x =
                      match name with
                      | Some x ->
                          let old = Ast_quotation.default.contents in
                          (match Ast_quotation.resolve_name ((`Sub []), x)
                           with
                           | None  ->
                               Locf.failf _loc "DDSL `%s' not resolved" x
                           | Some x ->
                               (Ast_quotation.default := (Some x); `name old))
                      | None  -> `non in
                    (x, (mk_name _loc il)) : 'entry_name )))))]));
  Fgram.extend_single (entry : 'entry Fgram.t )
    (None,
      (None, None,
        [([`Snterm (Fgram.obj (entry_name : 'entry_name Fgram.t ));
          `Skeyword ":";
          `Sopt (`Snterm (Fgram.obj (position : 'position Fgram.t )));
          `Snterm (Fgram.obj (level_list : 'level_list Fgram.t ))],
           ("let (n,p) = rest in\n(match n with | `name old -> Ast_quotation.default := old | _ -> ());\n(match (pos, levels) with\n | (Some (`App (_loc,`Vrn (_,\"Level\"),_) : FAst.exp),`Group _) ->\n     failwithf \"For Group levels the position can not be applied to Level\"\n | _ -> mk_entry ~local:false ~name:p ~pos ~levels)\n",
             (Fgram.mk_action
                (fun (levels : 'level_list)  (pos : 'position option)  _ 
                   (rest : 'entry_name)  (_loc : Locf.t)  ->
                   (let (n,p) = rest in
                    (match n with
                     | `name old -> Ast_quotation.default := old
                     | _ -> ());
                    (match (pos, levels) with
                     | (Some
                        (`App (_loc,`Vrn (_,"Level"),_) : FAst.exp),`Group _)
                         ->
                         failwithf
                           "For Group levels the position can not be applied to Level"
                     | _ -> mk_entry ~local:false ~name:p ~pos ~levels) : 
                   'entry )))));
        ([`Skeyword "let";
         `Snterm (Fgram.obj (entry_name : 'entry_name Fgram.t ));
         `Skeyword ":";
         `Sopt (`Snterm (Fgram.obj (position : 'position Fgram.t )));
         `Snterm (Fgram.obj (level_list : 'level_list Fgram.t ))],
          ("let (n,p) = rest in\n(match n with | `name old -> Ast_quotation.default := old | _ -> ());\n(match (pos, levels) with\n | (Some (`App (_loc,`Vrn (_,\"Level\"),_) : FAst.exp),`Group _) ->\n     failwithf \"For Group levels the position can not be applied to Level\"\n | _ -> mk_entry ~local:true ~name:p ~pos ~levels)\n",
            (Fgram.mk_action
               (fun (levels : 'level_list)  (pos : 'position option)  _ 
                  (rest : 'entry_name)  _  (_loc : Locf.t)  ->
                  (let (n,p) = rest in
                   (match n with
                    | `name old -> Ast_quotation.default := old
                    | _ -> ());
                   (match (pos, levels) with
                    | (Some
                       (`App (_loc,`Vrn (_,"Level"),_) : FAst.exp),`Group _)
                        ->
                        failwithf
                          "For Group levels the position can not be applied to Level"
                    | _ -> mk_entry ~local:true ~name:p ~pos ~levels) : 
                  'entry )))))]));
  Fgram.extend_single (position : 'position Fgram.t )
    (None,
      (None, None,
        [([`Stoken
             (((function | `Uid ("First"|"Last") -> true | _ -> false)),
               (`App ((`Vrn "Uid"), (`Bar ((`Str "First"), (`Str "Last"))))),
               "`Uid \"First\"| \"Last\"")],
           ("(`Vrn (_loc, x) : FAst.exp )\n",
             (Fgram.mk_action
                (fun (__fan_0 : [> Ftoken.t])  (_loc : Locf.t)  ->
                   match __fan_0 with
                   | `Uid ("First"|"Last" as x) ->
                       ((`Vrn (_loc, x) : FAst.exp ) : 'position )
                   | _ -> failwith "(`Vrn (_loc, x) : FAst.exp )\n"))));
        ([`Stoken
            (((function
               | `Uid ("Before"|"After"|"Level") -> true
               | _ -> false)),
              (`App
                 ((`Vrn "Uid"),
                   (`Bar
                      ((`Bar ((`Str "Before"), (`Str "After"))),
                        (`Str "Level"))))),
              "`Uid \"Before\"| \"After\"| \"Level\"");
         `Snterm (Fgram.obj (string : 'string Fgram.t ))],
          ("(`App (_loc, (`Vrn (_loc, x)), n) : FAst.exp )\n",
            (Fgram.mk_action
               (fun (n : 'string)  (__fan_0 : [> Ftoken.t])  (_loc : Locf.t) 
                  ->
                  match __fan_0 with
                  | `Uid ("Before"|"After"|"Level" as x) ->
                      ((`App (_loc, (`Vrn (_loc, x)), n) : FAst.exp ) : 
                      'position )
                  | _ ->
                      failwith
                        "(`App (_loc, (`Vrn (_loc, x)), n) : FAst.exp )\n"))));
        ([`Stoken
            (((function | `Uid _ -> true | _ -> false)),
              (`App ((`Vrn "Uid"), `Any)), "`Uid _")],
          ("failwithf \"%s is not the right position:(First|Last) or (Before|After|Level)\"\n  x\n",
            (Fgram.mk_action
               (fun (__fan_0 : [> Ftoken.t])  (_loc : Locf.t)  ->
                  match __fan_0 with
                  | `Uid x ->
                      (failwithf
                         "%s is not the right position:(First|Last) or (Before|After|Level)"
                         x : 'position )
                  | _ ->
                      failwith
                        "failwithf \"%s is not the right position:(First|Last) or (Before|After|Level)\"\n  x\n"))))]));
  Fgram.extend_single (level_list : 'level_list Fgram.t )
    (None,
      (None, None,
        [([`Skeyword "{";
          `Slist1 (`Snterm (Fgram.obj (level : 'level Fgram.t )));
          `Skeyword "}"],
           ("`Group ll\n",
             (Fgram.mk_action
                (fun _  (ll : 'level list)  _  (_loc : Locf.t)  ->
                   (`Group ll : 'level_list )))));
        ([`Snterm (Fgram.obj (level : 'level Fgram.t ))],
          ("`Single l\n",
            (Fgram.mk_action
               (fun (l : 'level)  (_loc : Locf.t)  ->
                  (`Single l : 'level_list )))))]));
  Fgram.extend_single (level : 'level Fgram.t )
    (None,
      (None, None,
        [([`Sopt (`Snterm (Fgram.obj (str : 'str Fgram.t )));
          `Sopt (`Snterm (Fgram.obj (assoc : 'assoc Fgram.t )));
          `Snterm (Fgram.obj (rule_list : 'rule_list Fgram.t ))],
           ("mk_level ~label ~assoc ~rules\n",
             (Fgram.mk_action
                (fun (rules : 'rule_list)  (assoc : 'assoc option) 
                   (label : 'str option)  (_loc : Locf.t)  ->
                   (mk_level ~label ~assoc ~rules : 'level )))))]));
  Fgram.extend_single (assoc : 'assoc Fgram.t )
    (None,
      (None, None,
        [([`Stoken
             (((function | `Uid ("LA"|"RA"|"NA") -> true | _ -> false)),
               (`App
                  ((`Vrn "Uid"),
                    (`Bar ((`Bar ((`Str "LA"), (`Str "RA"))), (`Str "NA"))))),
               "`Uid \"LA\"| \"RA\"| \"NA\"")],
           ("(`Vrn (_loc, x) : FAst.exp )\n",
             (Fgram.mk_action
                (fun (__fan_0 : [> Ftoken.t])  (_loc : Locf.t)  ->
                   match __fan_0 with
                   | `Uid ("LA"|"RA"|"NA" as x) ->
                       ((`Vrn (_loc, x) : FAst.exp ) : 'assoc )
                   | _ -> failwith "(`Vrn (_loc, x) : FAst.exp )\n"))));
        ([`Stoken
            (((function | `Uid _ -> true | _ -> false)),
              (`App ((`Vrn "Uid"), `Any)), "`Uid _")],
          ("failwithf \"%s is not a correct associativity:(LA|RA|NA)\" x\n",
            (Fgram.mk_action
               (fun (__fan_0 : [> Ftoken.t])  (_loc : Locf.t)  ->
                  match __fan_0 with
                  | `Uid x ->
                      (failwithf
                         "%s is not a correct associativity:(LA|RA|NA)" x : 
                      'assoc )
                  | _ ->
                      failwith
                        "failwithf \"%s is not a correct associativity:(LA|RA|NA)\" x\n"))))]));
  Fgram.extend_single (rule_list : 'rule_list Fgram.t )
    (None,
      (None, None,
        [([`Skeyword "["; `Skeyword "]"],
           ("[]\n",
             (Fgram.mk_action
                (fun _  _  (_loc : Locf.t)  -> ([] : 'rule_list )))));
        ([`Skeyword "[";
         `Slist1sep
           ((`Snterm (Fgram.obj (rule : 'rule Fgram.t ))), (`Skeyword "|"));
         `Skeyword "]"],
          ("retype_rule_list_without_patterns _loc rules\n",
            (Fgram.mk_action
               (fun _  (rules : 'rule list)  _  (_loc : Locf.t)  ->
                  (retype_rule_list_without_patterns _loc rules : 'rule_list )))))]));
  Fgram.extend_single (rule : 'rule Fgram.t )
    (None,
      (None, None,
        [([`Slist0sep
             ((`Snterm (Fgram.obj (psymbol : 'psymbol Fgram.t ))),
               (`Skeyword ";"));
          `Sopt (`Snterm (Fgram.obj (opt_action : 'opt_action Fgram.t )))],
           ("mk_rule ~prod ~action\n",
             (Fgram.mk_action
                (fun (action : 'opt_action option)  (prod : 'psymbol list) 
                   (_loc : Locf.t)  -> (mk_rule ~prod ~action : 'rule )))))]));
  Fgram.extend_single (opt_action : 'opt_action Fgram.t )
    (None,
      (None, None,
        [([`Stoken
             (((function | `Quot _ -> true | _ -> false)),
               (`App ((`Vrn "Quot"), `Any)), "`Quot _")],
           ("if x.name = Ftoken.empty_name\nthen\n  let expander loc _ s = Fgram.parse_string ~loc Syntaxf.exp s in\n  Ftoken.quot_expand expander x\nelse Ast_quotation.expand x Dyn_tag.exp\n",
             (Fgram.mk_action
                (fun (__fan_0 : [> Ftoken.t])  (_loc : Locf.t)  ->
                   match __fan_0 with
                   | `Quot x ->
                       (if x.name = Ftoken.empty_name
                        then
                          let expander loc _ s =
                            Fgram.parse_string ~loc Syntaxf.exp s in
                          Ftoken.quot_expand expander x
                        else Ast_quotation.expand x Dyn_tag.exp : 'opt_action )
                   | _ ->
                       failwith
                         "if x.name = Ftoken.empty_name\nthen\n  let expander loc _ s = Fgram.parse_string ~loc Syntaxf.exp s in\n  Ftoken.quot_expand expander x\nelse Ast_quotation.expand x Dyn_tag.exp\n"))))]));
  Fgram.extend_single (tmp_lid : 'tmp_lid Fgram.t )
    (None,
      (None, None,
        [([`Stoken
             (((function | `Lid _ -> true | _ -> false)),
               (`App ((`Vrn "Lid"), `Any)), "`Lid _")],
           ("`Lid (_loc, i)\n",
             (Fgram.mk_action
                (fun (__fan_0 : [> Ftoken.t])  (_loc : Locf.t)  ->
                   match __fan_0 with
                   | `Lid i -> (`Lid (_loc, i) : 'tmp_lid )
                   | _ -> failwith "`Lid (_loc, i)\n"))))]));
  Fgram.extend_single (brace_pattern : 'brace_pattern Fgram.t )
    (None,
      (None, None,
        [([`Skeyword "{";
          `Snterm (Fgram.obj (tmp_lid : 'tmp_lid Fgram.t ));
          `Skeyword "}"],
           ("p\n",
             (Fgram.mk_action
                (fun _  (p : 'tmp_lid)  _  (_loc : Locf.t)  ->
                   (p : 'brace_pattern )))))]));
  Fgram.extend_single (psymbol : 'psymbol Fgram.t )
    (None,
      (None, None,
        [([`Snterm (Fgram.obj (symbol : 'symbol Fgram.t ));
          `Sopt
            (`Snterm (Fgram.obj (brace_pattern : 'brace_pattern Fgram.t )))],
           ("match p with\n| Some _ ->\n    { s with pattern = (p : Gram_def.action_pattern option  :>pat option) }\n| None  -> s\n",
             (Fgram.mk_action
                (fun (p : 'brace_pattern option)  (s : 'symbol) 
                   (_loc : Locf.t)  ->
                   (match p with
                    | Some _ ->
                        {
                          s with
                          pattern =
                            (p : Gram_def.action_pattern option  :>pat option)
                        }
                    | None  -> s : 'psymbol )))))]));
  Fgram.extend_single (sep_symbol : 'sep_symbol Fgram.t )
    (None,
      (None, None,
        [([`Skeyword "SEP"; `Snterm (Fgram.obj (symbol : 'symbol Fgram.t ))],
           ("t\n",
             (Fgram.mk_action
                (fun (t : 'symbol)  _  (_loc : Locf.t)  -> (t : 'sep_symbol )))))]));
  Fgram.extend_single (level_str : 'level_str Fgram.t )
    (None,
      (None, None,
        [([`Stoken
             (((function | `Uid "Level" -> true | _ -> false)),
               (`App ((`Vrn "Uid"), (`Str "Level"))), "`Uid \"Level\"");
          `Stoken
            (((function | `Str _ -> true | _ -> false)),
              (`App ((`Vrn "Str"), `Any)), "`Str _")],
           ("s\n",
             (Fgram.mk_action
                (fun (__fan_1 : [> Ftoken.t])  (__fan_0 : [> Ftoken.t]) 
                   (_loc : Locf.t)  ->
                   match (__fan_1, __fan_0) with
                   | (`Str s,`Uid "Level") -> (s : 'level_str )
                   | _ -> failwith "s\n"))))]));
  Fgram.extend_single (symbol : 'symbol Fgram.t )
    (None,
      (None, None,
        [([`Stoken
             (((function | `Uid ("L0"|"L1") -> true | _ -> false)),
               (`App ((`Vrn "Uid"), (`Bar ((`Str "L0"), (`Str "L1"))))),
               "`Uid \"L0\"| \"L1\"");
          `Sself;
          `Sopt (`Snterm (Fgram.obj (sep_symbol : 'sep_symbol Fgram.t )))],
           ("let () = check_not_tok s in\nlet styp = `App (_loc, (`Lid (_loc, \"list\")), (s.styp)) in\nlet text =\n  mk_slist _loc\n    (match x with\n     | \"L0\" -> false\n     | \"L1\" -> true\n     | _ -> failwithf \"only (L0|L1) allowed here\") sep s in\nmk_symbol ~text ~styp ~pattern:None\n",
             (Fgram.mk_action
                (fun (sep : 'sep_symbol option)  (s : 'symbol) 
                   (__fan_0 : [> Ftoken.t])  (_loc : Locf.t)  ->
                   match __fan_0 with
                   | `Uid ("L0"|"L1" as x) ->
                       (let () = check_not_tok s in
                        let styp =
                          `App (_loc, (`Lid (_loc, "list")), (s.styp)) in
                        let text =
                          mk_slist _loc
                            (match x with
                             | "L0" -> false
                             | "L1" -> true
                             | _ -> failwithf "only (L0|L1) allowed here")
                            sep s in
                        mk_symbol ~text ~styp ~pattern:None : 'symbol )
                   | _ ->
                       failwith
                         "let () = check_not_tok s in\nlet styp = `App (_loc, (`Lid (_loc, \"list\")), (s.styp)) in\nlet text =\n  mk_slist _loc\n    (match x with\n     | \"L0\" -> false\n     | \"L1\" -> true\n     | _ -> failwithf \"only (L0|L1) allowed here\") sep s in\nmk_symbol ~text ~styp ~pattern:None\n"))));
        ([`Stoken
            (((function | `Uid "OPT" -> true | _ -> false)),
              (`App ((`Vrn "Uid"), (`Str "OPT"))), "`Uid \"OPT\"");
         `Sself],
          ("let () = check_not_tok s in\nlet styp = `App (_loc, (`Lid (_loc, \"option\")), (s.styp)) in\nlet text = `Sopt (_loc, (s.text)) in mk_symbol ~text ~styp ~pattern:None\n",
            (Fgram.mk_action
               (fun (s : 'symbol)  (__fan_0 : [> Ftoken.t])  (_loc : Locf.t) 
                  ->
                  match __fan_0 with
                  | `Uid "OPT" ->
                      (let () = check_not_tok s in
                       let styp =
                         `App (_loc, (`Lid (_loc, "option")), (s.styp)) in
                       let text = `Sopt (_loc, (s.text)) in
                       mk_symbol ~text ~styp ~pattern:None : 'symbol )
                  | _ ->
                      failwith
                        "let () = check_not_tok s in\nlet styp = `App (_loc, (`Lid (_loc, \"option\")), (s.styp)) in\nlet text = `Sopt (_loc, (s.text)) in mk_symbol ~text ~styp ~pattern:None\n"))));
        ([`Stoken
            (((function | `Uid "TRY" -> true | _ -> false)),
              (`App ((`Vrn "Uid"), (`Str "TRY"))), "`Uid \"TRY\"");
         `Sself],
          ("let text = `Stry (_loc, (s.text)) in\nmk_symbol ~text ~styp:(s.styp) ~pattern:None\n",
            (Fgram.mk_action
               (fun (s : 'symbol)  (__fan_0 : [> Ftoken.t])  (_loc : Locf.t) 
                  ->
                  match __fan_0 with
                  | `Uid "TRY" ->
                      (let text = `Stry (_loc, (s.text)) in
                       mk_symbol ~text ~styp:(s.styp) ~pattern:None : 
                      'symbol )
                  | _ ->
                      failwith
                        "let text = `Stry (_loc, (s.text)) in\nmk_symbol ~text ~styp:(s.styp) ~pattern:None\n"))));
        ([`Stoken
            (((function | `Uid "PEEK" -> true | _ -> false)),
              (`App ((`Vrn "Uid"), (`Str "PEEK"))), "`Uid \"PEEK\"");
         `Sself],
          ("let text = `Speek (_loc, (s.text)) in\nmk_symbol ~text ~styp:(s.styp) ~pattern:None\n",
            (Fgram.mk_action
               (fun (s : 'symbol)  (__fan_0 : [> Ftoken.t])  (_loc : Locf.t) 
                  ->
                  match __fan_0 with
                  | `Uid "PEEK" ->
                      (let text = `Speek (_loc, (s.text)) in
                       mk_symbol ~text ~styp:(s.styp) ~pattern:None : 
                      'symbol )
                  | _ ->
                      failwith
                        "let text = `Speek (_loc, (s.text)) in\nmk_symbol ~text ~styp:(s.styp) ~pattern:None\n"))));
        ([`Skeyword "S"],
          ("mk_symbol ~text:(`Sself _loc) ~styp:(`Self _loc) ~pattern:None\n",
            (Fgram.mk_action
               (fun _  (_loc : Locf.t)  ->
                  (mk_symbol ~text:(`Sself _loc) ~styp:(`Self _loc)
                     ~pattern:None : 'symbol )))));
        ([`Snterm (Fgram.obj (simple_meta : 'simple_meta Fgram.t ))],
          ("p\n",
            (Fgram.mk_action
               (fun (p : 'simple_meta)  (_loc : Locf.t)  -> (p : 'symbol )))));
        ([`Stoken
            (((function | `Str _ -> true | _ -> false)),
              (`App ((`Vrn "Str"), `Any)), "`Str _")],
          ("mk_symbol ~text:(`Skeyword (_loc, s)) ~styp:(`Tok _loc) ~pattern:None\n",
            (Fgram.mk_action
               (fun (__fan_0 : [> Ftoken.t])  (_loc : Locf.t)  ->
                  match __fan_0 with
                  | `Str s ->
                      (mk_symbol ~text:(`Skeyword (_loc, s))
                         ~styp:(`Tok _loc) ~pattern:None : 'symbol )
                  | _ ->
                      failwith
                        "mk_symbol ~text:(`Skeyword (_loc, s)) ~styp:(`Tok _loc) ~pattern:None\n"))));
        ([`Snterm (Fgram.obj (name : 'name Fgram.t ));
         `Sopt (`Snterm (Fgram.obj (level_str : 'level_str Fgram.t )))],
          ("mk_symbol ~text:(`Snterm (_loc, n, lev))\n  ~styp:(`Quote (_loc, (`Normal _loc), (`Lid (_loc, (n.tvar)))))\n  ~pattern:None\n",
            (Fgram.mk_action
               (fun (lev : 'level_str option)  (n : 'name)  (_loc : Locf.t) 
                  ->
                  (mk_symbol ~text:(`Snterm (_loc, n, lev))
                     ~styp:(`Quote
                              (_loc, (`Normal _loc), (`Lid (_loc, (n.tvar)))))
                     ~pattern:None : 'symbol )))));
        ([`Skeyword "("; `Sself; `Skeyword ")"],
          ("s\n",
            (Fgram.mk_action
               (fun _  (s : 'symbol)  _  (_loc : Locf.t)  -> (s : 'symbol )))))]));
  Fgram.extend_single (string : 'string Fgram.t )
    (None,
      (None, None,
        [([`Stoken
             (((function | `Str _ -> true | _ -> false)),
               (`App ((`Vrn "Str"), `Any)), "`Str _")],
           ("(`Str (_loc, s) : FAst.exp )\n",
             (Fgram.mk_action
                (fun (__fan_0 : [> Ftoken.t])  (_loc : Locf.t)  ->
                   match __fan_0 with
                   | `Str s -> ((`Str (_loc, s) : FAst.exp ) : 'string )
                   | _ -> failwith "(`Str (_loc, s) : FAst.exp )\n"))));
        ([`Stoken
            (((function | `Ant ("",_) -> true | _ -> false)),
              (`App ((`App ((`Vrn "Ant"), (`Str ""))), `Any)),
              "`Ant (\"\",_)")],
          ("Parsef.exp _loc s\n",
            (Fgram.mk_action
               (fun (__fan_0 : [> Ftoken.t])  (_loc : Locf.t)  ->
                  match __fan_0 with
                  | `Ant ("",s) -> (Parsef.exp _loc s : 'string )
                  | _ -> failwith "Parsef.exp _loc s\n"))))]))
let _ =
  let d = Ns.lang in
  Ast_quotation.of_exp ~name:(d, "extend") ~entry:extend_body ();
  Ast_quotation.of_exp ~name:(d, "unsafe_extend") ~entry:unsafe_extend_body
    ()