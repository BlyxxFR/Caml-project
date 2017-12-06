open Graph

exception Pas_de_chemin

let trouver_chemin graph src dest =
  let settled = ref [] in
  let pere = Hashtbl.create 100 in
  let rec explorer acu id =
    if List.exists (fun x -> x = id) !settled || id = dest.id then
      ()
    else
      begin 
        settled := id::!settled ;
        let vertex_info = Graph.find_vertex graph id in
          List.iter (fun (_, id_fils) -> Hashtbl.add pere id_fils id ; explorer (id :: acu) id_fils) vertex_info.outedges
      end
  in
  let rec construire_chemin acu sommet =
    if sommet = src.id then
      acu
    else
      begin
        try
          let next = Hashtbl.find pere sommet in
            begin
              match (Graph.find_edge graph next sommet) with
                | Some label -> construire_chemin ((label, next) :: acu) next
                | None -> raise Pas_de_chemin
            end
        with
          | Not_found -> raise Pas_de_chemin
      end
  in
    explorer [] src.id ;
    construire_chemin [] dest.id


let trouver_flot_min chemin =
  let min = ref max_int in
  let rec trouver_min list =
    match list with
      | [] -> !min
      | (label, _)::r when label < !min -> min := label ; trouver_min r
      | _::r  -> trouver_min r
  in
    trouver_min chemin

let ajouter_flot_arrete graph id1 id2 flot =
  match (Graph.find_edge graph id1 id2) with
    | Some plabel -> 
        let nlabel = plabel + flot in
          Graph.add_edge graph id1 id2 nlabel
    | None -> Graph.add_edge graph id1 id2 flot

let retirer_flot_arrete graph id1 id2 flot =
  match (Graph.find_edge graph id1 id2) with
    | Some plabel-> 
        let nlabel = plabel - flot in
          if nlabel = 0 then
            begin
              Graph.remove_edge graph id1 id2 ;
            end
          else
            Graph.add_edge graph id1 id2 nlabel
    | None -> ()

let mettre_a_jour_flot graph chemin final_node =
  let min_flot = trouver_flot_min chemin in
  let sommet_precedent = ref final_node in
  let rec mettre_a_jour = function
    | [] -> ()
    | (label, sommet_courant)::r -> 
        begin
          ajouter_flot_arrete graph !sommet_precedent sommet_courant min_flot ;
          retirer_flot_arrete graph sommet_courant !sommet_precedent min_flot ;
          sommet_precedent := sommet_courant ;
          mettre_a_jour r
        end
  in
    mettre_a_jour (List.rev chemin)


let construire_graph_residuel graph _src _dest =
  let _graph = Graph.map graph (fun v -> v) (fun e -> e) in
  let src = Graph.find_vertex _graph _src and dest = Graph.find_vertex _graph _dest in
  let rec execute () =
    try
      let path = trouver_chemin _graph src dest in
        mettre_a_jour_flot _graph path dest.id ;
        execute ()
    with 
      | Pas_de_chemin -> ()
      | Failure e -> Printf.printf "%s" e
  in 
    execute() ;
    _graph

let algo graph _src _dest =
  let graph_flot = Graph.map graph (fun v -> v) (fun e -> string_of_int e) in
  let graph_residuel = construire_graph_residuel graph _src _dest in
  let rec construire_labels sommet_courant = function 
    | [] -> ()
    | (label, sommet)::r -> 
        begin
          match (Graph.find_edge graph_residuel sommet sommet_courant) with
            | Some label_residuel -> 
                let min_label = string_of_int (min (int_of_string label) label_residuel) in
                  Graph.add_edge graph_flot sommet_courant sommet (min_label ^ "/" ^ label) ; 
                  construire_labels sommet_courant r
            | None -> Graph.add_edge graph_flot sommet_courant sommet ("0/" ^ label) ; 
        end
  in
    v_iter graph_flot (fun vertex_info -> construire_labels vertex_info.id vertex_info.outedges) ;
    graph_flot
