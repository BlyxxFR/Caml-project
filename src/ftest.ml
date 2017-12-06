open Graph
open FordFulkerson
open AttributionProjets

let () =

  if Array.length Sys.argv <> 5 then
    begin
      Printf.printf "\nUsage: %s infile source sink outfile\n\n%!" Sys.argv.(0) ;
      exit 0
    end ;

  let infile = "application/" ^ Sys.argv.(1)
  and _source = Sys.argv.(2)
  and _sink = Sys.argv.(3)
  and outfile = "output/" ^ Sys.argv.(4) in

(*
  let graph = Gfile.from_file infile in

  (* Rewrite the graph that has been read. *)
  let () = Gfile.export outfile graph in
	  let graph_flot = FordFulkerson.algo (Graph.map graph (fun v -> v) (fun e -> int_of_string e)) _source _sink in
		 let () = Gfile.export (outfile ^ "_flot") graph_flot in
			()
*)
let graph = AttributionProjets.algo infile in 
	let () = Gfile.export outfile graph in
		()
