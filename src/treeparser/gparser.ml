
  
open Util
  

  


let with_loc (parse_fun: 'b Tokenf.parse ) strm =
  let bp = Token_stream.cur_loc strm in
  let x = parse_fun strm in
  let ep = Token_stream.prev_loc strm in
  let loc =
    if bp.loc_start.pos_cnum > ep.loc_end.pos_cnum then 
      Location_util.join bp
    else Locf.merge bp ep (* normal case when consumed something *)in
  (x, loc)


let level_number (entry:Gdefs.entry) (lab:int) =
  let rec lookup n = function
    | [] ->
        begin
          Gprint.dump#entry Format.err_formatter entry;
          failwithf "unknown level %d in entry %s:" lab entry.name
        end
           
    | (lev:Gdefs.level) :: levs ->
        if  lev.level = lab then n else lookup (1 + n) levs  in
  lookup 0 entry.levels
        

(* in case of syntax error, the system attempts to recover the error by applying
   the [continue] function of the previous symbol(if the symbol is a call to an entry),
   so there's no behavior difference between [LA] and [NA]
 *)
        
module ArgContainer= Stack
  
let rec parser_of_tree (entry:Gdefs.entry)
    (lev,lassoc) (q: Gaction.t ArgContainer.t ) (x:Gdefs.tree) :
    (Obj.t * Locf.t) Tokenf.parse =
  (*
    Given a tree, return a parser which has the type
    [parse Gaction.t]. Think about [node son], only son owns the action,
    so the action returned by son is a function,
    it is to be applied by the value returned by node.
   *)
  let rec from_tree (tree:Gdefs.tree) : Gdefs.anno_action Tokenf.parse =
    match tree  with
    | DeadEnd -> raise Streamf.NotConsumed (* FIXME be more preicse *)
    | LocAct act -> fun _ -> act
          (* rules ending with [S] , for this last symbol there's a call to the [start]
             function:
             of the current level if the level is [`RA] or of the next level otherwise.
                 (see [start_parser_of_levels]) *)      
    | Node {node = Self; son = LocAct act; brother = bro} ->  fun strm ->
        begin 
          let alevn = if lassoc then lev + 1 else lev in
          try
            let a = with_loc (entry.start alevn) strm in
            ArgContainer.push (fst a) q;
            act 
          with Streamf.NotConsumed -> from_tree bro strm
        end
     (* invariant: [son] will never be [DeadEnd] *)        
    | Node ({ node ; son; brother } as y) ->
        match Gtools.get_terminals  y with
        | None ->
            (* [paser_of_symbol] given a stream should always return a value  *) 
            (let ps = parser_of_symbol entry node  in fun strm ->
              let bp = Token_stream.cur_loc strm in
              (try
                let a = ps strm in
                fun ()  ->
                  ArgContainer.push (fst a) q;
                  (let pson = from_tree son in
                  try pson strm
                  with  e ->
                    (ignore (ArgContainer.pop q);
                     (match e with
                     | Streamf.NotConsumed  ->
                         if Token_stream.cur_loc strm = bp
                         then raise Streamf.NotConsumed (* could call brother?*)
                         else
                           raise @@ Streamf.Error (Gfailed.tree_failed  entry a node son)
                     | _ -> raise e)))
              with Streamf.NotConsumed  -> (fun ()  -> from_tree brother strm)) ())

        | Some (tokl, node, son) -> fun strm ->
            match parser_of_terminals tokl strm with
            | None -> from_tree brother strm
            | Some args ->
                let args = List.rev args in
                List.iter (fun a  -> ArgContainer.push (Gaction.mk a) q) args;
                (let len = List.length args in
                let p = from_tree son in
                try p strm
                with e ->
                    (for _i = 1 to len do ignore (ArgContainer.pop q) done;
                     (match e with
                     | Streamf.NotConsumed  ->
                         raise (Streamf.Error
                              (Gfailed.tree_failed  entry e (Token node) son))
                     | _ -> raise e))) in
  let parse = from_tree x in
  fun strm -> 
    let (x,loc) =  with_loc parse strm in 
    let ans = ref x.fn in
    (for _i = 1 to x.arity do
      let  v = ArgContainer.pop q in
      ans := Gaction.apply !ans v;   
    done;
     (!ans,loc))


and parser_of_terminals
    (terminals:Tokenf.pattern list)  :Obj.t list option  Tokenf.parse =
  fun strm ->
    let module M = struct exception X end in
    let n = List.length terminals in
    let acc = ref [] in 
      try
        terminals
        |>
          List.iteri
            (fun i (terminal : Tokenf.pattern)  -> 
              let t  =
                match Streamf.peek_nth strm i with
                | Some t -> t 
                | None -> raise M.X  in
              let ((_,obj) as v) = Tokenf.destruct t in
              begin
                if not
                    (let p  =Tokenf.match_token terminal in
                    begin
                      acc:= obj ::!acc;
                      p v 
                    end)
                then raise M.X
              end);
        Streamf.njunk n strm;
        Some (!acc)
      with M.X -> None 

(* functional and re-entrant *)
and parser_of_symbol (entry : Gdefs.entry) (s:Gdefs.symbol)
    : (Gaction.t * Locf.t) Tokenf.parse  =
  let rec aux (s:Gdefs.symbol) = 
    match s with 
    | List0 s ->
        let ps = aux s in  Gcomb.slist0 ps ~f:(fun l -> Gaction.mk (List.rev l))
    | List0sep (symb, sep) ->
        let ps = aux symb and pt =  aux sep  in
        Gcomb.slist0sep ps pt ~err:(fun v -> Gfailed.symb_failed entry v sep symb)
          ~f:(fun l -> Gaction.mk (List.rev l))
    | List1 s -> let ps =  aux s  in
      Gcomb.slist1 ps ~f:(fun l -> Gaction.mk (List.rev l))
    | List1sep (symb, sep) ->
        let ps = aux symb and pt = aux sep  in
        Gcomb.slist1sep ps pt ~err:(fun v -> Gfailed.symb_failed entry v sep symb)
          ~f:(fun l -> Gaction.mk (List.rev l))
    | Try s -> let ps = aux s in Gcomb.tryp ps
    | Peek s -> let ps = aux s in Gcomb.peek ps
    | Snterml (e, l) -> fun strm -> e.start (level_number e l) strm
    | Nterm e -> fun strm -> e.start 0 strm  
    | Self -> fun strm -> entry.start 0 strm 
    | Token (x:Tokenf.pattern) ->
        let p = Tokenf.match_token x in 
        fun strm ->
          match Streamf.peek strm with
          |Some tok ->
              let ((_,obj) as v) = Tokenf.destruct tok in
              if p v then
                (Streamf.junk strm; obj )
              else  raise Streamf.NotConsumed
          |_ -> raise Streamf.NotConsumed in
  with_loc (aux s)




(* entrance for the start [clevn] is the current level *)  
let start_parser_of_levels entry =
  let rec aux clevn  (xs:  Gdefs.level list) : int ->  Gaction.t Tokenf.parse =
    match xs with 
    | [] -> fun _ -> fun _ -> raise Streamf.NotConsumed  
    | lev :: levs ->
        let hstart = aux  (clevn+1) levs in
        match lev.lprefix with
        | DeadEnd -> hstart (* try the upper levels *)
        | tree ->
            let cstart = 
              parser_of_tree entry (clevn, lev.lassoc) (ArgContainer.create ())tree  in
            (* the [start] function tires its associated tree. If it works
               it calls the [continue] function of the same level, giving the
               result of [start] as parameter.
               If this continue fails, the parameter is simply returned.
               If this [start] function fails, the start function of the
               next level is tested, if there is no more levels, the parsing fails
             *)    
            fun levn strm ->
              if levn > clevn && (not ([]=levs))then
                hstart levn strm (* only higher level allowed here *)
              else
                (try
                  let (act,loc) = cstart strm in
                  fun ()  ->
                    let a = Gaction.apply act loc in entry.continue levn loc a strm
                with  Streamf.NotConsumed  -> (fun ()  -> hstart levn strm)) () in
  aux 0
    
let start_parser_of_entry (entry:Gdefs.entry) =
  match entry.levels with
  | [] -> Gtools.empty_entry entry.name
  | elev -> start_parser_of_levels entry  elev

    


let rec continue_parser_of_levels entry clevn (xs:Gdefs.level list) =
  match xs with 
  | [] -> fun _ _ _ ->  fun _ -> raise Streamf.NotConsumed
  | lev :: levs ->
      let hcontinue = continue_parser_of_levels entry  (clevn+1) levs in
      match lev.lsuffix with
      | DeadEnd -> hcontinue
          (* the continue function first tries the [continue] function of the next level,
             if it fails or if it's the last level, it tries its associated tree, then
             call itself again, giving the result as parameter. If the associated tree
             fails, it returns its extra parameter
           *)
      | tree ->
        let ccontinue = parser_of_tree entry
            (clevn, lev.lassoc) (ArgContainer.create ()) tree in
        fun levn bp a strm ->
          if levn > clevn then
            hcontinue levn bp a strm
          else
            try hcontinue levn bp a strm
            with
            | Streamf.NotConsumed ->
              let (act,loc) = ccontinue strm in
              let loc = Locf.merge bp loc in
              let a = Gaction.apply2 act a loc in entry.continue levn loc a strm

  
let continue_parser_of_entry (entry:Gdefs.entry) =
  let p = continue_parser_of_levels entry 0 entry.levels  in
  (fun levn bp a strm -> try p levn bp a strm with Streamf.NotConsumed -> a )


(* local variables: *)
(* compile-command: "cd .. && pmake treeparser/gparser.cmo" *)
(* end: *)
