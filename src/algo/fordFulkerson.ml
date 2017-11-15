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

    (* TODO : changer le cehmin par la lsite des arrêtes *)
let chemin graph src dest =
  let settled = ref [dest] in
  let _chemin = ref [dest] in
  let rec trouver_chemin src dest =
    let rec trouver_sommet inedges =
      match inedges with 
        | (_, id)::r when List.exists (fun x -> x = Graph.find_vertex graph id) !settled -> trouver_sommet r
        | (label, _)::r when label = "0" -> trouver_sommet r
        | (_, id)::_-> let sommet = Graph.find_vertex graph id in settled := sommet::!settled ; sommet  
        | _ -> failwith "Pas de sommet"
    in
    let sommet_courant = trouver_sommet dest.inedges in
      if sommet_courant <> src 
      then begin _chemin := sommet_courant::!_chemin ; trouver_chemin src sommet_courant end
      else begin _chemin end

  in
    trouver_chemin src dest ; _chemin := src::!_chemin ; !_chemin



let algo graph _src _dest =
  let _graph = Graph.map graph (fun v -> v) (fun e -> e) in
  let src = Graph.find_vertex _graph _src and dest = Graph.find_vertex _graph _dest in
  let f = init_algo _graph in
  let cout = Hashtbl.create 60 in
    let path = chemin _graph src dest in
      List.iter (fun e -> Printf.printf "%s" e.id) path ;
    ()



