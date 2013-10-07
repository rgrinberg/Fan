let loc_of =
  function
  | `CtDeclS (_loc,_,_,_) -> _loc
  | `Apply (_loc,_,_) -> _loc
  | `Any _loc -> _loc
  | `Array (_loc,_) -> _loc
  | `ArrayDot (_loc,_,_) -> _loc
  | `Directive (_loc,_,_) -> _loc
  | `TypeSubst (_loc,_,_) -> _loc
  | `QuoteAny (_loc,_) -> _loc
  | `TyEq (_loc,_,_) -> _loc
  | `ModuleBind (_loc,_,_,_) -> _loc
  | `CtDecl (_loc,_,_,_,_) -> _loc
  | `Sta (_loc,_,_) -> _loc
  | `Match (_loc,_,_) -> _loc
  | `Obj (_loc,_) -> _loc
  | `TyPol (_loc,_,_) -> _loc
  | `Val (_loc,_,_) -> _loc
  | `C (_loc,_) -> _loc
  | `LabelS (_loc,_) -> _loc
  | `Str (_loc,_) -> _loc
  | `ClDeclS (_loc,_,_,_) -> _loc
  | `New (_loc,_) -> _loc
  | `Value (_loc,_,_) -> _loc
  | `PolyInfSup (_loc,_,_) -> _loc
  | `Try (_loc,_,_) -> _loc
  | `App (_loc,_,_) -> _loc
  | `Assign (_loc,_,_) -> _loc
  | `Normal _loc -> _loc
  | `Sem (_loc,_,_) -> _loc
  | `Send (_loc,_,_) -> _loc
  | `Type (_loc,_) -> _loc
  | `ModuleTypeEnd (_loc,_) -> _loc
  | `Chr (_loc,_) -> _loc
  | `IfThenElse (_loc,_,_,_) -> _loc
  | `ClassType (_loc,_) -> _loc
  | `ModuleUnpack (_loc,_) -> _loc
  | `Package (_loc,_) -> _loc
  | `While (_loc,_,_) -> _loc
  | `CrMth (_loc,_,_,_,_,_) -> _loc
  | `Dot (_loc,_,_) -> _loc
  | `Struct (_loc,_) -> _loc
  | `TyMan (_loc,_,_,_) -> _loc
  | `External (_loc,_,_,_) -> _loc
  | `CgVal (_loc,_,_,_,_) -> _loc
  | `Class (_loc,_) -> _loc
  | `CrMthS (_loc,_,_,_,_) -> _loc
  | `LetIn (_loc,_,_,_) -> _loc
  | `Nativeint (_loc,_) -> _loc
  | `Seq (_loc,_) -> _loc
  | `Quote (_loc,_,_) -> _loc
  | `TypeEq (_loc,_,_) -> _loc
  | `DirectiveSimple (_loc,_) -> _loc
  | `VirVal (_loc,_,_,_) -> _loc
  | `OptLabl (_loc,_,_) -> _loc
  | `Coercion (_loc,_,_,_) -> _loc
  | `ClApply (_loc,_,_) -> _loc
  | `CtFun (_loc,_,_) -> _loc
  | `Arrow (_loc,_,_) -> _loc
  | `ObjEnd _loc -> _loc
  | `Bind (_loc,_,_) -> _loc
  | `Subtype (_loc,_,_) -> _loc
  | `Functor (_loc,_,_,_) -> _loc
  | `With (_loc,_,_) -> _loc
  | `TyVrnOf (_loc,_,_) -> _loc
  | `TyAbstr (_loc,_,_,_) -> _loc
  | `IfThen (_loc,_,_) -> _loc
  | `RecBind (_loc,_,_) -> _loc
  | `Sig (_loc,_) -> _loc
  | `PolySup (_loc,_) -> _loc
  | `Ctyp (_loc,_) -> _loc
  | `Lazy (_loc,_) -> _loc
  | `Field (_loc,_,_) -> _loc
  | `CeFun (_loc,_,_) -> _loc
  | `ClassPath (_loc,_) -> _loc
  | `Par (_loc,_) -> _loc
  | `Com (_loc,_,_) -> _loc
  | `TyRepr (_loc,_,_) -> _loc
  | `ArrayEmpty _loc -> _loc
  | `Int64 (_loc,_) -> _loc
  | `ModuleTypeOf (_loc,_) -> _loc
  | `TyPolEnd (_loc,_) -> _loc
  | `TyCol (_loc,_,_) -> _loc
  | `ObjPat (_loc,_,_) -> _loc
  | `Initializer (_loc,_) -> _loc
  | `TyColMut (_loc,_,_) -> _loc
  | `ModuleEq (_loc,_,_) -> _loc
  | `Lid (_loc,_) -> _loc
  | `OptLablS (_loc,_) -> _loc
  | `Record (_loc,_) -> _loc
  | `InheritAs (_loc,_,_,_) -> _loc
  | `Constraint (_loc,_,_) -> _loc
  | `Ant (_loc,_) -> _loc
  | `Some (_loc,_) -> _loc
  | `TypeEqPriv (_loc,_,_) -> _loc
  | `Label (_loc,_,_) -> _loc
  | `TyTypePol (_loc,_,_) -> _loc
  | `Include (_loc,_) -> _loc
  | `Flo (_loc,_) -> _loc
  | `Alias (_loc,_,_) -> _loc
  | `Vrn (_loc,_) -> _loc
  | `StExp (_loc,_) -> _loc
  | `Uid (_loc,_) -> _loc
  | `TyObj (_loc,_,_) -> _loc
  | `Of (_loc,_,_) -> _loc
  | `OvrInst (_loc,_) -> _loc
  | `ModuleSubst (_loc,_,_) -> _loc
  | `Positive _loc -> _loc
  | `CrVal (_loc,_,_,_,_) -> _loc
  | `ModuleConstraint (_loc,_,_) -> _loc
  | `TyVrn (_loc,_) -> _loc
  | `Case (_loc,_,_) -> _loc
  | `OvrInstEmpty _loc -> _loc
  | `Exception (_loc,_) -> _loc
  | `RecordWith (_loc,_,_) -> _loc
  | `And (_loc,_,_) -> _loc
  | `SigEnd _loc -> _loc
  | `ObjPatEnd (_loc,_) -> _loc
  | `ClDecl (_loc,_,_,_,_) -> _loc
  | `TyDcl (_loc,_,_,_,_) -> _loc
  | `Assert (_loc,_) -> _loc
  | `StructEnd _loc -> _loc
  | `Int32 (_loc,_) -> _loc
  | `VirMeth (_loc,_,_,_) -> _loc
  | `PaRng (_loc,_,_) -> _loc
  | `RecModule (_loc,_) -> _loc
  | `LocalTypeFun (_loc,_,_) -> _loc
  | `Package_exp (_loc,_) -> _loc
  | `CaseWhen (_loc,_,_,_) -> _loc
  | `Int (_loc,_) -> _loc
  | `Negative _loc -> _loc
  | `Fun (_loc,_) -> _loc
  | `CeApp (_loc,_,_) -> _loc
  | `Eq (_loc,_,_) -> _loc
  | `LetTryInWith (_loc,_,_,_,_) -> _loc
  | `LetModule (_loc,_,_,_) -> _loc
  | `LetOpen (_loc,_,_,_) -> _loc
  | `PolyInf (_loc,_) -> _loc
  | `StringDot (_loc,_,_) -> _loc
  | `For (_loc,_,_,_,_,_) -> _loc
  | `TypeWith (_loc,_,_) -> _loc
  | `OptLablExpr (_loc,_,_,_) -> _loc
  | `SigInherit (_loc,_) -> _loc
  | `ModuleType (_loc,_,_) -> _loc
  | `Inherit (_loc,_,_) -> _loc
  | `None _loc -> _loc
  | `ObjTy (_loc,_,_) -> _loc
  | `Method (_loc,_,_,_) -> _loc
  | `Module (_loc,_,_) -> _loc
  | `PackageModule (_loc,_) -> _loc
  | `PolyEq (_loc,_) -> _loc
  | `Bar (_loc,_,_) -> _loc
  | `Open (_loc,_,_) -> _loc
  | `ObjTyEnd (_loc,_) -> _loc
  | `TyObjEnd (_loc,_) -> _loc
  | `Sum (_loc,_) -> _loc