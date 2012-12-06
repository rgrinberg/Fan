
open LibUtil;
(* open FanSig; *)
open Format;
open Structure;
open Tools;

type t 'a =internal_entry;

let name e = e.ename;

let print ppf e = fprintf ppf "%a@\n" Print.text#entry e;
let dump ppf e = fprintf ppf "%a@\n" Print.dump#entry e;


let trace_parser = ref false;
let mk_dynamic g n ={
  egram = g;
  ename = n;
  estart = empty_entry n;
  econtinue _ _ _ = parser [];
  edesc = Dlevels [] };

(* [estart] *)  
let action_parse entry ts : Action.t =
  try 
    let p =
      if !trace_parser then
        Format.fprintf
      else Format.ifprintf in 
    let () = p Format.err_formatter "@[<4>%s@ " entry.ename in
    let res = entry.estart 0 ts in (* entry.estart 0 *)
    let () =  p Format.err_formatter "@]@." in 
    res 
  with
    [ XStream.Failure ->
        FanLoc.raise (get_prev_loc ts)
          (XStream.Error ("illegal begin of " ^ entry.ename))
    | FanLoc.Exc_located (_, _) as exc -> begin
        eprintf "%s@." (Printexc.to_string exc);
        raise exc
    end
    | exc -> begin
        eprintf "%s@." (Printexc.to_string exc);
        FanLoc.raise (get_prev_loc ts) exc
    end];

let lex entry loc cs = entry.egram.glexer loc cs;

let lex_string entry loc str = lex entry loc (XStream.of_string str);

let filter entry ts =
  keep_prev_loc (FanTokenFilter.filter (get_filter entry.egram) ts);

let parse_origin_tokens entry ts = Action.get (action_parse entry ts);

let filter_and_parse_tokens entry ts =
  parse_origin_tokens entry (filter entry ts);

let parse entry loc cs = filter_and_parse_tokens entry (lex entry loc cs);

let parse_string entry loc str =
  filter_and_parse_tokens entry (lex_string entry loc str);

let of_parser g n (p : XStream.t (FanToken.token * token_info) -> 'a)   =
  let f ts = Action.mk (p ts) in {
  egram = g;
  ename = n;
  estart _ = f;
  econtinue _ _ _ = parser [];
  edesc = Dparser f };

let setup_parser e (p : XStream.t (FanToken.token * token_info) -> 'a) =
  let f ts = Action.mk (p ts) in begin
    e.estart <- fun _ -> f;
    e.econtinue <- fun _ _ _ -> parser [];
    e.edesc <- Dparser f
  end;

let clear e = begin 

      e.estart <- fun _ -> parser [];
      e.econtinue <- fun _ _ _ -> parser [];
      e.edesc <- Dlevels []
end;

let obj x = x;


