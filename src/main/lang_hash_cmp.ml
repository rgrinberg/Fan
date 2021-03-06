

%create{hash_p};;
begin
  %extend{
  hash_p:
  [L1 Str SEP "|" as xs %{
   let p =
     Ast_gen.bar_of_list
       (List.map
       (fun (x:Tokenf.txt) ->
         let v = x.txt in
         let i = Hashtbl.hash v  in
         %case{$int':i -> s = $str:v}) xs) in
   %exp{fun (s:string) -> (function | $p | _ -> false )} }]};
  %register{
   position:exp;
   name:hash_cmp;
   entry:hash_p
  }
end;;  

(*
%extend{
  (* %create{hash_p}; *)
  hash_p@Local:
  [L1 Str SEP "|" as xs %{
   let p =
     Ast_gen.bar_of_list
       (List.map
         (fun (x:Tokenf.txt) ->
           let v = x.txt in
           let i = Hashtbl.hash v  in
           %case{$int':i -> s = $str:v}) xs) in
   %exp{fun (s:string) ->
         (function | $p | _ -> false )} }]
  %{
  entry:hash_p;
  name: hash_p;
  position: exp;
  }
}
*)  
