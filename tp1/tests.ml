(* -- Tests effectuées vendredi 12 février 2016 à l'heure de midi ------------ *)

#use "tp1.ml";;

  
(* -- Ouvre les modules ------------------------------------------------------ *)
open Utiles;;
open Date;;
open Reseau_de_transport;;
open Gestionnaire_transport;;

  
(* -- Charge toutes les données dns tables de hachage ------------------------ *)
let _,t = timeRun (charger_tout ~rep:"rtc_data/") ();;

  
(* -- Définitions utilisées dans les exemples suivants ----------------------- *)
let vendredi = date_actuelle ();;
let samedi = date_a_nbjours "20160213";;
let fin_annee = date_a_nbjours "20161231";;
let pouliot_gps = {latitude = 46.778826; longitude = -71.275169};;
let desjardins_gps = {latitude = 46.779227; longitude = -71.269888};;
let faux_gps = {latitude = 200.; longitude = -400.};;
let station_desjardins = 1561;;
let station_desjardins' = 1515;;
let fausse_station = 0;;

let id x = x;;

  
(* -- lister_numero_lignes --------------------------------------------------- *)
lister_numero_lignes ();;
List.length (lister_numero_lignes ());;

  
(* -- lister_id_stations ----------------------------------------------------- *)
lister_id_stations ();;

List.length (lister_id_stations ());;

(* Limite l'affichage à 100 éléments des listes *)  
#print_length 100;;
lister_id_stations ();;

  
(* -- lister_numero_lignes_par_type ------------------------------------------ * )
lister_numero_lignes_par_type();;

(* Remet la limite de l'affichage à 300 éléments des listes *)  
#print_length 300;;
lister_numero_lignes_par_type();;
    
lister_numero_lignes_par_type ~types:[ MetroBus; Express ]();;

  
(* -- trouver_service -------------------------------------------------------- *)
(* Traitement des préconditions *)
trouver_service ~date:0 ();;
trouver_service ~date:fin_annee ();;    

(* Comportement correct *)
trouver_service ();;
trouver_service ~date:(samedi) ();;


(* -- trouver_voyages_par_date ----------------------------------------------- *)
(* Traitement des préconditions *)
trouver_voyages_par_date ~date:0 ();;
trouver_voyages_par_date ~date:fin_annee ();;
    
(* Comportement correct *)
trouver_voyages_par_date ();;
List.length (trouver_voyages_par_date ());;

List.length (trouver_voyages_par_date ~date:samedi ());;
List.length (trouver_voyages_par_date ~date:vendredi ());;

  
(* -- trouver_voyages_sur_la_ligne ------------------------------------------- *)
(* Traitement des préconditions *)
trouver_voyages_sur_la_ligne "0";;
trouver_voyages_sur_la_ligne ~date:(Some 0) "7";;
trouver_voyages_sur_la_ligne ~date:(Some fin_annee) "7";;   

(* Comportement correct *)
trouver_voyages_sur_la_ligne "7";;
List.length (trouver_voyages_sur_la_ligne "7");;
List.length (trouver_voyages_sur_la_ligne ~date:None "7");;

timeRun (fun x -> List.length (trouver_voyages_sur_la_ligne ~date:None x)) "7";; 

(* Affichage du nombre de voyages par ligne *)
let t = Array.of_list (lister_numero_lignes ()) in
let sum = ref 0 in
let open Printf in
    printf "\n";
    for i = 0 to (Array.length t)-1 do
      let nb = List.length (trouver_voyages_sur_la_ligne t.(i)) in
          printf "%s : %d voyages\n" (t.(i)) nb;
      sum := !sum + nb
    done;
    printf "\nTotal voyages = %d\n" (!sum);;


(* -- map_voyages_passants_itineraire ---------------------------------------- *)
(* Traitement des préconditions *)
map_voyages_passants_itineraire fausse_station station_desjardins id [];;
map_voyages_passants_itineraire station_desjardins fausse_station id [];;
map_voyages_passants_itineraire ~heure:(-1)
  station_desjardins station_desjardins' id [];;
    
(* Comportement correct *)
map_voyages_passants_itineraire 
  station_desjardins' 1440
  (fun (a,a',v) -> (a,a'))
  (trouver_voyages_par_date ());;

map_voyages_passants_itineraire 
  station_desjardins' 1440
  (fun (a,a',v) -> (a,a'))
  (trouver_voyages_sur_la_ligne "800");;

  
(* -- trouver_stations_environnantes ----------------------------------------- *)
(* Traitement des préconditions *)
trouver_stations_environnantes faux_gps 0.2;;
trouver_stations_environnantes pouliot_gps (-0.2);;

(* Comportement correct *)
trouver_stations_environnantes pouliot_gps 0.5;;
trouver_stations_environnantes pouliot_gps 0.2;;
trouver_stations_environnantes desjardins_gps 0.2;;

  
(* -- lister_lignes_passantes_station ---------------------------------------- *)
(* Traitement des préconditions *)
lister_lignes_passantes_station fausse_station;;

(* Comportement correct *)
lister_lignes_passantes_station station_desjardins';;
lister_lignes_passantes_station station_desjardins;;

  
(* -- lister_arrets_par_voyage ----------------------------------------------- *)
(* Traitement des préconditions *)
lister_arrets_par_voyage "0";;

(* Comportement correct *)
trouver_voyages_sur_la_ligne "800";;

lister_arrets_par_voyage "47421501-20160013multiint-1111100";;
lister_arrets_par_voyage "47421618-20160013multiint-1111100";;

   
(* -- trouver_horaire_ligne_a_la_station -------------------------------------- *)*)
(* Traitement des préconditions *)
trouver_horaire_ligne_a_la_station ~date:0 "800" station_desjardins;;
trouver_horaire_ligne_a_la_station ~date:fin_annee "800" station_desjardins;;
trouver_horaire_ligne_a_la_station ~heure:(-1) "800" station_desjardins;;
trouver_horaire_ligne_a_la_station "0" station_desjardins;;
trouver_horaire_ligne_a_la_station "800" fausse_station;;
trouver_horaire_ligne_a_la_station "800" 1076;;

(* Comportement correct *)
secs_a_heure (heure_actuelle());;
  
trouver_horaire_ligne_a_la_station "800" station_desjardins';;
trouver_horaire_ligne_a_la_station "18" station_desjardins;;
trouver_horaire_ligne_a_la_station "800" station_desjardins;;


(* -- lister_stations_sur_itineraire_ligne ----------------------------------- * )
(* Traitement des préconditions *)
lister_stations_sur_itineraire_ligne "0";;  

(* Comportement correct *)
lister_stations_sur_itineraire_ligne "11";;
lister_stations_sur_itineraire_ligne "800";;


(* -- ligne_passe_par_station ------------------------------------------------ * )
(* Traitement des préconditions *)
ligne_passe_par_station "0" station_desjardins';;
ligne_passe_par_station "801" fausse_station;;

(* Comportement correct *)
ligne_passe_par_station "800" station_desjardins';;
ligne_passe_par_station "801" station_desjardins;;
ligne_passe_par_station "11" 1076;;

  
(* -- duree_du_prochain_voyage_partant --------------------------------------- *)
(* Traitement des préconditions *)
duree_du_prochain_voyage_partant ~date:0 "11" 1815 1271;;
duree_du_prochain_voyage_partant ~date:fin_annee "11" 1815 1271;;
duree_du_prochain_voyage_partant ~heure:(-1) "11" 1815 1271;;
duree_du_prochain_voyage_partant  "0" 1815 1271;;
duree_du_prochain_voyage_partant  "11" fausse_station 1271;;
duree_du_prochain_voyage_partant  "11" 1815 fausse_station;;
duree_du_prochain_voyage_partant  "11" station_desjardins 1271;;
duree_du_prochain_voyage_partant  "11" 1815 station_desjardins;;

(* Comportement correct *)
duree_du_prochain_voyage_partant "800" station_desjardins' 1440;;  
duree_du_prochain_voyage_partant "11" 1815 1271;;


(* -- duree_attente_prochain_arret_ligne_a_la_station ------------------------ *)
(* Traitement des préconditions *)
duree_attente_prochain_arret_ligne_a_la_station
  ~date:0 "800" station_desjardins';;
duree_attente_prochain_arret_ligne_a_la_station
  ~date:fin_annee "800" station_desjardins';;
duree_attente_prochain_arret_ligne_a_la_station
  ~heure:(-1) "800" station_desjardins';;
duree_attente_prochain_arret_ligne_a_la_station "0" station_desjardins';;
duree_attente_prochain_arret_ligne_a_la_station "800" fausse_station;;

(* Comportement correct *)
duree_attente_prochain_arret_ligne_a_la_station "800" station_desjardins';;
duree_attente_prochain_arret_ligne_a_la_station "11" 1815;;

secs_a_heure (heure_actuelle());;
  
(* -- ligne_arrive_le_plus_tot ----------------------------------------------- *)
(* Traitement des préconditions *)
ligne_arrive_le_plus_tot ~date:0 station_desjardins' 1440;;
ligne_arrive_le_plus_tot ~date:fin_annee station_desjardins' 1440;;
ligne_arrive_le_plus_tot ~heure:(-1) station_desjardins' 1440;;
ligne_arrive_le_plus_tot fausse_station 1440;;
ligne_arrive_le_plus_tot station_desjardins' fausse_station;;

(* Comportement correct *)
ligne_arrive_le_plus_tot station_desjardins' 1440;;


(* -- ligne_met_le_moins_temps ----------------------------------------------- *)
(* Traitement des préconditions *)
ligne_met_le_moins_temps ~date:0 station_desjardins' 1440;;
ligne_met_le_moins_temps ~date:fin_annee station_desjardins' 1440;;
ligne_met_le_moins_temps ~heure:(-1) station_desjardins' 1440;;
ligne_met_le_moins_temps fausse_station 1440;;
ligne_met_le_moins_temps station_desjardins' fausse_station;;

(* Comportement correct *)
ligne_met_le_moins_temps station_desjardins' 1440;;

(* Pour terminer ... *)
timeRun (ligne_arrive_le_plus_tot station_desjardins') 1440;;
timeRun (ligne_met_le_moins_temps station_desjardins') 1440;;
secs_a_heure (heure_actuelle());;

*)
    
