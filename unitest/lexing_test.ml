
open LibUtil
open OUnit
let (===) = assert_equal



let get_tokens s =
  List.map fst
    (Flex_lib.list_of_string ~verbose:false s )
    
let test_empty_string _ =
  get_tokens {:str|""|}
    ===
  [`Str ""; `EOI]  

let test_escaped_string _ =
  get_tokens {:str|"a\n"|}
    ===
  [`Str "a\n"; `EOI]
    
let test_comment_string _ =
  get_tokens {:str|(*(**)*)|}
    ===
  [`COMMENT"(*(**)*)";`EOI]

let test_char _ =
  get_tokens {:str|'
'|}
    ===
  [`Chr "\n"; `EOI]
;;

(** maybe a bug. Quotation should be loyal to its
    layout *)
let test_string _ =
  get_tokens {:str|"hsoghsogho\n
    haha\
    hahah"|}
    ===
  [`Str "hsoghsogho\n\n    hahahahah"; `EOI]
    
(* This can not be made an unittest
   since our lexer depends on the context which is bad
*)   
let test_quotation _ =
  Flex_lib.list_of_string ~verbose:false {:str|{:lexer|abcdef|}|}
  ===
  [(`Quot
    {FToken.name = (`Sub [], "lexer"); loc = ""; shift = 8;
     content = "abcdef"},
  {FLoc.loc_start =
    {FLoc.pos_fname = "<string>"; pos_lnum = 1; pos_bol = 0; pos_cnum = 0};
   loc_end =
    {FLoc.pos_fname = "<string>"; pos_lnum = 1; pos_bol = 0; pos_cnum = 16};
   loc_ghost = false});
 (`EOI,
  {FLoc.loc_start =
    {FLoc.pos_fname = "<string>"; pos_lnum = 1; pos_bol = 0; pos_cnum = 16};
   loc_end =
    {FLoc.pos_fname = "<string>"; pos_lnum = 1; pos_bol = 1; pos_cnum = 17};
   loc_ghost = false})]

let test_ant _ =
  Ref.protect FConfig.antiquotations true @@ fun _ ->
    Flex_lib.list_of_string ~verbose:false "$aa:a"
      ===
  [(`Ant ("aa", "a"),
  {FLoc.loc_start =
    {FLoc.pos_fname = "<string>"; pos_lnum = 1; pos_bol = 0; pos_cnum = 4};
   loc_end =
    {FLoc.pos_fname = "<string>"; pos_lnum = 1; pos_bol = 0; pos_cnum = 5};
   loc_ghost = false});
 (`EOI,
  {FLoc.loc_start =
    {FLoc.pos_fname = "<string>"; pos_lnum = 1; pos_bol = 0; pos_cnum = 5};
   loc_end =
    {FLoc.pos_fname = "<string>"; pos_lnum = 1; pos_bol = 1; pos_cnum = 6};
   loc_ghost = false})]  

let suite =
  "Lexing_test" >:::
  [  "test_empty_string" >:: test_empty_string;

     "test_escaped_string" >:: test_escaped_string;

     "test_comment_string" >:: test_comment_string;

     "test_quotation" >:: test_quotation;

     "test_quotation" >:: test_string;
     
     "test_char" >:: test_char;
     "test_ant" >:: test_ant;
   ]

    
(* local variables: *)
(* compile-command: "cd .. && make test" *)
(* end: *)
