(* Character sets are represented as lists of intervals.
   The intervals must be non-overlapping and not collapsable, 
   and the list must be ordered in increasing order. *)

type t = (int * int) list

let max_code = 0x10ffff  (* must be < max_int *)
let min_code = -1

let empty = []
let singleton i = [i,i]
let is_empty = function [] -> true | _ -> false
let interval i j = if i <= j then [i,j] else [j,i]
let eof = singleton (-1)
let any = interval 0 max_code

let print ppf l =
  Format.fprintf ppf "[ ";
  List.iter (fun (i,j) -> Format.fprintf ppf "%i-%i " i j) l;
  Format.fprintf ppf "]"

let dump l =
  print Format.std_formatter l

(*
  Example:
  {[
  Cset.union [(1,3);(5,7);(9,11)] [(2,4);(6,8);(10,12)];
  - : (int * int) list = [(1, 12)]
  ]}
 *)    
let rec union c1 c2 =
  match c1,c2 with
  | [], _ -> c2
  | _, [] -> c1
  | ((i1,j1) as s1)::r1, (i2,j2)::r2 ->
      if (i1 <= i2) then
	if j1 + 1 < i2 then s1::(union r1 c2)
	else if (j1 < j2) then union r1 ((i1,j2)::r2)
	else union c1 r2
      else union c2 c1

let complement c =
  let rec aux start = function
    | [] -> if start <= max_code then [start,max_code] else []
    | (i,j)::l -> (start,i-1)::(aux (succ j) l) in
  match c with
    | (-1,j)::l -> aux (succ j) l
    | l -> aux (-1) l

let intersection c1 c2 = 
  complement (union (complement c1) (complement c2))


let difference c1 c2 =
  complement (union (complement c1) c2)


(* phisical comparity, merge concsequent segments *)    
let rec norm = function
  | (c1,n1)::((c2,n2)::q as l) ->
      if n1 == n2 then norm ((union c1 c2,n1)::q)
      else (c1,n1)::(norm l)
  | l -> l 

(* Split char sets so as to make them disjoint *)        
let  split (all,t) (c0 ,n0) = 
  let t = 
    [(difference c0 all, [n0])] @
    List.map (fun (c,ns) -> (intersection c c0, n0::ns)) t @
    List.map (fun (c,ns) -> (difference c c0, ns)) t in
  (union all c0,
   List.filter (fun (c,_ns) -> not (is_empty c)) t) ;;

(* let f t  = List.fold_left split (empty,[]) t ;; *)
(* Unicode classes from XML *)

