#filter "ulex";;
let regexp number = [ '0'-'9' ]+;

let rec token enc = lexer
  [ "<utf8>" -> begin enc := Ulexing.Utf8; token enc lexbuf end
  | "<latin1>" -> begin enc := Ulexing.Latin1; token enc lexbuf end
  | xml_letter+ -> Printf.sprintf "word(%s)" (Ulexing.utf8_lexeme lexbuf)
  | number -> "number"
  | eof -> exit 0
  | [1234-1246] -> "bla"
  | "(" ->  begin
      Ulexing.rollback lexbuf; (* Puts the lexeme back into the buffer *)
      ( lexer ["(" [^ '(']* ")" -> Ulexing.utf8_lexeme lexbuf]) lexbuf
      (* Note the use of an inline lexer *)
  end
  | "(*" -> begin comment lexbuf; "comment" end
  | _ -> "???"]
and comment = lexer
  [ "*)" -> ()
  | eof -> failwith "comment"
  | _ -> let lexeme = Ulexing.lexeme lexbuf in
    print_string  "comment"
   ];


(* let () = *)
(*   let enc = ref Ulexing.Ascii in *)
(*   let lexbuf = Ulexing.from_var_enc_string enc *)
(*       "<utf8>中华人民共和国" *)
(*       (\* "abc<latin1>é<utf8>Ã©(abc)(def)ghi" *\) in *)
(*   try *)
(*     while true do *)
(*       let r = token enc lexbuf in *)
(*       Printf.printf "%s\n" r *)
(*     done *)
(*   with *)
(*     [ Ulexing.Error -> *)
(* 	Printf.eprintf *)
(* 	"Lexing error at offset %i\n" (Ulexing.lexeme_end lexbuf) *)
(*     | Ulexing.InvalidCodepoint i -> *)
(* 	Printf.eprintf *)
(* 	"Invalid code point %i at offset %i\n" i (Ulexing.lexeme_end lexbuf)]; *)
