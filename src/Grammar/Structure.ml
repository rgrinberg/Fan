(* open FanSig; *)
open LibUtil;
type assoc =
    [= `NA|`RA|`LA];
type position =
    [= `First | `Last | `Before of string | `After of string | `Level of string];


module Action  = struct
  type  t     = Obj.t   ;
  let mk :'a -> t   = Obj.repr;
  let get: t -> 'a  = Obj.obj ;
  let getf: t-> 'a -> 'b  = Obj.obj ;
  let getf2: t -> 'a -> 'b -> 'c = Obj.obj ;
end;


type gram = {
    gfilter         : FanTokenFilter.filter;
    gkeywords       : Hashtbl.t string (ref int);
    glexer          : FanLoc.t -> XStream.t char -> XStream.t (FanToken.token * FanLoc.t);
    warning_verbose : ref bool;
    error_verbose   : ref bool };

type token_info = {
    prev_loc : FanLoc.t;
    cur_loc : FanLoc.t ;
    prev_loc_only : bool };
  
let ghost_token_info = {
  prev_loc=FanLoc.ghost;
  cur_loc = FanLoc.ghost;
  prev_loc_only = false;};
  (* with neighbor token info stored*)  

type token_stream = XStream.t (FanToken.token * token_info);

open Format;
let pp = fprintf;
  
let pp_token_info f {prev_loc;cur_loc;prev_loc_only} =
  pp f
    "{prev_loc=@;%a;cur_loc=@;%a;prev_loc_only=%b}"
    FanLoc.print prev_loc
    FanLoc.print cur_loc
    prev_loc_only ;

type parse 'a = token_stream -> 'a;
type cont_parse 'a = FanLoc.t -> Action.t -> parse 'a;
    
type description =
    [= `Normal
    | `Antiquot];

type descr = (description * string) ;  
type token_pattern = ((FanToken.token -> bool) * descr);

type terminal =
    [= `Skeyword of string
    | `Stoken of token_pattern ];

type internal_entry =
    { egram     : gram;
      ename     : string;
      estart    : mutable int -> parse Action.t;
      econtinue : mutable int -> cont_parse Action.t;
      edesc     : mutable desc }
and desc =
    [ Dlevels of list level
    | Dparser of token_stream -> Action.t ]
and level = {
    assoc   : assoc         ;
    lname   : option string ;
    lsuffix : tree          ;
    lprefix : tree          }
and symbol =
    [=
     `Smeta of (list string * list symbol * Action.t)
    | `Snterm of internal_entry
    | `Snterml of (internal_entry * string) (* the second argument is the level name *)
    | `Slist0 of symbol
    | `Slist0sep of (symbol * symbol)
    | `Slist1 of symbol
    | `Slist1sep of (symbol * symbol)
    | `Sopt of symbol
    | `Stry of symbol
    | `Speek of symbol
    | `Sself
    | `Snext
    | `Stree of tree
    | terminal ]
and tree = (* internal struccture *)
    [ Node of node
    | LocAct of Action.t and list Action.t
    | DeadEnd ]
and node = {
    node    : symbol ;
    son     : tree   ;
    brother : tree   };

type production= (list symbol * Action.t);

type olevel = (option string * option assoc * list production);
  
type extend_statment = (option position * list olevel);
  
type delete_statment = list symbol;

type fold 'a 'b 'c =
    internal_entry -> list symbol ->
      (XStream.t 'a -> 'b) -> XStream.t 'a -> 'c;

type foldsep 'a 'b 'c =
    internal_entry -> list symbol ->
      (XStream.t 'a -> 'b) -> (XStream.t 'a -> unit) -> XStream.t 'a -> 'c;

let get_filter g = g.gfilter;
let token_location r = r.cur_loc;

  
let using { gkeywords = table; gfilter = filter; _ } kwd =
  let r = try Hashtbl.find table kwd with
    [ Not_found ->
      let r = ref 0 in begin Hashtbl.add table kwd r; r end ]
  in begin
    FanTokenFilter.keyword_added filter kwd (r.contents = 0);
    incr r
  end;
let mk_action=Action.mk;
let string_of_token=FanToken.extract_string  ;
let removing { gkeywords = table; gfilter = filter; _ } kwd =
  let r = Hashtbl.find table kwd in
  let () = decr r in
    if !r = 0 then begin
      FanTokenFilter.keyword_removed filter kwd;
      Hashtbl.remove table kwd
    end else ();


(* tree processing *)  
let rec flatten_tree = fun
  [ DeadEnd -> []
  | LocAct (_, _) -> [[]]
  | Node {node = n; brother = b; son = s} ->
      [ [n :: l] | l <- flatten_tree s ] @ flatten_tree b ];

type brothers = [ Bro of symbol and list brothers ];

type space_formatter =  format unit Format.formatter unit;

let get_brothers x =
  let rec aux acc =  fun
  [ DeadEnd | LocAct _ -> List.rev acc
  | Node {node = n; brother = b; son = s} ->
          aux [ Bro n (aux [] s) :: acc] b ] in aux [] x ;
let get_children x = 
  let rec aux acc =  fun
  [ [] -> List.rev acc
  | [Bro (n, x)] -> aux [n::acc] x
  | _ -> raise Exit ] in aux [] x ;

(* level -> lprefix -> *)  
let get_first =
  let rec aux acc = fun
     [Node {node;brother;_}
      ->
       aux [node::acc] brother
     |LocAct (_,_) | DeadEnd -> acc ] in
  aux [];

let get_first_from levels set =
  List.iter
    (fun level -> level.lprefix |> get_first |> Hashset.add_list set)
    levels;

  
