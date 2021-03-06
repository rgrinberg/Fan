
 
(*  {[valch '3' = 3  ]} *) 
let valch x = Char.code x - Char.code '0'

(*
  {[
  valch_hex 'a' = 10
  valch_hex 'A' = 10
  valch_hex '3' = 3
  ]}
  no error check
 *)      
let valch_hex x =
  let d = Char.code x in
  if d >= 97 then d - 87
  else if d >= 65 then d - 55
  else d - 48

let rec skip_indent (__strm : _ Streamf.t) =
  match Streamf.peek __strm with
  | Some (' '|'\t') -> (Streamf.junk __strm; skip_indent __strm)
  | _ -> ()

let skip_opt_linefeed (__strm : _ Streamf.t) =
  match Streamf.peek __strm with
  | Some '\n' -> (Streamf.junk __strm; ())
  | _ -> ()

let chr c =
  if c < 0 || c > 255 then failwith "invalid char token" else Char.chr c

(*
  {[
  backslash (Streamf.of_string "321");;
  Exception: Failure "invalid char token".
  backslash (Streamf.of_string "255");;
  - : char = '\255'
  backslash (Streamf.of_string "xff");;
  - : char = '\255'
  '\255';;
  - : char = '\255'
  '\xff';;
  - : char = '\255'
  ]}
 *)  
(* let  backslash = parser *)
(*   |  ( '\010' | '\013' | '\\' | '\'' | ' ' | '"' as x)  -> x *)
(*   |  'n'   -> '\n' *)
(*   |  'r'   -> '\r' *)
(*   |  't'   -> '\t' *)
(*   |  'b'   -> '\b' *)
(*   |   ('0'..'9' as c1); ('0'..'9' as c2);  ('0'..'9' as c3)  -> *)
(*       chr (100 * (valch c1) + 10 * (valch c2) + (valch c3)) *)
(*   |  'x'; ('0'..'9' | 'a'..'f' | 'A'..'F' as c1) ; *)
(*       ('0'..'9' | 'a'..'f' | 'A'..'F' as c2)  -> *)
(*      chr (16 * (valch_hex c1) + (valch_hex c2))  *)

let backslash (__strm : _ Streamf.t) =
  match Streamf.peek __strm with
  | Some ('\n'|'\r'|'\\'|'\''|' '|'"' as x) -> (Streamf.junk __strm; x)
  | Some 'n' -> (Streamf.junk __strm; '\n')
  | Some 'r' -> (Streamf.junk __strm; '\r')
  | Some 't' -> (Streamf.junk __strm; '\t')
  | Some 'b' -> (Streamf.junk __strm; '\b')
  | Some ('0'..'9' as c1) ->
      (Streamf.junk __strm;
       (match Streamf.peek __strm with
        | Some ('0'..'9' as c2) ->
            (Streamf.junk __strm;
             (match Streamf.peek __strm with
              | Some ('0'..'9' as c3) ->
                  (Streamf.junk __strm;
                   chr
                     (((100 * (valch c1)) + (10 * (valch c2))) + (valch c3)))
              | _ -> raise (Streamf.Error "")))
        | _ -> raise (Streamf.Error "")))
  | Some 'x' ->
      (Streamf.junk __strm;
       (match Streamf.peek __strm with
        | Some ('0'|'1'..'9'|'a'..'f'|'A'..'F' as c1) ->
            (Streamf.junk __strm;
             (match Streamf.peek __strm with
              | Some ('0'|'1'..'9'|'a'..'f'|'A'..'F' as c2) ->
                  (Streamf.junk __strm;
                   chr ((16 * (valch_hex c1)) + (valch_hex c2)))
              | _ -> raise (Streamf.Error "")))
        | _ -> raise (Streamf.Error "")))
  | _ -> raise Streamf.NotConsumed


(* follow the ocaml convention *)    
(* let  backslash_in_string strict store = parser *)
(*   |  '\010'; 's  -> skip_indent s *)
(*   |  '\013'; 's  -> begin  skip_opt_linefeed s; skip_indent s  end *)
(*   |  x = backslash  -> store x *)
(*   |  c when not strict  -> begin  store '\\'; store c  end *)
(*   |  -> failwith "invalid string token"  *)
let backslash_in_string strict store (__strm : _ Streamf.t) =
  match Streamf.peek __strm with
  | Some '\n' -> (Streamf.junk __strm; skip_indent __strm)
  | Some '\r' ->
      (Streamf.junk __strm;
       (let s = __strm in skip_opt_linefeed s; skip_indent s))
  | _ ->
      (match try Some (backslash __strm) with  Streamf.NotConsumed  -> None with
       | Some x -> store x
       | _ ->
           (match Streamf.peek __strm with
            | Some c when not strict ->
                (Streamf.junk __strm; store '\\'; store c)
            | _ -> failwith "invalid string token"))
(*
  Exportered here wrap [backslash]
  {[
  char "\\321";;
  Exception: Failure "invalid char token".
  char "\\255";;
  - : char = '\255'
  char "\\xff" ;;
  - : char = '\255'
  ]}  
 *)
let char s =
  if String.length s = 1 then s.[0] (* normal *)
  else if String.length s = 0 then failwith "invalid char token"
  else
    let (__strm :_ Streamf.t)= Streamf.of_string s in
    match Streamf.peek __strm with
    | Some '\\' ->
        (Streamf.junk __strm;
         (try backslash __strm
         with  Streamf.NotConsumed  -> raise (Streamf.Error "Invalid char token")))
    | _ -> failwith "invalid char token"
    (* match Streamf.of_string s with parser *)
    (* | '\\'; x = backslash  ?? "Invalid char token"-> x *)
    (* |  -> failwith "invalid char token"  *)

(*
  {[
  string "\\nag";;
  - : string = "\nag"
  string "\\tag";;
  - : string = "\tag"
  
  ]}
 *)    
let string ?strict s =
  let buf = Buffer.create 23 in
  let store = Buffer.add_char buf in
  let rec parse = fun (__strm : _ Streamf.t)  ->
    match Streamf.peek __strm with
    | Some '\\' ->
        (Streamf.junk __strm;
         (let _ =
            try backslash_in_string (strict <> None) store __strm
            with | Streamf.NotConsumed  -> raise (Streamf.Error "") in
          parse __strm))
    | Some c -> (Streamf.junk __strm; (let s = __strm in store c; parse s))
    | _ -> Buffer.contents buf
    (* parser *)
    (* |  '\\'; _ = backslash_in_string (strict <> None) store; 's  -> parse s *)
    (* |  c; 's  ->  begin store c; parse s end *)
    (* |  -> Buffer.contents buf  *)
  in parse (Streamf.of_string s)
        



let char_of_char_token loc s =
  try char s with
  | Failure _ as exn -> Locf.raise loc exn
        
let string_of_string_token loc s =
  try string s with
  | Failure _ as exn -> Locf.raise loc exn 
                 
