%import{
Ast_quotation:
  add_quotation
  ;
Ast_gen:
  loc_of
  ;
};;

let stringnize  = [
  ("nativeint'",Some %exp-{Nativeint.to_string});
  ("int'", Some %exp-{string_of_int });
  ("int32'",Some %exp-{Int32.to_string});
  ("int64'",Some %exp-{Int64.to_string});
  ("chr'",Some %exp-{Char.escaped});
  ("str'",Some %exp-{String.escaped});
  ("flo'",Some %exp-{string_of_float});
  ("bool'",None) ]

let expander ant_annot = object
  inherit Objs.map as super
  method! pat (x:Astf.pat)= 
    match x with 
    |`Ant(_loc, x) ->
      let meta_loc_pat _loc _ =  %pat{ _ } in
      let mloc _loc = meta_loc_pat  _loc _loc in
      (*
        (x:int:>int) is an invalid pattern --
        we can not put rigid type annotations here,
        so for the pat, we simply ignore it, which does
        not hurt the user experience too much. *)
      let e = Tokenf.ant_expand Parsef.pat x   in
      begin 
        match (x.kind,x.cxt) with
        | (("uid" | "lid" | "par" | "seq"
        |"flo" |"int" | "int32" | "int64" |"nativeint"
        |"chr" |"str" as x),_) |
          (("vrn" as x), Some ("exp" |"pat")) ->
            let x = String.capitalize x in
            %pat{ $vrn:x (${mloc _loc},$e) }
        | _ -> super#pat e
      end
    | e -> super#pat e 
  method! exp (x:Astf.exp) =  with exp
    match x with 
    |`Ant(_loc, x) ->
        let meta_loc_exp _loc loc =
          match !Ast_quotation.current_loc_name with
          | Some "here" -> %exp{ ${Ast_gen.meta_here _loc loc}}
          | x ->
              let x = Option.default !Locf.name  x in
              %exp{$lid:x} in
      let mloc _loc = meta_loc_exp _loc _loc  in (* FIXME Simplify*)
      let e = Tokenf.ant_expand Parsef.exp x in
      (match (x.kind,x.cxt) with
      |(("uid" | "lid" 
      |"flo" |"int" | "int32" | "int64" |"nativeint"
      |"chr" |"str" | "par" | "seq" as x),_) ->
          %{$vrn{String.capitalize x} (${mloc _loc},$e) }
      | (("vrn" as x), Some ("exp" |"pat" |"ep")) ->

           %{$vrn{String.capitalize x} (${mloc _loc},$e) }
      | (("nativeint'" | "int'"|"int32'"|"int64'"|"chr'"|"str'"|"flo'"|"bool'" as x),_) ->
          let v =
            match List.assoc x stringnize with
            | Some x -> let  x = Fill.exp _loc x in %exp{$x $e}
            | None -> e in
          let s = String.sub x 0 (String.length x - 1) |> String.capitalize in
          %exp{$vrn:s (${mloc _loc}, $v)}
      | (_, ty) -> 
          let e =
            match (ty, ant_annot) with
            | (Some ty, true) ->
                 %exp{ ($e:> Astf.$lid:ty)}
            | _ -> e  in
            super#exp e)
    | e -> super#exp e
   
  end

    
let expandern ant_annot  = object
  inherit Objs.map as super;
  method! pat (x:Astf.pat)= 
    match x with 
    |`Ant(_loc, x) ->
      let e = Tokenf.ant_expand Parsef.pat  x in
      (match (x.kind,x.cxt) with
      | (("uid" | "lid" | "par" | "seq"
      |"flo" |"int" | "int32" | "int64" |"nativeint"
      |"chr" |"str" as x),_) | (("vrn" as x), Some ("exp" |"pat")) ->
          let x = String.capitalize x in %pat{$vrn:x $e }
      | _ -> super#pat e)
    | e -> super#pat e 
  method! exp (x:Astf.exp) = 
    match x with 
    |`Ant(_loc,x) ->
      let e = Tokenf.ant_expand Parsef.exp x  in
      (match (x.kind, x.cxt) with
      |(("uid" | "lid" | "par" | "seq"
      |"flo" |"int" | "int32" | "int64" |"nativeint"
      |"chr" |"str" as x),_) | (("vrn" as x), Some ("exp" |"pat"|"ep")) ->
           %exp{$vrn{String.capitalize x} $e }
      | (("nativeint'" | "int'"|"int32'"|"int64'"|"chr'"|"str'"|"flo'"|"bool'" as x),_) ->
          let v =
            match List.assoc x stringnize with
            | Some x -> let  x = Fill.exp _loc x in %exp{$x $e}
            | None -> e in
          let s = String.sub x 0 (String.length x - 1) |> String.capitalize in
          %exp{$vrn:s $v}
      | (_, ty) -> 
          let e =
            match (ty, ant_annot) with
            | (Some ty, true) ->
                 %exp{ ($e:> Astfn.$lid:ty)}
            | _ -> e  in
            super#exp e)
    | e -> super#exp e
  end
    

open Syntaxf
open Astf



let v = (expander false)
let u = (expander true)
let exp_filter (x:ep) = v#exp  (x:>exp)

let pat_filter (x:ep) = v#pat  (x:>pat)



let efilter str (e:ep) =
    let e = u#exp (e:>exp) in
    let _loc = loc_of e in
    %exp{($e :> Astf.$lid:str)} (* BOOTSTRAPPING, assocaited with module [Astf] *)
      

let pfilter str (e:ep) =
  let p = u#pat (e:>pat) in
  let _loc = loc_of p in
  %pat{($p : Astf.$lid:str)} (* BOOTSTRAPPING, associated with module [Astf] *);;


let domain = `Absolute ["Fan"; "Lang"; "Meta"]

let me = object
  inherit Metaf.meta;
  method! loc _loc loc =
    match !Ast_quotation.current_loc_name with
    | None -> `Lid (_loc, !Locf.name)
    | Some "here" ->
        Ast_gen.meta_here _loc loc
    | Some x ->  `Lid(_loc,x) 
end
let mp = object
  inherit Metaf.meta
  method! loc _loc _ = %pat'{ _ } (* we use [subst_first_loc] *)    
end

let m = new Metafn.meta    

let _ = begin 
  add_quotation {domain; name =  "sigi'"} sigi_quot
    ~mexp:me#sigi
    ~mpat:mp#sigi
    ~exp_filter
    ~pat_filter;

  add_quotation {domain; name =  "stru'"} stru_quot
    ~mexp:(me#stru)
    ~mpat:(mp#stru)
    ~exp_filter
    ~pat_filter;

  add_quotation {domain; name =  "ctyp'"} ctyp_quot
    ~mexp:(me#ctyp)
    ~mpat:(mp#ctyp)
    ~exp_filter
    ~pat_filter;
  
  add_quotation {domain; name =  "pat'"} pat_quot ~mexp:(me#pat)
    ~mpat:(mp#pat) ~exp_filter ~pat_filter;
  add_quotation {domain; name =  "exp'"} exp_quot ~mexp:(me#exp)
    ~mpat:(mp#exp) ~exp_filter ~pat_filter;
  add_quotation {domain; name =  "ep'"} ep ~mexp:me#ep
    ~mpat:mp#ep ~exp_filter ~pat_filter;

  add_quotation {domain; name =  "mtyp'"} mtyp_quot ~mexp:(me#mtyp)
    ~mpat:(mp#mtyp) ~exp_filter ~pat_filter;
  add_quotation {domain; name =  "mexp'"} mexp_quot ~mexp:(me#mexp)
    ~mpat:(mp#mexp) ~exp_filter ~pat_filter;
  add_quotation {domain; name =  "cltyp'"} cltyp_quot ~mexp:(me#cltyp)
    ~mpat:(mp#cltyp) ~exp_filter ~pat_filter;
  add_quotation {domain; name =  "clexp'"} clexp_quot ~mexp:(me#clexp)
    ~mpat:(mp#clexp) ~exp_filter ~pat_filter;
  add_quotation {domain; name =  "clsigi'"} clsigi_quot ~mexp:(me#clsigi)
    ~mpat:(mp#clsigi) ~exp_filter ~pat_filter;
  add_quotation {domain; name =  "clfield'"} clfield_quot ~mexp:(me#clfield)
    ~mpat:(mp#clfield) ~exp_filter ~pat_filter;
  add_quotation {domain; name =  "constr'"} constr_quot ~mexp:(me#constr)
    ~mpat:(mp#constr) ~exp_filter ~pat_filter;
  add_quotation {domain; name =  "bind'"} bind_quot ~mexp:(me#bind)
    ~mpat:(mp#bind) ~exp_filter ~pat_filter;
  add_quotation {domain; name =  "rec_exp'"} rec_exp_quot ~mexp:(me#rec_exp)
    ~mpat:(mp#rec_exp) ~exp_filter ~pat_filter;
  add_quotation {domain; name =  "case'"} case_quot ~mexp:(me#case)
    ~mpat:(mp#case) ~exp_filter ~pat_filter;
  add_quotation {domain; name =  "mbind'"} mbind_quot ~mexp:(me#mbind)
    ~mpat:(mp#mbind) ~exp_filter ~pat_filter;
  add_quotation {domain; name =  "ident'"} ident_quot ~mexp:(me#ident)
    ~mpat:(mp#ident) ~exp_filter ~pat_filter;
  add_quotation {domain; name =  "rec_flag'"} rec_flag_quot ~mexp:(me#flag)
    ~mpat:(mp#flag) ~exp_filter ~pat_filter;
  add_quotation {domain; name =  "private_flag'"} private_flag_quot
    ~mexp:(me#flag) ~mpat:(mp#flag)
    ~exp_filter ~pat_filter;
  add_quotation {domain; name =  "row_var_flag'"} row_var_flag_quot
    ~mexp:(me#flag) ~mpat:(mp#flag)
    ~exp_filter ~pat_filter;
  add_quotation {domain; name =  "mutable_flag'"} mutable_flag_quot
    ~mexp:(me#flag) ~mpat:(mp#flag)
    ~exp_filter ~pat_filter;
  add_quotation {domain; name =  "virtual_flag'"} virtual_flag_quot
    ~mexp:(me#flag) ~mpat:(mp#flag)
    ~exp_filter ~pat_filter;
  add_quotation {domain; name =  "override_flag'"} override_flag_quot
    ~mexp:(me#flag) ~mpat:(mp#flag)
    ~exp_filter ~pat_filter;
  add_quotation {domain; name =  "direction_flag'"} direction_flag_quot
    ~mexp:(me#flag) ~mpat:(mp#flag)
    ~exp_filter ~pat_filter;
  add_quotation {domain; name =  "or_ctyp'"} constructor_declarations
    ~mexp:(me#or_ctyp) ~mpat:(me#or_ctyp) ~exp_filter
    ~pat_filter;
  add_quotation {domain; name =  "row_field'"} row_field ~mexp:(me#row_field)
    ~mpat:(mp#row_field) ~exp_filter ~pat_filter
end;;


(* %register{ *)
(*   quotation: (row_field, direction_flag,override_flag,or_ctyp,clfield); *)
(*   mexp: (object:me, method:quotation); *)
(*   mpat: (object:mp, method:quotation) ; *)
(* };; *)
    
let _ = begin
  add_quotation {domain; name =  "sigi"} sigi_quot ~mexp:(me#sigi)
    ~mpat:(mp#sigi) ~exp_filter:(efilter "sigi")
    ~pat_filter:(pfilter "sigi");
  add_quotation {domain; name =  "stru"} stru_quot ~mexp:(me#stru)
    ~mpat:(mp#stru) ~exp_filter:(efilter "stru")
    ~pat_filter:(pfilter "stru");
  add_quotation {domain; name =  "ctyp"} ctyp_quot ~mexp:(me#ctyp)
    ~mpat:(mp#ctyp) ~exp_filter:(efilter "ctyp")
    ~pat_filter:(pfilter "ctyp");
  add_quotation {domain; name =  "pat"} pat_quot ~mexp:(me#pat)
    ~mpat:(mp#pat) ~exp_filter:(efilter "pat")
    ~pat_filter:(pfilter "pat");
  add_quotation {domain; name =  "ep"} ep ~mexp:(me#ep) (* FIXME *)
    ~mpat:(mp#ep) ~exp_filter:(efilter "ep")
    ~pat_filter:(pfilter "ep");
  add_quotation {domain; name =  "exp"} exp_quot ~mexp:(me#exp)
    ~mpat:(mp#exp) ~exp_filter:(efilter "exp")
    ~pat_filter:(pfilter "exp");
  add_quotation {domain; name =  "mtyp"} mtyp_quot ~mexp:(me#mtyp)
    ~mpat:(mp#mtyp) ~exp_filter:(efilter "mtyp")
    ~pat_filter:(pfilter "mtyp");
  add_quotation {domain; name =  "mexp"} mexp_quot ~mexp:(me#mexp)
    ~mpat:(mp#mexp) ~exp_filter:(efilter "mexp")
    ~pat_filter:(pfilter "mexp");
  add_quotation {domain; name =  "cltyp"} cltyp_quot ~mexp:(me#cltyp)
    ~mpat:(mp#cltyp) ~exp_filter:(efilter "cltyp")
    ~pat_filter:(pfilter "cltyp");
  add_quotation {domain; name =  "clexp"} clexp_quot ~mexp:(me#clexp)
    ~mpat:(mp#clexp) ~exp_filter:(efilter "clexp")
    ~pat_filter:(pfilter "clexp");
  add_quotation {domain; name =  "clsigi"} clsigi_quot ~mexp:(me#clsigi)
    ~mpat:(mp#clsigi) ~exp_filter:(efilter "clsigi")
    ~pat_filter:(pfilter "clsigi");
  add_quotation {domain; name =  "clfield"} clfield_quot ~mexp:(me#clfield)
    ~mpat:(mp#clfield) ~exp_filter:(efilter "clfield")
    ~pat_filter:(pfilter "clfield");
  add_quotation {domain; name =  "constr"} constr_quot ~mexp:(me#constr)
    ~mpat:(mp#constr) ~exp_filter:(efilter "constr")
    ~pat_filter:(pfilter "constr");
  add_quotation {domain; name =  "bind"} bind_quot ~mexp:(me#bind)
    ~mpat:(mp#bind) ~exp_filter:(efilter "bind")
    ~pat_filter:(pfilter "bind");
  add_quotation {domain; name =  "rec_exp"} rec_exp_quot ~mexp:(me#rec_exp)
    ~mpat:(mp#rec_exp) ~exp_filter:(efilter "rec_exp")
    ~pat_filter:(pfilter "rec_exp");
  add_quotation {domain; name =  "case"} case_quot ~mexp:(me#case)
    ~mpat:(mp#case) ~exp_filter:(efilter "case")
    ~pat_filter:(pfilter "case");
  add_quotation {domain; name =  "mbind"} mbind_quot ~mexp:(me#mbind)
    ~mpat:(mp#mbind) ~exp_filter:(efilter "mbind")
    ~pat_filter:(pfilter "mbind");
  add_quotation {domain; name =  "ident"} ident_quot ~mexp:(me#ident)
    ~mpat:(mp#ident) ~exp_filter:(efilter "ident")
    ~pat_filter:(pfilter "ident");
  add_quotation {domain; name =  "or_ctyp"} constructor_declarations
    ~mexp:(me#or_ctyp) ~mpat:(me#or_ctyp)
    ~exp_filter:(efilter "or_ctyp") ~pat_filter:(pfilter "or_ctyp");
  add_quotation {domain; name =  "row_field"} row_field ~mexp:(me#row_field)
    ~mpat:(mp#row_field) ~exp_filter:(efilter "row_field")
    ~pat_filter:(pfilter "row_field");
end
;;

(****************************************)
(* side effect                          *)
(****************************************)




(*************************************************************************)
(** begin quotation for Astf without locations *)

let v = expandern false
let u = expandern true
    
let exp_filter_n (x:ep) =
  v#exp   (x:>exp)
let pat_filter_n (x:ep) =
  v#pat (x:>pat)

let efilter str (e:ep) =
    let e = u#exp (e:>exp) in
    let _loc = loc_of e in
    %exp{($e :> Astfn.$lid:str)} (* BOOTSTRAPPING, associated with module [Astfn] *)

let pfilter str (e:ep) =
  let p = u#pat (e:>pat) in
  let _loc = loc_of p in
  %pat{($p : Astfn.$lid:str)};; (* BOOTSTRAPPING, associated with module [Astfn] *)


begin
  add_quotation {domain; name =  "sigi-"} sigi_quot
    ~mexp:(fun loc p -> m#sigi loc (Strip.sigi p))
    ~mpat:(fun loc p -> m#sigi loc (Strip.sigi p))
    ~exp_filter:(efilter "sigi")
    ~pat_filter:(pfilter "sigi");

  add_quotation {domain; name =  "stru-"} stru_quot
    ~mexp:(fun loc p -> m#stru loc (Strip.stru p))
    ~mpat:(fun loc p -> m#stru loc (Strip.stru p))
    ~exp_filter:(efilter "stru")
    ~pat_filter:(pfilter "stru");
  
  add_quotation {domain; name =  "ctyp-"} ctyp_quot
    ~mexp:(fun loc p -> m#ctyp loc (Strip.ctyp p))
    ~mpat:(fun loc p -> m#ctyp loc (Strip.ctyp p))
    ~exp_filter:(efilter "ctyp")
    ~pat_filter:(pfilter "ctyp");
  
  add_quotation {domain; name =  "pat-"} pat_quot
    ~mexp:(fun loc p -> m#pat loc (Strip.pat p))
    ~mpat:(fun loc p -> m#pat loc (Strip.pat p))
    ~exp_filter:(efilter "pat")
    ~pat_filter:(pfilter "pat");

  add_quotation {domain; name =  "ep-"} ep
    ~mexp:(fun loc p -> m#ep loc (Strip.ep p))
    ~mpat:(fun loc p -> m#ep loc (Strip.ep p))
    ~exp_filter:(efilter "ep")
    ~pat_filter:(pfilter "ep");
  
  add_quotation {domain; name =  "exp-"} exp_quot
    ~mexp:(fun loc p -> m#exp loc (Strip.exp p))
    ~mpat:(fun loc p -> m#exp loc (Strip.exp p))
    ~exp_filter:(efilter "exp")
    ~pat_filter:(pfilter "exp");

  add_quotation {domain; name =  "mtyp-"} mtyp_quot
    ~mexp:(fun loc p -> m#mtyp loc (Strip.mtyp p))
    ~mpat:(fun loc p -> m#mtyp loc (Strip.mtyp p))
    ~exp_filter:(efilter "mtyp")
    ~pat_filter:(pfilter "mtyp");
  
  add_quotation {domain; name =  "mexp-"} mexp_quot
    ~mexp:(fun loc p -> m#mexp loc (Strip.mexp p))
    ~mpat:(fun loc p -> m#mexp loc (Strip.mexp p))
    ~exp_filter:(efilter "mexp")
    ~pat_filter:(pfilter "mexp");
  
  add_quotation {domain; name =  "cltyp-"} cltyp_quot
    ~mexp:(fun loc p -> m#cltyp loc (Strip.cltyp p))
    ~mpat:(fun loc p -> m#cltyp loc (Strip.cltyp p))
    ~exp_filter:(efilter "cltyp")
    ~pat_filter:(pfilter "cltyp");
  
  add_quotation {domain; name =  "clexp-"} clexp_quot
    ~mexp:(fun loc p -> m#clexp loc (Strip.clexp p))
    ~mpat:(fun loc p -> m#clexp loc (Strip.clexp p))
    ~exp_filter:(efilter "clexp")
    ~pat_filter:(pfilter "clexp");
  
  add_quotation {domain; name =  "clsigi-"} clsigi_quot
    ~mexp:(fun loc p -> m#clsigi loc (Strip.clsigi p))
    ~mpat:(fun loc p -> m#clsigi loc (Strip.clsigi p))
    ~exp_filter:(efilter "clsigi")
    ~pat_filter:(pfilter "clsigi");

  add_quotation {domain; name =  "clfield-"} clfield_quot
    ~mexp:(fun loc p -> m#clfield loc (Strip.clfield p))
    ~mpat:(fun loc p -> m#clfield loc (Strip.clfield p))
    ~exp_filter:(efilter "clfield")
    ~pat_filter:(pfilter "clfield");
  
  add_quotation {domain; name =  "constr-"} constr_quot
    ~mexp:(fun loc p -> m#constr loc (Strip.constr p))
    ~mpat:(fun loc p -> m#constr loc (Strip.constr p))
    ~exp_filter:(efilter "constr")
    ~pat_filter:(pfilter "constr");

  add_quotation {domain; name =  "bind-"} bind_quot
    ~mexp:(fun loc p -> m#bind loc (Strip.bind p))
    ~mpat:(fun loc p -> m#bind loc (Strip.bind p))
    ~exp_filter:(efilter "bind")
    ~pat_filter:(pfilter "bind");

  add_quotation {domain; name =  "rec_exp-"} rec_exp_quot
    ~mexp:(fun loc p -> m#rec_exp loc (Strip.rec_exp p))
    ~mpat:(fun loc p -> m#rec_exp loc (Strip.rec_exp p))
    ~exp_filter:(efilter "rec_exp")
    ~pat_filter:(pfilter "rec_exp");

  add_quotation {domain; name =  "case-"} case_quot
    ~mexp:(fun loc p -> m#case loc (Strip.case p))
    ~mpat:(fun loc p -> m#case loc (Strip.case p)) 
    ~exp_filter:(efilter "case")
    ~pat_filter:(pfilter "case");

  add_quotation {domain; name =  "mbind-"} mbind_quot
    ~mexp:(fun loc p -> m#mbind loc (Strip.mbind p))
    ~mpat:(fun loc p -> m#mbind loc (Strip.mbind p))
    ~exp_filter:(efilter "mbind")
    ~pat_filter:(pfilter "mbind");

  add_quotation {domain; name =  "ident-"} ident_quot
    ~mexp:(fun loc p -> m#ident loc (Strip.ident p))
    ~mpat:(fun loc p -> m#ident loc (Strip.ident p))
    ~exp_filter:(efilter "ident")
    ~pat_filter:(pfilter "ident");
  
  add_quotation {domain; name =  "or_ctyp-"} constructor_declarations
    ~mexp:(fun loc p -> m#or_ctyp loc (Strip.or_ctyp p))
    ~mpat:(fun loc p -> m#or_ctyp loc (Strip.or_ctyp p))
    ~exp_filter:(efilter "or_ctyp")
    ~pat_filter:(pfilter "or_ctyp");
  
  add_quotation {domain; name =  "row_field-"}
    row_field ~mexp:(fun loc p -> m#row_field loc (Strip.row_field p))
    ~mpat:(fun loc p -> m#row_field loc (Strip.row_field p))
    ~exp_filter:(efilter "row_field")
    ~pat_filter:(pfilter "row_field");
end;;


let exp_filter = exp_filter_n in
let pat_filter = pat_filter_n in
begin
    add_quotation {domain; name =  "sigi-'"} sigi_quot ~mexp:(fun loc p -> m#sigi loc (Strip.sigi p))
    ~mpat:(fun loc p -> m#sigi loc (Strip.sigi p))
     ~exp_filter
    ~pat_filter;
  add_quotation {domain; name =  "stru-'"} stru_quot ~mexp:(fun loc p -> m#stru loc (Strip.stru p))
    ~mpat:(fun loc p -> m#stru loc (Strip.stru p)) ~exp_filter
    ~pat_filter;
  add_quotation {domain; name =  "ctyp-'"} ctyp_quot ~mexp:(fun loc p -> m#ctyp loc (Strip.ctyp p))
    ~mpat:(fun loc p -> m#ctyp loc (Strip.ctyp p)) ~exp_filter
    ~pat_filter;
  add_quotation {domain; name =  "pat-'"} pat_quot ~mexp:(fun loc p -> m#pat loc (Strip.pat p))
    ~mpat:(fun loc p -> m#pat loc (Strip.pat p)) ~exp_filter
    ~pat_filter;
  
  add_quotation {domain; name =  "ep-'"} ep
    ~mexp:(fun loc p -> m#ep loc (Strip.ep p))
    ~mpat:(fun loc p -> m#ep loc (Strip.ep p))
    ~exp_filter
    ~pat_filter;
  add_quotation {domain; name =  "exp-'"} exp_quot
    ~mexp:(fun loc p -> m#exp loc (Strip.exp p))
    ~mpat:(fun loc p -> m#exp loc (Strip.exp p))
    ~exp_filter
    ~pat_filter;
  add_quotation {domain; name =  "mtyp-'"} mtyp_quot ~mexp:(fun loc p -> m#mtyp loc (Strip.mtyp p))
    ~mpat:(fun loc p -> m#mtyp loc (Strip.mtyp p)) ~exp_filter
    ~pat_filter;
  add_quotation {domain; name =  "mexp-'"} mexp_quot ~mexp:(fun loc p -> m#mexp loc (Strip.mexp p))
    ~mpat:(fun loc p -> m#mexp loc (Strip.mexp p)) ~exp_filter
    ~pat_filter;
  add_quotation {domain; name =  "cltyp-'"} cltyp_quot ~mexp:(fun loc p -> m#cltyp loc (Strip.cltyp p))
    ~mpat:(fun loc p -> m#cltyp loc (Strip.cltyp p)) ~exp_filter
    ~pat_filter;
  add_quotation {domain; name =  "clexp-'"} clexp_quot ~mexp:(fun loc p -> m#clexp loc (Strip.clexp p))
    ~mpat:(fun loc p -> m#clexp loc (Strip.clexp p)) ~exp_filter
    ~pat_filter;
  add_quotation {domain; name =  "clsigi-'"} clsigi_quot ~mexp:(fun loc p -> m#clsigi loc (Strip.clsigi p))
    ~mpat:(fun loc p -> m#clsigi loc (Strip.clsigi p)) ~exp_filter
    ~pat_filter;
  add_quotation {domain; name =  "clfield-'"} clfield_quot ~mexp:(fun loc p -> m#clfield loc (Strip.clfield p))
    ~mpat:(fun loc p -> m#clfield loc (Strip.clfield p)) ~exp_filter
    ~pat_filter;
  add_quotation {domain; name =  "constr-'"} constr_quot ~mexp:(fun loc p -> m#constr loc (Strip.constr p))
    ~mpat:(fun loc p -> m#constr loc (Strip.constr p)) ~exp_filter
    ~pat_filter;
  add_quotation {domain; name =  "bind-'"} bind_quot ~mexp:(fun loc p -> m#bind loc (Strip.bind p))
    ~mpat:(fun loc p -> m#bind loc (Strip.bind p)) ~exp_filter
    ~pat_filter;
  add_quotation {domain; name =  "rec_exp-'"} rec_exp_quot ~mexp:(fun loc p -> m#rec_exp loc (Strip.rec_exp p))
    ~mpat:(fun loc p -> m#rec_exp loc (Strip.rec_exp p)) ~exp_filter
    ~pat_filter;
  add_quotation {domain; name =  "case-'"} case_quot ~mexp:(fun loc p -> m#case loc (Strip.case p))
    ~mpat:(fun loc p -> m#case loc (Strip.case p)) ~exp_filter
    ~pat_filter;
  add_quotation {domain; name =  "mbind-'"} mbind_quot ~mexp:(fun loc p -> m#mbind loc (Strip.mbind p))
    ~mpat:(fun loc p -> m#mbind loc (Strip.mbind p)) ~exp_filter
    ~pat_filter;
  add_quotation {domain; name =  "ident-'"} ident_quot ~mexp:(fun loc p -> m#ident loc (Strip.ident p))
    ~mpat:(fun loc p -> m#ident loc (Strip.ident p)) ~exp_filter
    ~pat_filter;
  add_quotation {domain; name =  "or_ctyp-'"} constructor_declarations
    ~mexp:(fun loc p -> m#or_ctyp loc (Strip.or_ctyp p)) ~mpat:(fun loc p -> m#or_ctyp loc (Strip.or_ctyp p))
    ~exp_filter ~pat_filter;
  add_quotation {domain; name =  "row_field-'"} row_field ~mexp:(fun loc p -> m#row_field loc (Strip.row_field p))
    ~mpat:(fun loc p -> m#row_field loc (Strip.row_field p)) ~exp_filter
    ~pat_filter
end
;;
(* local variables: *)
(* compile-command: "cd .. && pmake  main_annot/quasiquot.cmo" *)
(* end: *)
