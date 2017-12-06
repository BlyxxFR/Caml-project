open Graph



(**************  FILE MANAGEMENT  **************)

(* Reads a line with a student. *)
let read_student graph line =
  try Scanf.sscanf line "student %s \"%s@\"" (fun id nom -> add_vertex graph nom (string_of_int ((int_of_string id)+1)))
  with e -> Printf.printf "Cannot read student in line - %s:\n%s\n" (Printexc.to_string e) line

(* Reads a line with a project. *)
let read_project graph line offset =
  try Scanf.sscanf line "project %s \"%s@\" %s" (fun id nom capacite -> 
                                                  let id_projet = string_of_int ((int_of_string id)+offset+1) in 
                                                    add_vertex graph nom id_projet ; 
                                                    add_edge graph id_projet "1" capacite)
  with e -> Printf.printf "Cannot read project in line - %s:\n%s\n" (Printexc.to_string e) line

(* Reads a line with a preference. *)
let read_preference graph line offset =
  try Scanf.sscanf line "choice %s %s" (fun id1 id2 -> 
                                         let id_student = string_of_int ((int_of_string id1)+1) 
                                         and id_project = (string_of_int ((int_of_string id2)+offset+1)) in
                                           add_edge graph id_student id_project "1" ;
                                           begin
                                             match (find_vertex graph "0" id_student) with
                                               | Some number -> 
                                                   let new_number = string_of_int ((int_of_string number) + 1) in
                                                     add_edge graph "0" id_student new_number
                                               | None -> add_edge graph "0" id_student "1"
                                           end
                                       )
  with e -> Printf.printf "Cannot read project in line - %s:\n%s\n" (Printexc.to_string e) line

(* Create graph from file *)
let from_file path =

  let infile = open_in path in

  (* Create new graph *)
  let graph = new_graph () in

    (* Add source and sink *)
    add_vertex graph "Source" "0" ;
    add_vertex graph "Sink" "1" ;

    (* Populate it *)
    let rec loop () =
      try
        let line = input_line infile in
        let compteur_etudiant = ref 0 in
        let compteur_projet = ref 0 in
        let () =
          if line = "" then ()
          else match line.[0] with
            | 's' -> read_student graph line ; compteur_etudiant := !compteur_etudiant + 1
            | 'p' -> read_project graph line !compteur_etudiant ; compteur_projet := !compteur_projet + 1
            | 'c' -> read_preference graph line (!compteur_etudiant + !compteur_projet)
            | _ -> ()
        in                 
          loop ()        
      with End_of_file -> ()
    in

      loop () ;

      close_in infile ;
      graph


(**************  FUNCTIONS  **************)

let algo infile =
  let graph = from_file infile in
    graph

