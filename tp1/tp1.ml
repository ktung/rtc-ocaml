(* --------------------------------------------------------------------------- *)
(* ----------------------- TP1 - IFT-3000 - Hiver 2016 ----------------------- *)
(* --------------------------------------------------------------------------- *)
(* Matricule �tudiant: .........                                               *)
(* --------------------------------------------------------------------------- *)
(* -- PRINCIPALE FICHIER DU TP: FONCTIONS � COMPL�TER ------------------------ *)
(* --------------------------------------------------------------------------- *)

#use "reseau.ml";;
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

         
  (* -- � IMPLANTER/COMPL�TER (6 PTS) ---------------------------------------- *)
  (* @Fonction      : lister_numero_lignes_par_type : 
                      ?types:type_ligne list -> unit 
                      -> (type_ligne * string list) list                       *)
  (* @Description   : liste tous les numeros des lignes du r�seau  group�s par 
                      type dans la liste de types en param�tre,...             *)
  (* @Precondition  : aucune                                                   *)
  (* @Postcondition : la liste retourn�e est correcte                          *)
  let lister_numero_lignes_par_type
        ?(types = [ MetroBus; Express; LeBus; CoucheTard ]) () =      
    (* Remplacer la ligne suivante par votre code *)
    raise (Non_Implante "�lister_numero_lignes_par_type� � compl�ter")

             
  (* -- � IMPLANTER/COMPL�TER (4 PTS) ---------------------------------------- *)
  (* @Fonction      : trouver_service : ?date:int -> unit -> string list       *)
  (* @Description   : trouve  les num�ros des services associ�es � une date    *)
  (* @Precondition  : la date doit exister dans les dates r�f�r�es dans la 
                      table de hachage des services (si elle n'y existe pas, la
                      date sera �ventuellement non valide)                     *)
  (* @Postcondition : la liste retourn�e est correcte                          *)
  let trouver_service ?(date =date_actuelle ()) () =
    (* Remplacer la ligne suivante par votre code *)
    raise (Non_Implante "�trouver_service� � compl�ter")

             
  (* -- � IMPLANTER/COMPL�TER (4 PTS) ---------------------------------------- *)
  (* @Fonction      : trouver_voyages_par_date : 
                      ?date:int -> unit -> string list                         *)
  (* @Description   : trouve les ids de tous les voyages du r�seau pour une 
                      date donn�e                                              *)
  (* @Precondition  : la date doit exister dans les dates r�f�r�es dans la 
                      table de hachage des services                            *)
  (* @Postcondition : la liste retourn�e est correcte                          *)
  let trouver_voyages_par_date ?(date =date_actuelle ()) ()= 
    (* Remplacer la ligne suivante par votre code *)
    raise (Non_Implante "�trouver_voyages_par_date� � compl�ter")

               
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

                
  (* -- � IMPLANTER/COMPL�TER (6 PTS) ---------------------------------------- *)
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
    (* Remplacer la ligne suivante par votre code *)
    raise (Non_Implante "�trouver_stations_environnantes� � compl�ter")

	      
  (* -- � IMPLANTER/COMPL�TER (8 PTS) ---------------------------------------- *)
  (* @Fonction      : lister_lignes_passantes_station : int -> string list     *)
  (* @Description   : Lister toutes les lignes passantes par une station.
		      la r�ponse ne doit pas d�pendre d'une date particuli�re  *)
  (* @Precondition  : la station existe                                        *)
  (* @Postcondition : la liste doit �tre correcte m�me si l'ordre n'est pas 
                      important                                                *)
  let lister_lignes_passantes_station st_id = 
    (* Remplacer la ligne suivante par votre code *)
    raise (Non_Implante "�lister_lignes_passantes_station� � compl�ter")

            
  (* -- � IMPLANTER/COMPL�TER (6 PTS) ---------------------------------------- *)
  (* @Fonction      : lister_arrets_par_voyage : string -> int list            *)
  (* @Description   : lister tous les arr�ts se trouvant dans un voyage.
                      la liste est tri�e par le num�ro de s�quence de chaque
                      arr�t.                                                   *)
  (* @Precondition  : le numero du voyage doit exister                         *)
  (* @Postcondition : la liste est correcte                                    *)
  let lister_arrets_par_voyage v_id =
    (* Remplacer la ligne suivante par votre code *)
    raise (Non_Implante "�lister_arrets_par_voyage� � compl�ter")

		 
  (* -- � IMPLANTER/COMPL�TER (10 PTS) --------------------------------------- *)
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
    (* Remplacer la ligne suivante par votre code *)
    raise (Non_Implante "�trouver_horaire_ligne_a_la_station� � compl�ter")

	     
  (* -- � IMPLANTER/COMPL�TER (10 PTS) --------------------------------------- *)
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
    (* Remplacer la ligne suivante par votre code *)
    raise (Non_Implante "�lister_stations_sur_itineraire_ligne� � compl�ter")


  (* -- � IMPLANTER/COMPL�TER (4 PTS) ---------------------------------------- *)
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
    (* Remplacer la ligne suivante par votre code *)
    raise (Non_Implante "�ligne_passe_par_station� � compl�ter")

                               
  (* --  � IMPLANTER/COMPL�TER (12 PTS) -------------------------------------- *)
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
    (* Remplacer la ligne suivante par votre code *)
    raise (Non_Implante "�duree_du_prochain_voyage_partant� � compl�ter")
                                                           

  (* -- � IMPLANTER/COMPL�TER (12 PTS) --------------------------------------- *)
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
    (* Remplacer la ligne suivante par votre code *)
    raise (Non_Implante
             "�duree_attente_prochain_arret_ligne_a_la_station� � compl�ter")

                                   
  (* -- � IMPLANTER/COMPL�TER (10 PTS) --------------------------------------- *)
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
    (* Remplacer la ligne suivante par votre code *)
    raise (Non_Implante "�ligne_arrive_le_plus_tot� � compl�ter")

              
  (* -- � IMPLANTER/COMPL�TER (8 PTS) ---------------------------------------- *)
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
    (* Remplacer la ligne suivante par votre code *)
    raise (Non_Implante "�ligne_met_le_moins_temps� � compl�ter")

end;;


