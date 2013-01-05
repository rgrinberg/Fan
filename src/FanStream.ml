open Ast;
type item_or_def 'a =
  [ SdStr of 'a
  | SdDef of string and option (list string * expr)
  | SdUnd of string
  | SdITE of bool and list (item_or_def 'a) and list (item_or_def 'a)
  | SdLazy of Lazy.t 'a ];
