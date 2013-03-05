open StdLib
include AstN
let _ = ()
class eq =
  object (self : 'self_type)
    inherit  eqbase
    method loc : loc -> loc -> 'result0=
      fun _a0  _a1  -> self#fanloc_t _a0 _a1
    method ant : ant -> ant -> 'result1=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Ant (_a0,_a1),`Ant (_b0,_b1)) ->
            (self#loc _a0 _b0) && (self#fanutil_anti_cxt _a1 _b1)
    method nil : nil -> nil -> 'result2=
      fun _a0  _b0  -> match (_a0, _b0) with | (`Nil,`Nil) -> true
    method ant_nil : ant_nil -> ant_nil -> 'result3=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result3)
        | ((#nil as _a0),(#nil as _b0)) -> (self#nil _a0 _b0 :>'result3)
        | (_,_) -> false
    method literal : literal -> literal -> 'result4=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Chr _a0,`Chr _b0) -> self#string _a0 _b0
        | (`Int _a0,`Int _b0) -> self#string _a0 _b0
        | (`Int32 _a0,`Int32 _b0) -> self#string _a0 _b0
        | (`Int64 _a0,`Int64 _b0) -> self#string _a0 _b0
        | (`Flo _a0,`Flo _b0) -> self#string _a0 _b0
        | (`NativeInt _a0,`NativeInt _b0) -> self#string _a0 _b0
        | (`Str _a0,`Str _b0) -> self#string _a0 _b0
        | (_,_) -> false
    method rec_flag : rec_flag -> rec_flag -> 'result5=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Recursive,`Recursive) -> true
        | (`ReNil,`ReNil) -> true
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result5)
        | (_,_) -> false
    method direction_flag : direction_flag -> direction_flag -> 'result6=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`To,`To) -> true
        | (`Downto,`Downto) -> true
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result6)
        | (_,_) -> false
    method mutable_flag : mutable_flag -> mutable_flag -> 'result7=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Mutable,`Mutable) -> true
        | (`MuNil,`MuNil) -> true
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result7)
        | (_,_) -> false
    method private_flag : private_flag -> private_flag -> 'result8=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Private,`Private) -> true
        | (`PrNil,`PrNil) -> true
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result8)
        | (_,_) -> false
    method virtual_flag : virtual_flag -> virtual_flag -> 'result9=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Virtual,`Virtual) -> true
        | (`ViNil,`ViNil) -> true
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result9)
        | (_,_) -> false
    method override_flag : override_flag -> override_flag -> 'result10=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Override,`Override) -> true
        | (`OvNil,`OvNil) -> true
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result10)
        | (_,_) -> false
    method row_var_flag : row_var_flag -> row_var_flag -> 'result11=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`RowVar,`RowVar) -> true
        | (`RvNil,`RvNil) -> true
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result11)
        | (_,_) -> false
    method position_flag : position_flag -> position_flag -> 'result12=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Positive,`Positive) -> true
        | (`Negative,`Negative) -> true
        | (`Normal,`Normal) -> true
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result12)
        | (_,_) -> false
    method meta_bool : meta_bool -> meta_bool -> 'result13=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`True,`True) -> true
        | (`False,`False) -> true
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result13)
        | (_,_) -> false
    method meta_option :
      'all_a0 .
        ('self_type -> 'all_a0 -> 'all_a0 -> 'result14) ->
          'all_a0 meta_option -> 'all_a0 meta_option -> 'result14=
      fun mf_a  _a0  _b0  ->
        match (_a0, _b0) with
        | (`None,`None) -> true
        | (`Some _a0,`Some _b0) -> mf_a self _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result14)
        | (_,_) -> false
    method meta_list :
      'all_a0 .
        ('self_type -> 'all_a0 -> 'all_a0 -> 'result15) ->
          'all_a0 meta_list -> 'all_a0 meta_list -> 'result15=
      fun mf_a  _a0  _b0  ->
        match (_a0, _b0) with
        | (`LNil,`LNil) -> true
        | (`LCons (_a0,_a1),`LCons (_b0,_b1)) ->
            (mf_a self _a0 _b0) && (self#meta_list mf_a _a1 _b1)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result15)
        | (_,_) -> false
    method alident : alident -> alident -> 'result16=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Lid _a0,`Lid _b0) -> self#string _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result16)
        | (_,_) -> false
    method auident : auident -> auident -> 'result17=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Uid _a0,`Uid _b0) -> self#string _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result17)
        | (_,_) -> false
    method aident : aident -> aident -> 'result18=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#alident as _a0),(#alident as _b0)) ->
            (self#alident _a0 _b0 :>'result18)
        | ((#auident as _a0),(#auident as _b0)) ->
            (self#auident _a0 _b0 :>'result18)
        | (_,_) -> false
    method astring : astring -> astring -> 'result19=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`C _a0,`C _b0) -> self#string _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result19)
        | (_,_) -> false
    method uident : uident -> uident -> 'result20=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Dot (_a0,_a1),`Dot (_b0,_b1)) ->
            (self#uident _a0 _b0) && (self#uident _a1 _b1)
        | (`App (_a0,_a1),`App (_b0,_b1)) ->
            (self#uident _a0 _b0) && (self#uident _a1 _b1)
        | ((#auident as _a0),(#auident as _b0)) ->
            (self#auident _a0 _b0 :>'result20)
        | (_,_) -> false
    method ident : ident -> ident -> 'result21=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Dot (_a0,_a1),`Dot (_b0,_b1)) ->
            (self#ident _a0 _b0) && (self#ident _a1 _b1)
        | (`App (_a0,_a1),`App (_b0,_b1)) ->
            (self#ident _a0 _b0) && (self#ident _a1 _b1)
        | ((#alident as _a0),(#alident as _b0)) ->
            (self#alident _a0 _b0 :>'result21)
        | ((#auident as _a0),(#auident as _b0)) ->
            (self#auident _a0 _b0 :>'result21)
        | (_,_) -> false
    method dupath : dupath -> dupath -> 'result22=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Dot (_a0,_a1),`Dot (_b0,_b1)) ->
            (self#dupath _a0 _b0) && (self#dupath _a1 _b1)
        | ((#auident as _a0),(#auident as _b0)) ->
            (self#auident _a0 _b0 :>'result22)
        | (_,_) -> false
    method dlpath : dlpath -> dlpath -> 'result23=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Dot (_a0,_a1),`Dot (_b0,_b1)) ->
            (self#dupath _a0 _b0) && (self#alident _a1 _b1)
        | ((#alident as _a0),(#alident as _b0)) ->
            (self#alident _a0 _b0 :>'result23)
        | (_,_) -> false
    method sid : sid -> sid -> 'result24=
      fun _a0  _b0  ->
        match (_a0, _b0) with | (`Id _a0,`Id _b0) -> self#ident _a0 _b0
    method any : any -> any -> 'result25=
      fun _a0  _b0  -> match (_a0, _b0) with | (`Any,`Any) -> true
    method ctyp : ctyp -> ctyp -> 'result26=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#nil as _a0),(#nil as _b0)) -> (self#nil _a0 _b0 :>'result26)
        | (`Alias (_a0,_a1),`Alias (_b0,_b1)) ->
            (self#ctyp _a0 _b0) && (self#alident _a1 _b1)
        | ((#any as _a0),(#any as _b0)) -> (self#any _a0 _b0 :>'result26)
        | (`App (_a0,_a1),`App (_b0,_b1)) ->
            (self#ctyp _a0 _b0) && (self#ctyp _a1 _b1)
        | (`Arrow (_a0,_a1),`Arrow (_b0,_b1)) ->
            (self#ctyp _a0 _b0) && (self#ctyp _a1 _b1)
        | (`ClassPath _a0,`ClassPath _b0) -> self#ident _a0 _b0
        | (`Label (_a0,_a1),`Label (_b0,_b1)) ->
            (self#alident _a0 _b0) && (self#ctyp _a1 _b1)
        | (`OptLabl (_a0,_a1),`OptLabl (_b0,_b1)) ->
            (self#alident _a0 _b0) && (self#ctyp _a1 _b1)
        | ((#sid as _a0),(#sid as _b0)) -> (self#sid _a0 _b0 :>'result26)
        | (`TyObj (_a0,_a1),`TyObj (_b0,_b1)) ->
            (self#name_ctyp _a0 _b0) && (self#row_var_flag _a1 _b1)
        | (`TyPol (_a0,_a1),`TyPol (_b0,_b1)) ->
            (self#ctyp _a0 _b0) && (self#ctyp _a1 _b1)
        | (`TyTypePol (_a0,_a1),`TyTypePol (_b0,_b1)) ->
            (self#ctyp _a0 _b0) && (self#ctyp _a1 _b1)
        | (`Quote (_a0,_a1),`Quote (_b0,_b1)) ->
            (self#position_flag _a0 _b0) &&
              (self#meta_option (fun self  -> self#alident) _a1 _b1)
        | (`Com (_a0,_a1),`Com (_b0,_b1)) ->
            (self#ctyp _a0 _b0) && (self#ctyp _a1 _b1)
        | (`Tup _a0,`Tup _b0) -> self#ctyp _a0 _b0
        | (`Sta (_a0,_a1),`Sta (_b0,_b1)) ->
            (self#ctyp _a0 _b0) && (self#ctyp _a1 _b1)
        | (`PolyEq _a0,`PolyEq _b0) -> self#row_field _a0 _b0
        | (`PolySup _a0,`PolySup _b0) -> self#row_field _a0 _b0
        | (`PolyInf _a0,`PolyInf _b0) -> self#row_field _a0 _b0
        | (`PolyInfSup (_a0,_a1),`PolyInfSup (_b0,_b1)) ->
            (self#row_field _a0 _b0) && (self#tag_names _a1 _b1)
        | (`Package _a0,`Package _b0) -> self#module_type _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result26)
        | (_,_) -> false
    method row_field : row_field -> row_field -> 'result27=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#ant_nil as _a0),(#ant_nil as _b0)) ->
            (self#ant_nil _a0 _b0 :>'result27)
        | (`Or (_a0,_a1),`Or (_b0,_b1)) ->
            (self#row_field _a0 _b0) && (self#row_field _a1 _b1)
        | (`TyVrn _a0,`TyVrn _b0) -> self#astring _a0 _b0
        | (`TyVrnOf (_a0,_a1),`TyVrnOf (_b0,_b1)) ->
            (self#astring _a0 _b0) && (self#ctyp _a1 _b1)
        | (`Ctyp _a0,`Ctyp _b0) -> self#ctyp _a0 _b0
        | (_,_) -> false
    method tag_names : tag_names -> tag_names -> 'result28=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#ant_nil as _a0),(#ant_nil as _b0)) ->
            (self#ant_nil _a0 _b0 :>'result28)
        | (`App (_a0,_a1),`App (_b0,_b1)) ->
            (self#tag_names _a0 _b0) && (self#tag_names _a1 _b1)
        | (`TyVrn _a0,`TyVrn _b0) -> self#astring _a0 _b0
        | (_,_) -> false
    method typedecl : typedecl -> typedecl -> 'result29=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`TyDcl (_a0,_a1,_a2,_a3),`TyDcl (_b0,_b1,_b2,_b3)) ->
            (((self#alident _a0 _b0) &&
                (self#list (fun self  -> self#ctyp) _a1 _b1))
               && (self#type_info _a2 _b2))
              &&
              (self#list
                 (fun self  _a0  _b0  ->
                    match (_a0, _b0) with
                    | ((_a0,_a1),(_b0,_b1)) ->
                        (self#ctyp _a0 _b0) && (self#ctyp _a1 _b1)) _a3 _b3)
        | (`And (_a0,_a1),`And (_b0,_b1)) ->
            (self#typedecl _a0 _b0) && (self#typedecl _a1 _b1)
        | ((#ant_nil as _a0),(#ant_nil as _b0)) ->
            (self#ant_nil _a0 _b0 :>'result29)
        | (_,_) -> false
    method type_info : type_info -> type_info -> 'result30=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`TyMan (_a0,_a1,_a2),`TyMan (_b0,_b1,_b2)) ->
            ((self#ctyp _a0 _b0) && (self#private_flag _a1 _b1)) &&
              (self#type_repr _a2 _b2)
        | (`TyRepr (_a0,_a1),`TyRepr (_b0,_b1)) ->
            (self#private_flag _a0 _b0) && (self#type_repr _a1 _b1)
        | (`TyEq (_a0,_a1),`TyEq (_b0,_b1)) ->
            (self#private_flag _a0 _b0) && (self#ctyp _a1 _b1)
        | ((#ant_nil as _a0),(#ant_nil as _b0)) ->
            (self#ant_nil _a0 _b0 :>'result30)
        | (_,_) -> false
    method type_repr : type_repr -> type_repr -> 'result31=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Record _a0,`Record _b0) -> self#name_ctyp _a0 _b0
        | (`Sum _a0,`Sum _b0) -> self#or_ctyp _a0 _b0
        | ((#ant_nil as _a0),(#ant_nil as _b0)) ->
            (self#ant_nil _a0 _b0 :>'result31)
        | (_,_) -> false
    method name_ctyp : name_ctyp -> name_ctyp -> 'result32=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Sem (_a0,_a1),`Sem (_b0,_b1)) ->
            (self#name_ctyp _a0 _b0) && (self#name_ctyp _a1 _b1)
        | (`TyCol (_a0,_a1),`TyCol (_b0,_b1)) ->
            (self#sid _a0 _b0) && (self#ctyp _a1 _b1)
        | (`TyColMut (_a0,_a1),`TyColMut (_b0,_b1)) ->
            (self#sid _a0 _b0) && (self#ctyp _a1 _b1)
        | ((#ant_nil as _a0),(#ant_nil as _b0)) ->
            (self#ant_nil _a0 _b0 :>'result32)
        | (_,_) -> false
    method or_ctyp : or_ctyp -> or_ctyp -> 'result33=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Or (_a0,_a1),`Or (_b0,_b1)) ->
            (self#or_ctyp _a0 _b0) && (self#or_ctyp _a1 _b1)
        | (`TyCol (_a0,_a1),`TyCol (_b0,_b1)) ->
            (self#sid _a0 _b0) && (self#ctyp _a1 _b1)
        | (`Of (_a0,_a1),`Of (_b0,_b1)) ->
            (self#sid _a0 _b0) && (self#ctyp _a1 _b1)
        | ((#sid as _a0),(#sid as _b0)) -> (self#sid _a0 _b0 :>'result33)
        | ((#ant_nil as _a0),(#ant_nil as _b0)) ->
            (self#ant_nil _a0 _b0 :>'result33)
        | (_,_) -> false
    method of_ctyp : of_ctyp -> of_ctyp -> 'result34=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | (`Of (_a0,_a1),`Of (_b0,_b1)) ->
            (self#sid _a0 _b0) && (self#ctyp _a1 _b1)
        | ((#sid as _a0),(#sid as _b0)) -> (self#sid _a0 _b0 :>'result34)
        | ((#ant_nil as _a0),(#ant_nil as _b0)) ->
            (self#ant_nil _a0 _b0 :>'result34)
        | (_,_) -> false
    method patt : patt -> patt -> 'result35=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#nil as _a0),(#nil as _b0)) -> (self#nil _a0 _b0 :>'result35)
        | ((#sid as _a0),(#sid as _b0)) -> (self#sid _a0 _b0 :>'result35)
        | (`App (_a0,_a1),`App (_b0,_b1)) ->
            (self#patt _a0 _b0) && (self#patt _a1 _b1)
        | (`Vrn _a0,`Vrn _b0) -> self#string _a0 _b0
        | (`Com (_a0,_a1),`Com (_b0,_b1)) ->
            (self#patt _a0 _b0) && (self#patt _a1 _b1)
        | (`Sem (_a0,_a1),`Sem (_b0,_b1)) ->
            (self#patt _a0 _b0) && (self#patt _a1 _b1)
        | (`Tup _a0,`Tup _b0) -> self#patt _a0 _b0
        | ((#any as _a0),(#any as _b0)) -> (self#any _a0 _b0 :>'result35)
        | (`Record _a0,`Record _b0) -> self#rec_patt _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result35)
        | ((#literal as _a0),(#literal as _b0)) ->
            (self#literal _a0 _b0 :>'result35)
        | (`Alias (_a0,_a1),`Alias (_b0,_b1)) ->
            (self#patt _a0 _b0) && (self#alident _a1 _b1)
        | (`Array _a0,`Array _b0) -> self#patt _a0 _b0
        | (`Label (_a0,_a1),`Label (_b0,_b1)) ->
            (self#alident _a0 _b0) && (self#patt _a1 _b1)
        | (`PaOlbi (_a0,_a1,_a2),`PaOlbi (_b0,_b1,_b2)) ->
            ((self#alident _a0 _b0) && (self#patt _a1 _b1)) &&
              (self#meta_option (fun self  -> self#expr) _a2 _b2)
        | (`Or (_a0,_a1),`Or (_b0,_b1)) ->
            (self#patt _a0 _b0) && (self#patt _a1 _b1)
        | (`PaRng (_a0,_a1),`PaRng (_b0,_b1)) ->
            (self#patt _a0 _b0) && (self#patt _a1 _b1)
        | (`Constraint (_a0,_a1),`Constraint (_b0,_b1)) ->
            (self#patt _a0 _b0) && (self#ctyp _a1 _b1)
        | (`ClassPath _a0,`ClassPath _b0) -> self#ident _a0 _b0
        | (`Lazy _a0,`Lazy _b0) -> self#patt _a0 _b0
        | (`ModuleUnpack (_a0,_a1),`ModuleUnpack (_b0,_b1)) ->
            (self#auident _a0 _b0) &&
              (self#meta_option (fun self  -> self#ctyp) _a1 _b1)
        | (_,_) -> false
    method rec_patt : rec_patt -> rec_patt -> 'result36=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#nil as _a0),(#nil as _b0)) -> (self#nil _a0 _b0 :>'result36)
        | (`RecBind (_a0,_a1),`RecBind (_b0,_b1)) ->
            (self#ident _a0 _b0) && (self#patt _a1 _b1)
        | (`Sem (_a0,_a1),`Sem (_b0,_b1)) ->
            (self#rec_patt _a0 _b0) && (self#rec_patt _a1 _b1)
        | ((#any as _a0),(#any as _b0)) -> (self#any _a0 _b0 :>'result36)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result36)
        | (_,_) -> false
    method expr : expr -> expr -> 'result37=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#nil as _a0),(#nil as _b0)) -> (self#nil _a0 _b0 :>'result37)
        | ((#sid as _a0),(#sid as _b0)) -> (self#sid _a0 _b0 :>'result37)
        | (`App (_a0,_a1),`App (_b0,_b1)) ->
            (self#expr _a0 _b0) && (self#expr _a1 _b1)
        | (`Vrn _a0,`Vrn _b0) -> self#string _a0 _b0
        | (`Com (_a0,_a1),`Com (_b0,_b1)) ->
            (self#expr _a0 _b0) && (self#expr _a1 _b1)
        | (`Sem (_a0,_a1),`Sem (_b0,_b1)) ->
            (self#expr _a0 _b0) && (self#expr _a1 _b1)
        | (`Tup _a0,`Tup _b0) -> self#expr _a0 _b0
        | ((#any as _a0),(#any as _b0)) -> (self#any _a0 _b0 :>'result37)
        | (`Record _a0,`Record _b0) -> self#rec_expr _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result37)
        | ((#literal as _a0),(#literal as _b0)) ->
            (self#literal _a0 _b0 :>'result37)
        | (`RecordWith (_a0,_a1),`RecordWith (_b0,_b1)) ->
            (self#rec_expr _a0 _b0) && (self#expr _a1 _b1)
        | (`Dot (_a0,_a1),`Dot (_b0,_b1)) ->
            (self#expr _a0 _b0) && (self#expr _a1 _b1)
        | (`ArrayDot (_a0,_a1),`ArrayDot (_b0,_b1)) ->
            (self#expr _a0 _b0) && (self#expr _a1 _b1)
        | (`Array _a0,`Array _b0) -> self#expr _a0 _b0
        | (`ExAsf,`ExAsf) -> true
        | (`ExAsr _a0,`ExAsr _b0) -> self#expr _a0 _b0
        | (`Assign (_a0,_a1),`Assign (_b0,_b1)) ->
            (self#expr _a0 _b0) && (self#expr _a1 _b1)
        | (`For (_a0,_a1,_a2,_a3,_a4),`For (_b0,_b1,_b2,_b3,_b4)) ->
            ((((self#alident _a0 _b0) && (self#expr _a1 _b1)) &&
                (self#expr _a2 _b2))
               && (self#direction_flag _a3 _b3))
              && (self#expr _a4 _b4)
        | (`Fun _a0,`Fun _b0) -> self#match_case _a0 _b0
        | (`IfThenElse (_a0,_a1,_a2),`IfThenElse (_b0,_b1,_b2)) ->
            ((self#expr _a0 _b0) && (self#expr _a1 _b1)) &&
              (self#expr _a2 _b2)
        | (`IfThen (_a0,_a1),`IfThen (_b0,_b1)) ->
            (self#expr _a0 _b0) && (self#expr _a1 _b1)
        | (`Label (_a0,_a1),`Label (_b0,_b1)) ->
            (self#alident _a0 _b0) && (self#expr _a1 _b1)
        | (`Lazy _a0,`Lazy _b0) -> self#expr _a0 _b0
        | (`LetIn (_a0,_a1,_a2),`LetIn (_b0,_b1,_b2)) ->
            ((self#rec_flag _a0 _b0) && (self#binding _a1 _b1)) &&
              (self#expr _a2 _b2)
        | (`LetModule (_a0,_a1,_a2),`LetModule (_b0,_b1,_b2)) ->
            ((self#auident _a0 _b0) && (self#module_expr _a1 _b1)) &&
              (self#expr _a2 _b2)
        | (`Match (_a0,_a1),`Match (_b0,_b1)) ->
            (self#expr _a0 _b0) && (self#match_case _a1 _b1)
        | (`New _a0,`New _b0) -> self#ident _a0 _b0
        | (`Obj (_a0,_a1),`Obj (_b0,_b1)) ->
            (self#patt _a0 _b0) && (self#class_str_item _a1 _b1)
        | (`OptLabl (_a0,_a1),`OptLabl (_b0,_b1)) ->
            (self#alident _a0 _b0) && (self#expr _a1 _b1)
        | (`OvrInst _a0,`OvrInst _b0) -> self#rec_expr _a0 _b0
        | (`Seq _a0,`Seq _b0) -> self#expr _a0 _b0
        | (`Send (_a0,_a1),`Send (_b0,_b1)) ->
            (self#expr _a0 _b0) && (self#alident _a1 _b1)
        | (`StringDot (_a0,_a1),`StringDot (_b0,_b1)) ->
            (self#expr _a0 _b0) && (self#expr _a1 _b1)
        | (`Try (_a0,_a1),`Try (_b0,_b1)) ->
            (self#expr _a0 _b0) && (self#match_case _a1 _b1)
        | (`Constraint (_a0,_a1),`Constraint (_b0,_b1)) ->
            (self#expr _a0 _b0) && (self#ctyp _a1 _b1)
        | (`Coercion (_a0,_a1,_a2),`Coercion (_b0,_b1,_b2)) ->
            ((self#expr _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`While (_a0,_a1),`While (_b0,_b1)) ->
            (self#expr _a0 _b0) && (self#expr _a1 _b1)
        | (`LetOpen (_a0,_a1),`LetOpen (_b0,_b1)) ->
            (self#ident _a0 _b0) && (self#expr _a1 _b1)
        | (`LocalTypeFun (_a0,_a1),`LocalTypeFun (_b0,_b1)) ->
            (self#alident _a0 _b0) && (self#expr _a1 _b1)
        | (`Package_expr _a0,`Package_expr _b0) -> self#module_expr _a0 _b0
        | (_,_) -> false
    method rec_expr : rec_expr -> rec_expr -> 'result38=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#nil as _a0),(#nil as _b0)) -> (self#nil _a0 _b0 :>'result38)
        | (`Sem (_a0,_a1),`Sem (_b0,_b1)) ->
            (self#rec_expr _a0 _b0) && (self#rec_expr _a1 _b1)
        | (`RecBind (_a0,_a1),`RecBind (_b0,_b1)) ->
            (self#ident _a0 _b0) && (self#expr _a1 _b1)
        | ((#any as _a0),(#any as _b0)) -> (self#any _a0 _b0 :>'result38)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result38)
        | (_,_) -> false
    method module_type : module_type -> module_type -> 'result39=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#nil as _a0),(#nil as _b0)) -> (self#nil _a0 _b0 :>'result39)
        | ((#sid as _a0),(#sid as _b0)) -> (self#sid _a0 _b0 :>'result39)
        | (`MtFun (_a0,_a1,_a2),`MtFun (_b0,_b1,_b2)) ->
            ((self#auident _a0 _b0) && (self#module_type _a1 _b1)) &&
              (self#module_type _a2 _b2)
        | (`Sig _a0,`Sig _b0) -> self#sig_item _a0 _b0
        | (`With (_a0,_a1),`With (_b0,_b1)) ->
            (self#module_type _a0 _b0) && (self#with_constr _a1 _b1)
        | (`ModuleTypeOf _a0,`ModuleTypeOf _b0) -> self#module_expr _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result39)
        | (_,_) -> false
    method sig_item : sig_item -> sig_item -> 'result40=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#nil as _a0),(#nil as _b0)) -> (self#nil _a0 _b0 :>'result40)
        | (`Class _a0,`Class _b0) -> self#class_type _a0 _b0
        | (`ClassType _a0,`ClassType _b0) -> self#class_type _a0 _b0
        | (`Sem (_a0,_a1),`Sem (_b0,_b1)) ->
            (self#sig_item _a0 _b0) && (self#sig_item _a1 _b1)
        | (`Directive (_a0,_a1),`Directive (_b0,_b1)) ->
            (self#alident _a0 _b0) && (self#expr _a1 _b1)
        | (`Exception _a0,`Exception _b0) -> self#of_ctyp _a0 _b0
        | (`External (_a0,_a1,_a2),`External (_b0,_b1,_b2)) ->
            ((self#alident _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#meta_list (fun self  -> self#string) _a2 _b2)
        | (`Include _a0,`Include _b0) -> self#module_type _a0 _b0
        | (`Module (_a0,_a1),`Module (_b0,_b1)) ->
            (self#auident _a0 _b0) && (self#module_type _a1 _b1)
        | (`RecModule _a0,`RecModule _b0) -> self#module_binding _a0 _b0
        | (`ModuleType (_a0,_a1),`ModuleType (_b0,_b1)) ->
            (self#auident _a0 _b0) && (self#module_type _a1 _b1)
        | (`Open _a0,`Open _b0) -> self#ident _a0 _b0
        | (`Type _a0,`Type _b0) -> self#typedecl _a0 _b0
        | (`Val (_a0,_a1),`Val (_b0,_b1)) ->
            (self#alident _a0 _b0) && (self#ctyp _a1 _b1)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result40)
        | (_,_) -> false
    method with_constr : with_constr -> with_constr -> 'result41=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#nil as _a0),(#nil as _b0)) -> (self#nil _a0 _b0 :>'result41)
        | (`TypeEq (_a0,_a1),`TypeEq (_b0,_b1)) ->
            (self#ctyp _a0 _b0) && (self#ctyp _a1 _b1)
        | (`TypeEqPriv (_a0,_a1),`TypeEqPriv (_b0,_b1)) ->
            (self#ctyp _a0 _b0) && (self#ctyp _a1 _b1)
        | (`ModuleEq (_a0,_a1),`ModuleEq (_b0,_b1)) ->
            (self#ident _a0 _b0) && (self#ident _a1 _b1)
        | (`TypeSubst (_a0,_a1),`TypeSubst (_b0,_b1)) ->
            (self#ctyp _a0 _b0) && (self#ctyp _a1 _b1)
        | (`ModuleSubst (_a0,_a1),`ModuleSubst (_b0,_b1)) ->
            (self#ident _a0 _b0) && (self#ident _a1 _b1)
        | (`And (_a0,_a1),`And (_b0,_b1)) ->
            (self#with_constr _a0 _b0) && (self#with_constr _a1 _b1)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result41)
        | (_,_) -> false
    method binding : binding -> binding -> 'result42=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#nil as _a0),(#nil as _b0)) -> (self#nil _a0 _b0 :>'result42)
        | (`And (_a0,_a1),`And (_b0,_b1)) ->
            (self#binding _a0 _b0) && (self#binding _a1 _b1)
        | (`Bind (_a0,_a1),`Bind (_b0,_b1)) ->
            (self#patt _a0 _b0) && (self#expr _a1 _b1)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result42)
        | (_,_) -> false
    method module_binding : module_binding -> module_binding -> 'result43=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#nil as _a0),(#nil as _b0)) -> (self#nil _a0 _b0 :>'result43)
        | (`And (_a0,_a1),`And (_b0,_b1)) ->
            (self#module_binding _a0 _b0) && (self#module_binding _a1 _b1)
        | (`ModuleBind (_a0,_a1,_a2),`ModuleBind (_b0,_b1,_b2)) ->
            ((self#auident _a0 _b0) && (self#module_type _a1 _b1)) &&
              (self#module_expr _a2 _b2)
        | (`Constraint (_a0,_a1),`Constraint (_b0,_b1)) ->
            (self#auident _a0 _b0) && (self#module_type _a1 _b1)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result43)
        | (_,_) -> false
    method match_case : match_case -> match_case -> 'result44=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#nil as _a0),(#nil as _b0)) -> (self#nil _a0 _b0 :>'result44)
        | (`Or (_a0,_a1),`Or (_b0,_b1)) ->
            (self#match_case _a0 _b0) && (self#match_case _a1 _b1)
        | (`Case (_a0,_a1,_a2),`Case (_b0,_b1,_b2)) ->
            ((self#patt _a0 _b0) && (self#expr _a1 _b1)) &&
              (self#expr _a2 _b2)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result44)
        | (_,_) -> false
    method module_expr : module_expr -> module_expr -> 'result45=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#nil as _a0),(#nil as _b0)) -> (self#nil _a0 _b0 :>'result45)
        | ((#sid as _a0),(#sid as _b0)) -> (self#sid _a0 _b0 :>'result45)
        | (`App (_a0,_a1),`App (_b0,_b1)) ->
            (self#module_expr _a0 _b0) && (self#module_expr _a1 _b1)
        | (`Functor (_a0,_a1,_a2),`Functor (_b0,_b1,_b2)) ->
            ((self#auident _a0 _b0) && (self#module_type _a1 _b1)) &&
              (self#module_expr _a2 _b2)
        | (`Struct _a0,`Struct _b0) -> self#str_item _a0 _b0
        | (`Constraint (_a0,_a1),`Constraint (_b0,_b1)) ->
            (self#module_expr _a0 _b0) && (self#module_type _a1 _b1)
        | (`PackageModule _a0,`PackageModule _b0) -> self#expr _a0 _b0
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result45)
        | (_,_) -> false
    method str_item : str_item -> str_item -> 'result46=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#nil as _a0),(#nil as _b0)) -> (self#nil _a0 _b0 :>'result46)
        | (`Class _a0,`Class _b0) -> self#class_expr _a0 _b0
        | (`ClassType _a0,`ClassType _b0) -> self#class_type _a0 _b0
        | (`Sem (_a0,_a1),`Sem (_b0,_b1)) ->
            (self#str_item _a0 _b0) && (self#str_item _a1 _b1)
        | (`Directive (_a0,_a1),`Directive (_b0,_b1)) ->
            (self#alident _a0 _b0) && (self#expr _a1 _b1)
        | (`Exception _a0,`Exception _b0) -> self#of_ctyp _a0 _b0
        | (`StExp _a0,`StExp _b0) -> self#expr _a0 _b0
        | (`External (_a0,_a1,_a2),`External (_b0,_b1,_b2)) ->
            ((self#alident _a0 _b0) && (self#ctyp _a1 _b1)) &&
              (self#meta_list (fun self  -> self#string) _a2 _b2)
        | (`Include _a0,`Include _b0) -> self#module_expr _a0 _b0
        | (`Module (_a0,_a1),`Module (_b0,_b1)) ->
            (self#auident _a0 _b0) && (self#module_expr _a1 _b1)
        | (`RecModule _a0,`RecModule _b0) -> self#module_binding _a0 _b0
        | (`ModuleType (_a0,_a1),`ModuleType (_b0,_b1)) ->
            (self#auident _a0 _b0) && (self#module_type _a1 _b1)
        | (`Open _a0,`Open _b0) -> self#ident _a0 _b0
        | (`Type _a0,`Type _b0) -> self#typedecl _a0 _b0
        | (`Value (_a0,_a1),`Value (_b0,_b1)) ->
            (self#rec_flag _a0 _b0) && (self#binding _a1 _b1)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result46)
        | (_,_) -> false
    method class_type : class_type -> class_type -> 'result47=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#nil as _a0),(#nil as _b0)) -> (self#nil _a0 _b0 :>'result47)
        | (`CtCon (_a0,_a1,_a2),`CtCon (_b0,_b1,_b2)) ->
            ((self#virtual_flag _a0 _b0) && (self#ident _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`CtFun (_a0,_a1),`CtFun (_b0,_b1)) ->
            (self#ctyp _a0 _b0) && (self#class_type _a1 _b1)
        | (`CtSig (_a0,_a1),`CtSig (_b0,_b1)) ->
            (self#ctyp _a0 _b0) && (self#class_sig_item _a1 _b1)
        | (`And (_a0,_a1),`And (_b0,_b1)) ->
            (self#class_type _a0 _b0) && (self#class_type _a1 _b1)
        | (`CtCol (_a0,_a1),`CtCol (_b0,_b1)) ->
            (self#class_type _a0 _b0) && (self#class_type _a1 _b1)
        | (`CtEq (_a0,_a1),`CtEq (_b0,_b1)) ->
            (self#class_type _a0 _b0) && (self#class_type _a1 _b1)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result47)
        | (_,_) -> false
    method class_sig_item : class_sig_item -> class_sig_item -> 'result48=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#nil as _a0),(#nil as _b0)) -> (self#nil _a0 _b0 :>'result48)
        | (`Eq (_a0,_a1),`Eq (_b0,_b1)) ->
            (self#ctyp _a0 _b0) && (self#ctyp _a1 _b1)
        | (`Sem (_a0,_a1),`Sem (_b0,_b1)) ->
            (self#class_sig_item _a0 _b0) && (self#class_sig_item _a1 _b1)
        | (`SigInherit _a0,`SigInherit _b0) -> self#class_type _a0 _b0
        | (`Method (_a0,_a1,_a2),`Method (_b0,_b1,_b2)) ->
            ((self#alident _a0 _b0) && (self#private_flag _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`CgVal (_a0,_a1,_a2,_a3),`CgVal (_b0,_b1,_b2,_b3)) ->
            (((self#alident _a0 _b0) && (self#mutable_flag _a1 _b1)) &&
               (self#virtual_flag _a2 _b2))
              && (self#ctyp _a3 _b3)
        | (`CgVir (_a0,_a1,_a2),`CgVir (_b0,_b1,_b2)) ->
            ((self#alident _a0 _b0) && (self#private_flag _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result48)
        | (_,_) -> false
    method class_expr : class_expr -> class_expr -> 'result49=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#nil as _a0),(#nil as _b0)) -> (self#nil _a0 _b0 :>'result49)
        | (`CeApp (_a0,_a1),`CeApp (_b0,_b1)) ->
            (self#class_expr _a0 _b0) && (self#expr _a1 _b1)
        | (`CeCon (_a0,_a1,_a2),`CeCon (_b0,_b1,_b2)) ->
            ((self#virtual_flag _a0 _b0) && (self#ident _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`CeFun (_a0,_a1),`CeFun (_b0,_b1)) ->
            (self#patt _a0 _b0) && (self#class_expr _a1 _b1)
        | (`CeLet (_a0,_a1,_a2),`CeLet (_b0,_b1,_b2)) ->
            ((self#rec_flag _a0 _b0) && (self#binding _a1 _b1)) &&
              (self#class_expr _a2 _b2)
        | (`Obj (_a0,_a1),`Obj (_b0,_b1)) ->
            (self#patt _a0 _b0) && (self#class_str_item _a1 _b1)
        | (`CeTyc (_a0,_a1),`CeTyc (_b0,_b1)) ->
            (self#class_expr _a0 _b0) && (self#class_type _a1 _b1)
        | (`And (_a0,_a1),`And (_b0,_b1)) ->
            (self#class_expr _a0 _b0) && (self#class_expr _a1 _b1)
        | (`Eq (_a0,_a1),`Eq (_b0,_b1)) ->
            (self#class_expr _a0 _b0) && (self#class_expr _a1 _b1)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result49)
        | (_,_) -> false
    method class_str_item : class_str_item -> class_str_item -> 'result50=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#nil as _a0),(#nil as _b0)) -> (self#nil _a0 _b0 :>'result50)
        | (`Sem (_a0,_a1),`Sem (_b0,_b1)) ->
            (self#class_str_item _a0 _b0) && (self#class_str_item _a1 _b1)
        | (`Eq (_a0,_a1),`Eq (_b0,_b1)) ->
            (self#ctyp _a0 _b0) && (self#ctyp _a1 _b1)
        | (`Inherit (_a0,_a1,_a2),`Inherit (_b0,_b1,_b2)) ->
            ((self#override_flag _a0 _b0) && (self#class_expr _a1 _b1)) &&
              (self#meta_option (fun self  -> self#alident) _a2 _b2)
        | (`Initializer _a0,`Initializer _b0) -> self#expr _a0 _b0
        | (`CrMth (_a0,_a1,_a2,_a3,_a4),`CrMth (_b0,_b1,_b2,_b3,_b4)) ->
            ((((self#alident _a0 _b0) && (self#override_flag _a1 _b1)) &&
                (self#private_flag _a2 _b2))
               && (self#expr _a3 _b3))
              && (self#ctyp _a4 _b4)
        | (`CrVal (_a0,_a1,_a2,_a3),`CrVal (_b0,_b1,_b2,_b3)) ->
            (((self#alident _a0 _b0) && (self#override_flag _a1 _b1)) &&
               (self#mutable_flag _a2 _b2))
              && (self#expr _a3 _b3)
        | (`CrVir (_a0,_a1,_a2),`CrVir (_b0,_b1,_b2)) ->
            ((self#alident _a0 _b0) && (self#private_flag _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | (`CrVvr (_a0,_a1,_a2),`CrVvr (_b0,_b1,_b2)) ->
            ((self#alident _a0 _b0) && (self#mutable_flag _a1 _b1)) &&
              (self#ctyp _a2 _b2)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result50)
        | (_,_) -> false
    method ep : ep -> ep -> 'result51=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#nil as _a0),(#nil as _b0)) -> (self#nil _a0 _b0 :>'result51)
        | ((#sid as _a0),(#sid as _b0)) -> (self#sid _a0 _b0 :>'result51)
        | (`App (_a0,_a1),`App (_b0,_b1)) ->
            (self#ep _a0 _b0) && (self#ep _a1 _b1)
        | (`Vrn _a0,`Vrn _b0) -> self#string _a0 _b0
        | (`Com (_a0,_a1),`Com (_b0,_b1)) ->
            (self#ep _a0 _b0) && (self#ep _a1 _b1)
        | (`Sem (_a0,_a1),`Sem (_b0,_b1)) ->
            (self#ep _a0 _b0) && (self#ep _a1 _b1)
        | (`Tup _a0,`Tup _b0) -> self#ep _a0 _b0
        | ((#any as _a0),(#any as _b0)) -> (self#any _a0 _b0 :>'result51)
        | (`Array _a0,`Array _b0) -> self#ep _a0 _b0
        | (`Record _a0,`Record _b0) -> self#rec_bind _a0 _b0
        | ((#literal as _a0),(#literal as _b0)) ->
            (self#literal _a0 _b0 :>'result51)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result51)
        | (_,_) -> false
    method rec_bind : rec_bind -> rec_bind -> 'result52=
      fun _a0  _b0  ->
        match (_a0, _b0) with
        | ((#nil as _a0),(#nil as _b0)) -> (self#nil _a0 _b0 :>'result52)
        | (`RecBind (_a0,_a1),`RecBind (_b0,_b1)) ->
            (self#ident _a0 _b0) && (self#ep _a1 _b1)
        | (`Sem (_a0,_a1),`Sem (_b0,_b1)) ->
            (self#rec_bind _a0 _b0) && (self#rec_bind _a1 _b1)
        | ((#any as _a0),(#any as _b0)) -> (self#any _a0 _b0 :>'result52)
        | ((#ant as _a0),(#ant as _b0)) -> (self#ant _a0 _b0 :>'result52)
        | (_,_) -> false
    method fanloc_t : FanLoc.t -> FanLoc.t -> 'result53= self#unknown
    method fanutil_anti_cxt :
      FanUtil.anti_cxt -> FanUtil.anti_cxt -> 'result54= self#unknown
  end
class print =
  object (self : 'self_type)
    inherit  printbase
    method loc : 'fmt -> loc -> 'result55=
      fun fmt  _a0  -> self#fanloc_t fmt _a0
    method ant : 'fmt -> ant -> 'result56=
      fun fmt  (`Ant (_a0,_a1))  ->
        Format.fprintf fmt "@[<1>(`Ant@ %a@ %a)@]" self#loc _a0
          self#fanutil_anti_cxt _a1
    method nil : 'fmt -> nil -> 'result57=
      fun fmt  `Nil  -> Format.fprintf fmt "`Nil"
    method ant_nil : 'fmt -> ant_nil -> 'result58=
      fun fmt  ->
        function
        | #ant as _a0 -> (self#ant fmt _a0 :>'result58)
        | #nil as _a0 -> (self#nil fmt _a0 :>'result58)
    method literal : 'fmt -> literal -> 'result59=
      fun fmt  ->
        function
        | `Chr _a0 -> Format.fprintf fmt "@[<1>(`Chr@ %a)@]" self#string _a0
        | `Int _a0 -> Format.fprintf fmt "@[<1>(`Int@ %a)@]" self#string _a0
        | `Int32 _a0 ->
            Format.fprintf fmt "@[<1>(`Int32@ %a)@]" self#string _a0
        | `Int64 _a0 ->
            Format.fprintf fmt "@[<1>(`Int64@ %a)@]" self#string _a0
        | `Flo _a0 -> Format.fprintf fmt "@[<1>(`Flo@ %a)@]" self#string _a0
        | `NativeInt _a0 ->
            Format.fprintf fmt "@[<1>(`NativeInt@ %a)@]" self#string _a0
        | `Str _a0 -> Format.fprintf fmt "@[<1>(`Str@ %a)@]" self#string _a0
    method rec_flag : 'fmt -> rec_flag -> 'result60=
      fun fmt  ->
        function
        | `Recursive -> Format.fprintf fmt "`Recursive"
        | `ReNil -> Format.fprintf fmt "`ReNil"
        | #ant as _a0 -> (self#ant fmt _a0 :>'result60)
    method direction_flag : 'fmt -> direction_flag -> 'result61=
      fun fmt  ->
        function
        | `To -> Format.fprintf fmt "`To"
        | `Downto -> Format.fprintf fmt "`Downto"
        | #ant as _a0 -> (self#ant fmt _a0 :>'result61)
    method mutable_flag : 'fmt -> mutable_flag -> 'result62=
      fun fmt  ->
        function
        | `Mutable -> Format.fprintf fmt "`Mutable"
        | `MuNil -> Format.fprintf fmt "`MuNil"
        | #ant as _a0 -> (self#ant fmt _a0 :>'result62)
    method private_flag : 'fmt -> private_flag -> 'result63=
      fun fmt  ->
        function
        | `Private -> Format.fprintf fmt "`Private"
        | `PrNil -> Format.fprintf fmt "`PrNil"
        | #ant as _a0 -> (self#ant fmt _a0 :>'result63)
    method virtual_flag : 'fmt -> virtual_flag -> 'result64=
      fun fmt  ->
        function
        | `Virtual -> Format.fprintf fmt "`Virtual"
        | `ViNil -> Format.fprintf fmt "`ViNil"
        | #ant as _a0 -> (self#ant fmt _a0 :>'result64)
    method override_flag : 'fmt -> override_flag -> 'result65=
      fun fmt  ->
        function
        | `Override -> Format.fprintf fmt "`Override"
        | `OvNil -> Format.fprintf fmt "`OvNil"
        | #ant as _a0 -> (self#ant fmt _a0 :>'result65)
    method row_var_flag : 'fmt -> row_var_flag -> 'result66=
      fun fmt  ->
        function
        | `RowVar -> Format.fprintf fmt "`RowVar"
        | `RvNil -> Format.fprintf fmt "`RvNil"
        | #ant as _a0 -> (self#ant fmt _a0 :>'result66)
    method position_flag : 'fmt -> position_flag -> 'result67=
      fun fmt  ->
        function
        | `Positive -> Format.fprintf fmt "`Positive"
        | `Negative -> Format.fprintf fmt "`Negative"
        | `Normal -> Format.fprintf fmt "`Normal"
        | #ant as _a0 -> (self#ant fmt _a0 :>'result67)
    method meta_bool : 'fmt -> meta_bool -> 'result68=
      fun fmt  ->
        function
        | `True -> Format.fprintf fmt "`True"
        | `False -> Format.fprintf fmt "`False"
        | #ant as _a0 -> (self#ant fmt _a0 :>'result68)
    method meta_option :
      'all_a0 .
        ('self_type -> 'fmt -> 'all_a0 -> 'result69) ->
          'fmt -> 'all_a0 meta_option -> 'result69=
      fun mf_a  fmt  ->
        function
        | `None -> Format.fprintf fmt "`None"
        | `Some _a0 ->
            Format.fprintf fmt "@[<1>(`Some@ %a)@]" (mf_a self) _a0
        | #ant as _a0 -> (self#ant fmt _a0 :>'result69)
    method meta_list :
      'all_a0 .
        ('self_type -> 'fmt -> 'all_a0 -> 'result70) ->
          'fmt -> 'all_a0 meta_list -> 'result70=
      fun mf_a  fmt  ->
        function
        | `LNil -> Format.fprintf fmt "`LNil"
        | `LCons (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`LCons@ %a@ %a)@]" (mf_a self) _a0
              (self#meta_list mf_a) _a1
        | #ant as _a0 -> (self#ant fmt _a0 :>'result70)
    method alident : 'fmt -> alident -> 'result71=
      fun fmt  ->
        function
        | `Lid _a0 -> Format.fprintf fmt "@[<1>(`Lid@ %a)@]" self#string _a0
        | #ant as _a0 -> (self#ant fmt _a0 :>'result71)
    method auident : 'fmt -> auident -> 'result72=
      fun fmt  ->
        function
        | `Uid _a0 -> Format.fprintf fmt "@[<1>(`Uid@ %a)@]" self#string _a0
        | #ant as _a0 -> (self#ant fmt _a0 :>'result72)
    method aident : 'fmt -> aident -> 'result73=
      fun fmt  ->
        function
        | #alident as _a0 -> (self#alident fmt _a0 :>'result73)
        | #auident as _a0 -> (self#auident fmt _a0 :>'result73)
    method astring : 'fmt -> astring -> 'result74=
      fun fmt  ->
        function
        | `C _a0 -> Format.fprintf fmt "@[<1>(`C@ %a)@]" self#string _a0
        | #ant as _a0 -> (self#ant fmt _a0 :>'result74)
    method uident : 'fmt -> uident -> 'result75=
      fun fmt  ->
        function
        | `Dot (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Dot@ %a@ %a)@]" self#uident _a0
              self#uident _a1
        | `App (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`App@ %a@ %a)@]" self#uident _a0
              self#uident _a1
        | #auident as _a0 -> (self#auident fmt _a0 :>'result75)
    method ident : 'fmt -> ident -> 'result76=
      fun fmt  ->
        function
        | `Dot (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Dot@ %a@ %a)@]" self#ident _a0
              self#ident _a1
        | `App (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`App@ %a@ %a)@]" self#ident _a0
              self#ident _a1
        | #alident as _a0 -> (self#alident fmt _a0 :>'result76)
        | #auident as _a0 -> (self#auident fmt _a0 :>'result76)
    method dupath : 'fmt -> dupath -> 'result77=
      fun fmt  ->
        function
        | `Dot (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Dot@ %a@ %a)@]" self#dupath _a0
              self#dupath _a1
        | #auident as _a0 -> (self#auident fmt _a0 :>'result77)
    method dlpath : 'fmt -> dlpath -> 'result78=
      fun fmt  ->
        function
        | `Dot (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Dot@ %a@ %a)@]" self#dupath _a0
              self#alident _a1
        | #alident as _a0 -> (self#alident fmt _a0 :>'result78)
    method sid : 'fmt -> sid -> 'result79=
      fun fmt  (`Id _a0)  ->
        Format.fprintf fmt "@[<1>(`Id@ %a)@]" self#ident _a0
    method any : 'fmt -> any -> 'result80=
      fun fmt  `Any  -> Format.fprintf fmt "`Any"
    method ctyp : 'fmt -> ctyp -> 'result81=
      fun fmt  ->
        function
        | #nil as _a0 -> (self#nil fmt _a0 :>'result81)
        | `Alias (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Alias@ %a@ %a)@]" self#ctyp _a0
              self#alident _a1
        | #any as _a0 -> (self#any fmt _a0 :>'result81)
        | `App (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`App@ %a@ %a)@]" self#ctyp _a0
              self#ctyp _a1
        | `Arrow (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Arrow@ %a@ %a)@]" self#ctyp _a0
              self#ctyp _a1
        | `ClassPath _a0 ->
            Format.fprintf fmt "@[<1>(`ClassPath@ %a)@]" self#ident _a0
        | `Label (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Label@ %a@ %a)@]" self#alident _a0
              self#ctyp _a1
        | `OptLabl (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`OptLabl@ %a@ %a)@]" self#alident _a0
              self#ctyp _a1
        | #sid as _a0 -> (self#sid fmt _a0 :>'result81)
        | `TyObj (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`TyObj@ %a@ %a)@]" self#name_ctyp _a0
              self#row_var_flag _a1
        | `TyPol (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`TyPol@ %a@ %a)@]" self#ctyp _a0
              self#ctyp _a1
        | `TyTypePol (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`TyTypePol@ %a@ %a)@]" self#ctyp _a0
              self#ctyp _a1
        | `Quote (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Quote@ %a@ %a)@]" self#position_flag
              _a0 (self#meta_option (fun self  -> self#alident)) _a1
        | `Com (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Com@ %a@ %a)@]" self#ctyp _a0
              self#ctyp _a1
        | `Tup _a0 -> Format.fprintf fmt "@[<1>(`Tup@ %a)@]" self#ctyp _a0
        | `Sta (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Sta@ %a@ %a)@]" self#ctyp _a0
              self#ctyp _a1
        | `PolyEq _a0 ->
            Format.fprintf fmt "@[<1>(`PolyEq@ %a)@]" self#row_field _a0
        | `PolySup _a0 ->
            Format.fprintf fmt "@[<1>(`PolySup@ %a)@]" self#row_field _a0
        | `PolyInf _a0 ->
            Format.fprintf fmt "@[<1>(`PolyInf@ %a)@]" self#row_field _a0
        | `PolyInfSup (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`PolyInfSup@ %a@ %a)@]" self#row_field
              _a0 self#tag_names _a1
        | `Package _a0 ->
            Format.fprintf fmt "@[<1>(`Package@ %a)@]" self#module_type _a0
        | #ant as _a0 -> (self#ant fmt _a0 :>'result81)
    method row_field : 'fmt -> row_field -> 'result82=
      fun fmt  ->
        function
        | #ant_nil as _a0 -> (self#ant_nil fmt _a0 :>'result82)
        | `Or (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Or@ %a@ %a)@]" self#row_field _a0
              self#row_field _a1
        | `TyVrn _a0 ->
            Format.fprintf fmt "@[<1>(`TyVrn@ %a)@]" self#astring _a0
        | `TyVrnOf (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`TyVrnOf@ %a@ %a)@]" self#astring _a0
              self#ctyp _a1
        | `Ctyp _a0 -> Format.fprintf fmt "@[<1>(`Ctyp@ %a)@]" self#ctyp _a0
    method tag_names : 'fmt -> tag_names -> 'result83=
      fun fmt  ->
        function
        | #ant_nil as _a0 -> (self#ant_nil fmt _a0 :>'result83)
        | `App (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`App@ %a@ %a)@]" self#tag_names _a0
              self#tag_names _a1
        | `TyVrn _a0 ->
            Format.fprintf fmt "@[<1>(`TyVrn@ %a)@]" self#astring _a0
    method typedecl : 'fmt -> typedecl -> 'result84=
      fun fmt  ->
        function
        | `TyDcl (_a0,_a1,_a2,_a3) ->
            Format.fprintf fmt "@[<1>(`TyDcl@ %a@ %a@ %a@ %a)@]" self#alident
              _a0 (self#list (fun self  -> self#ctyp)) _a1 self#type_info _a2
              (self#list
                 (fun self  fmt  (_a0,_a1)  ->
                    Format.fprintf fmt "@[<1>(%a,@,%a)@]" self#ctyp _a0
                      self#ctyp _a1)) _a3
        | `And (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`And@ %a@ %a)@]" self#typedecl _a0
              self#typedecl _a1
        | #ant_nil as _a0 -> (self#ant_nil fmt _a0 :>'result84)
    method type_info : 'fmt -> type_info -> 'result85=
      fun fmt  ->
        function
        | `TyMan (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`TyMan@ %a@ %a@ %a)@]" self#ctyp _a0
              self#private_flag _a1 self#type_repr _a2
        | `TyRepr (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`TyRepr@ %a@ %a)@]" self#private_flag
              _a0 self#type_repr _a1
        | `TyEq (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`TyEq@ %a@ %a)@]" self#private_flag _a0
              self#ctyp _a1
        | #ant_nil as _a0 -> (self#ant_nil fmt _a0 :>'result85)
    method type_repr : 'fmt -> type_repr -> 'result86=
      fun fmt  ->
        function
        | `Record _a0 ->
            Format.fprintf fmt "@[<1>(`Record@ %a)@]" self#name_ctyp _a0
        | `Sum _a0 -> Format.fprintf fmt "@[<1>(`Sum@ %a)@]" self#or_ctyp _a0
        | #ant_nil as _a0 -> (self#ant_nil fmt _a0 :>'result86)
    method name_ctyp : 'fmt -> name_ctyp -> 'result87=
      fun fmt  ->
        function
        | `Sem (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Sem@ %a@ %a)@]" self#name_ctyp _a0
              self#name_ctyp _a1
        | `TyCol (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`TyCol@ %a@ %a)@]" self#sid _a0
              self#ctyp _a1
        | `TyColMut (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`TyColMut@ %a@ %a)@]" self#sid _a0
              self#ctyp _a1
        | #ant_nil as _a0 -> (self#ant_nil fmt _a0 :>'result87)
    method or_ctyp : 'fmt -> or_ctyp -> 'result88=
      fun fmt  ->
        function
        | `Or (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Or@ %a@ %a)@]" self#or_ctyp _a0
              self#or_ctyp _a1
        | `TyCol (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`TyCol@ %a@ %a)@]" self#sid _a0
              self#ctyp _a1
        | `Of (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Of@ %a@ %a)@]" self#sid _a0 self#ctyp
              _a1
        | #sid as _a0 -> (self#sid fmt _a0 :>'result88)
        | #ant_nil as _a0 -> (self#ant_nil fmt _a0 :>'result88)
    method of_ctyp : 'fmt -> of_ctyp -> 'result89=
      fun fmt  ->
        function
        | `Of (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Of@ %a@ %a)@]" self#sid _a0 self#ctyp
              _a1
        | #sid as _a0 -> (self#sid fmt _a0 :>'result89)
        | #ant_nil as _a0 -> (self#ant_nil fmt _a0 :>'result89)
    method patt : 'fmt -> patt -> 'result90=
      fun fmt  ->
        function
        | #nil as _a0 -> (self#nil fmt _a0 :>'result90)
        | #sid as _a0 -> (self#sid fmt _a0 :>'result90)
        | `App (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`App@ %a@ %a)@]" self#patt _a0
              self#patt _a1
        | `Vrn _a0 -> Format.fprintf fmt "@[<1>(`Vrn@ %a)@]" self#string _a0
        | `Com (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Com@ %a@ %a)@]" self#patt _a0
              self#patt _a1
        | `Sem (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Sem@ %a@ %a)@]" self#patt _a0
              self#patt _a1
        | `Tup _a0 -> Format.fprintf fmt "@[<1>(`Tup@ %a)@]" self#patt _a0
        | #any as _a0 -> (self#any fmt _a0 :>'result90)
        | `Record _a0 ->
            Format.fprintf fmt "@[<1>(`Record@ %a)@]" self#rec_patt _a0
        | #ant as _a0 -> (self#ant fmt _a0 :>'result90)
        | #literal as _a0 -> (self#literal fmt _a0 :>'result90)
        | `Alias (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Alias@ %a@ %a)@]" self#patt _a0
              self#alident _a1
        | `Array _a0 ->
            Format.fprintf fmt "@[<1>(`Array@ %a)@]" self#patt _a0
        | `Label (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Label@ %a@ %a)@]" self#alident _a0
              self#patt _a1
        | `PaOlbi (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`PaOlbi@ %a@ %a@ %a)@]" self#alident
              _a0 self#patt _a1 (self#meta_option (fun self  -> self#expr))
              _a2
        | `Or (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Or@ %a@ %a)@]" self#patt _a0 self#patt
              _a1
        | `PaRng (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`PaRng@ %a@ %a)@]" self#patt _a0
              self#patt _a1
        | `Constraint (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Constraint@ %a@ %a)@]" self#patt _a0
              self#ctyp _a1
        | `ClassPath _a0 ->
            Format.fprintf fmt "@[<1>(`ClassPath@ %a)@]" self#ident _a0
        | `Lazy _a0 -> Format.fprintf fmt "@[<1>(`Lazy@ %a)@]" self#patt _a0
        | `ModuleUnpack (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`ModuleUnpack@ %a@ %a)@]" self#auident
              _a0 (self#meta_option (fun self  -> self#ctyp)) _a1
    method rec_patt : 'fmt -> rec_patt -> 'result91=
      fun fmt  ->
        function
        | #nil as _a0 -> (self#nil fmt _a0 :>'result91)
        | `RecBind (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`RecBind@ %a@ %a)@]" self#ident _a0
              self#patt _a1
        | `Sem (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Sem@ %a@ %a)@]" self#rec_patt _a0
              self#rec_patt _a1
        | #any as _a0 -> (self#any fmt _a0 :>'result91)
        | #ant as _a0 -> (self#ant fmt _a0 :>'result91)
    method expr : 'fmt -> expr -> 'result92=
      fun fmt  ->
        function
        | #nil as _a0 -> (self#nil fmt _a0 :>'result92)
        | #sid as _a0 -> (self#sid fmt _a0 :>'result92)
        | `App (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`App@ %a@ %a)@]" self#expr _a0
              self#expr _a1
        | `Vrn _a0 -> Format.fprintf fmt "@[<1>(`Vrn@ %a)@]" self#string _a0
        | `Com (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Com@ %a@ %a)@]" self#expr _a0
              self#expr _a1
        | `Sem (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Sem@ %a@ %a)@]" self#expr _a0
              self#expr _a1
        | `Tup _a0 -> Format.fprintf fmt "@[<1>(`Tup@ %a)@]" self#expr _a0
        | #any as _a0 -> (self#any fmt _a0 :>'result92)
        | `Record _a0 ->
            Format.fprintf fmt "@[<1>(`Record@ %a)@]" self#rec_expr _a0
        | #ant as _a0 -> (self#ant fmt _a0 :>'result92)
        | #literal as _a0 -> (self#literal fmt _a0 :>'result92)
        | `RecordWith (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`RecordWith@ %a@ %a)@]" self#rec_expr
              _a0 self#expr _a1
        | `Dot (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Dot@ %a@ %a)@]" self#expr _a0
              self#expr _a1
        | `ArrayDot (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`ArrayDot@ %a@ %a)@]" self#expr _a0
              self#expr _a1
        | `Array _a0 ->
            Format.fprintf fmt "@[<1>(`Array@ %a)@]" self#expr _a0
        | `ExAsf -> Format.fprintf fmt "`ExAsf"
        | `ExAsr _a0 ->
            Format.fprintf fmt "@[<1>(`ExAsr@ %a)@]" self#expr _a0
        | `Assign (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Assign@ %a@ %a)@]" self#expr _a0
              self#expr _a1
        | `For (_a0,_a1,_a2,_a3,_a4) ->
            Format.fprintf fmt "@[<1>(`For@ %a@ %a@ %a@ %a@ %a)@]"
              self#alident _a0 self#expr _a1 self#expr _a2
              self#direction_flag _a3 self#expr _a4
        | `Fun _a0 ->
            Format.fprintf fmt "@[<1>(`Fun@ %a)@]" self#match_case _a0
        | `IfThenElse (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`IfThenElse@ %a@ %a@ %a)@]" self#expr
              _a0 self#expr _a1 self#expr _a2
        | `IfThen (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`IfThen@ %a@ %a)@]" self#expr _a0
              self#expr _a1
        | `Label (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Label@ %a@ %a)@]" self#alident _a0
              self#expr _a1
        | `Lazy _a0 -> Format.fprintf fmt "@[<1>(`Lazy@ %a)@]" self#expr _a0
        | `LetIn (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`LetIn@ %a@ %a@ %a)@]" self#rec_flag
              _a0 self#binding _a1 self#expr _a2
        | `LetModule (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`LetModule@ %a@ %a@ %a)@]" self#auident
              _a0 self#module_expr _a1 self#expr _a2
        | `Match (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Match@ %a@ %a)@]" self#expr _a0
              self#match_case _a1
        | `New _a0 -> Format.fprintf fmt "@[<1>(`New@ %a)@]" self#ident _a0
        | `Obj (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Obj@ %a@ %a)@]" self#patt _a0
              self#class_str_item _a1
        | `OptLabl (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`OptLabl@ %a@ %a)@]" self#alident _a0
              self#expr _a1
        | `OvrInst _a0 ->
            Format.fprintf fmt "@[<1>(`OvrInst@ %a)@]" self#rec_expr _a0
        | `Seq _a0 -> Format.fprintf fmt "@[<1>(`Seq@ %a)@]" self#expr _a0
        | `Send (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Send@ %a@ %a)@]" self#expr _a0
              self#alident _a1
        | `StringDot (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`StringDot@ %a@ %a)@]" self#expr _a0
              self#expr _a1
        | `Try (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Try@ %a@ %a)@]" self#expr _a0
              self#match_case _a1
        | `Constraint (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Constraint@ %a@ %a)@]" self#expr _a0
              self#ctyp _a1
        | `Coercion (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Coercion@ %a@ %a@ %a)@]" self#expr _a0
              self#ctyp _a1 self#ctyp _a2
        | `While (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`While@ %a@ %a)@]" self#expr _a0
              self#expr _a1
        | `LetOpen (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`LetOpen@ %a@ %a)@]" self#ident _a0
              self#expr _a1
        | `LocalTypeFun (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`LocalTypeFun@ %a@ %a)@]" self#alident
              _a0 self#expr _a1
        | `Package_expr _a0 ->
            Format.fprintf fmt "@[<1>(`Package_expr@ %a)@]" self#module_expr
              _a0
    method rec_expr : 'fmt -> rec_expr -> 'result93=
      fun fmt  ->
        function
        | #nil as _a0 -> (self#nil fmt _a0 :>'result93)
        | `Sem (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Sem@ %a@ %a)@]" self#rec_expr _a0
              self#rec_expr _a1
        | `RecBind (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`RecBind@ %a@ %a)@]" self#ident _a0
              self#expr _a1
        | #any as _a0 -> (self#any fmt _a0 :>'result93)
        | #ant as _a0 -> (self#ant fmt _a0 :>'result93)
    method module_type : 'fmt -> module_type -> 'result94=
      fun fmt  ->
        function
        | #nil as _a0 -> (self#nil fmt _a0 :>'result94)
        | #sid as _a0 -> (self#sid fmt _a0 :>'result94)
        | `MtFun (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`MtFun@ %a@ %a@ %a)@]" self#auident _a0
              self#module_type _a1 self#module_type _a2
        | `Sig _a0 ->
            Format.fprintf fmt "@[<1>(`Sig@ %a)@]" self#sig_item _a0
        | `With (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`With@ %a@ %a)@]" self#module_type _a0
              self#with_constr _a1
        | `ModuleTypeOf _a0 ->
            Format.fprintf fmt "@[<1>(`ModuleTypeOf@ %a)@]" self#module_expr
              _a0
        | #ant as _a0 -> (self#ant fmt _a0 :>'result94)
    method sig_item : 'fmt -> sig_item -> 'result95=
      fun fmt  ->
        function
        | #nil as _a0 -> (self#nil fmt _a0 :>'result95)
        | `Class _a0 ->
            Format.fprintf fmt "@[<1>(`Class@ %a)@]" self#class_type _a0
        | `ClassType _a0 ->
            Format.fprintf fmt "@[<1>(`ClassType@ %a)@]" self#class_type _a0
        | `Sem (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Sem@ %a@ %a)@]" self#sig_item _a0
              self#sig_item _a1
        | `Directive (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Directive@ %a@ %a)@]" self#alident _a0
              self#expr _a1
        | `Exception _a0 ->
            Format.fprintf fmt "@[<1>(`Exception@ %a)@]" self#of_ctyp _a0
        | `External (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`External@ %a@ %a@ %a)@]" self#alident
              _a0 self#ctyp _a1 (self#meta_list (fun self  -> self#string))
              _a2
        | `Include _a0 ->
            Format.fprintf fmt "@[<1>(`Include@ %a)@]" self#module_type _a0
        | `Module (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Module@ %a@ %a)@]" self#auident _a0
              self#module_type _a1
        | `RecModule _a0 ->
            Format.fprintf fmt "@[<1>(`RecModule@ %a)@]" self#module_binding
              _a0
        | `ModuleType (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`ModuleType@ %a@ %a)@]" self#auident
              _a0 self#module_type _a1
        | `Open _a0 -> Format.fprintf fmt "@[<1>(`Open@ %a)@]" self#ident _a0
        | `Type _a0 ->
            Format.fprintf fmt "@[<1>(`Type@ %a)@]" self#typedecl _a0
        | `Val (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Val@ %a@ %a)@]" self#alident _a0
              self#ctyp _a1
        | #ant as _a0 -> (self#ant fmt _a0 :>'result95)
    method with_constr : 'fmt -> with_constr -> 'result96=
      fun fmt  ->
        function
        | #nil as _a0 -> (self#nil fmt _a0 :>'result96)
        | `TypeEq (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`TypeEq@ %a@ %a)@]" self#ctyp _a0
              self#ctyp _a1
        | `TypeEqPriv (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`TypeEqPriv@ %a@ %a)@]" self#ctyp _a0
              self#ctyp _a1
        | `ModuleEq (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`ModuleEq@ %a@ %a)@]" self#ident _a0
              self#ident _a1
        | `TypeSubst (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`TypeSubst@ %a@ %a)@]" self#ctyp _a0
              self#ctyp _a1
        | `ModuleSubst (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`ModuleSubst@ %a@ %a)@]" self#ident _a0
              self#ident _a1
        | `And (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`And@ %a@ %a)@]" self#with_constr _a0
              self#with_constr _a1
        | #ant as _a0 -> (self#ant fmt _a0 :>'result96)
    method binding : 'fmt -> binding -> 'result97=
      fun fmt  ->
        function
        | #nil as _a0 -> (self#nil fmt _a0 :>'result97)
        | `And (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`And@ %a@ %a)@]" self#binding _a0
              self#binding _a1
        | `Bind (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Bind@ %a@ %a)@]" self#patt _a0
              self#expr _a1
        | #ant as _a0 -> (self#ant fmt _a0 :>'result97)
    method module_binding : 'fmt -> module_binding -> 'result98=
      fun fmt  ->
        function
        | #nil as _a0 -> (self#nil fmt _a0 :>'result98)
        | `And (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`And@ %a@ %a)@]" self#module_binding
              _a0 self#module_binding _a1
        | `ModuleBind (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`ModuleBind@ %a@ %a@ %a)@]"
              self#auident _a0 self#module_type _a1 self#module_expr _a2
        | `Constraint (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Constraint@ %a@ %a)@]" self#auident
              _a0 self#module_type _a1
        | #ant as _a0 -> (self#ant fmt _a0 :>'result98)
    method match_case : 'fmt -> match_case -> 'result99=
      fun fmt  ->
        function
        | #nil as _a0 -> (self#nil fmt _a0 :>'result99)
        | `Or (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Or@ %a@ %a)@]" self#match_case _a0
              self#match_case _a1
        | `Case (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Case@ %a@ %a@ %a)@]" self#patt _a0
              self#expr _a1 self#expr _a2
        | #ant as _a0 -> (self#ant fmt _a0 :>'result99)
    method module_expr : 'fmt -> module_expr -> 'result100=
      fun fmt  ->
        function
        | #nil as _a0 -> (self#nil fmt _a0 :>'result100)
        | #sid as _a0 -> (self#sid fmt _a0 :>'result100)
        | `App (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`App@ %a@ %a)@]" self#module_expr _a0
              self#module_expr _a1
        | `Functor (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Functor@ %a@ %a@ %a)@]" self#auident
              _a0 self#module_type _a1 self#module_expr _a2
        | `Struct _a0 ->
            Format.fprintf fmt "@[<1>(`Struct@ %a)@]" self#str_item _a0
        | `Constraint (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Constraint@ %a@ %a)@]"
              self#module_expr _a0 self#module_type _a1
        | `PackageModule _a0 ->
            Format.fprintf fmt "@[<1>(`PackageModule@ %a)@]" self#expr _a0
        | #ant as _a0 -> (self#ant fmt _a0 :>'result100)
    method str_item : 'fmt -> str_item -> 'result101=
      fun fmt  ->
        function
        | #nil as _a0 -> (self#nil fmt _a0 :>'result101)
        | `Class _a0 ->
            Format.fprintf fmt "@[<1>(`Class@ %a)@]" self#class_expr _a0
        | `ClassType _a0 ->
            Format.fprintf fmt "@[<1>(`ClassType@ %a)@]" self#class_type _a0
        | `Sem (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Sem@ %a@ %a)@]" self#str_item _a0
              self#str_item _a1
        | `Directive (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Directive@ %a@ %a)@]" self#alident _a0
              self#expr _a1
        | `Exception _a0 ->
            Format.fprintf fmt "@[<1>(`Exception@ %a)@]" self#of_ctyp _a0
        | `StExp _a0 ->
            Format.fprintf fmt "@[<1>(`StExp@ %a)@]" self#expr _a0
        | `External (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`External@ %a@ %a@ %a)@]" self#alident
              _a0 self#ctyp _a1 (self#meta_list (fun self  -> self#string))
              _a2
        | `Include _a0 ->
            Format.fprintf fmt "@[<1>(`Include@ %a)@]" self#module_expr _a0
        | `Module (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Module@ %a@ %a)@]" self#auident _a0
              self#module_expr _a1
        | `RecModule _a0 ->
            Format.fprintf fmt "@[<1>(`RecModule@ %a)@]" self#module_binding
              _a0
        | `ModuleType (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`ModuleType@ %a@ %a)@]" self#auident
              _a0 self#module_type _a1
        | `Open _a0 -> Format.fprintf fmt "@[<1>(`Open@ %a)@]" self#ident _a0
        | `Type _a0 ->
            Format.fprintf fmt "@[<1>(`Type@ %a)@]" self#typedecl _a0
        | `Value (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Value@ %a@ %a)@]" self#rec_flag _a0
              self#binding _a1
        | #ant as _a0 -> (self#ant fmt _a0 :>'result101)
    method class_type : 'fmt -> class_type -> 'result102=
      fun fmt  ->
        function
        | #nil as _a0 -> (self#nil fmt _a0 :>'result102)
        | `CtCon (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`CtCon@ %a@ %a@ %a)@]"
              self#virtual_flag _a0 self#ident _a1 self#ctyp _a2
        | `CtFun (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`CtFun@ %a@ %a)@]" self#ctyp _a0
              self#class_type _a1
        | `CtSig (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`CtSig@ %a@ %a)@]" self#ctyp _a0
              self#class_sig_item _a1
        | `And (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`And@ %a@ %a)@]" self#class_type _a0
              self#class_type _a1
        | `CtCol (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`CtCol@ %a@ %a)@]" self#class_type _a0
              self#class_type _a1
        | `CtEq (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`CtEq@ %a@ %a)@]" self#class_type _a0
              self#class_type _a1
        | #ant as _a0 -> (self#ant fmt _a0 :>'result102)
    method class_sig_item : 'fmt -> class_sig_item -> 'result103=
      fun fmt  ->
        function
        | #nil as _a0 -> (self#nil fmt _a0 :>'result103)
        | `Eq (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Eq@ %a@ %a)@]" self#ctyp _a0 self#ctyp
              _a1
        | `Sem (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Sem@ %a@ %a)@]" self#class_sig_item
              _a0 self#class_sig_item _a1
        | `SigInherit _a0 ->
            Format.fprintf fmt "@[<1>(`SigInherit@ %a)@]" self#class_type _a0
        | `Method (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Method@ %a@ %a@ %a)@]" self#alident
              _a0 self#private_flag _a1 self#ctyp _a2
        | `CgVal (_a0,_a1,_a2,_a3) ->
            Format.fprintf fmt "@[<1>(`CgVal@ %a@ %a@ %a@ %a)@]" self#alident
              _a0 self#mutable_flag _a1 self#virtual_flag _a2 self#ctyp _a3
        | `CgVir (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`CgVir@ %a@ %a@ %a)@]" self#alident _a0
              self#private_flag _a1 self#ctyp _a2
        | #ant as _a0 -> (self#ant fmt _a0 :>'result103)
    method class_expr : 'fmt -> class_expr -> 'result104=
      fun fmt  ->
        function
        | #nil as _a0 -> (self#nil fmt _a0 :>'result104)
        | `CeApp (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`CeApp@ %a@ %a)@]" self#class_expr _a0
              self#expr _a1
        | `CeCon (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`CeCon@ %a@ %a@ %a)@]"
              self#virtual_flag _a0 self#ident _a1 self#ctyp _a2
        | `CeFun (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`CeFun@ %a@ %a)@]" self#patt _a0
              self#class_expr _a1
        | `CeLet (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`CeLet@ %a@ %a@ %a)@]" self#rec_flag
              _a0 self#binding _a1 self#class_expr _a2
        | `Obj (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Obj@ %a@ %a)@]" self#patt _a0
              self#class_str_item _a1
        | `CeTyc (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`CeTyc@ %a@ %a)@]" self#class_expr _a0
              self#class_type _a1
        | `And (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`And@ %a@ %a)@]" self#class_expr _a0
              self#class_expr _a1
        | `Eq (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Eq@ %a@ %a)@]" self#class_expr _a0
              self#class_expr _a1
        | #ant as _a0 -> (self#ant fmt _a0 :>'result104)
    method class_str_item : 'fmt -> class_str_item -> 'result105=
      fun fmt  ->
        function
        | #nil as _a0 -> (self#nil fmt _a0 :>'result105)
        | `Sem (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Sem@ %a@ %a)@]" self#class_str_item
              _a0 self#class_str_item _a1
        | `Eq (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Eq@ %a@ %a)@]" self#ctyp _a0 self#ctyp
              _a1
        | `Inherit (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`Inherit@ %a@ %a@ %a)@]"
              self#override_flag _a0 self#class_expr _a1
              (self#meta_option (fun self  -> self#alident)) _a2
        | `Initializer _a0 ->
            Format.fprintf fmt "@[<1>(`Initializer@ %a)@]" self#expr _a0
        | `CrMth (_a0,_a1,_a2,_a3,_a4) ->
            Format.fprintf fmt "@[<1>(`CrMth@ %a@ %a@ %a@ %a@ %a)@]"
              self#alident _a0 self#override_flag _a1 self#private_flag _a2
              self#expr _a3 self#ctyp _a4
        | `CrVal (_a0,_a1,_a2,_a3) ->
            Format.fprintf fmt "@[<1>(`CrVal@ %a@ %a@ %a@ %a)@]" self#alident
              _a0 self#override_flag _a1 self#mutable_flag _a2 self#expr _a3
        | `CrVir (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`CrVir@ %a@ %a@ %a)@]" self#alident _a0
              self#private_flag _a1 self#ctyp _a2
        | `CrVvr (_a0,_a1,_a2) ->
            Format.fprintf fmt "@[<1>(`CrVvr@ %a@ %a@ %a)@]" self#alident _a0
              self#mutable_flag _a1 self#ctyp _a2
        | #ant as _a0 -> (self#ant fmt _a0 :>'result105)
    method ep : 'fmt -> ep -> 'result106=
      fun fmt  ->
        function
        | #nil as _a0 -> (self#nil fmt _a0 :>'result106)
        | #sid as _a0 -> (self#sid fmt _a0 :>'result106)
        | `App (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`App@ %a@ %a)@]" self#ep _a0 self#ep
              _a1
        | `Vrn _a0 -> Format.fprintf fmt "@[<1>(`Vrn@ %a)@]" self#string _a0
        | `Com (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Com@ %a@ %a)@]" self#ep _a0 self#ep
              _a1
        | `Sem (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Sem@ %a@ %a)@]" self#ep _a0 self#ep
              _a1
        | `Tup _a0 -> Format.fprintf fmt "@[<1>(`Tup@ %a)@]" self#ep _a0
        | #any as _a0 -> (self#any fmt _a0 :>'result106)
        | `Array _a0 -> Format.fprintf fmt "@[<1>(`Array@ %a)@]" self#ep _a0
        | `Record _a0 ->
            Format.fprintf fmt "@[<1>(`Record@ %a)@]" self#rec_bind _a0
        | #literal as _a0 -> (self#literal fmt _a0 :>'result106)
        | #ant as _a0 -> (self#ant fmt _a0 :>'result106)
    method rec_bind : 'fmt -> rec_bind -> 'result107=
      fun fmt  ->
        function
        | #nil as _a0 -> (self#nil fmt _a0 :>'result107)
        | `RecBind (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`RecBind@ %a@ %a)@]" self#ident _a0
              self#ep _a1
        | `Sem (_a0,_a1) ->
            Format.fprintf fmt "@[<1>(`Sem@ %a@ %a)@]" self#rec_bind _a0
              self#rec_bind _a1
        | #any as _a0 -> (self#any fmt _a0 :>'result107)
        | #ant as _a0 -> (self#ant fmt _a0 :>'result107)
    method fanloc_t : 'fmt -> FanLoc.t -> 'result108= self#unknown
    method fanutil_anti_cxt : 'fmt -> FanUtil.anti_cxt -> 'result109=
      self#unknown
  end
let meta_ant _loc (`Ant (_a0,_a1)) = `Ant (_a0, _a1)
let meta_nil _loc `Nil = `Vrn (_loc, "Nil")
let meta_ant_nil _loc =
  function
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result112)
  | #nil as _a0 -> (meta_nil _loc _a0 :>'result112)
let meta_literal _loc =
  function
  | `Chr _a0 -> `App (_loc, (`Vrn (_loc, "Chr")), (meta_string _loc _a0))
  | `Int _a0 -> `App (_loc, (`Vrn (_loc, "Int")), (meta_string _loc _a0))
  | `Int32 _a0 -> `App (_loc, (`Vrn (_loc, "Int32")), (meta_string _loc _a0))
  | `Int64 _a0 -> `App (_loc, (`Vrn (_loc, "Int64")), (meta_string _loc _a0))
  | `Flo _a0 -> `App (_loc, (`Vrn (_loc, "Flo")), (meta_string _loc _a0))
  | `NativeInt _a0 ->
      `App (_loc, (`Vrn (_loc, "NativeInt")), (meta_string _loc _a0))
  | `Str _a0 -> `App (_loc, (`Vrn (_loc, "Str")), (meta_string _loc _a0))
let meta_rec_flag _loc =
  function
  | `Recursive -> `Vrn (_loc, "Recursive")
  | `ReNil -> `Vrn (_loc, "ReNil")
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result114)
let meta_direction_flag _loc =
  function
  | `To -> `Vrn (_loc, "To")
  | `Downto -> `Vrn (_loc, "Downto")
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result115)
let meta_mutable_flag _loc =
  function
  | `Mutable -> `Vrn (_loc, "Mutable")
  | `MuNil -> `Vrn (_loc, "MuNil")
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result116)
let meta_private_flag _loc =
  function
  | `Private -> `Vrn (_loc, "Private")
  | `PrNil -> `Vrn (_loc, "PrNil")
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result117)
let meta_virtual_flag _loc =
  function
  | `Virtual -> `Vrn (_loc, "Virtual")
  | `ViNil -> `Vrn (_loc, "ViNil")
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result118)
let meta_override_flag _loc =
  function
  | `Override -> `Vrn (_loc, "Override")
  | `OvNil -> `Vrn (_loc, "OvNil")
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result119)
let meta_row_var_flag _loc =
  function
  | `RowVar -> `Vrn (_loc, "RowVar")
  | `RvNil -> `Vrn (_loc, "RvNil")
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result120)
let meta_position_flag _loc =
  function
  | `Positive -> `Vrn (_loc, "Positive")
  | `Negative -> `Vrn (_loc, "Negative")
  | `Normal -> `Vrn (_loc, "Normal")
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result121)
let meta_meta_bool _loc =
  function
  | `True -> `Vrn (_loc, "True")
  | `False -> `Vrn (_loc, "False")
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result122)
let meta_meta_option mf_a _loc =
  function
  | `None -> `Vrn (_loc, "None")
  | `Some _a0 -> `App (_loc, (`Vrn (_loc, "Some")), (mf_a _loc _a0))
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result123)
let rec meta_meta_list mf_a _loc =
  function
  | `LNil -> `Vrn (_loc, "LNil")
  | `LCons (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "LCons")), (mf_a _loc _a0))),
          (meta_meta_list mf_a _loc _a1))
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result124)
let meta_alident _loc =
  function
  | `Lid _a0 -> `App (_loc, (`Vrn (_loc, "Lid")), (meta_string _loc _a0))
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result125)
let meta_auident _loc =
  function
  | `Uid _a0 -> `App (_loc, (`Vrn (_loc, "Uid")), (meta_string _loc _a0))
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result126)
let meta_aident _loc =
  function
  | #alident as _a0 -> (meta_alident _loc _a0 :>'result127)
  | #auident as _a0 -> (meta_auident _loc _a0 :>'result127)
let meta_astring _loc =
  function
  | `C _a0 -> `App (_loc, (`Vrn (_loc, "C")), (meta_string _loc _a0))
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result128)
let rec meta_uident _loc =
  function
  | `Dot (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Dot")), (meta_uident _loc _a0))),
          (meta_uident _loc _a1))
  | `App (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "App")), (meta_uident _loc _a0))),
          (meta_uident _loc _a1))
  | #auident as _a0 -> (meta_auident _loc _a0 :>'result129)
let rec meta_ident _loc =
  function
  | `Dot (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Dot")), (meta_ident _loc _a0))),
          (meta_ident _loc _a1))
  | `App (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "App")), (meta_ident _loc _a0))),
          (meta_ident _loc _a1))
  | #alident as _a0 -> (meta_alident _loc _a0 :>'result130)
  | #auident as _a0 -> (meta_auident _loc _a0 :>'result130)
let rec meta_dupath _loc =
  function
  | `Dot (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Dot")), (meta_dupath _loc _a0))),
          (meta_dupath _loc _a1))
  | #auident as _a0 -> (meta_auident _loc _a0 :>'result131)
let meta_dlpath _loc =
  function
  | `Dot (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Dot")), (meta_dupath _loc _a0))),
          (meta_alident _loc _a1))
  | #alident as _a0 -> (meta_alident _loc _a0 :>'result132)
let meta_sid _loc (`Id _a0) =
  `App (_loc, (`Vrn (_loc, "Id")), (meta_ident _loc _a0))
let meta_any _loc `Any = `Vrn (_loc, "Any")
let rec meta_ctyp _loc =
  function
  | #nil as _a0 -> (meta_nil _loc _a0 :>'result159)
  | `Alias (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Alias")), (meta_ctyp _loc _a0))),
          (meta_alident _loc _a1))
  | #any as _a0 -> (meta_any _loc _a0 :>'result159)
  | `App (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "App")), (meta_ctyp _loc _a0))),
          (meta_ctyp _loc _a1))
  | `Arrow (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Arrow")), (meta_ctyp _loc _a0))),
          (meta_ctyp _loc _a1))
  | `ClassPath _a0 ->
      `App (_loc, (`Vrn (_loc, "ClassPath")), (meta_ident _loc _a0))
  | `Label (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "Label")), (meta_alident _loc _a0))),
          (meta_ctyp _loc _a1))
  | `OptLabl (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "OptLabl")), (meta_alident _loc _a0))),
          (meta_ctyp _loc _a1))
  | #sid as _a0 -> (meta_sid _loc _a0 :>'result159)
  | `TyObj (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "TyObj")), (meta_name_ctyp _loc _a0))),
          (meta_row_var_flag _loc _a1))
  | `TyPol (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "TyPol")), (meta_ctyp _loc _a0))),
          (meta_ctyp _loc _a1))
  | `TyTypePol (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "TyTypePol")), (meta_ctyp _loc _a0))),
          (meta_ctyp _loc _a1))
  | `Quote (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "Quote")), (meta_position_flag _loc _a0))),
          (meta_meta_option meta_alident _loc _a1))
  | `Com (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Com")), (meta_ctyp _loc _a0))),
          (meta_ctyp _loc _a1))
  | `Tup _a0 -> `App (_loc, (`Vrn (_loc, "Tup")), (meta_ctyp _loc _a0))
  | `Sta (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Sta")), (meta_ctyp _loc _a0))),
          (meta_ctyp _loc _a1))
  | `PolyEq _a0 ->
      `App (_loc, (`Vrn (_loc, "PolyEq")), (meta_row_field _loc _a0))
  | `PolySup _a0 ->
      `App (_loc, (`Vrn (_loc, "PolySup")), (meta_row_field _loc _a0))
  | `PolyInf _a0 ->
      `App (_loc, (`Vrn (_loc, "PolyInf")), (meta_row_field _loc _a0))
  | `PolyInfSup (_a0,_a1) ->
      `App
        (_loc,
          (`App
             (_loc, (`Vrn (_loc, "PolyInfSup")), (meta_row_field _loc _a0))),
          (meta_tag_names _loc _a1))
  | `Package _a0 ->
      `App (_loc, (`Vrn (_loc, "Package")), (meta_module_type _loc _a0))
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result159)
and meta_row_field _loc =
  function
  | #ant_nil as _a0 -> (meta_ant_nil _loc _a0 :>'result158)
  | `Or (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Or")), (meta_row_field _loc _a0))),
          (meta_row_field _loc _a1))
  | `TyVrn _a0 ->
      `App (_loc, (`Vrn (_loc, "TyVrn")), (meta_astring _loc _a0))
  | `TyVrnOf (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "TyVrnOf")), (meta_astring _loc _a0))),
          (meta_ctyp _loc _a1))
  | `Ctyp _a0 -> `App (_loc, (`Vrn (_loc, "Ctyp")), (meta_ctyp _loc _a0))
and meta_tag_names _loc =
  function
  | #ant_nil as _a0 -> (meta_ant_nil _loc _a0 :>'result157)
  | `App (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "App")), (meta_tag_names _loc _a0))),
          (meta_tag_names _loc _a1))
  | `TyVrn _a0 ->
      `App (_loc, (`Vrn (_loc, "TyVrn")), (meta_astring _loc _a0))
and meta_typedecl _loc =
  function
  | `TyDcl (_a0,_a1,_a2,_a3) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App
                  (_loc,
                    (`App
                       (_loc, (`Vrn (_loc, "TyDcl")),
                         (meta_alident _loc _a0))),
                    (meta_list meta_ctyp _loc _a1))),
               (meta_type_info _loc _a2))),
          (meta_list
             (fun _loc  (_a0,_a1)  ->
                `Tup
                  (_loc,
                    (`Com (_loc, (meta_ctyp _loc _a0), (meta_ctyp _loc _a1)))))
             _loc _a3))
  | `And (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "And")), (meta_typedecl _loc _a0))),
          (meta_typedecl _loc _a1))
  | #ant_nil as _a0 -> (meta_ant_nil _loc _a0 :>'result156)
and meta_type_info _loc =
  function
  | `TyMan (_a0,_a1,_a2) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App (_loc, (`Vrn (_loc, "TyMan")), (meta_ctyp _loc _a0))),
               (meta_private_flag _loc _a1))), (meta_type_repr _loc _a2))
  | `TyRepr (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "TyRepr")), (meta_private_flag _loc _a0))),
          (meta_type_repr _loc _a1))
  | `TyEq (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "TyEq")), (meta_private_flag _loc _a0))),
          (meta_ctyp _loc _a1))
  | #ant_nil as _a0 -> (meta_ant_nil _loc _a0 :>'result155)
and meta_type_repr _loc =
  function
  | `Record _a0 ->
      `App (_loc, (`Vrn (_loc, "Record")), (meta_name_ctyp _loc _a0))
  | `Sum _a0 -> `App (_loc, (`Vrn (_loc, "Sum")), (meta_or_ctyp _loc _a0))
  | #ant_nil as _a0 -> (meta_ant_nil _loc _a0 :>'result154)
and meta_name_ctyp _loc =
  function
  | `Sem (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "Sem")), (meta_name_ctyp _loc _a0))),
          (meta_name_ctyp _loc _a1))
  | `TyCol (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "TyCol")), (meta_sid _loc _a0))),
          (meta_ctyp _loc _a1))
  | `TyColMut (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "TyColMut")), (meta_sid _loc _a0))),
          (meta_ctyp _loc _a1))
  | #ant_nil as _a0 -> (meta_ant_nil _loc _a0 :>'result153)
and meta_or_ctyp _loc =
  function
  | `Or (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Or")), (meta_or_ctyp _loc _a0))),
          (meta_or_ctyp _loc _a1))
  | `TyCol (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "TyCol")), (meta_sid _loc _a0))),
          (meta_ctyp _loc _a1))
  | `Of (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Of")), (meta_sid _loc _a0))),
          (meta_ctyp _loc _a1))
  | #sid as _a0 -> (meta_sid _loc _a0 :>'result152)
  | #ant_nil as _a0 -> (meta_ant_nil _loc _a0 :>'result152)
and meta_of_ctyp _loc =
  function
  | `Of (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Of")), (meta_sid _loc _a0))),
          (meta_ctyp _loc _a1))
  | #sid as _a0 -> (meta_sid _loc _a0 :>'result151)
  | #ant_nil as _a0 -> (meta_ant_nil _loc _a0 :>'result151)
and meta_patt _loc =
  function
  | #nil as _a0 -> (meta_nil _loc _a0 :>'result150)
  | #sid as _a0 -> (meta_sid _loc _a0 :>'result150)
  | `App (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "App")), (meta_patt _loc _a0))),
          (meta_patt _loc _a1))
  | `Vrn _a0 -> `App (_loc, (`Vrn (_loc, "Vrn")), (meta_string _loc _a0))
  | `Com (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Com")), (meta_patt _loc _a0))),
          (meta_patt _loc _a1))
  | `Sem (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Sem")), (meta_patt _loc _a0))),
          (meta_patt _loc _a1))
  | `Tup _a0 -> `App (_loc, (`Vrn (_loc, "Tup")), (meta_patt _loc _a0))
  | #any as _a0 -> (meta_any _loc _a0 :>'result150)
  | `Record _a0 ->
      `App (_loc, (`Vrn (_loc, "Record")), (meta_rec_patt _loc _a0))
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result150)
  | #literal as _a0 -> (meta_literal _loc _a0 :>'result150)
  | `Alias (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Alias")), (meta_patt _loc _a0))),
          (meta_alident _loc _a1))
  | `Array _a0 -> `App (_loc, (`Vrn (_loc, "Array")), (meta_patt _loc _a0))
  | `Label (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "Label")), (meta_alident _loc _a0))),
          (meta_patt _loc _a1))
  | `PaOlbi (_a0,_a1,_a2) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App (_loc, (`Vrn (_loc, "PaOlbi")), (meta_alident _loc _a0))),
               (meta_patt _loc _a1))), (meta_meta_option meta_expr _loc _a2))
  | `Or (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Or")), (meta_patt _loc _a0))),
          (meta_patt _loc _a1))
  | `PaRng (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "PaRng")), (meta_patt _loc _a0))),
          (meta_patt _loc _a1))
  | `Constraint (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "Constraint")), (meta_patt _loc _a0))),
          (meta_ctyp _loc _a1))
  | `ClassPath _a0 ->
      `App (_loc, (`Vrn (_loc, "ClassPath")), (meta_ident _loc _a0))
  | `Lazy _a0 -> `App (_loc, (`Vrn (_loc, "Lazy")), (meta_patt _loc _a0))
  | `ModuleUnpack (_a0,_a1) ->
      `App
        (_loc,
          (`App
             (_loc, (`Vrn (_loc, "ModuleUnpack")), (meta_auident _loc _a0))),
          (meta_meta_option meta_ctyp _loc _a1))
and meta_rec_patt _loc =
  function
  | #nil as _a0 -> (meta_nil _loc _a0 :>'result149)
  | `RecBind (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "RecBind")), (meta_ident _loc _a0))),
          (meta_patt _loc _a1))
  | `Sem (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Sem")), (meta_rec_patt _loc _a0))),
          (meta_rec_patt _loc _a1))
  | #any as _a0 -> (meta_any _loc _a0 :>'result149)
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result149)
and meta_expr _loc =
  function
  | #nil as _a0 -> (meta_nil _loc _a0 :>'result148)
  | #sid as _a0 -> (meta_sid _loc _a0 :>'result148)
  | `App (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "App")), (meta_expr _loc _a0))),
          (meta_expr _loc _a1))
  | `Vrn _a0 -> `App (_loc, (`Vrn (_loc, "Vrn")), (meta_string _loc _a0))
  | `Com (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Com")), (meta_expr _loc _a0))),
          (meta_expr _loc _a1))
  | `Sem (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Sem")), (meta_expr _loc _a0))),
          (meta_expr _loc _a1))
  | `Tup _a0 -> `App (_loc, (`Vrn (_loc, "Tup")), (meta_expr _loc _a0))
  | #any as _a0 -> (meta_any _loc _a0 :>'result148)
  | `Record _a0 ->
      `App (_loc, (`Vrn (_loc, "Record")), (meta_rec_expr _loc _a0))
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result148)
  | #literal as _a0 -> (meta_literal _loc _a0 :>'result148)
  | `RecordWith (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "RecordWith")), (meta_rec_expr _loc _a0))),
          (meta_expr _loc _a1))
  | `Dot (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Dot")), (meta_expr _loc _a0))),
          (meta_expr _loc _a1))
  | `ArrayDot (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "ArrayDot")), (meta_expr _loc _a0))),
          (meta_expr _loc _a1))
  | `Array _a0 -> `App (_loc, (`Vrn (_loc, "Array")), (meta_expr _loc _a0))
  | `ExAsf -> `Vrn (_loc, "ExAsf")
  | `ExAsr _a0 -> `App (_loc, (`Vrn (_loc, "ExAsr")), (meta_expr _loc _a0))
  | `Assign (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Assign")), (meta_expr _loc _a0))),
          (meta_expr _loc _a1))
  | `For (_a0,_a1,_a2,_a3,_a4) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App
                  (_loc,
                    (`App
                       (_loc,
                         (`App
                            (_loc, (`Vrn (_loc, "For")),
                              (meta_alident _loc _a0))),
                         (meta_expr _loc _a1))), (meta_expr _loc _a2))),
               (meta_direction_flag _loc _a3))), (meta_expr _loc _a4))
  | `Fun _a0 -> `App (_loc, (`Vrn (_loc, "Fun")), (meta_match_case _loc _a0))
  | `IfThenElse (_a0,_a1,_a2) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App
                  (_loc, (`Vrn (_loc, "IfThenElse")), (meta_expr _loc _a0))),
               (meta_expr _loc _a1))), (meta_expr _loc _a2))
  | `IfThen (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "IfThen")), (meta_expr _loc _a0))),
          (meta_expr _loc _a1))
  | `Label (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "Label")), (meta_alident _loc _a0))),
          (meta_expr _loc _a1))
  | `Lazy _a0 -> `App (_loc, (`Vrn (_loc, "Lazy")), (meta_expr _loc _a0))
  | `LetIn (_a0,_a1,_a2) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App (_loc, (`Vrn (_loc, "LetIn")), (meta_rec_flag _loc _a0))),
               (meta_binding _loc _a1))), (meta_expr _loc _a2))
  | `LetModule (_a0,_a1,_a2) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App
                  (_loc, (`Vrn (_loc, "LetModule")), (meta_auident _loc _a0))),
               (meta_module_expr _loc _a1))), (meta_expr _loc _a2))
  | `Match (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Match")), (meta_expr _loc _a0))),
          (meta_match_case _loc _a1))
  | `New _a0 -> `App (_loc, (`Vrn (_loc, "New")), (meta_ident _loc _a0))
  | `Obj (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Obj")), (meta_patt _loc _a0))),
          (meta_class_str_item _loc _a1))
  | `OptLabl (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "OptLabl")), (meta_alident _loc _a0))),
          (meta_expr _loc _a1))
  | `OvrInst _a0 ->
      `App (_loc, (`Vrn (_loc, "OvrInst")), (meta_rec_expr _loc _a0))
  | `Seq _a0 -> `App (_loc, (`Vrn (_loc, "Seq")), (meta_expr _loc _a0))
  | `Send (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Send")), (meta_expr _loc _a0))),
          (meta_alident _loc _a1))
  | `StringDot (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "StringDot")), (meta_expr _loc _a0))),
          (meta_expr _loc _a1))
  | `Try (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Try")), (meta_expr _loc _a0))),
          (meta_match_case _loc _a1))
  | `Constraint (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "Constraint")), (meta_expr _loc _a0))),
          (meta_ctyp _loc _a1))
  | `Coercion (_a0,_a1,_a2) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App (_loc, (`Vrn (_loc, "Coercion")), (meta_expr _loc _a0))),
               (meta_ctyp _loc _a1))), (meta_ctyp _loc _a2))
  | `While (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "While")), (meta_expr _loc _a0))),
          (meta_expr _loc _a1))
  | `LetOpen (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "LetOpen")), (meta_ident _loc _a0))),
          (meta_expr _loc _a1))
  | `LocalTypeFun (_a0,_a1) ->
      `App
        (_loc,
          (`App
             (_loc, (`Vrn (_loc, "LocalTypeFun")), (meta_alident _loc _a0))),
          (meta_expr _loc _a1))
  | `Package_expr _a0 ->
      `App (_loc, (`Vrn (_loc, "Package_expr")), (meta_module_expr _loc _a0))
and meta_rec_expr _loc =
  function
  | #nil as _a0 -> (meta_nil _loc _a0 :>'result147)
  | `Sem (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Sem")), (meta_rec_expr _loc _a0))),
          (meta_rec_expr _loc _a1))
  | `RecBind (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "RecBind")), (meta_ident _loc _a0))),
          (meta_expr _loc _a1))
  | #any as _a0 -> (meta_any _loc _a0 :>'result147)
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result147)
and meta_module_type _loc =
  function
  | #nil as _a0 -> (meta_nil _loc _a0 :>'result146)
  | #sid as _a0 -> (meta_sid _loc _a0 :>'result146)
  | `MtFun (_a0,_a1,_a2) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App (_loc, (`Vrn (_loc, "MtFun")), (meta_auident _loc _a0))),
               (meta_module_type _loc _a1))), (meta_module_type _loc _a2))
  | `Sig _a0 -> `App (_loc, (`Vrn (_loc, "Sig")), (meta_sig_item _loc _a0))
  | `With (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "With")), (meta_module_type _loc _a0))),
          (meta_with_constr _loc _a1))
  | `ModuleTypeOf _a0 ->
      `App (_loc, (`Vrn (_loc, "ModuleTypeOf")), (meta_module_expr _loc _a0))
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result146)
and meta_sig_item _loc =
  function
  | #nil as _a0 -> (meta_nil _loc _a0 :>'result145)
  | `Class _a0 ->
      `App (_loc, (`Vrn (_loc, "Class")), (meta_class_type _loc _a0))
  | `ClassType _a0 ->
      `App (_loc, (`Vrn (_loc, "ClassType")), (meta_class_type _loc _a0))
  | `Sem (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Sem")), (meta_sig_item _loc _a0))),
          (meta_sig_item _loc _a1))
  | `Directive (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "Directive")), (meta_alident _loc _a0))),
          (meta_expr _loc _a1))
  | `Exception _a0 ->
      `App (_loc, (`Vrn (_loc, "Exception")), (meta_of_ctyp _loc _a0))
  | `External (_a0,_a1,_a2) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App
                  (_loc, (`Vrn (_loc, "External")), (meta_alident _loc _a0))),
               (meta_ctyp _loc _a1))), (meta_meta_list meta_string _loc _a2))
  | `Include _a0 ->
      `App (_loc, (`Vrn (_loc, "Include")), (meta_module_type _loc _a0))
  | `Module (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "Module")), (meta_auident _loc _a0))),
          (meta_module_type _loc _a1))
  | `RecModule _a0 ->
      `App (_loc, (`Vrn (_loc, "RecModule")), (meta_module_binding _loc _a0))
  | `ModuleType (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "ModuleType")), (meta_auident _loc _a0))),
          (meta_module_type _loc _a1))
  | `Open _a0 -> `App (_loc, (`Vrn (_loc, "Open")), (meta_ident _loc _a0))
  | `Type _a0 -> `App (_loc, (`Vrn (_loc, "Type")), (meta_typedecl _loc _a0))
  | `Val (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Val")), (meta_alident _loc _a0))),
          (meta_ctyp _loc _a1))
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result145)
and meta_with_constr _loc =
  function
  | #nil as _a0 -> (meta_nil _loc _a0 :>'result144)
  | `TypeEq (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "TypeEq")), (meta_ctyp _loc _a0))),
          (meta_ctyp _loc _a1))
  | `TypeEqPriv (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "TypeEqPriv")), (meta_ctyp _loc _a0))),
          (meta_ctyp _loc _a1))
  | `ModuleEq (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "ModuleEq")), (meta_ident _loc _a0))),
          (meta_ident _loc _a1))
  | `TypeSubst (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "TypeSubst")), (meta_ctyp _loc _a0))),
          (meta_ctyp _loc _a1))
  | `ModuleSubst (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "ModuleSubst")), (meta_ident _loc _a0))),
          (meta_ident _loc _a1))
  | `And (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "And")), (meta_with_constr _loc _a0))),
          (meta_with_constr _loc _a1))
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result144)
and meta_binding _loc =
  function
  | #nil as _a0 -> (meta_nil _loc _a0 :>'result143)
  | `And (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "And")), (meta_binding _loc _a0))),
          (meta_binding _loc _a1))
  | `Bind (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Bind")), (meta_patt _loc _a0))),
          (meta_expr _loc _a1))
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result143)
and meta_module_binding _loc =
  function
  | #nil as _a0 -> (meta_nil _loc _a0 :>'result142)
  | `And (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "And")), (meta_module_binding _loc _a0))),
          (meta_module_binding _loc _a1))
  | `ModuleBind (_a0,_a1,_a2) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App
                  (_loc, (`Vrn (_loc, "ModuleBind")),
                    (meta_auident _loc _a0))), (meta_module_type _loc _a1))),
          (meta_module_expr _loc _a2))
  | `Constraint (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "Constraint")), (meta_auident _loc _a0))),
          (meta_module_type _loc _a1))
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result142)
and meta_match_case _loc =
  function
  | #nil as _a0 -> (meta_nil _loc _a0 :>'result141)
  | `Or (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "Or")), (meta_match_case _loc _a0))),
          (meta_match_case _loc _a1))
  | `Case (_a0,_a1,_a2) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App (_loc, (`Vrn (_loc, "Case")), (meta_patt _loc _a0))),
               (meta_expr _loc _a1))), (meta_expr _loc _a2))
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result141)
and meta_module_expr _loc =
  function
  | #nil as _a0 -> (meta_nil _loc _a0 :>'result140)
  | #sid as _a0 -> (meta_sid _loc _a0 :>'result140)
  | `App (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "App")), (meta_module_expr _loc _a0))),
          (meta_module_expr _loc _a1))
  | `Functor (_a0,_a1,_a2) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App
                  (_loc, (`Vrn (_loc, "Functor")), (meta_auident _loc _a0))),
               (meta_module_type _loc _a1))), (meta_module_expr _loc _a2))
  | `Struct _a0 ->
      `App (_loc, (`Vrn (_loc, "Struct")), (meta_str_item _loc _a0))
  | `Constraint (_a0,_a1) ->
      `App
        (_loc,
          (`App
             (_loc, (`Vrn (_loc, "Constraint")), (meta_module_expr _loc _a0))),
          (meta_module_type _loc _a1))
  | `PackageModule _a0 ->
      `App (_loc, (`Vrn (_loc, "PackageModule")), (meta_expr _loc _a0))
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result140)
and meta_str_item _loc =
  function
  | #nil as _a0 -> (meta_nil _loc _a0 :>'result139)
  | `Class _a0 ->
      `App (_loc, (`Vrn (_loc, "Class")), (meta_class_expr _loc _a0))
  | `ClassType _a0 ->
      `App (_loc, (`Vrn (_loc, "ClassType")), (meta_class_type _loc _a0))
  | `Sem (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Sem")), (meta_str_item _loc _a0))),
          (meta_str_item _loc _a1))
  | `Directive (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "Directive")), (meta_alident _loc _a0))),
          (meta_expr _loc _a1))
  | `Exception _a0 ->
      `App (_loc, (`Vrn (_loc, "Exception")), (meta_of_ctyp _loc _a0))
  | `StExp _a0 -> `App (_loc, (`Vrn (_loc, "StExp")), (meta_expr _loc _a0))
  | `External (_a0,_a1,_a2) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App
                  (_loc, (`Vrn (_loc, "External")), (meta_alident _loc _a0))),
               (meta_ctyp _loc _a1))), (meta_meta_list meta_string _loc _a2))
  | `Include _a0 ->
      `App (_loc, (`Vrn (_loc, "Include")), (meta_module_expr _loc _a0))
  | `Module (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "Module")), (meta_auident _loc _a0))),
          (meta_module_expr _loc _a1))
  | `RecModule _a0 ->
      `App (_loc, (`Vrn (_loc, "RecModule")), (meta_module_binding _loc _a0))
  | `ModuleType (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "ModuleType")), (meta_auident _loc _a0))),
          (meta_module_type _loc _a1))
  | `Open _a0 -> `App (_loc, (`Vrn (_loc, "Open")), (meta_ident _loc _a0))
  | `Type _a0 -> `App (_loc, (`Vrn (_loc, "Type")), (meta_typedecl _loc _a0))
  | `Value (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "Value")), (meta_rec_flag _loc _a0))),
          (meta_binding _loc _a1))
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result139)
and meta_class_type _loc =
  function
  | #nil as _a0 -> (meta_nil _loc _a0 :>'result138)
  | `CtCon (_a0,_a1,_a2) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App
                  (_loc, (`Vrn (_loc, "CtCon")),
                    (meta_virtual_flag _loc _a0))), (meta_ident _loc _a1))),
          (meta_ctyp _loc _a2))
  | `CtFun (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "CtFun")), (meta_ctyp _loc _a0))),
          (meta_class_type _loc _a1))
  | `CtSig (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "CtSig")), (meta_ctyp _loc _a0))),
          (meta_class_sig_item _loc _a1))
  | `And (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "And")), (meta_class_type _loc _a0))),
          (meta_class_type _loc _a1))
  | `CtCol (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "CtCol")), (meta_class_type _loc _a0))),
          (meta_class_type _loc _a1))
  | `CtEq (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "CtEq")), (meta_class_type _loc _a0))),
          (meta_class_type _loc _a1))
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result138)
and meta_class_sig_item _loc =
  function
  | #nil as _a0 -> (meta_nil _loc _a0 :>'result137)
  | `Eq (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Eq")), (meta_ctyp _loc _a0))),
          (meta_ctyp _loc _a1))
  | `Sem (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "Sem")), (meta_class_sig_item _loc _a0))),
          (meta_class_sig_item _loc _a1))
  | `SigInherit _a0 ->
      `App (_loc, (`Vrn (_loc, "SigInherit")), (meta_class_type _loc _a0))
  | `Method (_a0,_a1,_a2) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App (_loc, (`Vrn (_loc, "Method")), (meta_alident _loc _a0))),
               (meta_private_flag _loc _a1))), (meta_ctyp _loc _a2))
  | `CgVal (_a0,_a1,_a2,_a3) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App
                  (_loc,
                    (`App
                       (_loc, (`Vrn (_loc, "CgVal")),
                         (meta_alident _loc _a0))),
                    (meta_mutable_flag _loc _a1))),
               (meta_virtual_flag _loc _a2))), (meta_ctyp _loc _a3))
  | `CgVir (_a0,_a1,_a2) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App (_loc, (`Vrn (_loc, "CgVir")), (meta_alident _loc _a0))),
               (meta_private_flag _loc _a1))), (meta_ctyp _loc _a2))
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result137)
and meta_class_expr _loc =
  function
  | #nil as _a0 -> (meta_nil _loc _a0 :>'result136)
  | `CeApp (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "CeApp")), (meta_class_expr _loc _a0))),
          (meta_expr _loc _a1))
  | `CeCon (_a0,_a1,_a2) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App
                  (_loc, (`Vrn (_loc, "CeCon")),
                    (meta_virtual_flag _loc _a0))), (meta_ident _loc _a1))),
          (meta_ctyp _loc _a2))
  | `CeFun (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "CeFun")), (meta_patt _loc _a0))),
          (meta_class_expr _loc _a1))
  | `CeLet (_a0,_a1,_a2) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App (_loc, (`Vrn (_loc, "CeLet")), (meta_rec_flag _loc _a0))),
               (meta_binding _loc _a1))), (meta_class_expr _loc _a2))
  | `Obj (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Obj")), (meta_patt _loc _a0))),
          (meta_class_str_item _loc _a1))
  | `CeTyc (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "CeTyc")), (meta_class_expr _loc _a0))),
          (meta_class_type _loc _a1))
  | `And (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "And")), (meta_class_expr _loc _a0))),
          (meta_class_expr _loc _a1))
  | `Eq (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "Eq")), (meta_class_expr _loc _a0))),
          (meta_class_expr _loc _a1))
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result136)
and meta_class_str_item _loc =
  function
  | #nil as _a0 -> (meta_nil _loc _a0 :>'result135)
  | `Sem (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "Sem")), (meta_class_str_item _loc _a0))),
          (meta_class_str_item _loc _a1))
  | `Eq (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Eq")), (meta_ctyp _loc _a0))),
          (meta_ctyp _loc _a1))
  | `Inherit (_a0,_a1,_a2) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App
                  (_loc, (`Vrn (_loc, "Inherit")),
                    (meta_override_flag _loc _a0))),
               (meta_class_expr _loc _a1))),
          (meta_meta_option meta_alident _loc _a2))
  | `Initializer _a0 ->
      `App (_loc, (`Vrn (_loc, "Initializer")), (meta_expr _loc _a0))
  | `CrMth (_a0,_a1,_a2,_a3,_a4) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App
                  (_loc,
                    (`App
                       (_loc,
                         (`App
                            (_loc, (`Vrn (_loc, "CrMth")),
                              (meta_alident _loc _a0))),
                         (meta_override_flag _loc _a1))),
                    (meta_private_flag _loc _a2))), (meta_expr _loc _a3))),
          (meta_ctyp _loc _a4))
  | `CrVal (_a0,_a1,_a2,_a3) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App
                  (_loc,
                    (`App
                       (_loc, (`Vrn (_loc, "CrVal")),
                         (meta_alident _loc _a0))),
                    (meta_override_flag _loc _a1))),
               (meta_mutable_flag _loc _a2))), (meta_expr _loc _a3))
  | `CrVir (_a0,_a1,_a2) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App (_loc, (`Vrn (_loc, "CrVir")), (meta_alident _loc _a0))),
               (meta_private_flag _loc _a1))), (meta_ctyp _loc _a2))
  | `CrVvr (_a0,_a1,_a2) ->
      `App
        (_loc,
          (`App
             (_loc,
               (`App (_loc, (`Vrn (_loc, "CrVvr")), (meta_alident _loc _a0))),
               (meta_mutable_flag _loc _a1))), (meta_ctyp _loc _a2))
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result135)
let rec meta_ep _loc =
  function
  | #nil as _a0 -> (meta_nil _loc _a0 :>'result161)
  | #sid as _a0 -> (meta_sid _loc _a0 :>'result161)
  | `App (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "App")), (meta_ep _loc _a0))),
          (meta_ep _loc _a1))
  | `Vrn _a0 -> `App (_loc, (`Vrn (_loc, "Vrn")), (meta_string _loc _a0))
  | `Com (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Com")), (meta_ep _loc _a0))),
          (meta_ep _loc _a1))
  | `Sem (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Sem")), (meta_ep _loc _a0))),
          (meta_ep _loc _a1))
  | `Tup _a0 -> `App (_loc, (`Vrn (_loc, "Tup")), (meta_ep _loc _a0))
  | #any as _a0 -> (meta_any _loc _a0 :>'result161)
  | `Array _a0 -> `App (_loc, (`Vrn (_loc, "Array")), (meta_ep _loc _a0))
  | `Record _a0 ->
      `App (_loc, (`Vrn (_loc, "Record")), (meta_rec_bind _loc _a0))
  | #literal as _a0 -> (meta_literal _loc _a0 :>'result161)
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result161)
and meta_rec_bind _loc =
  function
  | #nil as _a0 -> (meta_nil _loc _a0 :>'result160)
  | `RecBind (_a0,_a1) ->
      `App
        (_loc,
          (`App (_loc, (`Vrn (_loc, "RecBind")), (meta_ident _loc _a0))),
          (meta_ep _loc _a1))
  | `Sem (_a0,_a1) ->
      `App
        (_loc, (`App (_loc, (`Vrn (_loc, "Sem")), (meta_rec_bind _loc _a0))),
          (meta_rec_bind _loc _a1))
  | #any as _a0 -> (meta_any _loc _a0 :>'result160)
  | #ant as _a0 -> (meta_ant _loc _a0 :>'result160)