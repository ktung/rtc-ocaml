(* --------------------------------------------------------------------------- *)
(* ----------------------- TP1 - IFT-3000 - Hiver 2016 ----------------------- *)
(* --------------------------------------------------------------------------- *)
(* Matricule �tudiant: .........                                               *)
(* --------------------------------------------------------------------------- *)
(* -- PRINCIPALE FICHIER DU TP: FONCTIONS � COMPL�TER ------------------------ *)
(* --------------------------------------------------------------------------- *)

(* #use "reseau.ml";; *)
#use "tp1.mli";;
 
module Gestionnaire_transport : GESTIONNAIRE_TRANSPORT = struct
  
  open Utiles
  open Date
  open Reseau_de_transport

  (* Pour �viter conflits de noms entre List et Hashtbl, ne les ouvrez pas;    *)
  (* Allez-y avec la �notation point� en utilisant les abr�viations suivantes  *)
  module L = List
  module H = Hashtbl

               
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      : map_voyages_passants_itineraire : 
                      ?heure:int -> int -> int -> 
                      (arret * arret * string -> 'a) -> string list -> 'a list *)
  (* @Description   : applique une fonction f pass�e en argument seulement aux 
                      paires d'arr�ts respectivement aux stations de d�part et 
                      de destination (pass�es en arguments), ainsi qu'� chaque
                      voyage qui comprend chacune des paires d'arr�ts, et qui
                      fait partie de la liste de voyages pass�s en argument    *)
  (* @Precondition  : 1- les stations de d�part et de destination existent        
                      2- heure valide                                          *)
  (* @Postcondition : la liste doit �tre correcte m�me si l'ordre n'est pas 
                      important                                                *)
  let map_voyages_passants_itineraire ?(heure = heure_actuelle ())
                                      st_dep st_dest f v_ids =  
    (* Traitement correspondant aux pr�conditions *)
    if not (H.mem stations st_dep) then
      raise (Erreur "Station de d�part inexistante ");
    if not (H.mem stations st_dest) then
      raise (Erreur "Station de destination inexistante ");
    if heure < 0 then raise (Erreur "Heure n�gative");
    (* Traitement correspondant � la fonction *)
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
  (* @Description   : liste tous les numeros des lignes du r�seau i.e "800",...*)
  (* @Precondition  : aucune                                                   *)
  (* @Postcondition : la liste retourn�e est correcte                          *)
  let lister_numero_lignes () =        
    (* Traitement correspondant � la fonction *)
    cles lignes

         
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      : lister_id_stations : unit -> int list                    *)
  (* @Description   : liste tous les numeros des stations du r�seau            *)
  (* @Precondition  : aucune                                                   *)
  (* @Postcondition : la liste retourn�e est correcte                          *)
  let lister_id_stations () = 
    (* Traitement correspondant � la fonction *)
    cles stations

         
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      : lister_numero_lignes_par_type : 
                      ?types:type_ligne list -> unit 
                      -> (type_ligne * string list) list                       *)
  (* @Description   : liste tous les numeros des lignes du r�seau  group�s par 
                      type dans la liste de types en param�tre,...             *)
  (* @Precondition  : aucune                                                   *)
  (* @Postcondition : la liste retourn�e est correcte                          *)

         
  let lister_numero_lignes_par_type
        ?(types = [ MetroBus; Express; LeBus; CoucheTard ]) () =      
    (* Traitement correspondant � la fonction *)
    let cles = lister_numero_lignes () in
    let values = L.map (fun cle -> H.find lignes cle) cles in 
    let valeurs_par_type t = L.find_all (fun l -> l.le_type = t) values in
    L.map (fun t -> t, L.map (fun l -> l.numero) (valeurs_par_type t)) types

             
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      : trouver_service : ?date:int -> unit -> string list       *)
  (* @Description   : trouve  les num�ros des services associ�es � une date    *)
  (* @Precondition  : la date doit exister dans les dates r�f�r�es dans la 
                      table de hachage des services (si elle n'y existe pas, la
                      date sera �ventuellement non valide)                     *)
  (* @Postcondition : la liste retourn�e est correcte                          *)
  let trouver_service ?(date =date_actuelle ()) () =
    (* Traitement correspondant aux pr�conditions *)
    if not (H.mem services date) then
      raise (Erreur "Date invalide ou pas prise en charge");
    (* Traitement correspondant � la fonction *)
    H.find_all services date

             
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      : trouver_voyages_par_date : 
                      ?date:int -> unit -> string list                         *)
  (* @Description   : trouve les ids de tous les voyages du r�seau pour une 
                      date donn�e                                              *)
  (* @Precondition  : la date doit exister dans les dates r�f�r�es dans la 
                      table de hachage des services                            *)
  (* @Postcondition : la liste retourn�e est correcte                          *)
  let trouver_voyages_par_date ?(date =date_actuelle ()) ()= 
    (* Traitement correspondant � la fonction *)
    let s_ids = trouver_service ~date:date () in
    L.concat(L.map (fun s_id -> H.find_all voyages_par_service s_id) s_ids)

               
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      : trouver_voyages_sur_la_ligne : 
                      ?date:int option -> string -> string list                *)
  (* @Description   : trouve les ids de tous les voyages effectu�s par une 
                      ligne pour une date donn�e (Some d), ou quelque soit la 
                      date (None).
		      Rappel: un num�ro de ligne peut �tre associ� �
		      plusieurs ligne_id dans la table de hachage lignes       *)
  (* @Precondition  : 1- la date doit exister dans les dates r�f�r�es dans la 
                         table de hachage des services
                      2- le numero de ligne doit exister dans les lignes du 
                         r�seau de transport                                   *)
  (* @Postcondition : la liste retourn�e est correcte                          *)
  let trouver_voyages_sur_la_ligne ?(date = Some (date_actuelle ())) l_num = 
    (* Traitement correspondant aux pr�conditions *)
    if not (H.mem lignes l_num) then raise (Erreur "Ligne invalide");
    (* Traitement correspondant � la fonction *)
    let v_ids = match date with Some d -> trouver_voyages_par_date ~date:d ()
                              | None -> cles voyages in
    let l_ids = L.map (fun (l: ligne) -> l.ligne_id)(H.find_all lignes l_num) in
    L.filter (fun v_id -> let v = H.find voyages v_id in L.mem v.ligne_id l_ids)
             v_ids

                
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      : trouver_stations_environnantes : 
                      coordonnees -> float -> (int * float) list               *)
  (* @Description   : trouve toutes les stations dans un rayon pr�cis� en km 
                      par rapport � une coordonn�e GPS. voir la fonction
		      distance dans le module Reseau_de_transport              *)
  (* @Precondition  : 1- la coordonne�e doit �tre valide - voir fonction 
                         valide_coord dans Reseau_de_transport 
                      2- le rayon est positif ou nul                           *)
  (* @Postcondition : la liste de paire (station, distance) doit �tre tri�e par 
                      distance croissante                                      *)
  let trouver_stations_environnantes pos rayon =
    (* Traitement correspondant aux pr�conditions *)
    if not(valide_coord pos) then raise (Erreur "Position GPS invalide");
    if rayon < 0.  then raise (Erreur "Rayon n�gatif");
    (* Traitement correspondant � la fonction *)
    let liste_st =
      H.fold (fun id s acc -> let d = distance pos s.position_gps in
                              if d <= rayon then (id,d)::acc else acc
             )
             stations [] in
    L.sort (fun (_,d) (_,d') -> compare d d') liste_st

	      
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      : lister_lignes_passantes_station : int -> string list     *)
  (* @Description   : Lister toutes les lignes passantes par une station.
		      la r�ponse ne doit pas d�pendre d'une date particuli�re  *)
  (* @Precondition  : la station existe                                        *)
  (* @Postcondition : la liste doit �tre correcte m�me si l'ordre n'est pas 
                      important                                                *)
  let lister_lignes_passantes_station st_id = 
    (* Traitement correspondant aux pr�conditions *)
    if not (H.mem stations st_id) then raise (Erreur "Station inexistante ");
    (* Traitement correspondant � la fonction *)
    let v_ids = uniques (H.find_all arrets_par_station st_id) in
    let l_ids =
      uniques (L.map (fun v_id -> let v = H.find voyages v_id in v.ligne_id)
                     v_ids
              ) in 
    uniques (L.map (fun l_id -> H.find lignes_par_id l_id) l_ids)

            
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      : lister_arrets_par_voyage : string -> int list            *)
  (* @Description   : lister tous les arr�ts se trouvant dans un voyage.
                      la liste est tri�e par le num�ro de s�quence de chaque
                      arr�t.                                                   *)
  (* @Precondition  : le numero du voyage doit exister                         *)
  (* @Postcondition : la liste est correcte                                    *)
  let lister_arrets_par_voyage v_id =
    (* Traitement correspondant aux pr�conditions *)
    if not (H.mem voyages v_id) then raise (Erreur "Voyage inexistant ");
    (* Traitement correspondant � la fonction *)
    let comp_sid s1 s2 = let a1 = H.find arrets (s1, v_id)
                         and a2 = H.find arrets (s2, v_id)
                         in  compare a1.num_sequence a2.num_sequence
    in
    L.sort comp_sid (H.find_all arrets_par_voyage v_id)

		 
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      : trouver_horaire_ligne_a_la_station : 
                      ?date:int -> ?heure:int -> string -> int -> string list  *)
  (* @Description   : trouve l'horaire entier des arriv�es d'une ligne � une 
                      station donn�e, � partir d'une date et d'une heure 
                      donn�es  
		      Rappel: un num�ro de ligne peut �tre associ� �
		      plusieurs ligne_id dans la table de hachage lignes. 
                      Faites attention si vous r�utilisez 
                      trouver_voyages_sur_la_ligne                             *)
  (* @Precondition  : 1- date valide et pris en charge
                      2- heure valide 
                      3-4- la station et la ligne existent 
                      5- la ligne passe par la station                         *)
  (* @Postcondition : la liste doit �tre en ordre croissant de temps           *)
  let trouver_horaire_ligne_a_la_station ?(date =date_actuelle ())
                                         ?(heure =heure_actuelle ())
                                         l_num st_id =
    (* Traitement correspondant aux pr�conditions *)
    if heure < 0 then raise (Erreur "Heure n�gative");
    if not (H.mem stations st_id) then raise (Erreur "Station inexistante ");
    if not (L.mem l_num (lister_lignes_passantes_station st_id)) 
    then raise (Erreur "La ligne ne passe pas par la station");
    (* Traitement correspondant � la fonction *)
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
  (* @Description   : lister pour les directions emprunt�es par la ligne, 
                      dans l'ensemble des stations o� elle s'arr�te (en ordre 
                      de visite - tr�s important - ). 
		      Notez que le r�sultat de cette fonction peut d�pendre 
                      d'un jour particulier. 
		      Vous devez prendre en compte tous les voyages d'une 
                      ligne et pour une direction donn�e  
		      La liste des stations sur l'itin�raire doit �tre la plus 
                      longue possible    
    		      Rappel: un num�ro de ligne peut �tre associ� �
		      plusieurs ligne_id dans la table de hachage lignes.      
                      Faites attention si vous r�utilisez 
                      trouver_voyages_sur_la_ligne. 	                       *)
  (* @Precondition  : le numero de ligne doit exister dans les lignes du r�seau 
                      de transport                                             *)
  (* @Postcondition : vous devez avoir au plus 2 directions pour un numero de
 		      ligne donn�                                              *)
  let lister_stations_sur_itineraire_ligne ?(date = Some (date_actuelle ()))
                                           l_num =
    (* Traitement correspondant aux pr�conditions *)
    if not (H.mem lignes l_num) then raise (Erreur "Ligne inexistante ");
    (* Traitement correspondant � la fonction *)
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
  (* @Description   : v�rifie si une ligne passe par une station donn�e �,
                      �ventuellement, une date donn�e
                      Rappel: un num�ro de ligne peut �tre associ� �
		      plusieurs ligne_id dans la table de hachage lignes.      
                      Faites attention si vous r�utilisez 
                      trouver_voyages_sur_la_ligne.                            *)
  (* @Precondition  : la ligne et la station existe                            *)
  (* @Postcondition : true si c'est le cas et false sinon                      *)
  let ligne_passe_par_station ?(date = Some (date_actuelle ())) l_num st_id =
    (* Traitement correspondant aux pr�conditions *)
    if not (H.mem lignes l_num) then raise (Erreur "Ligne inexistante");
    if not (H.mem stations st_id) then raise (Erreur "Station inexistante");
    (* Traitement correspondant � la fonction *)
    let l1 = trouver_voyages_sur_la_ligne ~date:date l_num in
    let l2 = L.concat (L.map (fun v_id -> H.find_all arrets_par_voyage v_id) l1) in
    L.mem st_id l2

                               
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      : duree_du_prochain_voyage_partant : 
                      ?date:int -> ?heure:int -> string -> int -> int -> int   *)
  (* @Description   : cette fonction r�pond � la question:  Si je prends le 
                      prochain bus de la ligne "XX" � l'arret "YY"  dans combien 
		      de temps j'arrive � l'arr�t "ZZ" (proche de 
                      maison ou transfert) ?
		      Le r�sultat attendu doit �tre en minute (nb_secondes/60)
		      Rappel: un num�ro de ligne peut �tre associ� �
		      plusieurs ligne_id dans la table de hachage lignes. 
                      Faites attention si vous r�utilisez 
                      trouver_voyages_sur_la_ligne.                            *)
  (* @Precondition  : 1- date valide et pris en charge
                      2- heure valide 
                      3-4- les stations et la ligne existent     
		      5- la ligne passe par les deux stations                  *)
  (* @Postcondition : la sortie est un nombre enier positif                    *)
  let duree_du_prochain_voyage_partant ?(date =date_actuelle ())
                                       ?(heure =heure_actuelle ())
                                       l_num st_id_dep st_id_dest = 
    (* Traitement correspondant aux pr�conditions *)
    if heure < 0 then raise (Erreur "Heure invalide");
    if not (ligne_passe_par_station ~date:(Some date) l_num st_id_dep) then
      raise (Erreur "La ligne ne passe pas par la station de d�part");
    if not (ligne_passe_par_station ~date:(Some date) l_num st_id_dest) then
      raise (Erreur "La ligne ne passe pas par la station de destination");
    (* Traitement correspondant � la fonction *)
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
  (* @Description   : cette fonction r�pond � la question:  combien de minutes 
                      avant l'arriv�e de la ligne "XX" � l'arret "YY"?
		      Le r�sultat attendu doit �tre en minute (nb_secondes/60) 
		      Rappel: un num�ro de ligne peut �tre associ� �
		      plusieurs ligne_id dans la table de hachage lignes. 
                      Faites attention si vous r�utilisez 
                      trouver_voyages_sur_la_ligne.                            *)
  (* @Precondition  : 1- date valide et pris en charge
                      2- heure valide 
                      3-4- la station et la ligne existent   
		      5- la ligne passe par la station                         *)
  (* @Postcondition : la sortie est un nombre entier positif                   *)
  let duree_attente_prochain_arret_ligne_a_la_station ?(date=date_actuelle ())
                                                      ?(heure=heure_actuelle ())
                                                      l_num st_id =  
    (* Traitement correspondant aux pr�conditions *)
    if heure < 0 then raise (Erreur "Heure n�gative");
    if not (H.mem lignes l_num) then raise (Erreur "Ligne inexistante");
    if not (H.mem stations st_id) then raise (Erreur "Station inexistante");
    if not (ligne_passe_par_station ~date:(Some date) l_num st_id) then
      raise (Erreur "La ligne ne passe pas par la station");
    (* Traitement correspondant � la fonction *)
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
     | [] -> raise (Erreur "Pas de prochain arr�t pour cette ligne-station!")
     | _  -> (top_liste min durees) / 60

                                   
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      : ligne_arrive_le_plus_tot : 
                      ?date:int -> ?heure:int -> int -> int -> string          *)
  (* @Description   : trouve la ligne qui arrive le plus vite � la destinnation 
                      donn�e �tant donn�e une station de d�part st_dep 
		      ex: si la "800" arrive dans 10 min et fait 15min de voyage 
                      mais la "11" arrive dans 2 min et fait 20min de voyage 
                      alors le r�sultat c'est "11"                            *)
  (* @Precondition  : 1- date valide et pris en charge
                      2- heure valide 
                      3- les deux stations existent     
                      4- Il existe au moins une ligne qui joint les deux 
                         stations                                              *)
  (* @Postcondition : la sortie est un num�ro de ligne existant sur le r�seau  *)
  let ligne_arrive_le_plus_tot ?(date =date_actuelle ())
                               ?(heure =heure_actuelle ())
                               st_id_dep st_id_dest  =
    (* Traitement correspondant � la fonction *)
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
    | [] -> raise (Erreur "Pas de prochain tel itin�raire!")
    | _  -> top_liste (fun (a,d) (b,d') -> if d < d' then (a,d) else (b,d')) res

              
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      : ligne_met_le_moins_temps : 
                      ?date:int -> ?heure:int -> int -> int -> string * int    *)
  (* @Description   : trouve la ligne qui met le moins de temps avant pour 
                      aller d'une station st_dep � une autre st_dest           *)
  (* @Precondition  : 1- date valide et pris en charge
                      2- heure valide 
                      3- les deux stations existent   
                      4- il existe au moins une ligne qui joint les deux 
                         stations                                              *)
  (* @Postcondition : la sortie est un num�ro de ligne existant sur le 
                      r�seau, ainsi que la dur�e du trajet                     *)
  let ligne_met_le_moins_temps ?(date =date_actuelle ())
                               ?(heure =heure_actuelle ())
                               st_id_dep st_id_dest = 
    (* Traitement correspondant � la fonction *)
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
    | [] -> raise (Erreur "Pas de prochain tel itin�raire!")
    | _  -> top_liste (fun (a,d) (b,d') -> if d < d' then (a,d) else (b,d')) res 

end;;



