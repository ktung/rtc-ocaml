        OCaml version 4.02.3

(* PREMIERE UTILISATION ------------------------------------------------------*)

# #use "reseau.ml";;
exception Erreur of string
exception Non_Implante of string
module Utiles :
  sig
    module U = Unix
    module S = String
    module L = List
    val timeRun : ('a -> 'b) -> 'a -> 'b * float
    val decouper_chaine : string -> string -> string list
    val enlever_guillemets : string -> string
    val uniques : 'a list -> 'a list
    val top_liste : ('a -> 'a -> 'a) -> 'a list -> 'a
    val ( ++ ) : 'a list -> 'a list -> 'a list
    val cles : ('a, 'b) Hashtbl.t -> 'a list
  end
module Date :
  sig
    module S = String
    module L = List
    val date_a_nbjours : string -> int
    val date_actuelle : unit -> int
    val heure_a_nbsecs : string -> int
    val secs_a_heure : int -> string
    val heure_actuelle : unit -> int
  end
module Reseau_de_transport :
  sig
    module L = List
    module H = Hashtbl
    type ligne = {
      ligne_id : int;
      numero : string;
      noms_terminaux : string * string;
      le_type : type_ligne;
    }
    and type_ligne = MetroBus | Express | LeBus | CoucheTard
    val new_type_ligne : string -> type_ligne
    val new_ligne : string list -> ligne
    type station = {
      station_id : int;
      nom : string;
      description : string;
      position_gps : coordonnees;
      embarque_chaise : bool;
    }
    and coordonnees = { latitude : float; longitude : float; }
    val valide_coord : coordonnees -> bool
    val distance : coordonnees -> coordonnees -> float
    val new_station : string list -> station
    type voyage = {
      voyage_id : string;
      ligne_id : int;
      service_id : string;
      destination : string;
      direction_voyage : direction;
      itineraire_id : int;
      embarque_chaise : bool;
    }
    and direction = Aller | Retour
    val new_voyage : string list -> voyage
    type arret = {
      station_id : int;
      voyage_id : string;
      arrivee : int;
      depart : int;
      num_sequence : int;
      embarque_client : bool;
      debarque_client : bool;
    }
    val new_arret : string list -> arret
    type service = { service_id : string; date : int; }
    val new_service : string list -> service
    val lignes : (string, ligne) H.t
    val lignes_par_id : (int, string) H.t
    val stations : (int, station) H.t
    val voyages : (string, voyage) H.t
    val voyages_par_service : (string, string) H.t
    val voyages_par_ligne : (int, string) H.t
    val arrets : (int * string, arret) H.t
    val arrets_par_voyage : (string, int) H.t
    val arrets_par_station : (int, string) H.t
    val services : (int, string) H.t
    val charger_donnees : string -> (string list -> 'a) -> 'a list
    val charger_tout : ?rep:string -> unit -> unit
  end
# #use "tp1.ml";;
module type GESTIONNAIRE_TRANSPORT =
  sig
    val map_voyages_passants_itineraire :
      ?heure:int ->
      int ->
      int ->
      (Reseau_de_transport.arret * Reseau_de_transport.arret * string -> 'a) ->
      string list -> 'a list
    val lister_numero_lignes : unit -> string list
    val lister_id_stations : unit -> int list
    val trouver_voyages_sur_la_ligne :
      ?date:int option -> string -> string list
    val lister_numero_lignes_par_type :
      ?types:Reseau_de_transport.type_ligne list ->
      unit -> (Reseau_de_transport.type_ligne * string list) list
    val trouver_service : ?date:int -> unit -> string list
    val trouver_voyages_par_date : ?date:int -> unit -> string list
    val trouver_stations_environnantes :
      Reseau_de_transport.coordonnees -> float -> (int * float) list
    val lister_lignes_passantes_station : int -> string list
    val lister_arrets_par_voyage : string -> int list
    val trouver_horaire_ligne_a_la_station :
      ?date:int -> ?heure:int -> string -> int -> string list
    val lister_stations_sur_itineraire_ligne :
      ?date:int option -> string -> (string * int list) list
    val ligne_passe_par_station : ?date:int option -> string -> int -> bool
    val duree_du_prochain_voyage_partant :
      ?date:int -> ?heure:int -> string -> int -> int -> int
    val duree_attente_prochain_arret_ligne_a_la_station :
      ?date:int -> ?heure:int -> string -> int -> int
    val ligne_arrive_le_plus_tot :
      ?date:int -> ?heure:int -> int -> int -> string * int
    val ligne_met_le_moins_temps :
      ?date:int -> ?heure:int -> int -> int -> string * int
  end
module Gestionnaire_transport : GESTIONNAIRE_TRANSPORT
# #use "testeur.ml";;
val fail : unit -> unit = <fun>
val pass : unit -> unit = <fun>
val assert_equal : string -> 'a -> 'a -> unit = <fun>
val assert_equal_list : string -> 'a list -> 'a list -> unit = <fun>
val assert_throw_exception : string -> (unit -> 'a) -> unit = <fun>
val assert_true : string -> (unit -> bool) -> unit = <fun>
val test1 : unit -> unit = <fun>
val test2 : unit -> unit = <fun>
val test3 : unit -> unit = <fun>
val test4 : unit -> unit = <fun>
val test5 : unit -> unit = <fun>
val test6 : unit -> unit = <fun>
val test7 : unit -> unit = <fun>
val test8 : unit -> unit = <fun>
val test9 : unit -> unit = <fun>
val test10 : unit -> unit = <fun>
val test11 : unit -> unit = <fun>
val test12 : unit -> unit = <fun>
val test13 : unit -> unit = <fun>
val test : unit -> unit = <fun>
val test' : unit -> unit = <fun>


(* PREMIERE UTILISATION => VERSION TEST QUI CHARGE LES DONNÉES ---------------*)

# test'();;
CHARGEMENT DES DONNﾉES TERMINﾉ
*** DUREE CHARGEMENT: 26.0 sec

-------
D-TESTS
-------

LISTER_NUMERO_LIGNES_PAR_TYPE@LONGUEUR_BUS_CORRECT
.....................Pass
LISTER_NUMERO_LIGNES_PAR_TYPE@CONTENU_BUS _CORRECT
.....................Pass
LISTER_NUMERO_LIGNES_PAR_TYPE@LONGUEUR_METROBUS_CORRECT
.....................Pass
LISTER_NUMERO_LIGNES_PAR_TYPE@CONTENU_METROBUS _CORRECT
.....................Pass
LISTER_NUMERO_LIGNES_PAR_TYPE@LONGUEUR_COUCHETARD_CORRECT
.....................Pass
LISTER_NUMERO_LIGNES_PAR_TYPE@CONTENU_COUCHETARD_CORRECT
.....................Pass
LISTER_NUMERO_LIGNES_PAR_TYPE@LONGUEUR_EXPRESS_CORRECT
.....................Pass
LISTER_NUMERO_LIGNES_PAR_TYPE@CONTENU_EXPRESS_CORRECT
.....................Pass
LISTER_NUMERO_LIGNES_PAR_TYPE@LONGUEUR_CORRECT
.....................Pass
*** DUREE TEST: 0.0 sec


TROUVER_SERVICE@LONGUEUR_CORRECT1
.....................Pass
TROUVER_SERVICE@CONTENU_CORRECT1
.....................Pass
TROUVER_SERVICE@LONGUEUR_CORRECT2
.....................Pass
TROUVER_SERVICE@CONTENU_CORRECT2
.....................Pass
TROUVER_SERVICE@DATE_INVALIDE
.....................Pass
*** DUREE TEST: 0.0 sec


TROUVER_VOYAGES_PAR_DATE@LONGUEUR_CORRECT1
.....................Pass
TROUVER_VOYAGES_PAR_DATE@LONGUEUR_CORRECT2
.....................Pass
TROUVER_VOYAGES_PAR_DATE@DATE_INVALIDE
.....................Pass
*** DUREE TEST: 0.0 sec


TROUVER_STATIONS_ENVIRONNANTES@LONGUEUR_CORRECT
.....................Pass
TROUVER_STATIONS_ENVIRONNANTES@CONTENU_CORRECT
.....................Pass
TROUVER_STATIONS_ENVIRONNANTES@CONTENU_EN ORDRE
.....................Pass
TROUVER_STATIONS_ENVIRONNANTES@RAYON_INVALIDE
.....................Pass
TROUVER_STATIONS_ENVIRONNANTES@POSITION_INVALIDE
.....................Pass
*** DUREE TEST: 0.0 sec


LISTER_LIGNES_PASSANTES_STATION@LONGUEUR_CORRECT1
.....................Pass
LISTER_LIGNES_PASSANTES_STATION@CONTENU_CORRECT1
.....................Pass
LISTER_LIGNES_PASSANTES_STATION@LONGUEUR_CORRECT1
.....................Pass
LISTER_LIGNES_PASSANTES_STATION@CONTENU_CORRECT1
.....................Pass
LISTER_LIGNES_PASSANTES_STATION@STATION_INVALIDE
.....................Pass
*** DUREE TEST: 0.1 sec


LISTER_ARRETS_PAR_VOYAGE@LONGUEUR_CORRECT1
.....................Pass
LISTER_ARRETS_PAR_VOYAGE@CONTENU_CORRECT1
.....................Pass
LISTER_ARRETS_PAR_VOYAGE@ORDRE_CORRECT1
.....................Pass
LISTER_ARRETS_PAR_VOYAGE@LONGUEUR_CORRECT2
.....................Pass
LISTER_ARRETS_PAR_VOYAGE@CONTENU_CORRECT2
.....................Pass
LISTER_ARRETS_PAR_VOYAGE@ORDRE_CORRECT2
.....................Pass
LISTER_ARRETS_PAR_VOYAGE@STATION_INVALIDE
.....................Pass
*** DUREE TEST: 0.0 sec


TROUVER_HORAIRE_LIGNE_A_LA_STATION@LONGUEUR_CORRECT1
.....................Pass
TROUVER_HORAIRE_LIGNE_A_LA_STATION@CONTENU_CORRECT1
.....................Pass
TROUVER_HORAIRE_LIGNE_A_LA_STATION@CONTENU_EN ORDRE1
.....................Pass
TROUVER_HORAIRE_LIGNE_A_LA_STATION@LONGUEUR_CORRECT2
.....................Pass
TROUVER_HORAIRE_LIGNE_A_LA_STATION@CONTENU_CORRECT2
.....................Pass
TROUVER_HORAIRE_LIGNE_A_LA_STATION@CONTENU_EN ORDRE2
.....................Pass
TROUVER_HORAIRE_LIGNE_A_LA_STATION@DATE_INVALIDE
.....................Pass
TROUVER_HORAIRE_LIGNE_A_LA_STATION@LIGNE_INVALIDE
.....................Pass
TROUVER_HORAIRE_LIGNE_A_LA_STATION@HEURE_INVALIDE
.....................Pass
TROUVER_HORAIRE_LIGNE_A_LA_STATION@STATION_INVALIDE
.....................Pass
*** DUREE TEST: 0.4 sec


LISTER_STATIONS_SUR_ITINERAIRE_LIGNE@LONGUEUR_CORRECT
.....................Pass
LISTER_STATIONS_SUR_ITINERAIRE_LIGNE@DIRECTION1_VALIDE
.....................Pass
LISTER_STATIONS_SUR_ITINERAIRE_LIGNE@DIRECTION2_VALIDE
.....................Pass
LISTER_STATIONS_SUR_ITINERAIRE_LIGNE@LIGNE_INVALIDE
.....................Pass
*** DUREE TEST: 12.8 sec


LIGNE_PASSE_PAR_STATION@CAS_VRAI
.....................Pass
LIGNE_PASSE_PAR_STATION@CAS_FAUX
.....................Pass
LIGNE_PASSE_PAR_STATION@CASVRAI
.....................Pass
LIGNE_PASSE_PAR_STATION@CASFAUX
.....................Pass
LIGNE_PASSE_PAR_STATION@STATION_INVALIDE
.....................Pass
LIGNE_PASSE_PAR_STATION@LIGNE_INVALIDE
.....................Pass
*** DUREE TEST: 0.1 sec


DUREE_DU_PROCHAIN_VOYAGE_PARTANT@DUREE_CORRECTE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@DATE_INVALIDE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@LIGNE_INVALIDE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@HEURE_INVALIDE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@STATION1_INVALIDE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@STATION2_INVALIDE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@STATION1_NON_PASSANTE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@STATION2_NON_PASSANTE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@PAS_DITINERAIRE_PASSANT
.....................Pass
*** DUREE TEST: 0.3 sec


DUREE_ATTENTE_PROCHAIN_ARRET_LIGNE_A_LA_STATION@SORTIE_CORRECTE
.....................Pass
DUREE_ATTENTE_PROCHAIN_ARRET_LIGNE_A_LA_STATION@DATE_INVALIDE
.....................Pass
DUREE_ATTENTE_PROCHAIN_ARRET_LIGNE_A_LA_STATION@LIGNE_INVALIDE
.....................Pass
DUREE_ATTENTE_PROCHAIN_ARRET_LIGNE_A_LA_STATION@HEURE_INVALIDE
.....................Pass
DUREE_ATTENTE_PROCHAIN_ARRET_LIGNE_A_LA_STATION@STATION_INVALIDE
.....................Pass
DUREE_ATTENTE_PROCHAIN_ARRET_LIGNE_A_LA_STATION@PLUS_DE_PASSAGE
.....................Pass
*** DUREE TEST: 0.1 sec


LIGNE_ARRIVE_LE_PLUS_TOT@SORTIE_CORRECTE
.....................Pass
LIGNE_ARRIVE_LE_PLUS_TOT@DATE_INVALIDE
.....................Pass
LIGNE_ARRIVE_LE_PLUS_TOT@STATION1_INVALIDE
.....................Pass
LIGNE_ARRIVE_LE_PLUS_TOT@STATION2_INVALIDE
.....................Pass
LIGNE_ARRIVE_LE_PLUS_TOT@HEURE_INVALIDE
.....................Pass
LIGNE_ARRIVE_LE_PLUS_TOT@PAS_DITINERAIRE
.....................Pass
*** DUREE TEST: 9.4 sec


LIGNE_MET_LE_MOINS_TEMPS@SORTIE_CORRECTE
.....................Pass
LIGNE_MET_LE_MOINS_TEMPS@DATE_INVALIDE
.....................Pass
LIGNE_MET_LE_MOINS_TEMPS@STATION1_INVALIDE
.....................Pass
LIGNE_MET_LE_MOINS_TEMPS@STATION2_INVALIDE
.....................Pass
LIGNE_MET_LE_MOINS_TEMPS@HEURE_INVALIDE
.....................Pass
LIGNE_MET_LE_MOINS_TEMPS@PAS_DITINERAIRE
.....................Pass
*** DUREE TEST: 8.5 sec


-------
F-TESTS
-------

- : unit = ()

(* ON PEUT AUSSI TESTER DES FONCTIONS INDISVIDUELLEMENT ----------------------*)

# test2();;
TROUVER_SERVICE@LONGUEUR_CORRECT1
.....................Pass
TROUVER_SERVICE@CONTENU_CORRECT1
.....................Pass
TROUVER_SERVICE@LONGUEUR_CORRECT2
.....................Pass
TROUVER_SERVICE@CONTENU_CORRECT2
.....................Pass
TROUVER_SERVICE@DATE_INVALIDE
.....................Pass
- : unit = ()
# test10();;
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@DUREE_CORRECTE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@DATE_INVALIDE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@LIGNE_INVALIDE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@HEURE_INVALIDE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@STATION1_INVALIDE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@STATION2_INVALIDE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@STATION1_NON_PASSANTE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@STATION2_NON_PASSANTE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@PAS_DITINERAIRE_PASSANT
.....................Pass
- : unit = ()

(* ON SUPPOSE QUE LE MODULE PRINCIPAL DU TP A ETE MODIFIE --------------------*)
(* => ON N'A QU'A RECHARGER LE FICHIER PRINCIPAL DU TP1   --------------------*)

# #use "tp1.ml";;
module type GESTIONNAIRE_TRANSPORT =
  sig
    val map_voyages_passants_itineraire :
      ?heure:int ->
      int ->
      int ->
      (Reseau_de_transport.arret * Reseau_de_transport.arret * string -> 'a) ->
      string list -> 'a list
    val lister_numero_lignes : unit -> string list
    val lister_id_stations : unit -> int list
    val trouver_voyages_sur_la_ligne :
      ?date:int option -> string -> string list
    val lister_numero_lignes_par_type :
      ?types:Reseau_de_transport.type_ligne list ->
      unit -> (Reseau_de_transport.type_ligne * string list) list
    val trouver_service : ?date:int -> unit -> string list
    val trouver_voyages_par_date : ?date:int -> unit -> string list
    val trouver_stations_environnantes :
      Reseau_de_transport.coordonnees -> float -> (int * float) list
    val lister_lignes_passantes_station : int -> string list
    val lister_arrets_par_voyage : string -> int list
    val trouver_horaire_ligne_a_la_station :
      ?date:int -> ?heure:int -> string -> int -> string list
    val lister_stations_sur_itineraire_ligne :
      ?date:int option -> string -> (string * int list) list
    val ligne_passe_par_station : ?date:int option -> string -> int -> bool
    val duree_du_prochain_voyage_partant :
      ?date:int -> ?heure:int -> string -> int -> int -> int
    val duree_attente_prochain_arret_ligne_a_la_station :
      ?date:int -> ?heure:int -> string -> int -> int
    val ligne_arrive_le_plus_tot :
      ?date:int -> ?heure:int -> int -> int -> string * int
    val ligne_met_le_moins_temps :
      ?date:int -> ?heure:int -> int -> int -> string * int
  end
module Gestionnaire_transport : GESTIONNAIRE_TRANSPORT

(* => PUIS CELUI DU TESTEUR --------------------------------------------------*)

# #use "testeur.ml";;
val fail : unit -> unit = <fun>
val pass : unit -> unit = <fun>
val assert_equal : string -> 'a -> 'a -> unit = <fun>
val assert_equal_list : string -> 'a list -> 'a list -> unit = <fun>
val assert_throw_exception : string -> (unit -> 'a) -> unit = <fun>
val assert_true : string -> (unit -> bool) -> unit = <fun>
val test1 : unit -> unit = <fun>
val test2 : unit -> unit = <fun>
val test3 : unit -> unit = <fun>
val test4 : unit -> unit = <fun>
val test5 : unit -> unit = <fun>
val test6 : unit -> unit = <fun>
val test7 : unit -> unit = <fun>
val test8 : unit -> unit = <fun>
val test9 : unit -> unit = <fun>
val test10 : unit -> unit = <fun>
val test11 : unit -> unit = <fun>
val test12 : unit -> unit = <fun>
val test13 : unit -> unit = <fun>
val test : unit -> unit = <fun>
val test' : unit -> unit = <fun>
# test3();;
TROUVER_VOYAGES_PAR_DATE@LONGUEUR_CORRECT1
.....................Pass
TROUVER_VOYAGES_PAR_DATE@LONGUEUR_CORRECT2
.....................Pass
TROUVER_VOYAGES_PAR_DATE@DATE_INVALIDE
.....................Pass
- : unit = ()

(* ET ON REFAIT LES TESTS QU'ON VEUT -----------------------------------------*)
(* RQ: IL NE FAUT PAS UTILISER TEST' CAR ELLE RECHARGE LES DONNÉES CE QUI     *)
(*     ALLOURDIT L'INTERPRETEUR.                                              *)
(*     ON UTILE DONC TEST() OU TESTn() SANS AVOIR A RECHARGER LES DONNEES     *)

# test();;

-------
D-TESTS
-------

LISTER_NUMERO_LIGNES_PAR_TYPE@LONGUEUR_BUS_CORRECT
.....................Pass
LISTER_NUMERO_LIGNES_PAR_TYPE@CONTENU_BUS _CORRECT
.....................Pass
LISTER_NUMERO_LIGNES_PAR_TYPE@LONGUEUR_METROBUS_CORRECT
.....................Pass
LISTER_NUMERO_LIGNES_PAR_TYPE@CONTENU_METROBUS _CORRECT
.....................Pass
LISTER_NUMERO_LIGNES_PAR_TYPE@LONGUEUR_COUCHETARD_CORRECT
.....................Pass
LISTER_NUMERO_LIGNES_PAR_TYPE@CONTENU_COUCHETARD_CORRECT
.....................Pass
LISTER_NUMERO_LIGNES_PAR_TYPE@LONGUEUR_EXPRESS_CORRECT
.....................Pass
LISTER_NUMERO_LIGNES_PAR_TYPE@CONTENU_EXPRESS_CORRECT
.....................Pass
LISTER_NUMERO_LIGNES_PAR_TYPE@LONGUEUR_CORRECT
.....................Pass
*** DUREE TEST: 0.0 sec


TROUVER_SERVICE@LONGUEUR_CORRECT1
.....................Pass
TROUVER_SERVICE@CONTENU_CORRECT1
.....................Pass
TROUVER_SERVICE@LONGUEUR_CORRECT2
.....................Pass
TROUVER_SERVICE@CONTENU_CORRECT2
.....................Pass
TROUVER_SERVICE@DATE_INVALIDE
.....................Pass
*** DUREE TEST: 0.0 sec


TROUVER_VOYAGES_PAR_DATE@LONGUEUR_CORRECT1
.....................Pass
TROUVER_VOYAGES_PAR_DATE@LONGUEUR_CORRECT2
.....................Pass
TROUVER_VOYAGES_PAR_DATE@DATE_INVALIDE
.....................Pass
*** DUREE TEST: 0.0 sec


TROUVER_STATIONS_ENVIRONNANTES@LONGUEUR_CORRECT
.....................Pass
TROUVER_STATIONS_ENVIRONNANTES@CONTENU_CORRECT
.....................Pass
TROUVER_STATIONS_ENVIRONNANTES@CONTENU_EN ORDRE
.....................Pass
TROUVER_STATIONS_ENVIRONNANTES@RAYON_INVALIDE
.....................Pass
TROUVER_STATIONS_ENVIRONNANTES@POSITION_INVALIDE
.....................Pass
*** DUREE TEST: 0.0 sec


LISTER_LIGNES_PASSANTES_STATION@LONGUEUR_CORRECT1
.....................Pass
LISTER_LIGNES_PASSANTES_STATION@CONTENU_CORRECT1
.....................Pass
LISTER_LIGNES_PASSANTES_STATION@LONGUEUR_CORRECT1
.....................Pass
LISTER_LIGNES_PASSANTES_STATION@CONTENU_CORRECT1
.....................Pass
LISTER_LIGNES_PASSANTES_STATION@STATION_INVALIDE
.....................Pass
*** DUREE TEST: 0.1 sec


LISTER_ARRETS_PAR_VOYAGE@LONGUEUR_CORRECT1
.....................Pass
LISTER_ARRETS_PAR_VOYAGE@CONTENU_CORRECT1
.....................Pass
LISTER_ARRETS_PAR_VOYAGE@ORDRE_CORRECT1
.....................Pass
LISTER_ARRETS_PAR_VOYAGE@LONGUEUR_CORRECT2
.....................Pass
LISTER_ARRETS_PAR_VOYAGE@CONTENU_CORRECT2
.....................Pass
LISTER_ARRETS_PAR_VOYAGE@ORDRE_CORRECT2
.....................Pass
LISTER_ARRETS_PAR_VOYAGE@STATION_INVALIDE
.....................Pass
*** DUREE TEST: 0.0 sec


TROUVER_HORAIRE_LIGNE_A_LA_STATION@LONGUEUR_CORRECT1
.....................Pass
TROUVER_HORAIRE_LIGNE_A_LA_STATION@CONTENU_CORRECT1
.....................Pass
TROUVER_HORAIRE_LIGNE_A_LA_STATION@CONTENU_EN ORDRE1
.....................Pass
TROUVER_HORAIRE_LIGNE_A_LA_STATION@LONGUEUR_CORRECT2
.....................Pass
TROUVER_HORAIRE_LIGNE_A_LA_STATION@CONTENU_CORRECT2
.....................Pass
TROUVER_HORAIRE_LIGNE_A_LA_STATION@CONTENU_EN ORDRE2
.....................Pass
TROUVER_HORAIRE_LIGNE_A_LA_STATION@DATE_INVALIDE
.....................Pass
TROUVER_HORAIRE_LIGNE_A_LA_STATION@LIGNE_INVALIDE
.....................Pass
TROUVER_HORAIRE_LIGNE_A_LA_STATION@HEURE_INVALIDE
.....................Pass
TROUVER_HORAIRE_LIGNE_A_LA_STATION@STATION_INVALIDE
.....................Pass
*** DUREE TEST: 0.4 sec


LISTER_STATIONS_SUR_ITINERAIRE_LIGNE@LONGUEUR_CORRECT
.....................Pass
LISTER_STATIONS_SUR_ITINERAIRE_LIGNE@DIRECTION1_VALIDE
.....................Pass
LISTER_STATIONS_SUR_ITINERAIRE_LIGNE@DIRECTION2_VALIDE
.....................Pass
LISTER_STATIONS_SUR_ITINERAIRE_LIGNE@LIGNE_INVALIDE
.....................Pass
*** DUREE TEST: 13.0 sec


LIGNE_PASSE_PAR_STATION@CAS_VRAI
.....................Pass
LIGNE_PASSE_PAR_STATION@CAS_FAUX
.....................Pass
LIGNE_PASSE_PAR_STATION@CASVRAI
.....................Pass
LIGNE_PASSE_PAR_STATION@CASFAUX
.....................Pass
LIGNE_PASSE_PAR_STATION@STATION_INVALIDE
.....................Pass
LIGNE_PASSE_PAR_STATION@LIGNE_INVALIDE
.....................Pass
*** DUREE TEST: 0.1 sec


DUREE_DU_PROCHAIN_VOYAGE_PARTANT@DUREE_CORRECTE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@DATE_INVALIDE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@LIGNE_INVALIDE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@HEURE_INVALIDE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@STATION1_INVALIDE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@STATION2_INVALIDE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@STATION1_NON_PASSANTE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@STATION2_NON_PASSANTE
.....................Pass
DUREE_DU_PROCHAIN_VOYAGE_PARTANT@PAS_DITINERAIRE_PASSANT
.....................Pass
*** DUREE TEST: 0.3 sec


DUREE_ATTENTE_PROCHAIN_ARRET_LIGNE_A_LA_STATION@SORTIE_CORRECTE
.....................Pass
DUREE_ATTENTE_PROCHAIN_ARRET_LIGNE_A_LA_STATION@DATE_INVALIDE
.....................Pass
DUREE_ATTENTE_PROCHAIN_ARRET_LIGNE_A_LA_STATION@LIGNE_INVALIDE
.....................Pass
DUREE_ATTENTE_PROCHAIN_ARRET_LIGNE_A_LA_STATION@HEURE_INVALIDE
.....................Pass
DUREE_ATTENTE_PROCHAIN_ARRET_LIGNE_A_LA_STATION@STATION_INVALIDE
.....................Pass
DUREE_ATTENTE_PROCHAIN_ARRET_LIGNE_A_LA_STATION@PLUS_DE_PASSAGE
.....................Pass
*** DUREE TEST: 0.1 sec


LIGNE_ARRIVE_LE_PLUS_TOT@SORTIE_CORRECTE
.....................Pass
LIGNE_ARRIVE_LE_PLUS_TOT@DATE_INVALIDE
.....................Pass
LIGNE_ARRIVE_LE_PLUS_TOT@STATION1_INVALIDE
.....................Pass
LIGNE_ARRIVE_LE_PLUS_TOT@STATION2_INVALIDE
.....................Pass
LIGNE_ARRIVE_LE_PLUS_TOT@HEURE_INVALIDE
.....................Pass
LIGNE_ARRIVE_LE_PLUS_TOT@PAS_DITINERAIRE
.....................Pass
*** DUREE TEST: 9.4 sec


LIGNE_MET_LE_MOINS_TEMPS@SORTIE_CORRECTE
.....................Pass
LIGNE_MET_LE_MOINS_TEMPS@DATE_INVALIDE
.....................Pass
LIGNE_MET_LE_MOINS_TEMPS@STATION1_INVALIDE
.....................Pass
LIGNE_MET_LE_MOINS_TEMPS@STATION2_INVALIDE
.....................Pass
LIGNE_MET_LE_MOINS_TEMPS@HEURE_INVALIDE
.....................Pass
LIGNE_MET_LE_MOINS_TEMPS@PAS_DITINERAIRE
.....................Pass
*** DUREE TEST: 7.4 sec


-------
F-TESTS
-------

- : unit = ()
# 
