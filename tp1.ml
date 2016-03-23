(* --------------------------------------------------------------------------- *)
(* ----------------------- TP1 - IFT-3000 - Hiver 2016 ----------------------- *)
(* --------------------------------------------------------------------------- *)
(* Matricule étudiant: .........                                               *)
(* --------------------------------------------------------------------------- *)
(* -- PRINCIPALE FICHIER DU TP: FONCTIONS À COMPLÉTER ------------------------ *)
(* --------------------------------------------------------------------------- *)

(* #use "reseau.ml";; *)
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

         
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      : lister_numero_lignes_par_type : 
                      ?types:type_ligne list -> unit 
                      -> (type_ligne * string list) list                       *)
  (* @Description   : liste tous les numeros des lignes du réseau  groupés par 
                      type dans la liste de types en paramètre,...             *)
  (* @Precondition  : aucune                                                   *)
  (* @Postcondition : la liste retournée est correcte                          *)

         
  let lister_numero_lignes_par_type
        ?(types = [ MetroBus; Express; LeBus; CoucheTard ]) () =      
    (* Traitement correspondant à la fonction *)
    let cles = lister_numero_lignes () in
    let values = L.map (fun cle -> H.find lignes cle) cles in 
    let valeurs_par_type t = L.find_all (fun l -> l.le_type = t) values in
    L.map (fun t -> t, L.map (fun l -> l.numero) (valeurs_par_type t)) types

             
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      : trouver_service : ?date:int -> unit -> string list       *)
  (* @Description   : trouve  les numéros des services associées à une date    *)
  (* @Precondition  : la date doit exister dans les dates référées dans la 
                      table de hachage des services (si elle n'y existe pas, la
                      date sera éventuellement non valide)                     *)
  (* @Postcondition : la liste retournée est correcte                          *)
  let trouver_service ?(date =date_actuelle ()) () =
    (* Traitement correspondant aux préconditions *)
    if not (H.mem services date) then
      raise (Erreur "Date invalide ou pas prise en charge");
    (* Traitement correspondant à la fonction *)
    H.find_all services date

             
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      : trouver_voyages_par_date : 
                      ?date:int -> unit -> string list                         *)
  (* @Description   : trouve les ids de tous les voyages du réseau pour une 
                      date donnée                                              *)
  (* @Precondition  : la date doit exister dans les dates référées dans la 
                      table de hachage des services                            *)
  (* @Postcondition : la liste retournée est correcte                          *)
  let trouver_voyages_par_date ?(date =date_actuelle ()) ()= 
    (* Traitement correspondant à la fonction *)
    let s_ids = trouver_service ~date:date () in
    L.concat(L.map (fun s_id -> H.find_all voyages_par_service s_id) s_ids)

               
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

                
  (* ------------------------------------------------------------------------- *)
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
    (* Traitement correspondant aux préconditions *)
    if not(valide_coord pos) then raise (Erreur "Position GPS invalide");
    if rayon < 0.  then raise (Erreur "Rayon négatif");
    (* Traitement correspondant à la fonction *)
    let liste_st =
      H.fold (fun id s acc -> let d = distance pos s.position_gps in
                              if d <= rayon then (id,d)::acc else acc
             )
             stations [] in
    L.sort (fun (_,d) (_,d') -> compare d d') liste_st

	      
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      : lister_lignes_passantes_station : int -> string list     *)
  (* @Description   : Lister toutes les lignes passantes par une station.
		      la réponse ne doit pas dépendre d'une date particulière  *)
  (* @Precondition  : la station existe                                        *)
  (* @Postcondition : la liste doit être correcte même si l'ordre n'est pas 
                      important                                                *)
  let lister_lignes_passantes_station st_id = 
    (* Traitement correspondant aux préconditions *)
    if not (H.mem stations st_id) then raise (Erreur "Station inexistante ");
    (* Traitement correspondant à la fonction *)
    let v_ids = uniques (H.find_all arrets_par_station st_id) in
    let l_ids =
      uniques (L.map (fun v_id -> let v = H.find voyages v_id in v.ligne_id)
                     v_ids
              ) in 
    uniques (L.map (fun l_id -> H.find lignes_par_id l_id) l_ids)

            
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      : lister_arrets_par_voyage : string -> int list            *)
  (* @Description   : lister tous les arrêts se trouvant dans un voyage.
                      la liste est triée par le numéro de séquence de chaque
                      arrêt.                                                   *)
  (* @Precondition  : le numero du voyage doit exister                         *)
  (* @Postcondition : la liste est correcte                                    *)
  let lister_arrets_par_voyage v_id =
    (* Traitement correspondant aux préconditions *)
    if not (H.mem voyages v_id) then raise (Erreur "Voyage inexistant ");
    (* Traitement correspondant à la fonction *)
    let comp_sid s1 s2 = let a1 = H.find arrets (s1, v_id)
                         and a2 = H.find arrets (s2, v_id)
                         in  compare a1.num_sequence a2.num_sequence
    in
    L.sort comp_sid (H.find_all arrets_par_voyage v_id)

		 
  (* ------------------------------------------------------------------------- *)
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
    (* Traitement correspondant aux préconditions *)
    if heure < 0 then raise (Erreur "Heure négative");
    if not (H.mem stations st_id) then raise (Erreur "Station inexistante ");
    if not (L.mem l_num (lister_lignes_passantes_station st_id)) 
    then raise (Erreur "La ligne ne passe pas par la station");
    (* Traitement correspondant à la fonction *)
    let horaires = L.fold_left
                     (fun acc vid ->
                       match H.find arrets (st_id, vid) with
                       | a when a.arrivee >= heure -> a.arrivee::acc
                       | _ -> acc
                       | exception _ -> acc
                     )
                     [] (trouver_voyages_sur_la_ligne l_num ~date:(Some date)) in
    L.map secs_a_heure (L.sort compare horaires)

	     
  (* ------------------------------------------------------------------------- *)
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
    (* Traitement correspondant aux préconditions *)
    if not (H.mem lignes l_num) then raise (Erreur "Ligne inexistante ");
    (* Traitement correspondant à la fonction *)
    let th = H.create 10000 in
    let _ = L.iter (fun v_id -> let v = H.find voyages v_id in 
                                H.add th v.destination
                                         (lister_arrets_par_voyage v.voyage_id)
                   ) (trouver_voyages_sur_la_ligne ~date:date l_num) in
    let max' x y = if (List.length x) > (List.length y) then x else y in
    L.map (fun dest -> dest, top_liste max' (H.find_all th dest)) (cles th)


  (* ------------------------------------------------------------------------- *)
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
    (* Traitement correspondant aux préconditions *)
    if not (H.mem lignes l_num) then raise (Erreur "Ligne inexistante");
    if not (H.mem stations st_id) then raise (Erreur "Station inexistante");
    (* Traitement correspondant à la fonction *)
    let l1 = trouver_voyages_sur_la_ligne ~date:date l_num in
    let l2 = L.concat (L.map (fun v_id -> H.find_all arrets_par_voyage v_id) l1) in
    L.mem st_id l2

                               
  (* ------------------------------------------------------------------------- *)
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
    (* Traitement correspondant aux préconditions *)
    if heure < 0 then raise (Erreur "Heure invalide");
    if not (ligne_passe_par_station ~date:(Some date) l_num st_id_dep) then
      raise (Erreur "La ligne ne passe pas par la station de départ");
    if not (ligne_passe_par_station ~date:(Some date) l_num st_id_dest) then
      raise (Erreur "La ligne ne passe pas par la station de destination");
    (* Traitement correspondant à la fonction *)
     let comp = fun (a1,d1) (a2,d2) -> if a1.arrivee <= a2.arrivee
                                       then (a1,d1)
                                       else (a2,d2) in
    let arrets_au_dep = map_voyages_passants_itineraire
                          ~heure:heure st_id_dep st_id_dest
                          (fun (a,a',_) -> (a,a'))
                          (trouver_voyages_sur_la_ligne l_num ~date:(Some date))
    in
    match arrets_au_dep with
    | [] -> raise (Erreur "Pas de tel prochain voyage pour la ligne!")
    | _  ->  let res = top_liste comp arrets_au_dep
             in ((snd res).arrivee - (fst res).arrivee) / 60
                                                            

  (* ------------------------------------------------------------------------- *)
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
    (* Traitement correspondant aux préconditions *)
    if heure < 0 then raise (Erreur "Heure négative");
    if not (H.mem lignes l_num) then raise (Erreur "Ligne inexistante");
    if not (H.mem stations st_id) then raise (Erreur "Station inexistante");
    if not (ligne_passe_par_station ~date:(Some date) l_num st_id) then
      raise (Erreur "La ligne ne passe pas par la station");
    (* Traitement correspondant à la fonction *)
     let durees =
      L.fold_left 
        (fun acc v_id ->
          match H.find arrets (st_id, v_id) with
          | a when (a.arrivee - heure) >= 0 -> (a.arrivee - heure)::acc
          | _ -> acc
          | exception _ -> acc
        )
        [] (trouver_voyages_sur_la_ligne l_num ~date:(Some date)) in
     match durees with
     | [] -> raise (Erreur "Pas de prochain arrêt pour cette ligne-station!")
     | _  -> (top_liste min durees) / 60

                                   
  (* ------------------------------------------------------------------------- *)
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
    (* Traitement correspondant à la fonction *)
    let l_nums = map_voyages_passants_itineraire
                   ~heure:heure st_id_dep st_id_dest
                   (fun (_,_,v) -> H.find lignes_par_id
                                          H.(find voyages v).ligne_id)
                   (trouver_voyages_par_date ~date:date ()) in
    let res = L.map
                (fun l_num ->
                  let dep_dans = duree_attente_prochain_arret_ligne_a_la_station
                                      ~date:date ~heure:heure l_num st_id_dep
                  and duree = duree_du_prochain_voyage_partant
                                ~date:date ~heure:heure l_num st_id_dep st_id_dest
                  in 
	          (l_num, dep_dans + duree)
                )
                l_nums in
    match res with
    | [] -> raise (Erreur "Pas de prochain tel itinéraire!")
    | _  -> top_liste (fun (a,d) (b,d') -> if d < d' then (a,d) else (b,d')) res

              
  (* ------------------------------------------------------------------------- *)
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
    (* Traitement correspondant à la fonction *)
    let l_nums = map_voyages_passants_itineraire
                   ~heure:heure st_id_dep st_id_dest
                   (fun (_,_,v) -> H.find lignes_par_id
                                          (H.find voyages v).ligne_id)
                   (trouver_voyages_par_date ~date:date ()) in
    let res = L.map (fun l_num -> (l_num, duree_du_prochain_voyage_partant
                                            ~date:date ~heure:heure l_num
                                            st_id_dep st_id_dest)
                    )
                    l_nums in
    match res with
    | [] -> raise (Erreur "Pas de prochain tel itinéraire!")
    | _  -> top_liste (fun (a,d) (b,d') -> if d < d' then (a,d) else (b,d')) res 

end;;



