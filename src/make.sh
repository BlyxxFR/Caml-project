#!/bin/bash
# rm -f *.cmi *.cmo ftest
ocamlbuild -Is lib,algo ftest.native

# Si ça marche pas, peut être un truc comme ça
# ocamlc -I lib/ -c lib/gfile.ml
# ocamlc -I lib/ -c Bureau/graph.ml
# ocamlc -o ftest lib/gfile.cmo lib/graph.cmo ftest.ml

'