let base_char =
  [ 0x0041,0x005A; 0x0061,0x007A; 0x00C0,0x00D6; 0x00D8,0x00F6; 
    0x00F8,0x00FF; 0x0100,0x0131; 0x0134,0x013E; 0x0141,0x0148; 
    0x014A,0x017E; 0x0180,0x01C3; 0x01CD,0x01F0; 0x01F4,0x01F5; 
    0x01FA,0x0217; 0x0250,0x02A8; 0x02BB,0x02C1; 0x0386,0x0386;
    0x0388,0x038A; 0x038C,0x038C; 0x038E,0x03A1; 0x03A3,0x03CE; 
    0x03D0,0x03D6; 0x03DA,0x03DA; 0x03DC,0x03DC; 0x03DE,0x03DE; 
    0x03E0,0x03E0; 0x03E2,0x03F3; 
    0x0401,0x040C; 0x040E,0x044F; 0x0451,0x045C; 0x045E,0x0481; 
    0x0490,0x04C4; 0x04C7,0x04C8; 0x04CB,0x04CC; 0x04D0,0x04EB; 
    0x04EE,0x04F5; 0x04F8,0x04F9; 0x0531,0x0556; 0x0559,0x0559;
    0x0561,0x0586; 0x05D0,0x05EA; 0x05F0,0x05F2; 0x0621,0x063A; 
    0x0641,0x064A; 0x0671,0x06B7; 0x06BA,0x06BE; 0x06C0,0x06CE; 
    0x06D0,0x06D3; 0x06D5,0x06D5; 0x06E5,0x06E6; 0x0905,0x0939; 
    0x093D,0x093D;
    0x0958,0x0961; 0x0985,0x098C; 0x098F,0x0990; 0x0993,0x09A8; 
    0x09AA,0x09B0; 0x09B2,0x09B2; 0x09B6,0x09B9; 0x09DC,0x09DD; 
    0x09DF,0x09E1; 0x09F0,0x09F1; 0x0A05,0x0A0A; 0x0A0F,0x0A10; 
    0x0A13,0x0A28; 0x0A2A,0x0A30; 0x0A32,0x0A33; 0x0A35,0x0A36; 
    0x0A38,0x0A39; 0x0A59,0x0A5C; 0x0A5E,0x0A5E; 0x0A72,0x0A74; 
    0x0A85,0x0A8B; 0x0A8D,0x0A8D; 0x0A8F,0x0A91; 0x0A93,0x0AA8; 
    0x0AAA,0x0AB0; 0x0AB2,0x0AB3; 0x0AB5,0x0AB9; 0x0ABD,0x0ABD; 
    0x0AE0,0x0AE0;
    0x0B05,0x0B0C; 0x0B0F,0x0B10; 0x0B13,0x0B28; 0x0B2A,0x0B30; 
    0x0B32,0x0B33; 0x0B36,0x0B39; 0x0B3D,0x0B3D; 0x0B5C,0x0B5D; 
    0x0B5F,0x0B61; 0x0B85,0x0B8A; 0x0B8E,0x0B90; 0x0B92,0x0B95; 
    0x0B99,0x0B9A; 0x0B9C,0x0B9C; 0x0B9E,0x0B9F; 0x0BA3,0x0BA4; 
    0x0BA8,0x0BAA; 0x0BAE,0x0BB5; 0x0BB7,0x0BB9; 0x0C05,0x0C0C; 
    0x0C0E,0x0C10; 0x0C12,0x0C28; 0x0C2A,0x0C33; 0x0C35,0x0C39; 
    0x0C60,0x0C61; 0x0C85,0x0C8C; 0x0C8E,0x0C90; 0x0C92,0x0CA8; 
    0x0CAA,0x0CB3; 0x0CB5,0x0CB9; 0x0CDE,0x0CDE; 0x0CE0,0x0CE1; 
    0x0D05,0x0D0C; 0x0D0E,0x0D10; 0x0D12,0x0D28; 0x0D2A,0x0D39; 
    0x0D60,0x0D61; 0x0E01,0x0E2E; 0x0E30,0x0E30; 0x0E32,0x0E33; 
    0x0E40,0x0E45; 0x0E81,0x0E82; 0x0E84,0x0E84; 0x0E87,0x0E88; 
    0x0E8A,0x0E8A;
    0x0E8D,0x0E8D; 0x0E94,0x0E97; 0x0E99,0x0E9F; 0x0EA1,0x0EA3; 
    0x0EA5,0x0EA5;
    0x0EA7,0x0EA7; 0x0EAA,0x0EAB; 0x0EAD,0x0EAE; 0x0EB0,0x0EB0; 
    0x0EB2,0x0EB3;
    0x0EBD,0x0EBD; 0x0EC0,0x0EC4; 0x0F40,0x0F47; 0x0F49,0x0F69; 
    0x10A0,0x10C5; 0x10D0,0x10F6; 0x1100,0x1100; 0x1102,0x1103; 
    0x1105,0x1107; 0x1109,0x1109; 0x110B,0x110C; 0x110E,0x1112; 
    0x113C,0x113C;
    0x113E,0x113E; 0x1140,0x1140; 0x114C,0x114C; 0x114E,0x114E; 
    0x1150,0x1150; 0x1154,0x1155; 0x1159,0x1159;
    0x115F,0x1161; 0x1163,0x1163; 0x1165,0x1165; 0x1167,0x1167; 
    0x1169,0x1169; 0x116D,0x116E; 
    0x1172,0x1173; 0x1175,0x1175; 0x119E,0x119E; 0x11A8,0x11A8; 
    0x11AB,0x11AB; 0x11AE,0x11AF; 
    0x11B7,0x11B8; 0x11BA,0x11BA; 0x11BC,0x11C2; 0x11EB,0x11EB; 
    0x11F0,0x11F0; 0x11F9,0x11F9;
    0x1E00,0x1E9B; 0x1EA0,0x1EF9; 0x1F00,0x1F15; 0x1F18,0x1F1D; 
    0x1F20,0x1F45; 0x1F48,0x1F4D; 0x1F50,0x1F57; 0x1F59,0x1F59; 
    0x1F5B,0x1F5B;
    0x1F5D,0x1F5D; 0x1F5F,0x1F7D; 0x1F80,0x1FB4; 0x1FB6,0x1FBC; 
    0x1FBE,0x1FBE;
    0x1FC2,0x1FC4; 0x1FC6,0x1FCC; 0x1FD0,0x1FD3; 0x1FD6,0x1FDB; 
    0x1FE0,0x1FEC; 0x1FF2,0x1FF4; 0x1FF6,0x1FFC; 0x2126,0x2126;
    0x212A,0x212B; 0x212E,0x212E; 0x2180,0x2182; 0x3041,0x3094; 
    0x30A1,0x30FA; 0x3105,0x312C; 0xAC00,0xD7A3 ]
  
