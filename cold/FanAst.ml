include Ast
module type META_LOC =
  sig
    val meta_loc_patt : FanLoc.t -> FanLoc.t -> patt
    val meta_loc_expr : FanLoc.t -> FanLoc.t -> expr
  end
open FanUtil
open LibUtil
open StdLib
let safe_string_escaped s =
  if ((String.length s) > 2) && (((s.[0]) = '\\') && ((s.[1]) = '$'))
  then s
  else String.escaped s
let strip_loc_list f lst = List.map f lst
let _ = ()
class eq =
  object (self : 'self_type)
    inherit  eqbase
    method loc : loc -> loc -> 'result=
      fun _a0  _a1  -> self#fanloc_t _a0 _a1
    method ant : ant -> ant -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Ant (_a0,_a1),`Ant (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#fanutil_anti_cxt _a1 _b1)
    method literal : literal -> literal -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Chr (_a0,_a1),`Chr (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#string _a1 _b1)
        | (`Int (_a0,_a1),`Int (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#string _a1 _b1)
        | (`Int32 (_a0,_a1),`Int32 (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#string _a1 _b1)
        | (`Int64 (_a0,_a1),`Int64 (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#string _a1 _b1)
        | (`Flo (_a0,_a1),`Flo (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#string _a1 _b1)
        | (`NativeInt (_a0,_a1),`NativeInt (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#string _a1 _b1)
        | (`Str (_a0,_a1),`Str (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#string _a1 _b1)
        | (_,_) -> false
    method rec_flag : rec_flag -> rec_flag -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Recursive _a0,`Recursive _b0) -> self#loc _a0 _b0
        | (`ReNil _a0,`ReNil _b0) -> self#loc _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method direction_flag : direction_flag -> direction_flag -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`To _a0,`To _b0) -> self#loc _a0 _b0
        | (`Downto _a0,`Downto _b0) -> self#loc _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method mutable_flag : mutable_flag -> mutable_flag -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Mutable _a0,`Mutable _b0) -> self#loc _a0 _b0
        | (`MuNil _a0,`MuNil _b0) -> self#loc _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method private_flag : private_flag -> private_flag -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Private _a0,`Private _b0) -> self#loc _a0 _b0
        | (`PrNil _a0,`PrNil _b0) -> self#loc _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method virtual_flag : virtual_flag -> virtual_flag -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Virtual _a0,`Virtual _b0) -> self#loc _a0 _b0
        | (`ViNil _a0,`ViNil _b0) -> self#loc _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method override_flag : override_flag -> override_flag -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Override _a0,`Override _b0) -> self#loc _a0 _b0
        | (`OvNil _a0,`OvNil _b0) -> self#loc _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method row_var_flag : row_var_flag -> row_var_flag -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`RowVar _a0,`RowVar _b0) -> self#loc _a0 _b0
        | (`RvNil _a0,`RvNil _b0) -> self#loc _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method position_flag : position_flag -> position_flag -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Positive _a0,`Positive _b0) -> self#loc _a0 _b0
        | (`Negative _a0,`Negative _b0) -> self#loc _a0 _b0
        | (`Normal _a0,`Normal _b0) -> self#loc _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method meta_bool : meta_bool -> meta_bool -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`True _a0,`True _b0) -> self#loc _a0 _b0
        | (`False _a0,`False _b0) -> self#loc _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method meta_option :
      'all_a0 .
        ('self_type -> 'all_a0 -> 'all_a0 -> 'result) ->
          'all_a0 meta_option -> 'all_a0 meta_option -> 'result=
      fun mf_a  _a0  _b0  ->
        match (_a0, _b0) with
        | (`None _a0,`None _b0) -> self#loc _a0 _b0
        | (`Some _a0,`Some _b0) -> mf_a self _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method meta_list :
      'all_a0 .
        ('self_type -> 'all_a0 -> 'all_a0 -> 'result) ->
          'all_a0 meta_list -> 'all_a0 meta_list -> 'result=
      fun mf_a  _a0  _b0  ->
        match (_a0, _b0) with
        | (`LNil _a0,`LNil _b0) -> self#loc _a0 _b0
        | (`LCons (_a0,_a1),`LCons (_b0,_b1)) ->
            (mf_a self _a0 _b0) && (self#meta_list mf_a _a1 _b1)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method alident : alident -> alident -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Lid (_a0,_a1),`Lid (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#string _a1 _b1)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method auident : auident -> auident -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Uid (_a0,_a1),`Uid (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#string _a1 _b1)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method aident : aident -> aident -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#alident as _a0),(#alident as _b0)) ->
            (self#alident _a0 _b0 :>'result)
        | ((#auident as _a0),(#auident as _b0)) ->
            (self#auident _a0 _b0 :>'result)
        | (_,_) -> false
    method astring : astring -> astring -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`C (_a0,_a1),`C (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#string _a1 _b1)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method ident : ident -> ident -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Dot (_a0,_a1,_a2),`Dot (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ident _a1 _b1)) &&
              (self#ident _a2 _b2)
        | (`IdApp (_a0,_a1,_a2),`IdApp (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ident _a1 _b1)) &&
              (self#ident _a2 _b2)
        | ((#alident as _a0),(#alident as _b0)) ->
            (self#alident _a0 _b0 :>'result)
        | ((#auident as _a0),(#auident as _b0)) ->
            (self#auident _a0 _b0 :>'result)
        | (_,_) -> false
    method ctyp : ctyp -> ctyp -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`Alias (_a0,_a1,_a2),`Alias (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`Any _a0,`Any _b0) -> self#loc _a0 _b0
        | (`TyApp (_a0,_a1,_a2),`TyApp (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`Arrow (_a0,_a1,_a2),`Arrow (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`ClassPath (_a0,_a1),`ClassPath (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#ident _a1 _b1)
        | (`Label (_a0,_a1,_a2),`Label (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#alident _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`Id (_a0,_a1),`Id (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#ident _a1 _b1)
        | (`TyMan (_a0,_a1,_a2),`TyMan (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`TyDcl (_a0,_a1,_a2,_a3,_a4),`TyDcl (_b0,_b1,_b2,_b3,_b4)) ->
            ((((self#loc _a0 _b0) && (self#alident _a1 _b1)) &&
                (self#list (fun self  -> self#ctyp) _a2 _b2))
               && (self#ctyp _a3 _b3))
              &&
              (self#list
                 (fun self  _a0  _b0  ->
                    match (_a0, _b0) with
                    | ((_a0,_a1),(_b0,_b1)) ->
                        (self#ctyp _a0 _b0) && (self#ctyp _a1 _b1)) _a4 _b4)
        | (`TyObj (_a0,_a1,_a2),`TyObj (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#row_var_flag _a2 _b2)
        | (`TyOlb (_a0,_a1,_a2),`TyOlb (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#alident _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`TyPol (_a0,_a1,_a2),`TyPol (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`TyTypePol (_a0,_a1,_a2),`TyTypePol (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`Quote (_a0,_a1,_a2),`Quote (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#position_flag _a1 _b1)) &&
              (self#meta_option (fun self  -> self#alident) _a2 _b2)
        | (`TyRec (_a0,_a1),`TyRec (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#ctyp _a1 _b1)
        | (`TyCol (_a0,_a1,_a2),`TyCol (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`Com (_a0,_a1,_a2),`Com (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`Sum (_a0,_a1),`Sum (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#ctyp _a1 _b1)
        | (`Of (_a0,_a1,_a2),`Of (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`And (_a0,_a1,_a2),`And (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`Or (_a0,_a1,_a2),`Or (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`Priv (_a0,_a1),`Priv (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#ctyp _a1 _b1)
        | (`Mut (_a0,_a1),`Mut (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#ctyp _a1 _b1)
        | (`Tup (_a0,_a1),`Tup (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#ctyp _a1 _b1)
        | (`Sta (_a0,_a1,_a2),`Sta (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`TyVrn (_a0,_a1),`TyVrn (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#astring _a1 _b1)
        | (`TyVrnEq (_a0,_a1),`TyVrnEq (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#ctyp _a1 _b1)
        | (`TyVrnSup (_a0,_a1),`TyVrnSup (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#ctyp _a1 _b1)
        | (`TyVrnInf (_a0,_a1),`TyVrnInf (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#ctyp _a1 _b1)
        | (`TyVrnInfSup (_a0,_a1,_a2),`TyVrnInfSup (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`Amp (_a0,_a1,_a2),`Amp (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`TyOfAmp (_a0,_a1,_a2),`TyOfAmp (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`Package (_a0,_a1),`Package (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#module_type _a1 _b1)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method patt : patt -> patt -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`Id (_a0,_a1),`Id (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#ident _a1 _b1)
        | (`Alias (_a0,_a1,_a2),`Alias (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#patt _a1 _b1)) &&
              (self#alident _a2 _b2)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (`Any _a0,`Any _b0) -> self#loc _a0 _b0
        | (`PaApp (_a0,_a1,_a2),`PaApp (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#patt _a1 _b1)) &&
              (self#patt _a2 _b2)
        | (`Array (_a0,_a1),`Array (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#patt _a1 _b1)
        | (`Com (_a0,_a1,_a2),`Com (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#patt _a1 _b1)) &&
              (self#patt _a2 _b2)
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#patt _a1 _b1)) &&
              (self#patt _a2 _b2)
        | ((#literal as _a0),(#literal as _b0)) ->
            (self#literal _a0 _b0 :>'result)
        | (`Label (_a0,_a1,_a2),`Label (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#alident _a1 _b1)) &&
              (self#patt _a2 _b2)
        | (`PaOlbi (_a0,_a1,_a2,_a3),`PaOlbi (_b0,_b1,_b2,_b3)) ->
            (((self#loc _a0 _b0) && (self#alident _a1 _b1)) &&
               (self#patt _a2 _b2))
              && (self#meta_option (fun self  -> self#expr) _a3 _b3)
        | (`Or (_a0,_a1,_a2),`Or (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#patt _a1 _b1)) &&
              (self#patt _a2 _b2)
        | (`PaRng (_a0,_a1,_a2),`PaRng (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#patt _a1 _b1)) &&
              (self#patt _a2 _b2)
        | (`PaRec (_a0,_a1),`PaRec (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#patt _a1 _b1)
        | (`PaEq (_a0,_a1,_a2),`PaEq (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ident _a1 _b1)) &&
              (self#patt _a2 _b2)
        | (`Tup (_a0,_a1),`Tup (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#patt _a1 _b1)
        | (`Constraint (_a0,_a1,_a2),`Constraint (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#patt _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`ClassPath (_a0,_a1),`ClassPath (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#ident _a1 _b1)
        | (`PaVrn (_a0,_a1),`PaVrn (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#string _a1 _b1)
        | (`Lazy (_a0,_a1),`Lazy (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#patt _a1 _b1)
        | (`ModuleUnpack (_a0,_a1,_a2),`ModuleUnpack (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#auident _a1 _b1)) &&
              (self#meta_option (fun self  -> self#ctyp) _a2 _b2)
        | (_,_) -> false
    method expr : expr -> expr -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`Id (_a0,_a1),`Id (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#ident _a1 _b1)
        | (`Dot (_a0,_a1,_a2),`Dot (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#expr _a1 _b1)) &&
              (self#expr _a2 _b2)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (`ExApp (_a0,_a1,_a2),`ExApp (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#expr _a1 _b1)) &&
              (self#expr _a2 _b2)
        | (`ArrayDot (_a0,_a1,_a2),`ArrayDot (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#expr _a1 _b1)) &&
              (self#expr _a2 _b2)
        | (`Array (_a0,_a1),`Array (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#expr _a1 _b1)
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#expr _a1 _b1)) &&
              (self#expr _a2 _b2)
        | (`ExAsf _a0,`ExAsf _b0) -> self#loc _a0 _b0
        | (`ExAsr (_a0,_a1),`ExAsr (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#expr _a1 _b1)
        | (`Assign (_a0,_a1,_a2),`Assign (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#expr _a1 _b1)) &&
              (self#expr _a2 _b2)
        | (`For (_a0,_a1,_a2,_a3,_a4,_a5),`For (_b0,_b1,_b2,_b3,_b4,_b5)) ->
            (((((self#loc _a0 _b0) && (self#alident _a1 _b1)) &&
                 (self#expr _a2 _b2))
                && (self#expr _a3 _b3))
               && (self#direction_flag _a4 _b4))
              && (self#expr _a5 _b5)
        | (`Fun (_a0,_a1),`Fun (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#match_case _a1 _b1)
        | (`IfThenElse (_a0,_a1,_a2,_a3),`IfThenElse (_b0,_b1,_b2,_b3)) ->
            (((self#loc _a0 _b0) && (self#expr _a1 _b1)) &&
               (self#expr _a2 _b2))
              && (self#expr _a3 _b3)
        | (`IfThen (_a0,_a1,_a2),`IfThen (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#expr _a1 _b1)) &&
              (self#expr _a2 _b2)
        | ((#literal as _a0),(#literal as _b0)) ->
            (self#literal _a0 _b0 :>'result)
        | (`Label (_a0,_a1,_a2),`Label (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#alident _a1 _b1)) &&
              (self#expr _a2 _b2)
        | (`Lazy (_a0,_a1),`Lazy (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#expr _a1 _b1)
        | (`LetIn (_a0,_a1,_a2,_a3),`LetIn (_b0,_b1,_b2,_b3)) ->
            (((self#loc _a0 _b0) && (self#rec_flag _a1 _b1)) &&
               (self#binding _a2 _b2))
              && (self#expr _a3 _b3)
        | (`LetModule (_a0,_a1,_a2,_a3),`LetModule (_b0,_b1,_b2,_b3)) ->
            (((self#loc _a0 _b0) && (self#auident _a1 _b1)) &&
               (self#module_expr _a2 _b2))
              && (self#expr _a3 _b3)
        | (`Match (_a0,_a1,_a2),`Match (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#expr _a1 _b1)) &&
              (self#match_case _a2 _b2)
        | (`New (_a0,_a1),`New (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#ident _a1 _b1)
        | (`Obj (_a0,_a1,_a2),`Obj (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#patt _a1 _b1)) &&
              (self#class_str_item _a2 _b2)
        | (`OptLabl (_a0,_a1,_a2),`OptLabl (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#alident _a1 _b1)) &&
              (self#expr _a2 _b2)
        | (`OvrInst (_a0,_a1),`OvrInst (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#rec_binding _a1 _b1)
        | (`Record (_a0,_a1,_a2),`Record (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#rec_binding _a1 _b1)) &&
              (self#expr _a2 _b2)
        | (`Seq (_a0,_a1),`Seq (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#expr _a1 _b1)
        | (`Send (_a0,_a1,_a2),`Send (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#expr _a1 _b1)) &&
              (self#alident _a2 _b2)
        | (`StringDot (_a0,_a1,_a2),`StringDot (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#expr _a1 _b1)) &&
              (self#expr _a2 _b2)
        | (`Try (_a0,_a1,_a2),`Try (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#expr _a1 _b1)) &&
              (self#match_case _a2 _b2)
        | (`Tup (_a0,_a1),`Tup (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#expr _a1 _b1)
        | (`Com (_a0,_a1,_a2),`Com (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#expr _a1 _b1)) &&
              (self#expr _a2 _b2)
        | (`Constraint (_a0,_a1,_a2),`Constraint (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#expr _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`Coercion (_a0,_a1,_a2,_a3),`Coercion (_b0,_b1,_b2,_b3)) ->
            (((self#loc _a0 _b0) && (self#expr _a1 _b1)) &&
               (self#ctyp _a2 _b2))
              && (self#ctyp _a3 _b3)
        | (`ExVrn (_a0,_a1),`ExVrn (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#string _a1 _b1)
        | (`While (_a0,_a1,_a2),`While (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#expr _a1 _b1)) &&
              (self#expr _a2 _b2)
        | (`LetOpen (_a0,_a1,_a2),`LetOpen (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ident _a1 _b1)) &&
              (self#expr _a2 _b2)
        | (`LocalTypeFun (_a0,_a1,_a2),`LocalTypeFun (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#alident _a1 _b1)) &&
              (self#expr _a2 _b2)
        | (`Package_expr (_a0,_a1),`Package_expr (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#module_expr _a1 _b1)
        | (_,_) -> false
    method module_type : module_type -> module_type -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`Id (_a0,_a1),`Id (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#ident _a1 _b1)
        | (`MtFun (_a0,_a1,_a2,_a3),`MtFun (_b0,_b1,_b2,_b3)) ->
            (((self#loc _a0 _b0) && (self#auident _a1 _b1)) &&
               (self#module_type _a2 _b2))
              && (self#module_type _a3 _b3)
        | (`Sig (_a0,_a1),`Sig (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#sig_item _a1 _b1)
        | (`With (_a0,_a1,_a2),`With (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#module_type _a1 _b1)) &&
              (self#with_constr _a2 _b2)
        | (`ModuleTypeOf (_a0,_a1),`ModuleTypeOf (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#module_expr _a1 _b1)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method sig_item : sig_item -> sig_item -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`Class (_a0,_a1),`Class (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#class_type _a1 _b1)
        | (`ClassType (_a0,_a1),`ClassType (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#class_type _a1 _b1)
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#sig_item _a1 _b1)) &&
              (self#sig_item _a2 _b2)
        | (`Directive (_a0,_a1,_a2),`Directive (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#alident _a1 _b1)) &&
              (self#expr _a2 _b2)
        | (`Exception (_a0,_a1),`Exception (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#ctyp _a1 _b1)
        | (`External (_a0,_a1,_a2,_a3),`External (_b0,_b1,_b2,_b3)) ->
            (((self#loc _a0 _b0) && (self#alident _a1 _b1)) &&
               (self#ctyp _a2 _b2))
              && (self#meta_list (fun self  -> self#string) _a3 _b3)
        | (`Include (_a0,_a1),`Include (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#module_type _a1 _b1)
        | (`Module (_a0,_a1,_a2),`Module (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#auident _a1 _b1)) &&
              (self#module_type _a2 _b2)
        | (`RecModule (_a0,_a1),`RecModule (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#module_binding _a1 _b1)
        | (`ModuleType (_a0,_a1,_a2),`ModuleType (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#auident _a1 _b1)) &&
              (self#module_type _a2 _b2)
        | (`Open (_a0,_a1),`Open (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#ident _a1 _b1)
        | (`Type (_a0,_a1),`Type (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#ctyp _a1 _b1)
        | (`Val (_a0,_a1,_a2),`Val (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#alident _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method with_constr : with_constr -> with_constr -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`TypeEq (_a0,_a1,_a2),`TypeEq (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`ModuleEq (_a0,_a1,_a2),`ModuleEq (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ident _a1 _b1)) &&
              (self#ident _a2 _b2)
        | (`TypeSubst (_a0,_a1,_a2),`TypeSubst (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`ModuleSubst (_a0,_a1,_a2),`ModuleSubst (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ident _a1 _b1)) &&
              (self#ident _a2 _b2)
        | (`And (_a0,_a1,_a2),`And (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#with_constr _a1 _b1)) &&
              (self#with_constr _a2 _b2)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method binding : binding -> binding -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`And (_a0,_a1,_a2),`And (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#binding _a1 _b1)) &&
              (self#binding _a2 _b2)
        | (`Bind (_a0,_a1,_a2),`Bind (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#patt _a1 _b1)) &&
              (self#expr _a2 _b2)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method rec_binding : rec_binding -> rec_binding -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#rec_binding _a1 _b1)) &&
              (self#rec_binding _a2 _b2)
        | (`RecBind (_a0,_a1,_a2),`RecBind (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ident _a1 _b1)) &&
              (self#expr _a2 _b2)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method module_binding : module_binding -> module_binding -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`And (_a0,_a1,_a2),`And (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#module_binding _a1 _b1)) &&
              (self#module_binding _a2 _b2)
        | (`ModuleBind (_a0,_a1,_a2,_a3),`ModuleBind (_b0,_b1,_b2,_b3)) ->
            (((self#loc _a0 _b0) && (self#auident _a1 _b1)) &&
               (self#module_type _a2 _b2))
              && (self#module_expr _a3 _b3)
        | (`Constraint (_a0,_a1,_a2),`Constraint (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#auident _a1 _b1)) &&
              (self#module_type _a2 _b2)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method match_case : match_case -> match_case -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`Or (_a0,_a1,_a2),`Or (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#match_case _a1 _b1)) &&
              (self#match_case _a2 _b2)
        | (`Case (_a0,_a1,_a2,_a3),`Case (_b0,_b1,_b2,_b3)) ->
            (((self#loc _a0 _b0) && (self#patt _a1 _b1)) &&
               (self#expr _a2 _b2))
              && (self#expr _a3 _b3)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method module_expr : module_expr -> module_expr -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`Id (_a0,_a1),`Id (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#ident _a1 _b1)
        | (`MeApp (_a0,_a1,_a2),`MeApp (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#module_expr _a1 _b1)) &&
              (self#module_expr _a2 _b2)
        | (`Functor (_a0,_a1,_a2,_a3),`Functor (_b0,_b1,_b2,_b3)) ->
            (((self#loc _a0 _b0) && (self#auident _a1 _b1)) &&
               (self#module_type _a2 _b2))
              && (self#module_expr _a3 _b3)
        | (`Struct (_a0,_a1),`Struct (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#str_item _a1 _b1)
        | (`Constraint (_a0,_a1,_a2),`Constraint (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#module_expr _a1 _b1)) &&
              (self#module_type _a2 _b2)
        | (`PackageModule (_a0,_a1),`PackageModule (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#expr _a1 _b1)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method str_item : str_item -> str_item -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`Class (_a0,_a1),`Class (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#class_expr _a1 _b1)
        | (`ClassType (_a0,_a1),`ClassType (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#class_type _a1 _b1)
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#str_item _a1 _b1)) &&
              (self#str_item _a2 _b2)
        | (`Directive (_a0,_a1,_a2),`Directive (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#alident _a1 _b1)) &&
              (self#expr _a2 _b2)
        | (`Exception (_a0,_a1),`Exception (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#ctyp _a1 _b1)
        | (`StExp (_a0,_a1),`StExp (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#expr _a1 _b1)
        | (`External (_a0,_a1,_a2,_a3),`External (_b0,_b1,_b2,_b3)) ->
            (((self#loc _a0 _b0) && (self#alident _a1 _b1)) &&
               (self#ctyp _a2 _b2))
              && (self#meta_list (fun self  -> self#string) _a3 _b3)
        | (`Include (_a0,_a1),`Include (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#module_expr _a1 _b1)
        | (`Module (_a0,_a1,_a2),`Module (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#auident _a1 _b1)) &&
              (self#module_expr _a2 _b2)
        | (`RecModule (_a0,_a1),`RecModule (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#module_binding _a1 _b1)
        | (`ModuleType (_a0,_a1,_a2),`ModuleType (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#auident _a1 _b1)) &&
              (self#module_type _a2 _b2)
        | (`Open (_a0,_a1),`Open (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#ident _a1 _b1)
        | (`Type (_a0,_a1),`Type (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#ctyp _a1 _b1)
        | (`Value (_a0,_a1,_a2),`Value (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#rec_flag _a1 _b1)) &&
              (self#binding _a2 _b2)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method class_type : class_type -> class_type -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`CtCon (_a0,_a1,_a2,_a3),`CtCon (_b0,_b1,_b2,_b3)) ->
            (((self#loc _a0 _b0) && (self#virtual_flag _a1 _b1)) &&
               (self#ident _a2 _b2))
              && (self#ctyp _a3 _b3)
        | (`CtFun (_a0,_a1,_a2),`CtFun (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#class_type _a2 _b2)
        | (`CtSig (_a0,_a1,_a2),`CtSig (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#class_sig_item _a2 _b2)
        | (`And (_a0,_a1,_a2),`And (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#class_type _a1 _b1)) &&
              (self#class_type _a2 _b2)
        | (`CtCol (_a0,_a1,_a2),`CtCol (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#class_type _a1 _b1)) &&
              (self#class_type _a2 _b2)
        | (`CtEq (_a0,_a1,_a2),`CtEq (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#class_type _a1 _b1)) &&
              (self#class_type _a2 _b2)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method class_sig_item : class_sig_item -> class_sig_item -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`Eq (_a0,_a1,_a2),`Eq (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#class_sig_item _a1 _b1)) &&
              (self#class_sig_item _a2 _b2)
        | (`SigInherit (_a0,_a1),`SigInherit (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#class_type _a1 _b1)
        | (`Method (_a0,_a1,_a2,_a3),`Method (_b0,_b1,_b2,_b3)) ->
            (((self#loc _a0 _b0) && (self#alident _a1 _b1)) &&
               (self#private_flag _a2 _b2))
              && (self#ctyp _a3 _b3)
        | (`CgVal (_a0,_a1,_a2,_a3,_a4),`CgVal (_b0,_b1,_b2,_b3,_b4)) ->
            ((((self#loc _a0 _b0) && (self#alident _a1 _b1)) &&
                (self#mutable_flag _a2 _b2))
               && (self#virtual_flag _a3 _b3))
              && (self#ctyp _a4 _b4)
        | (`CgVir (_a0,_a1,_a2,_a3),`CgVir (_b0,_b1,_b2,_b3)) ->
            (((self#loc _a0 _b0) && (self#alident _a1 _b1)) &&
               (self#private_flag _a2 _b2))
              && (self#ctyp _a3 _b3)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method class_expr : class_expr -> class_expr -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`CeApp (_a0,_a1,_a2),`CeApp (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#class_expr _a1 _b1)) &&
              (self#expr _a2 _b2)
        | (`CeCon (_a0,_a1,_a2,_a3),`CeCon (_b0,_b1,_b2,_b3)) ->
            (((self#loc _a0 _b0) && (self#virtual_flag _a1 _b1)) &&
               (self#ident _a2 _b2))
              && (self#ctyp _a3 _b3)
        | (`CeFun (_a0,_a1,_a2),`CeFun (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#patt _a1 _b1)) &&
              (self#class_expr _a2 _b2)
        | (`CeLet (_a0,_a1,_a2,_a3),`CeLet (_b0,_b1,_b2,_b3)) ->
            (((self#loc _a0 _b0) && (self#rec_flag _a1 _b1)) &&
               (self#binding _a2 _b2))
              && (self#class_expr _a3 _b3)
        | (`Obj (_a0,_a1,_a2),`Obj (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#patt _a1 _b1)) &&
              (self#class_str_item _a2 _b2)
        | (`CeTyc (_a0,_a1,_a2),`CeTyc (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#class_expr _a1 _b1)) &&
              (self#class_type _a2 _b2)
        | (`And (_a0,_a1,_a2),`And (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#class_expr _a1 _b1)) &&
              (self#class_expr _a2 _b2)
        | (`Eq (_a0,_a1,_a2),`Eq (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#class_expr _a1 _b1)) &&
              (self#class_expr _a2 _b2)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method class_str_item : class_str_item -> class_str_item -> 'result=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#class_str_item _a1 _b1)) &&
              (self#class_str_item _a2 _b2)
        | (`Eq (_a0,_a1,_a2),`Eq (_b0,_b1,_b2)) ->
            ((self#loc _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`Inherit (_a0,_a1,_a2,_a3),`Inherit (_b0,_b1,_b2,_b3)) ->
            (((self#loc _a0 _b0) && (self#override_flag _a1 _b1)) &&
               (self#class_expr _a2 _b2))
              && (self#meta_option (fun self  -> self#alident) _a3 _b3)
        | (`Initializer (_a0,_a1),`Initializer (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#expr _a1 _b1)
        | (`CrMth (_a0,_a1,_a2,_a3,_a4,_a5),`CrMth (_b0,_b1,_b2,_b3,_b4,_b5))
            ->
            (((((self#loc _a0 _b0) && (self#alident _a1 _b1)) &&
                 (self#override_flag _a2 _b2))
                && (self#private_flag _a3 _b3))
               && (self#expr _a4 _b4))
              && (self#ctyp _a5 _b5)
        | (`CrVal (_a0,_a1,_a2,_a3,_a4),`CrVal (_b0,_b1,_b2,_b3,_b4)) ->
            ((((self#loc _a0 _b0) && (self#alident _a1 _b1)) &&
                (self#override_flag _a2 _b2))
               && (self#mutable_flag _a3 _b3))
              && (self#expr _a4 _b4)
        | (`CrVir (_a0,_a1,_a2,_a3),`CrVir (_b0,_b1,_b2,_b3)) ->
            (((self#loc _a0 _b0) && (self#alident _a1 _b1)) &&
               (self#private_flag _a2 _b2))
              && (self#ctyp _a3 _b3)
        | (`CrVvr (_a0,_a1,_a2,_a3),`CrVvr (_b0,_b1,_b2,_b3)) ->
            (((self#loc _a0 _b0) && (self#alident _a1 _b1)) &&
               (self#mutable_flag _a2 _b2))
              && (self#ctyp _a3 _b3)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result)
        | (_,_) -> false
    method fanloc_t : FanLoc.t -> FanLoc.t -> 'result= self#unknown
    method fanutil_anti_cxt :
      FanUtil.anti_cxt -> FanUtil.anti_cxt -> 'result= self#unknown
  end
class map =
  object (self : 'self_type)
    inherit  mapbase
    method loc : loc -> loc= fun _a0  -> self#fanloc_t _a0
    method ant : ant -> ant=
      fun (`Ant (_a0,_a1))  ->
        let _a0 = self#loc _a0 in
        let _a1 = self#fanutil_anti_cxt _a1 in `Ant (_a0, _a1)
    method literal : literal -> literal=
      function
      | `Chr (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#string _a1 in `Chr (_a0, _a1)
      | `Int (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#string _a1 in `Int (_a0, _a1)
      | `Int32 (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#string _a1 in `Int32 (_a0, _a1)
      | `Int64 (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#string _a1 in `Int64 (_a0, _a1)
      | `Flo (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#string _a1 in `Flo (_a0, _a1)
      | `NativeInt (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#string _a1 in `NativeInt (_a0, _a1)
      | `Str (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#string _a1 in `Str (_a0, _a1)
    method rec_flag : rec_flag -> rec_flag=
      function
      | `Recursive _a0 -> let _a0 = self#loc _a0 in `Recursive _a0
      | `ReNil _a0 -> let _a0 = self#loc _a0 in `ReNil _a0
      | #ant as _a0 -> (self#ant _a0 : ant  :>rec_flag)
    method direction_flag : direction_flag -> direction_flag=
      function
      | `To _a0 -> let _a0 = self#loc _a0 in `To _a0
      | `Downto _a0 -> let _a0 = self#loc _a0 in `Downto _a0
      | #ant as _a0 -> (self#ant _a0 : ant  :>direction_flag)
    method mutable_flag : mutable_flag -> mutable_flag=
      function
      | `Mutable _a0 -> let _a0 = self#loc _a0 in `Mutable _a0
      | `MuNil _a0 -> let _a0 = self#loc _a0 in `MuNil _a0
      | #ant as _a0 -> (self#ant _a0 : ant  :>mutable_flag)
    method private_flag : private_flag -> private_flag=
      function
      | `Private _a0 -> let _a0 = self#loc _a0 in `Private _a0
      | `PrNil _a0 -> let _a0 = self#loc _a0 in `PrNil _a0
      | #ant as _a0 -> (self#ant _a0 : ant  :>private_flag)
    method virtual_flag : virtual_flag -> virtual_flag=
      function
      | `Virtual _a0 -> let _a0 = self#loc _a0 in `Virtual _a0
      | `ViNil _a0 -> let _a0 = self#loc _a0 in `ViNil _a0
      | #ant as _a0 -> (self#ant _a0 : ant  :>virtual_flag)
    method override_flag : override_flag -> override_flag=
      function
      | `Override _a0 -> let _a0 = self#loc _a0 in `Override _a0
      | `OvNil _a0 -> let _a0 = self#loc _a0 in `OvNil _a0
      | #ant as _a0 -> (self#ant _a0 : ant  :>override_flag)
    method row_var_flag : row_var_flag -> row_var_flag=
      function
      | `RowVar _a0 -> let _a0 = self#loc _a0 in `RowVar _a0
      | `RvNil _a0 -> let _a0 = self#loc _a0 in `RvNil _a0
      | #ant as _a0 -> (self#ant _a0 : ant  :>row_var_flag)
    method position_flag : position_flag -> position_flag=
      function
      | `Positive _a0 -> let _a0 = self#loc _a0 in `Positive _a0
      | `Negative _a0 -> let _a0 = self#loc _a0 in `Negative _a0
      | `Normal _a0 -> let _a0 = self#loc _a0 in `Normal _a0
      | #ant as _a0 -> (self#ant _a0 : ant  :>position_flag)
    method meta_bool : meta_bool -> meta_bool=
      function
      | `True _a0 -> let _a0 = self#loc _a0 in `True _a0
      | `False _a0 -> let _a0 = self#loc _a0 in `False _a0
      | #ant as _a0 -> (self#ant _a0 : ant  :>meta_bool)
    method meta_option :
      'all_a0 'all_b0 .
        ('self_type -> 'all_a0 -> 'all_b0) ->
          'all_a0 meta_option -> 'all_b0 meta_option=
      fun mf_a  ->
        function
        | `None _a0 -> let _a0 = self#loc _a0 in `None _a0
        | `Some _a0 -> let _a0 = mf_a self _a0 in `Some _a0
        | #ant as _a0 -> (self#ant _a0 : ant  :>_ meta_option)
    method meta_list :
      'all_a0 'all_b0 .
        ('self_type -> 'all_a0 -> 'all_b0) ->
          'all_a0 meta_list -> 'all_b0 meta_list=
      fun mf_a  ->
        function
        | `LNil _a0 -> let _a0 = self#loc _a0 in `LNil _a0
        | `LCons (_a0,_a1) ->
            let _a0 = mf_a self _a0 in
            let _a1 = self#meta_list mf_a _a1 in `LCons (_a0, _a1)
        | #ant as _a0 -> (self#ant _a0 : ant  :>_ meta_list)
    method alident : alident -> alident=
      function
      | `Lid (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#string _a1 in `Lid (_a0, _a1)
      | #ant as _a0 -> (self#ant _a0 : ant  :>alident)
    method auident : auident -> auident=
      function
      | `Uid (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#string _a1 in `Uid (_a0, _a1)
      | #ant as _a0 -> (self#ant _a0 : ant  :>auident)
    method aident : aident -> aident=
      function
      | #alident as _a0 -> (self#alident _a0 : alident  :>aident)
      | #auident as _a0 -> (self#auident _a0 : auident  :>aident)
    method astring : astring -> astring=
      function
      | `C (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#string _a1 in `C (_a0, _a1)
      | #ant as _a0 -> (self#ant _a0 : ant  :>astring)
    method ident : ident -> ident=
      function
      | `Dot (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ident _a1 in
          let _a2 = self#ident _a2 in `Dot (_a0, _a1, _a2)
      | `IdApp (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ident _a1 in
          let _a2 = self#ident _a2 in `IdApp (_a0, _a1, _a2)
      | #alident as _a0 -> (self#alident _a0 : alident  :>ident)
      | #auident as _a0 -> (self#auident _a0 : auident  :>ident)
    method ctyp : ctyp -> ctyp=
      function
      | `Nil _a0 -> let _a0 = self#loc _a0 in `Nil _a0
      | `Alias (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#ctyp _a2 in `Alias (_a0, _a1, _a2)
      | `Any _a0 -> let _a0 = self#loc _a0 in `Any _a0
      | `TyApp (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#ctyp _a2 in `TyApp (_a0, _a1, _a2)
      | `Arrow (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#ctyp _a2 in `Arrow (_a0, _a1, _a2)
      | `ClassPath (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ident _a1 in `ClassPath (_a0, _a1)
      | `Label (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#alident _a1 in
          let _a2 = self#ctyp _a2 in `Label (_a0, _a1, _a2)
      | `Id (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ident _a1 in `Id (_a0, _a1)
      | `TyMan (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#ctyp _a2 in `TyMan (_a0, _a1, _a2)
      | `TyDcl (_a0,_a1,_a2,_a3,_a4) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#alident _a1 in
          let _a2 = self#list (fun self  -> self#ctyp) _a2 in
          let _a3 = self#ctyp _a3 in
          let _a4 =
            self#list
              (fun self  (_a0,_a1)  ->
                 let _a0 = self#ctyp _a0 in
                 let _a1 = self#ctyp _a1 in (_a0, _a1)) _a4 in
          `TyDcl (_a0, _a1, _a2, _a3, _a4)
      | `TyObj (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#row_var_flag _a2 in `TyObj (_a0, _a1, _a2)
      | `TyOlb (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#alident _a1 in
          let _a2 = self#ctyp _a2 in `TyOlb (_a0, _a1, _a2)
      | `TyPol (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#ctyp _a2 in `TyPol (_a0, _a1, _a2)
      | `TyTypePol (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#ctyp _a2 in `TyTypePol (_a0, _a1, _a2)
      | `Quote (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#position_flag _a1 in
          let _a2 = self#meta_option (fun self  -> self#alident) _a2 in
          `Quote (_a0, _a1, _a2)
      | `TyRec (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in `TyRec (_a0, _a1)
      | `TyCol (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#ctyp _a2 in `TyCol (_a0, _a1, _a2)
      | `Sem (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#ctyp _a2 in `Sem (_a0, _a1, _a2)
      | `Com (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#ctyp _a2 in `Com (_a0, _a1, _a2)
      | `Sum (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in `Sum (_a0, _a1)
      | `Of (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#ctyp _a2 in `Of (_a0, _a1, _a2)
      | `And (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#ctyp _a2 in `And (_a0, _a1, _a2)
      | `Or (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#ctyp _a2 in `Or (_a0, _a1, _a2)
      | `Priv (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in `Priv (_a0, _a1)
      | `Mut (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in `Mut (_a0, _a1)
      | `Tup (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in `Tup (_a0, _a1)
      | `Sta (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#ctyp _a2 in `Sta (_a0, _a1, _a2)
      | `TyVrn (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#astring _a1 in `TyVrn (_a0, _a1)
      | `TyVrnEq (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in `TyVrnEq (_a0, _a1)
      | `TyVrnSup (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in `TyVrnSup (_a0, _a1)
      | `TyVrnInf (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in `TyVrnInf (_a0, _a1)
      | `TyVrnInfSup (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#ctyp _a2 in `TyVrnInfSup (_a0, _a1, _a2)
      | `Amp (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#ctyp _a2 in `Amp (_a0, _a1, _a2)
      | `TyOfAmp (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#ctyp _a2 in `TyOfAmp (_a0, _a1, _a2)
      | `Package (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#module_type _a1 in `Package (_a0, _a1)
      | #ant as _a0 -> (self#ant _a0 : ant  :>ctyp)
    method patt : patt -> patt=
      function
      | `Nil _a0 -> let _a0 = self#loc _a0 in `Nil _a0
      | `Id (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ident _a1 in `Id (_a0, _a1)
      | `Alias (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#patt _a1 in
          let _a2 = self#alident _a2 in `Alias (_a0, _a1, _a2)
      | #ant as _a0 -> (self#ant _a0 : ant  :>patt)
      | `Any _a0 -> let _a0 = self#loc _a0 in `Any _a0
      | `PaApp (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#patt _a1 in
          let _a2 = self#patt _a2 in `PaApp (_a0, _a1, _a2)
      | `Array (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#patt _a1 in `Array (_a0, _a1)
      | `Com (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#patt _a1 in
          let _a2 = self#patt _a2 in `Com (_a0, _a1, _a2)
      | `Sem (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#patt _a1 in
          let _a2 = self#patt _a2 in `Sem (_a0, _a1, _a2)
      | #literal as _a0 -> (self#literal _a0 : literal  :>patt)
      | `Label (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#alident _a1 in
          let _a2 = self#patt _a2 in `Label (_a0, _a1, _a2)
      | `PaOlbi (_a0,_a1,_a2,_a3) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#alident _a1 in
          let _a2 = self#patt _a2 in
          let _a3 = self#meta_option (fun self  -> self#expr) _a3 in
          `PaOlbi (_a0, _a1, _a2, _a3)
      | `Or (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#patt _a1 in
          let _a2 = self#patt _a2 in `Or (_a0, _a1, _a2)
      | `PaRng (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#patt _a1 in
          let _a2 = self#patt _a2 in `PaRng (_a0, _a1, _a2)
      | `PaRec (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#patt _a1 in `PaRec (_a0, _a1)
      | `PaEq (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ident _a1 in
          let _a2 = self#patt _a2 in `PaEq (_a0, _a1, _a2)
      | `Tup (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#patt _a1 in `Tup (_a0, _a1)
      | `Constraint (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#patt _a1 in
          let _a2 = self#ctyp _a2 in `Constraint (_a0, _a1, _a2)
      | `ClassPath (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ident _a1 in `ClassPath (_a0, _a1)
      | `PaVrn (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#string _a1 in `PaVrn (_a0, _a1)
      | `Lazy (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#patt _a1 in `Lazy (_a0, _a1)
      | `ModuleUnpack (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#auident _a1 in
          let _a2 = self#meta_option (fun self  -> self#ctyp) _a2 in
          `ModuleUnpack (_a0, _a1, _a2)
    method expr : expr -> expr=
      function
      | `Nil _a0 -> let _a0 = self#loc _a0 in `Nil _a0
      | `Id (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ident _a1 in `Id (_a0, _a1)
      | `Dot (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in
          let _a2 = self#expr _a2 in `Dot (_a0, _a1, _a2)
      | #ant as _a0 -> (self#ant _a0 : ant  :>expr)
      | `ExApp (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in
          let _a2 = self#expr _a2 in `ExApp (_a0, _a1, _a2)
      | `ArrayDot (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in
          let _a2 = self#expr _a2 in `ArrayDot (_a0, _a1, _a2)
      | `Array (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in `Array (_a0, _a1)
      | `Sem (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in
          let _a2 = self#expr _a2 in `Sem (_a0, _a1, _a2)
      | `ExAsf _a0 -> let _a0 = self#loc _a0 in `ExAsf _a0
      | `ExAsr (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in `ExAsr (_a0, _a1)
      | `Assign (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in
          let _a2 = self#expr _a2 in `Assign (_a0, _a1, _a2)
      | `For (_a0,_a1,_a2,_a3,_a4,_a5) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#alident _a1 in
          let _a2 = self#expr _a2 in
          let _a3 = self#expr _a3 in
          let _a4 = self#direction_flag _a4 in
          let _a5 = self#expr _a5 in `For (_a0, _a1, _a2, _a3, _a4, _a5)
      | `Fun (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#match_case _a1 in `Fun (_a0, _a1)
      | `IfThenElse (_a0,_a1,_a2,_a3) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in
          let _a2 = self#expr _a2 in
          let _a3 = self#expr _a3 in `IfThenElse (_a0, _a1, _a2, _a3)
      | `IfThen (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in
          let _a2 = self#expr _a2 in `IfThen (_a0, _a1, _a2)
      | #literal as _a0 -> (self#literal _a0 : literal  :>expr)
      | `Label (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#alident _a1 in
          let _a2 = self#expr _a2 in `Label (_a0, _a1, _a2)
      | `Lazy (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in `Lazy (_a0, _a1)
      | `LetIn (_a0,_a1,_a2,_a3) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#rec_flag _a1 in
          let _a2 = self#binding _a2 in
          let _a3 = self#expr _a3 in `LetIn (_a0, _a1, _a2, _a3)
      | `LetModule (_a0,_a1,_a2,_a3) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#auident _a1 in
          let _a2 = self#module_expr _a2 in
          let _a3 = self#expr _a3 in `LetModule (_a0, _a1, _a2, _a3)
      | `Match (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in
          let _a2 = self#match_case _a2 in `Match (_a0, _a1, _a2)
      | `New (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ident _a1 in `New (_a0, _a1)
      | `Obj (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#patt _a1 in
          let _a2 = self#class_str_item _a2 in `Obj (_a0, _a1, _a2)
      | `OptLabl (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#alident _a1 in
          let _a2 = self#expr _a2 in `OptLabl (_a0, _a1, _a2)
      | `OvrInst (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#rec_binding _a1 in `OvrInst (_a0, _a1)
      | `Record (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#rec_binding _a1 in
          let _a2 = self#expr _a2 in `Record (_a0, _a1, _a2)
      | `Seq (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in `Seq (_a0, _a1)
      | `Send (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in
          let _a2 = self#alident _a2 in `Send (_a0, _a1, _a2)
      | `StringDot (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in
          let _a2 = self#expr _a2 in `StringDot (_a0, _a1, _a2)
      | `Try (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in
          let _a2 = self#match_case _a2 in `Try (_a0, _a1, _a2)
      | `Tup (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in `Tup (_a0, _a1)
      | `Com (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in
          let _a2 = self#expr _a2 in `Com (_a0, _a1, _a2)
      | `Constraint (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in
          let _a2 = self#ctyp _a2 in `Constraint (_a0, _a1, _a2)
      | `Coercion (_a0,_a1,_a2,_a3) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in
          let _a2 = self#ctyp _a2 in
          let _a3 = self#ctyp _a3 in `Coercion (_a0, _a1, _a2, _a3)
      | `ExVrn (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#string _a1 in `ExVrn (_a0, _a1)
      | `While (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in
          let _a2 = self#expr _a2 in `While (_a0, _a1, _a2)
      | `LetOpen (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ident _a1 in
          let _a2 = self#expr _a2 in `LetOpen (_a0, _a1, _a2)
      | `LocalTypeFun (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#alident _a1 in
          let _a2 = self#expr _a2 in `LocalTypeFun (_a0, _a1, _a2)
      | `Package_expr (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#module_expr _a1 in `Package_expr (_a0, _a1)
    method module_type : module_type -> module_type=
      function
      | `Nil _a0 -> let _a0 = self#loc _a0 in `Nil _a0
      | `Id (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ident _a1 in `Id (_a0, _a1)
      | `MtFun (_a0,_a1,_a2,_a3) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#auident _a1 in
          let _a2 = self#module_type _a2 in
          let _a3 = self#module_type _a3 in `MtFun (_a0, _a1, _a2, _a3)
      | `Sig (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#sig_item _a1 in `Sig (_a0, _a1)
      | `With (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#module_type _a1 in
          let _a2 = self#with_constr _a2 in `With (_a0, _a1, _a2)
      | `ModuleTypeOf (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#module_expr _a1 in `ModuleTypeOf (_a0, _a1)
      | #ant as _a0 -> (self#ant _a0 : ant  :>module_type)
    method sig_item : sig_item -> sig_item=
      function
      | `Nil _a0 -> let _a0 = self#loc _a0 in `Nil _a0
      | `Class (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#class_type _a1 in `Class (_a0, _a1)
      | `ClassType (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#class_type _a1 in `ClassType (_a0, _a1)
      | `Sem (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#sig_item _a1 in
          let _a2 = self#sig_item _a2 in `Sem (_a0, _a1, _a2)
      | `Directive (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#alident _a1 in
          let _a2 = self#expr _a2 in `Directive (_a0, _a1, _a2)
      | `Exception (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in `Exception (_a0, _a1)
      | `External (_a0,_a1,_a2,_a3) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#alident _a1 in
          let _a2 = self#ctyp _a2 in
          let _a3 = self#meta_list (fun self  -> self#string) _a3 in
          `External (_a0, _a1, _a2, _a3)
      | `Include (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#module_type _a1 in `Include (_a0, _a1)
      | `Module (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#auident _a1 in
          let _a2 = self#module_type _a2 in `Module (_a0, _a1, _a2)
      | `RecModule (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#module_binding _a1 in `RecModule (_a0, _a1)
      | `ModuleType (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#auident _a1 in
          let _a2 = self#module_type _a2 in `ModuleType (_a0, _a1, _a2)
      | `Open (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ident _a1 in `Open (_a0, _a1)
      | `Type (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in `Type (_a0, _a1)
      | `Val (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#alident _a1 in
          let _a2 = self#ctyp _a2 in `Val (_a0, _a1, _a2)
      | #ant as _a0 -> (self#ant _a0 : ant  :>sig_item)
    method with_constr : with_constr -> with_constr=
      function
      | `Nil _a0 -> let _a0 = self#loc _a0 in `Nil _a0
      | `TypeEq (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#ctyp _a2 in `TypeEq (_a0, _a1, _a2)
      | `ModuleEq (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ident _a1 in
          let _a2 = self#ident _a2 in `ModuleEq (_a0, _a1, _a2)
      | `TypeSubst (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#ctyp _a2 in `TypeSubst (_a0, _a1, _a2)
      | `ModuleSubst (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ident _a1 in
          let _a2 = self#ident _a2 in `ModuleSubst (_a0, _a1, _a2)
      | `And (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#with_constr _a1 in
          let _a2 = self#with_constr _a2 in `And (_a0, _a1, _a2)
      | #ant as _a0 -> (self#ant _a0 : ant  :>with_constr)
    method binding : binding -> binding=
      function
      | `Nil _a0 -> let _a0 = self#loc _a0 in `Nil _a0
      | `And (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#binding _a1 in
          let _a2 = self#binding _a2 in `And (_a0, _a1, _a2)
      | `Bind (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#patt _a1 in
          let _a2 = self#expr _a2 in `Bind (_a0, _a1, _a2)
      | #ant as _a0 -> (self#ant _a0 : ant  :>binding)
    method rec_binding : rec_binding -> rec_binding=
      function
      | `Nil _a0 -> let _a0 = self#loc _a0 in `Nil _a0
      | `Sem (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#rec_binding _a1 in
          let _a2 = self#rec_binding _a2 in `Sem (_a0, _a1, _a2)
      | `RecBind (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ident _a1 in
          let _a2 = self#expr _a2 in `RecBind (_a0, _a1, _a2)
      | #ant as _a0 -> (self#ant _a0 : ant  :>rec_binding)
    method module_binding : module_binding -> module_binding=
      function
      | `Nil _a0 -> let _a0 = self#loc _a0 in `Nil _a0
      | `And (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#module_binding _a1 in
          let _a2 = self#module_binding _a2 in `And (_a0, _a1, _a2)
      | `ModuleBind (_a0,_a1,_a2,_a3) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#auident _a1 in
          let _a2 = self#module_type _a2 in
          let _a3 = self#module_expr _a3 in `ModuleBind (_a0, _a1, _a2, _a3)
      | `Constraint (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#auident _a1 in
          let _a2 = self#module_type _a2 in `Constraint (_a0, _a1, _a2)
      | #ant as _a0 -> (self#ant _a0 : ant  :>module_binding)
    method match_case : match_case -> match_case=
      function
      | `Nil _a0 -> let _a0 = self#loc _a0 in `Nil _a0
      | `Or (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#match_case _a1 in
          let _a2 = self#match_case _a2 in `Or (_a0, _a1, _a2)
      | `Case (_a0,_a1,_a2,_a3) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#patt _a1 in
          let _a2 = self#expr _a2 in
          let _a3 = self#expr _a3 in `Case (_a0, _a1, _a2, _a3)
      | #ant as _a0 -> (self#ant _a0 : ant  :>match_case)
    method module_expr : module_expr -> module_expr=
      function
      | `Nil _a0 -> let _a0 = self#loc _a0 in `Nil _a0
      | `Id (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ident _a1 in `Id (_a0, _a1)
      | `MeApp (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#module_expr _a1 in
          let _a2 = self#module_expr _a2 in `MeApp (_a0, _a1, _a2)
      | `Functor (_a0,_a1,_a2,_a3) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#auident _a1 in
          let _a2 = self#module_type _a2 in
          let _a3 = self#module_expr _a3 in `Functor (_a0, _a1, _a2, _a3)
      | `Struct (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#str_item _a1 in `Struct (_a0, _a1)
      | `Constraint (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#module_expr _a1 in
          let _a2 = self#module_type _a2 in `Constraint (_a0, _a1, _a2)
      | `PackageModule (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in `PackageModule (_a0, _a1)
      | #ant as _a0 -> (self#ant _a0 : ant  :>module_expr)
    method str_item : str_item -> str_item=
      function
      | `Nil _a0 -> let _a0 = self#loc _a0 in `Nil _a0
      | `Class (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#class_expr _a1 in `Class (_a0, _a1)
      | `ClassType (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#class_type _a1 in `ClassType (_a0, _a1)
      | `Sem (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#str_item _a1 in
          let _a2 = self#str_item _a2 in `Sem (_a0, _a1, _a2)
      | `Directive (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#alident _a1 in
          let _a2 = self#expr _a2 in `Directive (_a0, _a1, _a2)
      | `Exception (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in `Exception (_a0, _a1)
      | `StExp (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in `StExp (_a0, _a1)
      | `External (_a0,_a1,_a2,_a3) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#alident _a1 in
          let _a2 = self#ctyp _a2 in
          let _a3 = self#meta_list (fun self  -> self#string) _a3 in
          `External (_a0, _a1, _a2, _a3)
      | `Include (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#module_expr _a1 in `Include (_a0, _a1)
      | `Module (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#auident _a1 in
          let _a2 = self#module_expr _a2 in `Module (_a0, _a1, _a2)
      | `RecModule (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#module_binding _a1 in `RecModule (_a0, _a1)
      | `ModuleType (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#auident _a1 in
          let _a2 = self#module_type _a2 in `ModuleType (_a0, _a1, _a2)
      | `Open (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ident _a1 in `Open (_a0, _a1)
      | `Type (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in `Type (_a0, _a1)
      | `Value (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#rec_flag _a1 in
          let _a2 = self#binding _a2 in `Value (_a0, _a1, _a2)
      | #ant as _a0 -> (self#ant _a0 : ant  :>str_item)
    method class_type : class_type -> class_type=
      function
      | `Nil _a0 -> let _a0 = self#loc _a0 in `Nil _a0
      | `CtCon (_a0,_a1,_a2,_a3) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#virtual_flag _a1 in
          let _a2 = self#ident _a2 in
          let _a3 = self#ctyp _a3 in `CtCon (_a0, _a1, _a2, _a3)
      | `CtFun (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#class_type _a2 in `CtFun (_a0, _a1, _a2)
      | `CtSig (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#class_sig_item _a2 in `CtSig (_a0, _a1, _a2)
      | `And (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#class_type _a1 in
          let _a2 = self#class_type _a2 in `And (_a0, _a1, _a2)
      | `CtCol (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#class_type _a1 in
          let _a2 = self#class_type _a2 in `CtCol (_a0, _a1, _a2)
      | `CtEq (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#class_type _a1 in
          let _a2 = self#class_type _a2 in `CtEq (_a0, _a1, _a2)
      | #ant as _a0 -> (self#ant _a0 : ant  :>class_type)
    method class_sig_item : class_sig_item -> class_sig_item=
      function
      | `Nil _a0 -> let _a0 = self#loc _a0 in `Nil _a0
      | `Eq (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#ctyp _a2 in `Eq (_a0, _a1, _a2)
      | `Sem (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#class_sig_item _a1 in
          let _a2 = self#class_sig_item _a2 in `Sem (_a0, _a1, _a2)
      | `SigInherit (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#class_type _a1 in `SigInherit (_a0, _a1)
      | `Method (_a0,_a1,_a2,_a3) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#alident _a1 in
          let _a2 = self#private_flag _a2 in
          let _a3 = self#ctyp _a3 in `Method (_a0, _a1, _a2, _a3)
      | `CgVal (_a0,_a1,_a2,_a3,_a4) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#alident _a1 in
          let _a2 = self#mutable_flag _a2 in
          let _a3 = self#virtual_flag _a3 in
          let _a4 = self#ctyp _a4 in `CgVal (_a0, _a1, _a2, _a3, _a4)
      | `CgVir (_a0,_a1,_a2,_a3) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#alident _a1 in
          let _a2 = self#private_flag _a2 in
          let _a3 = self#ctyp _a3 in `CgVir (_a0, _a1, _a2, _a3)
      | #ant as _a0 -> (self#ant _a0 : ant  :>class_sig_item)
    method class_expr : class_expr -> class_expr=
      function
      | `Nil _a0 -> let _a0 = self#loc _a0 in `Nil _a0
      | `CeApp (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#class_expr _a1 in
          let _a2 = self#expr _a2 in `CeApp (_a0, _a1, _a2)
      | `CeCon (_a0,_a1,_a2,_a3) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#virtual_flag _a1 in
          let _a2 = self#ident _a2 in
          let _a3 = self#ctyp _a3 in `CeCon (_a0, _a1, _a2, _a3)
      | `CeFun (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#patt _a1 in
          let _a2 = self#class_expr _a2 in `CeFun (_a0, _a1, _a2)
      | `CeLet (_a0,_a1,_a2,_a3) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#rec_flag _a1 in
          let _a2 = self#binding _a2 in
          let _a3 = self#class_expr _a3 in `CeLet (_a0, _a1, _a2, _a3)
      | `Obj (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#patt _a1 in
          let _a2 = self#class_str_item _a2 in `Obj (_a0, _a1, _a2)
      | `CeTyc (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#class_expr _a1 in
          let _a2 = self#class_type _a2 in `CeTyc (_a0, _a1, _a2)
      | `And (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#class_expr _a1 in
          let _a2 = self#class_expr _a2 in `And (_a0, _a1, _a2)
      | `Eq (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#class_expr _a1 in
          let _a2 = self#class_expr _a2 in `Eq (_a0, _a1, _a2)
      | #ant as _a0 -> (self#ant _a0 : ant  :>class_expr)
    method class_str_item : class_str_item -> class_str_item=
      function
      | `Nil _a0 -> let _a0 = self#loc _a0 in `Nil _a0
      | `Sem (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#class_str_item _a1 in
          let _a2 = self#class_str_item _a2 in `Sem (_a0, _a1, _a2)
      | `Eq (_a0,_a1,_a2) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#ctyp _a1 in
          let _a2 = self#ctyp _a2 in `Eq (_a0, _a1, _a2)
      | `Inherit (_a0,_a1,_a2,_a3) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#override_flag _a1 in
          let _a2 = self#class_expr _a2 in
          let _a3 = self#meta_option (fun self  -> self#alident) _a3 in
          `Inherit (_a0, _a1, _a2, _a3)
      | `Initializer (_a0,_a1) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#expr _a1 in `Initializer (_a0, _a1)
      | `CrMth (_a0,_a1,_a2,_a3,_a4,_a5) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#alident _a1 in
          let _a2 = self#override_flag _a2 in
          let _a3 = self#private_flag _a3 in
          let _a4 = self#expr _a4 in
          let _a5 = self#ctyp _a5 in `CrMth (_a0, _a1, _a2, _a3, _a4, _a5)
      | `CrVal (_a0,_a1,_a2,_a3,_a4) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#alident _a1 in
          let _a2 = self#override_flag _a2 in
          let _a3 = self#mutable_flag _a3 in
          let _a4 = self#expr _a4 in `CrVal (_a0, _a1, _a2, _a3, _a4)
      | `CrVir (_a0,_a1,_a2,_a3) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#alident _a1 in
          let _a2 = self#private_flag _a2 in
          let _a3 = self#ctyp _a3 in `CrVir (_a0, _a1, _a2, _a3)
      | `CrVvr (_a0,_a1,_a2,_a3) ->
          let _a0 = self#loc _a0 in
          let _a1 = self#alident _a1 in
          let _a2 = self#mutable_flag _a2 in
          let _a3 = self#ctyp _a3 in `CrVvr (_a0, _a1, _a2, _a3)
      | #ant as _a0 -> (self#ant _a0 : ant  :>class_str_item)
    method fanloc_t : FanLoc.t -> FanLoc.t= self#unknown
    method fanutil_anti_cxt : FanUtil.anti_cxt -> FanUtil.anti_cxt=
      self#unknown
  end
class print =
  object (self : 'self_type)
    inherit  printbase
    method loc : 'fmt -> loc -> 'result=
      fun fmt  _a0  -> self#fanloc_t fmt _a0
    method ant : 'fmt -> ant -> 'result=
      fun fmt  (`Ant (_a0,_a1))  ->
        Format.fprintf fmt "@[<1>(`Ant@ %a@ %a)@]" self#loc _a0
          self#fanutil_anti_cxt _a1
    method literal : 'fmt -> literal -> 'result=
      fun fmt  ->
        function
        | `Chr (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Chr@ %a@ %a)@]" self#loc _a0
              self#string _a1
        | `Int (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Int@ %a@ %a)@]" self#loc _a0
              self#string _a1
        | `Int32 (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Int32@ %a@ %a)@]" self#loc _a0
              self#string _a1
        | `Int64 (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Int64@ %a@ %a)@]" self#loc _a0
              self#string _a1
        | `Flo (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Flo@ %a@ %a)@]" self#loc _a0
              self#string _a1
        | `NativeInt (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`NativeInt@ %a@ %a)@]" self#loc _a0
              self#string _a1
        | `Str (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Str@ %a@ %a)@]" self#loc _a0
              self#string _a1
    method rec_flag : 'fmt -> rec_flag -> 'result=
      fun fmt  ->
        function
        | `Recursive _a0 ->
            Format.fprintf fmt "@[<1>(`Recursive@ %a)@]" self#loc _a0
        | `ReNil _a0 -> Format.fprintf fmt "@[<1>(`ReNil@ %a)@]" self#loc _a0
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method direction_flag : 'fmt -> direction_flag -> 'result=
      fun fmt  ->
        function
        | `To _a0 -> Format.fprintf fmt "@[<1>(`To@ %a)@]" self#loc _a0
        | `Downto _a0 ->
            Format.fprintf fmt "@[<1>(`Downto@ %a)@]" self#loc _a0
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method mutable_flag : 'fmt -> mutable_flag -> 'result=
      fun fmt  ->
        function
        | `Mutable _a0 ->
            Format.fprintf fmt "@[<1>(`Mutable@ %a)@]" self#loc _a0
        | `MuNil _a0 -> Format.fprintf fmt "@[<1>(`MuNil@ %a)@]" self#loc _a0
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method private_flag : 'fmt -> private_flag -> 'result=
      fun fmt  ->
        function
        | `Private _a0 ->
            Format.fprintf fmt "@[<1>(`Private@ %a)@]" self#loc _a0
        | `PrNil _a0 -> Format.fprintf fmt "@[<1>(`PrNil@ %a)@]" self#loc _a0
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method virtual_flag : 'fmt -> virtual_flag -> 'result=
      fun fmt  ->
        function
        | `Virtual _a0 ->
            Format.fprintf fmt "@[<1>(`Virtual@ %a)@]" self#loc _a0
        | `ViNil _a0 -> Format.fprintf fmt "@[<1>(`ViNil@ %a)@]" self#loc _a0
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method override_flag : 'fmt -> override_flag -> 'result=
      fun fmt  ->
        function
        | `Override _a0 ->
            Format.fprintf fmt "@[<1>(`Override@ %a)@]" self#loc _a0
        | `OvNil _a0 -> Format.fprintf fmt "@[<1>(`OvNil@ %a)@]" self#loc _a0
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method row_var_flag : 'fmt -> row_var_flag -> 'result=
      fun fmt  ->
        function
        | `RowVar _a0 ->
            Format.fprintf fmt "@[<1>(`RowVar@ %a)@]" self#loc _a0
        | `RvNil _a0 -> Format.fprintf fmt "@[<1>(`RvNil@ %a)@]" self#loc _a0
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method position_flag : 'fmt -> position_flag -> 'result=
      fun fmt  ->
        function
        | `Positive _a0 ->
            Format.fprintf fmt "@[<1>(`Positive@ %a)@]" self#loc _a0
        | `Negative _a0 ->
            Format.fprintf fmt "@[<1>(`Negative@ %a)@]" self#loc _a0
        | `Normal _a0 ->
            Format.fprintf fmt "@[<1>(`Normal@ %a)@]" self#loc _a0
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method meta_bool : 'fmt -> meta_bool -> 'result=
      fun fmt  ->
        function
        | `True _a0 -> Format.fprintf fmt "@[<1>(`True@ %a)@]" self#loc _a0
        | `False _a0 -> Format.fprintf fmt "@[<1>(`False@ %a)@]" self#loc _a0
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method meta_option :
      'all_a0 .
        ('self_type -> 'fmt -> 'all_a0 -> 'result) ->
          'fmt -> 'all_a0 meta_option -> 'result=
      fun mf_a  fmt  ->
        function
        | `None _a0 -> Format.fprintf fmt "@[<1>(`None@ %a)@]" self#loc _a0
        | `Some _a0 ->
            Format.fprintf fmt "@[<1>(`Some@ %a)@]" (mf_a self) _a0
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method meta_list :
      'all_a0 .
        ('self_type -> 'fmt -> 'all_a0 -> 'result) ->
          'fmt -> 'all_a0 meta_list -> 'result=
      fun mf_a  fmt  ->
        function
        | `LNil _a0 -> Format.fprintf fmt "@[<1>(`LNil@ %a)@]" self#loc _a0
        | `LCons (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`LCons@ %a@ %a)@]" (mf_a self) _a0
              (self#meta_list mf_a) _a1
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method alident : 'fmt -> alident -> 'result=
      fun fmt  ->
        function
        | `Lid (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Lid@ %a@ %a)@]" self#loc _a0
              self#string _a1
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method auident : 'fmt -> auident -> 'result=
      fun fmt  ->
        function
        | `Uid (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Uid@ %a@ %a)@]" self#loc _a0
              self#string _a1
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method aident : 'fmt -> aident -> 'result=
      fun fmt  ->
        function
        | #alident as _a0 -> (self#alident fmt _a0 :>'result)
        | #auident as _a0 -> (self#auident fmt _a0 :>'result)
    method astring : 'fmt -> astring -> 'result=
      fun fmt  ->
        function
        | `C (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`C@ %a@ %a)@]" self#loc _a0 self#string
              _a1
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method ident : 'fmt -> ident -> 'result=
      fun fmt  ->
        function
        | `Dot (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Dot@ %a@ %a@ %a)@]" self#loc _a0
              self#ident _a1 self#ident _a2
        | `IdApp (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`IdApp@ %a@ %a@ %a)@]" self#loc _a0
              self#ident _a1 self#ident _a2
        | #alident as _a0 -> (self#alident fmt _a0 :>'result)
        | #auident as _a0 -> (self#auident fmt _a0 :>'result)
    method ctyp : 'fmt -> ctyp -> 'result=
      fun fmt  ->
        function
        | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" self#loc _a0
        | `Alias (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Alias@ %a@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1 self#ctyp _a2
        | `Any _a0 -> Format.fprintf fmt "@[<1>(`Any@ %a)@]" self#loc _a0
        | `TyApp (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`TyApp@ %a@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1 self#ctyp _a2
        | `Arrow (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Arrow@ %a@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1 self#ctyp _a2
        | `ClassPath (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`ClassPath@ %a@ %a)@]" self#loc _a0
              self#ident _a1
        | `Label (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Label@ %a@ %a@ %a)@]" self#loc _a0
              self#alident _a1 self#ctyp _a2
        | `Id (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Id@ %a@ %a)@]" self#loc _a0 self#ident
              _a1
        | `TyMan (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`TyMan@ %a@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1 self#ctyp _a2
        | `TyDcl (_a0,_a1,_a2,_a3,_a4) ->
            Format.fprintf fmt "@[<1>(`TyDcl@ %a@ %a@ %a@ %a@ %a)@]" 
              self#loc _a0 self#alident _a1
              (self#list (fun self  -> self#ctyp)) _a2 self#ctyp _a3
              (self#list
                 (fun self  fmt  (_a0,_a1)  ->
                    Format.fprintf fmt "@[<1>(%a,@,%a)@]" self#ctyp _a0
                      self#ctyp _a1)) _a4
        | `TyObj (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`TyObj@ %a@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1 self#row_var_flag _a2
        | `TyOlb (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`TyOlb@ %a@ %a@ %a)@]" self#loc _a0
              self#alident _a1 self#ctyp _a2
        | `TyPol (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`TyPol@ %a@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1 self#ctyp _a2
        | `TyTypePol (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`TyTypePol@ %a@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1 self#ctyp _a2
        | `Quote (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Quote@ %a@ %a@ %a)@]" self#loc _a0
              self#position_flag _a1
              (self#meta_option (fun self  -> self#alident)) _a2
        | `TyRec (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`TyRec@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1
        | `TyCol (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`TyCol@ %a@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1 self#ctyp _a2
        | `Sem (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Sem@ %a@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1 self#ctyp _a2
        | `Com (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Com@ %a@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1 self#ctyp _a2
        | `Sum (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Sum@ %a@ %a)@]" self#loc _a0 self#ctyp
              _a1
        | `Of (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Of@ %a@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1 self#ctyp _a2
        | `And (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`And@ %a@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1 self#ctyp _a2
        | `Or (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Or@ %a@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1 self#ctyp _a2
        | `Priv (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Priv@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1
        | `Mut (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Mut@ %a@ %a)@]" self#loc _a0 self#ctyp
              _a1
        | `Tup (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Tup@ %a@ %a)@]" self#loc _a0 self#ctyp
              _a1
        | `Sta (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Sta@ %a@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1 self#ctyp _a2
        | `TyVrn (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`TyVrn@ %a@ %a)@]" self#loc _a0
              self#astring _a1
        | `TyVrnEq (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`TyVrnEq@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1
        | `TyVrnSup (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`TyVrnSup@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1
        | `TyVrnInf (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`TyVrnInf@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1
        | `TyVrnInfSup (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`TyVrnInfSup@ %a@ %a@ %a)@]" self#loc
              _a0 self#ctyp _a1 self#ctyp _a2
        | `Amp (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Amp@ %a@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1 self#ctyp _a2
        | `TyOfAmp (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`TyOfAmp@ %a@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1 self#ctyp _a2
        | `Package (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Package@ %a@ %a)@]" self#loc _a0
              self#module_type _a1
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method patt : 'fmt -> patt -> 'result=
      fun fmt  ->
        function
        | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" self#loc _a0
        | `Id (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Id@ %a@ %a)@]" self#loc _a0 self#ident
              _a1
        | `Alias (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Alias@ %a@ %a@ %a)@]" self#loc _a0
              self#patt _a1 self#alident _a2
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
        | `Any _a0 -> Format.fprintf fmt "@[<1>(`Any@ %a)@]" self#loc _a0
        | `PaApp (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`PaApp@ %a@ %a@ %a)@]" self#loc _a0
              self#patt _a1 self#patt _a2
        | `Array (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Array@ %a@ %a)@]" self#loc _a0
              self#patt _a1
        | `Com (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Com@ %a@ %a@ %a)@]" self#loc _a0
              self#patt _a1 self#patt _a2
        | `Sem (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Sem@ %a@ %a@ %a)@]" self#loc _a0
              self#patt _a1 self#patt _a2
        | #literal as _a0 -> (self#literal fmt _a0 :>'result)
        | `Label (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Label@ %a@ %a@ %a)@]" self#loc _a0
              self#alident _a1 self#patt _a2
        | `PaOlbi (_a0,_a1,_a2,_a3) ->
            Format.fprintf fmt "@[<1>(`PaOlbi@ %a@ %a@ %a@ %a)@]" self#loc
              _a0 self#alident _a1 self#patt _a2
              (self#meta_option (fun self  -> self#expr)) _a3
        | `Or (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Or@ %a@ %a@ %a)@]" self#loc _a0
              self#patt _a1 self#patt _a2
        | `PaRng (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`PaRng@ %a@ %a@ %a)@]" self#loc _a0
              self#patt _a1 self#patt _a2
        | `PaRec (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`PaRec@ %a@ %a)@]" self#loc _a0
              self#patt _a1
        | `PaEq (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`PaEq@ %a@ %a@ %a)@]" self#loc _a0
              self#ident _a1 self#patt _a2
        | `Tup (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Tup@ %a@ %a)@]" self#loc _a0 self#patt
              _a1
        | `Constraint (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Constraint@ %a@ %a@ %a)@]" self#loc
              _a0 self#patt _a1 self#ctyp _a2
        | `ClassPath (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`ClassPath@ %a@ %a)@]" self#loc _a0
              self#ident _a1
        | `PaVrn (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`PaVrn@ %a@ %a)@]" self#loc _a0
              self#string _a1
        | `Lazy (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Lazy@ %a@ %a)@]" self#loc _a0
              self#patt _a1
        | `ModuleUnpack (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`ModuleUnpack@ %a@ %a@ %a)@]" self#loc
              _a0 self#auident _a1
              (self#meta_option (fun self  -> self#ctyp)) _a2
    method expr : 'fmt -> expr -> 'result=
      fun fmt  ->
        function
        | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" self#loc _a0
        | `Id (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Id@ %a@ %a)@]" self#loc _a0 self#ident
              _a1
        | `Dot (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Dot@ %a@ %a@ %a)@]" self#loc _a0
              self#expr _a1 self#expr _a2
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
        | `ExApp (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`ExApp@ %a@ %a@ %a)@]" self#loc _a0
              self#expr _a1 self#expr _a2
        | `ArrayDot (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`ArrayDot@ %a@ %a@ %a)@]" self#loc _a0
              self#expr _a1 self#expr _a2
        | `Array (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Array@ %a@ %a)@]" self#loc _a0
              self#expr _a1
        | `Sem (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Sem@ %a@ %a@ %a)@]" self#loc _a0
              self#expr _a1 self#expr _a2
        | `ExAsf _a0 -> Format.fprintf fmt "@[<1>(`ExAsf@ %a)@]" self#loc _a0
        | `ExAsr (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`ExAsr@ %a@ %a)@]" self#loc _a0
              self#expr _a1
        | `Assign (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Assign@ %a@ %a@ %a)@]" self#loc _a0
              self#expr _a1 self#expr _a2
        | `For (_a0,_a1,_a2,_a3,_a4,_a5) ->
            Format.fprintf fmt "@[<1>(`For@ %a@ %a@ %a@ %a@ %a@ %a)@]"
              self#loc _a0 self#alident _a1 self#expr _a2 self#expr _a3
              self#direction_flag _a4 self#expr _a5
        | `Fun (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Fun@ %a@ %a)@]" self#loc _a0
              self#match_case _a1
        | `IfThenElse (_a0,_a1,_a2,_a3) ->
            Format.fprintf fmt "@[<1>(`IfThenElse@ %a@ %a@ %a@ %a)@]"
              self#loc _a0 self#expr _a1 self#expr _a2 self#expr _a3
        | `IfThen (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`IfThen@ %a@ %a@ %a)@]" self#loc _a0
              self#expr _a1 self#expr _a2
        | #literal as _a0 -> (self#literal fmt _a0 :>'result)
        | `Label (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Label@ %a@ %a@ %a)@]" self#loc _a0
              self#alident _a1 self#expr _a2
        | `Lazy (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Lazy@ %a@ %a)@]" self#loc _a0
              self#expr _a1
        | `LetIn (_a0,_a1,_a2,_a3) ->
            Format.fprintf fmt "@[<1>(`LetIn@ %a@ %a@ %a@ %a)@]" self#loc _a0
              self#rec_flag _a1 self#binding _a2 self#expr _a3
        | `LetModule (_a0,_a1,_a2,_a3) ->
            Format.fprintf fmt "@[<1>(`LetModule@ %a@ %a@ %a@ %a)@]" 
              self#loc _a0 self#auident _a1 self#module_expr _a2 self#expr
              _a3
        | `Match (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Match@ %a@ %a@ %a)@]" self#loc _a0
              self#expr _a1 self#match_case _a2
        | `New (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`New@ %a@ %a)@]" self#loc _a0
              self#ident _a1
        | `Obj (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Obj@ %a@ %a@ %a)@]" self#loc _a0
              self#patt _a1 self#class_str_item _a2
        | `OptLabl (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`OptLabl@ %a@ %a@ %a)@]" self#loc _a0
              self#alident _a1 self#expr _a2
        | `OvrInst (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`OvrInst@ %a@ %a)@]" self#loc _a0
              self#rec_binding _a1
        | `Record (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Record@ %a@ %a@ %a)@]" self#loc _a0
              self#rec_binding _a1 self#expr _a2
        | `Seq (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Seq@ %a@ %a)@]" self#loc _a0 self#expr
              _a1
        | `Send (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Send@ %a@ %a@ %a)@]" self#loc _a0
              self#expr _a1 self#alident _a2
        | `StringDot (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`StringDot@ %a@ %a@ %a)@]" self#loc _a0
              self#expr _a1 self#expr _a2
        | `Try (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Try@ %a@ %a@ %a)@]" self#loc _a0
              self#expr _a1 self#match_case _a2
        | `Tup (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Tup@ %a@ %a)@]" self#loc _a0 self#expr
              _a1
        | `Com (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Com@ %a@ %a@ %a)@]" self#loc _a0
              self#expr _a1 self#expr _a2
        | `Constraint (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Constraint@ %a@ %a@ %a)@]" self#loc
              _a0 self#expr _a1 self#ctyp _a2
        | `Coercion (_a0,_a1,_a2,_a3) ->
            Format.fprintf fmt "@[<1>(`Coercion@ %a@ %a@ %a@ %a)@]" self#loc
              _a0 self#expr _a1 self#ctyp _a2 self#ctyp _a3
        | `ExVrn (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`ExVrn@ %a@ %a)@]" self#loc _a0
              self#string _a1
        | `While (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`While@ %a@ %a@ %a)@]" self#loc _a0
              self#expr _a1 self#expr _a2
        | `LetOpen (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`LetOpen@ %a@ %a@ %a)@]" self#loc _a0
              self#ident _a1 self#expr _a2
        | `LocalTypeFun (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`LocalTypeFun@ %a@ %a@ %a)@]" self#loc
              _a0 self#alident _a1 self#expr _a2
        | `Package_expr (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Package_expr@ %a@ %a)@]" self#loc _a0
              self#module_expr _a1
    method module_type : 'fmt -> module_type -> 'result=
      fun fmt  ->
        function
        | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" self#loc _a0
        | `Id (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Id@ %a@ %a)@]" self#loc _a0 self#ident
              _a1
        | `MtFun (_a0,_a1,_a2,_a3) ->
            Format.fprintf fmt "@[<1>(`MtFun@ %a@ %a@ %a@ %a)@]" self#loc _a0
              self#auident _a1 self#module_type _a2 self#module_type _a3
        | `Sig (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Sig@ %a@ %a)@]" self#loc _a0
              self#sig_item _a1
        | `With (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`With@ %a@ %a@ %a)@]" self#loc _a0
              self#module_type _a1 self#with_constr _a2
        | `ModuleTypeOf (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`ModuleTypeOf@ %a@ %a)@]" self#loc _a0
              self#module_expr _a1
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method sig_item : 'fmt -> sig_item -> 'result=
      fun fmt  ->
        function
        | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" self#loc _a0
        | `Class (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Class@ %a@ %a)@]" self#loc _a0
              self#class_type _a1
        | `ClassType (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`ClassType@ %a@ %a)@]" self#loc _a0
              self#class_type _a1
        | `Sem (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Sem@ %a@ %a@ %a)@]" self#loc _a0
              self#sig_item _a1 self#sig_item _a2
        | `Directive (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Directive@ %a@ %a@ %a)@]" self#loc _a0
              self#alident _a1 self#expr _a2
        | `Exception (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Exception@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1
        | `External (_a0,_a1,_a2,_a3) ->
            Format.fprintf fmt "@[<1>(`External@ %a@ %a@ %a@ %a)@]" self#loc
              _a0 self#alident _a1 self#ctyp _a2
              (self#meta_list (fun self  -> self#string)) _a3
        | `Include (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Include@ %a@ %a)@]" self#loc _a0
              self#module_type _a1
        | `Module (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Module@ %a@ %a@ %a)@]" self#loc _a0
              self#auident _a1 self#module_type _a2
        | `RecModule (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`RecModule@ %a@ %a)@]" self#loc _a0
              self#module_binding _a1
        | `ModuleType (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`ModuleType@ %a@ %a@ %a)@]" self#loc
              _a0 self#auident _a1 self#module_type _a2
        | `Open (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Open@ %a@ %a)@]" self#loc _a0
              self#ident _a1
        | `Type (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Type@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1
        | `Val (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Val@ %a@ %a@ %a)@]" self#loc _a0
              self#alident _a1 self#ctyp _a2
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method with_constr : 'fmt -> with_constr -> 'result=
      fun fmt  ->
        function
        | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" self#loc _a0
        | `TypeEq (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`TypeEq@ %a@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1 self#ctyp _a2
        | `ModuleEq (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`ModuleEq@ %a@ %a@ %a)@]" self#loc _a0
              self#ident _a1 self#ident _a2
        | `TypeSubst (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`TypeSubst@ %a@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1 self#ctyp _a2
        | `ModuleSubst (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`ModuleSubst@ %a@ %a@ %a)@]" self#loc
              _a0 self#ident _a1 self#ident _a2
        | `And (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`And@ %a@ %a@ %a)@]" self#loc _a0
              self#with_constr _a1 self#with_constr _a2
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method binding : 'fmt -> binding -> 'result=
      fun fmt  ->
        function
        | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" self#loc _a0
        | `And (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`And@ %a@ %a@ %a)@]" self#loc _a0
              self#binding _a1 self#binding _a2
        | `Bind (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Bind@ %a@ %a@ %a)@]" self#loc _a0
              self#patt _a1 self#expr _a2
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method rec_binding : 'fmt -> rec_binding -> 'result=
      fun fmt  ->
        function
        | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" self#loc _a0
        | `Sem (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Sem@ %a@ %a@ %a)@]" self#loc _a0
              self#rec_binding _a1 self#rec_binding _a2
        | `RecBind (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`RecBind@ %a@ %a@ %a)@]" self#loc _a0
              self#ident _a1 self#expr _a2
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method module_binding : 'fmt -> module_binding -> 'result=
      fun fmt  ->
        function
        | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" self#loc _a0
        | `And (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`And@ %a@ %a@ %a)@]" self#loc _a0
              self#module_binding _a1 self#module_binding _a2
        | `ModuleBind (_a0,_a1,_a2,_a3) ->
            Format.fprintf fmt "@[<1>(`ModuleBind@ %a@ %a@ %a@ %a)@]"
              self#loc _a0 self#auident _a1 self#module_type _a2
              self#module_expr _a3
        | `Constraint (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Constraint@ %a@ %a@ %a)@]" self#loc
              _a0 self#auident _a1 self#module_type _a2
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method match_case : 'fmt -> match_case -> 'result=
      fun fmt  ->
        function
        | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" self#loc _a0
        | `Or (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Or@ %a@ %a@ %a)@]" self#loc _a0
              self#match_case _a1 self#match_case _a2
        | `Case (_a0,_a1,_a2,_a3) ->
            Format.fprintf fmt "@[<1>(`Case@ %a@ %a@ %a@ %a)@]" self#loc _a0
              self#patt _a1 self#expr _a2 self#expr _a3
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method module_expr : 'fmt -> module_expr -> 'result=
      fun fmt  ->
        function
        | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" self#loc _a0
        | `Id (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Id@ %a@ %a)@]" self#loc _a0 self#ident
              _a1
        | `MeApp (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`MeApp@ %a@ %a@ %a)@]" self#loc _a0
              self#module_expr _a1 self#module_expr _a2
        | `Functor (_a0,_a1,_a2,_a3) ->
            Format.fprintf fmt "@[<1>(`Functor@ %a@ %a@ %a@ %a)@]" self#loc
              _a0 self#auident _a1 self#module_type _a2 self#module_expr _a3
        | `Struct (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Struct@ %a@ %a)@]" self#loc _a0
              self#str_item _a1
        | `Constraint (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Constraint@ %a@ %a@ %a)@]" self#loc
              _a0 self#module_expr _a1 self#module_type _a2
        | `PackageModule (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`PackageModule@ %a@ %a)@]" self#loc _a0
              self#expr _a1
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method str_item : 'fmt -> str_item -> 'result=
      fun fmt  ->
        function
        | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" self#loc _a0
        | `Class (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Class@ %a@ %a)@]" self#loc _a0
              self#class_expr _a1
        | `ClassType (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`ClassType@ %a@ %a)@]" self#loc _a0
              self#class_type _a1
        | `Sem (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Sem@ %a@ %a@ %a)@]" self#loc _a0
              self#str_item _a1 self#str_item _a2
        | `Directive (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Directive@ %a@ %a@ %a)@]" self#loc _a0
              self#alident _a1 self#expr _a2
        | `Exception (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Exception@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1
        | `StExp (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`StExp@ %a@ %a)@]" self#loc _a0
              self#expr _a1
        | `External (_a0,_a1,_a2,_a3) ->
            Format.fprintf fmt "@[<1>(`External@ %a@ %a@ %a@ %a)@]" self#loc
              _a0 self#alident _a1 self#ctyp _a2
              (self#meta_list (fun self  -> self#string)) _a3
        | `Include (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Include@ %a@ %a)@]" self#loc _a0
              self#module_expr _a1
        | `Module (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Module@ %a@ %a@ %a)@]" self#loc _a0
              self#auident _a1 self#module_expr _a2
        | `RecModule (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`RecModule@ %a@ %a)@]" self#loc _a0
              self#module_binding _a1
        | `ModuleType (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`ModuleType@ %a@ %a@ %a)@]" self#loc
              _a0 self#auident _a1 self#module_type _a2
        | `Open (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Open@ %a@ %a)@]" self#loc _a0
              self#ident _a1
        | `Type (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Type@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1
        | `Value (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Value@ %a@ %a@ %a)@]" self#loc _a0
              self#rec_flag _a1 self#binding _a2
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method class_type : 'fmt -> class_type -> 'result=
      fun fmt  ->
        function
        | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" self#loc _a0
        | `CtCon (_a0,_a1,_a2,_a3) ->
            Format.fprintf fmt "@[<1>(`CtCon@ %a@ %a@ %a@ %a)@]" self#loc _a0
              self#virtual_flag _a1 self#ident _a2 self#ctyp _a3
        | `CtFun (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`CtFun@ %a@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1 self#class_type _a2
        | `CtSig (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`CtSig@ %a@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1 self#class_sig_item _a2
        | `And (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`And@ %a@ %a@ %a)@]" self#loc _a0
              self#class_type _a1 self#class_type _a2
        | `CtCol (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`CtCol@ %a@ %a@ %a)@]" self#loc _a0
              self#class_type _a1 self#class_type _a2
        | `CtEq (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`CtEq@ %a@ %a@ %a)@]" self#loc _a0
              self#class_type _a1 self#class_type _a2
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method class_sig_item : 'fmt -> class_sig_item -> 'result=
      fun fmt  ->
        function
        | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" self#loc _a0
        | `Eq (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Eq@ %a@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1 self#ctyp _a2
        | `Sem (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Sem@ %a@ %a@ %a)@]" self#loc _a0
              self#class_sig_item _a1 self#class_sig_item _a2
        | `SigInherit (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`SigInherit@ %a@ %a)@]" self#loc _a0
              self#class_type _a1
        | `Method (_a0,_a1,_a2,_a3) ->
            Format.fprintf fmt "@[<1>(`Method@ %a@ %a@ %a@ %a)@]" self#loc
              _a0 self#alident _a1 self#private_flag _a2 self#ctyp _a3
        | `CgVal (_a0,_a1,_a2,_a3,_a4) ->
            Format.fprintf fmt "@[<1>(`CgVal@ %a@ %a@ %a@ %a@ %a)@]" 
              self#loc _a0 self#alident _a1 self#mutable_flag _a2
              self#virtual_flag _a3 self#ctyp _a4
        | `CgVir (_a0,_a1,_a2,_a3) ->
            Format.fprintf fmt "@[<1>(`CgVir@ %a@ %a@ %a@ %a)@]" self#loc _a0
              self#alident _a1 self#private_flag _a2 self#ctyp _a3
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method class_expr : 'fmt -> class_expr -> 'result=
      fun fmt  ->
        function
        | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" self#loc _a0
        | `CeApp (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`CeApp@ %a@ %a@ %a)@]" self#loc _a0
              self#class_expr _a1 self#expr _a2
        | `CeCon (_a0,_a1,_a2,_a3) ->
            Format.fprintf fmt "@[<1>(`CeCon@ %a@ %a@ %a@ %a)@]" self#loc _a0
              self#virtual_flag _a1 self#ident _a2 self#ctyp _a3
        | `CeFun (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`CeFun@ %a@ %a@ %a)@]" self#loc _a0
              self#patt _a1 self#class_expr _a2
        | `CeLet (_a0,_a1,_a2,_a3) ->
            Format.fprintf fmt "@[<1>(`CeLet@ %a@ %a@ %a@ %a)@]" self#loc _a0
              self#rec_flag _a1 self#binding _a2 self#class_expr _a3
        | `Obj (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Obj@ %a@ %a@ %a)@]" self#loc _a0
              self#patt _a1 self#class_str_item _a2
        | `CeTyc (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`CeTyc@ %a@ %a@ %a)@]" self#loc _a0
              self#class_expr _a1 self#class_type _a2
        | `And (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`And@ %a@ %a@ %a)@]" self#loc _a0
              self#class_expr _a1 self#class_expr _a2
        | `Eq (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Eq@ %a@ %a@ %a)@]" self#loc _a0
              self#class_expr _a1 self#class_expr _a2
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method class_str_item : 'fmt -> class_str_item -> 'result=
      fun fmt  ->
        function
        | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" self#loc _a0
        | `Sem (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Sem@ %a@ %a@ %a)@]" self#loc _a0
              self#class_str_item _a1 self#class_str_item _a2
        | `Eq (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Eq@ %a@ %a@ %a)@]" self#loc _a0
              self#ctyp _a1 self#ctyp _a2
        | `Inherit (_a0,_a1,_a2,_a3) ->
            Format.fprintf fmt "@[<1>(`Inherit@ %a@ %a@ %a@ %a)@]" self#loc
              _a0 self#override_flag _a1 self#class_expr _a2
              (self#meta_option (fun self  -> self#alident)) _a3
        | `Initializer (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Initializer@ %a@ %a)@]" self#loc _a0
              self#expr _a1
        | `CrMth (_a0,_a1,_a2,_a3,_a4,_a5) ->
            Format.fprintf fmt "@[<1>(`CrMth@ %a@ %a@ %a@ %a@ %a@ %a)@]"
              self#loc _a0 self#alident _a1 self#override_flag _a2
              self#private_flag _a3 self#expr _a4 self#ctyp _a5
        | `CrVal (_a0,_a1,_a2,_a3,_a4) ->
            Format.fprintf fmt "@[<1>(`CrVal@ %a@ %a@ %a@ %a@ %a)@]" 
              self#loc _a0 self#alident _a1 self#override_flag _a2
              self#mutable_flag _a3 self#expr _a4
        | `CrVir (_a0,_a1,_a2,_a3) ->
            Format.fprintf fmt "@[<1>(`CrVir@ %a@ %a@ %a@ %a)@]" self#loc _a0
              self#alident _a1 self#private_flag _a2 self#ctyp _a3
        | `CrVvr (_a0,_a1,_a2,_a3) ->
            Format.fprintf fmt "@[<1>(`CrVvr@ %a@ %a@ %a@ %a)@]" self#loc _a0
              self#alident _a1 self#mutable_flag _a2 self#ctyp _a3
        | #ant as _a0 -> (self#ant fmt _a0 :>'result)
    method fanloc_t : 'fmt -> FanLoc.t -> 'result= self#unknown
    method fanutil_anti_cxt : 'fmt -> FanUtil.anti_cxt -> 'result=
      self#unknown
  end
class fold =
  object (self : 'self_type)
    inherit  foldbase
    method loc : loc -> 'self_type= fun _a0  -> self#fanloc_t _a0
    method ant : ant -> 'self_type=
      fun (`Ant (_a0,_a1))  ->
        let self = self#loc _a0 in self#fanutil_anti_cxt _a1
    method literal : literal -> 'self_type=
      function
      | `Chr (_a0,_a1) -> let self = self#loc _a0 in self#string _a1
      | `Int (_a0,_a1) -> let self = self#loc _a0 in self#string _a1
      | `Int32 (_a0,_a1) -> let self = self#loc _a0 in self#string _a1
      | `Int64 (_a0,_a1) -> let self = self#loc _a0 in self#string _a1
      | `Flo (_a0,_a1) -> let self = self#loc _a0 in self#string _a1
      | `NativeInt (_a0,_a1) -> let self = self#loc _a0 in self#string _a1
      | `Str (_a0,_a1) -> let self = self#loc _a0 in self#string _a1
    method rec_flag : rec_flag -> 'self_type=
      function
      | `Recursive _a0 -> self#loc _a0
      | `ReNil _a0 -> self#loc _a0
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method direction_flag : direction_flag -> 'self_type=
      function
      | `To _a0 -> self#loc _a0
      | `Downto _a0 -> self#loc _a0
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method mutable_flag : mutable_flag -> 'self_type=
      function
      | `Mutable _a0 -> self#loc _a0
      | `MuNil _a0 -> self#loc _a0
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method private_flag : private_flag -> 'self_type=
      function
      | `Private _a0 -> self#loc _a0
      | `PrNil _a0 -> self#loc _a0
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method virtual_flag : virtual_flag -> 'self_type=
      function
      | `Virtual _a0 -> self#loc _a0
      | `ViNil _a0 -> self#loc _a0
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method override_flag : override_flag -> 'self_type=
      function
      | `Override _a0 -> self#loc _a0
      | `OvNil _a0 -> self#loc _a0
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method row_var_flag : row_var_flag -> 'self_type=
      function
      | `RowVar _a0 -> self#loc _a0
      | `RvNil _a0 -> self#loc _a0
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method position_flag : position_flag -> 'self_type=
      function
      | `Positive _a0 -> self#loc _a0
      | `Negative _a0 -> self#loc _a0
      | `Normal _a0 -> self#loc _a0
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method meta_bool : meta_bool -> 'self_type=
      function
      | `True _a0 -> self#loc _a0
      | `False _a0 -> self#loc _a0
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method meta_option :
      'all_a0 .
        ('self_type -> 'all_a0 -> 'self_type) ->
          'all_a0 meta_option -> 'self_type=
      fun mf_a  ->
        function
        | `None _a0 -> self#loc _a0
        | `Some _a0 -> mf_a self _a0
        | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method meta_list :
      'all_a0 .
        ('self_type -> 'all_a0 -> 'self_type) ->
          'all_a0 meta_list -> 'self_type=
      fun mf_a  ->
        function
        | `LNil _a0 -> self#loc _a0
        | `LCons (_a0,_a1) ->
            let self = mf_a self _a0 in self#meta_list mf_a _a1
        | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method alident : alident -> 'self_type=
      function
      | `Lid (_a0,_a1) -> let self = self#loc _a0 in self#string _a1
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method auident : auident -> 'self_type=
      function
      | `Uid (_a0,_a1) -> let self = self#loc _a0 in self#string _a1
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method aident : aident -> 'self_type=
      function
      | #alident as _a0 -> (self#alident _a0 :>'self_type)
      | #auident as _a0 -> (self#auident _a0 :>'self_type)
    method astring : astring -> 'self_type=
      function
      | `C (_a0,_a1) -> let self = self#loc _a0 in self#string _a1
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method ident : ident -> 'self_type=
      function
      | `Dot (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ident _a1 in self#ident _a2
      | `IdApp (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ident _a1 in self#ident _a2
      | #alident as _a0 -> (self#alident _a0 :>'self_type)
      | #auident as _a0 -> (self#auident _a0 :>'self_type)
    method ctyp : ctyp -> 'self_type=
      function
      | `Nil _a0 -> self#loc _a0
      | `Alias (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#ctyp _a2
      | `Any _a0 -> self#loc _a0
      | `TyApp (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#ctyp _a2
      | `Arrow (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#ctyp _a2
      | `ClassPath (_a0,_a1) -> let self = self#loc _a0 in self#ident _a1
      | `Label (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#alident _a1 in self#ctyp _a2
      | `Id (_a0,_a1) -> let self = self#loc _a0 in self#ident _a1
      | `TyMan (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#ctyp _a2
      | `TyDcl (_a0,_a1,_a2,_a3,_a4) ->
          let self = self#loc _a0 in
          let self = self#alident _a1 in
          let self = self#list (fun self  -> self#ctyp) _a2 in
          let self = self#ctyp _a3 in
          self#list
            (fun self  (_a0,_a1)  ->
               let self = self#ctyp _a0 in self#ctyp _a1) _a4
      | `TyObj (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#row_var_flag _a2
      | `TyOlb (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#alident _a1 in self#ctyp _a2
      | `TyPol (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#ctyp _a2
      | `TyTypePol (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#ctyp _a2
      | `Quote (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#position_flag _a1 in
          self#meta_option (fun self  -> self#alident) _a2
      | `TyRec (_a0,_a1) -> let self = self#loc _a0 in self#ctyp _a1
      | `TyCol (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#ctyp _a2
      | `Sem (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#ctyp _a2
      | `Com (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#ctyp _a2
      | `Sum (_a0,_a1) -> let self = self#loc _a0 in self#ctyp _a1
      | `Of (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#ctyp _a2
      | `And (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#ctyp _a2
      | `Or (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#ctyp _a2
      | `Priv (_a0,_a1) -> let self = self#loc _a0 in self#ctyp _a1
      | `Mut (_a0,_a1) -> let self = self#loc _a0 in self#ctyp _a1
      | `Tup (_a0,_a1) -> let self = self#loc _a0 in self#ctyp _a1
      | `Sta (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#ctyp _a2
      | `TyVrn (_a0,_a1) -> let self = self#loc _a0 in self#astring _a1
      | `TyVrnEq (_a0,_a1) -> let self = self#loc _a0 in self#ctyp _a1
      | `TyVrnSup (_a0,_a1) -> let self = self#loc _a0 in self#ctyp _a1
      | `TyVrnInf (_a0,_a1) -> let self = self#loc _a0 in self#ctyp _a1
      | `TyVrnInfSup (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#ctyp _a2
      | `Amp (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#ctyp _a2
      | `TyOfAmp (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#ctyp _a2
      | `Package (_a0,_a1) -> let self = self#loc _a0 in self#module_type _a1
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method patt : patt -> 'self_type=
      function
      | `Nil _a0 -> self#loc _a0
      | `Id (_a0,_a1) -> let self = self#loc _a0 in self#ident _a1
      | `Alias (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#patt _a1 in self#alident _a2
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
      | `Any _a0 -> self#loc _a0
      | `PaApp (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#patt _a1 in self#patt _a2
      | `Array (_a0,_a1) -> let self = self#loc _a0 in self#patt _a1
      | `Com (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#patt _a1 in self#patt _a2
      | `Sem (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#patt _a1 in self#patt _a2
      | #literal as _a0 -> (self#literal _a0 :>'self_type)
      | `Label (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#alident _a1 in self#patt _a2
      | `PaOlbi (_a0,_a1,_a2,_a3) ->
          let self = self#loc _a0 in
          let self = self#alident _a1 in
          let self = self#patt _a2 in
          self#meta_option (fun self  -> self#expr) _a3
      | `Or (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#patt _a1 in self#patt _a2
      | `PaRng (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#patt _a1 in self#patt _a2
      | `PaRec (_a0,_a1) -> let self = self#loc _a0 in self#patt _a1
      | `PaEq (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ident _a1 in self#patt _a2
      | `Tup (_a0,_a1) -> let self = self#loc _a0 in self#patt _a1
      | `Constraint (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#patt _a1 in self#ctyp _a2
      | `ClassPath (_a0,_a1) -> let self = self#loc _a0 in self#ident _a1
      | `PaVrn (_a0,_a1) -> let self = self#loc _a0 in self#string _a1
      | `Lazy (_a0,_a1) -> let self = self#loc _a0 in self#patt _a1
      | `ModuleUnpack (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#auident _a1 in
          self#meta_option (fun self  -> self#ctyp) _a2
    method expr : expr -> 'self_type=
      function
      | `Nil _a0 -> self#loc _a0
      | `Id (_a0,_a1) -> let self = self#loc _a0 in self#ident _a1
      | `Dot (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#expr _a1 in self#expr _a2
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
      | `ExApp (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#expr _a1 in self#expr _a2
      | `ArrayDot (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#expr _a1 in self#expr _a2
      | `Array (_a0,_a1) -> let self = self#loc _a0 in self#expr _a1
      | `Sem (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#expr _a1 in self#expr _a2
      | `ExAsf _a0 -> self#loc _a0
      | `ExAsr (_a0,_a1) -> let self = self#loc _a0 in self#expr _a1
      | `Assign (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#expr _a1 in self#expr _a2
      | `For (_a0,_a1,_a2,_a3,_a4,_a5) ->
          let self = self#loc _a0 in
          let self = self#alident _a1 in
          let self = self#expr _a2 in
          let self = self#expr _a3 in
          let self = self#direction_flag _a4 in self#expr _a5
      | `Fun (_a0,_a1) -> let self = self#loc _a0 in self#match_case _a1
      | `IfThenElse (_a0,_a1,_a2,_a3) ->
          let self = self#loc _a0 in
          let self = self#expr _a1 in
          let self = self#expr _a2 in self#expr _a3
      | `IfThen (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#expr _a1 in self#expr _a2
      | #literal as _a0 -> (self#literal _a0 :>'self_type)
      | `Label (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#alident _a1 in self#expr _a2
      | `Lazy (_a0,_a1) -> let self = self#loc _a0 in self#expr _a1
      | `LetIn (_a0,_a1,_a2,_a3) ->
          let self = self#loc _a0 in
          let self = self#rec_flag _a1 in
          let self = self#binding _a2 in self#expr _a3
      | `LetModule (_a0,_a1,_a2,_a3) ->
          let self = self#loc _a0 in
          let self = self#auident _a1 in
          let self = self#module_expr _a2 in self#expr _a3
      | `Match (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#expr _a1 in self#match_case _a2
      | `New (_a0,_a1) -> let self = self#loc _a0 in self#ident _a1
      | `Obj (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#patt _a1 in self#class_str_item _a2
      | `OptLabl (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#alident _a1 in self#expr _a2
      | `OvrInst (_a0,_a1) -> let self = self#loc _a0 in self#rec_binding _a1
      | `Record (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#rec_binding _a1 in self#expr _a2
      | `Seq (_a0,_a1) -> let self = self#loc _a0 in self#expr _a1
      | `Send (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#expr _a1 in self#alident _a2
      | `StringDot (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#expr _a1 in self#expr _a2
      | `Try (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#expr _a1 in self#match_case _a2
      | `Tup (_a0,_a1) -> let self = self#loc _a0 in self#expr _a1
      | `Com (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#expr _a1 in self#expr _a2
      | `Constraint (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#expr _a1 in self#ctyp _a2
      | `Coercion (_a0,_a1,_a2,_a3) ->
          let self = self#loc _a0 in
          let self = self#expr _a1 in
          let self = self#ctyp _a2 in self#ctyp _a3
      | `ExVrn (_a0,_a1) -> let self = self#loc _a0 in self#string _a1
      | `While (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#expr _a1 in self#expr _a2
      | `LetOpen (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ident _a1 in self#expr _a2
      | `LocalTypeFun (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#alident _a1 in self#expr _a2
      | `Package_expr (_a0,_a1) ->
          let self = self#loc _a0 in self#module_expr _a1
    method module_type : module_type -> 'self_type=
      function
      | `Nil _a0 -> self#loc _a0
      | `Id (_a0,_a1) -> let self = self#loc _a0 in self#ident _a1
      | `MtFun (_a0,_a1,_a2,_a3) ->
          let self = self#loc _a0 in
          let self = self#auident _a1 in
          let self = self#module_type _a2 in self#module_type _a3
      | `Sig (_a0,_a1) -> let self = self#loc _a0 in self#sig_item _a1
      | `With (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#module_type _a1 in self#with_constr _a2
      | `ModuleTypeOf (_a0,_a1) ->
          let self = self#loc _a0 in self#module_expr _a1
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method sig_item : sig_item -> 'self_type=
      function
      | `Nil _a0 -> self#loc _a0
      | `Class (_a0,_a1) -> let self = self#loc _a0 in self#class_type _a1
      | `ClassType (_a0,_a1) ->
          let self = self#loc _a0 in self#class_type _a1
      | `Sem (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#sig_item _a1 in self#sig_item _a2
      | `Directive (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#alident _a1 in self#expr _a2
      | `Exception (_a0,_a1) -> let self = self#loc _a0 in self#ctyp _a1
      | `External (_a0,_a1,_a2,_a3) ->
          let self = self#loc _a0 in
          let self = self#alident _a1 in
          let self = self#ctyp _a2 in
          self#meta_list (fun self  -> self#string) _a3
      | `Include (_a0,_a1) -> let self = self#loc _a0 in self#module_type _a1
      | `Module (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#auident _a1 in self#module_type _a2
      | `RecModule (_a0,_a1) ->
          let self = self#loc _a0 in self#module_binding _a1
      | `ModuleType (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#auident _a1 in self#module_type _a2
      | `Open (_a0,_a1) -> let self = self#loc _a0 in self#ident _a1
      | `Type (_a0,_a1) -> let self = self#loc _a0 in self#ctyp _a1
      | `Val (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#alident _a1 in self#ctyp _a2
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method with_constr : with_constr -> 'self_type=
      function
      | `Nil _a0 -> self#loc _a0
      | `TypeEq (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#ctyp _a2
      | `ModuleEq (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ident _a1 in self#ident _a2
      | `TypeSubst (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#ctyp _a2
      | `ModuleSubst (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ident _a1 in self#ident _a2
      | `And (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#with_constr _a1 in self#with_constr _a2
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method binding : binding -> 'self_type=
      function
      | `Nil _a0 -> self#loc _a0
      | `And (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#binding _a1 in self#binding _a2
      | `Bind (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#patt _a1 in self#expr _a2
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method rec_binding : rec_binding -> 'self_type=
      function
      | `Nil _a0 -> self#loc _a0
      | `Sem (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#rec_binding _a1 in self#rec_binding _a2
      | `RecBind (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ident _a1 in self#expr _a2
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method module_binding : module_binding -> 'self_type=
      function
      | `Nil _a0 -> self#loc _a0
      | `And (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#module_binding _a1 in self#module_binding _a2
      | `ModuleBind (_a0,_a1,_a2,_a3) ->
          let self = self#loc _a0 in
          let self = self#auident _a1 in
          let self = self#module_type _a2 in self#module_expr _a3
      | `Constraint (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#auident _a1 in self#module_type _a2
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method match_case : match_case -> 'self_type=
      function
      | `Nil _a0 -> self#loc _a0
      | `Or (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#match_case _a1 in self#match_case _a2
      | `Case (_a0,_a1,_a2,_a3) ->
          let self = self#loc _a0 in
          let self = self#patt _a1 in
          let self = self#expr _a2 in self#expr _a3
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method module_expr : module_expr -> 'self_type=
      function
      | `Nil _a0 -> self#loc _a0
      | `Id (_a0,_a1) -> let self = self#loc _a0 in self#ident _a1
      | `MeApp (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#module_expr _a1 in self#module_expr _a2
      | `Functor (_a0,_a1,_a2,_a3) ->
          let self = self#loc _a0 in
          let self = self#auident _a1 in
          let self = self#module_type _a2 in self#module_expr _a3
      | `Struct (_a0,_a1) -> let self = self#loc _a0 in self#str_item _a1
      | `Constraint (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#module_expr _a1 in self#module_type _a2
      | `PackageModule (_a0,_a1) -> let self = self#loc _a0 in self#expr _a1
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method str_item : str_item -> 'self_type=
      function
      | `Nil _a0 -> self#loc _a0
      | `Class (_a0,_a1) -> let self = self#loc _a0 in self#class_expr _a1
      | `ClassType (_a0,_a1) ->
          let self = self#loc _a0 in self#class_type _a1
      | `Sem (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#str_item _a1 in self#str_item _a2
      | `Directive (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#alident _a1 in self#expr _a2
      | `Exception (_a0,_a1) -> let self = self#loc _a0 in self#ctyp _a1
      | `StExp (_a0,_a1) -> let self = self#loc _a0 in self#expr _a1
      | `External (_a0,_a1,_a2,_a3) ->
          let self = self#loc _a0 in
          let self = self#alident _a1 in
          let self = self#ctyp _a2 in
          self#meta_list (fun self  -> self#string) _a3
      | `Include (_a0,_a1) -> let self = self#loc _a0 in self#module_expr _a1
      | `Module (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#auident _a1 in self#module_expr _a2
      | `RecModule (_a0,_a1) ->
          let self = self#loc _a0 in self#module_binding _a1
      | `ModuleType (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#auident _a1 in self#module_type _a2
      | `Open (_a0,_a1) -> let self = self#loc _a0 in self#ident _a1
      | `Type (_a0,_a1) -> let self = self#loc _a0 in self#ctyp _a1
      | `Value (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#rec_flag _a1 in self#binding _a2
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method class_type : class_type -> 'self_type=
      function
      | `Nil _a0 -> self#loc _a0
      | `CtCon (_a0,_a1,_a2,_a3) ->
          let self = self#loc _a0 in
          let self = self#virtual_flag _a1 in
          let self = self#ident _a2 in self#ctyp _a3
      | `CtFun (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#class_type _a2
      | `CtSig (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#class_sig_item _a2
      | `And (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#class_type _a1 in self#class_type _a2
      | `CtCol (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#class_type _a1 in self#class_type _a2
      | `CtEq (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#class_type _a1 in self#class_type _a2
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method class_sig_item : class_sig_item -> 'self_type=
      function
      | `Nil _a0 -> self#loc _a0
      | `Eq (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#ctyp _a2
      | `Sem (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#class_sig_item _a1 in self#class_sig_item _a2
      | `SigInherit (_a0,_a1) ->
          let self = self#loc _a0 in self#class_type _a1
      | `Method (_a0,_a1,_a2,_a3) ->
          let self = self#loc _a0 in
          let self = self#alident _a1 in
          let self = self#private_flag _a2 in self#ctyp _a3
      | `CgVal (_a0,_a1,_a2,_a3,_a4) ->
          let self = self#loc _a0 in
          let self = self#alident _a1 in
          let self = self#mutable_flag _a2 in
          let self = self#virtual_flag _a3 in self#ctyp _a4
      | `CgVir (_a0,_a1,_a2,_a3) ->
          let self = self#loc _a0 in
          let self = self#alident _a1 in
          let self = self#private_flag _a2 in self#ctyp _a3
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method class_expr : class_expr -> 'self_type=
      function
      | `Nil _a0 -> self#loc _a0
      | `CeApp (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#class_expr _a1 in self#expr _a2
      | `CeCon (_a0,_a1,_a2,_a3) ->
          let self = self#loc _a0 in
          let self = self#virtual_flag _a1 in
          let self = self#ident _a2 in self#ctyp _a3
      | `CeFun (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#patt _a1 in self#class_expr _a2
      | `CeLet (_a0,_a1,_a2,_a3) ->
          let self = self#loc _a0 in
          let self = self#rec_flag _a1 in
          let self = self#binding _a2 in self#class_expr _a3
      | `Obj (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#patt _a1 in self#class_str_item _a2
      | `CeTyc (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#class_expr _a1 in self#class_type _a2
      | `And (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#class_expr _a1 in self#class_expr _a2
      | `Eq (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#class_expr _a1 in self#class_expr _a2
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method class_str_item : class_str_item -> 'self_type=
      function
      | `Nil _a0 -> self#loc _a0
      | `Sem (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#class_str_item _a1 in self#class_str_item _a2
      | `Eq (_a0,_a1,_a2) ->
          let self = self#loc _a0 in
          let self = self#ctyp _a1 in self#ctyp _a2
      | `Inherit (_a0,_a1,_a2,_a3) ->
          let self = self#loc _a0 in
          let self = self#override_flag _a1 in
          let self = self#class_expr _a2 in
          self#meta_option (fun self  -> self#alident) _a3
      | `Initializer (_a0,_a1) -> let self = self#loc _a0 in self#expr _a1
      | `CrMth (_a0,_a1,_a2,_a3,_a4,_a5) ->
          let self = self#loc _a0 in
          let self = self#alident _a1 in
          let self = self#override_flag _a2 in
          let self = self#private_flag _a3 in
          let self = self#expr _a4 in self#ctyp _a5
      | `CrVal (_a0,_a1,_a2,_a3,_a4) ->
          let self = self#loc _a0 in
          let self = self#alident _a1 in
          let self = self#override_flag _a2 in
          let self = self#mutable_flag _a3 in self#expr _a4
      | `CrVir (_a0,_a1,_a2,_a3) ->
          let self = self#loc _a0 in
          let self = self#alident _a1 in
          let self = self#private_flag _a2 in self#ctyp _a3
      | `CrVvr (_a0,_a1,_a2,_a3) ->
          let self = self#loc _a0 in
          let self = self#alident _a1 in
          let self = self#mutable_flag _a2 in self#ctyp _a3
      | #ant as _a0 -> (self#ant _a0 :>'self_type)
    method fanloc_t : FanLoc.t -> 'self_type= self#unknown
    method fanutil_anti_cxt : FanUtil.anti_cxt -> 'self_type= self#unknown
  end
let strip_loc_ant: ant -> 'result = fun (`Ant (_a0,_a1))  -> `Ant _a1
let strip_loc_literal: literal -> 'result =
  function
  | `Chr (_a0,_a1) -> `Chr _a1
  | `Int (_a0,_a1) -> `Int _a1
  | `Int32 (_a0,_a1) -> `Int32 _a1
  | `Int64 (_a0,_a1) -> `Int64 _a1
  | `Flo (_a0,_a1) -> `Flo _a1
  | `NativeInt (_a0,_a1) -> `NativeInt _a1
  | `Str (_a0,_a1) -> `Str _a1
let strip_loc_rec_flag: rec_flag -> 'result =
  function
  | `Recursive _a0 -> `Recursive
  | `ReNil _a0 -> `ReNil
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
let strip_loc_direction_flag: direction_flag -> 'result =
  function
  | `To _a0 -> `To
  | `Downto _a0 -> `Downto
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
let strip_loc_mutable_flag: mutable_flag -> 'result =
  function
  | `Mutable _a0 -> `Mutable
  | `MuNil _a0 -> `MuNil
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
let strip_loc_private_flag: private_flag -> 'result =
  function
  | `Private _a0 -> `Private
  | `PrNil _a0 -> `PrNil
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
let strip_loc_virtual_flag: virtual_flag -> 'result =
  function
  | `Virtual _a0 -> `Virtual
  | `ViNil _a0 -> `ViNil
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
let strip_loc_override_flag: override_flag -> 'result =
  function
  | `Override _a0 -> `Override
  | `OvNil _a0 -> `OvNil
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
let strip_loc_row_var_flag: row_var_flag -> 'result =
  function
  | `RowVar _a0 -> `RowVar
  | `RvNil _a0 -> `RvNil
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
let strip_loc_position_flag: position_flag -> 'result =
  function
  | `Positive _a0 -> `Positive
  | `Negative _a0 -> `Negative
  | `Normal _a0 -> `Normal
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
let strip_loc_meta_bool: meta_bool -> 'result =
  function
  | `True _a0 -> `True
  | `False _a0 -> `False
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
let strip_loc_meta_option :
  'all_a0 . ('all_a0 -> 'result) -> 'all_a0 meta_option -> 'result=
  fun mf_a  ->
    function
    | `None _a0 -> `None
    | `Some _a0 -> `Some
    | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
let rec strip_loc_meta_list :
  'all_a0 . ('all_a0 -> 'result) -> 'all_a0 meta_list -> 'result=
  fun mf_a  ->
    function
    | `LNil _a0 -> `LNil
    | `LCons (_a0,_a1) ->
        let _a1 = strip_loc_meta_list mf_a _a1 in `LCons _a1
    | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
let strip_loc_alident: alident -> 'result =
  function
  | `Lid (_a0,_a1) -> `Lid _a1
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
let strip_loc_auident: auident -> 'result =
  function
  | `Uid (_a0,_a1) -> `Uid _a1
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
let strip_loc_aident: aident -> 'result =
  function
  | #alident as _a0 -> (strip_loc_alident _a0 :>'result)
  | #auident as _a0 -> (strip_loc_auident _a0 :>'result)
let strip_loc_astring: astring -> 'result =
  function
  | `C (_a0,_a1) -> `C _a1
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
let rec strip_loc_ident: ident -> 'result =
  function
  | `Dot (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ident _a1 in
      let _a2 = strip_loc_ident _a2 in `Dot (_a1, _a2)
  | `IdApp (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ident _a1 in
      let _a2 = strip_loc_ident _a2 in `IdApp (_a1, _a2)
  | #alident as _a0 -> (strip_loc_alident _a0 :>'result)
  | #auident as _a0 -> (strip_loc_auident _a0 :>'result)
let rec strip_loc_ctyp: ctyp -> 'result =
  function
  | `Nil _a0 -> `Nil
  | `Alias (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_ctyp _a2 in `Alias (_a1, _a2)
  | `Any _a0 -> `Any
  | `TyApp (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_ctyp _a2 in `TyApp (_a1, _a2)
  | `Arrow (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_ctyp _a2 in `Arrow (_a1, _a2)
  | `ClassPath (_a0,_a1) -> let _a1 = strip_loc_ident _a1 in `ClassPath _a1
  | `Label (_a0,_a1,_a2) ->
      let _a1 = strip_loc_alident _a1 in
      let _a2 = strip_loc_ctyp _a2 in `Label (_a1, _a2)
  | `Id (_a0,_a1) -> let _a1 = strip_loc_ident _a1 in `Id _a1
  | `TyMan (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_ctyp _a2 in `TyMan (_a1, _a2)
  | `TyDcl (_a0,_a1,_a2,_a3,_a4) ->
      let _a1 = strip_loc_alident _a1 in
      let _a2 = strip_loc_list strip_loc_ctyp _a2 in
      let _a3 = strip_loc_ctyp _a3 in
      let _a4 =
        strip_loc_list
          (fun (_a0,_a1)  ->
             let _a0 = strip_loc_ctyp _a0 in
             let _a1 = strip_loc_ctyp _a1 in (_a0, _a1)) _a4 in
      `TyDcl (_a1, _a2, _a3, _a4)
  | `TyObj (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_row_var_flag _a2 in `TyObj (_a1, _a2)
  | `TyOlb (_a0,_a1,_a2) ->
      let _a1 = strip_loc_alident _a1 in
      let _a2 = strip_loc_ctyp _a2 in `TyOlb (_a1, _a2)
  | `TyPol (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_ctyp _a2 in `TyPol (_a1, _a2)
  | `TyTypePol (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_ctyp _a2 in `TyTypePol (_a1, _a2)
  | `Quote (_a0,_a1,_a2) ->
      let _a1 = strip_loc_position_flag _a1 in
      let _a2 = strip_loc_meta_option strip_loc_alident _a2 in
      `Quote (_a1, _a2)
  | `TyRec (_a0,_a1) -> let _a1 = strip_loc_ctyp _a1 in `TyRec _a1
  | `TyCol (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_ctyp _a2 in `TyCol (_a1, _a2)
  | `Sem (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_ctyp _a2 in `Sem (_a1, _a2)
  | `Com (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_ctyp _a2 in `Com (_a1, _a2)
  | `Sum (_a0,_a1) -> let _a1 = strip_loc_ctyp _a1 in `Sum _a1
  | `Of (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_ctyp _a2 in `Of (_a1, _a2)
  | `And (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_ctyp _a2 in `And (_a1, _a2)
  | `Or (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_ctyp _a2 in `Or (_a1, _a2)
  | `Priv (_a0,_a1) -> let _a1 = strip_loc_ctyp _a1 in `Priv _a1
  | `Mut (_a0,_a1) -> let _a1 = strip_loc_ctyp _a1 in `Mut _a1
  | `Tup (_a0,_a1) -> let _a1 = strip_loc_ctyp _a1 in `Tup _a1
  | `Sta (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_ctyp _a2 in `Sta (_a1, _a2)
  | `TyVrn (_a0,_a1) -> let _a1 = strip_loc_astring _a1 in `TyVrn _a1
  | `TyVrnEq (_a0,_a1) -> let _a1 = strip_loc_ctyp _a1 in `TyVrnEq _a1
  | `TyVrnSup (_a0,_a1) -> let _a1 = strip_loc_ctyp _a1 in `TyVrnSup _a1
  | `TyVrnInf (_a0,_a1) -> let _a1 = strip_loc_ctyp _a1 in `TyVrnInf _a1
  | `TyVrnInfSup (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_ctyp _a2 in `TyVrnInfSup (_a1, _a2)
  | `Amp (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_ctyp _a2 in `Amp (_a1, _a2)
  | `TyOfAmp (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_ctyp _a2 in `TyOfAmp (_a1, _a2)
  | `Package (_a0,_a1) -> let _a1 = strip_loc_module_type _a1 in `Package _a1
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
and strip_loc_patt: patt -> 'result =
  function
  | `Nil _a0 -> `Nil
  | `Id (_a0,_a1) -> let _a1 = strip_loc_ident _a1 in `Id _a1
  | `Alias (_a0,_a1,_a2) ->
      let _a1 = strip_loc_patt _a1 in
      let _a2 = strip_loc_alident _a2 in `Alias (_a1, _a2)
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
  | `Any _a0 -> `Any
  | `PaApp (_a0,_a1,_a2) ->
      let _a1 = strip_loc_patt _a1 in
      let _a2 = strip_loc_patt _a2 in `PaApp (_a1, _a2)
  | `Array (_a0,_a1) -> let _a1 = strip_loc_patt _a1 in `Array _a1
  | `Com (_a0,_a1,_a2) ->
      let _a1 = strip_loc_patt _a1 in
      let _a2 = strip_loc_patt _a2 in `Com (_a1, _a2)
  | `Sem (_a0,_a1,_a2) ->
      let _a1 = strip_loc_patt _a1 in
      let _a2 = strip_loc_patt _a2 in `Sem (_a1, _a2)
  | #literal as _a0 -> (strip_loc_literal _a0 :>'result)
  | `Label (_a0,_a1,_a2) ->
      let _a1 = strip_loc_alident _a1 in
      let _a2 = strip_loc_patt _a2 in `Label (_a1, _a2)
  | `PaOlbi (_a0,_a1,_a2,_a3) ->
      let _a1 = strip_loc_alident _a1 in
      let _a2 = strip_loc_patt _a2 in
      let _a3 = strip_loc_meta_option strip_loc_expr _a3 in
      `PaOlbi (_a1, _a2, _a3)
  | `Or (_a0,_a1,_a2) ->
      let _a1 = strip_loc_patt _a1 in
      let _a2 = strip_loc_patt _a2 in `Or (_a1, _a2)
  | `PaRng (_a0,_a1,_a2) ->
      let _a1 = strip_loc_patt _a1 in
      let _a2 = strip_loc_patt _a2 in `PaRng (_a1, _a2)
  | `PaRec (_a0,_a1) -> let _a1 = strip_loc_patt _a1 in `PaRec _a1
  | `PaEq (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ident _a1 in
      let _a2 = strip_loc_patt _a2 in `PaEq (_a1, _a2)
  | `Tup (_a0,_a1) -> let _a1 = strip_loc_patt _a1 in `Tup _a1
  | `Constraint (_a0,_a1,_a2) ->
      let _a1 = strip_loc_patt _a1 in
      let _a2 = strip_loc_ctyp _a2 in `Constraint (_a1, _a2)
  | `ClassPath (_a0,_a1) -> let _a1 = strip_loc_ident _a1 in `ClassPath _a1
  | `PaVrn (_a0,_a1) -> `PaVrn _a1
  | `Lazy (_a0,_a1) -> let _a1 = strip_loc_patt _a1 in `Lazy _a1
  | `ModuleUnpack (_a0,_a1,_a2) ->
      let _a1 = strip_loc_auident _a1 in
      let _a2 = strip_loc_meta_option strip_loc_ctyp _a2 in
      `ModuleUnpack (_a1, _a2)
and strip_loc_expr: expr -> 'result =
  function
  | `Nil _a0 -> `Nil
  | `Id (_a0,_a1) -> let _a1 = strip_loc_ident _a1 in `Id _a1
  | `Dot (_a0,_a1,_a2) ->
      let _a1 = strip_loc_expr _a1 in
      let _a2 = strip_loc_expr _a2 in `Dot (_a1, _a2)
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
  | `ExApp (_a0,_a1,_a2) ->
      let _a1 = strip_loc_expr _a1 in
      let _a2 = strip_loc_expr _a2 in `ExApp (_a1, _a2)
  | `ArrayDot (_a0,_a1,_a2) ->
      let _a1 = strip_loc_expr _a1 in
      let _a2 = strip_loc_expr _a2 in `ArrayDot (_a1, _a2)
  | `Array (_a0,_a1) -> let _a1 = strip_loc_expr _a1 in `Array _a1
  | `Sem (_a0,_a1,_a2) ->
      let _a1 = strip_loc_expr _a1 in
      let _a2 = strip_loc_expr _a2 in `Sem (_a1, _a2)
  | `ExAsf _a0 -> `ExAsf
  | `ExAsr (_a0,_a1) -> let _a1 = strip_loc_expr _a1 in `ExAsr _a1
  | `Assign (_a0,_a1,_a2) ->
      let _a1 = strip_loc_expr _a1 in
      let _a2 = strip_loc_expr _a2 in `Assign (_a1, _a2)
  | `For (_a0,_a1,_a2,_a3,_a4,_a5) ->
      let _a1 = strip_loc_alident _a1 in
      let _a2 = strip_loc_expr _a2 in
      let _a3 = strip_loc_expr _a3 in
      let _a4 = strip_loc_direction_flag _a4 in
      let _a5 = strip_loc_expr _a5 in `For (_a1, _a2, _a3, _a4, _a5)
  | `Fun (_a0,_a1) -> let _a1 = strip_loc_match_case _a1 in `Fun _a1
  | `IfThenElse (_a0,_a1,_a2,_a3) ->
      let _a1 = strip_loc_expr _a1 in
      let _a2 = strip_loc_expr _a2 in
      let _a3 = strip_loc_expr _a3 in `IfThenElse (_a1, _a2, _a3)
  | `IfThen (_a0,_a1,_a2) ->
      let _a1 = strip_loc_expr _a1 in
      let _a2 = strip_loc_expr _a2 in `IfThen (_a1, _a2)
  | #literal as _a0 -> (strip_loc_literal _a0 :>'result)
  | `Label (_a0,_a1,_a2) ->
      let _a1 = strip_loc_alident _a1 in
      let _a2 = strip_loc_expr _a2 in `Label (_a1, _a2)
  | `Lazy (_a0,_a1) -> let _a1 = strip_loc_expr _a1 in `Lazy _a1
  | `LetIn (_a0,_a1,_a2,_a3) ->
      let _a1 = strip_loc_rec_flag _a1 in
      let _a2 = strip_loc_binding _a2 in
      let _a3 = strip_loc_expr _a3 in `LetIn (_a1, _a2, _a3)
  | `LetModule (_a0,_a1,_a2,_a3) ->
      let _a1 = strip_loc_auident _a1 in
      let _a2 = strip_loc_module_expr _a2 in
      let _a3 = strip_loc_expr _a3 in `LetModule (_a1, _a2, _a3)
  | `Match (_a0,_a1,_a2) ->
      let _a1 = strip_loc_expr _a1 in
      let _a2 = strip_loc_match_case _a2 in `Match (_a1, _a2)
  | `New (_a0,_a1) -> let _a1 = strip_loc_ident _a1 in `New _a1
  | `Obj (_a0,_a1,_a2) ->
      let _a1 = strip_loc_patt _a1 in
      let _a2 = strip_loc_class_str_item _a2 in `Obj (_a1, _a2)
  | `OptLabl (_a0,_a1,_a2) ->
      let _a1 = strip_loc_alident _a1 in
      let _a2 = strip_loc_expr _a2 in `OptLabl (_a1, _a2)
  | `OvrInst (_a0,_a1) -> let _a1 = strip_loc_rec_binding _a1 in `OvrInst _a1
  | `Record (_a0,_a1,_a2) ->
      let _a1 = strip_loc_rec_binding _a1 in
      let _a2 = strip_loc_expr _a2 in `Record (_a1, _a2)
  | `Seq (_a0,_a1) -> let _a1 = strip_loc_expr _a1 in `Seq _a1
  | `Send (_a0,_a1,_a2) ->
      let _a1 = strip_loc_expr _a1 in
      let _a2 = strip_loc_alident _a2 in `Send (_a1, _a2)
  | `StringDot (_a0,_a1,_a2) ->
      let _a1 = strip_loc_expr _a1 in
      let _a2 = strip_loc_expr _a2 in `StringDot (_a1, _a2)
  | `Try (_a0,_a1,_a2) ->
      let _a1 = strip_loc_expr _a1 in
      let _a2 = strip_loc_match_case _a2 in `Try (_a1, _a2)
  | `Tup (_a0,_a1) -> let _a1 = strip_loc_expr _a1 in `Tup _a1
  | `Com (_a0,_a1,_a2) ->
      let _a1 = strip_loc_expr _a1 in
      let _a2 = strip_loc_expr _a2 in `Com (_a1, _a2)
  | `Constraint (_a0,_a1,_a2) ->
      let _a1 = strip_loc_expr _a1 in
      let _a2 = strip_loc_ctyp _a2 in `Constraint (_a1, _a2)
  | `Coercion (_a0,_a1,_a2,_a3) ->
      let _a1 = strip_loc_expr _a1 in
      let _a2 = strip_loc_ctyp _a2 in
      let _a3 = strip_loc_ctyp _a3 in `Coercion (_a1, _a2, _a3)
  | `ExVrn (_a0,_a1) -> `ExVrn _a1
  | `While (_a0,_a1,_a2) ->
      let _a1 = strip_loc_expr _a1 in
      let _a2 = strip_loc_expr _a2 in `While (_a1, _a2)
  | `LetOpen (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ident _a1 in
      let _a2 = strip_loc_expr _a2 in `LetOpen (_a1, _a2)
  | `LocalTypeFun (_a0,_a1,_a2) ->
      let _a1 = strip_loc_alident _a1 in
      let _a2 = strip_loc_expr _a2 in `LocalTypeFun (_a1, _a2)
  | `Package_expr (_a0,_a1) ->
      let _a1 = strip_loc_module_expr _a1 in `Package_expr _a1
and strip_loc_module_type: module_type -> 'result =
  function
  | `Nil _a0 -> `Nil
  | `Id (_a0,_a1) -> let _a1 = strip_loc_ident _a1 in `Id _a1
  | `MtFun (_a0,_a1,_a2,_a3) ->
      let _a1 = strip_loc_auident _a1 in
      let _a2 = strip_loc_module_type _a2 in
      let _a3 = strip_loc_module_type _a3 in `MtFun (_a1, _a2, _a3)
  | `Sig (_a0,_a1) -> let _a1 = strip_loc_sig_item _a1 in `Sig _a1
  | `With (_a0,_a1,_a2) ->
      let _a1 = strip_loc_module_type _a1 in
      let _a2 = strip_loc_with_constr _a2 in `With (_a1, _a2)
  | `ModuleTypeOf (_a0,_a1) ->
      let _a1 = strip_loc_module_expr _a1 in `ModuleTypeOf _a1
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
and strip_loc_sig_item: sig_item -> 'result =
  function
  | `Nil _a0 -> `Nil
  | `Class (_a0,_a1) -> let _a1 = strip_loc_class_type _a1 in `Class _a1
  | `ClassType (_a0,_a1) ->
      let _a1 = strip_loc_class_type _a1 in `ClassType _a1
  | `Sem (_a0,_a1,_a2) ->
      let _a1 = strip_loc_sig_item _a1 in
      let _a2 = strip_loc_sig_item _a2 in `Sem (_a1, _a2)
  | `Directive (_a0,_a1,_a2) ->
      let _a1 = strip_loc_alident _a1 in
      let _a2 = strip_loc_expr _a2 in `Directive (_a1, _a2)
  | `Exception (_a0,_a1) -> let _a1 = strip_loc_ctyp _a1 in `Exception _a1
  | `External (_a0,_a1,_a2,_a3) ->
      let _a1 = strip_loc_alident _a1 in
      let _a2 = strip_loc_ctyp _a2 in `External (_a1, _a2, _a3)
  | `Include (_a0,_a1) -> let _a1 = strip_loc_module_type _a1 in `Include _a1
  | `Module (_a0,_a1,_a2) ->
      let _a1 = strip_loc_auident _a1 in
      let _a2 = strip_loc_module_type _a2 in `Module (_a1, _a2)
  | `RecModule (_a0,_a1) ->
      let _a1 = strip_loc_module_binding _a1 in `RecModule _a1
  | `ModuleType (_a0,_a1,_a2) ->
      let _a1 = strip_loc_auident _a1 in
      let _a2 = strip_loc_module_type _a2 in `ModuleType (_a1, _a2)
  | `Open (_a0,_a1) -> let _a1 = strip_loc_ident _a1 in `Open _a1
  | `Type (_a0,_a1) -> let _a1 = strip_loc_ctyp _a1 in `Type _a1
  | `Val (_a0,_a1,_a2) ->
      let _a1 = strip_loc_alident _a1 in
      let _a2 = strip_loc_ctyp _a2 in `Val (_a1, _a2)
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
and strip_loc_with_constr: with_constr -> 'result =
  function
  | `Nil _a0 -> `Nil
  | `TypeEq (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_ctyp _a2 in `TypeEq (_a1, _a2)
  | `ModuleEq (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ident _a1 in
      let _a2 = strip_loc_ident _a2 in `ModuleEq (_a1, _a2)
  | `TypeSubst (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_ctyp _a2 in `TypeSubst (_a1, _a2)
  | `ModuleSubst (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ident _a1 in
      let _a2 = strip_loc_ident _a2 in `ModuleSubst (_a1, _a2)
  | `And (_a0,_a1,_a2) ->
      let _a1 = strip_loc_with_constr _a1 in
      let _a2 = strip_loc_with_constr _a2 in `And (_a1, _a2)
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
and strip_loc_binding: binding -> 'result =
  function
  | `Nil _a0 -> `Nil
  | `And (_a0,_a1,_a2) ->
      let _a1 = strip_loc_binding _a1 in
      let _a2 = strip_loc_binding _a2 in `And (_a1, _a2)
  | `Bind (_a0,_a1,_a2) ->
      let _a1 = strip_loc_patt _a1 in
      let _a2 = strip_loc_expr _a2 in `Bind (_a1, _a2)
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
and strip_loc_rec_binding: rec_binding -> 'result =
  function
  | `Nil _a0 -> `Nil
  | `Sem (_a0,_a1,_a2) ->
      let _a1 = strip_loc_rec_binding _a1 in
      let _a2 = strip_loc_rec_binding _a2 in `Sem (_a1, _a2)
  | `RecBind (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ident _a1 in
      let _a2 = strip_loc_expr _a2 in `RecBind (_a1, _a2)
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
and strip_loc_module_binding: module_binding -> 'result =
  function
  | `Nil _a0 -> `Nil
  | `And (_a0,_a1,_a2) ->
      let _a1 = strip_loc_module_binding _a1 in
      let _a2 = strip_loc_module_binding _a2 in `And (_a1, _a2)
  | `ModuleBind (_a0,_a1,_a2,_a3) ->
      let _a1 = strip_loc_auident _a1 in
      let _a2 = strip_loc_module_type _a2 in
      let _a3 = strip_loc_module_expr _a3 in `ModuleBind (_a1, _a2, _a3)
  | `Constraint (_a0,_a1,_a2) ->
      let _a1 = strip_loc_auident _a1 in
      let _a2 = strip_loc_module_type _a2 in `Constraint (_a1, _a2)
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
and strip_loc_match_case: match_case -> 'result =
  function
  | `Nil _a0 -> `Nil
  | `Or (_a0,_a1,_a2) ->
      let _a1 = strip_loc_match_case _a1 in
      let _a2 = strip_loc_match_case _a2 in `Or (_a1, _a2)
  | `Case (_a0,_a1,_a2,_a3) ->
      let _a1 = strip_loc_patt _a1 in
      let _a2 = strip_loc_expr _a2 in
      let _a3 = strip_loc_expr _a3 in `Case (_a1, _a2, _a3)
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
and strip_loc_module_expr: module_expr -> 'result =
  function
  | `Nil _a0 -> `Nil
  | `Id (_a0,_a1) -> let _a1 = strip_loc_ident _a1 in `Id _a1
  | `MeApp (_a0,_a1,_a2) ->
      let _a1 = strip_loc_module_expr _a1 in
      let _a2 = strip_loc_module_expr _a2 in `MeApp (_a1, _a2)
  | `Functor (_a0,_a1,_a2,_a3) ->
      let _a1 = strip_loc_auident _a1 in
      let _a2 = strip_loc_module_type _a2 in
      let _a3 = strip_loc_module_expr _a3 in `Functor (_a1, _a2, _a3)
  | `Struct (_a0,_a1) -> let _a1 = strip_loc_str_item _a1 in `Struct _a1
  | `Constraint (_a0,_a1,_a2) ->
      let _a1 = strip_loc_module_expr _a1 in
      let _a2 = strip_loc_module_type _a2 in `Constraint (_a1, _a2)
  | `PackageModule (_a0,_a1) ->
      let _a1 = strip_loc_expr _a1 in `PackageModule _a1
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
and strip_loc_str_item: str_item -> 'result =
  function
  | `Nil _a0 -> `Nil
  | `Class (_a0,_a1) -> let _a1 = strip_loc_class_expr _a1 in `Class _a1
  | `ClassType (_a0,_a1) ->
      let _a1 = strip_loc_class_type _a1 in `ClassType _a1
  | `Sem (_a0,_a1,_a2) ->
      let _a1 = strip_loc_str_item _a1 in
      let _a2 = strip_loc_str_item _a2 in `Sem (_a1, _a2)
  | `Directive (_a0,_a1,_a2) ->
      let _a1 = strip_loc_alident _a1 in
      let _a2 = strip_loc_expr _a2 in `Directive (_a1, _a2)
  | `Exception (_a0,_a1) -> let _a1 = strip_loc_ctyp _a1 in `Exception _a1
  | `StExp (_a0,_a1) -> let _a1 = strip_loc_expr _a1 in `StExp _a1
  | `External (_a0,_a1,_a2,_a3) ->
      let _a1 = strip_loc_alident _a1 in
      let _a2 = strip_loc_ctyp _a2 in `External (_a1, _a2, _a3)
  | `Include (_a0,_a1) -> let _a1 = strip_loc_module_expr _a1 in `Include _a1
  | `Module (_a0,_a1,_a2) ->
      let _a1 = strip_loc_auident _a1 in
      let _a2 = strip_loc_module_expr _a2 in `Module (_a1, _a2)
  | `RecModule (_a0,_a1) ->
      let _a1 = strip_loc_module_binding _a1 in `RecModule _a1
  | `ModuleType (_a0,_a1,_a2) ->
      let _a1 = strip_loc_auident _a1 in
      let _a2 = strip_loc_module_type _a2 in `ModuleType (_a1, _a2)
  | `Open (_a0,_a1) -> let _a1 = strip_loc_ident _a1 in `Open _a1
  | `Type (_a0,_a1) -> let _a1 = strip_loc_ctyp _a1 in `Type _a1
  | `Value (_a0,_a1,_a2) ->
      let _a1 = strip_loc_rec_flag _a1 in
      let _a2 = strip_loc_binding _a2 in `Value (_a1, _a2)
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
and strip_loc_class_type: class_type -> 'result =
  function
  | `Nil _a0 -> `Nil
  | `CtCon (_a0,_a1,_a2,_a3) ->
      let _a1 = strip_loc_virtual_flag _a1 in
      let _a2 = strip_loc_ident _a2 in
      let _a3 = strip_loc_ctyp _a3 in `CtCon (_a1, _a2, _a3)
  | `CtFun (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_class_type _a2 in `CtFun (_a1, _a2)
  | `CtSig (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_class_sig_item _a2 in `CtSig (_a1, _a2)
  | `And (_a0,_a1,_a2) ->
      let _a1 = strip_loc_class_type _a1 in
      let _a2 = strip_loc_class_type _a2 in `And (_a1, _a2)
  | `CtCol (_a0,_a1,_a2) ->
      let _a1 = strip_loc_class_type _a1 in
      let _a2 = strip_loc_class_type _a2 in `CtCol (_a1, _a2)
  | `CtEq (_a0,_a1,_a2) ->
      let _a1 = strip_loc_class_type _a1 in
      let _a2 = strip_loc_class_type _a2 in `CtEq (_a1, _a2)
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
and strip_loc_class_sig_item: class_sig_item -> 'result =
  function
  | `Nil _a0 -> `Nil
  | `Eq (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_ctyp _a2 in `Eq (_a1, _a2)
  | `Sem (_a0,_a1,_a2) ->
      let _a1 = strip_loc_class_sig_item _a1 in
      let _a2 = strip_loc_class_sig_item _a2 in `Sem (_a1, _a2)
  | `SigInherit (_a0,_a1) ->
      let _a1 = strip_loc_class_type _a1 in `SigInherit _a1
  | `Method (_a0,_a1,_a2,_a3) ->
      let _a1 = strip_loc_alident _a1 in
      let _a2 = strip_loc_private_flag _a2 in
      let _a3 = strip_loc_ctyp _a3 in `Method (_a1, _a2, _a3)
  | `CgVal (_a0,_a1,_a2,_a3,_a4) ->
      let _a1 = strip_loc_alident _a1 in
      let _a2 = strip_loc_mutable_flag _a2 in
      let _a3 = strip_loc_virtual_flag _a3 in
      let _a4 = strip_loc_ctyp _a4 in `CgVal (_a1, _a2, _a3, _a4)
  | `CgVir (_a0,_a1,_a2,_a3) ->
      let _a1 = strip_loc_alident _a1 in
      let _a2 = strip_loc_private_flag _a2 in
      let _a3 = strip_loc_ctyp _a3 in `CgVir (_a1, _a2, _a3)
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
and strip_loc_class_expr: class_expr -> 'result =
  function
  | `Nil _a0 -> `Nil
  | `CeApp (_a0,_a1,_a2) ->
      let _a1 = strip_loc_class_expr _a1 in
      let _a2 = strip_loc_expr _a2 in `CeApp (_a1, _a2)
  | `CeCon (_a0,_a1,_a2,_a3) ->
      let _a1 = strip_loc_virtual_flag _a1 in
      let _a2 = strip_loc_ident _a2 in
      let _a3 = strip_loc_ctyp _a3 in `CeCon (_a1, _a2, _a3)
  | `CeFun (_a0,_a1,_a2) ->
      let _a1 = strip_loc_patt _a1 in
      let _a2 = strip_loc_class_expr _a2 in `CeFun (_a1, _a2)
  | `CeLet (_a0,_a1,_a2,_a3) ->
      let _a1 = strip_loc_rec_flag _a1 in
      let _a2 = strip_loc_binding _a2 in
      let _a3 = strip_loc_class_expr _a3 in `CeLet (_a1, _a2, _a3)
  | `Obj (_a0,_a1,_a2) ->
      let _a1 = strip_loc_patt _a1 in
      let _a2 = strip_loc_class_str_item _a2 in `Obj (_a1, _a2)
  | `CeTyc (_a0,_a1,_a2) ->
      let _a1 = strip_loc_class_expr _a1 in
      let _a2 = strip_loc_class_type _a2 in `CeTyc (_a1, _a2)
  | `And (_a0,_a1,_a2) ->
      let _a1 = strip_loc_class_expr _a1 in
      let _a2 = strip_loc_class_expr _a2 in `And (_a1, _a2)
  | `Eq (_a0,_a1,_a2) ->
      let _a1 = strip_loc_class_expr _a1 in
      let _a2 = strip_loc_class_expr _a2 in `Eq (_a1, _a2)
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
and strip_loc_class_str_item: class_str_item -> 'result =
  function
  | `Nil _a0 -> `Nil
  | `Sem (_a0,_a1,_a2) ->
      let _a1 = strip_loc_class_str_item _a1 in
      let _a2 = strip_loc_class_str_item _a2 in `Sem (_a1, _a2)
  | `Eq (_a0,_a1,_a2) ->
      let _a1 = strip_loc_ctyp _a1 in
      let _a2 = strip_loc_ctyp _a2 in `Eq (_a1, _a2)
  | `Inherit (_a0,_a1,_a2,_a3) ->
      let _a1 = strip_loc_override_flag _a1 in
      let _a2 = strip_loc_class_expr _a2 in
      let _a3 = strip_loc_meta_option strip_loc_alident _a3 in
      `Inherit (_a1, _a2, _a3)
  | `Initializer (_a0,_a1) ->
      let _a1 = strip_loc_expr _a1 in `Initializer _a1
  | `CrMth (_a0,_a1,_a2,_a3,_a4,_a5) ->
      let _a1 = strip_loc_alident _a1 in
      let _a2 = strip_loc_override_flag _a2 in
      let _a3 = strip_loc_private_flag _a3 in
      let _a4 = strip_loc_expr _a4 in
      let _a5 = strip_loc_ctyp _a5 in `CrMth (_a1, _a2, _a3, _a4, _a5)
  | `CrVal (_a0,_a1,_a2,_a3,_a4) ->
      let _a1 = strip_loc_alident _a1 in
      let _a2 = strip_loc_override_flag _a2 in
      let _a3 = strip_loc_mutable_flag _a3 in
      let _a4 = strip_loc_expr _a4 in `CrVal (_a1, _a2, _a3, _a4)
  | `CrVir (_a0,_a1,_a2,_a3) ->
      let _a1 = strip_loc_alident _a1 in
      let _a2 = strip_loc_private_flag _a2 in
      let _a3 = strip_loc_ctyp _a3 in `CrVir (_a1, _a2, _a3)
  | `CrVvr (_a0,_a1,_a2,_a3) ->
      let _a1 = strip_loc_alident _a1 in
      let _a2 = strip_loc_mutable_flag _a2 in
      let _a3 = strip_loc_ctyp _a3 in `CrVvr (_a1, _a2, _a3)
  | #ant as _a0 -> (strip_loc_ant _a0 :>'result)
let loc_of =
  function
  | `PaOlbi (_loc,_,_,_) -> _loc
  | `Any _loc -> _loc
  | `TyVrnInf (_loc,_) -> _loc
  | `PaVrn (_loc,_) -> _loc
  | `Tup (_loc,_) -> _loc
  | `PaApp (_loc,_,_) -> _loc
  | `Array (_loc,_) -> _loc
  | `MtFun (_loc,_,_,_) -> _loc
  | `Id (_loc,_) -> _loc
  | `ArrayDot (_loc,_,_) -> _loc
  | `Directive (_loc,_,_) -> _loc
  | `TypeSubst (_loc,_,_) -> _loc
  | `ModuleBind (_loc,_,_,_) -> _loc
  | `Sta (_loc,_,_) -> _loc
  | `Match (_loc,_,_) -> _loc
  | `Obj (_loc,_,_) -> _loc
  | `TyPol (_loc,_,_) -> _loc
  | `Val (_loc,_,_) -> _loc
  | `C (_loc,_) -> _loc
  | `Str (_loc,_) -> _loc
  | `Or (_loc,_,_) -> _loc
  | `New (_loc,_) -> _loc
  | `Value (_loc,_,_) -> _loc
  | `Try (_loc,_,_) -> _loc
  | `Downto _loc -> _loc
  | `Assign (_loc,_,_) -> _loc
  | `Normal _loc -> _loc
  | `True _loc -> _loc
  | `Sem (_loc,_,_) -> _loc
  | `Send (_loc,_,_) -> _loc
  | `Type (_loc,_) -> _loc
  | `Chr (_loc,_) -> _loc
  | `IfThenElse (_loc,_,_,_) -> _loc
  | `ClassType (_loc,_) -> _loc
  | `ModuleUnpack (_loc,_,_) -> _loc
  | `CeTyc (_loc,_,_) -> _loc
  | `CrVir (_loc,_,_,_) -> _loc
  | `Package (_loc,_) -> _loc
  | `LCons (_loc,_) -> _loc
  | `While (_loc,_,_) -> _loc
  | `CrMth (_loc,_,_,_,_,_) -> _loc
  | `Dot (_loc,_,_) -> _loc
  | `Struct (_loc,_) -> _loc
  | `CeCon (_loc,_,_,_) -> _loc
  | `TyMan (_loc,_,_) -> _loc
  | `ExVrn (_loc,_) -> _loc
  | `External (_loc,_,_,_) -> _loc
  | `CgVal (_loc,_,_,_,_) -> _loc
  | `Class (_loc,_) -> _loc
  | `TyApp (_loc,_,_) -> _loc
  | `LetIn (_loc,_,_,_) -> _loc
  | `Seq (_loc,_) -> _loc
  | `Quote (_loc,_,_) -> _loc
  | `TypeEq (_loc,_,_) -> _loc
  | `OptLabl (_loc,_,_) -> _loc
  | `Coercion (_loc,_,_,_) -> _loc
  | `CtFun (_loc,_,_) -> _loc
  | `Arrow (_loc,_,_) -> _loc
  | `Bind (_loc,_,_) -> _loc
  | `CtEq (_loc,_,_) -> _loc
  | `Functor (_loc,_,_,_) -> _loc
  | `With (_loc,_,_) -> _loc
  | `NativeInt (_loc,_) -> _loc
  | `Private _loc -> _loc
  | `Virtual _loc -> _loc
  | `RowVar _loc -> _loc
  | `IfThen (_loc,_,_) -> _loc
  | `Sig (_loc,_) -> _loc
  | `RecBind (_loc,_,_) -> _loc
  | `Mutable _loc -> _loc
  | `ReNil _loc -> _loc
  | `Lazy (_loc,_) -> _loc
  | `CeFun (_loc,_,_) -> _loc
  | `ClassPath (_loc,_) -> _loc
  | `False _loc -> _loc
  | `Nil _loc -> _loc
  | `Com (_loc,_,_) -> _loc
  | `Int64 (_loc,_) -> _loc
  | `TyVrnSup (_loc,_) -> _loc
  | `ModuleTypeOf (_loc,_) -> _loc
  | `To _loc -> _loc
  | `LNil _loc -> _loc
  | `TyCol (_loc,_,_) -> _loc
  | `CgVir (_loc,_,_,_) -> _loc
  | `Initializer (_loc,_) -> _loc
  | `Amp (_loc,_,_) -> _loc
  | `ModuleEq (_loc,_,_) -> _loc
  | `Lid (_loc,_) -> _loc
  | `Record (_loc,_,_) -> _loc
  | `Constraint (_loc,_,_) -> _loc
  | `ExApp (_loc,_,_) -> _loc
  | `Ant (_loc,_) -> _loc
  | `Some _loc -> _loc
  | `Package_expr (_loc,_) -> _loc
  | `TyVrnEq (_loc,_) -> _loc
  | `Label (_loc,_,_) -> _loc
  | `TyTypePol (_loc,_,_) -> _loc
  | `Priv (_loc,_) -> _loc
  | `RvNil _loc -> _loc
  | `Override _loc -> _loc
  | `Include (_loc,_) -> _loc
  | `Flo (_loc,_) -> _loc
  | `Alias (_loc,_,_) -> _loc
  | `StExp (_loc,_) -> _loc
  | `Uid (_loc,_) -> _loc
  | `TyObj (_loc,_,_) -> _loc
  | `TyOlb (_loc,_,_) -> _loc
  | `Of (_loc,_,_) -> _loc
  | `OvrInst (_loc,_) -> _loc
  | `OvNil _loc -> _loc
  | `ModuleSubst (_loc,_,_) -> _loc
  | `Mut (_loc,_) -> _loc
  | `Positive _loc -> _loc
  | `CrVal (_loc,_,_,_,_) -> _loc
  | `TyVrn (_loc,_) -> _loc
  | `Case (_loc,_,_,_) -> _loc
  | `ExAsr (_loc,_) -> _loc
  | `Exception (_loc,_) -> _loc
  | `CtCol (_loc,_,_) -> _loc
  | `And (_loc,_,_) -> _loc
  | `TyDcl (_loc,_,_,_,_) -> _loc
  | `TyRec (_loc,_) -> _loc
  | `Int32 (_loc,_) -> _loc
  | `PaRng (_loc,_,_) -> _loc
  | `RecModule (_loc,_) -> _loc
  | `LocalTypeFun (_loc,_,_) -> _loc
  | `PrNil _loc -> _loc
  | `MeApp (_loc,_,_) -> _loc
  | `Int (_loc,_) -> _loc
  | `Negative _loc -> _loc
  | `Fun (_loc,_) -> _loc
  | `CeApp (_loc,_,_) -> _loc
  | `Eq (_loc,_,_) -> _loc
  | `IdApp (_loc,_,_) -> _loc
  | `LetModule (_loc,_,_,_) -> _loc
  | `LetOpen (_loc,_,_) -> _loc
  | `TyOfAmp (_loc,_,_) -> _loc
  | `StringDot (_loc,_,_) -> _loc
  | `For (_loc,_,_,_,_,_) -> _loc
  | `CrVvr (_loc,_,_,_) -> _loc
  | `CtCon (_loc,_,_,_) -> _loc
  | `Recursive _loc -> _loc
  | `TyVrnInfSup (_loc,_,_) -> _loc
  | `CtSig (_loc,_,_) -> _loc
  | `SigInherit (_loc,_) -> _loc
  | `ModuleType (_loc,_,_) -> _loc
  | `Inherit (_loc,_,_,_) -> _loc
  | `MuNil _loc -> _loc
  | `None _loc -> _loc
  | `Method (_loc,_,_,_) -> _loc
  | `Module (_loc,_,_) -> _loc
  | `ExAsf _loc -> _loc
  | `PackageModule (_loc,_) -> _loc
  | `PaRec (_loc,_) -> _loc
  | `CeLet (_loc,_,_,_) -> _loc
  | `Open (_loc,_) -> _loc
  | `ViNil _loc -> _loc
  | `Sum (_loc,_) -> _loc
  | `PaEq (_loc,_,_) -> _loc
class fold2 =
  object (self : 'self_type)
    inherit  foldbase2
    method loc : loc -> loc -> 'self_type=
      fun _a0  _a1  -> self#fanloc_t _a0 _a1
    method ant : ant -> ant -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Ant (_a0,_a1),`Ant (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#fanutil_anti_cxt _a1 _b1
    method literal : literal -> literal -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Chr (_a0,_a1),`Chr (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#string _a1 _b1
        | (`Int (_a0,_a1),`Int (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#string _a1 _b1
        | (`Int32 (_a0,_a1),`Int32 (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#string _a1 _b1
        | (`Int64 (_a0,_a1),`Int64 (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#string _a1 _b1
        | (`Flo (_a0,_a1),`Flo (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#string _a1 _b1
        | (`NativeInt (_a0,_a1),`NativeInt (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#string _a1 _b1
        | (`Str (_a0,_a1),`Str (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#string _a1 _b1
        | (_,_) -> invalid_arg "fold2 failure"
    method rec_flag : rec_flag -> rec_flag -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Recursive _a0,`Recursive _b0) -> self#loc _a0 _b0
        | (`ReNil _a0,`ReNil _b0) -> self#loc _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method direction_flag : direction_flag -> direction_flag -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`To _a0,`To _b0) -> self#loc _a0 _b0
        | (`Downto _a0,`Downto _b0) -> self#loc _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method mutable_flag : mutable_flag -> mutable_flag -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Mutable _a0,`Mutable _b0) -> self#loc _a0 _b0
        | (`MuNil _a0,`MuNil _b0) -> self#loc _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method private_flag : private_flag -> private_flag -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Private _a0,`Private _b0) -> self#loc _a0 _b0
        | (`PrNil _a0,`PrNil _b0) -> self#loc _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method virtual_flag : virtual_flag -> virtual_flag -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Virtual _a0,`Virtual _b0) -> self#loc _a0 _b0
        | (`ViNil _a0,`ViNil _b0) -> self#loc _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method override_flag : override_flag -> override_flag -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Override _a0,`Override _b0) -> self#loc _a0 _b0
        | (`OvNil _a0,`OvNil _b0) -> self#loc _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method row_var_flag : row_var_flag -> row_var_flag -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`RowVar _a0,`RowVar _b0) -> self#loc _a0 _b0
        | (`RvNil _a0,`RvNil _b0) -> self#loc _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method position_flag : position_flag -> position_flag -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Positive _a0,`Positive _b0) -> self#loc _a0 _b0
        | (`Negative _a0,`Negative _b0) -> self#loc _a0 _b0
        | (`Normal _a0,`Normal _b0) -> self#loc _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method meta_bool : meta_bool -> meta_bool -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`True _a0,`True _b0) -> self#loc _a0 _b0
        | (`False _a0,`False _b0) -> self#loc _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method meta_option :
      'all_a0 .
        ('self_type -> 'all_a0 -> 'all_a0 -> 'self_type) ->
          'all_a0 meta_option -> 'all_a0 meta_option -> 'self_type=
      fun mf_a  _a0  _b0  ->
        match (_a0, _b0) with
        | (`None _a0,`None _b0) -> self#loc _a0 _b0
        | (`Some _a0,`Some _b0) -> mf_a self _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method meta_list :
      'all_a0 .
        ('self_type -> 'all_a0 -> 'all_a0 -> 'self_type) ->
          'all_a0 meta_list -> 'all_a0 meta_list -> 'self_type=
      fun mf_a  _a0  _b0  ->
        match (_a0, _b0) with
        | (`LNil _a0,`LNil _b0) -> self#loc _a0 _b0
        | (`LCons (_a0,_a1),`LCons (_b0,_b1)) ->
            let self = mf_a self _a0 _b0 in self#meta_list mf_a _a1 _b1
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method alident : alident -> alident -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Lid (_a0,_a1),`Lid (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#string _a1 _b1
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method auident : auident -> auident -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Uid (_a0,_a1),`Uid (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#string _a1 _b1
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method aident : aident -> aident -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#alident as _a0),(#alident as _b0)) ->
            (self#alident _a0 _b0 :>'self_type)
        | ((#auident as _a0),(#auident as _b0)) ->
            (self#auident _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method astring : astring -> astring -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`C (_a0,_a1),`C (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#string _a1 _b1
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method ident : ident -> ident -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Dot (_a0,_a1,_a2),`Dot (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ident _a1 _b1 in self#ident _a2 _b2
        | (`IdApp (_a0,_a1,_a2),`IdApp (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ident _a1 _b1 in self#ident _a2 _b2
        | ((#alident as _a0),(#alident as _b0)) ->
            (self#alident _a0 _b0 :>'self_type)
        | ((#auident as _a0),(#auident as _b0)) ->
            (self#auident _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method ctyp : ctyp -> ctyp -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`Alias (_a0,_a1,_a2),`Alias (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#ctyp _a2 _b2
        | (`Any _a0,`Any _b0) -> self#loc _a0 _b0
        | (`TyApp (_a0,_a1,_a2),`TyApp (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#ctyp _a2 _b2
        | (`Arrow (_a0,_a1,_a2),`Arrow (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#ctyp _a2 _b2
        | (`ClassPath (_a0,_a1),`ClassPath (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#ident _a1 _b1
        | (`Label (_a0,_a1,_a2),`Label (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#alident _a1 _b1 in self#ctyp _a2 _b2
        | (`Id (_a0,_a1),`Id (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#ident _a1 _b1
        | (`TyMan (_a0,_a1,_a2),`TyMan (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#ctyp _a2 _b2
        | (`TyDcl (_a0,_a1,_a2,_a3,_a4),`TyDcl (_b0,_b1,_b2,_b3,_b4)) ->
            let self = self#loc _a0 _b0 in
            let self = self#alident _a1 _b1 in
            let self = self#list (fun self  -> self#ctyp) _a2 _b2 in
            let self = self#ctyp _a3 _b3 in
            self#list
              (fun self  _a0  _b0  ->
                 match (_a0, _b0) with
                 | ((_a0,_a1),(_b0,_b1)) ->
                     let self = self#ctyp _a0 _b0 in self#ctyp _a1 _b1) _a4
              _b4
        | (`TyObj (_a0,_a1,_a2),`TyObj (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#row_var_flag _a2 _b2
        | (`TyOlb (_a0,_a1,_a2),`TyOlb (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#alident _a1 _b1 in self#ctyp _a2 _b2
        | (`TyPol (_a0,_a1,_a2),`TyPol (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#ctyp _a2 _b2
        | (`TyTypePol (_a0,_a1,_a2),`TyTypePol (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#ctyp _a2 _b2
        | (`Quote (_a0,_a1,_a2),`Quote (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#position_flag _a1 _b1 in
            self#meta_option (fun self  -> self#alident) _a2 _b2
        | (`TyRec (_a0,_a1),`TyRec (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#ctyp _a1 _b1
        | (`TyCol (_a0,_a1,_a2),`TyCol (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#ctyp _a2 _b2
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#ctyp _a2 _b2
        | (`Com (_a0,_a1,_a2),`Com (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#ctyp _a2 _b2
        | (`Sum (_a0,_a1),`Sum (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#ctyp _a1 _b1
        | (`Of (_a0,_a1,_a2),`Of (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#ctyp _a2 _b2
        | (`And (_a0,_a1,_a2),`And (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#ctyp _a2 _b2
        | (`Or (_a0,_a1,_a2),`Or (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#ctyp _a2 _b2
        | (`Priv (_a0,_a1),`Priv (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#ctyp _a1 _b1
        | (`Mut (_a0,_a1),`Mut (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#ctyp _a1 _b1
        | (`Tup (_a0,_a1),`Tup (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#ctyp _a1 _b1
        | (`Sta (_a0,_a1,_a2),`Sta (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#ctyp _a2 _b2
        | (`TyVrn (_a0,_a1),`TyVrn (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#astring _a1 _b1
        | (`TyVrnEq (_a0,_a1),`TyVrnEq (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#ctyp _a1 _b1
        | (`TyVrnSup (_a0,_a1),`TyVrnSup (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#ctyp _a1 _b1
        | (`TyVrnInf (_a0,_a1),`TyVrnInf (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#ctyp _a1 _b1
        | (`TyVrnInfSup (_a0,_a1,_a2),`TyVrnInfSup (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#ctyp _a2 _b2
        | (`Amp (_a0,_a1,_a2),`Amp (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#ctyp _a2 _b2
        | (`TyOfAmp (_a0,_a1,_a2),`TyOfAmp (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#ctyp _a2 _b2
        | (`Package (_a0,_a1),`Package (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#module_type _a1 _b1
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method patt : patt -> patt -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`Id (_a0,_a1),`Id (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#ident _a1 _b1
        | (`Alias (_a0,_a1,_a2),`Alias (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#patt _a1 _b1 in self#alident _a2 _b2
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (`Any _a0,`Any _b0) -> self#loc _a0 _b0
        | (`PaApp (_a0,_a1,_a2),`PaApp (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#patt _a1 _b1 in self#patt _a2 _b2
        | (`Array (_a0,_a1),`Array (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#patt _a1 _b1
        | (`Com (_a0,_a1,_a2),`Com (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#patt _a1 _b1 in self#patt _a2 _b2
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#patt _a1 _b1 in self#patt _a2 _b2
        | ((#literal as _a0),(#literal as _b0)) ->
            (self#literal _a0 _b0 :>'self_type)
        | (`Label (_a0,_a1,_a2),`Label (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#alident _a1 _b1 in self#patt _a2 _b2
        | (`PaOlbi (_a0,_a1,_a2,_a3),`PaOlbi (_b0,_b1,_b2,_b3)) ->
            let self = self#loc _a0 _b0 in
            let self = self#alident _a1 _b1 in
            let self = self#patt _a2 _b2 in
            self#meta_option (fun self  -> self#expr) _a3 _b3
        | (`Or (_a0,_a1,_a2),`Or (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#patt _a1 _b1 in self#patt _a2 _b2
        | (`PaRng (_a0,_a1,_a2),`PaRng (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#patt _a1 _b1 in self#patt _a2 _b2
        | (`PaRec (_a0,_a1),`PaRec (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#patt _a1 _b1
        | (`PaEq (_a0,_a1,_a2),`PaEq (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ident _a1 _b1 in self#patt _a2 _b2
        | (`Tup (_a0,_a1),`Tup (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#patt _a1 _b1
        | (`Constraint (_a0,_a1,_a2),`Constraint (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#patt _a1 _b1 in self#ctyp _a2 _b2
        | (`ClassPath (_a0,_a1),`ClassPath (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#ident _a1 _b1
        | (`PaVrn (_a0,_a1),`PaVrn (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#string _a1 _b1
        | (`Lazy (_a0,_a1),`Lazy (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#patt _a1 _b1
        | (`ModuleUnpack (_a0,_a1,_a2),`ModuleUnpack (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#auident _a1 _b1 in
            self#meta_option (fun self  -> self#ctyp) _a2 _b2
        | (_,_) -> invalid_arg "fold2 failure"
    method expr : expr -> expr -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`Id (_a0,_a1),`Id (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#ident _a1 _b1
        | (`Dot (_a0,_a1,_a2),`Dot (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#expr _a1 _b1 in self#expr _a2 _b2
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (`ExApp (_a0,_a1,_a2),`ExApp (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#expr _a1 _b1 in self#expr _a2 _b2
        | (`ArrayDot (_a0,_a1,_a2),`ArrayDot (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#expr _a1 _b1 in self#expr _a2 _b2
        | (`Array (_a0,_a1),`Array (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#expr _a1 _b1
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#expr _a1 _b1 in self#expr _a2 _b2
        | (`ExAsf _a0,`ExAsf _b0) -> self#loc _a0 _b0
        | (`ExAsr (_a0,_a1),`ExAsr (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#expr _a1 _b1
        | (`Assign (_a0,_a1,_a2),`Assign (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#expr _a1 _b1 in self#expr _a2 _b2
        | (`For (_a0,_a1,_a2,_a3,_a4,_a5),`For (_b0,_b1,_b2,_b3,_b4,_b5)) ->
            let self = self#loc _a0 _b0 in
            let self = self#alident _a1 _b1 in
            let self = self#expr _a2 _b2 in
            let self = self#expr _a3 _b3 in
            let self = self#direction_flag _a4 _b4 in self#expr _a5 _b5
        | (`Fun (_a0,_a1),`Fun (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#match_case _a1 _b1
        | (`IfThenElse (_a0,_a1,_a2,_a3),`IfThenElse (_b0,_b1,_b2,_b3)) ->
            let self = self#loc _a0 _b0 in
            let self = self#expr _a1 _b1 in
            let self = self#expr _a2 _b2 in self#expr _a3 _b3
        | (`IfThen (_a0,_a1,_a2),`IfThen (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#expr _a1 _b1 in self#expr _a2 _b2
        | ((#literal as _a0),(#literal as _b0)) ->
            (self#literal _a0 _b0 :>'self_type)
        | (`Label (_a0,_a1,_a2),`Label (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#alident _a1 _b1 in self#expr _a2 _b2
        | (`Lazy (_a0,_a1),`Lazy (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#expr _a1 _b1
        | (`LetIn (_a0,_a1,_a2,_a3),`LetIn (_b0,_b1,_b2,_b3)) ->
            let self = self#loc _a0 _b0 in
            let self = self#rec_flag _a1 _b1 in
            let self = self#binding _a2 _b2 in self#expr _a3 _b3
        | (`LetModule (_a0,_a1,_a2,_a3),`LetModule (_b0,_b1,_b2,_b3)) ->
            let self = self#loc _a0 _b0 in
            let self = self#auident _a1 _b1 in
            let self = self#module_expr _a2 _b2 in self#expr _a3 _b3
        | (`Match (_a0,_a1,_a2),`Match (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#expr _a1 _b1 in self#match_case _a2 _b2
        | (`New (_a0,_a1),`New (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#ident _a1 _b1
        | (`Obj (_a0,_a1,_a2),`Obj (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#patt _a1 _b1 in self#class_str_item _a2 _b2
        | (`OptLabl (_a0,_a1,_a2),`OptLabl (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#alident _a1 _b1 in self#expr _a2 _b2
        | (`OvrInst (_a0,_a1),`OvrInst (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#rec_binding _a1 _b1
        | (`Record (_a0,_a1,_a2),`Record (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#rec_binding _a1 _b1 in self#expr _a2 _b2
        | (`Seq (_a0,_a1),`Seq (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#expr _a1 _b1
        | (`Send (_a0,_a1,_a2),`Send (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#expr _a1 _b1 in self#alident _a2 _b2
        | (`StringDot (_a0,_a1,_a2),`StringDot (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#expr _a1 _b1 in self#expr _a2 _b2
        | (`Try (_a0,_a1,_a2),`Try (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#expr _a1 _b1 in self#match_case _a2 _b2
        | (`Tup (_a0,_a1),`Tup (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#expr _a1 _b1
        | (`Com (_a0,_a1,_a2),`Com (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#expr _a1 _b1 in self#expr _a2 _b2
        | (`Constraint (_a0,_a1,_a2),`Constraint (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#expr _a1 _b1 in self#ctyp _a2 _b2
        | (`Coercion (_a0,_a1,_a2,_a3),`Coercion (_b0,_b1,_b2,_b3)) ->
            let self = self#loc _a0 _b0 in
            let self = self#expr _a1 _b1 in
            let self = self#ctyp _a2 _b2 in self#ctyp _a3 _b3
        | (`ExVrn (_a0,_a1),`ExVrn (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#string _a1 _b1
        | (`While (_a0,_a1,_a2),`While (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#expr _a1 _b1 in self#expr _a2 _b2
        | (`LetOpen (_a0,_a1,_a2),`LetOpen (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ident _a1 _b1 in self#expr _a2 _b2
        | (`LocalTypeFun (_a0,_a1,_a2),`LocalTypeFun (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#alident _a1 _b1 in self#expr _a2 _b2
        | (`Package_expr (_a0,_a1),`Package_expr (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#module_expr _a1 _b1
        | (_,_) -> invalid_arg "fold2 failure"
    method module_type : module_type -> module_type -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`Id (_a0,_a1),`Id (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#ident _a1 _b1
        | (`MtFun (_a0,_a1,_a2,_a3),`MtFun (_b0,_b1,_b2,_b3)) ->
            let self = self#loc _a0 _b0 in
            let self = self#auident _a1 _b1 in
            let self = self#module_type _a2 _b2 in self#module_type _a3 _b3
        | (`Sig (_a0,_a1),`Sig (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#sig_item _a1 _b1
        | (`With (_a0,_a1,_a2),`With (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#module_type _a1 _b1 in self#with_constr _a2 _b2
        | (`ModuleTypeOf (_a0,_a1),`ModuleTypeOf (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#module_expr _a1 _b1
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method sig_item : sig_item -> sig_item -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`Class (_a0,_a1),`Class (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#class_type _a1 _b1
        | (`ClassType (_a0,_a1),`ClassType (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#class_type _a1 _b1
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#sig_item _a1 _b1 in self#sig_item _a2 _b2
        | (`Directive (_a0,_a1,_a2),`Directive (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#alident _a1 _b1 in self#expr _a2 _b2
        | (`Exception (_a0,_a1),`Exception (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#ctyp _a1 _b1
        | (`External (_a0,_a1,_a2,_a3),`External (_b0,_b1,_b2,_b3)) ->
            let self = self#loc _a0 _b0 in
            let self = self#alident _a1 _b1 in
            let self = self#ctyp _a2 _b2 in
            self#meta_list (fun self  -> self#string) _a3 _b3
        | (`Include (_a0,_a1),`Include (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#module_type _a1 _b1
        | (`Module (_a0,_a1,_a2),`Module (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#auident _a1 _b1 in self#module_type _a2 _b2
        | (`RecModule (_a0,_a1),`RecModule (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#module_binding _a1 _b1
        | (`ModuleType (_a0,_a1,_a2),`ModuleType (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#auident _a1 _b1 in self#module_type _a2 _b2
        | (`Open (_a0,_a1),`Open (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#ident _a1 _b1
        | (`Type (_a0,_a1),`Type (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#ctyp _a1 _b1
        | (`Val (_a0,_a1,_a2),`Val (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#alident _a1 _b1 in self#ctyp _a2 _b2
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method with_constr : with_constr -> with_constr -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`TypeEq (_a0,_a1,_a2),`TypeEq (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#ctyp _a2 _b2
        | (`ModuleEq (_a0,_a1,_a2),`ModuleEq (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ident _a1 _b1 in self#ident _a2 _b2
        | (`TypeSubst (_a0,_a1,_a2),`TypeSubst (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#ctyp _a2 _b2
        | (`ModuleSubst (_a0,_a1,_a2),`ModuleSubst (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ident _a1 _b1 in self#ident _a2 _b2
        | (`And (_a0,_a1,_a2),`And (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#with_constr _a1 _b1 in self#with_constr _a2 _b2
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method binding : binding -> binding -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`And (_a0,_a1,_a2),`And (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#binding _a1 _b1 in self#binding _a2 _b2
        | (`Bind (_a0,_a1,_a2),`Bind (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#patt _a1 _b1 in self#expr _a2 _b2
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method rec_binding : rec_binding -> rec_binding -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#rec_binding _a1 _b1 in self#rec_binding _a2 _b2
        | (`RecBind (_a0,_a1,_a2),`RecBind (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ident _a1 _b1 in self#expr _a2 _b2
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method module_binding : module_binding -> module_binding -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`And (_a0,_a1,_a2),`And (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#module_binding _a1 _b1 in
            self#module_binding _a2 _b2
        | (`ModuleBind (_a0,_a1,_a2,_a3),`ModuleBind (_b0,_b1,_b2,_b3)) ->
            let self = self#loc _a0 _b0 in
            let self = self#auident _a1 _b1 in
            let self = self#module_type _a2 _b2 in self#module_expr _a3 _b3
        | (`Constraint (_a0,_a1,_a2),`Constraint (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#auident _a1 _b1 in self#module_type _a2 _b2
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method match_case : match_case -> match_case -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`Or (_a0,_a1,_a2),`Or (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#match_case _a1 _b1 in self#match_case _a2 _b2
        | (`Case (_a0,_a1,_a2,_a3),`Case (_b0,_b1,_b2,_b3)) ->
            let self = self#loc _a0 _b0 in
            let self = self#patt _a1 _b1 in
            let self = self#expr _a2 _b2 in self#expr _a3 _b3
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method module_expr : module_expr -> module_expr -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`Id (_a0,_a1),`Id (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#ident _a1 _b1
        | (`MeApp (_a0,_a1,_a2),`MeApp (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#module_expr _a1 _b1 in self#module_expr _a2 _b2
        | (`Functor (_a0,_a1,_a2,_a3),`Functor (_b0,_b1,_b2,_b3)) ->
            let self = self#loc _a0 _b0 in
            let self = self#auident _a1 _b1 in
            let self = self#module_type _a2 _b2 in self#module_expr _a3 _b3
        | (`Struct (_a0,_a1),`Struct (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#str_item _a1 _b1
        | (`Constraint (_a0,_a1,_a2),`Constraint (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#module_expr _a1 _b1 in self#module_type _a2 _b2
        | (`PackageModule (_a0,_a1),`PackageModule (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#expr _a1 _b1
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method str_item : str_item -> str_item -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`Class (_a0,_a1),`Class (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#class_expr _a1 _b1
        | (`ClassType (_a0,_a1),`ClassType (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#class_type _a1 _b1
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#str_item _a1 _b1 in self#str_item _a2 _b2
        | (`Directive (_a0,_a1,_a2),`Directive (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#alident _a1 _b1 in self#expr _a2 _b2
        | (`Exception (_a0,_a1),`Exception (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#ctyp _a1 _b1
        | (`StExp (_a0,_a1),`StExp (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#expr _a1 _b1
        | (`External (_a0,_a1,_a2,_a3),`External (_b0,_b1,_b2,_b3)) ->
            let self = self#loc _a0 _b0 in
            let self = self#alident _a1 _b1 in
            let self = self#ctyp _a2 _b2 in
            self#meta_list (fun self  -> self#string) _a3 _b3
        | (`Include (_a0,_a1),`Include (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#module_expr _a1 _b1
        | (`Module (_a0,_a1,_a2),`Module (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#auident _a1 _b1 in self#module_expr _a2 _b2
        | (`RecModule (_a0,_a1),`RecModule (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#module_binding _a1 _b1
        | (`ModuleType (_a0,_a1,_a2),`ModuleType (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#auident _a1 _b1 in self#module_type _a2 _b2
        | (`Open (_a0,_a1),`Open (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#ident _a1 _b1
        | (`Type (_a0,_a1),`Type (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#ctyp _a1 _b1
        | (`Value (_a0,_a1,_a2),`Value (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#rec_flag _a1 _b1 in self#binding _a2 _b2
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method class_type : class_type -> class_type -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`CtCon (_a0,_a1,_a2,_a3),`CtCon (_b0,_b1,_b2,_b3)) ->
            let self = self#loc _a0 _b0 in
            let self = self#virtual_flag _a1 _b1 in
            let self = self#ident _a2 _b2 in self#ctyp _a3 _b3
        | (`CtFun (_a0,_a1,_a2),`CtFun (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#class_type _a2 _b2
        | (`CtSig (_a0,_a1,_a2),`CtSig (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#class_sig_item _a2 _b2
        | (`And (_a0,_a1,_a2),`And (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#class_type _a1 _b1 in self#class_type _a2 _b2
        | (`CtCol (_a0,_a1,_a2),`CtCol (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#class_type _a1 _b1 in self#class_type _a2 _b2
        | (`CtEq (_a0,_a1,_a2),`CtEq (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#class_type _a1 _b1 in self#class_type _a2 _b2
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method class_sig_item : class_sig_item -> class_sig_item -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`Eq (_a0,_a1,_a2),`Eq (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#ctyp _a2 _b2
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#class_sig_item _a1 _b1 in
            self#class_sig_item _a2 _b2
        | (`SigInherit (_a0,_a1),`SigInherit (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#class_type _a1 _b1
        | (`Method (_a0,_a1,_a2,_a3),`Method (_b0,_b1,_b2,_b3)) ->
            let self = self#loc _a0 _b0 in
            let self = self#alident _a1 _b1 in
            let self = self#private_flag _a2 _b2 in self#ctyp _a3 _b3
        | (`CgVal (_a0,_a1,_a2,_a3,_a4),`CgVal (_b0,_b1,_b2,_b3,_b4)) ->
            let self = self#loc _a0 _b0 in
            let self = self#alident _a1 _b1 in
            let self = self#mutable_flag _a2 _b2 in
            let self = self#virtual_flag _a3 _b3 in self#ctyp _a4 _b4
        | (`CgVir (_a0,_a1,_a2,_a3),`CgVir (_b0,_b1,_b2,_b3)) ->
            let self = self#loc _a0 _b0 in
            let self = self#alident _a1 _b1 in
            let self = self#private_flag _a2 _b2 in self#ctyp _a3 _b3
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method class_expr : class_expr -> class_expr -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`CeApp (_a0,_a1,_a2),`CeApp (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#class_expr _a1 _b1 in self#expr _a2 _b2
        | (`CeCon (_a0,_a1,_a2,_a3),`CeCon (_b0,_b1,_b2,_b3)) ->
            let self = self#loc _a0 _b0 in
            let self = self#virtual_flag _a1 _b1 in
            let self = self#ident _a2 _b2 in self#ctyp _a3 _b3
        | (`CeFun (_a0,_a1,_a2),`CeFun (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#patt _a1 _b1 in self#class_expr _a2 _b2
        | (`CeLet (_a0,_a1,_a2,_a3),`CeLet (_b0,_b1,_b2,_b3)) ->
            let self = self#loc _a0 _b0 in
            let self = self#rec_flag _a1 _b1 in
            let self = self#binding _a2 _b2 in self#class_expr _a3 _b3
        | (`Obj (_a0,_a1,_a2),`Obj (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#patt _a1 _b1 in self#class_str_item _a2 _b2
        | (`CeTyc (_a0,_a1,_a2),`CeTyc (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#class_expr _a1 _b1 in self#class_type _a2 _b2
        | (`And (_a0,_a1,_a2),`And (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#class_expr _a1 _b1 in self#class_expr _a2 _b2
        | (`Eq (_a0,_a1,_a2),`Eq (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#class_expr _a1 _b1 in self#class_expr _a2 _b2
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method class_str_item : class_str_item -> class_str_item -> 'self_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> self#loc _a0 _b0
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#class_str_item _a1 _b1 in
            self#class_str_item _a2 _b2
        | (`Eq (_a0,_a1,_a2),`Eq (_b0,_b1,_b2)) ->
            let self = self#loc _a0 _b0 in
            let self = self#ctyp _a1 _b1 in self#ctyp _a2 _b2
        | (`Inherit (_a0,_a1,_a2,_a3),`Inherit (_b0,_b1,_b2,_b3)) ->
            let self = self#loc _a0 _b0 in
            let self = self#override_flag _a1 _b1 in
            let self = self#class_expr _a2 _b2 in
            self#meta_option (fun self  -> self#alident) _a3 _b3
        | (`Initializer (_a0,_a1),`Initializer (_b0,_b1)) ->
            let self = self#loc _a0 _b0 in self#expr _a1 _b1
        | (`CrMth (_a0,_a1,_a2,_a3,_a4,_a5),`CrMth (_b0,_b1,_b2,_b3,_b4,_b5))
            ->
            let self = self#loc _a0 _b0 in
            let self = self#alident _a1 _b1 in
            let self = self#override_flag _a2 _b2 in
            let self = self#private_flag _a3 _b3 in
            let self = self#expr _a4 _b4 in self#ctyp _a5 _b5
        | (`CrVal (_a0,_a1,_a2,_a3,_a4),`CrVal (_b0,_b1,_b2,_b3,_b4)) ->
            let self = self#loc _a0 _b0 in
            let self = self#alident _a1 _b1 in
            let self = self#override_flag _a2 _b2 in
            let self = self#mutable_flag _a3 _b3 in self#expr _a4 _b4
        | (`CrVir (_a0,_a1,_a2,_a3),`CrVir (_b0,_b1,_b2,_b3)) ->
            let self = self#loc _a0 _b0 in
            let self = self#alident _a1 _b1 in
            let self = self#private_flag _a2 _b2 in self#ctyp _a3 _b3
        | (`CrVvr (_a0,_a1,_a2,_a3),`CrVvr (_b0,_b1,_b2,_b3)) ->
            let self = self#loc _a0 _b0 in
            let self = self#alident _a1 _b1 in
            let self = self#mutable_flag _a2 _b2 in self#ctyp _a3 _b3
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'self_type)
        | (_,_) -> invalid_arg "fold2 failure"
    method fanloc_t : FanLoc.t -> FanLoc.t -> 'self_type= self#unknown
    method fanutil_anti_cxt :
      FanUtil.anti_cxt -> FanUtil.anti_cxt -> 'self_type= self#unknown
  end
let pp_print_loc: 'fmt -> loc -> 'result =
  fun fmt  _a0  -> FanLoc.pp_print_t fmt _a0
let pp_print_ant: 'fmt -> ant -> 'result =
  fun fmt  (`Ant (_a0,_a1))  ->
    Format.fprintf fmt "@[<1>(`Ant@ %a@ %a)@]" pp_print_loc _a0
      FanUtil.pp_print_anti_cxt _a1
let pp_print_literal: 'fmt -> literal -> 'result =
  fun fmt  ->
    function
    | `Chr (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Chr@ %a@ %a)@]" pp_print_loc _a0
          pp_print_string _a1
    | `Int (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Int@ %a@ %a)@]" pp_print_loc _a0
          pp_print_string _a1
    | `Int32 (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Int32@ %a@ %a)@]" pp_print_loc _a0
          pp_print_string _a1
    | `Int64 (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Int64@ %a@ %a)@]" pp_print_loc _a0
          pp_print_string _a1
    | `Flo (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Flo@ %a@ %a)@]" pp_print_loc _a0
          pp_print_string _a1
    | `NativeInt (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`NativeInt@ %a@ %a)@]" pp_print_loc _a0
          pp_print_string _a1
    | `Str (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Str@ %a@ %a)@]" pp_print_loc _a0
          pp_print_string _a1
let pp_print_rec_flag: 'fmt -> rec_flag -> 'result =
  fun fmt  ->
    function
    | `Recursive _a0 ->
        Format.fprintf fmt "@[<1>(`Recursive@ %a)@]" pp_print_loc _a0
    | `ReNil _a0 -> Format.fprintf fmt "@[<1>(`ReNil@ %a)@]" pp_print_loc _a0
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
let pp_print_direction_flag: 'fmt -> direction_flag -> 'result =
  fun fmt  ->
    function
    | `To _a0 -> Format.fprintf fmt "@[<1>(`To@ %a)@]" pp_print_loc _a0
    | `Downto _a0 ->
        Format.fprintf fmt "@[<1>(`Downto@ %a)@]" pp_print_loc _a0
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
let pp_print_mutable_flag: 'fmt -> mutable_flag -> 'result =
  fun fmt  ->
    function
    | `Mutable _a0 ->
        Format.fprintf fmt "@[<1>(`Mutable@ %a)@]" pp_print_loc _a0
    | `MuNil _a0 -> Format.fprintf fmt "@[<1>(`MuNil@ %a)@]" pp_print_loc _a0
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
let pp_print_private_flag: 'fmt -> private_flag -> 'result =
  fun fmt  ->
    function
    | `Private _a0 ->
        Format.fprintf fmt "@[<1>(`Private@ %a)@]" pp_print_loc _a0
    | `PrNil _a0 -> Format.fprintf fmt "@[<1>(`PrNil@ %a)@]" pp_print_loc _a0
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
let pp_print_virtual_flag: 'fmt -> virtual_flag -> 'result =
  fun fmt  ->
    function
    | `Virtual _a0 ->
        Format.fprintf fmt "@[<1>(`Virtual@ %a)@]" pp_print_loc _a0
    | `ViNil _a0 -> Format.fprintf fmt "@[<1>(`ViNil@ %a)@]" pp_print_loc _a0
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
let pp_print_override_flag: 'fmt -> override_flag -> 'result =
  fun fmt  ->
    function
    | `Override _a0 ->
        Format.fprintf fmt "@[<1>(`Override@ %a)@]" pp_print_loc _a0
    | `OvNil _a0 -> Format.fprintf fmt "@[<1>(`OvNil@ %a)@]" pp_print_loc _a0
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
let pp_print_row_var_flag: 'fmt -> row_var_flag -> 'result =
  fun fmt  ->
    function
    | `RowVar _a0 ->
        Format.fprintf fmt "@[<1>(`RowVar@ %a)@]" pp_print_loc _a0
    | `RvNil _a0 -> Format.fprintf fmt "@[<1>(`RvNil@ %a)@]" pp_print_loc _a0
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
let pp_print_position_flag: 'fmt -> position_flag -> 'result =
  fun fmt  ->
    function
    | `Positive _a0 ->
        Format.fprintf fmt "@[<1>(`Positive@ %a)@]" pp_print_loc _a0
    | `Negative _a0 ->
        Format.fprintf fmt "@[<1>(`Negative@ %a)@]" pp_print_loc _a0
    | `Normal _a0 ->
        Format.fprintf fmt "@[<1>(`Normal@ %a)@]" pp_print_loc _a0
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
let pp_print_meta_bool: 'fmt -> meta_bool -> 'result =
  fun fmt  ->
    function
    | `True _a0 -> Format.fprintf fmt "@[<1>(`True@ %a)@]" pp_print_loc _a0
    | `False _a0 -> Format.fprintf fmt "@[<1>(`False@ %a)@]" pp_print_loc _a0
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
let pp_print_meta_option :
  'all_a0 .
    ('fmt -> 'all_a0 -> 'result) -> 'fmt -> 'all_a0 meta_option -> 'result=
  fun mf_a  fmt  ->
    function
    | `None _a0 -> Format.fprintf fmt "@[<1>(`None@ %a)@]" pp_print_loc _a0
    | `Some _a0 -> Format.fprintf fmt "@[<1>(`Some@ %a)@]" mf_a _a0
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
let rec pp_print_meta_list :
  'all_a0 .
    ('fmt -> 'all_a0 -> 'result) -> 'fmt -> 'all_a0 meta_list -> 'result=
  fun mf_a  fmt  ->
    function
    | `LNil _a0 -> Format.fprintf fmt "@[<1>(`LNil@ %a)@]" pp_print_loc _a0
    | `LCons (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`LCons@ %a@ %a)@]" mf_a _a0
          (pp_print_meta_list mf_a) _a1
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
let pp_print_alident: 'fmt -> alident -> 'result =
  fun fmt  ->
    function
    | `Lid (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Lid@ %a@ %a)@]" pp_print_loc _a0
          pp_print_string _a1
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
let pp_print_auident: 'fmt -> auident -> 'result =
  fun fmt  ->
    function
    | `Uid (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Uid@ %a@ %a)@]" pp_print_loc _a0
          pp_print_string _a1
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
let pp_print_aident: 'fmt -> aident -> 'result =
  fun fmt  ->
    function
    | #alident as _a0 -> (pp_print_alident fmt _a0 :>'result)
    | #auident as _a0 -> (pp_print_auident fmt _a0 :>'result)
let pp_print_astring: 'fmt -> astring -> 'result =
  fun fmt  ->
    function
    | `C (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`C@ %a@ %a)@]" pp_print_loc _a0
          pp_print_string _a1
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
let rec pp_print_ident: 'fmt -> ident -> 'result =
  fun fmt  ->
    function
    | `Dot (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Dot@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ident _a1 pp_print_ident _a2
    | `IdApp (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`IdApp@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ident _a1 pp_print_ident _a2
    | #alident as _a0 -> (pp_print_alident fmt _a0 :>'result)
    | #auident as _a0 -> (pp_print_auident fmt _a0 :>'result)
let rec pp_print_ctyp: 'fmt -> ctyp -> 'result =
  fun fmt  ->
    function
    | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" pp_print_loc _a0
    | `Alias (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Alias@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1 pp_print_ctyp _a2
    | `Any _a0 -> Format.fprintf fmt "@[<1>(`Any@ %a)@]" pp_print_loc _a0
    | `TyApp (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`TyApp@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1 pp_print_ctyp _a2
    | `Arrow (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Arrow@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1 pp_print_ctyp _a2
    | `ClassPath (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`ClassPath@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ident _a1
    | `Label (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Label@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_alident _a1 pp_print_ctyp _a2
    | `Id (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Id@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ident _a1
    | `TyMan (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`TyMan@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1 pp_print_ctyp _a2
    | `TyDcl (_a0,_a1,_a2,_a3,_a4) ->
        Format.fprintf fmt "@[<1>(`TyDcl@ %a@ %a@ %a@ %a@ %a)@]" pp_print_loc
          _a0 pp_print_alident _a1 (pp_print_list pp_print_ctyp) _a2
          pp_print_ctyp _a3
          (pp_print_list
             (fun fmt  (_a0,_a1)  ->
                Format.fprintf fmt "@[<1>(%a,@,%a)@]" pp_print_ctyp _a0
                  pp_print_ctyp _a1)) _a4
    | `TyObj (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`TyObj@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1 pp_print_row_var_flag _a2
    | `TyOlb (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`TyOlb@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_alident _a1 pp_print_ctyp _a2
    | `TyPol (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`TyPol@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1 pp_print_ctyp _a2
    | `TyTypePol (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`TyTypePol@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1 pp_print_ctyp _a2
    | `Quote (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Quote@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_position_flag _a1 (pp_print_meta_option pp_print_alident)
          _a2
    | `TyRec (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`TyRec@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1
    | `TyCol (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`TyCol@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1 pp_print_ctyp _a2
    | `Sem (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Sem@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1 pp_print_ctyp _a2
    | `Com (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Com@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1 pp_print_ctyp _a2
    | `Sum (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Sum@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1
    | `Of (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Of@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1 pp_print_ctyp _a2
    | `And (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`And@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1 pp_print_ctyp _a2
    | `Or (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Or@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1 pp_print_ctyp _a2
    | `Priv (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Priv@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1
    | `Mut (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Mut@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1
    | `Tup (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Tup@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1
    | `Sta (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Sta@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1 pp_print_ctyp _a2
    | `TyVrn (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`TyVrn@ %a@ %a)@]" pp_print_loc _a0
          pp_print_astring _a1
    | `TyVrnEq (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`TyVrnEq@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1
    | `TyVrnSup (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`TyVrnSup@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1
    | `TyVrnInf (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`TyVrnInf@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1
    | `TyVrnInfSup (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`TyVrnInfSup@ %a@ %a@ %a)@]" pp_print_loc
          _a0 pp_print_ctyp _a1 pp_print_ctyp _a2
    | `Amp (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Amp@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1 pp_print_ctyp _a2
    | `TyOfAmp (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`TyOfAmp@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1 pp_print_ctyp _a2
    | `Package (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Package@ %a@ %a)@]" pp_print_loc _a0
          pp_print_module_type _a1
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
and pp_print_patt: 'fmt -> patt -> 'result =
  fun fmt  ->
    function
    | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" pp_print_loc _a0
    | `Id (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Id@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ident _a1
    | `Alias (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Alias@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_patt _a1 pp_print_alident _a2
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
    | `Any _a0 -> Format.fprintf fmt "@[<1>(`Any@ %a)@]" pp_print_loc _a0
    | `PaApp (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`PaApp@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_patt _a1 pp_print_patt _a2
    | `Array (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Array@ %a@ %a)@]" pp_print_loc _a0
          pp_print_patt _a1
    | `Com (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Com@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_patt _a1 pp_print_patt _a2
    | `Sem (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Sem@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_patt _a1 pp_print_patt _a2
    | #literal as _a0 -> (pp_print_literal fmt _a0 :>'result)
    | `Label (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Label@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_alident _a1 pp_print_patt _a2
    | `PaOlbi (_a0,_a1,_a2,_a3) ->
        Format.fprintf fmt "@[<1>(`PaOlbi@ %a@ %a@ %a@ %a)@]" pp_print_loc
          _a0 pp_print_alident _a1 pp_print_patt _a2
          (pp_print_meta_option pp_print_expr) _a3
    | `Or (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Or@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_patt _a1 pp_print_patt _a2
    | `PaRng (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`PaRng@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_patt _a1 pp_print_patt _a2
    | `PaRec (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`PaRec@ %a@ %a)@]" pp_print_loc _a0
          pp_print_patt _a1
    | `PaEq (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`PaEq@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ident _a1 pp_print_patt _a2
    | `Tup (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Tup@ %a@ %a)@]" pp_print_loc _a0
          pp_print_patt _a1
    | `Constraint (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Constraint@ %a@ %a@ %a)@]" pp_print_loc
          _a0 pp_print_patt _a1 pp_print_ctyp _a2
    | `ClassPath (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`ClassPath@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ident _a1
    | `PaVrn (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`PaVrn@ %a@ %a)@]" pp_print_loc _a0
          pp_print_string _a1
    | `Lazy (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Lazy@ %a@ %a)@]" pp_print_loc _a0
          pp_print_patt _a1
    | `ModuleUnpack (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`ModuleUnpack@ %a@ %a@ %a)@]" pp_print_loc
          _a0 pp_print_auident _a1 (pp_print_meta_option pp_print_ctyp) _a2
and pp_print_expr: 'fmt -> expr -> 'result =
  fun fmt  ->
    function
    | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" pp_print_loc _a0
    | `Id (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Id@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ident _a1
    | `Dot (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Dot@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_expr _a1 pp_print_expr _a2
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
    | `ExApp (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`ExApp@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_expr _a1 pp_print_expr _a2
    | `ArrayDot (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`ArrayDot@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_expr _a1 pp_print_expr _a2
    | `Array (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Array@ %a@ %a)@]" pp_print_loc _a0
          pp_print_expr _a1
    | `Sem (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Sem@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_expr _a1 pp_print_expr _a2
    | `ExAsf _a0 -> Format.fprintf fmt "@[<1>(`ExAsf@ %a)@]" pp_print_loc _a0
    | `ExAsr (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`ExAsr@ %a@ %a)@]" pp_print_loc _a0
          pp_print_expr _a1
    | `Assign (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Assign@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_expr _a1 pp_print_expr _a2
    | `For (_a0,_a1,_a2,_a3,_a4,_a5) ->
        Format.fprintf fmt "@[<1>(`For@ %a@ %a@ %a@ %a@ %a@ %a)@]"
          pp_print_loc _a0 pp_print_alident _a1 pp_print_expr _a2
          pp_print_expr _a3 pp_print_direction_flag _a4 pp_print_expr _a5
    | `Fun (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Fun@ %a@ %a)@]" pp_print_loc _a0
          pp_print_match_case _a1
    | `IfThenElse (_a0,_a1,_a2,_a3) ->
        Format.fprintf fmt "@[<1>(`IfThenElse@ %a@ %a@ %a@ %a)@]"
          pp_print_loc _a0 pp_print_expr _a1 pp_print_expr _a2 pp_print_expr
          _a3
    | `IfThen (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`IfThen@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_expr _a1 pp_print_expr _a2
    | #literal as _a0 -> (pp_print_literal fmt _a0 :>'result)
    | `Label (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Label@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_alident _a1 pp_print_expr _a2
    | `Lazy (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Lazy@ %a@ %a)@]" pp_print_loc _a0
          pp_print_expr _a1
    | `LetIn (_a0,_a1,_a2,_a3) ->
        Format.fprintf fmt "@[<1>(`LetIn@ %a@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_rec_flag _a1 pp_print_binding _a2 pp_print_expr _a3
    | `LetModule (_a0,_a1,_a2,_a3) ->
        Format.fprintf fmt "@[<1>(`LetModule@ %a@ %a@ %a@ %a)@]" pp_print_loc
          _a0 pp_print_auident _a1 pp_print_module_expr _a2 pp_print_expr _a3
    | `Match (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Match@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_expr _a1 pp_print_match_case _a2
    | `New (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`New@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ident _a1
    | `Obj (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Obj@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_patt _a1 pp_print_class_str_item _a2
    | `OptLabl (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`OptLabl@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_alident _a1 pp_print_expr _a2
    | `OvrInst (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`OvrInst@ %a@ %a)@]" pp_print_loc _a0
          pp_print_rec_binding _a1
    | `Record (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Record@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_rec_binding _a1 pp_print_expr _a2
    | `Seq (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Seq@ %a@ %a)@]" pp_print_loc _a0
          pp_print_expr _a1
    | `Send (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Send@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_expr _a1 pp_print_alident _a2
    | `StringDot (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`StringDot@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_expr _a1 pp_print_expr _a2
    | `Try (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Try@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_expr _a1 pp_print_match_case _a2
    | `Tup (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Tup@ %a@ %a)@]" pp_print_loc _a0
          pp_print_expr _a1
    | `Com (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Com@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_expr _a1 pp_print_expr _a2
    | `Constraint (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Constraint@ %a@ %a@ %a)@]" pp_print_loc
          _a0 pp_print_expr _a1 pp_print_ctyp _a2
    | `Coercion (_a0,_a1,_a2,_a3) ->
        Format.fprintf fmt "@[<1>(`Coercion@ %a@ %a@ %a@ %a)@]" pp_print_loc
          _a0 pp_print_expr _a1 pp_print_ctyp _a2 pp_print_ctyp _a3
    | `ExVrn (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`ExVrn@ %a@ %a)@]" pp_print_loc _a0
          pp_print_string _a1
    | `While (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`While@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_expr _a1 pp_print_expr _a2
    | `LetOpen (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`LetOpen@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ident _a1 pp_print_expr _a2
    | `LocalTypeFun (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`LocalTypeFun@ %a@ %a@ %a)@]" pp_print_loc
          _a0 pp_print_alident _a1 pp_print_expr _a2
    | `Package_expr (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Package_expr@ %a@ %a)@]" pp_print_loc _a0
          pp_print_module_expr _a1
and pp_print_module_type: 'fmt -> module_type -> 'result =
  fun fmt  ->
    function
    | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" pp_print_loc _a0
    | `Id (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Id@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ident _a1
    | `MtFun (_a0,_a1,_a2,_a3) ->
        Format.fprintf fmt "@[<1>(`MtFun@ %a@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_auident _a1 pp_print_module_type _a2 pp_print_module_type
          _a3
    | `Sig (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Sig@ %a@ %a)@]" pp_print_loc _a0
          pp_print_sig_item _a1
    | `With (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`With@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_module_type _a1 pp_print_with_constr _a2
    | `ModuleTypeOf (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`ModuleTypeOf@ %a@ %a)@]" pp_print_loc _a0
          pp_print_module_expr _a1
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
and pp_print_sig_item: 'fmt -> sig_item -> 'result =
  fun fmt  ->
    function
    | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" pp_print_loc _a0
    | `Class (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Class@ %a@ %a)@]" pp_print_loc _a0
          pp_print_class_type _a1
    | `ClassType (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`ClassType@ %a@ %a)@]" pp_print_loc _a0
          pp_print_class_type _a1
    | `Sem (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Sem@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_sig_item _a1 pp_print_sig_item _a2
    | `Directive (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Directive@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_alident _a1 pp_print_expr _a2
    | `Exception (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Exception@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1
    | `External (_a0,_a1,_a2,_a3) ->
        Format.fprintf fmt "@[<1>(`External@ %a@ %a@ %a@ %a)@]" pp_print_loc
          _a0 pp_print_alident _a1 pp_print_ctyp _a2
          (pp_print_meta_list pp_print_string) _a3
    | `Include (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Include@ %a@ %a)@]" pp_print_loc _a0
          pp_print_module_type _a1
    | `Module (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Module@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_auident _a1 pp_print_module_type _a2
    | `RecModule (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`RecModule@ %a@ %a)@]" pp_print_loc _a0
          pp_print_module_binding _a1
    | `ModuleType (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`ModuleType@ %a@ %a@ %a)@]" pp_print_loc
          _a0 pp_print_auident _a1 pp_print_module_type _a2
    | `Open (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Open@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ident _a1
    | `Type (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Type@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1
    | `Val (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Val@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_alident _a1 pp_print_ctyp _a2
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
and pp_print_with_constr: 'fmt -> with_constr -> 'result =
  fun fmt  ->
    function
    | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" pp_print_loc _a0
    | `TypeEq (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`TypeEq@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1 pp_print_ctyp _a2
    | `ModuleEq (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`ModuleEq@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ident _a1 pp_print_ident _a2
    | `TypeSubst (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`TypeSubst@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1 pp_print_ctyp _a2
    | `ModuleSubst (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`ModuleSubst@ %a@ %a@ %a)@]" pp_print_loc
          _a0 pp_print_ident _a1 pp_print_ident _a2
    | `And (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`And@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_with_constr _a1 pp_print_with_constr _a2
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
and pp_print_binding: 'fmt -> binding -> 'result =
  fun fmt  ->
    function
    | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" pp_print_loc _a0
    | `And (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`And@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_binding _a1 pp_print_binding _a2
    | `Bind (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Bind@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_patt _a1 pp_print_expr _a2
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
and pp_print_rec_binding: 'fmt -> rec_binding -> 'result =
  fun fmt  ->
    function
    | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" pp_print_loc _a0
    | `Sem (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Sem@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_rec_binding _a1 pp_print_rec_binding _a2
    | `RecBind (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`RecBind@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ident _a1 pp_print_expr _a2
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
and pp_print_module_binding: 'fmt -> module_binding -> 'result =
  fun fmt  ->
    function
    | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" pp_print_loc _a0
    | `And (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`And@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_module_binding _a1 pp_print_module_binding _a2
    | `ModuleBind (_a0,_a1,_a2,_a3) ->
        Format.fprintf fmt "@[<1>(`ModuleBind@ %a@ %a@ %a@ %a)@]"
          pp_print_loc _a0 pp_print_auident _a1 pp_print_module_type _a2
          pp_print_module_expr _a3
    | `Constraint (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Constraint@ %a@ %a@ %a)@]" pp_print_loc
          _a0 pp_print_auident _a1 pp_print_module_type _a2
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
and pp_print_match_case: 'fmt -> match_case -> 'result =
  fun fmt  ->
    function
    | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" pp_print_loc _a0
    | `Or (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Or@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_match_case _a1 pp_print_match_case _a2
    | `Case (_a0,_a1,_a2,_a3) ->
        Format.fprintf fmt "@[<1>(`Case@ %a@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_patt _a1 pp_print_expr _a2 pp_print_expr _a3
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
and pp_print_module_expr: 'fmt -> module_expr -> 'result =
  fun fmt  ->
    function
    | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" pp_print_loc _a0
    | `Id (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Id@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ident _a1
    | `MeApp (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`MeApp@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_module_expr _a1 pp_print_module_expr _a2
    | `Functor (_a0,_a1,_a2,_a3) ->
        Format.fprintf fmt "@[<1>(`Functor@ %a@ %a@ %a@ %a)@]" pp_print_loc
          _a0 pp_print_auident _a1 pp_print_module_type _a2
          pp_print_module_expr _a3
    | `Struct (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Struct@ %a@ %a)@]" pp_print_loc _a0
          pp_print_str_item _a1
    | `Constraint (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Constraint@ %a@ %a@ %a)@]" pp_print_loc
          _a0 pp_print_module_expr _a1 pp_print_module_type _a2
    | `PackageModule (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`PackageModule@ %a@ %a)@]" pp_print_loc _a0
          pp_print_expr _a1
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
and pp_print_str_item: 'fmt -> str_item -> 'result =
  fun fmt  ->
    function
    | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" pp_print_loc _a0
    | `Class (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Class@ %a@ %a)@]" pp_print_loc _a0
          pp_print_class_expr _a1
    | `ClassType (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`ClassType@ %a@ %a)@]" pp_print_loc _a0
          pp_print_class_type _a1
    | `Sem (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Sem@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_str_item _a1 pp_print_str_item _a2
    | `Directive (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Directive@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_alident _a1 pp_print_expr _a2
    | `Exception (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Exception@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1
    | `StExp (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`StExp@ %a@ %a)@]" pp_print_loc _a0
          pp_print_expr _a1
    | `External (_a0,_a1,_a2,_a3) ->
        Format.fprintf fmt "@[<1>(`External@ %a@ %a@ %a@ %a)@]" pp_print_loc
          _a0 pp_print_alident _a1 pp_print_ctyp _a2
          (pp_print_meta_list pp_print_string) _a3
    | `Include (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Include@ %a@ %a)@]" pp_print_loc _a0
          pp_print_module_expr _a1
    | `Module (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Module@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_auident _a1 pp_print_module_expr _a2
    | `RecModule (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`RecModule@ %a@ %a)@]" pp_print_loc _a0
          pp_print_module_binding _a1
    | `ModuleType (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`ModuleType@ %a@ %a@ %a)@]" pp_print_loc
          _a0 pp_print_auident _a1 pp_print_module_type _a2
    | `Open (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Open@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ident _a1
    | `Type (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Type@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1
    | `Value (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Value@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_rec_flag _a1 pp_print_binding _a2
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
and pp_print_class_type: 'fmt -> class_type -> 'result =
  fun fmt  ->
    function
    | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" pp_print_loc _a0
    | `CtCon (_a0,_a1,_a2,_a3) ->
        Format.fprintf fmt "@[<1>(`CtCon@ %a@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_virtual_flag _a1 pp_print_ident _a2 pp_print_ctyp _a3
    | `CtFun (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`CtFun@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1 pp_print_class_type _a2
    | `CtSig (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`CtSig@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1 pp_print_class_sig_item _a2
    | `And (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`And@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_class_type _a1 pp_print_class_type _a2
    | `CtCol (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`CtCol@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_class_type _a1 pp_print_class_type _a2
    | `CtEq (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`CtEq@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_class_type _a1 pp_print_class_type _a2
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
and pp_print_class_sig_item: 'fmt -> class_sig_item -> 'result =
  fun fmt  ->
    function
    | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" pp_print_loc _a0
    | `Eq (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Eq@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1 pp_print_ctyp _a2
    | `Sem (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Sem@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_class_sig_item _a1 pp_print_class_sig_item _a2
    | `SigInherit (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`SigInherit@ %a@ %a)@]" pp_print_loc _a0
          pp_print_class_type _a1
    | `Method (_a0,_a1,_a2,_a3) ->
        Format.fprintf fmt "@[<1>(`Method@ %a@ %a@ %a@ %a)@]" pp_print_loc
          _a0 pp_print_alident _a1 pp_print_private_flag _a2 pp_print_ctyp
          _a3
    | `CgVal (_a0,_a1,_a2,_a3,_a4) ->
        Format.fprintf fmt "@[<1>(`CgVal@ %a@ %a@ %a@ %a@ %a)@]" pp_print_loc
          _a0 pp_print_alident _a1 pp_print_mutable_flag _a2
          pp_print_virtual_flag _a3 pp_print_ctyp _a4
    | `CgVir (_a0,_a1,_a2,_a3) ->
        Format.fprintf fmt "@[<1>(`CgVir@ %a@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_alident _a1 pp_print_private_flag _a2 pp_print_ctyp _a3
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
and pp_print_class_expr: 'fmt -> class_expr -> 'result =
  fun fmt  ->
    function
    | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" pp_print_loc _a0
    | `CeApp (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`CeApp@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_class_expr _a1 pp_print_expr _a2
    | `CeCon (_a0,_a1,_a2,_a3) ->
        Format.fprintf fmt "@[<1>(`CeCon@ %a@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_virtual_flag _a1 pp_print_ident _a2 pp_print_ctyp _a3
    | `CeFun (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`CeFun@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_patt _a1 pp_print_class_expr _a2
    | `CeLet (_a0,_a1,_a2,_a3) ->
        Format.fprintf fmt "@[<1>(`CeLet@ %a@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_rec_flag _a1 pp_print_binding _a2 pp_print_class_expr _a3
    | `Obj (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Obj@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_patt _a1 pp_print_class_str_item _a2
    | `CeTyc (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`CeTyc@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_class_expr _a1 pp_print_class_type _a2
    | `And (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`And@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_class_expr _a1 pp_print_class_expr _a2
    | `Eq (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Eq@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_class_expr _a1 pp_print_class_expr _a2
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
and pp_print_class_str_item: 'fmt -> class_str_item -> 'result =
  fun fmt  ->
    function
    | `Nil _a0 -> Format.fprintf fmt "@[<1>(`Nil@ %a)@]" pp_print_loc _a0
    | `Sem (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Sem@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_class_str_item _a1 pp_print_class_str_item _a2
    | `Eq (_a0,_a1,_a2) ->
        Format.fprintf fmt "@[<1>(`Eq@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_ctyp _a1 pp_print_ctyp _a2
    | `Inherit (_a0,_a1,_a2,_a3) ->
        Format.fprintf fmt "@[<1>(`Inherit@ %a@ %a@ %a@ %a)@]" pp_print_loc
          _a0 pp_print_override_flag _a1 pp_print_class_expr _a2
          (pp_print_meta_option pp_print_alident) _a3
    | `Initializer (_a0,_a1) ->
        Format.fprintf fmt "@[<1>(`Initializer@ %a@ %a)@]" pp_print_loc _a0
          pp_print_expr _a1
    | `CrMth (_a0,_a1,_a2,_a3,_a4,_a5) ->
        Format.fprintf fmt "@[<1>(`CrMth@ %a@ %a@ %a@ %a@ %a@ %a)@]"
          pp_print_loc _a0 pp_print_alident _a1 pp_print_override_flag _a2
          pp_print_private_flag _a3 pp_print_expr _a4 pp_print_ctyp _a5
    | `CrVal (_a0,_a1,_a2,_a3,_a4) ->
        Format.fprintf fmt "@[<1>(`CrVal@ %a@ %a@ %a@ %a@ %a)@]" pp_print_loc
          _a0 pp_print_alident _a1 pp_print_override_flag _a2
          pp_print_mutable_flag _a3 pp_print_expr _a4
    | `CrVir (_a0,_a1,_a2,_a3) ->
        Format.fprintf fmt "@[<1>(`CrVir@ %a@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_alident _a1 pp_print_private_flag _a2 pp_print_ctyp _a3
    | `CrVvr (_a0,_a1,_a2,_a3) ->
        Format.fprintf fmt "@[<1>(`CrVvr@ %a@ %a@ %a@ %a)@]" pp_print_loc _a0
          pp_print_alident _a1 pp_print_mutable_flag _a2 pp_print_ctyp _a3
    | #ant as _a0 -> (pp_print_ant fmt _a0 :>'result)
class iter =
  object (self : 'self_type)
    inherit  iterbase
    method loc : loc -> 'result= fun _a0  -> self#fanloc_t _a0
    method ant : ant -> 'result=
      fun (`Ant (_a0,_a1))  -> self#loc _a0; self#fanutil_anti_cxt _a1
    method literal : literal -> 'result=
      function
      | `Chr (_a0,_a1) -> (self#loc _a0; self#string _a1)
      | `Int (_a0,_a1) -> (self#loc _a0; self#string _a1)
      | `Int32 (_a0,_a1) -> (self#loc _a0; self#string _a1)
      | `Int64 (_a0,_a1) -> (self#loc _a0; self#string _a1)
      | `Flo (_a0,_a1) -> (self#loc _a0; self#string _a1)
      | `NativeInt (_a0,_a1) -> (self#loc _a0; self#string _a1)
      | `Str (_a0,_a1) -> (self#loc _a0; self#string _a1)
    method rec_flag : rec_flag -> 'result=
      function
      | `Recursive _a0 -> self#loc _a0
      | `ReNil _a0 -> self#loc _a0
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method direction_flag : direction_flag -> 'result=
      function
      | `To _a0 -> self#loc _a0
      | `Downto _a0 -> self#loc _a0
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method mutable_flag : mutable_flag -> 'result=
      function
      | `Mutable _a0 -> self#loc _a0
      | `MuNil _a0 -> self#loc _a0
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method private_flag : private_flag -> 'result=
      function
      | `Private _a0 -> self#loc _a0
      | `PrNil _a0 -> self#loc _a0
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method virtual_flag : virtual_flag -> 'result=
      function
      | `Virtual _a0 -> self#loc _a0
      | `ViNil _a0 -> self#loc _a0
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method override_flag : override_flag -> 'result=
      function
      | `Override _a0 -> self#loc _a0
      | `OvNil _a0 -> self#loc _a0
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method row_var_flag : row_var_flag -> 'result=
      function
      | `RowVar _a0 -> self#loc _a0
      | `RvNil _a0 -> self#loc _a0
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method position_flag : position_flag -> 'result=
      function
      | `Positive _a0 -> self#loc _a0
      | `Negative _a0 -> self#loc _a0
      | `Normal _a0 -> self#loc _a0
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method meta_bool : meta_bool -> 'result=
      function
      | `True _a0 -> self#loc _a0
      | `False _a0 -> self#loc _a0
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method meta_option :
      'all_a0 .
        ('self_type -> 'all_a0 -> 'result) -> 'all_a0 meta_option -> 'result=
      fun mf_a  ->
        function
        | `None _a0 -> self#loc _a0
        | `Some _a0 -> mf_a self _a0
        | #ant as _a0 -> (self#ant _a0 :>'result)
    method meta_list :
      'all_a0 .
        ('self_type -> 'all_a0 -> 'result) -> 'all_a0 meta_list -> 'result=
      fun mf_a  ->
        function
        | `LNil _a0 -> self#loc _a0
        | `LCons (_a0,_a1) -> (mf_a self _a0; self#meta_list mf_a _a1)
        | #ant as _a0 -> (self#ant _a0 :>'result)
    method alident : alident -> 'result=
      function
      | `Lid (_a0,_a1) -> (self#loc _a0; self#string _a1)
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method auident : auident -> 'result=
      function
      | `Uid (_a0,_a1) -> (self#loc _a0; self#string _a1)
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method aident : aident -> 'result=
      function
      | #alident as _a0 -> (self#alident _a0 :>'result)
      | #auident as _a0 -> (self#auident _a0 :>'result)
    method astring : astring -> 'result=
      function
      | `C (_a0,_a1) -> (self#loc _a0; self#string _a1)
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method ident : ident -> 'result=
      function
      | `Dot (_a0,_a1,_a2) -> (self#loc _a0; self#ident _a1; self#ident _a2)
      | `IdApp (_a0,_a1,_a2) ->
          (self#loc _a0; self#ident _a1; self#ident _a2)
      | #alident as _a0 -> (self#alident _a0 :>'result)
      | #auident as _a0 -> (self#auident _a0 :>'result)
    method ctyp : ctyp -> 'result=
      function
      | `Nil _a0 -> self#loc _a0
      | `Alias (_a0,_a1,_a2) -> (self#loc _a0; self#ctyp _a1; self#ctyp _a2)
      | `Any _a0 -> self#loc _a0
      | `TyApp (_a0,_a1,_a2) -> (self#loc _a0; self#ctyp _a1; self#ctyp _a2)
      | `Arrow (_a0,_a1,_a2) -> (self#loc _a0; self#ctyp _a1; self#ctyp _a2)
      | `ClassPath (_a0,_a1) -> (self#loc _a0; self#ident _a1)
      | `Label (_a0,_a1,_a2) ->
          (self#loc _a0; self#alident _a1; self#ctyp _a2)
      | `Id (_a0,_a1) -> (self#loc _a0; self#ident _a1)
      | `TyMan (_a0,_a1,_a2) -> (self#loc _a0; self#ctyp _a1; self#ctyp _a2)
      | `TyDcl (_a0,_a1,_a2,_a3,_a4) ->
          (self#loc _a0;
           self#alident _a1;
           self#list (fun self  -> self#ctyp) _a2;
           self#ctyp _a3;
           self#list (fun self  (_a0,_a1)  -> self#ctyp _a0; self#ctyp _a1)
             _a4)
      | `TyObj (_a0,_a1,_a2) ->
          (self#loc _a0; self#ctyp _a1; self#row_var_flag _a2)
      | `TyOlb (_a0,_a1,_a2) ->
          (self#loc _a0; self#alident _a1; self#ctyp _a2)
      | `TyPol (_a0,_a1,_a2) -> (self#loc _a0; self#ctyp _a1; self#ctyp _a2)
      | `TyTypePol (_a0,_a1,_a2) ->
          (self#loc _a0; self#ctyp _a1; self#ctyp _a2)
      | `Quote (_a0,_a1,_a2) ->
          (self#loc _a0;
           self#position_flag _a1;
           self#meta_option (fun self  -> self#alident) _a2)
      | `TyRec (_a0,_a1) -> (self#loc _a0; self#ctyp _a1)
      | `TyCol (_a0,_a1,_a2) -> (self#loc _a0; self#ctyp _a1; self#ctyp _a2)
      | `Sem (_a0,_a1,_a2) -> (self#loc _a0; self#ctyp _a1; self#ctyp _a2)
      | `Com (_a0,_a1,_a2) -> (self#loc _a0; self#ctyp _a1; self#ctyp _a2)
      | `Sum (_a0,_a1) -> (self#loc _a0; self#ctyp _a1)
      | `Of (_a0,_a1,_a2) -> (self#loc _a0; self#ctyp _a1; self#ctyp _a2)
      | `And (_a0,_a1,_a2) -> (self#loc _a0; self#ctyp _a1; self#ctyp _a2)
      | `Or (_a0,_a1,_a2) -> (self#loc _a0; self#ctyp _a1; self#ctyp _a2)
      | `Priv (_a0,_a1) -> (self#loc _a0; self#ctyp _a1)
      | `Mut (_a0,_a1) -> (self#loc _a0; self#ctyp _a1)
      | `Tup (_a0,_a1) -> (self#loc _a0; self#ctyp _a1)
      | `Sta (_a0,_a1,_a2) -> (self#loc _a0; self#ctyp _a1; self#ctyp _a2)
      | `TyVrn (_a0,_a1) -> (self#loc _a0; self#astring _a1)
      | `TyVrnEq (_a0,_a1) -> (self#loc _a0; self#ctyp _a1)
      | `TyVrnSup (_a0,_a1) -> (self#loc _a0; self#ctyp _a1)
      | `TyVrnInf (_a0,_a1) -> (self#loc _a0; self#ctyp _a1)
      | `TyVrnInfSup (_a0,_a1,_a2) ->
          (self#loc _a0; self#ctyp _a1; self#ctyp _a2)
      | `Amp (_a0,_a1,_a2) -> (self#loc _a0; self#ctyp _a1; self#ctyp _a2)
      | `TyOfAmp (_a0,_a1,_a2) ->
          (self#loc _a0; self#ctyp _a1; self#ctyp _a2)
      | `Package (_a0,_a1) -> (self#loc _a0; self#module_type _a1)
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method patt : patt -> 'result=
      function
      | `Nil _a0 -> self#loc _a0
      | `Id (_a0,_a1) -> (self#loc _a0; self#ident _a1)
      | `Alias (_a0,_a1,_a2) ->
          (self#loc _a0; self#patt _a1; self#alident _a2)
      | #ant as _a0 -> (self#ant _a0 :>'result)
      | `Any _a0 -> self#loc _a0
      | `PaApp (_a0,_a1,_a2) -> (self#loc _a0; self#patt _a1; self#patt _a2)
      | `Array (_a0,_a1) -> (self#loc _a0; self#patt _a1)
      | `Com (_a0,_a1,_a2) -> (self#loc _a0; self#patt _a1; self#patt _a2)
      | `Sem (_a0,_a1,_a2) -> (self#loc _a0; self#patt _a1; self#patt _a2)
      | #literal as _a0 -> (self#literal _a0 :>'result)
      | `Label (_a0,_a1,_a2) ->
          (self#loc _a0; self#alident _a1; self#patt _a2)
      | `PaOlbi (_a0,_a1,_a2,_a3) ->
          (self#loc _a0;
           self#alident _a1;
           self#patt _a2;
           self#meta_option (fun self  -> self#expr) _a3)
      | `Or (_a0,_a1,_a2) -> (self#loc _a0; self#patt _a1; self#patt _a2)
      | `PaRng (_a0,_a1,_a2) -> (self#loc _a0; self#patt _a1; self#patt _a2)
      | `PaRec (_a0,_a1) -> (self#loc _a0; self#patt _a1)
      | `PaEq (_a0,_a1,_a2) -> (self#loc _a0; self#ident _a1; self#patt _a2)
      | `Tup (_a0,_a1) -> (self#loc _a0; self#patt _a1)
      | `Constraint (_a0,_a1,_a2) ->
          (self#loc _a0; self#patt _a1; self#ctyp _a2)
      | `ClassPath (_a0,_a1) -> (self#loc _a0; self#ident _a1)
      | `PaVrn (_a0,_a1) -> (self#loc _a0; self#string _a1)
      | `Lazy (_a0,_a1) -> (self#loc _a0; self#patt _a1)
      | `ModuleUnpack (_a0,_a1,_a2) ->
          (self#loc _a0;
           self#auident _a1;
           self#meta_option (fun self  -> self#ctyp) _a2)
    method expr : expr -> 'result=
      function
      | `Nil _a0 -> self#loc _a0
      | `Id (_a0,_a1) -> (self#loc _a0; self#ident _a1)
      | `Dot (_a0,_a1,_a2) -> (self#loc _a0; self#expr _a1; self#expr _a2)
      | #ant as _a0 -> (self#ant _a0 :>'result)
      | `ExApp (_a0,_a1,_a2) -> (self#loc _a0; self#expr _a1; self#expr _a2)
      | `ArrayDot (_a0,_a1,_a2) ->
          (self#loc _a0; self#expr _a1; self#expr _a2)
      | `Array (_a0,_a1) -> (self#loc _a0; self#expr _a1)
      | `Sem (_a0,_a1,_a2) -> (self#loc _a0; self#expr _a1; self#expr _a2)
      | `ExAsf _a0 -> self#loc _a0
      | `ExAsr (_a0,_a1) -> (self#loc _a0; self#expr _a1)
      | `Assign (_a0,_a1,_a2) -> (self#loc _a0; self#expr _a1; self#expr _a2)
      | `For (_a0,_a1,_a2,_a3,_a4,_a5) ->
          (self#loc _a0;
           self#alident _a1;
           self#expr _a2;
           self#expr _a3;
           self#direction_flag _a4;
           self#expr _a5)
      | `Fun (_a0,_a1) -> (self#loc _a0; self#match_case _a1)
      | `IfThenElse (_a0,_a1,_a2,_a3) ->
          (self#loc _a0; self#expr _a1; self#expr _a2; self#expr _a3)
      | `IfThen (_a0,_a1,_a2) -> (self#loc _a0; self#expr _a1; self#expr _a2)
      | #literal as _a0 -> (self#literal _a0 :>'result)
      | `Label (_a0,_a1,_a2) ->
          (self#loc _a0; self#alident _a1; self#expr _a2)
      | `Lazy (_a0,_a1) -> (self#loc _a0; self#expr _a1)
      | `LetIn (_a0,_a1,_a2,_a3) ->
          (self#loc _a0; self#rec_flag _a1; self#binding _a2; self#expr _a3)
      | `LetModule (_a0,_a1,_a2,_a3) ->
          (self#loc _a0;
           self#auident _a1;
           self#module_expr _a2;
           self#expr _a3)
      | `Match (_a0,_a1,_a2) ->
          (self#loc _a0; self#expr _a1; self#match_case _a2)
      | `New (_a0,_a1) -> (self#loc _a0; self#ident _a1)
      | `Obj (_a0,_a1,_a2) ->
          (self#loc _a0; self#patt _a1; self#class_str_item _a2)
      | `OptLabl (_a0,_a1,_a2) ->
          (self#loc _a0; self#alident _a1; self#expr _a2)
      | `OvrInst (_a0,_a1) -> (self#loc _a0; self#rec_binding _a1)
      | `Record (_a0,_a1,_a2) ->
          (self#loc _a0; self#rec_binding _a1; self#expr _a2)
      | `Seq (_a0,_a1) -> (self#loc _a0; self#expr _a1)
      | `Send (_a0,_a1,_a2) ->
          (self#loc _a0; self#expr _a1; self#alident _a2)
      | `StringDot (_a0,_a1,_a2) ->
          (self#loc _a0; self#expr _a1; self#expr _a2)
      | `Try (_a0,_a1,_a2) ->
          (self#loc _a0; self#expr _a1; self#match_case _a2)
      | `Tup (_a0,_a1) -> (self#loc _a0; self#expr _a1)
      | `Com (_a0,_a1,_a2) -> (self#loc _a0; self#expr _a1; self#expr _a2)
      | `Constraint (_a0,_a1,_a2) ->
          (self#loc _a0; self#expr _a1; self#ctyp _a2)
      | `Coercion (_a0,_a1,_a2,_a3) ->
          (self#loc _a0; self#expr _a1; self#ctyp _a2; self#ctyp _a3)
      | `ExVrn (_a0,_a1) -> (self#loc _a0; self#string _a1)
      | `While (_a0,_a1,_a2) -> (self#loc _a0; self#expr _a1; self#expr _a2)
      | `LetOpen (_a0,_a1,_a2) ->
          (self#loc _a0; self#ident _a1; self#expr _a2)
      | `LocalTypeFun (_a0,_a1,_a2) ->
          (self#loc _a0; self#alident _a1; self#expr _a2)
      | `Package_expr (_a0,_a1) -> (self#loc _a0; self#module_expr _a1)
    method module_type : module_type -> 'result=
      function
      | `Nil _a0 -> self#loc _a0
      | `Id (_a0,_a1) -> (self#loc _a0; self#ident _a1)
      | `MtFun (_a0,_a1,_a2,_a3) ->
          (self#loc _a0;
           self#auident _a1;
           self#module_type _a2;
           self#module_type _a3)
      | `Sig (_a0,_a1) -> (self#loc _a0; self#sig_item _a1)
      | `With (_a0,_a1,_a2) ->
          (self#loc _a0; self#module_type _a1; self#with_constr _a2)
      | `ModuleTypeOf (_a0,_a1) -> (self#loc _a0; self#module_expr _a1)
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method sig_item : sig_item -> 'result=
      function
      | `Nil _a0 -> self#loc _a0
      | `Class (_a0,_a1) -> (self#loc _a0; self#class_type _a1)
      | `ClassType (_a0,_a1) -> (self#loc _a0; self#class_type _a1)
      | `Sem (_a0,_a1,_a2) ->
          (self#loc _a0; self#sig_item _a1; self#sig_item _a2)
      | `Directive (_a0,_a1,_a2) ->
          (self#loc _a0; self#alident _a1; self#expr _a2)
      | `Exception (_a0,_a1) -> (self#loc _a0; self#ctyp _a1)
      | `External (_a0,_a1,_a2,_a3) ->
          (self#loc _a0;
           self#alident _a1;
           self#ctyp _a2;
           self#meta_list (fun self  -> self#string) _a3)
      | `Include (_a0,_a1) -> (self#loc _a0; self#module_type _a1)
      | `Module (_a0,_a1,_a2) ->
          (self#loc _a0; self#auident _a1; self#module_type _a2)
      | `RecModule (_a0,_a1) -> (self#loc _a0; self#module_binding _a1)
      | `ModuleType (_a0,_a1,_a2) ->
          (self#loc _a0; self#auident _a1; self#module_type _a2)
      | `Open (_a0,_a1) -> (self#loc _a0; self#ident _a1)
      | `Type (_a0,_a1) -> (self#loc _a0; self#ctyp _a1)
      | `Val (_a0,_a1,_a2) -> (self#loc _a0; self#alident _a1; self#ctyp _a2)
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method with_constr : with_constr -> 'result=
      function
      | `Nil _a0 -> self#loc _a0
      | `TypeEq (_a0,_a1,_a2) -> (self#loc _a0; self#ctyp _a1; self#ctyp _a2)
      | `ModuleEq (_a0,_a1,_a2) ->
          (self#loc _a0; self#ident _a1; self#ident _a2)
      | `TypeSubst (_a0,_a1,_a2) ->
          (self#loc _a0; self#ctyp _a1; self#ctyp _a2)
      | `ModuleSubst (_a0,_a1,_a2) ->
          (self#loc _a0; self#ident _a1; self#ident _a2)
      | `And (_a0,_a1,_a2) ->
          (self#loc _a0; self#with_constr _a1; self#with_constr _a2)
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method binding : binding -> 'result=
      function
      | `Nil _a0 -> self#loc _a0
      | `And (_a0,_a1,_a2) ->
          (self#loc _a0; self#binding _a1; self#binding _a2)
      | `Bind (_a0,_a1,_a2) -> (self#loc _a0; self#patt _a1; self#expr _a2)
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method rec_binding : rec_binding -> 'result=
      function
      | `Nil _a0 -> self#loc _a0
      | `Sem (_a0,_a1,_a2) ->
          (self#loc _a0; self#rec_binding _a1; self#rec_binding _a2)
      | `RecBind (_a0,_a1,_a2) ->
          (self#loc _a0; self#ident _a1; self#expr _a2)
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method module_binding : module_binding -> 'result=
      function
      | `Nil _a0 -> self#loc _a0
      | `And (_a0,_a1,_a2) ->
          (self#loc _a0; self#module_binding _a1; self#module_binding _a2)
      | `ModuleBind (_a0,_a1,_a2,_a3) ->
          (self#loc _a0;
           self#auident _a1;
           self#module_type _a2;
           self#module_expr _a3)
      | `Constraint (_a0,_a1,_a2) ->
          (self#loc _a0; self#auident _a1; self#module_type _a2)
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method match_case : match_case -> 'result=
      function
      | `Nil _a0 -> self#loc _a0
      | `Or (_a0,_a1,_a2) ->
          (self#loc _a0; self#match_case _a1; self#match_case _a2)
      | `Case (_a0,_a1,_a2,_a3) ->
          (self#loc _a0; self#patt _a1; self#expr _a2; self#expr _a3)
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method module_expr : module_expr -> 'result=
      function
      | `Nil _a0 -> self#loc _a0
      | `Id (_a0,_a1) -> (self#loc _a0; self#ident _a1)
      | `MeApp (_a0,_a1,_a2) ->
          (self#loc _a0; self#module_expr _a1; self#module_expr _a2)
      | `Functor (_a0,_a1,_a2,_a3) ->
          (self#loc _a0;
           self#auident _a1;
           self#module_type _a2;
           self#module_expr _a3)
      | `Struct (_a0,_a1) -> (self#loc _a0; self#str_item _a1)
      | `Constraint (_a0,_a1,_a2) ->
          (self#loc _a0; self#module_expr _a1; self#module_type _a2)
      | `PackageModule (_a0,_a1) -> (self#loc _a0; self#expr _a1)
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method str_item : str_item -> 'result=
      function
      | `Nil _a0 -> self#loc _a0
      | `Class (_a0,_a1) -> (self#loc _a0; self#class_expr _a1)
      | `ClassType (_a0,_a1) -> (self#loc _a0; self#class_type _a1)
      | `Sem (_a0,_a1,_a2) ->
          (self#loc _a0; self#str_item _a1; self#str_item _a2)
      | `Directive (_a0,_a1,_a2) ->
          (self#loc _a0; self#alident _a1; self#expr _a2)
      | `Exception (_a0,_a1) -> (self#loc _a0; self#ctyp _a1)
      | `StExp (_a0,_a1) -> (self#loc _a0; self#expr _a1)
      | `External (_a0,_a1,_a2,_a3) ->
          (self#loc _a0;
           self#alident _a1;
           self#ctyp _a2;
           self#meta_list (fun self  -> self#string) _a3)
      | `Include (_a0,_a1) -> (self#loc _a0; self#module_expr _a1)
      | `Module (_a0,_a1,_a2) ->
          (self#loc _a0; self#auident _a1; self#module_expr _a2)
      | `RecModule (_a0,_a1) -> (self#loc _a0; self#module_binding _a1)
      | `ModuleType (_a0,_a1,_a2) ->
          (self#loc _a0; self#auident _a1; self#module_type _a2)
      | `Open (_a0,_a1) -> (self#loc _a0; self#ident _a1)
      | `Type (_a0,_a1) -> (self#loc _a0; self#ctyp _a1)
      | `Value (_a0,_a1,_a2) ->
          (self#loc _a0; self#rec_flag _a1; self#binding _a2)
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method class_type : class_type -> 'result=
      function
      | `Nil _a0 -> self#loc _a0
      | `CtCon (_a0,_a1,_a2,_a3) ->
          (self#loc _a0; self#virtual_flag _a1; self#ident _a2; self#ctyp _a3)
      | `CtFun (_a0,_a1,_a2) ->
          (self#loc _a0; self#ctyp _a1; self#class_type _a2)
      | `CtSig (_a0,_a1,_a2) ->
          (self#loc _a0; self#ctyp _a1; self#class_sig_item _a2)
      | `And (_a0,_a1,_a2) ->
          (self#loc _a0; self#class_type _a1; self#class_type _a2)
      | `CtCol (_a0,_a1,_a2) ->
          (self#loc _a0; self#class_type _a1; self#class_type _a2)
      | `CtEq (_a0,_a1,_a2) ->
          (self#loc _a0; self#class_type _a1; self#class_type _a2)
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method class_sig_item : class_sig_item -> 'result=
      function
      | `Nil _a0 -> self#loc _a0
      | `Eq (_a0,_a1,_a2) -> (self#loc _a0; self#ctyp _a1; self#ctyp _a2)
      | `Sem (_a0,_a1,_a2) ->
          (self#loc _a0; self#class_sig_item _a1; self#class_sig_item _a2)
      | `SigInherit (_a0,_a1) -> (self#loc _a0; self#class_type _a1)
      | `Method (_a0,_a1,_a2,_a3) ->
          (self#loc _a0;
           self#alident _a1;
           self#private_flag _a2;
           self#ctyp _a3)
      | `CgVal (_a0,_a1,_a2,_a3,_a4) ->
          (self#loc _a0;
           self#alident _a1;
           self#mutable_flag _a2;
           self#virtual_flag _a3;
           self#ctyp _a4)
      | `CgVir (_a0,_a1,_a2,_a3) ->
          (self#loc _a0;
           self#alident _a1;
           self#private_flag _a2;
           self#ctyp _a3)
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method class_expr : class_expr -> 'result=
      function
      | `Nil _a0 -> self#loc _a0
      | `CeApp (_a0,_a1,_a2) ->
          (self#loc _a0; self#class_expr _a1; self#expr _a2)
      | `CeCon (_a0,_a1,_a2,_a3) ->
          (self#loc _a0; self#virtual_flag _a1; self#ident _a2; self#ctyp _a3)
      | `CeFun (_a0,_a1,_a2) ->
          (self#loc _a0; self#patt _a1; self#class_expr _a2)
      | `CeLet (_a0,_a1,_a2,_a3) ->
          (self#loc _a0;
           self#rec_flag _a1;
           self#binding _a2;
           self#class_expr _a3)
      | `Obj (_a0,_a1,_a2) ->
          (self#loc _a0; self#patt _a1; self#class_str_item _a2)
      | `CeTyc (_a0,_a1,_a2) ->
          (self#loc _a0; self#class_expr _a1; self#class_type _a2)
      | `And (_a0,_a1,_a2) ->
          (self#loc _a0; self#class_expr _a1; self#class_expr _a2)
      | `Eq (_a0,_a1,_a2) ->
          (self#loc _a0; self#class_expr _a1; self#class_expr _a2)
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method class_str_item : class_str_item -> 'result=
      function
      | `Nil _a0 -> self#loc _a0
      | `Sem (_a0,_a1,_a2) ->
          (self#loc _a0; self#class_str_item _a1; self#class_str_item _a2)
      | `Eq (_a0,_a1,_a2) -> (self#loc _a0; self#ctyp _a1; self#ctyp _a2)
      | `Inherit (_a0,_a1,_a2,_a3) ->
          (self#loc _a0;
           self#override_flag _a1;
           self#class_expr _a2;
           self#meta_option (fun self  -> self#alident) _a3)
      | `Initializer (_a0,_a1) -> (self#loc _a0; self#expr _a1)
      | `CrMth (_a0,_a1,_a2,_a3,_a4,_a5) ->
          (self#loc _a0;
           self#alident _a1;
           self#override_flag _a2;
           self#private_flag _a3;
           self#expr _a4;
           self#ctyp _a5)
      | `CrVal (_a0,_a1,_a2,_a3,_a4) ->
          (self#loc _a0;
           self#alident _a1;
           self#override_flag _a2;
           self#mutable_flag _a3;
           self#expr _a4)
      | `CrVir (_a0,_a1,_a2,_a3) ->
          (self#loc _a0;
           self#alident _a1;
           self#private_flag _a2;
           self#ctyp _a3)
      | `CrVvr (_a0,_a1,_a2,_a3) ->
          (self#loc _a0;
           self#alident _a1;
           self#mutable_flag _a2;
           self#ctyp _a3)
      | #ant as _a0 -> (self#ant _a0 :>'result)
    method fanloc_t : FanLoc.t -> 'result= self#unknown
    method fanutil_anti_cxt : FanUtil.anti_cxt -> 'result= self#unknown
  end
class map2 =
  object (self : 'self_type)
    inherit  mapbase2
    method loc : loc -> loc -> loc= fun _a0  _a1  -> self#fanloc_t _a0 _a1
    method ant : ant -> ant -> ant=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Ant (_a0,_a1),`Ant (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#fanutil_anti_cxt _a1 _b1 in `Ant (_a0, _a1)
    method literal : literal -> literal -> literal=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Chr (_a0,_a1),`Chr (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#string _a1 _b1 in `Chr (_a0, _a1)
        | (`Int (_a0,_a1),`Int (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#string _a1 _b1 in `Int (_a0, _a1)
        | (`Int32 (_a0,_a1),`Int32 (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#string _a1 _b1 in `Int32 (_a0, _a1)
        | (`Int64 (_a0,_a1),`Int64 (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#string _a1 _b1 in `Int64 (_a0, _a1)
        | (`Flo (_a0,_a1),`Flo (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#string _a1 _b1 in `Flo (_a0, _a1)
        | (`NativeInt (_a0,_a1),`NativeInt (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#string _a1 _b1 in `NativeInt (_a0, _a1)
        | (`Str (_a0,_a1),`Str (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#string _a1 _b1 in `Str (_a0, _a1)
        | (_,_) -> invalid_arg "map2 failure"
    method rec_flag : rec_flag -> rec_flag -> rec_flag=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Recursive _a0,`Recursive _b0) ->
            let _a0 = self#loc _a0 _b0 in `Recursive _a0
        | (`ReNil _a0,`ReNil _b0) -> let _a0 = self#loc _a0 _b0 in `ReNil _a0
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>rec_flag)
        | (_,_) -> invalid_arg "map2 failure"
    method direction_flag :
      direction_flag -> direction_flag -> direction_flag=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`To _a0,`To _b0) -> let _a0 = self#loc _a0 _b0 in `To _a0
        | (`Downto _a0,`Downto _b0) ->
            let _a0 = self#loc _a0 _b0 in `Downto _a0
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>direction_flag)
        | (_,_) -> invalid_arg "map2 failure"
    method mutable_flag : mutable_flag -> mutable_flag -> mutable_flag=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Mutable _a0,`Mutable _b0) ->
            let _a0 = self#loc _a0 _b0 in `Mutable _a0
        | (`MuNil _a0,`MuNil _b0) -> let _a0 = self#loc _a0 _b0 in `MuNil _a0
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>mutable_flag)
        | (_,_) -> invalid_arg "map2 failure"
    method private_flag : private_flag -> private_flag -> private_flag=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Private _a0,`Private _b0) ->
            let _a0 = self#loc _a0 _b0 in `Private _a0
        | (`PrNil _a0,`PrNil _b0) -> let _a0 = self#loc _a0 _b0 in `PrNil _a0
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>private_flag)
        | (_,_) -> invalid_arg "map2 failure"
    method virtual_flag : virtual_flag -> virtual_flag -> virtual_flag=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Virtual _a0,`Virtual _b0) ->
            let _a0 = self#loc _a0 _b0 in `Virtual _a0
        | (`ViNil _a0,`ViNil _b0) -> let _a0 = self#loc _a0 _b0 in `ViNil _a0
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>virtual_flag)
        | (_,_) -> invalid_arg "map2 failure"
    method override_flag : override_flag -> override_flag -> override_flag=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Override _a0,`Override _b0) ->
            let _a0 = self#loc _a0 _b0 in `Override _a0
        | (`OvNil _a0,`OvNil _b0) -> let _a0 = self#loc _a0 _b0 in `OvNil _a0
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>override_flag)
        | (_,_) -> invalid_arg "map2 failure"
    method row_var_flag : row_var_flag -> row_var_flag -> row_var_flag=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`RowVar _a0,`RowVar _b0) ->
            let _a0 = self#loc _a0 _b0 in `RowVar _a0
        | (`RvNil _a0,`RvNil _b0) -> let _a0 = self#loc _a0 _b0 in `RvNil _a0
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>row_var_flag)
        | (_,_) -> invalid_arg "map2 failure"
    method position_flag : position_flag -> position_flag -> position_flag=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Positive _a0,`Positive _b0) ->
            let _a0 = self#loc _a0 _b0 in `Positive _a0
        | (`Negative _a0,`Negative _b0) ->
            let _a0 = self#loc _a0 _b0 in `Negative _a0
        | (`Normal _a0,`Normal _b0) ->
            let _a0 = self#loc _a0 _b0 in `Normal _a0
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>position_flag)
        | (_,_) -> invalid_arg "map2 failure"
    method meta_bool : meta_bool -> meta_bool -> meta_bool=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`True _a0,`True _b0) -> let _a0 = self#loc _a0 _b0 in `True _a0
        | (`False _a0,`False _b0) -> let _a0 = self#loc _a0 _b0 in `False _a0
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>meta_bool)
        | (_,_) -> invalid_arg "map2 failure"
    method meta_option :
      'all_a0 'all_b0 .
        ('self_type -> 'all_a0 -> 'all_a0 -> 'all_b0) ->
          'all_a0 meta_option -> 'all_a0 meta_option -> 'all_b0 meta_option=
      fun mf_a  _a0  _b0  ->
        match (_a0, _b0) with
        | (`None _a0,`None _b0) -> let _a0 = self#loc _a0 _b0 in `None _a0
        | (`Some _a0,`Some _b0) -> let _a0 = mf_a self _a0 _b0 in `Some _a0
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>_ meta_option)
        | (_,_) -> invalid_arg "map2 failure"
    method meta_list :
      'all_a0 'all_b0 .
        ('self_type -> 'all_a0 -> 'all_a0 -> 'all_b0) ->
          'all_a0 meta_list -> 'all_a0 meta_list -> 'all_b0 meta_list=
      fun mf_a  _a0  _b0  ->
        match (_a0, _b0) with
        | (`LNil _a0,`LNil _b0) -> let _a0 = self#loc _a0 _b0 in `LNil _a0
        | (`LCons (_a0,_a1),`LCons (_b0,_b1)) ->
            let _a0 = mf_a self _a0 _b0 in
            let _a1 = self#meta_list mf_a _a1 _b1 in `LCons (_a0, _a1)
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>_ meta_list)
        | (_,_) -> invalid_arg "map2 failure"
    method alident : alident -> alident -> alident=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Lid (_a0,_a1),`Lid (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#string _a1 _b1 in `Lid (_a0, _a1)
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>alident)
        | (_,_) -> invalid_arg "map2 failure"
    method auident : auident -> auident -> auident=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Uid (_a0,_a1),`Uid (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#string _a1 _b1 in `Uid (_a0, _a1)
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>auident)
        | (_,_) -> invalid_arg "map2 failure"
    method aident : aident -> aident -> aident=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#alident as _a0),(#alident as _b0)) ->
            (self#alident _a0 _b0 : alident  :>aident)
        | ((#auident as _a0),(#auident as _b0)) ->
            (self#auident _a0 _b0 : auident  :>aident)
        | (_,_) -> invalid_arg "map2 failure"
    method astring : astring -> astring -> astring=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`C (_a0,_a1),`C (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#string _a1 _b1 in `C (_a0, _a1)
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>astring)
        | (_,_) -> invalid_arg "map2 failure"
    method ident : ident -> ident -> ident=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Dot (_a0,_a1,_a2),`Dot (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ident _a1 _b1 in
            let _a2 = self#ident _a2 _b2 in `Dot (_a0, _a1, _a2)
        | (`IdApp (_a0,_a1,_a2),`IdApp (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ident _a1 _b1 in
            let _a2 = self#ident _a2 _b2 in `IdApp (_a0, _a1, _a2)
        | ((#alident as _a0),(#alident as _b0)) ->
            (self#alident _a0 _b0 : alident  :>ident)
        | ((#auident as _a0),(#auident as _b0)) ->
            (self#auident _a0 _b0 : auident  :>ident)
        | (_,_) -> invalid_arg "map2 failure"
    method ctyp : ctyp -> ctyp -> ctyp=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> let _a0 = self#loc _a0 _b0 in `Nil _a0
        | (`Alias (_a0,_a1,_a2),`Alias (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `Alias (_a0, _a1, _a2)
        | (`Any _a0,`Any _b0) -> let _a0 = self#loc _a0 _b0 in `Any _a0
        | (`TyApp (_a0,_a1,_a2),`TyApp (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `TyApp (_a0, _a1, _a2)
        | (`Arrow (_a0,_a1,_a2),`Arrow (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `Arrow (_a0, _a1, _a2)
        | (`ClassPath (_a0,_a1),`ClassPath (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ident _a1 _b1 in `ClassPath (_a0, _a1)
        | (`Label (_a0,_a1,_a2),`Label (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#alident _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `Label (_a0, _a1, _a2)
        | (`Id (_a0,_a1),`Id (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ident _a1 _b1 in `Id (_a0, _a1)
        | (`TyMan (_a0,_a1,_a2),`TyMan (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `TyMan (_a0, _a1, _a2)
        | (`TyDcl (_a0,_a1,_a2,_a3,_a4),`TyDcl (_b0,_b1,_b2,_b3,_b4)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#alident _a1 _b1 in
            let _a2 = self#list (fun self  -> self#ctyp) _a2 _b2 in
            let _a3 = self#ctyp _a3 _b3 in
            let _a4 =
              self#list
                (fun self  _a0  _b0  ->
                   match (_a0, _b0) with
                   | ((_a0,_a1),(_b0,_b1)) ->
                       let _a0 = self#ctyp _a0 _b0 in
                       let _a1 = self#ctyp _a1 _b1 in (_a0, _a1)) _a4 _b4 in
            `TyDcl (_a0, _a1, _a2, _a3, _a4)
        | (`TyObj (_a0,_a1,_a2),`TyObj (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#row_var_flag _a2 _b2 in `TyObj (_a0, _a1, _a2)
        | (`TyOlb (_a0,_a1,_a2),`TyOlb (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#alident _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `TyOlb (_a0, _a1, _a2)
        | (`TyPol (_a0,_a1,_a2),`TyPol (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `TyPol (_a0, _a1, _a2)
        | (`TyTypePol (_a0,_a1,_a2),`TyTypePol (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `TyTypePol (_a0, _a1, _a2)
        | (`Quote (_a0,_a1,_a2),`Quote (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#position_flag _a1 _b1 in
            let _a2 = self#meta_option (fun self  -> self#alident) _a2 _b2 in
            `Quote (_a0, _a1, _a2)
        | (`TyRec (_a0,_a1),`TyRec (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in `TyRec (_a0, _a1)
        | (`TyCol (_a0,_a1,_a2),`TyCol (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `TyCol (_a0, _a1, _a2)
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `Sem (_a0, _a1, _a2)
        | (`Com (_a0,_a1,_a2),`Com (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `Com (_a0, _a1, _a2)
        | (`Sum (_a0,_a1),`Sum (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in `Sum (_a0, _a1)
        | (`Of (_a0,_a1,_a2),`Of (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `Of (_a0, _a1, _a2)
        | (`And (_a0,_a1,_a2),`And (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `And (_a0, _a1, _a2)
        | (`Or (_a0,_a1,_a2),`Or (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `Or (_a0, _a1, _a2)
        | (`Priv (_a0,_a1),`Priv (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in `Priv (_a0, _a1)
        | (`Mut (_a0,_a1),`Mut (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in `Mut (_a0, _a1)
        | (`Tup (_a0,_a1),`Tup (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in `Tup (_a0, _a1)
        | (`Sta (_a0,_a1,_a2),`Sta (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `Sta (_a0, _a1, _a2)
        | (`TyVrn (_a0,_a1),`TyVrn (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#astring _a1 _b1 in `TyVrn (_a0, _a1)
        | (`TyVrnEq (_a0,_a1),`TyVrnEq (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in `TyVrnEq (_a0, _a1)
        | (`TyVrnSup (_a0,_a1),`TyVrnSup (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in `TyVrnSup (_a0, _a1)
        | (`TyVrnInf (_a0,_a1),`TyVrnInf (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in `TyVrnInf (_a0, _a1)
        | (`TyVrnInfSup (_a0,_a1,_a2),`TyVrnInfSup (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `TyVrnInfSup (_a0, _a1, _a2)
        | (`Amp (_a0,_a1,_a2),`Amp (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `Amp (_a0, _a1, _a2)
        | (`TyOfAmp (_a0,_a1,_a2),`TyOfAmp (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `TyOfAmp (_a0, _a1, _a2)
        | (`Package (_a0,_a1),`Package (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#module_type _a1 _b1 in `Package (_a0, _a1)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 : ant  :>ctyp)
        | (_,_) -> invalid_arg "map2 failure"
    method patt : patt -> patt -> patt=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> let _a0 = self#loc _a0 _b0 in `Nil _a0
        | (`Id (_a0,_a1),`Id (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ident _a1 _b1 in `Id (_a0, _a1)
        | (`Alias (_a0,_a1,_a2),`Alias (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#patt _a1 _b1 in
            let _a2 = self#alident _a2 _b2 in `Alias (_a0, _a1, _a2)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 : ant  :>patt)
        | (`Any _a0,`Any _b0) -> let _a0 = self#loc _a0 _b0 in `Any _a0
        | (`PaApp (_a0,_a1,_a2),`PaApp (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#patt _a1 _b1 in
            let _a2 = self#patt _a2 _b2 in `PaApp (_a0, _a1, _a2)
        | (`Array (_a0,_a1),`Array (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#patt _a1 _b1 in `Array (_a0, _a1)
        | (`Com (_a0,_a1,_a2),`Com (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#patt _a1 _b1 in
            let _a2 = self#patt _a2 _b2 in `Com (_a0, _a1, _a2)
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#patt _a1 _b1 in
            let _a2 = self#patt _a2 _b2 in `Sem (_a0, _a1, _a2)
        | ((#literal as _a0),(#literal as _b0)) ->
            (self#literal _a0 _b0 : literal  :>patt)
        | (`Label (_a0,_a1,_a2),`Label (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#alident _a1 _b1 in
            let _a2 = self#patt _a2 _b2 in `Label (_a0, _a1, _a2)
        | (`PaOlbi (_a0,_a1,_a2,_a3),`PaOlbi (_b0,_b1,_b2,_b3)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#alident _a1 _b1 in
            let _a2 = self#patt _a2 _b2 in
            let _a3 = self#meta_option (fun self  -> self#expr) _a3 _b3 in
            `PaOlbi (_a0, _a1, _a2, _a3)
        | (`Or (_a0,_a1,_a2),`Or (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#patt _a1 _b1 in
            let _a2 = self#patt _a2 _b2 in `Or (_a0, _a1, _a2)
        | (`PaRng (_a0,_a1,_a2),`PaRng (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#patt _a1 _b1 in
            let _a2 = self#patt _a2 _b2 in `PaRng (_a0, _a1, _a2)
        | (`PaRec (_a0,_a1),`PaRec (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#patt _a1 _b1 in `PaRec (_a0, _a1)
        | (`PaEq (_a0,_a1,_a2),`PaEq (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ident _a1 _b1 in
            let _a2 = self#patt _a2 _b2 in `PaEq (_a0, _a1, _a2)
        | (`Tup (_a0,_a1),`Tup (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#patt _a1 _b1 in `Tup (_a0, _a1)
        | (`Constraint (_a0,_a1,_a2),`Constraint (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#patt _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `Constraint (_a0, _a1, _a2)
        | (`ClassPath (_a0,_a1),`ClassPath (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ident _a1 _b1 in `ClassPath (_a0, _a1)
        | (`PaVrn (_a0,_a1),`PaVrn (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#string _a1 _b1 in `PaVrn (_a0, _a1)
        | (`Lazy (_a0,_a1),`Lazy (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#patt _a1 _b1 in `Lazy (_a0, _a1)
        | (`ModuleUnpack (_a0,_a1,_a2),`ModuleUnpack (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#auident _a1 _b1 in
            let _a2 = self#meta_option (fun self  -> self#ctyp) _a2 _b2 in
            `ModuleUnpack (_a0, _a1, _a2)
        | (_,_) -> invalid_arg "map2 failure"
    method expr : expr -> expr -> expr=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> let _a0 = self#loc _a0 _b0 in `Nil _a0
        | (`Id (_a0,_a1),`Id (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ident _a1 _b1 in `Id (_a0, _a1)
        | (`Dot (_a0,_a1,_a2),`Dot (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in
            let _a2 = self#expr _a2 _b2 in `Dot (_a0, _a1, _a2)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 : ant  :>expr)
        | (`ExApp (_a0,_a1,_a2),`ExApp (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in
            let _a2 = self#expr _a2 _b2 in `ExApp (_a0, _a1, _a2)
        | (`ArrayDot (_a0,_a1,_a2),`ArrayDot (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in
            let _a2 = self#expr _a2 _b2 in `ArrayDot (_a0, _a1, _a2)
        | (`Array (_a0,_a1),`Array (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in `Array (_a0, _a1)
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in
            let _a2 = self#expr _a2 _b2 in `Sem (_a0, _a1, _a2)
        | (`ExAsf _a0,`ExAsf _b0) -> let _a0 = self#loc _a0 _b0 in `ExAsf _a0
        | (`ExAsr (_a0,_a1),`ExAsr (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in `ExAsr (_a0, _a1)
        | (`Assign (_a0,_a1,_a2),`Assign (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in
            let _a2 = self#expr _a2 _b2 in `Assign (_a0, _a1, _a2)
        | (`For (_a0,_a1,_a2,_a3,_a4,_a5),`For (_b0,_b1,_b2,_b3,_b4,_b5)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#alident _a1 _b1 in
            let _a2 = self#expr _a2 _b2 in
            let _a3 = self#expr _a3 _b3 in
            let _a4 = self#direction_flag _a4 _b4 in
            let _a5 = self#expr _a5 _b5 in
            `For (_a0, _a1, _a2, _a3, _a4, _a5)
        | (`Fun (_a0,_a1),`Fun (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#match_case _a1 _b1 in `Fun (_a0, _a1)
        | (`IfThenElse (_a0,_a1,_a2,_a3),`IfThenElse (_b0,_b1,_b2,_b3)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in
            let _a2 = self#expr _a2 _b2 in
            let _a3 = self#expr _a3 _b3 in `IfThenElse (_a0, _a1, _a2, _a3)
        | (`IfThen (_a0,_a1,_a2),`IfThen (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in
            let _a2 = self#expr _a2 _b2 in `IfThen (_a0, _a1, _a2)
        | ((#literal as _a0),(#literal as _b0)) ->
            (self#literal _a0 _b0 : literal  :>expr)
        | (`Label (_a0,_a1,_a2),`Label (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#alident _a1 _b1 in
            let _a2 = self#expr _a2 _b2 in `Label (_a0, _a1, _a2)
        | (`Lazy (_a0,_a1),`Lazy (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in `Lazy (_a0, _a1)
        | (`LetIn (_a0,_a1,_a2,_a3),`LetIn (_b0,_b1,_b2,_b3)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#rec_flag _a1 _b1 in
            let _a2 = self#binding _a2 _b2 in
            let _a3 = self#expr _a3 _b3 in `LetIn (_a0, _a1, _a2, _a3)
        | (`LetModule (_a0,_a1,_a2,_a3),`LetModule (_b0,_b1,_b2,_b3)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#auident _a1 _b1 in
            let _a2 = self#module_expr _a2 _b2 in
            let _a3 = self#expr _a3 _b3 in `LetModule (_a0, _a1, _a2, _a3)
        | (`Match (_a0,_a1,_a2),`Match (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in
            let _a2 = self#match_case _a2 _b2 in `Match (_a0, _a1, _a2)
        | (`New (_a0,_a1),`New (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ident _a1 _b1 in `New (_a0, _a1)
        | (`Obj (_a0,_a1,_a2),`Obj (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#patt _a1 _b1 in
            let _a2 = self#class_str_item _a2 _b2 in `Obj (_a0, _a1, _a2)
        | (`OptLabl (_a0,_a1,_a2),`OptLabl (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#alident _a1 _b1 in
            let _a2 = self#expr _a2 _b2 in `OptLabl (_a0, _a1, _a2)
        | (`OvrInst (_a0,_a1),`OvrInst (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#rec_binding _a1 _b1 in `OvrInst (_a0, _a1)
        | (`Record (_a0,_a1,_a2),`Record (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#rec_binding _a1 _b1 in
            let _a2 = self#expr _a2 _b2 in `Record (_a0, _a1, _a2)
        | (`Seq (_a0,_a1),`Seq (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in `Seq (_a0, _a1)
        | (`Send (_a0,_a1,_a2),`Send (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in
            let _a2 = self#alident _a2 _b2 in `Send (_a0, _a1, _a2)
        | (`StringDot (_a0,_a1,_a2),`StringDot (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in
            let _a2 = self#expr _a2 _b2 in `StringDot (_a0, _a1, _a2)
        | (`Try (_a0,_a1,_a2),`Try (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in
            let _a2 = self#match_case _a2 _b2 in `Try (_a0, _a1, _a2)
        | (`Tup (_a0,_a1),`Tup (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in `Tup (_a0, _a1)
        | (`Com (_a0,_a1,_a2),`Com (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in
            let _a2 = self#expr _a2 _b2 in `Com (_a0, _a1, _a2)
        | (`Constraint (_a0,_a1,_a2),`Constraint (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `Constraint (_a0, _a1, _a2)
        | (`Coercion (_a0,_a1,_a2,_a3),`Coercion (_b0,_b1,_b2,_b3)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in
            let _a3 = self#ctyp _a3 _b3 in `Coercion (_a0, _a1, _a2, _a3)
        | (`ExVrn (_a0,_a1),`ExVrn (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#string _a1 _b1 in `ExVrn (_a0, _a1)
        | (`While (_a0,_a1,_a2),`While (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in
            let _a2 = self#expr _a2 _b2 in `While (_a0, _a1, _a2)
        | (`LetOpen (_a0,_a1,_a2),`LetOpen (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ident _a1 _b1 in
            let _a2 = self#expr _a2 _b2 in `LetOpen (_a0, _a1, _a2)
        | (`LocalTypeFun (_a0,_a1,_a2),`LocalTypeFun (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#alident _a1 _b1 in
            let _a2 = self#expr _a2 _b2 in `LocalTypeFun (_a0, _a1, _a2)
        | (`Package_expr (_a0,_a1),`Package_expr (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#module_expr _a1 _b1 in `Package_expr (_a0, _a1)
        | (_,_) -> invalid_arg "map2 failure"
    method module_type : module_type -> module_type -> module_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> let _a0 = self#loc _a0 _b0 in `Nil _a0
        | (`Id (_a0,_a1),`Id (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ident _a1 _b1 in `Id (_a0, _a1)
        | (`MtFun (_a0,_a1,_a2,_a3),`MtFun (_b0,_b1,_b2,_b3)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#auident _a1 _b1 in
            let _a2 = self#module_type _a2 _b2 in
            let _a3 = self#module_type _a3 _b3 in `MtFun (_a0, _a1, _a2, _a3)
        | (`Sig (_a0,_a1),`Sig (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#sig_item _a1 _b1 in `Sig (_a0, _a1)
        | (`With (_a0,_a1,_a2),`With (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#module_type _a1 _b1 in
            let _a2 = self#with_constr _a2 _b2 in `With (_a0, _a1, _a2)
        | (`ModuleTypeOf (_a0,_a1),`ModuleTypeOf (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#module_expr _a1 _b1 in `ModuleTypeOf (_a0, _a1)
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>module_type)
        | (_,_) -> invalid_arg "map2 failure"
    method sig_item : sig_item -> sig_item -> sig_item=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> let _a0 = self#loc _a0 _b0 in `Nil _a0
        | (`Class (_a0,_a1),`Class (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#class_type _a1 _b1 in `Class (_a0, _a1)
        | (`ClassType (_a0,_a1),`ClassType (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#class_type _a1 _b1 in `ClassType (_a0, _a1)
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#sig_item _a1 _b1 in
            let _a2 = self#sig_item _a2 _b2 in `Sem (_a0, _a1, _a2)
        | (`Directive (_a0,_a1,_a2),`Directive (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#alident _a1 _b1 in
            let _a2 = self#expr _a2 _b2 in `Directive (_a0, _a1, _a2)
        | (`Exception (_a0,_a1),`Exception (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in `Exception (_a0, _a1)
        | (`External (_a0,_a1,_a2,_a3),`External (_b0,_b1,_b2,_b3)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#alident _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in
            let _a3 = self#meta_list (fun self  -> self#string) _a3 _b3 in
            `External (_a0, _a1, _a2, _a3)
        | (`Include (_a0,_a1),`Include (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#module_type _a1 _b1 in `Include (_a0, _a1)
        | (`Module (_a0,_a1,_a2),`Module (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#auident _a1 _b1 in
            let _a2 = self#module_type _a2 _b2 in `Module (_a0, _a1, _a2)
        | (`RecModule (_a0,_a1),`RecModule (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#module_binding _a1 _b1 in `RecModule (_a0, _a1)
        | (`ModuleType (_a0,_a1,_a2),`ModuleType (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#auident _a1 _b1 in
            let _a2 = self#module_type _a2 _b2 in `ModuleType (_a0, _a1, _a2)
        | (`Open (_a0,_a1),`Open (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ident _a1 _b1 in `Open (_a0, _a1)
        | (`Type (_a0,_a1),`Type (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in `Type (_a0, _a1)
        | (`Val (_a0,_a1,_a2),`Val (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#alident _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `Val (_a0, _a1, _a2)
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>sig_item)
        | (_,_) -> invalid_arg "map2 failure"
    method with_constr : with_constr -> with_constr -> with_constr=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> let _a0 = self#loc _a0 _b0 in `Nil _a0
        | (`TypeEq (_a0,_a1,_a2),`TypeEq (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `TypeEq (_a0, _a1, _a2)
        | (`ModuleEq (_a0,_a1,_a2),`ModuleEq (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ident _a1 _b1 in
            let _a2 = self#ident _a2 _b2 in `ModuleEq (_a0, _a1, _a2)
        | (`TypeSubst (_a0,_a1,_a2),`TypeSubst (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `TypeSubst (_a0, _a1, _a2)
        | (`ModuleSubst (_a0,_a1,_a2),`ModuleSubst (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ident _a1 _b1 in
            let _a2 = self#ident _a2 _b2 in `ModuleSubst (_a0, _a1, _a2)
        | (`And (_a0,_a1,_a2),`And (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#with_constr _a1 _b1 in
            let _a2 = self#with_constr _a2 _b2 in `And (_a0, _a1, _a2)
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>with_constr)
        | (_,_) -> invalid_arg "map2 failure"
    method binding : binding -> binding -> binding=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> let _a0 = self#loc _a0 _b0 in `Nil _a0
        | (`And (_a0,_a1,_a2),`And (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#binding _a1 _b1 in
            let _a2 = self#binding _a2 _b2 in `And (_a0, _a1, _a2)
        | (`Bind (_a0,_a1,_a2),`Bind (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#patt _a1 _b1 in
            let _a2 = self#expr _a2 _b2 in `Bind (_a0, _a1, _a2)
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>binding)
        | (_,_) -> invalid_arg "map2 failure"
    method rec_binding : rec_binding -> rec_binding -> rec_binding=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> let _a0 = self#loc _a0 _b0 in `Nil _a0
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#rec_binding _a1 _b1 in
            let _a2 = self#rec_binding _a2 _b2 in `Sem (_a0, _a1, _a2)
        | (`RecBind (_a0,_a1,_a2),`RecBind (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ident _a1 _b1 in
            let _a2 = self#expr _a2 _b2 in `RecBind (_a0, _a1, _a2)
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>rec_binding)
        | (_,_) -> invalid_arg "map2 failure"
    method module_binding :
      module_binding -> module_binding -> module_binding=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> let _a0 = self#loc _a0 _b0 in `Nil _a0
        | (`And (_a0,_a1,_a2),`And (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#module_binding _a1 _b1 in
            let _a2 = self#module_binding _a2 _b2 in `And (_a0, _a1, _a2)
        | (`ModuleBind (_a0,_a1,_a2,_a3),`ModuleBind (_b0,_b1,_b2,_b3)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#auident _a1 _b1 in
            let _a2 = self#module_type _a2 _b2 in
            let _a3 = self#module_expr _a3 _b3 in
            `ModuleBind (_a0, _a1, _a2, _a3)
        | (`Constraint (_a0,_a1,_a2),`Constraint (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#auident _a1 _b1 in
            let _a2 = self#module_type _a2 _b2 in `Constraint (_a0, _a1, _a2)
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>module_binding)
        | (_,_) -> invalid_arg "map2 failure"
    method match_case : match_case -> match_case -> match_case=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> let _a0 = self#loc _a0 _b0 in `Nil _a0
        | (`Or (_a0,_a1,_a2),`Or (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#match_case _a1 _b1 in
            let _a2 = self#match_case _a2 _b2 in `Or (_a0, _a1, _a2)
        | (`Case (_a0,_a1,_a2,_a3),`Case (_b0,_b1,_b2,_b3)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#patt _a1 _b1 in
            let _a2 = self#expr _a2 _b2 in
            let _a3 = self#expr _a3 _b3 in `Case (_a0, _a1, _a2, _a3)
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>match_case)
        | (_,_) -> invalid_arg "map2 failure"
    method module_expr : module_expr -> module_expr -> module_expr=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> let _a0 = self#loc _a0 _b0 in `Nil _a0
        | (`Id (_a0,_a1),`Id (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ident _a1 _b1 in `Id (_a0, _a1)
        | (`MeApp (_a0,_a1,_a2),`MeApp (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#module_expr _a1 _b1 in
            let _a2 = self#module_expr _a2 _b2 in `MeApp (_a0, _a1, _a2)
        | (`Functor (_a0,_a1,_a2,_a3),`Functor (_b0,_b1,_b2,_b3)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#auident _a1 _b1 in
            let _a2 = self#module_type _a2 _b2 in
            let _a3 = self#module_expr _a3 _b3 in
            `Functor (_a0, _a1, _a2, _a3)
        | (`Struct (_a0,_a1),`Struct (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#str_item _a1 _b1 in `Struct (_a0, _a1)
        | (`Constraint (_a0,_a1,_a2),`Constraint (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#module_expr _a1 _b1 in
            let _a2 = self#module_type _a2 _b2 in `Constraint (_a0, _a1, _a2)
        | (`PackageModule (_a0,_a1),`PackageModule (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in `PackageModule (_a0, _a1)
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>module_expr)
        | (_,_) -> invalid_arg "map2 failure"
    method str_item : str_item -> str_item -> str_item=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> let _a0 = self#loc _a0 _b0 in `Nil _a0
        | (`Class (_a0,_a1),`Class (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#class_expr _a1 _b1 in `Class (_a0, _a1)
        | (`ClassType (_a0,_a1),`ClassType (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#class_type _a1 _b1 in `ClassType (_a0, _a1)
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#str_item _a1 _b1 in
            let _a2 = self#str_item _a2 _b2 in `Sem (_a0, _a1, _a2)
        | (`Directive (_a0,_a1,_a2),`Directive (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#alident _a1 _b1 in
            let _a2 = self#expr _a2 _b2 in `Directive (_a0, _a1, _a2)
        | (`Exception (_a0,_a1),`Exception (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in `Exception (_a0, _a1)
        | (`StExp (_a0,_a1),`StExp (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in `StExp (_a0, _a1)
        | (`External (_a0,_a1,_a2,_a3),`External (_b0,_b1,_b2,_b3)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#alident _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in
            let _a3 = self#meta_list (fun self  -> self#string) _a3 _b3 in
            `External (_a0, _a1, _a2, _a3)
        | (`Include (_a0,_a1),`Include (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#module_expr _a1 _b1 in `Include (_a0, _a1)
        | (`Module (_a0,_a1,_a2),`Module (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#auident _a1 _b1 in
            let _a2 = self#module_expr _a2 _b2 in `Module (_a0, _a1, _a2)
        | (`RecModule (_a0,_a1),`RecModule (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#module_binding _a1 _b1 in `RecModule (_a0, _a1)
        | (`ModuleType (_a0,_a1,_a2),`ModuleType (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#auident _a1 _b1 in
            let _a2 = self#module_type _a2 _b2 in `ModuleType (_a0, _a1, _a2)
        | (`Open (_a0,_a1),`Open (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ident _a1 _b1 in `Open (_a0, _a1)
        | (`Type (_a0,_a1),`Type (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in `Type (_a0, _a1)
        | (`Value (_a0,_a1,_a2),`Value (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#rec_flag _a1 _b1 in
            let _a2 = self#binding _a2 _b2 in `Value (_a0, _a1, _a2)
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>str_item)
        | (_,_) -> invalid_arg "map2 failure"
    method class_type : class_type -> class_type -> class_type=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> let _a0 = self#loc _a0 _b0 in `Nil _a0
        | (`CtCon (_a0,_a1,_a2,_a3),`CtCon (_b0,_b1,_b2,_b3)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#virtual_flag _a1 _b1 in
            let _a2 = self#ident _a2 _b2 in
            let _a3 = self#ctyp _a3 _b3 in `CtCon (_a0, _a1, _a2, _a3)
        | (`CtFun (_a0,_a1,_a2),`CtFun (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#class_type _a2 _b2 in `CtFun (_a0, _a1, _a2)
        | (`CtSig (_a0,_a1,_a2),`CtSig (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#class_sig_item _a2 _b2 in `CtSig (_a0, _a1, _a2)
        | (`And (_a0,_a1,_a2),`And (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#class_type _a1 _b1 in
            let _a2 = self#class_type _a2 _b2 in `And (_a0, _a1, _a2)
        | (`CtCol (_a0,_a1,_a2),`CtCol (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#class_type _a1 _b1 in
            let _a2 = self#class_type _a2 _b2 in `CtCol (_a0, _a1, _a2)
        | (`CtEq (_a0,_a1,_a2),`CtEq (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#class_type _a1 _b1 in
            let _a2 = self#class_type _a2 _b2 in `CtEq (_a0, _a1, _a2)
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>class_type)
        | (_,_) -> invalid_arg "map2 failure"
    method class_sig_item :
      class_sig_item -> class_sig_item -> class_sig_item=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> let _a0 = self#loc _a0 _b0 in `Nil _a0
        | (`Eq (_a0,_a1,_a2),`Eq (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `Eq (_a0, _a1, _a2)
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#class_sig_item _a1 _b1 in
            let _a2 = self#class_sig_item _a2 _b2 in `Sem (_a0, _a1, _a2)
        | (`SigInherit (_a0,_a1),`SigInherit (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#class_type _a1 _b1 in `SigInherit (_a0, _a1)
        | (`Method (_a0,_a1,_a2,_a3),`Method (_b0,_b1,_b2,_b3)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#alident _a1 _b1 in
            let _a2 = self#private_flag _a2 _b2 in
            let _a3 = self#ctyp _a3 _b3 in `Method (_a0, _a1, _a2, _a3)
        | (`CgVal (_a0,_a1,_a2,_a3,_a4),`CgVal (_b0,_b1,_b2,_b3,_b4)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#alident _a1 _b1 in
            let _a2 = self#mutable_flag _a2 _b2 in
            let _a3 = self#virtual_flag _a3 _b3 in
            let _a4 = self#ctyp _a4 _b4 in `CgVal (_a0, _a1, _a2, _a3, _a4)
        | (`CgVir (_a0,_a1,_a2,_a3),`CgVir (_b0,_b1,_b2,_b3)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#alident _a1 _b1 in
            let _a2 = self#private_flag _a2 _b2 in
            let _a3 = self#ctyp _a3 _b3 in `CgVir (_a0, _a1, _a2, _a3)
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>class_sig_item)
        | (_,_) -> invalid_arg "map2 failure"
    method class_expr : class_expr -> class_expr -> class_expr=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> let _a0 = self#loc _a0 _b0 in `Nil _a0
        | (`CeApp (_a0,_a1,_a2),`CeApp (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#class_expr _a1 _b1 in
            let _a2 = self#expr _a2 _b2 in `CeApp (_a0, _a1, _a2)
        | (`CeCon (_a0,_a1,_a2,_a3),`CeCon (_b0,_b1,_b2,_b3)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#virtual_flag _a1 _b1 in
            let _a2 = self#ident _a2 _b2 in
            let _a3 = self#ctyp _a3 _b3 in `CeCon (_a0, _a1, _a2, _a3)
        | (`CeFun (_a0,_a1,_a2),`CeFun (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#patt _a1 _b1 in
            let _a2 = self#class_expr _a2 _b2 in `CeFun (_a0, _a1, _a2)
        | (`CeLet (_a0,_a1,_a2,_a3),`CeLet (_b0,_b1,_b2,_b3)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#rec_flag _a1 _b1 in
            let _a2 = self#binding _a2 _b2 in
            let _a3 = self#class_expr _a3 _b3 in `CeLet (_a0, _a1, _a2, _a3)
        | (`Obj (_a0,_a1,_a2),`Obj (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#patt _a1 _b1 in
            let _a2 = self#class_str_item _a2 _b2 in `Obj (_a0, _a1, _a2)
        | (`CeTyc (_a0,_a1,_a2),`CeTyc (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#class_expr _a1 _b1 in
            let _a2 = self#class_type _a2 _b2 in `CeTyc (_a0, _a1, _a2)
        | (`And (_a0,_a1,_a2),`And (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#class_expr _a1 _b1 in
            let _a2 = self#class_expr _a2 _b2 in `And (_a0, _a1, _a2)
        | (`Eq (_a0,_a1,_a2),`Eq (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#class_expr _a1 _b1 in
            let _a2 = self#class_expr _a2 _b2 in `Eq (_a0, _a1, _a2)
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>class_expr)
        | (_,_) -> invalid_arg "map2 failure"
    method class_str_item :
      class_str_item -> class_str_item -> class_str_item=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Nil _a0,`Nil _b0) -> let _a0 = self#loc _a0 _b0 in `Nil _a0
        | (`Sem (_a0,_a1,_a2),`Sem (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#class_str_item _a1 _b1 in
            let _a2 = self#class_str_item _a2 _b2 in `Sem (_a0, _a1, _a2)
        | (`Eq (_a0,_a1,_a2),`Eq (_b0,_b1,_b2)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#ctyp _a1 _b1 in
            let _a2 = self#ctyp _a2 _b2 in `Eq (_a0, _a1, _a2)
        | (`Inherit (_a0,_a1,_a2,_a3),`Inherit (_b0,_b1,_b2,_b3)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#override_flag _a1 _b1 in
            let _a2 = self#class_expr _a2 _b2 in
            let _a3 = self#meta_option (fun self  -> self#alident) _a3 _b3 in
            `Inherit (_a0, _a1, _a2, _a3)
        | (`Initializer (_a0,_a1),`Initializer (_b0,_b1)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#expr _a1 _b1 in `Initializer (_a0, _a1)
        | (`CrMth (_a0,_a1,_a2,_a3,_a4,_a5),`CrMth (_b0,_b1,_b2,_b3,_b4,_b5))
            ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#alident _a1 _b1 in
            let _a2 = self#override_flag _a2 _b2 in
            let _a3 = self#private_flag _a3 _b3 in
            let _a4 = self#expr _a4 _b4 in
            let _a5 = self#ctyp _a5 _b5 in
            `CrMth (_a0, _a1, _a2, _a3, _a4, _a5)
        | (`CrVal (_a0,_a1,_a2,_a3,_a4),`CrVal (_b0,_b1,_b2,_b3,_b4)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#alident _a1 _b1 in
            let _a2 = self#override_flag _a2 _b2 in
            let _a3 = self#mutable_flag _a3 _b3 in
            let _a4 = self#expr _a4 _b4 in `CrVal (_a0, _a1, _a2, _a3, _a4)
        | (`CrVir (_a0,_a1,_a2,_a3),`CrVir (_b0,_b1,_b2,_b3)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#alident _a1 _b1 in
            let _a2 = self#private_flag _a2 _b2 in
            let _a3 = self#ctyp _a3 _b3 in `CrVir (_a0, _a1, _a2, _a3)
        | (`CrVvr (_a0,_a1,_a2,_a3),`CrVvr (_b0,_b1,_b2,_b3)) ->
            let _a0 = self#loc _a0 _b0 in
            let _a1 = self#alident _a1 _b1 in
            let _a2 = self#mutable_flag _a2 _b2 in
            let _a3 = self#ctyp _a3 _b3 in `CrVvr (_a0, _a1, _a2, _a3)
        | ((#ant as _a0),(#ant as _b0)) ->
            (self#ant _a0 _b0 : ant  :>class_str_item)
        | (_,_) -> invalid_arg "map2 failure"
    method fanloc_t : FanLoc.t -> FanLoc.t -> FanLoc.t= self#unknown
    method fanutil_anti_cxt :
      FanUtil.anti_cxt -> FanUtil.anti_cxt -> FanUtil.anti_cxt= self#unknown
  end
module MExpr =
  struct
    let meta_int _loc i = `Int (_loc, (string_of_int i))
    let meta_int32 _loc i = `Int32 (_loc, (Int32.to_string i))
    let meta_int64 _loc i = `Int64 (_loc, (Int64.to_string i))
    let meta_nativeint _loc i = `NativeInt (_loc, (Nativeint.to_string i))
    let meta_float _loc i = `Flo (_loc, (FanUtil.float_repres i))
    let meta_string _loc i = `Str (_loc, (safe_string_escaped i))
    let meta_char _loc i = `Chr (_loc, (Char.escaped i))
    let meta_unit _loc _ = `Id (_loc, (`Uid (_loc, "()")))
    let meta_bool _loc =
      function
      | true  -> `Id (_loc, (`Lid (_loc, "true")))
      | false  -> `Id (_loc, (`Lid (_loc, "false")))
    let meta_ref mf_a _loc i =
      `Record
        (_loc,
          (`RecBind (_loc, (`Lid (_loc, "contents")), (mf_a _loc i.contents))),
          (`Nil _loc))
    let mklist loc =
      let rec loop top =
        function
        | [] -> `Id (loc, (`Uid (loc, "[]")))
        | e1::el ->
            let _loc = if top then loc else FanLoc.merge (loc_of e1) loc in
            `ExApp
              (_loc, (`ExApp (_loc, (`Id (_loc, (`Uid (_loc, "::")))), e1)),
                (loop false el)) in
      loop true
    let mkarray loc arr =
      let rec loop top =
        function
        | [] -> `Id (loc, (`Uid (loc, "[]")))
        | e1::el ->
            let _loc = if top then loc else FanLoc.merge (loc_of e1) loc in
            `Array (_loc, (`Sem (_loc, e1, (loop false el)))) in
      let items = arr |> Array.to_list in loop true items
    let meta_list mf_a _loc ls =
      mklist _loc (List.map (fun x  -> mf_a _loc x) ls)
    let meta_array mf_a _loc ls =
      mkarray _loc (Array.map (fun x  -> mf_a _loc x) ls)
    let meta_option mf_a _loc =
      function
      | None  -> `Id (_loc, (`Uid (_loc, "None")))
      | Some x ->
          `ExApp (_loc, (`Id (_loc, (`Uid (_loc, "Some")))), (mf_a _loc x))
    let meta_arrow (type t) (_mf_a : FanLoc.t -> 'a -> t)
      (_mf_b : FanLoc.t -> 'b -> t) (_loc : FanLoc.t) (_x : 'a -> 'b) =
      invalid_arg "meta_arrow not implemented"
  end
module MPatt =
  struct
    let meta_int _loc i = `Int (_loc, (string_of_int i))
    let meta_int32 _loc i = `Int32 (_loc, (Int32.to_string i))
    let meta_int64 _loc i = `Int64 (_loc, (Int64.to_string i))
    let meta_nativeint _loc i = `NativeInt (_loc, (Nativeint.to_string i))
    let meta_float _loc i = `Flo (_loc, (FanUtil.float_repres i))
    let meta_string _loc i = `Str (_loc, (safe_string_escaped i))
    let meta_char _loc i = `Chr (_loc, (Char.escaped i))
    let meta_unit _loc _ = `Id (_loc, (`Uid (_loc, "()")))
    let meta_bool _loc =
      function
      | true  -> `Id (_loc, (`Lid (_loc, "true")))
      | false  -> `Id (_loc, (`Lid (_loc, "false")))
    let meta_ref mf_a _loc i =
      `PaRec
        (_loc,
          (`PaEq (_loc, (`Lid (_loc, "contents")), (mf_a _loc i.contents))))
    let mklist loc =
      let rec loop top =
        function
        | [] -> `Id (loc, (`Uid (loc, "[]")))
        | e1::el ->
            let _loc = if top then loc else FanLoc.merge (loc_of e1) loc in
            `PaApp
              (_loc, (`PaApp (_loc, (`Id (_loc, (`Uid (_loc, "::")))), e1)),
                (loop false el)) in
      loop true
    let mkarray loc arr =
      let rec loop top =
        function
        | [] -> `Id (loc, (`Uid (loc, "[]")))
        | e1::el ->
            let _loc = if top then loc else FanLoc.merge (loc_of e1) loc in
            `Array (_loc, (`Sem (_loc, e1, (loop false el)))) in
      let items = arr |> Array.to_list in loop true items
    let meta_list mf_a _loc ls =
      mklist _loc (List.map (fun x  -> mf_a _loc x) ls)
    let meta_array mf_a _loc ls =
      mkarray _loc (Array.map (fun x  -> mf_a _loc x) ls)
    let meta_option mf_a _loc =
      function
      | None  -> `Id (_loc, (`Uid (_loc, "None")))
      | Some x ->
          `PaApp (_loc, (`Id (_loc, (`Uid (_loc, "Some")))), (mf_a _loc x))
    let meta_arrow (type t) (_mf_a : FanLoc.t -> 'a -> t)
      (_mf_b : FanLoc.t -> 'b -> t) (_loc : FanLoc.t) (_x : 'a -> 'b) =
      invalid_arg "meta_arrow not implemented"
  end
module Make(MetaLoc:META_LOC) =
  struct
    module Expr =
      struct
        open MExpr
        let meta_loc = MetaLoc.meta_loc_expr
        let meta_ant: 'loc -> ant -> 'result =
          fun _loc  (`Ant (_a0,_a1))  -> `Ant (_a0, _a1)
        let meta_literal: 'loc -> literal -> 'result =
          fun _loc  ->
            function
            | `Chr (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Chr")), (meta_loc _loc _a0))),
                    (meta_string _loc _a1))
            | `Int (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Int")), (meta_loc _loc _a0))),
                    (meta_string _loc _a1))
            | `Int32 (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Int32")), (meta_loc _loc _a0))),
                    (meta_string _loc _a1))
            | `Int64 (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Int64")), (meta_loc _loc _a0))),
                    (meta_string _loc _a1))
            | `Flo (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Flo")), (meta_loc _loc _a0))),
                    (meta_string _loc _a1))
            | `NativeInt (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "NativeInt")),
                         (meta_loc _loc _a0))), (meta_string _loc _a1))
            | `Str (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Str")), (meta_loc _loc _a0))),
                    (meta_string _loc _a1))
        let meta_rec_flag: 'loc -> rec_flag -> 'result =
          fun _loc  ->
            function
            | `Recursive _a0 ->
                `ExApp
                  (_loc, (`ExVrn (_loc, "Recursive")), (meta_loc _loc _a0))
            | `ReNil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "ReNil")), (meta_loc _loc _a0))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_direction_flag: 'loc -> direction_flag -> 'result =
          fun _loc  ->
            function
            | `To _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "To")), (meta_loc _loc _a0))
            | `Downto _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "Downto")), (meta_loc _loc _a0))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_mutable_flag: 'loc -> mutable_flag -> 'result =
          fun _loc  ->
            function
            | `Mutable _a0 ->
                `ExApp
                  (_loc, (`ExVrn (_loc, "Mutable")), (meta_loc _loc _a0))
            | `MuNil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "MuNil")), (meta_loc _loc _a0))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_private_flag: 'loc -> private_flag -> 'result =
          fun _loc  ->
            function
            | `Private _a0 ->
                `ExApp
                  (_loc, (`ExVrn (_loc, "Private")), (meta_loc _loc _a0))
            | `PrNil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "PrNil")), (meta_loc _loc _a0))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_virtual_flag: 'loc -> virtual_flag -> 'result =
          fun _loc  ->
            function
            | `Virtual _a0 ->
                `ExApp
                  (_loc, (`ExVrn (_loc, "Virtual")), (meta_loc _loc _a0))
            | `ViNil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "ViNil")), (meta_loc _loc _a0))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_override_flag: 'loc -> override_flag -> 'result =
          fun _loc  ->
            function
            | `Override _a0 ->
                `ExApp
                  (_loc, (`ExVrn (_loc, "Override")), (meta_loc _loc _a0))
            | `OvNil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "OvNil")), (meta_loc _loc _a0))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_row_var_flag: 'loc -> row_var_flag -> 'result =
          fun _loc  ->
            function
            | `RowVar _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "RowVar")), (meta_loc _loc _a0))
            | `RvNil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "RvNil")), (meta_loc _loc _a0))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_position_flag: 'loc -> position_flag -> 'result =
          fun _loc  ->
            function
            | `Positive _a0 ->
                `ExApp
                  (_loc, (`ExVrn (_loc, "Positive")), (meta_loc _loc _a0))
            | `Negative _a0 ->
                `ExApp
                  (_loc, (`ExVrn (_loc, "Negative")), (meta_loc _loc _a0))
            | `Normal _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "Normal")), (meta_loc _loc _a0))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_meta_bool: 'loc -> meta_bool -> 'result =
          fun _loc  ->
            function
            | `True _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "True")), (meta_loc _loc _a0))
            | `False _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "False")), (meta_loc _loc _a0))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_meta_option :
          'all_a0 .
            ('loc -> 'all_a0 -> 'result) ->
              'loc -> 'all_a0 meta_option -> 'result=
          fun mf_a  _loc  ->
            function
            | `None _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "None")), (meta_loc _loc _a0))
            | `Some _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "Some")), (mf_a _loc _a0))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let rec meta_meta_list :
          'all_a0 .
            ('loc -> 'all_a0 -> 'result) ->
              'loc -> 'all_a0 meta_list -> 'result=
          fun mf_a  _loc  ->
            function
            | `LNil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "LNil")), (meta_loc _loc _a0))
            | `LCons (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp (_loc, (`ExVrn (_loc, "LCons")), (mf_a _loc _a0))),
                    (meta_meta_list mf_a _loc _a1))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_alident: 'loc -> alident -> 'result =
          fun _loc  ->
            function
            | `Lid (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Lid")), (meta_loc _loc _a0))),
                    (meta_string _loc _a1))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_auident: 'loc -> auident -> 'result =
          fun _loc  ->
            function
            | `Uid (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Uid")), (meta_loc _loc _a0))),
                    (meta_string _loc _a1))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_aident: 'loc -> aident -> 'result =
          fun _loc  ->
            function
            | #alident as _a0 -> (meta_alident _loc _a0 :>'result)
            | #auident as _a0 -> (meta_auident _loc _a0 :>'result)
        let meta_astring: 'loc -> astring -> 'result =
          fun _loc  ->
            function
            | `C (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp (_loc, (`ExVrn (_loc, "C")), (meta_loc _loc _a0))),
                    (meta_string _loc _a1))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let rec meta_ident: 'loc -> ident -> 'result =
          fun _loc  ->
            function
            | `Dot (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Dot")),
                              (meta_loc _loc _a0))), (meta_ident _loc _a1))),
                    (meta_ident _loc _a2))
            | `IdApp (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "IdApp")),
                              (meta_loc _loc _a0))), (meta_ident _loc _a1))),
                    (meta_ident _loc _a2))
            | #alident as _a0 -> (meta_alident _loc _a0 :>'result)
            | #auident as _a0 -> (meta_auident _loc _a0 :>'result)
        let rec meta_ctyp: 'loc -> ctyp -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `Alias (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Alias")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Any _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "Any")), (meta_loc _loc _a0))
            | `TyApp (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "TyApp")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Arrow (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Arrow")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `ClassPath (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "ClassPath")),
                         (meta_loc _loc _a0))), (meta_ident _loc _a1))
            | `Label (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Label")),
                              (meta_loc _loc _a0))), (meta_alident _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Id (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Id")), (meta_loc _loc _a0))),
                    (meta_ident _loc _a1))
            | `TyMan (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "TyMan")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `TyDcl (_a0,_a1,_a2,_a3,_a4) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc,
                                   (`ExApp
                                      (_loc, (`ExVrn (_loc, "TyDcl")),
                                        (meta_loc _loc _a0))),
                                   (meta_alident _loc _a1))),
                              (meta_list meta_ctyp _loc _a2))),
                         (meta_ctyp _loc _a3))),
                    (meta_list
                       (fun _loc  (_a0,_a1)  ->
                          `Tup
                            (_loc,
                              (`Com
                                 (_loc, (meta_ctyp _loc _a0),
                                   (meta_ctyp _loc _a1))))) _loc _a4))
            | `TyObj (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "TyObj")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_row_var_flag _loc _a2))
            | `TyOlb (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "TyOlb")),
                              (meta_loc _loc _a0))), (meta_alident _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `TyPol (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "TyPol")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `TyTypePol (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "TyTypePol")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Quote (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Quote")),
                              (meta_loc _loc _a0))),
                         (meta_position_flag _loc _a1))),
                    (meta_meta_option meta_alident _loc _a2))
            | `TyRec (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "TyRec")), (meta_loc _loc _a0))),
                    (meta_ctyp _loc _a1))
            | `TyCol (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "TyCol")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Sem (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Sem")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Com (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Com")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Sum (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Sum")), (meta_loc _loc _a0))),
                    (meta_ctyp _loc _a1))
            | `Of (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Of")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `And (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "And")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Or (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Or")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Priv (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Priv")), (meta_loc _loc _a0))),
                    (meta_ctyp _loc _a1))
            | `Mut (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Mut")), (meta_loc _loc _a0))),
                    (meta_ctyp _loc _a1))
            | `Tup (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Tup")), (meta_loc _loc _a0))),
                    (meta_ctyp _loc _a1))
            | `Sta (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Sta")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `TyVrn (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "TyVrn")), (meta_loc _loc _a0))),
                    (meta_astring _loc _a1))
            | `TyVrnEq (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "TyVrnEq")),
                         (meta_loc _loc _a0))), (meta_ctyp _loc _a1))
            | `TyVrnSup (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "TyVrnSup")),
                         (meta_loc _loc _a0))), (meta_ctyp _loc _a1))
            | `TyVrnInf (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "TyVrnInf")),
                         (meta_loc _loc _a0))), (meta_ctyp _loc _a1))
            | `TyVrnInfSup (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "TyVrnInfSup")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Amp (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Amp")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `TyOfAmp (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "TyOfAmp")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Package (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Package")),
                         (meta_loc _loc _a0))), (meta_module_type _loc _a1))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_patt: 'loc -> patt -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `Id (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Id")), (meta_loc _loc _a0))),
                    (meta_ident _loc _a1))
            | `Alias (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Alias")),
                              (meta_loc _loc _a0))), (meta_patt _loc _a1))),
                    (meta_alident _loc _a2))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
            | `Any _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "Any")), (meta_loc _loc _a0))
            | `PaApp (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "PaApp")),
                              (meta_loc _loc _a0))), (meta_patt _loc _a1))),
                    (meta_patt _loc _a2))
            | `Array (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Array")), (meta_loc _loc _a0))),
                    (meta_patt _loc _a1))
            | `Com (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Com")),
                              (meta_loc _loc _a0))), (meta_patt _loc _a1))),
                    (meta_patt _loc _a2))
            | `Sem (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Sem")),
                              (meta_loc _loc _a0))), (meta_patt _loc _a1))),
                    (meta_patt _loc _a2))
            | #literal as _a0 -> (meta_literal _loc _a0 :>'result)
            | `Label (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Label")),
                              (meta_loc _loc _a0))), (meta_alident _loc _a1))),
                    (meta_patt _loc _a2))
            | `PaOlbi (_a0,_a1,_a2,_a3) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc, (`ExVrn (_loc, "PaOlbi")),
                                   (meta_loc _loc _a0))),
                              (meta_alident _loc _a1))),
                         (meta_patt _loc _a2))),
                    (meta_meta_option meta_expr _loc _a3))
            | `Or (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Or")),
                              (meta_loc _loc _a0))), (meta_patt _loc _a1))),
                    (meta_patt _loc _a2))
            | `PaRng (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "PaRng")),
                              (meta_loc _loc _a0))), (meta_patt _loc _a1))),
                    (meta_patt _loc _a2))
            | `PaRec (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "PaRec")), (meta_loc _loc _a0))),
                    (meta_patt _loc _a1))
            | `PaEq (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "PaEq")),
                              (meta_loc _loc _a0))), (meta_ident _loc _a1))),
                    (meta_patt _loc _a2))
            | `Tup (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Tup")), (meta_loc _loc _a0))),
                    (meta_patt _loc _a1))
            | `Constraint (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Constraint")),
                              (meta_loc _loc _a0))), (meta_patt _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `ClassPath (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "ClassPath")),
                         (meta_loc _loc _a0))), (meta_ident _loc _a1))
            | `PaVrn (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "PaVrn")), (meta_loc _loc _a0))),
                    (meta_string _loc _a1))
            | `Lazy (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Lazy")), (meta_loc _loc _a0))),
                    (meta_patt _loc _a1))
            | `ModuleUnpack (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "ModuleUnpack")),
                              (meta_loc _loc _a0))), (meta_auident _loc _a1))),
                    (meta_meta_option meta_ctyp _loc _a2))
        and meta_expr: 'loc -> expr -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `Id (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Id")), (meta_loc _loc _a0))),
                    (meta_ident _loc _a1))
            | `Dot (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Dot")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_expr _loc _a2))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
            | `ExApp (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "ExApp")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_expr _loc _a2))
            | `ArrayDot (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "ArrayDot")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_expr _loc _a2))
            | `Array (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Array")), (meta_loc _loc _a0))),
                    (meta_expr _loc _a1))
            | `Sem (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Sem")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_expr _loc _a2))
            | `ExAsf _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "ExAsf")), (meta_loc _loc _a0))
            | `ExAsr (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "ExAsr")), (meta_loc _loc _a0))),
                    (meta_expr _loc _a1))
            | `Assign (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Assign")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_expr _loc _a2))
            | `For (_a0,_a1,_a2,_a3,_a4,_a5) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc,
                                   (`ExApp
                                      (_loc,
                                        (`ExApp
                                           (_loc, (`ExVrn (_loc, "For")),
                                             (meta_loc _loc _a0))),
                                        (meta_alident _loc _a1))),
                                   (meta_expr _loc _a2))),
                              (meta_expr _loc _a3))),
                         (meta_direction_flag _loc _a4))),
                    (meta_expr _loc _a5))
            | `Fun (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Fun")), (meta_loc _loc _a0))),
                    (meta_match_case _loc _a1))
            | `IfThenElse (_a0,_a1,_a2,_a3) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc, (`ExVrn (_loc, "IfThenElse")),
                                   (meta_loc _loc _a0))),
                              (meta_expr _loc _a1))), (meta_expr _loc _a2))),
                    (meta_expr _loc _a3))
            | `IfThen (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "IfThen")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_expr _loc _a2))
            | #literal as _a0 -> (meta_literal _loc _a0 :>'result)
            | `Label (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Label")),
                              (meta_loc _loc _a0))), (meta_alident _loc _a1))),
                    (meta_expr _loc _a2))
            | `Lazy (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Lazy")), (meta_loc _loc _a0))),
                    (meta_expr _loc _a1))
            | `LetIn (_a0,_a1,_a2,_a3) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc, (`ExVrn (_loc, "LetIn")),
                                   (meta_loc _loc _a0))),
                              (meta_rec_flag _loc _a1))),
                         (meta_binding _loc _a2))), (meta_expr _loc _a3))
            | `LetModule (_a0,_a1,_a2,_a3) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc, (`ExVrn (_loc, "LetModule")),
                                   (meta_loc _loc _a0))),
                              (meta_auident _loc _a1))),
                         (meta_module_expr _loc _a2))), (meta_expr _loc _a3))
            | `Match (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Match")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_match_case _loc _a2))
            | `New (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "New")), (meta_loc _loc _a0))),
                    (meta_ident _loc _a1))
            | `Obj (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Obj")),
                              (meta_loc _loc _a0))), (meta_patt _loc _a1))),
                    (meta_class_str_item _loc _a2))
            | `OptLabl (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "OptLabl")),
                              (meta_loc _loc _a0))), (meta_alident _loc _a1))),
                    (meta_expr _loc _a2))
            | `OvrInst (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "OvrInst")),
                         (meta_loc _loc _a0))), (meta_rec_binding _loc _a1))
            | `Record (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Record")),
                              (meta_loc _loc _a0))),
                         (meta_rec_binding _loc _a1))), (meta_expr _loc _a2))
            | `Seq (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Seq")), (meta_loc _loc _a0))),
                    (meta_expr _loc _a1))
            | `Send (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Send")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_alident _loc _a2))
            | `StringDot (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "StringDot")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_expr _loc _a2))
            | `Try (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Try")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_match_case _loc _a2))
            | `Tup (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Tup")), (meta_loc _loc _a0))),
                    (meta_expr _loc _a1))
            | `Com (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Com")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_expr _loc _a2))
            | `Constraint (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Constraint")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Coercion (_a0,_a1,_a2,_a3) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc, (`ExVrn (_loc, "Coercion")),
                                   (meta_loc _loc _a0))),
                              (meta_expr _loc _a1))), (meta_ctyp _loc _a2))),
                    (meta_ctyp _loc _a3))
            | `ExVrn (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "ExVrn")), (meta_loc _loc _a0))),
                    (meta_string _loc _a1))
            | `While (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "While")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_expr _loc _a2))
            | `LetOpen (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "LetOpen")),
                              (meta_loc _loc _a0))), (meta_ident _loc _a1))),
                    (meta_expr _loc _a2))
            | `LocalTypeFun (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "LocalTypeFun")),
                              (meta_loc _loc _a0))), (meta_alident _loc _a1))),
                    (meta_expr _loc _a2))
            | `Package_expr (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Package_expr")),
                         (meta_loc _loc _a0))), (meta_module_expr _loc _a1))
        and meta_module_type: 'loc -> module_type -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `Id (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Id")), (meta_loc _loc _a0))),
                    (meta_ident _loc _a1))
            | `MtFun (_a0,_a1,_a2,_a3) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc, (`ExVrn (_loc, "MtFun")),
                                   (meta_loc _loc _a0))),
                              (meta_auident _loc _a1))),
                         (meta_module_type _loc _a2))),
                    (meta_module_type _loc _a3))
            | `Sig (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Sig")), (meta_loc _loc _a0))),
                    (meta_sig_item _loc _a1))
            | `With (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "With")),
                              (meta_loc _loc _a0))),
                         (meta_module_type _loc _a1))),
                    (meta_with_constr _loc _a2))
            | `ModuleTypeOf (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "ModuleTypeOf")),
                         (meta_loc _loc _a0))), (meta_module_expr _loc _a1))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_sig_item: 'loc -> sig_item -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `Class (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Class")), (meta_loc _loc _a0))),
                    (meta_class_type _loc _a1))
            | `ClassType (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "ClassType")),
                         (meta_loc _loc _a0))), (meta_class_type _loc _a1))
            | `Sem (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Sem")),
                              (meta_loc _loc _a0))),
                         (meta_sig_item _loc _a1))),
                    (meta_sig_item _loc _a2))
            | `Directive (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Directive")),
                              (meta_loc _loc _a0))), (meta_alident _loc _a1))),
                    (meta_expr _loc _a2))
            | `Exception (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Exception")),
                         (meta_loc _loc _a0))), (meta_ctyp _loc _a1))
            | `External (_a0,_a1,_a2,_a3) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc, (`ExVrn (_loc, "External")),
                                   (meta_loc _loc _a0))),
                              (meta_alident _loc _a1))),
                         (meta_ctyp _loc _a2))),
                    (meta_meta_list meta_string _loc _a3))
            | `Include (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Include")),
                         (meta_loc _loc _a0))), (meta_module_type _loc _a1))
            | `Module (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Module")),
                              (meta_loc _loc _a0))), (meta_auident _loc _a1))),
                    (meta_module_type _loc _a2))
            | `RecModule (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "RecModule")),
                         (meta_loc _loc _a0))),
                    (meta_module_binding _loc _a1))
            | `ModuleType (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "ModuleType")),
                              (meta_loc _loc _a0))), (meta_auident _loc _a1))),
                    (meta_module_type _loc _a2))
            | `Open (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Open")), (meta_loc _loc _a0))),
                    (meta_ident _loc _a1))
            | `Type (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Type")), (meta_loc _loc _a0))),
                    (meta_ctyp _loc _a1))
            | `Val (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Val")),
                              (meta_loc _loc _a0))), (meta_alident _loc _a1))),
                    (meta_ctyp _loc _a2))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_with_constr: 'loc -> with_constr -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `TypeEq (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "TypeEq")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `ModuleEq (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "ModuleEq")),
                              (meta_loc _loc _a0))), (meta_ident _loc _a1))),
                    (meta_ident _loc _a2))
            | `TypeSubst (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "TypeSubst")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `ModuleSubst (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "ModuleSubst")),
                              (meta_loc _loc _a0))), (meta_ident _loc _a1))),
                    (meta_ident _loc _a2))
            | `And (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "And")),
                              (meta_loc _loc _a0))),
                         (meta_with_constr _loc _a1))),
                    (meta_with_constr _loc _a2))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_binding: 'loc -> binding -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `And (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "And")),
                              (meta_loc _loc _a0))), (meta_binding _loc _a1))),
                    (meta_binding _loc _a2))
            | `Bind (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Bind")),
                              (meta_loc _loc _a0))), (meta_patt _loc _a1))),
                    (meta_expr _loc _a2))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_rec_binding: 'loc -> rec_binding -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `Sem (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Sem")),
                              (meta_loc _loc _a0))),
                         (meta_rec_binding _loc _a1))),
                    (meta_rec_binding _loc _a2))
            | `RecBind (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "RecBind")),
                              (meta_loc _loc _a0))), (meta_ident _loc _a1))),
                    (meta_expr _loc _a2))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_module_binding: 'loc -> module_binding -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `And (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "And")),
                              (meta_loc _loc _a0))),
                         (meta_module_binding _loc _a1))),
                    (meta_module_binding _loc _a2))
            | `ModuleBind (_a0,_a1,_a2,_a3) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc, (`ExVrn (_loc, "ModuleBind")),
                                   (meta_loc _loc _a0))),
                              (meta_auident _loc _a1))),
                         (meta_module_type _loc _a2))),
                    (meta_module_expr _loc _a3))
            | `Constraint (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Constraint")),
                              (meta_loc _loc _a0))), (meta_auident _loc _a1))),
                    (meta_module_type _loc _a2))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_match_case: 'loc -> match_case -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `Or (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Or")),
                              (meta_loc _loc _a0))),
                         (meta_match_case _loc _a1))),
                    (meta_match_case _loc _a2))
            | `Case (_a0,_a1,_a2,_a3) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc, (`ExVrn (_loc, "Case")),
                                   (meta_loc _loc _a0))),
                              (meta_patt _loc _a1))), (meta_expr _loc _a2))),
                    (meta_expr _loc _a3))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_module_expr: 'loc -> module_expr -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `Id (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Id")), (meta_loc _loc _a0))),
                    (meta_ident _loc _a1))
            | `MeApp (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "MeApp")),
                              (meta_loc _loc _a0))),
                         (meta_module_expr _loc _a1))),
                    (meta_module_expr _loc _a2))
            | `Functor (_a0,_a1,_a2,_a3) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc, (`ExVrn (_loc, "Functor")),
                                   (meta_loc _loc _a0))),
                              (meta_auident _loc _a1))),
                         (meta_module_type _loc _a2))),
                    (meta_module_expr _loc _a3))
            | `Struct (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Struct")), (meta_loc _loc _a0))),
                    (meta_str_item _loc _a1))
            | `Constraint (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Constraint")),
                              (meta_loc _loc _a0))),
                         (meta_module_expr _loc _a1))),
                    (meta_module_type _loc _a2))
            | `PackageModule (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "PackageModule")),
                         (meta_loc _loc _a0))), (meta_expr _loc _a1))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_str_item: 'loc -> str_item -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `Class (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Class")), (meta_loc _loc _a0))),
                    (meta_class_expr _loc _a1))
            | `ClassType (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "ClassType")),
                         (meta_loc _loc _a0))), (meta_class_type _loc _a1))
            | `Sem (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Sem")),
                              (meta_loc _loc _a0))),
                         (meta_str_item _loc _a1))),
                    (meta_str_item _loc _a2))
            | `Directive (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Directive")),
                              (meta_loc _loc _a0))), (meta_alident _loc _a1))),
                    (meta_expr _loc _a2))
            | `Exception (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Exception")),
                         (meta_loc _loc _a0))), (meta_ctyp _loc _a1))
            | `StExp (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "StExp")), (meta_loc _loc _a0))),
                    (meta_expr _loc _a1))
            | `External (_a0,_a1,_a2,_a3) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc, (`ExVrn (_loc, "External")),
                                   (meta_loc _loc _a0))),
                              (meta_alident _loc _a1))),
                         (meta_ctyp _loc _a2))),
                    (meta_meta_list meta_string _loc _a3))
            | `Include (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Include")),
                         (meta_loc _loc _a0))), (meta_module_expr _loc _a1))
            | `Module (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Module")),
                              (meta_loc _loc _a0))), (meta_auident _loc _a1))),
                    (meta_module_expr _loc _a2))
            | `RecModule (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "RecModule")),
                         (meta_loc _loc _a0))),
                    (meta_module_binding _loc _a1))
            | `ModuleType (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "ModuleType")),
                              (meta_loc _loc _a0))), (meta_auident _loc _a1))),
                    (meta_module_type _loc _a2))
            | `Open (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Open")), (meta_loc _loc _a0))),
                    (meta_ident _loc _a1))
            | `Type (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Type")), (meta_loc _loc _a0))),
                    (meta_ctyp _loc _a1))
            | `Value (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Value")),
                              (meta_loc _loc _a0))),
                         (meta_rec_flag _loc _a1))), (meta_binding _loc _a2))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_class_type: 'loc -> class_type -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `CtCon (_a0,_a1,_a2,_a3) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc, (`ExVrn (_loc, "CtCon")),
                                   (meta_loc _loc _a0))),
                              (meta_virtual_flag _loc _a1))),
                         (meta_ident _loc _a2))), (meta_ctyp _loc _a3))
            | `CtFun (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "CtFun")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_class_type _loc _a2))
            | `CtSig (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "CtSig")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_class_sig_item _loc _a2))
            | `And (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "And")),
                              (meta_loc _loc _a0))),
                         (meta_class_type _loc _a1))),
                    (meta_class_type _loc _a2))
            | `CtCol (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "CtCol")),
                              (meta_loc _loc _a0))),
                         (meta_class_type _loc _a1))),
                    (meta_class_type _loc _a2))
            | `CtEq (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "CtEq")),
                              (meta_loc _loc _a0))),
                         (meta_class_type _loc _a1))),
                    (meta_class_type _loc _a2))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_class_sig_item: 'loc -> class_sig_item -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `Eq (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Eq")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Sem (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Sem")),
                              (meta_loc _loc _a0))),
                         (meta_class_sig_item _loc _a1))),
                    (meta_class_sig_item _loc _a2))
            | `SigInherit (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "SigInherit")),
                         (meta_loc _loc _a0))), (meta_class_type _loc _a1))
            | `Method (_a0,_a1,_a2,_a3) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc, (`ExVrn (_loc, "Method")),
                                   (meta_loc _loc _a0))),
                              (meta_alident _loc _a1))),
                         (meta_private_flag _loc _a2))),
                    (meta_ctyp _loc _a3))
            | `CgVal (_a0,_a1,_a2,_a3,_a4) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc,
                                   (`ExApp
                                      (_loc, (`ExVrn (_loc, "CgVal")),
                                        (meta_loc _loc _a0))),
                                   (meta_alident _loc _a1))),
                              (meta_mutable_flag _loc _a2))),
                         (meta_virtual_flag _loc _a3))),
                    (meta_ctyp _loc _a4))
            | `CgVir (_a0,_a1,_a2,_a3) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc, (`ExVrn (_loc, "CgVir")),
                                   (meta_loc _loc _a0))),
                              (meta_alident _loc _a1))),
                         (meta_private_flag _loc _a2))),
                    (meta_ctyp _loc _a3))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_class_expr: 'loc -> class_expr -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `CeApp (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "CeApp")),
                              (meta_loc _loc _a0))),
                         (meta_class_expr _loc _a1))), (meta_expr _loc _a2))
            | `CeCon (_a0,_a1,_a2,_a3) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc, (`ExVrn (_loc, "CeCon")),
                                   (meta_loc _loc _a0))),
                              (meta_virtual_flag _loc _a1))),
                         (meta_ident _loc _a2))), (meta_ctyp _loc _a3))
            | `CeFun (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "CeFun")),
                              (meta_loc _loc _a0))), (meta_patt _loc _a1))),
                    (meta_class_expr _loc _a2))
            | `CeLet (_a0,_a1,_a2,_a3) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc, (`ExVrn (_loc, "CeLet")),
                                   (meta_loc _loc _a0))),
                              (meta_rec_flag _loc _a1))),
                         (meta_binding _loc _a2))),
                    (meta_class_expr _loc _a3))
            | `Obj (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Obj")),
                              (meta_loc _loc _a0))), (meta_patt _loc _a1))),
                    (meta_class_str_item _loc _a2))
            | `CeTyc (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "CeTyc")),
                              (meta_loc _loc _a0))),
                         (meta_class_expr _loc _a1))),
                    (meta_class_type _loc _a2))
            | `And (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "And")),
                              (meta_loc _loc _a0))),
                         (meta_class_expr _loc _a1))),
                    (meta_class_expr _loc _a2))
            | `Eq (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Eq")),
                              (meta_loc _loc _a0))),
                         (meta_class_expr _loc _a1))),
                    (meta_class_expr _loc _a2))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_class_str_item: 'loc -> class_str_item -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `ExApp (_loc, (`ExVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `Sem (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Sem")),
                              (meta_loc _loc _a0))),
                         (meta_class_str_item _loc _a1))),
                    (meta_class_str_item _loc _a2))
            | `Eq (_a0,_a1,_a2) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc, (`ExVrn (_loc, "Eq")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Inherit (_a0,_a1,_a2,_a3) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc, (`ExVrn (_loc, "Inherit")),
                                   (meta_loc _loc _a0))),
                              (meta_override_flag _loc _a1))),
                         (meta_class_expr _loc _a2))),
                    (meta_meta_option meta_alident _loc _a3))
            | `Initializer (_a0,_a1) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc, (`ExVrn (_loc, "Initializer")),
                         (meta_loc _loc _a0))), (meta_expr _loc _a1))
            | `CrMth (_a0,_a1,_a2,_a3,_a4,_a5) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc,
                                   (`ExApp
                                      (_loc,
                                        (`ExApp
                                           (_loc, (`ExVrn (_loc, "CrMth")),
                                             (meta_loc _loc _a0))),
                                        (meta_alident _loc _a1))),
                                   (meta_override_flag _loc _a2))),
                              (meta_private_flag _loc _a3))),
                         (meta_expr _loc _a4))), (meta_ctyp _loc _a5))
            | `CrVal (_a0,_a1,_a2,_a3,_a4) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc,
                                   (`ExApp
                                      (_loc, (`ExVrn (_loc, "CrVal")),
                                        (meta_loc _loc _a0))),
                                   (meta_alident _loc _a1))),
                              (meta_override_flag _loc _a2))),
                         (meta_mutable_flag _loc _a3))),
                    (meta_expr _loc _a4))
            | `CrVir (_a0,_a1,_a2,_a3) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc, (`ExVrn (_loc, "CrVir")),
                                   (meta_loc _loc _a0))),
                              (meta_alident _loc _a1))),
                         (meta_private_flag _loc _a2))),
                    (meta_ctyp _loc _a3))
            | `CrVvr (_a0,_a1,_a2,_a3) ->
                `ExApp
                  (_loc,
                    (`ExApp
                       (_loc,
                         (`ExApp
                            (_loc,
                              (`ExApp
                                 (_loc, (`ExVrn (_loc, "CrVvr")),
                                   (meta_loc _loc _a0))),
                              (meta_alident _loc _a1))),
                         (meta_mutable_flag _loc _a2))),
                    (meta_ctyp _loc _a3))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
      end
    module Patt =
      struct
        open MPatt
        let meta_loc = MetaLoc.meta_loc_patt
        let meta_ant: 'loc -> ant -> 'result =
          fun _loc  (`Ant (_a0,_a1))  -> `Ant (_a0, _a1)
        let meta_literal: 'loc -> literal -> 'result =
          fun _loc  ->
            function
            | `Chr (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Chr")), (meta_loc _loc _a0))),
                    (meta_string _loc _a1))
            | `Int (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Int")), (meta_loc _loc _a0))),
                    (meta_string _loc _a1))
            | `Int32 (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Int32")), (meta_loc _loc _a0))),
                    (meta_string _loc _a1))
            | `Int64 (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Int64")), (meta_loc _loc _a0))),
                    (meta_string _loc _a1))
            | `Flo (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Flo")), (meta_loc _loc _a0))),
                    (meta_string _loc _a1))
            | `NativeInt (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "NativeInt")),
                         (meta_loc _loc _a0))), (meta_string _loc _a1))
            | `Str (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Str")), (meta_loc _loc _a0))),
                    (meta_string _loc _a1))
        let meta_rec_flag: 'loc -> rec_flag -> 'result =
          fun _loc  ->
            function
            | `Recursive _a0 ->
                `PaApp
                  (_loc, (`PaVrn (_loc, "Recursive")), (meta_loc _loc _a0))
            | `ReNil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "ReNil")), (meta_loc _loc _a0))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_direction_flag: 'loc -> direction_flag -> 'result =
          fun _loc  ->
            function
            | `To _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "To")), (meta_loc _loc _a0))
            | `Downto _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "Downto")), (meta_loc _loc _a0))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_mutable_flag: 'loc -> mutable_flag -> 'result =
          fun _loc  ->
            function
            | `Mutable _a0 ->
                `PaApp
                  (_loc, (`PaVrn (_loc, "Mutable")), (meta_loc _loc _a0))
            | `MuNil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "MuNil")), (meta_loc _loc _a0))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_private_flag: 'loc -> private_flag -> 'result =
          fun _loc  ->
            function
            | `Private _a0 ->
                `PaApp
                  (_loc, (`PaVrn (_loc, "Private")), (meta_loc _loc _a0))
            | `PrNil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "PrNil")), (meta_loc _loc _a0))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_virtual_flag: 'loc -> virtual_flag -> 'result =
          fun _loc  ->
            function
            | `Virtual _a0 ->
                `PaApp
                  (_loc, (`PaVrn (_loc, "Virtual")), (meta_loc _loc _a0))
            | `ViNil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "ViNil")), (meta_loc _loc _a0))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_override_flag: 'loc -> override_flag -> 'result =
          fun _loc  ->
            function
            | `Override _a0 ->
                `PaApp
                  (_loc, (`PaVrn (_loc, "Override")), (meta_loc _loc _a0))
            | `OvNil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "OvNil")), (meta_loc _loc _a0))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_row_var_flag: 'loc -> row_var_flag -> 'result =
          fun _loc  ->
            function
            | `RowVar _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "RowVar")), (meta_loc _loc _a0))
            | `RvNil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "RvNil")), (meta_loc _loc _a0))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_position_flag: 'loc -> position_flag -> 'result =
          fun _loc  ->
            function
            | `Positive _a0 ->
                `PaApp
                  (_loc, (`PaVrn (_loc, "Positive")), (meta_loc _loc _a0))
            | `Negative _a0 ->
                `PaApp
                  (_loc, (`PaVrn (_loc, "Negative")), (meta_loc _loc _a0))
            | `Normal _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "Normal")), (meta_loc _loc _a0))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_meta_bool: 'loc -> meta_bool -> 'result =
          fun _loc  ->
            function
            | `True _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "True")), (meta_loc _loc _a0))
            | `False _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "False")), (meta_loc _loc _a0))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_meta_option :
          'all_a0 .
            ('loc -> 'all_a0 -> 'result) ->
              'loc -> 'all_a0 meta_option -> 'result=
          fun mf_a  _loc  ->
            function
            | `None _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "None")), (meta_loc _loc _a0))
            | `Some _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "Some")), (mf_a _loc _a0))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let rec meta_meta_list :
          'all_a0 .
            ('loc -> 'all_a0 -> 'result) ->
              'loc -> 'all_a0 meta_list -> 'result=
          fun mf_a  _loc  ->
            function
            | `LNil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "LNil")), (meta_loc _loc _a0))
            | `LCons (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp (_loc, (`PaVrn (_loc, "LCons")), (mf_a _loc _a0))),
                    (meta_meta_list mf_a _loc _a1))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_alident: 'loc -> alident -> 'result =
          fun _loc  ->
            function
            | `Lid (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Lid")), (meta_loc _loc _a0))),
                    (meta_string _loc _a1))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_auident: 'loc -> auident -> 'result =
          fun _loc  ->
            function
            | `Uid (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Uid")), (meta_loc _loc _a0))),
                    (meta_string _loc _a1))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let meta_aident: 'loc -> aident -> 'result =
          fun _loc  ->
            function
            | #alident as _a0 -> (meta_alident _loc _a0 :>'result)
            | #auident as _a0 -> (meta_auident _loc _a0 :>'result)
        let meta_astring: 'loc -> astring -> 'result =
          fun _loc  ->
            function
            | `C (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp (_loc, (`PaVrn (_loc, "C")), (meta_loc _loc _a0))),
                    (meta_string _loc _a1))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        let rec meta_ident: 'loc -> ident -> 'result =
          fun _loc  ->
            function
            | `Dot (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Dot")),
                              (meta_loc _loc _a0))), (meta_ident _loc _a1))),
                    (meta_ident _loc _a2))
            | `IdApp (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "IdApp")),
                              (meta_loc _loc _a0))), (meta_ident _loc _a1))),
                    (meta_ident _loc _a2))
            | #alident as _a0 -> (meta_alident _loc _a0 :>'result)
            | #auident as _a0 -> (meta_auident _loc _a0 :>'result)
        let rec meta_ctyp: 'loc -> ctyp -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `Alias (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Alias")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Any _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "Any")), (meta_loc _loc _a0))
            | `TyApp (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "TyApp")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Arrow (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Arrow")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `ClassPath (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "ClassPath")),
                         (meta_loc _loc _a0))), (meta_ident _loc _a1))
            | `Label (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Label")),
                              (meta_loc _loc _a0))), (meta_alident _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Id (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Id")), (meta_loc _loc _a0))),
                    (meta_ident _loc _a1))
            | `TyMan (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "TyMan")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `TyDcl (_a0,_a1,_a2,_a3,_a4) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc,
                                   (`PaApp
                                      (_loc, (`PaVrn (_loc, "TyDcl")),
                                        (meta_loc _loc _a0))),
                                   (meta_alident _loc _a1))),
                              (meta_list meta_ctyp _loc _a2))),
                         (meta_ctyp _loc _a3))),
                    (meta_list
                       (fun _loc  (_a0,_a1)  ->
                          `Tup
                            (_loc,
                              (`Com
                                 (_loc, (meta_ctyp _loc _a0),
                                   (meta_ctyp _loc _a1))))) _loc _a4))
            | `TyObj (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "TyObj")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_row_var_flag _loc _a2))
            | `TyOlb (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "TyOlb")),
                              (meta_loc _loc _a0))), (meta_alident _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `TyPol (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "TyPol")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `TyTypePol (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "TyTypePol")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Quote (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Quote")),
                              (meta_loc _loc _a0))),
                         (meta_position_flag _loc _a1))),
                    (meta_meta_option meta_alident _loc _a2))
            | `TyRec (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "TyRec")), (meta_loc _loc _a0))),
                    (meta_ctyp _loc _a1))
            | `TyCol (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "TyCol")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Sem (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Sem")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Com (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Com")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Sum (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Sum")), (meta_loc _loc _a0))),
                    (meta_ctyp _loc _a1))
            | `Of (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Of")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `And (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "And")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Or (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Or")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Priv (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Priv")), (meta_loc _loc _a0))),
                    (meta_ctyp _loc _a1))
            | `Mut (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Mut")), (meta_loc _loc _a0))),
                    (meta_ctyp _loc _a1))
            | `Tup (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Tup")), (meta_loc _loc _a0))),
                    (meta_ctyp _loc _a1))
            | `Sta (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Sta")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `TyVrn (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "TyVrn")), (meta_loc _loc _a0))),
                    (meta_astring _loc _a1))
            | `TyVrnEq (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "TyVrnEq")),
                         (meta_loc _loc _a0))), (meta_ctyp _loc _a1))
            | `TyVrnSup (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "TyVrnSup")),
                         (meta_loc _loc _a0))), (meta_ctyp _loc _a1))
            | `TyVrnInf (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "TyVrnInf")),
                         (meta_loc _loc _a0))), (meta_ctyp _loc _a1))
            | `TyVrnInfSup (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "TyVrnInfSup")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Amp (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Amp")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `TyOfAmp (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "TyOfAmp")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Package (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Package")),
                         (meta_loc _loc _a0))), (meta_module_type _loc _a1))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_patt: 'loc -> patt -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `Id (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Id")), (meta_loc _loc _a0))),
                    (meta_ident _loc _a1))
            | `Alias (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Alias")),
                              (meta_loc _loc _a0))), (meta_patt _loc _a1))),
                    (meta_alident _loc _a2))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
            | `Any _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "Any")), (meta_loc _loc _a0))
            | `PaApp (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "PaApp")),
                              (meta_loc _loc _a0))), (meta_patt _loc _a1))),
                    (meta_patt _loc _a2))
            | `Array (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Array")), (meta_loc _loc _a0))),
                    (meta_patt _loc _a1))
            | `Com (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Com")),
                              (meta_loc _loc _a0))), (meta_patt _loc _a1))),
                    (meta_patt _loc _a2))
            | `Sem (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Sem")),
                              (meta_loc _loc _a0))), (meta_patt _loc _a1))),
                    (meta_patt _loc _a2))
            | #literal as _a0 -> (meta_literal _loc _a0 :>'result)
            | `Label (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Label")),
                              (meta_loc _loc _a0))), (meta_alident _loc _a1))),
                    (meta_patt _loc _a2))
            | `PaOlbi (_a0,_a1,_a2,_a3) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc, (`PaVrn (_loc, "PaOlbi")),
                                   (meta_loc _loc _a0))),
                              (meta_alident _loc _a1))),
                         (meta_patt _loc _a2))),
                    (meta_meta_option meta_expr _loc _a3))
            | `Or (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Or")),
                              (meta_loc _loc _a0))), (meta_patt _loc _a1))),
                    (meta_patt _loc _a2))
            | `PaRng (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "PaRng")),
                              (meta_loc _loc _a0))), (meta_patt _loc _a1))),
                    (meta_patt _loc _a2))
            | `PaRec (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "PaRec")), (meta_loc _loc _a0))),
                    (meta_patt _loc _a1))
            | `PaEq (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "PaEq")),
                              (meta_loc _loc _a0))), (meta_ident _loc _a1))),
                    (meta_patt _loc _a2))
            | `Tup (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Tup")), (meta_loc _loc _a0))),
                    (meta_patt _loc _a1))
            | `Constraint (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Constraint")),
                              (meta_loc _loc _a0))), (meta_patt _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `ClassPath (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "ClassPath")),
                         (meta_loc _loc _a0))), (meta_ident _loc _a1))
            | `PaVrn (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "PaVrn")), (meta_loc _loc _a0))),
                    (meta_string _loc _a1))
            | `Lazy (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Lazy")), (meta_loc _loc _a0))),
                    (meta_patt _loc _a1))
            | `ModuleUnpack (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "ModuleUnpack")),
                              (meta_loc _loc _a0))), (meta_auident _loc _a1))),
                    (meta_meta_option meta_ctyp _loc _a2))
        and meta_expr: 'loc -> expr -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `Id (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Id")), (meta_loc _loc _a0))),
                    (meta_ident _loc _a1))
            | `Dot (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Dot")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_expr _loc _a2))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
            | `ExApp (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "ExApp")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_expr _loc _a2))
            | `ArrayDot (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "ArrayDot")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_expr _loc _a2))
            | `Array (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Array")), (meta_loc _loc _a0))),
                    (meta_expr _loc _a1))
            | `Sem (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Sem")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_expr _loc _a2))
            | `ExAsf _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "ExAsf")), (meta_loc _loc _a0))
            | `ExAsr (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "ExAsr")), (meta_loc _loc _a0))),
                    (meta_expr _loc _a1))
            | `Assign (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Assign")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_expr _loc _a2))
            | `For (_a0,_a1,_a2,_a3,_a4,_a5) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc,
                                   (`PaApp
                                      (_loc,
                                        (`PaApp
                                           (_loc, (`PaVrn (_loc, "For")),
                                             (meta_loc _loc _a0))),
                                        (meta_alident _loc _a1))),
                                   (meta_expr _loc _a2))),
                              (meta_expr _loc _a3))),
                         (meta_direction_flag _loc _a4))),
                    (meta_expr _loc _a5))
            | `Fun (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Fun")), (meta_loc _loc _a0))),
                    (meta_match_case _loc _a1))
            | `IfThenElse (_a0,_a1,_a2,_a3) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc, (`PaVrn (_loc, "IfThenElse")),
                                   (meta_loc _loc _a0))),
                              (meta_expr _loc _a1))), (meta_expr _loc _a2))),
                    (meta_expr _loc _a3))
            | `IfThen (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "IfThen")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_expr _loc _a2))
            | #literal as _a0 -> (meta_literal _loc _a0 :>'result)
            | `Label (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Label")),
                              (meta_loc _loc _a0))), (meta_alident _loc _a1))),
                    (meta_expr _loc _a2))
            | `Lazy (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Lazy")), (meta_loc _loc _a0))),
                    (meta_expr _loc _a1))
            | `LetIn (_a0,_a1,_a2,_a3) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc, (`PaVrn (_loc, "LetIn")),
                                   (meta_loc _loc _a0))),
                              (meta_rec_flag _loc _a1))),
                         (meta_binding _loc _a2))), (meta_expr _loc _a3))
            | `LetModule (_a0,_a1,_a2,_a3) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc, (`PaVrn (_loc, "LetModule")),
                                   (meta_loc _loc _a0))),
                              (meta_auident _loc _a1))),
                         (meta_module_expr _loc _a2))), (meta_expr _loc _a3))
            | `Match (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Match")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_match_case _loc _a2))
            | `New (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "New")), (meta_loc _loc _a0))),
                    (meta_ident _loc _a1))
            | `Obj (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Obj")),
                              (meta_loc _loc _a0))), (meta_patt _loc _a1))),
                    (meta_class_str_item _loc _a2))
            | `OptLabl (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "OptLabl")),
                              (meta_loc _loc _a0))), (meta_alident _loc _a1))),
                    (meta_expr _loc _a2))
            | `OvrInst (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "OvrInst")),
                         (meta_loc _loc _a0))), (meta_rec_binding _loc _a1))
            | `Record (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Record")),
                              (meta_loc _loc _a0))),
                         (meta_rec_binding _loc _a1))), (meta_expr _loc _a2))
            | `Seq (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Seq")), (meta_loc _loc _a0))),
                    (meta_expr _loc _a1))
            | `Send (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Send")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_alident _loc _a2))
            | `StringDot (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "StringDot")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_expr _loc _a2))
            | `Try (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Try")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_match_case _loc _a2))
            | `Tup (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Tup")), (meta_loc _loc _a0))),
                    (meta_expr _loc _a1))
            | `Com (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Com")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_expr _loc _a2))
            | `Constraint (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Constraint")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Coercion (_a0,_a1,_a2,_a3) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc, (`PaVrn (_loc, "Coercion")),
                                   (meta_loc _loc _a0))),
                              (meta_expr _loc _a1))), (meta_ctyp _loc _a2))),
                    (meta_ctyp _loc _a3))
            | `ExVrn (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "ExVrn")), (meta_loc _loc _a0))),
                    (meta_string _loc _a1))
            | `While (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "While")),
                              (meta_loc _loc _a0))), (meta_expr _loc _a1))),
                    (meta_expr _loc _a2))
            | `LetOpen (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "LetOpen")),
                              (meta_loc _loc _a0))), (meta_ident _loc _a1))),
                    (meta_expr _loc _a2))
            | `LocalTypeFun (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "LocalTypeFun")),
                              (meta_loc _loc _a0))), (meta_alident _loc _a1))),
                    (meta_expr _loc _a2))
            | `Package_expr (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Package_expr")),
                         (meta_loc _loc _a0))), (meta_module_expr _loc _a1))
        and meta_module_type: 'loc -> module_type -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `Id (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Id")), (meta_loc _loc _a0))),
                    (meta_ident _loc _a1))
            | `MtFun (_a0,_a1,_a2,_a3) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc, (`PaVrn (_loc, "MtFun")),
                                   (meta_loc _loc _a0))),
                              (meta_auident _loc _a1))),
                         (meta_module_type _loc _a2))),
                    (meta_module_type _loc _a3))
            | `Sig (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Sig")), (meta_loc _loc _a0))),
                    (meta_sig_item _loc _a1))
            | `With (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "With")),
                              (meta_loc _loc _a0))),
                         (meta_module_type _loc _a1))),
                    (meta_with_constr _loc _a2))
            | `ModuleTypeOf (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "ModuleTypeOf")),
                         (meta_loc _loc _a0))), (meta_module_expr _loc _a1))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_sig_item: 'loc -> sig_item -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `Class (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Class")), (meta_loc _loc _a0))),
                    (meta_class_type _loc _a1))
            | `ClassType (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "ClassType")),
                         (meta_loc _loc _a0))), (meta_class_type _loc _a1))
            | `Sem (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Sem")),
                              (meta_loc _loc _a0))),
                         (meta_sig_item _loc _a1))),
                    (meta_sig_item _loc _a2))
            | `Directive (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Directive")),
                              (meta_loc _loc _a0))), (meta_alident _loc _a1))),
                    (meta_expr _loc _a2))
            | `Exception (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Exception")),
                         (meta_loc _loc _a0))), (meta_ctyp _loc _a1))
            | `External (_a0,_a1,_a2,_a3) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc, (`PaVrn (_loc, "External")),
                                   (meta_loc _loc _a0))),
                              (meta_alident _loc _a1))),
                         (meta_ctyp _loc _a2))),
                    (meta_meta_list meta_string _loc _a3))
            | `Include (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Include")),
                         (meta_loc _loc _a0))), (meta_module_type _loc _a1))
            | `Module (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Module")),
                              (meta_loc _loc _a0))), (meta_auident _loc _a1))),
                    (meta_module_type _loc _a2))
            | `RecModule (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "RecModule")),
                         (meta_loc _loc _a0))),
                    (meta_module_binding _loc _a1))
            | `ModuleType (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "ModuleType")),
                              (meta_loc _loc _a0))), (meta_auident _loc _a1))),
                    (meta_module_type _loc _a2))
            | `Open (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Open")), (meta_loc _loc _a0))),
                    (meta_ident _loc _a1))
            | `Type (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Type")), (meta_loc _loc _a0))),
                    (meta_ctyp _loc _a1))
            | `Val (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Val")),
                              (meta_loc _loc _a0))), (meta_alident _loc _a1))),
                    (meta_ctyp _loc _a2))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_with_constr: 'loc -> with_constr -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `TypeEq (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "TypeEq")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `ModuleEq (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "ModuleEq")),
                              (meta_loc _loc _a0))), (meta_ident _loc _a1))),
                    (meta_ident _loc _a2))
            | `TypeSubst (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "TypeSubst")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `ModuleSubst (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "ModuleSubst")),
                              (meta_loc _loc _a0))), (meta_ident _loc _a1))),
                    (meta_ident _loc _a2))
            | `And (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "And")),
                              (meta_loc _loc _a0))),
                         (meta_with_constr _loc _a1))),
                    (meta_with_constr _loc _a2))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_binding: 'loc -> binding -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `And (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "And")),
                              (meta_loc _loc _a0))), (meta_binding _loc _a1))),
                    (meta_binding _loc _a2))
            | `Bind (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Bind")),
                              (meta_loc _loc _a0))), (meta_patt _loc _a1))),
                    (meta_expr _loc _a2))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_rec_binding: 'loc -> rec_binding -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `Sem (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Sem")),
                              (meta_loc _loc _a0))),
                         (meta_rec_binding _loc _a1))),
                    (meta_rec_binding _loc _a2))
            | `RecBind (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "RecBind")),
                              (meta_loc _loc _a0))), (meta_ident _loc _a1))),
                    (meta_expr _loc _a2))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_module_binding: 'loc -> module_binding -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `And (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "And")),
                              (meta_loc _loc _a0))),
                         (meta_module_binding _loc _a1))),
                    (meta_module_binding _loc _a2))
            | `ModuleBind (_a0,_a1,_a2,_a3) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc, (`PaVrn (_loc, "ModuleBind")),
                                   (meta_loc _loc _a0))),
                              (meta_auident _loc _a1))),
                         (meta_module_type _loc _a2))),
                    (meta_module_expr _loc _a3))
            | `Constraint (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Constraint")),
                              (meta_loc _loc _a0))), (meta_auident _loc _a1))),
                    (meta_module_type _loc _a2))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_match_case: 'loc -> match_case -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `Or (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Or")),
                              (meta_loc _loc _a0))),
                         (meta_match_case _loc _a1))),
                    (meta_match_case _loc _a2))
            | `Case (_a0,_a1,_a2,_a3) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc, (`PaVrn (_loc, "Case")),
                                   (meta_loc _loc _a0))),
                              (meta_patt _loc _a1))), (meta_expr _loc _a2))),
                    (meta_expr _loc _a3))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_module_expr: 'loc -> module_expr -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `Id (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Id")), (meta_loc _loc _a0))),
                    (meta_ident _loc _a1))
            | `MeApp (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "MeApp")),
                              (meta_loc _loc _a0))),
                         (meta_module_expr _loc _a1))),
                    (meta_module_expr _loc _a2))
            | `Functor (_a0,_a1,_a2,_a3) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc, (`PaVrn (_loc, "Functor")),
                                   (meta_loc _loc _a0))),
                              (meta_auident _loc _a1))),
                         (meta_module_type _loc _a2))),
                    (meta_module_expr _loc _a3))
            | `Struct (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Struct")), (meta_loc _loc _a0))),
                    (meta_str_item _loc _a1))
            | `Constraint (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Constraint")),
                              (meta_loc _loc _a0))),
                         (meta_module_expr _loc _a1))),
                    (meta_module_type _loc _a2))
            | `PackageModule (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "PackageModule")),
                         (meta_loc _loc _a0))), (meta_expr _loc _a1))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_str_item: 'loc -> str_item -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `Class (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Class")), (meta_loc _loc _a0))),
                    (meta_class_expr _loc _a1))
            | `ClassType (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "ClassType")),
                         (meta_loc _loc _a0))), (meta_class_type _loc _a1))
            | `Sem (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Sem")),
                              (meta_loc _loc _a0))),
                         (meta_str_item _loc _a1))),
                    (meta_str_item _loc _a2))
            | `Directive (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Directive")),
                              (meta_loc _loc _a0))), (meta_alident _loc _a1))),
                    (meta_expr _loc _a2))
            | `Exception (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Exception")),
                         (meta_loc _loc _a0))), (meta_ctyp _loc _a1))
            | `StExp (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "StExp")), (meta_loc _loc _a0))),
                    (meta_expr _loc _a1))
            | `External (_a0,_a1,_a2,_a3) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc, (`PaVrn (_loc, "External")),
                                   (meta_loc _loc _a0))),
                              (meta_alident _loc _a1))),
                         (meta_ctyp _loc _a2))),
                    (meta_meta_list meta_string _loc _a3))
            | `Include (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Include")),
                         (meta_loc _loc _a0))), (meta_module_expr _loc _a1))
            | `Module (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Module")),
                              (meta_loc _loc _a0))), (meta_auident _loc _a1))),
                    (meta_module_expr _loc _a2))
            | `RecModule (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "RecModule")),
                         (meta_loc _loc _a0))),
                    (meta_module_binding _loc _a1))
            | `ModuleType (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "ModuleType")),
                              (meta_loc _loc _a0))), (meta_auident _loc _a1))),
                    (meta_module_type _loc _a2))
            | `Open (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Open")), (meta_loc _loc _a0))),
                    (meta_ident _loc _a1))
            | `Type (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Type")), (meta_loc _loc _a0))),
                    (meta_ctyp _loc _a1))
            | `Value (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Value")),
                              (meta_loc _loc _a0))),
                         (meta_rec_flag _loc _a1))), (meta_binding _loc _a2))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_class_type: 'loc -> class_type -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `CtCon (_a0,_a1,_a2,_a3) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc, (`PaVrn (_loc, "CtCon")),
                                   (meta_loc _loc _a0))),
                              (meta_virtual_flag _loc _a1))),
                         (meta_ident _loc _a2))), (meta_ctyp _loc _a3))
            | `CtFun (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "CtFun")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_class_type _loc _a2))
            | `CtSig (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "CtSig")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_class_sig_item _loc _a2))
            | `And (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "And")),
                              (meta_loc _loc _a0))),
                         (meta_class_type _loc _a1))),
                    (meta_class_type _loc _a2))
            | `CtCol (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "CtCol")),
                              (meta_loc _loc _a0))),
                         (meta_class_type _loc _a1))),
                    (meta_class_type _loc _a2))
            | `CtEq (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "CtEq")),
                              (meta_loc _loc _a0))),
                         (meta_class_type _loc _a1))),
                    (meta_class_type _loc _a2))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_class_sig_item: 'loc -> class_sig_item -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `Eq (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Eq")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Sem (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Sem")),
                              (meta_loc _loc _a0))),
                         (meta_class_sig_item _loc _a1))),
                    (meta_class_sig_item _loc _a2))
            | `SigInherit (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "SigInherit")),
                         (meta_loc _loc _a0))), (meta_class_type _loc _a1))
            | `Method (_a0,_a1,_a2,_a3) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc, (`PaVrn (_loc, "Method")),
                                   (meta_loc _loc _a0))),
                              (meta_alident _loc _a1))),
                         (meta_private_flag _loc _a2))),
                    (meta_ctyp _loc _a3))
            | `CgVal (_a0,_a1,_a2,_a3,_a4) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc,
                                   (`PaApp
                                      (_loc, (`PaVrn (_loc, "CgVal")),
                                        (meta_loc _loc _a0))),
                                   (meta_alident _loc _a1))),
                              (meta_mutable_flag _loc _a2))),
                         (meta_virtual_flag _loc _a3))),
                    (meta_ctyp _loc _a4))
            | `CgVir (_a0,_a1,_a2,_a3) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc, (`PaVrn (_loc, "CgVir")),
                                   (meta_loc _loc _a0))),
                              (meta_alident _loc _a1))),
                         (meta_private_flag _loc _a2))),
                    (meta_ctyp _loc _a3))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_class_expr: 'loc -> class_expr -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `CeApp (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "CeApp")),
                              (meta_loc _loc _a0))),
                         (meta_class_expr _loc _a1))), (meta_expr _loc _a2))
            | `CeCon (_a0,_a1,_a2,_a3) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc, (`PaVrn (_loc, "CeCon")),
                                   (meta_loc _loc _a0))),
                              (meta_virtual_flag _loc _a1))),
                         (meta_ident _loc _a2))), (meta_ctyp _loc _a3))
            | `CeFun (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "CeFun")),
                              (meta_loc _loc _a0))), (meta_patt _loc _a1))),
                    (meta_class_expr _loc _a2))
            | `CeLet (_a0,_a1,_a2,_a3) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc, (`PaVrn (_loc, "CeLet")),
                                   (meta_loc _loc _a0))),
                              (meta_rec_flag _loc _a1))),
                         (meta_binding _loc _a2))),
                    (meta_class_expr _loc _a3))
            | `Obj (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Obj")),
                              (meta_loc _loc _a0))), (meta_patt _loc _a1))),
                    (meta_class_str_item _loc _a2))
            | `CeTyc (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "CeTyc")),
                              (meta_loc _loc _a0))),
                         (meta_class_expr _loc _a1))),
                    (meta_class_type _loc _a2))
            | `And (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "And")),
                              (meta_loc _loc _a0))),
                         (meta_class_expr _loc _a1))),
                    (meta_class_expr _loc _a2))
            | `Eq (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Eq")),
                              (meta_loc _loc _a0))),
                         (meta_class_expr _loc _a1))),
                    (meta_class_expr _loc _a2))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
        and meta_class_str_item: 'loc -> class_str_item -> 'result =
          fun _loc  ->
            function
            | `Nil _a0 ->
                `PaApp (_loc, (`PaVrn (_loc, "Nil")), (meta_loc _loc _a0))
            | `Sem (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Sem")),
                              (meta_loc _loc _a0))),
                         (meta_class_str_item _loc _a1))),
                    (meta_class_str_item _loc _a2))
            | `Eq (_a0,_a1,_a2) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc, (`PaVrn (_loc, "Eq")),
                              (meta_loc _loc _a0))), (meta_ctyp _loc _a1))),
                    (meta_ctyp _loc _a2))
            | `Inherit (_a0,_a1,_a2,_a3) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc, (`PaVrn (_loc, "Inherit")),
                                   (meta_loc _loc _a0))),
                              (meta_override_flag _loc _a1))),
                         (meta_class_expr _loc _a2))),
                    (meta_meta_option meta_alident _loc _a3))
            | `Initializer (_a0,_a1) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc, (`PaVrn (_loc, "Initializer")),
                         (meta_loc _loc _a0))), (meta_expr _loc _a1))
            | `CrMth (_a0,_a1,_a2,_a3,_a4,_a5) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc,
                                   (`PaApp
                                      (_loc,
                                        (`PaApp
                                           (_loc, (`PaVrn (_loc, "CrMth")),
                                             (meta_loc _loc _a0))),
                                        (meta_alident _loc _a1))),
                                   (meta_override_flag _loc _a2))),
                              (meta_private_flag _loc _a3))),
                         (meta_expr _loc _a4))), (meta_ctyp _loc _a5))
            | `CrVal (_a0,_a1,_a2,_a3,_a4) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc,
                                   (`PaApp
                                      (_loc, (`PaVrn (_loc, "CrVal")),
                                        (meta_loc _loc _a0))),
                                   (meta_alident _loc _a1))),
                              (meta_override_flag _loc _a2))),
                         (meta_mutable_flag _loc _a3))),
                    (meta_expr _loc _a4))
            | `CrVir (_a0,_a1,_a2,_a3) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc, (`PaVrn (_loc, "CrVir")),
                                   (meta_loc _loc _a0))),
                              (meta_alident _loc _a1))),
                         (meta_private_flag _loc _a2))),
                    (meta_ctyp _loc _a3))
            | `CrVvr (_a0,_a1,_a2,_a3) ->
                `PaApp
                  (_loc,
                    (`PaApp
                       (_loc,
                         (`PaApp
                            (_loc,
                              (`PaApp
                                 (_loc, (`PaVrn (_loc, "CrVvr")),
                                   (meta_loc _loc _a0))),
                              (meta_alident _loc _a1))),
                         (meta_mutable_flag _loc _a2))),
                    (meta_ctyp _loc _a3))
            | #ant as _a0 -> (meta_ant _loc _a0 :>'result)
      end
  end
let rec is_module_longident =
  function
  | `Dot (_loc,_,i) -> is_module_longident i
  | `IdApp (_loc,i1,i2) ->
      (is_module_longident i1) && (is_module_longident i2)
  | `Uid (_loc,_) -> true
  | _ -> false
let ident_of_expr =
  let error () =
    invalid_arg "ident_of_expr: this expression is not an identifier" in
  let rec self =
    function
    | `ExApp (_loc,e1,e2) -> `IdApp (_loc, (self e1), (self e2))
    | `Dot (_loc,e1,e2) -> `Dot (_loc, (self e1), (self e2))
    | `Id (_loc,`Lid (_,_)) -> error ()
    | `Id (_loc,i) -> if is_module_longident i then i else error ()
    | _ -> error () in
  function | `Id (_loc,i) -> i | `ExApp (_loc,_,_) -> error () | t -> self t
let ident_of_ctyp =
  let error () = invalid_arg "ident_of_ctyp: this type is not an identifier" in
  let rec self =
    function
    | `TyApp (_loc,t1,t2) -> `IdApp (_loc, (self t1), (self t2))
    | `Id (_loc,`Lid (_,_)) -> error ()
    | `Id (_loc,i) -> if is_module_longident i then i else error ()
    | _ -> error () in
  function | `Id (_loc,i) -> i | t -> self t
let ident_of_patt =
  let error () =
    invalid_arg "ident_of_patt: this pattern is not an identifier" in
  let rec self =
    function
    | `PaApp (_loc,p1,p2) -> `IdApp (_loc, (self p1), (self p2))
    | `Id (_loc,`Lid (_,_)) -> error ()
    | `Id (_loc,i) -> if is_module_longident i then i else error ()
    | _ -> error () in
  function | `Id (_loc,i) -> i | p -> self p
let rec is_irrefut_patt: patt -> bool =
  function
  | `Id (_loc,`Lid (_,_)) -> true
  | `Id (_loc,`Uid (_,"()")) -> true
  | `Any _loc -> true
  | `Nil _loc -> true
  | `Alias (_loc,x,_) -> is_irrefut_patt x
  | `PaRec (_loc,p) -> is_irrefut_patt p
  | `PaEq (_loc,_,p) -> is_irrefut_patt p
  | `Sem (_loc,p1,p2) -> (is_irrefut_patt p1) && (is_irrefut_patt p2)
  | `Com (_loc,p1,p2) -> (is_irrefut_patt p1) && (is_irrefut_patt p2)
  | `Or (_loc,p1,p2) -> (is_irrefut_patt p1) && (is_irrefut_patt p2)
  | `PaApp (_loc,p1,p2) -> (is_irrefut_patt p1) && (is_irrefut_patt p2)
  | `Constraint (_loc,p,_) -> is_irrefut_patt p
  | `Tup (_loc,pl) -> is_irrefut_patt pl
  | `PaOlbi (_loc,_,p,_) -> is_irrefut_patt p
  | `Label (_loc,_,`Nil _) -> true
  | `Label (_loc,_,p) -> is_irrefut_patt p
  | `Lazy (_loc,p) -> is_irrefut_patt p
  | `Id (_loc,_) -> false
  | `ModuleUnpack (_loc,_,_) -> true
  | `PaVrn (_loc,_)|`Str (_loc,_)|`PaRng (_loc,_,_)|`Flo (_loc,_)
    |`NativeInt (_loc,_)|`Int64 (_loc,_)|`Int32 (_loc,_)|`Int (_loc,_)
    |`Chr (_loc,_)|`ClassPath (_loc,_)|`Array (_loc,_)|`Ant (_loc,_) -> false
let rec is_constructor =
  function
  | `Dot (_loc,_,i) -> is_constructor i
  | `Uid (_loc,_) -> true
  | `Lid (_loc,_)|`IdApp (_loc,_,_) -> false
  | `Ant (_loc,_) -> assert false
let is_patt_constructor =
  function
  | `Id (_loc,i) -> is_constructor i
  | `PaVrn (_loc,_) -> true
  | _ -> false
let rec is_expr_constructor =
  function
  | `Id (_loc,i) -> is_constructor i
  | `Dot (_loc,e1,e2) -> (is_expr_constructor e1) && (is_expr_constructor e2)
  | `ExVrn (_loc,_) -> true
  | _ -> false
let ghost = FanLoc.ghost
let rec or_of_list =
  function
  | [] -> `Nil ghost
  | t::[] -> t
  | t::ts -> let _loc = loc_of t in `Or (_loc, t, (or_of_list ts))
let rec and_of_list =
  function
  | [] -> `Nil ghost
  | t::[] -> t
  | t::ts -> let _loc = loc_of t in `And (_loc, t, (and_of_list ts))
let rec sem_of_list =
  function
  | [] -> `Nil ghost
  | t::[] -> t
  | t::ts -> let _loc = loc_of t in `Sem (_loc, t, (sem_of_list ts))
let rec com_of_list =
  function
  | [] -> `Nil ghost
  | t::[] -> t
  | t::ts -> let _loc = loc_of t in `Com (_loc, t, (com_of_list ts))
let rec sta_of_list =
  function
  | [] -> `Nil ghost
  | t::[] -> t
  | t::ts -> let _loc = loc_of t in `Sta (_loc, t, (sta_of_list ts))
let rec amp_of_list =
  function
  | [] -> `Nil ghost
  | t::[] -> t
  | t::ts -> let _loc = loc_of t in `Amp (_loc, t, (amp_of_list ts))
let tuple_com y =
  match y with
  | [] -> failwith "tuple_com empty"
  | x::[] -> x
  | x::_ ->
      let a = loc_of x in
      let b = loc_of (List.last y) in
      let _loc = FanLoc.merge a b in `Tup (_loc, (com_of_list y))
let rec tyApp_of_list =
  function
  | [] -> `Nil ghost
  | t::[] -> t
  | t::ts -> let _loc = loc_of t in `TyApp (_loc, t, (tyApp_of_list ts))
let tyVarApp_of_list (_loc,ls) =
  let aux =
    function
    | [] -> `Nil ghost
    | t::[] -> `Quote (_loc, (`Normal _loc), (`Some t))
    | t::ts ->
        List.fold_left
          (fun x  y  ->
             `TyApp (_loc, x, (`Quote (_loc, (`Normal _loc), (`Some y)))))
          (`Quote (_loc, (`Normal _loc), (`Some t))) ts in
  aux ls
let rec idAcc_of_list =
  function
  | [] -> assert false
  | i::[] -> i
  | i::is -> let _loc = loc_of i in `Dot (_loc, i, (idAcc_of_list is))
let rec idApp_of_list =
  function
  | [] -> assert false
  | i::[] -> i
  | i::is -> let _loc = loc_of i in `IdApp (_loc, i, (idApp_of_list is))
let rec meApp_of_list =
  function
  | [] -> assert false
  | x::[] -> x
  | x::xs -> let _loc = loc_of x in `MeApp (_loc, x, (meApp_of_list xs))
let exApp_of_list =
  function
  | [] -> `Nil ghost
  | t::[] -> t
  | t::ts ->
      List.fold_left
        (fun x  y  -> let _loc = loc_of x in `ExApp (_loc, x, y)) t ts
let ty_of_stl =
  function
  | (_loc,s,[]) -> `Id (_loc, (`Uid (_loc, s)))
  | (_loc,s,tl) ->
      `Of (_loc, (`Id (_loc, (`Uid (_loc, s)))), (and_of_list tl))
let ty_of_sbt =
  function
  | (_loc,s,true ,t) ->
      `TyCol (_loc, (`Id (_loc, (`Lid (_loc, s)))), (`Mut (_loc, t)))
  | (_loc,s,false ,t) -> `TyCol (_loc, (`Id (_loc, (`Lid (_loc, s)))), t)
let bi_of_pe (p,e) = let _loc = loc_of p in `Bind (_loc, p, e)
let sum_type_of_list l = or_of_list (List.map ty_of_stl l)
let record_type_of_list l = sem_of_list (List.map ty_of_sbt l)
let binding_of_pel l = and_of_list (List.map bi_of_pe l)
let rec list_of_amp x acc =
  match x with
  | `And (_,x,y) -> list_of_amp x (list_of_amp y acc)
  | _ -> x :: acc
let rec list_of_amp' x acc =
  match x with
  | `And (_,x,y) -> list_of_amp' x (list_of_amp' y acc)
  | `Nil _ -> acc
  | _ -> x :: acc
let rec list_of_and x acc =
  match x with
  | `And (_,x,y) -> list_of_and x (list_of_and y acc)
  | _ -> x :: acc
let rec list_of_and' x acc =
  match x with
  | `And (_,x,y) -> list_of_and' x (list_of_and' y acc)
  | `Nil _ -> acc
  | _ -> x :: acc
let rec list_of_com x acc =
  match x with
  | `Com (_,x,y) -> list_of_com x (list_of_com y acc)
  | _ -> x :: acc
let rec list_of_com' x acc =
  match x with
  | `Com (_,x,y) -> list_of_com' x (list_of_com' y acc)
  | `Nil _ -> acc
  | _ -> x :: acc
let rec list_of_star' x acc =
  match x with
  | `Sta (_,x,y) -> list_of_star' x (list_of_star' y acc)
  | `Nil _ -> acc
  | _ -> x :: acc
let rec list_of_star x acc =
  match x with
  | `Sta (_,x,y) -> list_of_star x (list_of_star y acc)
  | _ -> x :: acc
let rec list_of_or x acc =
  match x with
  | `Or (_,x,y) -> list_of_or x (list_of_or y acc)
  | _ -> x :: acc
let rec list_of_or' x acc =
  match x with
  | `Or (_,x,y) -> list_of_or x (list_of_or' y acc)
  | `Nil _ -> acc
  | _ -> x :: acc
let rec list_of_sem x acc =
  match x with
  | `Sem (_,x,y) -> list_of_sem x (list_of_sem y acc)
  | _ -> x :: acc
let rec list_of_sem' x acc =
  match x with
  | `Sem (_,x,y) -> list_of_sem' x (list_of_sem' y acc)
  | `Nil _ -> acc
  | _ -> x :: acc
let sem a b =
  let _loc = FanLoc.merge (loc_of a) (loc_of b) in `Sem (_loc, a, b)
let com a b =
  let _loc = FanLoc.merge (loc_of a) (loc_of b) in `Com (_loc, a, b)
let rec list_of_ctyp_app (x : ctyp) (acc : ctyp list) =
  (match x with
   | `TyApp (_loc,t1,t2) -> list_of_ctyp_app t1 (list_of_ctyp_app t2 acc)
   | `Nil _loc -> acc
   | x -> x :: acc : ctyp list )
let rec list_of_module_expr x acc =
  match x with
  | `MeApp (_loc,x,y) -> list_of_module_expr x (list_of_module_expr y acc)
  | x -> x :: acc
let rec list_of_ident x acc =
  match x with
  | `Dot (_loc,x,y)|`IdApp (_loc,x,y) ->
      list_of_ident x (list_of_ident y acc)
  | x -> x :: acc
let map_expr f =
  object  inherit  map as super method! expr x = f (super#expr x) end
let map_patt f =
  object  inherit  map as super method! patt x = f (super#patt x) end
let map_ctyp f =
  object  inherit  map as super method! ctyp x = f (super#ctyp x) end
let map_str_item f =
  object  inherit  map as super method! str_item x = f (super#str_item x) end
let map_sig_item f =
  object  inherit  map as super method! sig_item x = f (super#sig_item x) end
let map_loc f =
  object  inherit  map as super method! loc x = f (super#loc x) end
class clean_ast =
  object 
    inherit  map as super
    method! with_constr wc =
      match super#with_constr wc with
      | `And (_loc,`Nil _l,wc)|`And (_loc,wc,`Nil _l) -> wc
      | wc -> wc
    method! expr e =
      match super#expr e with
      | `LetIn (_loc,_,`Nil _l,e)|`Record (_loc,`Nil _l,e)
        |`Com (_loc,`Nil _l,e)|`Com (_loc,e,`Nil _l)|`Sem (_loc,`Nil _l,e)
        |`Sem (_loc,e,`Nil _l) -> e
      | e -> e
    method! patt p =
      match super#patt p with
      | `Or (_loc,`Nil _l,p)|`Or (_loc,p,`Nil _l)|`Com (_loc,`Nil _l,p)
        |`Com (_loc,p,`Nil _l)|`Sem (_loc,`Nil _l,p)|`Sem (_loc,p,`Nil _l) ->
          p
      | p -> p
    method! match_case mc =
      match super#match_case mc with
      | `Or (_loc,`Nil _l,mc)|`Or (_loc,mc,`Nil _l) -> mc
      | mc -> mc
    method! binding bi =
      match super#binding bi with
      | `And (_loc,`Nil _l,bi)|`And (_loc,bi,`Nil _l) -> bi
      | bi -> bi
    method! rec_binding rb =
      match super#rec_binding rb with
      | `Sem (_loc,`Nil _l,bi)|`Sem (_loc,bi,`Nil _l) -> bi
      | bi -> bi
    method! module_binding mb =
      match super#module_binding mb with
      | `And (_loc,`Nil _l,mb)|`And (_loc,mb,`Nil _l) -> mb
      | mb -> mb
    method! ctyp t =
      match super#ctyp t with
      | `TyPol (_loc,`Nil _l,t)|`Alias (_loc,`Nil _l,t)
        |`Alias (_loc,t,`Nil _l)|`Arrow (_loc,t,`Nil _l)
        |`Arrow (_loc,`Nil _l,t)|`Or (_loc,`Nil _l,t)|`Or (_loc,t,`Nil _l)
        |`Of (_loc,t,`Nil _l)|`And (_loc,`Nil _l,t)|`And (_loc,t,`Nil _l)
        |`Sem (_loc,t,`Nil _l)|`Sem (_loc,`Nil _l,t)|`Com (_loc,`Nil _l,t)
        |`Com (_loc,t,`Nil _l)|`Amp (_loc,t,`Nil _l)|`Amp (_loc,`Nil _l,t)
        |`Sta (_loc,`Nil _l,t)|`Sta (_loc,t,`Nil _l) -> t
      | t -> t
    method! sig_item sg =
      match super#sig_item sg with
      | `Sem (_loc,`Nil _l,sg)|`Sem (_loc,sg,`Nil _l) -> sg
      | `Type (_loc,`Nil _l) -> `Nil _loc
      | sg -> sg
    method! str_item st =
      match super#str_item st with
      | `Sem (_loc,`Nil _l,st)|`Sem (_loc,st,`Nil _l) -> st
      | `Type (_loc,`Nil _l) -> `Nil _loc
      | `Value (_loc,_,`Nil _l) -> `Nil _loc
      | st -> st
    method! module_type mt =
      match super#module_type mt with
      | `With (_loc,mt,`Nil _l) -> mt
      | mt -> mt
    method! class_expr ce =
      match super#class_expr ce with
      | `And (_loc,`Nil _l,ce)|`And (_loc,ce,`Nil _l) -> ce
      | ce -> ce
    method! class_type ct =
      match super#class_type ct with
      | `And (_loc,`Nil _l,ct)|`And (_loc,ct,`Nil _l) -> ct
      | ct -> ct
    method! class_sig_item csg =
      match super#class_sig_item csg with
      | `Sem (_loc,`Nil _l,csg)|`Sem (_loc,csg,`Nil _l) -> csg
      | csg -> csg
    method! class_str_item cst =
      match super#class_str_item cst with
      | `Sem (_loc,`Nil _l,cst)|`Sem (_loc,cst,`Nil _l) -> cst
      | cst -> cst
  end
class reloc _loc = object  inherit  map method! loc _ = _loc end
let wildcarder =
  object (self)
    inherit  map as super
    method! patt =
      function
      | `Id (_loc,`Lid (_,_)) -> `Any _loc
      | `Alias (_loc,p,_) -> self#patt p
      | p -> super#patt p
  end
let match_pre =
  object (self)
    inherit  map
    method! match_case =
      function
      | `Case (_loc,p,`Nil _,e) ->
          `Case
            (_loc, p, (`Nil _loc),
              (`Fun
                 (_loc,
                   (`Case
                      (_loc, (`Id (_loc, (`Uid (_loc, "()")))), (`Nil _loc),
                        e)))))
      | `Case (_loc,p,e,e1) ->
          `Case
            (_loc, p, e,
              (`Fun
                 (_loc,
                   (`Case
                      (_loc, (`Id (_loc, (`Uid (_loc, "()")))), (`Nil _loc),
                        e1)))))
      | `Or (_loc,a1,a2) ->
          `Or (_loc, (self#match_case a1), (self#match_case a2))
      | `Nil _loc -> `Nil _loc
      | `Ant (_loc,x) -> `Ant (_loc, (add_context x "lettry"))
  end
let dump = new print
let dump_ctyp = to_string_of_printer dump#ctyp
let dump_with_constr = to_string_of_printer dump#with_constr
let dump_module_type = to_string_of_printer dump#module_type
let dump_expr = to_string_of_printer dump#expr
let dump_patt = to_string_of_printer dump#patt
let dump_class_type = to_string_of_printer dump#class_type
let dump_class_expr = to_string_of_printer dump#class_expr
let dump_ident = to_string_of_printer dump#ident
let dump_match_case = to_string_of_printer dump#match_case
let dump_rec_binding = to_string_of_printer dump#rec_binding
let dump_str_item = to_string_of_printer dump#str_item
let dump_sig_item = to_string_of_printer dump#sig_item
let dump_module_binding = to_string_of_printer dump#module_binding
let dump_module_expr = to_string_of_printer dump#module_expr
let dump_class_sig_item = to_string_of_printer dump#class_sig_item
let dump_class_str_item = to_string_of_printer dump#class_str_item