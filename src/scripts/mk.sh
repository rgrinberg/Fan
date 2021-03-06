#! /bin/sh 
# -*- Mode:Shell-script -*-
set -e
FILES=('FanMeta.ml')

OB= ocamlbuild
TMP=tmp

for i in ${FILES[@]}
do
    ocamlbuild -I src $TMP/$i
    echo "$OB $TMP/$i\n"
    cp _build/$TMP/$i cold/
done
# ocamlbuild tmp/Ast.ml tmp/FanAst.ml tmp/ParserRevise.ml tmp/Sig.ml tmp/OCamlInitSyntax.ml tmp/Ast2pt.ml
# cp _build/tmp/Ast.ml _build/tmp/FanAst.ml _build/tmp/ParserRevise.ml _build/tmp/Sig.ml _build/tmp/OCamlInitSyntax.ml _build/tmp/Ast2pt.ml cold/
