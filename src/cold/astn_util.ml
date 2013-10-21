open FAstN
let sem a b = `Sem (a, b)
let com a b = `Com (a, b)
let app a b = `App (a, b)
let apply a b = `Apply (a, b)
let sta a b = `Sta (a, b)
let bar a b = `Bar (a, b)
let anda a b = `And (a, b)
let dot a b = `Dot (a, b)
let par x = `Par x
let seq a = `Seq a
let arrow a b = `Arrow (a, b)
let typing a b = `Constraint (a, b)
let bar_of_list xs = Ast_basic.of_listr bar xs
let and_of_list xs = Ast_basic.of_listr anda xs
let sem_of_list xs = Ast_basic.of_listr sem xs
let com_of_list xs = Ast_basic.of_listr com xs
let sta_of_list xs = Ast_basic.of_listr sta xs
let dot_of_list xs = Ast_basic.of_listr dot xs
let appl_of_list xs = Ast_basic.of_listl app xs
let seq_sem ls = seq (sem_of_list ls)
let binds bs (e : exp) =
  match bs with
  | [] -> e
  | _ ->
      let binds = and_of_list bs in
      (`LetIn (`Negative, binds, e) : FAstN.exp )
let lid n = `Lid n
let uid n = `Uid n
let unit: ep = `Uid "()"
let ep_of_cons n ps = appl_of_list ((uid n) :: ps)
let tuple_com_unit =
  function | [] -> unit | p::[] -> p | y -> `Par (com_of_list y)
let tuple_com y =
  match y with
  | [] -> failwith "tuple_com empty"
  | x::[] -> x
  | _ -> `Par (com_of_list y)
let tuple_sta y =
  match y with
  | [] -> failwith "tuple_sta empty"
  | x::[] -> x
  | _ -> `Par (sta_of_list y)
let (+>) f names = appl_of_list (f :: (List.map lid names))
let meta_here location =
  let {
        Locf.loc_start =
          { pos_fname = a; pos_lnum = b; pos_bol = c; pos_cnum = d };
        loc_end = { pos_lnum = e; pos_bol = f; pos_cnum = g;_}; loc_ghost = h
        }
    = location in
  `App
    ((`Dot ((`Uid "Locf"), (`Lid "of_tuple"))),
      (`Par
         (`Com
            ((`Str (String.escaped a)),
              (`Com
                 ((`Com
                     ((`Com
                         ((`Com
                             ((`Com
                                 ((`Com
                                     ((`Int (string_of_int b)),
                                       (`Int (string_of_int c)))),
                                   (`Int (string_of_int d)))),
                               (`Int (string_of_int e)))),
                           (`Int (string_of_int f)))),
                       (`Int (string_of_int g)))),
                   (if h then `Lid "true" else `Lid "false")))))))