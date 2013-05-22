open Format

open Ast

open LibUtil

let sigi_printer =
  ref
    (fun ?input_file:_  ?output_file:_  _  -> failwith "No interface printer")

let stru_printer =
  ref
    (fun ?input_file:_  ?output_file:_  _  ->
       failwith "No implementation printer")

type 'a parser_fun =
  ?directive_handler:('a -> 'a option) -> loc -> char XStream.t -> 'a option 

type 'a printer_fun =
  ?input_file:string -> ?output_file:string -> 'a option -> unit 

let register_text_printer () =
  let print_implem ?input_file:_  ?output_file  ast =
    let pt = match ast with | None  -> [] | Some ast -> Ast2pt.stru ast in
    FanUtil.with_open_out_file output_file
      (fun oc  ->
         let fmt = Format.formatter_of_out_channel oc in
         let () = AstPrint.structure fmt pt in pp_print_flush fmt ()) in
  let print_interf ?input_file:_  ?output_file  ast =
    let pt = match ast with | None  -> [] | Some ast -> Ast2pt.sigi ast in
    FanUtil.with_open_out_file output_file
      (fun oc  ->
         let fmt = Format.formatter_of_out_channel oc in
         let () = AstPrint.signature fmt pt in pp_print_flush fmt ()) in
  begin stru_printer := print_implem; sigi_printer := print_interf end

let register_bin_printer () =
  let print_interf ?(input_file= "-")  ?output_file  ast =
    let pt = match ast with | None  -> [] | Some ast -> Ast2pt.sigi ast in
    let open FanUtil in
      with_open_out_file output_file
        (dump_pt FanConfig.ocaml_ast_intf_magic_number input_file pt) in
  let print_implem ?(input_file= "-")  ?output_file  ast =
    let pt = match ast with | None  -> [] | Some ast -> Ast2pt.stru ast in
    let open FanUtil in
      with_open_out_file output_file
        (dump_pt FanConfig.ocaml_ast_impl_magic_number input_file pt) in
  begin stru_printer := print_implem; sigi_printer := print_interf end

let wrap directive_handler pa init_loc cs =
  let rec loop loc =
    let (pl,stopped_at_directive) = pa loc cs in
    match stopped_at_directive with
    | Some new_loc ->
        let pl =
          match List.rev pl with
          | [] -> assert false
          | x::xs ->
              (match directive_handler x with
               | None  -> xs
               | Some x -> x :: xs) in
        (List.rev pl) @ (loop (FanLoc.join_end new_loc))
    | None  -> pl in
  loop init_loc

let parse_implem ?(directive_handler= fun _  -> None)  loc cs =
  let l = wrap directive_handler (Gram.parse Syntax.implem) loc cs in
  match l with | [] -> None | l -> Some (AstLib.sem_of_list l)

let parse_interf ?(directive_handler= fun _  -> None)  loc cs =
  let l = wrap directive_handler (Gram.parse Syntax.interf) loc cs in
  match l with | [] -> None | l -> Some (AstLib.sem_of_list l)

let parse_file ?directive_handler  name pa =
  let loc = FanLoc.mk name in
  let print_warning = eprintf "%a:\n%s@." FanLoc.print in
  let () = Syntax.current_warning := print_warning in
  let ic = if name = "-" then stdin else open_in_bin name in
  let clear () = if name = "-" then () else close_in ic in
  let cs = XStream.of_channel ic in
  finally ~action:clear (pa ?directive_handler loc) cs

module CurrentPrinter =
  struct
    let print_interf ?input_file  ?output_file  ast =
      sigi_printer.contents ?input_file ?output_file ast
    let print_implem ?input_file  ?output_file  ast =
      stru_printer.contents ?input_file ?output_file ast
  end