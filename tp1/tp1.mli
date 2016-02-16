(* --------------------------------------------------------------------------- *)
(* ----------------------- TP1 - IFT-3000 - Hiver 2016 ----------------------- *)
(* --------------------------------------------------------------------------- *)

(* --------------------------------------------------------------------------- *)
(* -- PRINCIPALE FICHIER DU TP: SIGNATURES DES FONCTIONS À COMPLÉTER --------- *)
(* --------------------------------------------------------------------------- *)

module type GESTIONNAIRE_TRANSPORT = sig
  (* Fonctions fournies - déjà implantées *)
  val map_voyages_passants_itineraire : ?heure:int -> int -> int
                                        -> (Reseau_de_transport.arret
                                            * Reseau_de_transport.arret
                                            * string -> 'a)
                                        -> string list -> 'a list
  val lister_numero_lignes: unit -> string list
  val lister_id_stations: unit -> int list
  val trouver_voyages_sur_la_ligne: ?date:int option -> string -> string list

  (* Fonctions à compléter/à implanter    *)
  val lister_numero_lignes_par_type :
    ?types:Reseau_de_transport.type_ligne list ->
    unit -> (Reseau_de_transport.type_ligne * string list) list
  val trouver_service: ?date:int -> unit -> string list
  val trouver_voyages_par_date: ?date:int -> unit -> string list
  val trouver_stations_environnantes: Reseau_de_transport.coordonnees -> float
                                      -> (int * float) list
  val lister_lignes_passantes_station: int -> string list
  val lister_arrets_par_voyage: string -> int list
  val trouver_horaire_ligne_a_la_station: ?date:int -> ?heure:int -> string
                                          -> int -> string list
  val lister_stations_sur_itineraire_ligne: ?date:int option -> string
                                            -> (string * int list) list
  val ligne_passe_par_station: ?date:int option -> string -> int -> bool
  val duree_du_prochain_voyage_partant: ?date:int -> ?heure:int -> string
                                        -> int -> int -> int
  val duree_attente_prochain_arret_ligne_a_la_station: ?date:int -> ?heure:int
                                                       -> string -> int -> int
  val ligne_arrive_le_plus_tot: ?date:int -> ?heure:int -> int -> int
                                -> string * int
  val ligne_met_le_moins_temps: ?date:int -> ?heure:int -> int -> int
                                -> string * int
                                                                           
end;;
   
