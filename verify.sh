
# byte code fixpoint seems to reach faster compared with native code?
ocamlbuild src/fan.native src/fan.byte
./re src fan.native

rm -rf _build/boot/fan.byte

mv _build/src/fan.byte _build/boot/
make cleansrc
ocamlbuild src/fan.byte

if cmp _build/src/fan.byte _build/boot/fan.byte
then
    echo fixpoint reached
else
    echo "bytecode fixpoint not reached"
fi