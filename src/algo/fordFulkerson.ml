open Graph

let init_algo graph =
  let f = Hashtbl.create 100 in
    v_iter graph (fun vi -> 
                   List.iter (fun (_, id2) -> 
                               Hashtbl.add f (vi.id, id2) 0)
                     vi.outedges) ;
    v_iter graph (fun vi -> 
                   List.iter (fun (_, id2) -> 
                               Hashtbl.add f (id2, vi.id) 0)
                     vi.inedges) ;
    f

let chemin graph src dest =
  let settled = ref [dest.id] in
  let _chemin = ref [] in
  let rec trouver_chemin src dest =
    let rec trouver_arrete inedges =
      match inedges with 
        | (_, id)::r when List.exists (fun x -> x = id) !settled -> trouver_arrete r
        | (label, _)::r when label = "0" -> trouver_arrete r
        | (label, id)::_-> settled := id::!settled ; (label, id)
        | _ -> failwith "Pas de chemin"
    in
    let edge = trouver_arrete dest.inedges in
    let (label, sommet_courant) = edge in
      if sommet_courant <> src.id
      then begin _chemin := edge::!_chemin ; trouver_chemin src (Graph.find_vertex graph sommet_courant) end
  in
    trouver_chemin src dest ; !_chemin

let trouver_flot_min chemin =
  let min = ref max_int in
  let rec trouver_min list =
    match list with
      | [] -> min
      | (label, _)::r when (int_of_string label) < !min -> min := (int_of_string label) ; trouver_min r
      | _::r  -> trouver_min r
  in
    trouver_min chemin ;
    !min

let mettre_a_jour_flot graph chemin =
  ()


	

let algo graph _src _dest =
  let _graph = Graph.map graph (fun v -> v) (fun e -> e) in
  let src = Graph.find_vertex _graph _src and dest = Graph.find_vertex _graph _dest in
  let f = init_algo _graph in
  let cout = Hashtbl.create 60 in
  let path = chemin _graph src dest in
    List.iter (fun (l, e) -> Printf.printf "(%s, %s) " l e) path ;
    let min =trouver_flot_min path in
      Printf.printf "%d" min