let ideographic =
  [ 0x3007,0x3007; 0x3021,0x3029; 0x4E00,0x9FA5 ]

let combining_char =
  [ 0x0300,0x0345; 0x0360,0x0361; 0x0483,0x0486; 0x0591,0x05A1;
    0x05A3,0x05B9; 0x05BB,0x05BD; 0x05BF,0x05BF; 0x05C1,0x05C2;
    0x05C4,0x05C4; 0x064B,0x0652; 0x0670,0x0670; 0x06D6,0x06DC;
    0x06DD,0x06DF; 0x06E0,0x06E4; 0x06E7,0x06E8; 0x06EA,0x06ED;
    0x0901,0x0903; 0x093C,0x093C; 0x093E,0x094C; 0x094D,0x094D;
    0x0951,0x0954; 0x0962,0x0963; 0x0981,0x0983; 0x09BC,0x09BC;
    0x09BE,0x09BE; 0x09BF,0x09BF; 0x09C0,0x09C4; 0x09C7,0x09C8;
    0x09CB,0x09CD; 0x09D7,0x09D7; 0x09E2,0x09E3; 0x0A02,0x0A02;
    0x0A3C,0x0A3C; 0x0A3E,0x0A3E; 0x0A3F,0x0A3F; 0x0A40,0x0A42;
    0x0A47,0x0A48; 0x0A4B,0x0A4D; 0x0A70,0x0A71; 0x0A81,0x0A83;
    0x0ABC,0x0ABC; 0x0ABE,0x0AC5; 0x0AC7,0x0AC9; 0x0ACB,0x0ACD;
    0x0B01,0x0B03; 0x0B3C,0x0B3C; 0x0B3E,0x0B43; 0x0B47,0x0B48;
    0x0B4B,0x0B4D; 0x0B56,0x0B57; 0x0B82,0x0B83; 0x0BBE,0x0BC2;
    0x0BC6,0x0BC8; 0x0BCA,0x0BCD; 0x0BD7,0x0BD7; 0x0C01,0x0C03;
    0x0C3E,0x0C44; 0x0C46,0x0C48; 0x0C4A,0x0C4D; 0x0C55,0x0C56;
    0x0C82,0x0C83; 0x0CBE,0x0CC4; 0x0CC6,0x0CC8; 0x0CCA,0x0CCD;
    0x0CD5,0x0CD6; 0x0D02,0x0D03; 0x0D3E,0x0D43; 0x0D46,0x0D48;
    0x0D4A,0x0D4D; 0x0D57,0x0D57; 0x0E31,0x0E31; 0x0E34,0x0E3A;
    0x0E47,0x0E4E; 0x0EB1,0x0EB1; 0x0EB4,0x0EB9; 0x0EBB,0x0EBC;
    0x0EC8,0x0ECD; 0x0F18,0x0F19; 0x0F35,0x0F35; 0x0F37,0x0F37;
    0x0F39,0x0F39; 0x0F3E,0x0F3E; 0x0F3F,0x0F3F; 0x0F71,0x0F84;
    0x0F86,0x0F8B; 0x0F90,0x0F95; 0x0F97,0x0F97; 0x0F99,0x0FAD;
    0x0FB1,0x0FB7; 0x0FB9,0x0FB9; 0x20D0,0x20DC; 0x20E1,0x20E1;
    0x302A,0x302F; 0x3099,0x3099; 0x309A,0x309A ]

