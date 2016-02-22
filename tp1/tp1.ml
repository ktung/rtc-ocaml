(* --------------------------------------------------------------------------- *)
(* ----------------------- TP1 - IFT-3000 - Hiver 2016 ----------------------- *)
(* --------------------------------------------------------------------------- *)
(* Matricule étudiant: 111 139 433                                             *)
(* --------------------------------------------------------------------------- *)
(* -- PRINCIPALE FICHIER DU TP: FONCTIONS À COMPLÉTER ------------------------ *)
(* --------------------------------------------------------------------------- *)

#use "reseau.ml";;
#use "tp1.mli";;
 
module Gestionnaire_transport : GESTIONNAIRE_TRANSPORT = struct
  
  open Utiles
  open Date
  open Reseau_de_transport

  (* Pour éviter conflits de noms entre List et Hashtbl, ne les ouvrez pas;    *)
  (* Allez-y avec la «notation point» en utilisant les abréviations suivantes  *)
  module L = List
  module H = Hashtbl

               
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      : map_voyages_passants_itineraire : 
                      ?heure:int -> int -> int -> 
                      (arret * arret * string -> 'a) -> string list -> 'a list *)
  (* @Description   : applique une fonction f passée en argument seulement aux 
                      paires d'arrêts respectivement aux stations de départ et 
                      de destination (passées en arguments), ainsi qu'à chaque
                      voyage qui comprend chacune des paires d'arrêts, et qui
                      fait partie de la liste de voyages passés en argument    *)
  (* @Precondition  : 1- les stations de départ et de destination existent        
                      2- heure valide                                          *)
  (* @Postcondition : la liste doit être correcte même si l'ordre n'est pas 
                      important                                                *)
  let map_voyages_passants_itineraire ?(heure = heure_actuelle ())
                                      st_dep st_dest f v_ids =  
    (* Traitement correspondant aux préconditions *)
    if not (H.mem stations st_dep) then
      raise (Erreur "Station de départ inexistante ");
    if not (H.mem stations st_dest) then
      raise (Erreur "Station de destination inexistante ");
    if heure < 0 then raise (Erreur "Heure négative");
    (* Traitement correspondant à la fonction *)
    L.fold_left
      (fun acc v ->
        match H.find arrets (st_dep, v), H.find arrets (st_dest, v) with
        | (a,a') when a.arrivee >= heure
                      && a'.arrivee > a.arrivee -> (f (a,a',v))::acc
        | _ -> acc
        | exception _ -> acc
      )
      [] v_ids

            
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      : lister_numero_lignes : unit -> string list               *)
  (* @Description   : liste tous les numeros des lignes du réseau i.e "800",...*)
  (* @Precondition  : aucune                                                   *)
  (* @Postcondition : la liste retournée est correcte                          *)
  let lister_numero_lignes () =        
    (* Traitement correspondant à la fonction *)
    cles lignes

                 
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      : lister_id_stations : unit -> int list                    *)
  (* @Description   : liste tous les numeros des stations du réseau            *)
  (* @Precondition  : aucune                                                   *)
  (* @Postcondition : la liste retournée est correcte                          *)
  let lister_id_stations () = 
    (* Traitement correspondant à la fonction *)
    cles stations

         
  (* -- À IMPLANTER/COMPLÉTER (6 PTS) ---------------------------------------- *)
  (* @Fonction      : lister_numero_lignes_par_type : 
                      ?types:type_ligne list -> unit 
                      -> (type_ligne * string list) list                       *)
  (* @Description   : liste tous les numeros des lignes du réseau  groupés par 
                      type dans la liste de types en paramètre,...             *)
  (* @Precondition  : aucune                                                   *)
  (* @Postcondition : la liste retournée est correcte                          *)
  let lister_numero_lignes_par_type
        ?(types = [ MetroBus; Express; LeBus; CoucheTard ]) () =
    L.fold_left(fun acc t -> (t, H.fold(
        fun _ l acc2 -> if l.le_type = t && not(L.mem l.numero acc2) then l.numero::acc2 else acc2) lignes [])::acc
    ) [] types

  (* -- À IMPLANTER/COMPLÉTER (4 PTS) ---------------------------------------- *)
  (* @Fonction      : trouver_service : ?date:int -> unit -> string list       *)
  (* @Description   : trouve  les numéros des services associées à une date    *)
  (* @Precondition  : la date doit exister dans les dates référées dans la 
                      table de hachage des services (si elle n'y existe pas, la
                      date sera éventuellement non valide)                     *)
  (* @Postcondition : la liste retournée est correcte                          *)
  let trouver_service ?(date =date_actuelle ()) () =
   if not(H.mem services date) then raise(Erreur "Date invalide ou pas prise en charge")
   else H.find_all services date

             
  (* -- À IMPLANTER/COMPLÉTER (4 PTS) ---------------------------------------- *)
  (* @Fonction      : trouver_voyages_par_date : 
                      ?date:int -> unit -> string list                         *)
  (* @Description   : trouve les ids de tous les voyages du réseau pour une 
                      date donnée                                              *)
  (* @Precondition  : la date doit exister dans les dates référées dans la 
                      table de hachage des services                            *)
  (* @Postcondition : la liste retournée est correcte                          *)
  let trouver_voyages_par_date ?(date =date_actuelle ()) ()= 
    if not(H.mem services date) then raise(Erreur "Date invalide ou pas prise en charge");
    L.fold_left(
        fun acc s -> L.append (H.find_all voyages_par_service s) acc
    ) [] (trouver_service ~date:date())
               
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      : trouver_voyages_sur_la_ligne : 
                      ?date:int option -> string -> string list                *)
  (* @Description   : trouve les ids de tous les voyages effectués par une 
                      ligne pour une date donnée (Some d), ou quelque soit la 
                      date (None).
		      Rappel: un numéro de ligne peut être associé à
		      plusieurs ligne_id dans la table de hachage lignes       *)
  (* @Precondition  : 1- la date doit exister dans les dates référées dans la 
                         table de hachage des services
                      2- le numero de ligne doit exister dans les lignes du 
                         réseau de transport                                   *)
  (* @Postcondition : la liste retournée est correcte                          *)
  let trouver_voyages_sur_la_ligne ?(date = Some (date_actuelle ())) l_num = 
    (* Traitement correspondant aux préconditions *)
    if not (H.mem lignes l_num) then raise (Erreur "Ligne invalide");
    (* Traitement correspondant à la fonction *)
    let v_ids = match date with Some d -> trouver_voyages_par_date ~date:d ()
                              | None -> cles voyages in
    let l_ids = L.map (fun (l: ligne) -> l.ligne_id)(H.find_all lignes l_num) in
    L.filter (fun v_id -> let v = H.find voyages v_id in L.mem v.ligne_id l_ids)
             v_ids

                
  (* -- À IMPLANTER/COMPLÉTER (6 PTS) ---------------------------------------- *)
  (* @Fonction      : trouver_stations_environnantes : 
                      coordonnees -> float -> (int * float) list               *)
  (* @Description   : trouve toutes les stations dans un rayon précisé en km 
                      par rapport à une coordonnée GPS. voir la fonction
		      distance dans le module Reseau_de_transport              *)
  (* @Precondition  : 1- la coordonneée doit être valide - voir fonction 
                         valide_coord dans Reseau_de_transport 
                      2- le rayon est positif ou nul                           *)
  (* @Postcondition : la liste de paire (station, distance) doit être triée par 
                      distance croissante                                      *)
  let trouver_stations_environnantes pos rayon =
    if not(valide_coord pos) then raise(Erreur "Position GPS invalide");
    if rayon < 0.0 then raise(Erreur "Rayon négatif");
    let acc = (
     H.fold(fun id s acc ->
        let dist = distance pos s.position_gps in
          if dist <= rayon then (id, dist)::acc else acc
     ) stations []
    ) in L.sort (fun (_,e1) (_,e2) -> if e1 < e2 then -1 else if e1 > e2 then 1 else 0) acc

	      
  (* -- À IMPLANTER/COMPLÉTER (8 PTS) ---------------------------------------- *)
  (* @Fonction      : lister_lignes_passantes_station : int -> string list     *)
  (* @Description   : Lister toutes les lignes passantes par une station.
		      la réponse ne doit pas dépendre d'une date particulière  *)
  (* @Precondition  : la station existe                                        *)
  (* @Postcondition : la liste doit être correcte même si l'ordre n'est pas 
                      important                                                *)
  let lister_lignes_passantes_station st_id = 
    if not(H.mem stations st_id) then raise(Erreur "Station inexistante ");
    L.fold_left
      (fun acc vid -> L.fold_left(fun acc num -> if L.mem num acc then acc else acc@[num])
          acc
          (L.map (fun v -> (H.find lignes_par_id v.ligne_id)) (H.find_all voyages vid))
      )
      []
      (H.find_all arrets_par_station st_id)

            
  (* -- À IMPLANTER/COMPLÉTER (6 PTS) ---------------------------------------- *)
  (* @Fonction      : lister_arrets_par_voyage : string -> int list            *)
  (* @Description   : lister tous les arrêts se trouvant dans un voyage.
                      la liste est triée par le numéro de séquence de chaque
                      arrêt.                                                   *)
  (* @Precondition  : le numero du voyage doit exister                         *)
  (* @Postcondition : la liste est correcte                                    *)
  let lister_arrets_par_voyage v_id =
  if not(H.mem voyages v_id) then raise(Erreur "Voyage inexistant ");
  let arrets_list = (L.fold_left (fun acc s_id -> H.find arrets (s_id, v_id)::acc) [] (H.find_all arrets_par_voyage v_id)) in (
    let arrets_trie = (L.sort
      (fun e1 e2 -> if e1.num_sequence < e2.num_sequence then -1 else if e1.num_sequence > e2.num_sequence then 1 else 0)
      arrets_list
    ) in (L.map (fun a -> a.station_id) arrets_trie)
  )

		 
  (* -- À IMPLANTER/COMPLÉTER (10 PTS) --------------------------------------- *)
  (* @Fonction      : trouver_horaire_ligne_a_la_station : 
                      ?date:int -> ?heure:int -> string -> int -> string list  *)
  (* @Description   : trouve l'horaire entier des arrivées d'une ligne à une 
                      station donnée, à partir d'une date et d'une heure 
                      données  
		      Rappel: un numéro de ligne peut être associé à
		      plusieurs ligne_id dans la table de hachage lignes. 
                      Faites attention si vous réutilisez 
                      trouver_voyages_sur_la_ligne                             *)
  (* @Precondition  : 1- date valide et pris en charge
                      2- heure valide 
                      3-4- la station et la ligne existent 
                      5- la ligne passe par la station                         *)
  (* @Postcondition : la liste doit être en ordre croissant de temps           *)
  let trouver_horaire_ligne_a_la_station ?(date =date_actuelle ())
                                         ?(heure =heure_actuelle ())
                                         l_num st_id =
    if not(H.mem services date) then raise(Erreur "Date invalide ou pas prise en charge");
    if heure < 0 then raise(Erreur "Heure négative");
    if not (H.mem lignes l_num) then raise (Erreur "Ligne invalide");
    if not(H.mem stations st_id) then raise(Erreur "Station inexistante ");

    let v_ids = trouver_voyages_sur_la_ligne ~date:(Some date) l_num in (
      let arrets_list = (L.fold_left (fun acc v_id -> L.append (H.find_all arrets (st_id,v_id)) acc) [] v_ids) in (
        if (L.length arrets_list = 0) then raise(Erreur "La ligne ne passe pas par la station");

        let arrets_trie_heure = (L.fold_left (fun acc a -> if a.depart >= heure then a::acc else acc;) [] arrets_list) in (
          let arrets_trie = (L.sort
            (fun e1 e2 -> if e1.depart < e2.depart then -1 else if e1.depart > e2.depart then 1 else 0)
            arrets_trie_heure
          ) in (L.map (fun a -> secs_a_heure a.depart) arrets_trie)
        )
      )
    )

	     
  (* -- À IMPLANTER/COMPLÉTER (10 PTS) --------------------------------------- *)
  (* @Fonction      : lister_stations_sur_itineraire_ligne : 
                      ?date:int option -> string -> (string * int list) list   *)
  (* @Description   : lister pour les directions empruntées par la ligne, 
                      dans l'ensemble des stations où elle s'arrête (en ordre 
                      de visite - très important - ). 
		      Notez que le résultat de cette fonction peut dépendre 
                      d'un jour particulier. 
		      Vous devez prendre en compte tous les voyages d'une 
                      ligne et pour une direction donnée  
		      La liste des stations sur l'itinéraire doit être la plus 
                      longue possible    
    		      Rappel: un numéro de ligne peut être associé à
		      plusieurs ligne_id dans la table de hachage lignes.      
                      Faites attention si vous réutilisez 
                      trouver_voyages_sur_la_ligne. 	                       *)
  (* @Precondition  : le numero de ligne doit exister dans les lignes du réseau 
                      de transport                                             *)
  (* @Postcondition : vous devez avoir au plus 2 directions pour un numero de
 		      ligne donné                                              *)
  let lister_stations_sur_itineraire_ligne ?(date = Some (date_actuelle ()))
                                           l_num =
    (* Remplacer la ligne suivante par votre code *)
    raise (Non_Implante "«lister_stations_sur_itineraire_ligne» à compléter")


  (* -- À IMPLANTER/COMPLÉTER (4 PTS) ---------------------------------------- *)
  (* @Fonction      : ligne_passe_par_station : ?date:int option -> string -> int 
                                                -> bool                        *)
  (* @Description   : vérifie si une ligne passe par une station donnée à,
                      éventuellement, une date donnée
                      Rappel: un numéro de ligne peut être associé à
		      plusieurs ligne_id dans la table de hachage lignes.      
                      Faites attention si vous réutilisez 
                      trouver_voyages_sur_la_ligne.                            *)
  (* @Precondition  : la ligne et la station existe                            *)
  (* @Postcondition : true si c'est le cas et false sinon                      *)
  let ligne_passe_par_station ?(date = Some (date_actuelle ())) l_num st_id =
    if not (H.mem lignes l_num) then raise (Erreur "Ligne invalide");
    if not(H.mem stations st_id) then raise(Erreur "Station inexistante ");
    let l_num = "800" and st_id = station_desjardins' and date = date_actuelle () in (
      let v_ids = trouver_voyages_sur_la_ligne ~date:(Some date) l_num in (
        if L.mem true (L.map (fun v_id -> H.mem arrets (st_id, v_id)) v_ids) then true else false;
      )
    )

                               
  (* --  À IMPLANTER/COMPLÉTER (12 PTS) -------------------------------------- *)
  (* @Fonction      : duree_du_prochain_voyage_partant : 
                      ?date:int -> ?heure:int -> string -> int -> int -> int   *)
  (* @Description   : cette fonction répond à la question:  Si je prends le 
                      prochain bus de la ligne "XX" à l'arret "YY"  dans combien 
		      de temps j'arrive à l'arrêt "ZZ" (proche de 
                      maison ou transfert) ?
		      Le résultat attendu doit être en minute (nb_secondes/60)
		      Rappel: un numéro de ligne peut être associé à
		      plusieurs ligne_id dans la table de hachage lignes. 
                      Faites attention si vous réutilisez 
                      trouver_voyages_sur_la_ligne.                            *)
  (* @Precondition  : 1- date valide et pris en charge
                      2- heure valide 
                      3-4- les stations et la ligne existent     
		      5- la ligne passe par les deux stations                  *)
  (* @Postcondition : la sortie est un nombre enier positif                    *)
  let duree_du_prochain_voyage_partant ?(date =date_actuelle ())
                                       ?(heure =heure_actuelle ())
                                       l_num st_id_dep st_id_dest = 
    if not(H.mem services date) then raise(Erreur "Date invalide ou pas prise en charge");
    if heure < 0 then raise(Erreur "Heure négative");
    if not (H.mem lignes l_num) then raise (Erreur "Ligne invalide");
    if not(H.mem stations st_id_dep) || not(H.mem stations st_id_dest) then raise(Erreur "Station inexistante ");
    
    let v_ids = trouver_voyages_sur_la_ligne ~date:(Some date) l_num in (
      let arrets_dep_list = (L.fold_left (fun acc v_id -> L.append (H.find_all arrets (st_id_dep,v_id)) acc) [] v_ids) in (
        if (L.length arrets_dep_list = 0) then raise(Erreur "La ligne ne passe pas par la station de départ");

        let arrets_dep_trie_heure = (L.fold_left (fun acc a -> if a.depart >= heure then a::acc else acc;) [] arrets_dep_list) in (
          let arret_dep = L.hd arrets_dep_trie_heure in (
            let arret_arr = (try H.find arrets (st_id_dest, arret_dep.voyage_id) with 
             | Not_found -> raise(Erreur "La ligne ne passe pas par la station de destination")
           ) in (
              (arret_arr.arrivee - arret_dep.depart)/60
            )
          )
        )
      )
    )
                                                           

  (* -- À IMPLANTER/COMPLÉTER (12 PTS) --------------------------------------- *)
  (* @Fonction      : duree_attente_prochain_arret_ligne_a_la_station : 
                      ?date:int -> ?heure:int -> string -> int -> int          *)
  (* @Description   : cette fonction répond à la question:  combien de minutes 
                      avant l'arrivée de la ligne "XX" à l'arret "YY"?
		      Le résultat attendu doit être en minute (nb_secondes/60) 
		      Rappel: un numéro de ligne peut être associé à
		      plusieurs ligne_id dans la table de hachage lignes. 
                      Faites attention si vous réutilisez 
                      trouver_voyages_sur_la_ligne.                            *)
  (* @Precondition  : 1- date valide et pris en charge
                      2- heure valide 
                      3-4- la station et la ligne existent   
		      5- la ligne passe par la station                         *)
  (* @Postcondition : la sortie est un nombre entier positif                   *)
  let duree_attente_prochain_arret_ligne_a_la_station ?(date=date_actuelle ())
                                                      ?(heure=heure_actuelle ())
                                                      l_num st_id =  
    (* Remplacer la ligne suivante par votre code *)
    raise (Non_Implante
             "«duree_attente_prochain_arret_ligne_a_la_station» à compléter")

                                   
  (* -- À IMPLANTER/COMPLÉTER (10 PTS) --------------------------------------- *)
  (* @Fonction      : ligne_arrive_le_plus_tot : 
                      ?date:int -> ?heure:int -> int -> int -> string          *)
  (* @Description   : trouve la ligne qui arrive le plus vite à la destinnation 
                      donnée étant donnée une station de départ st_dep 
		      ex: si la "800" arrive dans 10 min et fait 15min de voyage 
                      mais la "11" arrive dans 2 min et fait 20min de voyage 
                      alors le résultat c'est "11"                            *)
  (* @Precondition  : 1- date valide et pris en charge
                      2- heure valide 
                      3- les deux stations existent     
                      4- Il existe au moins une ligne qui joint les deux 
                         stations                                              *)
  (* @Postcondition : la sortie est un numéro de ligne existant sur le réseau  *)
  let ligne_arrive_le_plus_tot ?(date =date_actuelle ())
                               ?(heure =heure_actuelle ())
                               st_id_dep st_id_dest  =
    (* Remplacer la ligne suivante par votre code *)
    raise (Non_Implante "«ligne_arrive_le_plus_tot» à compléter")

              
  (* -- À IMPLANTER/COMPLÉTER (8 PTS) ---------------------------------------- *)
  (* @Fonction      : ligne_met_le_moins_temps : 
                      ?date:int -> ?heure:int -> int -> int -> string * int    *)
  (* @Description   : trouve la ligne qui met le moins de temps avant pour 
                      aller d'une station st_dep à une autre st_dest           *)
  (* @Precondition  : 1- date valide et pris en charge
                      2- heure valide 
                      3- les deux stations existent   
                      4- il existe au moins une ligne qui joint les deux 
                         stations                                              *)
  (* @Postcondition : la sortie est un numéro de ligne existant sur le 
                      réseau, ainsi que la durée du trajet                     *)
  let ligne_met_le_moins_temps ?(date =date_actuelle ())
                               ?(heure =heure_actuelle ())
                               st_id_dep st_id_dest = 
    (* Remplacer la ligne suivante par votre code *)
    raise (Non_Implante "«ligne_met_le_moins_temps» à compléter")

end;;



