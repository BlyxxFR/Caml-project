open Graph
open FordFulkerson
open AttributionProjets

let () =

  if Array.length Sys.argv <> 5 && Array.length Sys.argv <> 3 then
    begin
      Printf.printf "\nUsage: %s infile source sink outfile\n\n%!" Sys.argv.(0) ;
      exit 0
    end ;
  let infile = Sys.argv.(1) in
  let graph = Gfile.from_file infile in

  if Array.length Sys.argv = 5 then
  begin
	  Printf.printf "FordFulkerson test on a graph\n" ;
  	  let _source = Sys.argv.(2)
  	  and _sink = Sys.argv.(3)
  	  and outfile = Sys.argv.(4) in
	  (* Rewrite the graph that has been read. *)
		Printf.printf "Exporting input graph\n" ;
	  let () = Gfile.export outfile graph in
			Printf.printf "Computing flow...\n" ;
		  let graph_flot = FordFulkerson.algo (Graph.map graph (fun v -> v) (fun e -> int_of_string e)) _source _sink in
				Printf.printf "Done. Exporting...\n" ;
			 let () = Gfile.export (outfile ^ "_flot") graph_flot in
				Printf.printf "Done.\n"
  end else
  begin
  	  let outfile = Sys.argv.(2) in
	  Printf.printf "FordFulkerson application\n" ;
	  let graph = AttributionProjets.algo infile in 
		let () = Gfile.export outfile graph in
			()
  end
  