let digit =
  [ 0x0030,0x0039;
    0x0660,0x0669; 0x06F0,0x06F9; 0x0966,0x096F; 0x09E6,0x09EF;
    0x0A66,0x0A6F; 0x0AE6,0x0AEF; 0x0B66,0x0B6F; 0x0BE7,0x0BEF;
    0x0C66,0x0C6F; 0x0CE6,0x0CEF; 0x0D66,0x0D6F; 0x0E50,0x0E59;
    0x0ED0,0x0ED9; 0x0F20,0x0F29 ]

let extender =
  [ 0x00B7,0x00B7; 0x02D0,0x02D1; 0x0387,0x0387; 0x0640,0x0640;
    0x0E46,0x0E46; 0x0EC6,0x0EC6; 0x3005,0x3005; 0x3031,0x3035;
    0x309D,0x309E; 0x30FC,0x30FE ]

let blank =
  [ 0x0009,0x000A; 0x000D,0x000D; 0x0020,0x0020 ]

let letter = union base_char ideographic


(* Letters to be used in identifiers, as specified
   by ISO ....
   Data provided by John M. Skaller *)
let tr8876_ident_char = [
  (* ASCII *)
  (0x0041,0x005a);
  (0x0061,0x007a);

  (* Latin *)
  (0x00c0,0x00d6);
  (0x00d8,0x00f6);
  (0x00f8,0x01f5);
  (0x01fa,0x0217);
  (0x0250,0x02a8);

  (* Greek *)
  (0x0384,0x0384);
  (0x0388,0x038a);
  (0x038c,0x038c);
  (0x038e,0x03a1);
  (0x03a3,0x03ce);
  (0x03d0,0x03d6);
  (0x03da,0x03da);
  (0x03dc,0x03dc);
  (0x03de,0x03de);
  (0x03e0,0x03e0);
  (0x03e2,0x03f3);

  (* Cyrillic *)
  (0x0401,0x040d);
  (0x040f,0x044f);
  (0x0451,0x045c);
  (0x045e,0x0481);
  (0x0490,0x04c4);
  (0x04c7,0x04c4);
  (0x04cb,0x04cc);
  (0x04d0,0x04eb);
  (0x04ee,0x04f5);
  (0x04f8,0x04f9);

  (* Armenian *)
  (0x0531,0x0556);
  (0x0561,0x0587);
  (0x04d0,0x04eb);

  (* Hebrew *)
  (0x05d0,0x05ea);
  (0x05f0,0x05f4);

  (* Arabic *)
  (0x0621,0x063a);
  (0x0640,0x0652);
  (0x0670,0x06b7);
  (0x06ba,0x06be);
  (0x06c0,0x06ce);
  (0x06e5,0x06e7);

  (* Devanagari *)
  (0x0905,0x0939);
  (0x0958,0x0962);

  (* Bengali *)
  (0x0985,0x098c);
  (0x098f,0x0990);
  (0x0993,0x09a8);
  (0x09aa,0x09b0);
  (0x09b2,0x09b2);
  (0x09b6,0x09b9);
  (0x09dc,0x09dd);
  (0x09df,0x09e1);
  (0x09f0,0x09f1);

  (* Gurmukhi *)
  (0x0a05,0x0a0a);
  (0x0a0f,0x0a10);
  (0x0a13,0x0a28);
  (0x0a2a,0x0a30);
  (0x0a32,0x0a33);
  (0x0a35,0x0a36);
  (0x0a38,0x0a39);
  (0x0a59,0x0a5c);
  (0x0a5e,0x0a5e);

  (* Gunjarati *)
  (0x0a85,0x0a8b);
  (0x0a8d,0x0a8d);
  (0x0a8f,0x0a91);
  (0x0a93,0x0aa8);
  (0x0aaa,0x0ab0);
  (0x0ab2,0x0ab3);
  (0x0ab5,0x0ab9);
  (0x0ae0,0x0ae0);

  (* Oriya *)
  (0x0b05,0x0b0c);
  (0x0b0f,0x0b10);
  (0x0b13,0x0b28);
  (0x0b2a,0x0b30);
  (0x0b32,0x0b33);
  (0x0b36,0x0b39);
  (0x0b5c,0x0b5d);
  (0x0b5f,0x0b61);

  (* Tamil *)
  (0x0b85,0x0b8a);
  (0x0b8e,0x0b90);
  (0x0b92,0x0b95);
  (0x0b99,0x0b9a);
  (0x0b9c,0x0b9c);
  (0x0b9e,0x0b9f);
  (0x0ba3,0x0ba4);
  (0x0ba8,0x0baa);
  (0x0bae,0x0bb5);
  (0x0bb7,0x0bb9);

  (* Telugu *)
  (0x0c05,0x0c0c);
  (0x0c0e,0x0c10);
  (0x0c12,0x0c28);
  (0x0c2a,0x0c33);
  (0x0c35,0x0c39);
  (0x0c60,0x0c61);

  (* Kannada *)
  (0x0c85,0x0c8c);
  (0x0c8e,0x0c90);
  (0x0c92,0x0ca8);
  (0x0caa,0x0cb3);
  (0x0cb5,0x0cb9);
  (0x0ce0,0x0ce1);

  (* Malayam *)
  (0x0d05,0x0d0c);
  (0x0d0e,0x0d10);
  (0x0d12,0x0d28);
  (0x0d2a,0x0d39);
  (0x0d60,0x0d61);

  (* Thai *)
  (0x0e01,0x0e30);
  (0x0e32,0x0e33);
  (0x0e40,0x0e46);
  (0x0e4f,0x0e5b);

  (* Lao *)
  (0x0e81,0x0e82);
  (0x0e84,0x0e84);
  (0x0e87,0x0e88);
  (0x0e8a,0x0e8a);
  (0x0e0d,0x0e0d);
  (0x0e94,0x0e97);
  (0x0e99,0x0e9f);
  (0x0ea1,0x0ea3);
  (0x0ea5,0x0ea5);
  (0x0ea7,0x0ea7);
  (0x0eaa,0x0eab);
  (0x0ead,0x0eb0);
  (0x0eb2,0x0eb3);
  (0x0ebd,0x0ebd);
  (0x0ec0,0x0ec4);
  (0x0ec6,0x0ec6);

  (* Georgian *)
  (0x10a0,0x10c5);
  (0x10d0,0x10f6);

  (* Hangul Jamo *)
  (0x1100,0x1159);
  (0x1161,0x11a2);
  (0x11a8,0x11f9);
  (0x11d0,0x11f6);

  (* Latin extensions *)
  (0x1e00,0x1e9a);
  (0x1ea0,0x1ef9);

  (* Greek extended *)
  (0x1f00,0x1f15);
  (0x1f18,0x1f1d);
  (0x1f20,0x1f45);
  (0x1f48,0x1f4d);
  (0x1f50,0x1f57);
  (0x1f59,0x1f59);
  (0x1f5b,0x1f5b);
  (0x1f5d,0x1f5d);
  (0x1f5f,0x1f7d);
  (0x1f80,0x1fb4);
  (0x1fb6,0x1fbc);
  (0x1fc2,0x1fc4);
  (0x1fc6,0x1fcc);
  (0x1fd0,0x1fd3);
  (0x1fd6,0x1fdb);
  (0x1fe0,0x1fec);
  (0x1ff2,0x1ff4);
  (0x1ff6,0x1ffc);


  (* Hiragana *)
  (0x3041,0x3094);
  (0x309b,0x309e);

  (* Katakana *)
  (0x30a1,0x30fe);

  (* Bopmofo *)
  (0x3105,0x312c);

  (* CJK Unified Ideographs *)
  (0x4e00,0x9fa5);

  (* CJK Compatibility Ideographs *)
  (0xf900,0xfa2d);

  (* Arabic Presentation Forms *)
  (0xfb1f,0xfb36);
  (0xfb38,0xfb3c);
  (0xfb3e,0xfb3e);
  (0xfb40,0xfb41);
  (0xfb42,0xfb44);
  (0xfb46,0xfbb1);
  (0xfbd3,0xfd35);

  (* Arabic Presentation Forms-A *)
  (0xfd50,0xfd85);
  (0xfd92,0xfbc7);
  (0xfdf0,0xfdfb);

  (* Arabic Presentation Forms-B *)
  (0xfe70,0xfe72);
  (0xfe74,0xfe74);
  (0xfe76,0xfefc);

  (* Half width and Fullwidth Forms *)
  (0xff21,0xff3a);
  (0xff41,0xff5a);
  (0xff66,0xffbe);
  (0xffc2,0xffc7);
  (0xffca,0xffcf);
  (0xffd2,0xffd7);
  (0xffd2,0xffd7);
  (0xffda,0xffdc)
]
