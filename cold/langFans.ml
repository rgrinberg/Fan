open AstLib

let g =
  Gram.create_lexer
    ~keywords:["derive";
              "unload";
              "clear";
              "keep";
              "on";
              "keep";
              "off";
              "show_code";
              "(";
              ")";
              ",";
              ";"] ~annot:"derive" ()

let fan_quot = Gram.mk_dynamic g "fan_quot"

let fan_quots = Gram.mk_dynamic g "fan_quots"

let _ =
  begin
    Gram.extend_single (fan_quot : 'fan_quot Gram.t )
      (None,
        (None, None,
          [([`Skeyword "derive";
            `Skeyword "(";
            `Slist1
              (Gram.srules
                 [([`Stoken
                      (((function | `Lid _ -> true | _ -> false)),
                        (`Normal, "`Lid _"))],
                    ("Gram.mk_action\n  (fun (__fan_0 : [> FToken.t])  (_loc : FLoc.t)  ->\n     match __fan_0 with | `Lid x -> (x : 'e__1 ) | _ -> failwith \"x\n\")\n",
                      (Gram.mk_action
                         (fun (__fan_0 : [> FToken.t])  (_loc : FLoc.t)  ->
                            match __fan_0 with
                            | `Lid x -> (x : 'e__1 )
                            | _ -> failwith "x\n"))));
                 ([`Stoken
                     (((function | `Uid _ -> true | _ -> false)),
                       (`Normal, "`Uid _"))],
                   ("Gram.mk_action\n  (fun (__fan_0 : [> FToken.t])  (_loc : FLoc.t)  ->\n     match __fan_0 with | `Uid x -> (x : 'e__1 ) | _ -> failwith \"x\n\")\n",
                     (Gram.mk_action
                        (fun (__fan_0 : [> FToken.t])  (_loc : FLoc.t)  ->
                           match __fan_0 with
                           | `Uid x -> (x : 'e__1 )
                           | _ -> failwith "x\n"))))]);
            `Skeyword ")"],
             ("Gram.mk_action\n  (fun _  (plugins : 'e__1 list)  _  _  (_loc : FLoc.t)  ->\n     (begin\n        List.iter Typehook.plugin_add plugins;\n        (`Uid (_loc, \"()\") : FAst.exp )\n      end : 'fan_quot ))\n",
               (Gram.mk_action
                  (fun _  (plugins : 'e__1 list)  _  _  (_loc : FLoc.t)  ->
                     (begin
                        List.iter Typehook.plugin_add plugins;
                        (`Uid (_loc, "()") : FAst.exp )
                      end : 'fan_quot )))));
          ([`Skeyword "unload";
           `Slist1sep
             ((Gram.srules
                 [([`Stoken
                      (((function | `Lid _ -> true | _ -> false)),
                        (`Normal, "`Lid _"))],
                    ("Gram.mk_action\n  (fun (__fan_0 : [> FToken.t])  (_loc : FLoc.t)  ->\n     match __fan_0 with | `Lid x -> (x : 'e__2 ) | _ -> failwith \"x\n\")\n",
                      (Gram.mk_action
                         (fun (__fan_0 : [> FToken.t])  (_loc : FLoc.t)  ->
                            match __fan_0 with
                            | `Lid x -> (x : 'e__2 )
                            | _ -> failwith "x\n"))));
                 ([`Stoken
                     (((function | `Uid _ -> true | _ -> false)),
                       (`Normal, "`Uid _"))],
                   ("Gram.mk_action\n  (fun (__fan_0 : [> FToken.t])  (_loc : FLoc.t)  ->\n     match __fan_0 with | `Uid x -> (x : 'e__2 ) | _ -> failwith \"x\n\")\n",
                     (Gram.mk_action
                        (fun (__fan_0 : [> FToken.t])  (_loc : FLoc.t)  ->
                           match __fan_0 with
                           | `Uid x -> (x : 'e__2 )
                           | _ -> failwith "x\n"))))]), (`Skeyword ","))],
            ("Gram.mk_action\n  (fun (plugins : 'e__2 list)  _  (_loc : FLoc.t)  ->\n     (begin\n        List.iter Typehook.plugin_remove plugins;\n        (`Uid (_loc, \"()\") : FAst.exp )\n      end : 'fan_quot ))\n",
              (Gram.mk_action
                 (fun (plugins : 'e__2 list)  _  (_loc : FLoc.t)  ->
                    (begin
                       List.iter Typehook.plugin_remove plugins;
                       (`Uid (_loc, "()") : FAst.exp )
                     end : 'fan_quot )))));
          ([`Skeyword "clear"],
            ("Gram.mk_action\n  (fun _  (_loc : FLoc.t)  ->\n     (begin\n        FState.reset_current_filters (); (`Uid (_loc, \"()\") : FAst.exp )\n      end : 'fan_quot ))\n",
              (Gram.mk_action
                 (fun _  (_loc : FLoc.t)  ->
                    (begin
                       FState.reset_current_filters ();
                       (`Uid (_loc, "()") : FAst.exp )
                     end : 'fan_quot )))));
          ([`Skeyword "keep"; `Skeyword "on"],
            ("Gram.mk_action\n  (fun _  _  (_loc : FLoc.t)  ->\n     (begin FState.keep := true; (`Uid (_loc, \"()\") : FAst.exp ) end : \n     'fan_quot ))\n",
              (Gram.mk_action
                 (fun _  _  (_loc : FLoc.t)  ->
                    (begin
                       FState.keep := true; (`Uid (_loc, "()") : FAst.exp )
                     end : 'fan_quot )))));
          ([`Skeyword "keep"; `Skeyword "off"],
            ("Gram.mk_action\n  (fun _  _  (_loc : FLoc.t)  ->\n     (begin FState.keep := false; (`Uid (_loc, \"()\") : FAst.exp ) end : \n     'fan_quot ))\n",
              (Gram.mk_action
                 (fun _  _  (_loc : FLoc.t)  ->
                    (begin
                       FState.keep := false; (`Uid (_loc, "()") : FAst.exp )
                     end : 'fan_quot )))));
          ([`Skeyword "show_code"; `Skeyword "on"],
            ("Gram.mk_action\n  (fun _  _  (_loc : FLoc.t)  ->\n     (begin Typehook.show_code := true; (`Uid (_loc, \"()\") : FAst.exp ) end : \n     'fan_quot ))\n",
              (Gram.mk_action
                 (fun _  _  (_loc : FLoc.t)  ->
                    (begin
                       Typehook.show_code := true;
                       (`Uid (_loc, "()") : FAst.exp )
                     end : 'fan_quot )))));
          ([`Skeyword "show_code"; `Skeyword "off"],
            ("Gram.mk_action\n  (fun _  _  (_loc : FLoc.t)  ->\n     (begin Typehook.show_code := false; (`Uid (_loc, \"()\") : FAst.exp ) end : \n     'fan_quot ))\n",
              (Gram.mk_action
                 (fun _  _  (_loc : FLoc.t)  ->
                    (begin
                       Typehook.show_code := false;
                       (`Uid (_loc, "()") : FAst.exp )
                     end : 'fan_quot )))))]));
    Gram.extend_single (fan_quots : 'fan_quots Gram.t )
      (None,
        (None, None,
          [([`Slist1
               (Gram.srules
                  [([`Snterm (Gram.obj (fan_quot : 'fan_quot Gram.t ));
                    `Skeyword ";"],
                     ("Gram.mk_action (fun _  (x : 'fan_quot)  (_loc : FLoc.t)  -> (x : 'e__3 ))\n",
                       (Gram.mk_action
                          (fun _  (x : 'fan_quot)  (_loc : FLoc.t)  ->
                             (x : 'e__3 )))))])],
             ("Gram.mk_action\n  (fun (xs : 'e__3 list)  (_loc : FLoc.t)  -> (seq_sem xs : 'fan_quots ))\n",
               (Gram.mk_action
                  (fun (xs : 'e__3 list)  (_loc : FLoc.t)  ->
                     (seq_sem xs : 'fan_quots )))))]))
  end

let _ =
  begin
    Fsyntax.Options.add
      ("-keep", (FArg.Set FState.keep), "Keep the included type definitions");
    Fsyntax.Options.add
      ("-loaded-plugins", (FArg.Unit Typehook.show_modules), "Show plugins")
  end