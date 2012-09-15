open Format

module ObjTools =
              struct
               let desc =
                fun obj ->
                 if (Obj.is_block obj) then
                  (
                  ("tag = " ^ ( (string_of_int ( (Obj.tag obj) )) ))
                  )
                 else ("int_val = " ^ ( (string_of_int ( (Obj.obj obj) )) ))

               let rec to_string =
                fun r ->
                 if (Obj.is_int r) then
                  (
                  let i = ((Obj.magic r) : int) in
                  (( (string_of_int i) ) ^ (
                    (" | CstTag" ^ ( (string_of_int ( (i + 1) )) )) ))
                  )
                 else
                  let rec get_fields =
                   fun acc ->
                    function
                    | 0 -> acc
                    | n ->
                       let n = (n - 1) in
                       (get_fields ( ( ( (Obj.field r n) ) ) :: acc  ) n) in
                  let rec is_list =
                   fun r ->
                    if (Obj.is_int r) then ( (r = ( (Obj.repr 0) )) )
                    else
                     let s = (Obj.size r)
                     and t = (Obj.tag r) in
                     (( (t = 0) ) && (
                       (( (s = 2) ) && ( (is_list ( (Obj.field r 1) )) )) )) in
                  let rec get_list =
                   fun r ->
                    if (Obj.is_int r) then [] 
                    else
                     let h = (Obj.field r 0)
                     and t = (get_list ( (Obj.field r 1) )) in
                     ( h ) :: t  in
                  let opaque = fun name -> ("<" ^ ( (name ^ ">") )) in
                  let s = (Obj.size r)
                  and t = (Obj.tag r) in
                  (match t with
                   | _ when (is_list r) ->
                      let fields = (get_list r) in
                      ("[" ^ (
                        ((
                          (String.concat "; " ( (List.map to_string fields)
                            )) ) ^ "]") ))
                   | 0 ->
                      let fields = (get_fields []  s) in
                      ("(" ^ (
                        ((
                          (String.concat ", " ( (List.map to_string fields)
                            )) ) ^ ")") ))
                   | x when (x = Obj.lazy_tag) -> (opaque "lazy")
                   | x when (x = Obj.closure_tag) -> (opaque "closure")
                   | x when (x = Obj.object_tag) ->
                      let fields = (get_fields []  s) in
                      let (_class, id, slots) =
                       (match fields with
                        | (h :: h' :: t) -> (h, h', t)
                        | _ -> assert false) in
                      ("Object #" ^ (
                        (( (to_string id) ) ^ (
                          (" (" ^ (
                            ((
                              (String.concat ", " (
                                (List.map to_string slots) )) ) ^ ")") )) ))
                        ))
                   | x when (x = Obj.infix_tag) -> (opaque "infix")
                   | x when (x = Obj.forward_tag) -> (opaque "forward")
                   | x when (x < Obj.no_scan_tag) ->
                      let fields = (get_fields []  s) in
                      ("Tag" ^ (
                        (( (string_of_int t) ) ^ (
                          (" (" ^ (
                            ((
                              (String.concat ", " (
                                (List.map to_string fields) )) ) ^ ")") )) ))
                        ))
                   | x when (x = Obj.string_tag) ->
                      ("\"" ^ (
                        (( (String.escaped ( ((Obj.magic r) : string) )) ) ^
                          "\"") ))
                   | x when (x = Obj.double_tag) ->
                      (FanUtil.float_repres ( ((Obj.magic r) : float) ))
                   | x when (x = Obj.abstract_tag) -> (opaque "abstract")
                   | x when (x = Obj.custom_tag) -> (opaque "custom")
                   | x when (x = Obj.final_tag) -> (opaque "final")
                   | _ ->
                      (failwith (
                        ("ObjTools.to_string: unknown tag (" ^ (
                          (( (string_of_int t) ) ^ ")") )) )))

               let print =
                fun ppf -> fun x -> (fprintf ppf "%s" ( (to_string x) ))

               let print_desc =
                fun ppf -> fun x -> (fprintf ppf "%s" ( (desc x) ))

              end

let default_handler =
                    fun ppf ->
                     fun x ->
                      let x = (Obj.repr x) in
                      (
                      (fprintf ppf "Camlp4: Uncaught exception: %s" (
                        ((Obj.obj ( (Obj.field ( (Obj.field x 0) ) 0) )) :
                          string) ))
                      );
                      (
                      if (( (Obj.size x) ) > 1)
                      then
                       begin
                       (
                       (pp_print_string ppf " (")
                       );
                       for i = 1 to (( (Obj.size x) ) - 1) do
                        (
                       if (i > 1) then ( (pp_print_string ppf ", ") ) else ()
                       );
                        (ObjTools.print ppf ( (Obj.field x i) ))
                       done;
                       (pp_print_char ppf ')')
                      end else ()
                      );
                      (fprintf ppf "@.")

let handler =
                                           (ref (
                                             fun ppf ->
                                              fun default_handler ->
                                               fun exn ->
                                                (default_handler ppf exn) ))


let register =
 fun f ->
  let current_handler = !handler in
  (handler := (
    fun ppf ->
     fun default_handler ->
      fun exn ->
       (try (f ppf exn) with
        exn -> (current_handler ppf default_handler exn)) ))

module Register =
                                                               functor (Error : Sig.Error) ->
                                                                struct
                                                                 let _ = 
                                                                 let current_handler =
                                                                  !handler in
                                                                 (handler :=
                                                                   (
                                                                   fun ppf ->
                                                                    fun default_handler ->
                                                                    function
                                                                    | Error.E
                                                                    (x) ->
                                                                    (Error.print
                                                                    ppf x)
                                                                    | 
                                                                    x ->
                                                                    (current_handler
                                                                    ppf
                                                                    default_handler
                                                                    x) ))

                                                                end


let gen_print =
 fun ppf ->
  fun default_handler ->
   function
   | Out_of_memory -> (fprintf ppf "Out of memory")
   | Assert_failure (file, line, char) ->
      (fprintf ppf "Assertion failed, file %S, line %d, char %d" file line
        char)
   | Match_failure (file, line, char) ->
      (fprintf ppf "Pattern matching failed, file %S, line %d, char %d" file
        line char)
   | Failure (str) -> (fprintf ppf "Failure: %S" str)
   | Invalid_argument (str) -> (fprintf ppf "Invalid argument: %S" str)
   | Sys_error (str) -> (fprintf ppf "I/O error: %S" str)
   | Stream.Failure -> (fprintf ppf "Parse failure")
   | Stream.Error (str) -> (fprintf ppf "Parse error: %s" str)
   | x -> ((!handler) ppf default_handler x)

let print =
                                               fun ppf ->
                                                (gen_print ppf
                                                  default_handler)

let try_print =
                                                                    fun ppf ->
                                                                    (gen_print
                                                                    ppf (
                                                                    fun _ ->
                                                                    raise ))


let to_string =
 fun exn ->
  let buf = (Buffer.create 128) in
  let () = (bprintf buf "%a" print exn) in (Buffer.contents buf)

let try_to_string =
                                                                   fun exn ->
                                                                    let buf =
                                                                    (Buffer.create
                                                                    128) in
                                                                    let 
                                                                    () =
                                                                    (bprintf
                                                                    buf "%a"
                                                                    try_print
                                                                    exn) in
                                                                    (Buffer.contents
                                                                    buf)