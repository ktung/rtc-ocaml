(* --------------------------------------------------------------------------- *)
(* ----------------------- TP1 - IFT-3000 - Hiver 2016 ----------------------- *)
(* --------------------------------------------------------------------------- *)

(* --------------------------------------------------------------------------- *)
(* -- STRUCTURES DE DONNÉES ET FONCTIONS POUR PEUPLER LES TABLES DE HACHAGE -- *)
(* --------------------------------------------------------------------------- *)

#use "utiles.ml";;
  
module Reseau_de_transport = struct

  open Utiles
  open Date

  module L = List
  module H = Hashtbl
	
  (* -- STRUCTURES DE DONNÉES ------------------------------------------------ *)

  (* -- Lignes - routes.txt -------------------------------------------------- *)
  type ligne = 
    {
      ligne_id : int;
      numero : string;
      noms_terminaux : string * string;
      le_type : type_ligne;
    }
  and type_ligne = MetroBus | Express | LeBus | CoucheTard 

  (* -- Le type du bus inféré à partir de la couleur est du «hack»             *)
  let new_type_ligne couleur = match couleur with
    | "013888" -> LeBus
    | "E04503" -> Express
    | "97BF0D" -> MetroBus
    | "1A171B" -> CoucheTard
    | _ -> raise (Failure "La couleur du bus est invalide")
                 
  let new_ligne liste =
    {
      ligne_id = int_of_string (L.nth liste 0);
      numero = enlever_guillemets (L.nth liste 2);
      noms_terminaux = 
	(let temp = decouper_chaine (enlever_guillemets (L.nth liste 4)) " - " in
         (L.nth temp 0), (L.nth temp 1));
      le_type = new_type_ligne (L.nth liste 7);
    }
    
  (* -- Stations - stops.txt ------------------------------------------------- *)
  type station = 
    {
      station_id : int;
      nom : string;
      description : string;
      position_gps : coordonnees;
      embarque_chaise : bool;
    }
   and coordonnees = 
    {
      latitude : float;
      longitude : float;
    }
	
  let valide_coord c = 
    (* Cette fonction valide si une coordonnée géographique est correct        *)
    c.latitude >= 0.
    && c.latitude <= 90.
    && c.longitude >= -180.
    && c.longitude <= 180.
 		
  let distance a b = 
    (* Cette fonction calcule la distance à vol d'oiseau entre deux points de 
       la terre indiqués par leurs coordonnées gps. 
       Pour plus de renseignements, visiter:
        http://www.mapanet.eu/EN/Resources/Script-Distance.htm  
    *)
    let pi = 3.14159265358979323846 in 
    let pi_rad = pi /. 180. in
    let lat1 = a.latitude *. pi_rad in
    let lon1 = a.longitude *. pi_rad in
    let lat2 = b.latitude *. pi_rad in
    let lon2 = b.longitude *. pi_rad in
    6378.137 *. acos( (cos lat1) *. (cos lat2) *. (cos (lon2 -. lon1))
                      +.(sin lat1) *. (sin lat2) )

  let new_station liste =
    {
      station_id = int_of_string (L.nth liste 0);
      nom = enlever_guillemets (L.nth liste 1);
      description = enlever_guillemets (L.nth liste 2);
      position_gps = { latitude = float_of_string (L.nth liste 3) ; 
		       longitude = float_of_string (L.nth liste 4) };
      embarque_chaise = 
	(if int_of_string (L.nth liste 7) = 1 then true else false);
    }
    
  (* -- Voyages - trips.txt -------------------------------------------------- *)
    
  type voyage = 
    {
      voyage_id : string;
      ligne_id : int;
      service_id : string;
      destination : string;
      direction_voyage : direction;
      itineraire_id : int;
      embarque_chaise : bool;
    }
   and direction = Aller | Retour
	
  let new_voyage liste =
    {
      voyage_id = L.nth liste 2;
      ligne_id = int_of_string (L.nth liste 0);
      service_id = L.nth liste 1;
      destination = enlever_guillemets (L.nth liste 3);
      direction_voyage = 
	(if int_of_string (L.nth liste 5) = 0 then Aller else Retour);
      itineraire_id = int_of_string (L.nth liste 7);
      embarque_chaise = 
	(if int_of_string (L.nth liste 8) = 1 then true else false);
    }
	
  (* -- Arrêts - stop_times.txt ---------------------------------------------- *)
  type arret = 
    {
      station_id : int;
      voyage_id : string;
      arrivee : int;
      depart : int;
      num_sequence : int;
      embarque_client : bool;
      debarque_client : bool;
    }
		 
  let new_arret liste = 
    {
      station_id = int_of_string (L.nth liste 3);
      voyage_id = L.nth liste 0;
      arrivee = heure_a_nbsecs (L.nth liste 1);
      depart = heure_a_nbsecs (L.nth liste 2);
      num_sequence = int_of_string (L.nth liste 4);
      embarque_client = 
	(if int_of_string (L.nth liste 5) = 0 then true else false);
      debarque_client = 
	(if int_of_string (L.nth liste 6) = 0 then true else false);
    }
	
  (* -- Services - calendar_dates.txt ---------------------------------------- *)
  type service = 
    {
      service_id : string;
      date : int;
    }
    
  let new_service liste = 
    {
      service_id = L.nth liste 0;
      date = date_a_nbjours (L.nth liste 1);
    }
           
  (* -- TABLES DE HACHAGE ---------------------------------------------------- *)
         
  (* -- Création de tables de hachage ---------------------------------------- *)
  let lignes = H.create 5000
  let lignes_par_id = H.create 5000

  let stations = H.create 100000

  let voyages = H.create 500000 
  let voyages_par_service = H.create 500000 
  let voyages_par_ligne = H.create 500000 

  let arrets = H.create 3000000 
  let arrets_par_voyage = H.create 3000000 
  let arrets_par_station = H.create 3000000 

  let services = H.create 100000

  (* -- CHARGEMENT DONNÉES --------------------------------------------------- *)

  (* -- Principale fonctions pour chargement de données ---------------------- *)
  let charger_donnees fichier record_constructor =
    let f = try open_in fichier with _ -> raise (Erreur "Fichier inacessible") in
    (* on ignore l'entête qui correspond aux titres des colonnes               *)
    let _ = try input_line f with _ -> raise (Erreur "Fichier vide") in 
    let rec aux acc =
      match input_line f with
      | s -> aux ((record_constructor (decouper_chaine s ",")) :: acc)
      | exception End_of_file -> L.rev acc 
    in
    aux []
                            
  (* -- Chargement de fichier et remplissage des tables de hachage ----------- *)
  let charger_tout ?(rep = "/home/etudiant/workspace/tp1/rtc_data/") () =
    L.iter (fun (l: ligne) -> H.add lignes  l.numero l;
			      H.add lignes_par_id l.ligne_id  l.numero)
           (charger_donnees (rep ^ "routes.txt") new_ligne);
    L.iter (fun (s: station) -> H.add stations s.station_id s)
           (charger_donnees (rep ^ "stops.txt") new_station);
    L.iter (fun (v: voyage) -> H.add voyages v.voyage_id v; 
			       H.add voyages_par_service v.service_id
                                     v.voyage_id;
			       H.add voyages_par_ligne v.ligne_id
                                     v.voyage_id)
           (charger_donnees (rep ^ "trips.txt") new_voyage);
    L.iter (fun (a: arret) -> H.add arrets (a.station_id, a.voyage_id) a;
			      H.add arrets_par_voyage a.voyage_id a.station_id;
			      H.add arrets_par_station a.station_id a.voyage_id)
           (charger_donnees (rep ^ "stop_times.txt") new_arret);
    L.iter (fun (s: service) -> H.add services s.date s.service_id)
           (charger_donnees (rep ^ "calendar_dates.txt") new_service);
    print_endline "CHARGEMENT DES DONNÉES TERMINÉ"
                  
end;;
