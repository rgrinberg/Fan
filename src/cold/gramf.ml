open Format
include Gstructure
include Gentry
include Gstru
module Action = Gaction
let default_keywords =
  ["&&";
  "functor";
  "||";
  "private";
  "sig";
  "include";
  "exception";
  "inherit";
  "<";
  "~";
  "and";
  "when";
  ",";
  "mod";
  "then";
  "|]";
  "initializer";
  "#";
  "!";
  "-.";
  "_";
  ">]";
  "??";
  "in";
  "->";
  "downto";
  "lsr";
  "as";
  "function";
  "begin";
  "..";
  ")";
  "=";
  ":";
  "|";
  "[<";
  "class";
  "==";
  ".";
  "{<";
  "land";
  ">}";
  "lxor";
  "do";
  "end";
  "assert";
  "external";
  "+";
  "virtual";
  "to";
  "try";
  ":>";
  "lsl";
  "struct";
  "else";
  "*";
  "val";
  "constraint";
  "type";
  "new";
  "of";
  "<-";
  "done";
  "for";
  "&";
  ";;";
  "{";
  "fun";
  "method";
  "'";
  ";";
  "mutable";
  "lazy";
  "[";
  "}";
  "[|";
  "with";
  "[^";
  "`";
  "::";
  "]";
  "asr";
  "[>";
  ":=";
  "if";
  "while";
  "rec";
  "object";
  "or";
  "-";
  "(";
  "match";
  "open";
  "module";
  "?";
  ">";
  "let";
  "lor";
  "["]
let gkeywords = ref (Setf.String.of_list default_keywords)
let rec fan_filter (__strm : _ Streamf.t) =
  match Streamf.peek __strm with
  | Some (#Tokenf.space_token,_) -> (Streamf.junk __strm; fan_filter __strm)
  | Some x ->
      (Streamf.junk __strm;
       (let xs = __strm in
        Streamf.icons x (Streamf.slazy (fun _  -> fan_filter xs))))
  | _ -> Streamf.sempty
let rec ignore_layout: Tokenf.filter =
  fun (__strm : _ Streamf.t)  ->
    match Streamf.peek __strm with
    | Some (#Tokenf.space_token,_) ->
        (Streamf.junk __strm; ignore_layout __strm)
    | Some x ->
        (Streamf.junk __strm;
         (let xs = __strm in
          Streamf.icons x (Streamf.slazy (fun _  -> ignore_layout xs))))
    | _ -> Streamf.sempty
let gram =
  {
    annot = "Fan";
    gfilter =
      { kwds = (Setf.String.of_list default_keywords); filter = fan_filter }
  }
let filter = FanTokenFilter.filter gram.gfilter
let create_lexer ?(filter= ignore_layout)  ~annot  ~keywords  () =
  { annot; gfilter = { kwds = (Setf.String.of_list keywords); filter } }
let mk f = mk_dynamic gram f
let of_parser name strm = of_parser gram name strm
let get_filter () = gram.gfilter
let token_stream_of_string s = lex_string Locf.string_loc s
let debug_origin_token_stream (entry : 'a t) tokens =
  (parse_origin_tokens entry (Streamf.map (fun t  -> (t, Locf.ghost)) tokens) : 
  'a )
let debug_filtered_token_stream entry tokens =
  filter_and_parse_tokens entry
    (Streamf.map (fun t  -> (t, Locf.ghost)) tokens)
let parse_string_safe ?(loc= Locf.string_loc)  entry s =
  try parse_string entry ~loc s
  with
  | Locf.Exc_located (loc,e) ->
      (eprintf "%s" (Printexc.to_string e);
       Locf.error_report (loc, s);
       Locf.raise loc e)
let sfold0 = Gfold.sfold0
let sfold1 = Gfold.sfold1
let sfold0sep = Gfold.sfold0sep
let sfold1sep = Gfold.sfold1sep
let eoi_entry entry =
  let open! Gstru in
    let g = gram_of_entry entry in
    let entry_eoi = mk_dynamic g ((name entry) ^ "_eoi") in
    extend_single (entry_eoi : 'entry_eoi t )
      (None,
        (None, None,
          [([`Snterm (obj (entry : 'entry t ));
            `Stoken
              (((function | `EOI _ -> true | _ -> false)), (3448991, `Empty),
                "`EOI")],
             ("x\n",
               (mk_action
                  (fun _  (x : 'entry)  (_loc : Locf.t)  -> (x : 'entry_eoi )))))]));
    entry_eoi
let find_level ?position  (entry : Gstructure.entry) =
  match entry.desc with
  | Dparser _ -> invalid_arg "Gramf.find_level"
  | Dlevels levs ->
      let (_,f,_) = Ginsert.find_level ?position entry levs in f
let parse_include_file entry =
  let dir_ok file dir = Sys.file_exists (dir ^ file) in
  fun file  ->
    let file =
      try
        (List.find (dir_ok file) ("./" :: (Configf.include_dirs.contents))) ^
          file
      with | Not_found  -> file in
    let ch = open_in file in
    let st = Streamf.of_channel ch in parse entry (Locf.mk file) st
let parse_string_of_entry ?(loc= Locf.mk "<string>")  entry s =
  try parse_string entry ~loc s
  with
  | Locf.Exc_located (loc,e) ->
      (eprintf "%s" (Printexc.to_string e);
       Locf.error_report (loc, s);
       Locf.raise loc e)
let wrap_stream_parser ?(loc= Locf.mk "<stream>")  p s =
  try p ~loc s
  with
  | Locf.Exc_located (loc,e) ->
      (eprintf "error: %s" (Locf.to_string loc); Locf.raise loc e)