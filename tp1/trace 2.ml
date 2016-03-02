        OCaml version 4.02.3

# #use "tp1.ml";;
(* -- Tests effectuées vendredi 12 février 2016 à l'heure de midi ------------ *)
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
# open Utiles;;
# open Date;;
# open Reseau_de_transport;;
# open Gestionnaire_transport;;
# let _,t = timeRun (charger_tout ~rep:"rtc_data/") ();;
CHARGEMENT DES DONNÉES TERMINÉ
val t : float = 106.68649768829346
# let vendredi = date_actuelle ();;
val vendredi : int = 16843
# let samedi = date_a_nbjours "20160213";;
val samedi : int = 16844
# let fin_annee = date_a_nbjours "20161231";;
val fin_annee : int = 17166
# let pouliot_gps = {latitude = 46.778826; longitude = -71.275169};;
val pouliot_gps : Reseau_de_transport.coordonnees =
  {latitude = 46.778826; longitude = -71.275169}
# let desjardins_gps = {latitude = 46.779227; longitude = -71.269888};;
val desjardins_gps : Reseau_de_transport.coordonnees =
  {latitude = 46.779227; longitude = -71.269888}
# let faux_gps = {latitude = 200.; longitude = -400.};;
val faux_gps : Reseau_de_transport.coordonnees =
  {latitude = 200.; longitude = -400.}
# let station_desjardins = 1561;;
val station_desjardins : int = 1561
# let station_desjardins' = 1515;;
val station_desjardins' : int = 1515
# let fausse_station = 0;;
val fausse_station : int = 0
# let id x = x;;
val id : 'a -> 'a = <fun>
# ;;

  
(* -- lister_numero_lignes --------------------------------------------------- *)
lister_numero_lignes ();;
#       - : string list =
["279"; "16"; "274"; "984"; "39"; "915"; "95"; "185"; "21"; "580"; "93";
 "954"; "59"; "29"; "254"; "272"; "72"; "581"; "84g"; "4"; "536"; "136";
 "936"; "61"; "14a"; "273"; "372"; "54g"; "282"; "86g"; "50"; "81"; "32";
 "82"; "255"; "18"; "15b"; "802"; "558"; "250"; "925"; "74"; "337"; "374";
 "79b"; "354"; "88"; "355"; "1"; "350"; "31"; "14g"; "107"; "972"; "803";
 "290"; "537"; "54"; "14"; "538"; "215"; "9"; "55g"; "289"; "338"; "80";
 "77"; "13"; "358"; "36"; "22"; "550"; "15"; "58"; "800"; "555"; "85"; "980";
 "94"; "92a"; "315"; "801"; "280"; "25"; "336"; "133"; "574"; "281"; "3";
 "332"; "992"; "53"; "78"; "380"; "572"; "907"; "295"; "1a"; "10"; "931";
 "284"; "15a"; "330"; "79"; "44"; "55h"; "34"; "80g"; "52"; "79a"; "92";
 "84"; "37"; "125"; "214"; "28"; "33"; "86"; "7"; "54a"; "79g"; "987"; "25g";
 "75"; "230"; "70"; "391"; "582"; "13b"; "3g"; "55"; "87"; "80a"; "11g";
 "55a"; "236"; "950"; "82a"; "3a"; "382"; "11"; "64"; "13a"; "239"; "294";
 "277"; "530"; "111"; "331"; "577"; "65"; "251"; "982"; "238"; "584"; "57";
 "283"; "381"; "384"; "377"]
# ;;
List.length (lister_numero_lignes ());;
# - : int = 160
# ;;

  
(* -- lister_id_stations ----------------------------------------------------- *)
lister_id_stations ();;
#       - : int list =
[4395; 4357; 2917; 4939; 1680; 4411; 3756; 5407; 1311; 3574; 2334; 2844;
 3535; 1225; 6083; 4851; 3937; 4687; 5279; 3730; 6323; 2869; 3196; 5294;
 5099; 5273; 6259; 3154; 5550; 5803; 2634; 1943; 5780; 5851; 3030; 3876;
 4501; 1674; 7006; 3207; 1709; 2165; 4340; 1262; 1860; 3826; 2499; 3163;
 4842; 3052; 2782; 2261; 4978; 4151; 2525; 1811; 2392; 3252; 3873; 2931;
 4778; 2218; 3314; 3789; 5500; 2508; 2555; 4800; 4089; 3619; 3922; 5118;
 4377; 3814; 5043; 5719; 1230; 2661; 4833; 1173; 1660; 3283; 5312; 3551;
 5772; 1823; 2933; 3951; 5149; 6238; 3787; 5744; 4696; 3912; 4215; 2660;
 3221; 6041; 3763; 5169; 3845; 1683; 3920; 4537; 6134; 6013; 4413; 3927;
 5315; 2874; 5381; 1401; 1595; 5513; 4338; 3629; 4073; 3777; 2851; 3676;
 2175; 2385; 1870; 3856; 4463; 2236; 3900; 3499; 3305; 4304; 6147; 6093;
 4789; 4998; 2503; 2852; 2187; 3344; 1307; 3473; 9505; 1841; 2755; 6066;
 4846; 4437; 4405; 5868; 7011; 1937; 1226; 2484; 4706; 4329; 4122; 5087;
 3000; 4195; 1143; 1075; 2876; 4053; 2291; 1601; 3838; 3523; 2467; 3659;
 1643; 1223; 1494; 2778; 4579; 4863; 4692; 4642; 4855; 3784; 1530; 2678;
 3139; 2514; 4716; 4831; 3203; 3223; 2703; 4327; 5100; 5804; 1309; 4613;
 4864; 5316; 1658; 4796; 5257; 5582; 3967; 5461; 6207; 1235; 3236; 4082;
 5358; 1517; 5015; 3334; 5005; 5223; 1061; 2091; 1252; 1073; 6086; 5192;
 3531; 4683; 5697; 2180; 1008; 1921; 2833; 6339; 3381; 5442; 4155; 3402;
 3204; 4382; 3124; 5041; 1070; 2870; 5012; 2160; 2232; 5480; 1638; 3680;
 5405; 4119; 4100; 2086; 2407; 6070; 5158; 1290; 6266; 5695; 5654; 2940;
 2398; 3933; 3280; 6335; 3614; 6286; 1692; 4485; 3214; 4466; 5619; 1759;
 1166; 2815; 5765; 2907; 5657; 1085; 4984; 1106; 1766; 3408; 2716; 2793;
 3979; 5528; 1504; 3423; 5603; 5474; 2574; 6306; 5717; 5342; 3655; 3174;
 4673; 5070; 3162; 4131; 1806; 3443; 1418; 4350; 3972; 1486; 3820; ...]
# ;;

List.length (lister_id_stations ());;
#   - : int = 4584
# #print_length 100;;
# lister_id_stations ();;
- : int list =
[4395; 4357; 2917; 4939; 1680; 4411; 3756; 5407; 1311; 3574; 2334; 2844;
 3535; 1225; 6083; 4851; 3937; 4687; 5279; 3730; 6323; 2869; 3196; 5294;
 5099; 5273; 6259; 3154; 5550; 5803; 2634; 1943; 5780; 5851; 3030; 3876;
 4501; 1674; 7006; 3207; 1709; 2165; 4340; 1262; 1860; 3826; 2499; 3163;
 4842; 3052; 2782; 2261; 4978; 4151; 2525; 1811; 2392; 3252; 3873; 2931;
 4778; 2218; 3314; 3789; 5500; 2508; 2555; 4800; 4089; 3619; 3922; 5118;
 4377; 3814; 5043; 5719; 1230; 2661; 4833; 1173; 1660; 3283; 5312; 3551;
 5772; 1823; 2933; 3951; 5149; 6238; 3787; 5744; 4696; 3912; 4215; 2660;
 3221; 6041; 3763; ...]
# ;;

  
(* -- lister_numero_lignes_par_type ------------------------------------------ *)
lister_numero_lignes_par_type();;
#       - : (Reseau_de_transport.type_ligne * string list) list =
[(MetroBus, ["802"; "803"; "800"; "801"]);
 (Express,
  ["279"; "274"; "580"; "254"; "272"; "581"; "536"; "273"; "372"; "282";
   "255"; "558"; "250"; "337"; "374"; "354"; "355"; "350"; "290"; "537";
   "538"; "215"; "289"; "338"; "358"; "550"; "555"; "315"; "280"; "336";
   "574"; "281"; "332"; "380"; "572"; "295"; "284"; "330"; "214"; "230";
   "391"; "582"; "236"; "382"; "239"; "294"; "277"; "530"; "331"; "577";
   "251"; "238"; "584"; "283"; "381"; "384"; "377"]);
 (LeBus,
  ["16"; "39"; "95"; "185"; "21"; "93"; "59"; "29"; "72"; "84g"; "4"; "136";
   "61"; "14a"; "54g"; "86g"; "50"; "81"; "32"; "82"; "18"; "15b"; "74";
   "79b"; "88"; "1"; "31"; "14g"; "107"; ...]);
 ...]
# #print_length 300;;
# ;;
lister_numero_lignes_par_type();;
# - : (Reseau_de_transport.type_ligne * string list) list =
[(MetroBus, ["802"; "803"; "800"; "801"]);
 (Express,
  ["279"; "274"; "580"; "254"; "272"; "581"; "536"; "273"; "372"; "282";
   "255"; "558"; "250"; "337"; "374"; "354"; "355"; "350"; "290"; "537";
   "538"; "215"; "289"; "338"; "358"; "550"; "555"; "315"; "280"; "336";
   "574"; "281"; "332"; "380"; "572"; "295"; "284"; "330"; "214"; "230";
   "391"; "582"; "236"; "382"; "239"; "294"; "277"; "530"; "331"; "577";
   "251"; "238"; "584"; "283"; "381"; "384"; "377"]);
 (LeBus,
  ["16"; "39"; "95"; "185"; "21"; "93"; "59"; "29"; "72"; "84g"; "4"; "136";
   "61"; "14a"; "54g"; "86g"; "50"; "81"; "32"; "82"; "18"; "15b"; "74";
   "79b"; "88"; "1"; "31"; "14g"; "107"; "54"; "14"; "9"; "55g"; "80"; "77";
   "13"; "36"; "22"; "15"; "58"; "85"; "94"; "92a"; "25"; "133"; "3"; "53";
   "78"; "1a"; "10"; "15a"; "79"; "44"; "55h"; "34"; "80g"; "52"; "79a";
   "92"; "84"; "37"; "125"; "28"; "33"; "86"; "7"; "54a"; "79g"; "25g"; "75";
   "70"; "13b"; "3g"; "55"; "87"; "80a"; "11g"; "55a"; "82a"; "3a"; "11";
   "64"; "13a"; "111"; "65"; "57"]);
 (CoucheTard,
  ["984"; "915"; "954"; "936"; "925"; "972"; "980"; "992"; "907"; "931";
   "987"; "950"; "982"])]
# ;;
    
lister_numero_lignes_par_type ~types:[ MetroBus; Express ]();;
#   - : (Reseau_de_transport.type_ligne * string list) list =
[(MetroBus, ["802"; "803"; "800"; "801"]);
 (Express,
  ["279"; "274"; "580"; "254"; "272"; "581"; "536"; "273"; "372"; "282";
   "255"; "558"; "250"; "337"; "374"; "354"; "355"; "350"; "290"; "537";
   "538"; "215"; "289"; "338"; "358"; "550"; "555"; "315"; "280"; "336";
   "574"; "281"; "332"; "380"; "572"; "295"; "284"; "330"; "214"; "230";
   "391"; "582"; "236"; "382"; "239"; "294"; "277"; "530"; "331"; "577";
   "251"; "238"; "584"; "283"; "381"; "384"; "377"])]
# ;;

  
(* -- trouver_service -------------------------------------------------------- *)
(* Traitement des préconditions *)
trouver_service ~date:0 ();;
#         Exception: Erreur "Date invalide ou pas prise en charge".
# ;;
trouver_service ~date:fin_annee ();;
# Exception: Erreur "Date invalide ou pas prise en charge".
# ;;    

(* Comportement correct *)
trouver_service ();;
#     - : string list =
["20160013multiint-1111100"; "20160013multiint-0001100";
 "20160013multiint-0000100"]
# ;;
trouver_service ~date:(samedi) ();;
# - : string list = ["20160511multiint-0000010"]
# ;;


(* -- trouver_voyages_par_date ----------------------------------------------- *)
(* Traitement des préconditions *)
trouver_voyages_par_date ~date:0 ();;
#         Exception: Erreur "Date invalide ou pas prise en charge".
# ;;
trouver_voyages_par_date ~date:fin_annee ();;
# Exception: Erreur "Date invalide ou pas prise en charge".
# ;;
    
(* Comportement correct *)
trouver_voyages_par_date ();;
#     - : string list =
["47422174-20160013multiint-1111100"; "47422173-20160013multiint-1111100";
 "47422172-20160013multiint-1111100"; "47422171-20160013multiint-1111100";
 "47422170-20160013multiint-1111100"; "47422169-20160013multiint-1111100";
 "47422168-20160013multiint-1111100"; "47422167-20160013multiint-1111100";
 "47422166-20160013multiint-1111100"; "47422165-20160013multiint-1111100";
 "47422164-20160013multiint-1111100"; "47422163-20160013multiint-1111100";
 "47422160-20160013multiint-1111100"; "47422159-20160013multiint-1111100";
 "47422158-20160013multiint-1111100"; "47422157-20160013multiint-1111100";
 "47422156-20160013multiint-1111100"; "47422155-20160013multiint-1111100";
 "47422154-20160013multiint-1111100"; "47422153-20160013multiint-1111100";
 "47422152-20160013multiint-1111100"; "47422151-20160013multiint-1111100";
 "47422150-20160013multiint-1111100"; "47422149-20160013multiint-1111100";
 "47422148-20160013multiint-1111100"; "47422147-20160013multiint-1111100";
 "47422146-20160013multiint-1111100"; "47422145-20160013multiint-1111100";
 "47422144-20160013multiint-1111100"; "47422143-20160013multiint-1111100";
 "47422142-20160013multiint-1111100"; "47422141-20160013multiint-1111100";
 "47422140-20160013multiint-1111100"; "47422139-20160013multiint-1111100";
 "47422138-20160013multiint-1111100"; "47422137-20160013multiint-1111100";
 "47422136-20160013multiint-1111100"; "47422135-20160013multiint-1111100";
 "47422134-20160013multiint-1111100"; "47422133-20160013multiint-1111100";
 "47422132-20160013multiint-1111100"; "47422131-20160013multiint-1111100";
 "47422130-20160013multiint-1111100"; "47422129-20160013multiint-1111100";
 "47422128-20160013multiint-1111100"; "47422127-20160013multiint-1111100";
 "47422126-20160013multiint-1111100"; "47422125-20160013multiint-1111100";
 "47422122-20160013multiint-1111100"; "47422121-20160013multiint-1111100";
 "47422120-20160013multiint-1111100"; "47422119-20160013multiint-1111100";
 "47422118-20160013multiint-1111100"; "47422117-20160013multiint-1111100";
 "47422116-20160013multiint-1111100"; "47422115-20160013multiint-1111100";
 "47422114-20160013multiint-1111100"; "47422113-20160013multiint-1111100";
 "47422112-20160013multiint-1111100"; "47422111-20160013multiint-1111100";
 "47422110-20160013multiint-1111100"; "47422109-20160013multiint-1111100";
 "47422108-20160013multiint-1111100"; "47422107-20160013multiint-1111100";
 "47421584-20160013multiint-1111100"; "47421537-20160013multiint-1111100";
 "47421592-20160013multiint-1111100"; "47421512-20160013multiint-1111100";
 "47421803-20160013multiint-1111100"; "46205965-20160013multiint-1111100";
 "46205964-20160013multiint-1111100"; "46205892-20160013multiint-1111100";
 "46205891-20160013multiint-1111100"; "46205828-20160013multiint-1111100";
 "46205827-20160013multiint-1111100"; "46205826-20160013multiint-1111100";
 "46205825-20160013multiint-1111100"; "47421250-20160013multiint-1111100";
 "46205870-20160013multiint-1111100"; "46205804-20160013multiint-1111100";
 "46205803-20160013multiint-1111100"; "46205802-20160013multiint-1111100";
 "46205801-20160013multiint-1111100"; "46205915-20160013multiint-1111100";
 "47420978-20160013multiint-1111100"; "47421769-20160013multiint-1111100";
 "47421567-20160013multiint-1111100"; "47421446-20160013multiint-1111100";
 "47421557-20160013multiint-1111100"; "47421582-20160013multiint-1111100";
 "47421545-20160013multiint-1111100"; "47421449-20160013multiint-1111100";
 "47421520-20160013multiint-1111100"; "47421600-20160013multiint-1111100";
 "47421500-20160013multiint-1111100"; "47421791-20160013multiint-1111100";
 "47421664-20160013multiint-1111100"; "47421639-20160013multiint-1111100";
 "47421713-20160013multiint-1111100"; ...]
# ;;
List.length (trouver_voyages_par_date ());;
# - : int = 4173
# ;;

List.length (trouver_voyages_par_date ~date:samedi ());;
#   - : int = 2383
# ;;
List.length (trouver_voyages_par_date ~date:vendredi ());;
# - : int = 4173
# ;;

  
(* -- trouver_voyages_sur_la_ligne ------------------------------------------- *)
(* Traitement des préconditions *)
trouver_voyages_sur_la_ligne "0";;
#         Exception: Erreur "Ligne invalide".
# ;;
trouver_voyages_sur_la_ligne ~date:(Some 0) "7";;
# Exception: Erreur "Date invalide ou pas prise en charge".
# ;;
trouver_voyages_sur_la_ligne ~date:(Some fin_annee) "7";;
# Exception: Erreur "Date invalide ou pas prise en charge".
# ;;   

(* Comportement correct *)
trouver_voyages_sur_la_ligne "7";;
#     - : string list =
["47420488-20160013multiint-1111100"; "46203427-20160013multiint-1111100";
 "47420498-20160013multiint-1111100"; "47420457-20160013multiint-1111100";
 "47420148-20160013multiint-1111100"; "46203434-20160013multiint-1111100";
 "47420484-20160013multiint-1111100"; "46203422-20160013multiint-1111100";
 "47420506-20160013multiint-1111100"; "46203412-20160013multiint-1111100";
 "47420405-20160013multiint-1111100"; "46203407-20160013multiint-1111100";
 "47420400-20160013multiint-1111100"; "46203402-20160013multiint-1111100";
 "46203361-20160013multiint-1111100"; "47420415-20160013multiint-1111100";
 "46203417-20160013multiint-1111100"; "47420410-20160013multiint-1111100";
 "46203436-20160013multiint-1111100"; "47420486-20160013multiint-1111100";
 "47420152-20160013multiint-1111100"; "46203363-20160013multiint-1111100";
 "47420416-20160013multiint-1111100"; "46203418-20160013multiint-1111100";
 "47420411-20160013multiint-1111100"; "46203371-20160013multiint-1111100";
 "47420421-20160013multiint-1111100"; "46203423-20160013multiint-1111100";
 "47420407-20160013multiint-1111100"; "46203409-20160013multiint-1111100";
 "47420402-20160013multiint-1111100"; "46203404-20160013multiint-1111100";
 "47420397-20160013multiint-1111100"; "46203333-20160013multiint-1111100";
 "47420396-20160013multiint-1111100"; "46203391-20160013multiint-1111100";
 "47420445-20160013multiint-1111100"; "46203386-20160013multiint-1111100";
 "47420440-20160013multiint-1111100"; "46203445-20160013multiint-1111100";
 "47420449-20160013multiint-1111100"; "47420490-20160013multiint-1111100";
 "47420155-20160013multiint-1111100"; "47420489-20160013multiint-1111100";
 "47420154-20160013multiint-1111100"; "46203351-20160013multiint-1111100";
 "47420452-20160013multiint-1111100"; "46203373-20160013multiint-1111100";
 "47420423-20160013multiint-1111100"; "46203425-20160013multiint-1111100";
 "47420479-20160013multiint-1111100"; "46203353-20160013multiint-1111100";
 "47420474-20160013multiint-1111100"; "46203348-20160013multiint-1111100";
 "47420469-20160013multiint-1111100"; "46203343-20160013multiint-1111100";
 "47420464-20160013multiint-1111100"; "46203338-20160013multiint-1111100";
 "47420458-20160013multiint-1111100"; "46203395-20160013multiint-1111100";
 "46203426-20160013multiint-1111100"; "47420499-20160013multiint-1111100";
 "46203435-20160013multiint-1111100"; "47420485-20160013multiint-1111100";
 "47420151-20160013multiint-1111100"; "46203352-20160013multiint-1111100";
 "47420473-20160013multiint-1111100"; "46203396-20160013multiint-1111100";
 "47420144-20160013multiint-1111100"; "46203393-20160013multiint-1111100";
 "46203369-20160013multiint-1111100"; "47420419-20160013multiint-1111100";
 "47420448-20160013multiint-1111100"; "46203429-20160013multiint-1111100";
 "46203335-20160013multiint-1111100"; "47420388-20160013multiint-1111100";
 "46203401-20160013multiint-1111100"; "47420455-20160013multiint-1111100";
 "47420145-20160013multiint-1111100"; "47420150-20160013multiint-1111100";
 "46203380-20160013multiint-1111100"; "47420497-20160013multiint-1111100";
 "46203377-20160013multiint-1111100"; "47420494-20160013multiint-1111100";
 "46203374-20160013multiint-1111100"; "47420426-20160013multiint-1111100";
 "46203431-20160013multiint-1111100"; "47420392-20160013multiint-1111100";
 "47420451-20160013multiint-1111100"; "47420478-20160013multiint-1111100";
 "46203463-20160013multiint-1111100"; "46203356-20160013multiint-1111100";
 "47420413-20160013multiint-1111100"; "46203461-20160013multiint-1111100";
 "46203341-20160013multiint-1111100"; "47420462-20160013multiint-1111100";
 "46203400-20160013multiint-1111100"; "47420143-20160013multiint-1111100";
 "46203432-20160013multiint-1111100"; ...]
# ;;
List.length (trouver_voyages_sur_la_ligne "7");;
# - : int = 253
# ;;
List.length (trouver_voyages_sur_la_ligne ~date:None "7");;
# - : int = 1144
# ;;

timeRun (fun x -> List.length (trouver_voyages_sur_la_ligne ~date:None x)) "7";;
#   - : int * float = (1144, 26.693267107009888)
# let t = Array.of_list (lister_numero_lignes ()) in
let sum = ref 0 in
let open Printf in
    printf "\n";
    for i = 0 to (Array.length t)-1 do
      let nb = List.length (trouver_voyages_sur_la_ligne t.(i)) in
          printf "%s : %d voyages\n" (t.(i)) nb;
      sum := !sum + nb
    done;
    printf "\nTotal voyages = %d\n" (!sum);;
                  
279 : 11 voyages
16 : 36 voyages
274 : 17 voyages
984 : 1 voyages
39 : 41 voyages
915 : 2 voyages
95 : 8 voyages
185 : 11 voyages
21 : 179 voyages
580 : 8 voyages
93 : 40 voyages
954 : 2 voyages
59 : 4 voyages
29 : 6 voyages
254 : 18 voyages
272 : 12 voyages
72 : 62 voyages
581 : 7 voyages
84g : 4 voyages
4 : 84 voyages
536 : 5 voyages
136 : 11 voyages
936 : 1 voyages
61 : 61 voyages
14a : 2 voyages
273 : 13 voyages
372 : 15 voyages
54g : 4 voyages
282 : 13 voyages
86g : 4 voyages
50 : 43 voyages
81 : 47 voyages
32 : 29 voyages
82 : 46 voyages
255 : 12 voyages
18 : 68 voyages
15b : 2 voyages
802 : 200 voyages
558 : 5 voyages
250 : 19 voyages
925 : 2 voyages
74 : 36 voyages
337 : 13 voyages
374 : 12 voyages
79b : 2 voyages
354 : 5 voyages
88 : 12 voyages
355 : 12 voyages
1 : 93 voyages
350 : 21 voyages
31 : 48 voyages
14g : 2 voyages
107 : 14 voyages
972 : 1 voyages
803 : 199 voyages
290 : 9 voyages
537 : 8 voyages
54 : 57 voyages
14 : 36 voyages
538 : 7 voyages
215 : 10 voyages
9 : 8 voyages
55g : 4 voyages
289 : 14 voyages
338 : 8 voyages
80 : 63 voyages
77 : 52 voyages
13 : 46 voyages
358 : 5 voyages
36 : 42 voyages
22 : 6 voyages
550 : 8 voyages
15 : 36 voyages
58 : 32 voyages
800 : 221 voyages
555 : 7 voyages
85 : 11 voyages
980 : 1 voyages
94 : 8 voyages
92a : 2 voyages
315 : 13 voyages
801 : 222 voyages
280 : 21 voyages
25 : 67 voyages
336 : 5 voyages
133 : 9 voyages
574 : 7 voyages
281 : 15 voyages
3 : 94 voyages
332 : 8 voyages
992 : 2 voyages
53 : 35 voyages
78 : 5 voyages
380 : 9 voyages
572 : 7 voyages
907 : 4 voyages
295 : 11 voyages
1a : 2 voyages
10 : 17 voyages
931 : 3 voyages
284 : 16 voyages
15a : 2 voyages
330 : 35 voyages
79 : 33 voyages
44 : 12 voyages
55h : 4 voyages
34 : 19 voyages
80g : 4 voyages
52 : 47 voyages
79a : 2 voyages
92 : 25 voyages
84 : 34 voyages
37 : 45 voyages
125 : 6 voyages
214 : 13 voyages
28 : 82 voyages
33 : 6 voyages
86 : 46 voyages
7 : 253 voyages
54a : 2 voyages
79g : 2 voyages
987 : 1 voyages
25g : 1 voyages
75 : 27 voyages
230 : 17 voyages
70 : 1 voyages
391 : 6 voyages
582 : 8 voyages
13b : 2 voyages
3g : 2 voyages
55 : 60 voyages
87 : 146 voyages
80a : 4 voyages
11g : 1 voyages
55a : 4 voyages
236 : 14 voyages
950 : 2 voyages
82a : 2 voyages
3a : 2 voyages
382 : 15 voyages
11 : 93 voyages
64 : 27 voyages
13a : 2 voyages
239 : 15 voyages
294 : 12 voyages
277 : 17 voyages
530 : 9 voyages
111 : 3 voyages
331 : 6 voyages
577 : 8 voyages
65 : 11 voyages
251 : 10 voyages
982 : 1 voyages
238 : 13 voyages
584 : 7 voyages
57 : 4 voyages
283 : 9 voyages
381 : 13 voyages
384 : 14 voyages
377 : 14 voyages

Total voyages = 4173
- : unit = ()
# ;;


(* -- map_voyages_passants_itineraire ---------------------------------------- *)
(* Traitement des préconditions *)
map_voyages_passants_itineraire fausse_station station_desjardins id [];;
#         Exception: Erreur "Station de départ inexistante ".
# ;;
map_voyages_passants_itineraire station_desjardins fausse_station id [];;
# Exception: Erreur "Station de destination inexistante ".
# ;;
map_voyages_passants_itineraire ~heure:(-1)
  station_desjardins station_desjardins' id [];;
#   Exception: Erreur "Heure négative".
# ;;
    
(* Comportement correct *)
map_voyages_passants_itineraire 
  station_desjardins' 1440
  (fun (a,a',v) -> (a,a'))
  (trouver_voyages_par_date ());;
#           - : (Reseau_de_transport.arret * Reseau_de_transport.arret) list =
[({station_id = 1515; voyage_id = "47417185-20160013multiint-0000100";
   arrivee = 92460; depart = 92460; num_sequence = 20130;
   embarque_client = true; debarque_client = true},
  {station_id = 1440; voyage_id = "47417185-20160013multiint-0000100";
   arrivee = 93370; depart = 93370; num_sequence = 20260;
   embarque_client = true; debarque_client = true});
 ({station_id = 1515; voyage_id = "47417184-20160013multiint-0000100";
   arrivee = 97860; depart = 97860; num_sequence = 20130;
   embarque_client = true; debarque_client = true},
  {station_id = 1440; voyage_id = "47417184-20160013multiint-0000100";
   arrivee = 98770; depart = 98770; num_sequence = 20260;
   embarque_client = true; debarque_client = true});
 ({station_id = 1515; voyage_id = "47421442-20160013multiint-1111100";
   arrivee = 79260; depart = 79260; num_sequence = 20450;
   embarque_client = true; debarque_client = true},
  {station_id = 1440; voyage_id = "47421442-20160013multiint-1111100";
   arrivee = 80255; depart = 80255; num_sequence = 20580;
   embarque_client = true; debarque_client = true});
 ({station_id = 1515; voyage_id = "47421863-20160013multiint-1111100";
   arrivee = 88740; depart = 88740; num_sequence = 20440;
   embarque_client = true; debarque_client = true},
  {station_id = 1440; voyage_id = "47421863-20160013multiint-1111100";
   arrivee = 89666; depart = 89666; num_sequence = 20570;
   embarque_client = true; debarque_client = true});
 ({station_id = 1515; voyage_id = "47421818-20160013multiint-1111100";
   arrivee = 56580; depart = 56580; num_sequence = 20440;
   embarque_client = true; debarque_client = true},
  {station_id = 1440; voyage_id = "47421818-20160013multiint-1111100";
   arrivee = 57884; depart = 57884; num_sequence = 20570;
   embarque_client = true; debarque_client = true});
 ({station_id = 1515; voyage_id = "47421840-20160013multiint-1111100";
   arrivee = 68220; depart = 68220; num_sequence = 20440;
   embarque_client = true; debarque_client = true},
  {station_id = 1440; voyage_id = "47421840-20160013multiint-1111100";
   arrivee = 69335; depart = 69335; num_sequence = ...;
   embarque_client = ...; debarque_client = ...});
 ...]
# ;;

map_voyages_passants_itineraire 
  station_desjardins' 1440
  (fun (a,a',v) -> (a,a'))
  (trouver_voyages_sur_la_ligne "800");;
#         - : (Reseau_de_transport.arret * Reseau_de_transport.arret) list =
[({station_id = 1515; voyage_id = "47421442-20160013multiint-1111100";
   arrivee = 79260; depart = 79260; num_sequence = 20450;
   embarque_client = true; debarque_client = true},
  {station_id = 1440; voyage_id = "47421442-20160013multiint-1111100";
   arrivee = 80255; depart = 80255; num_sequence = 20580;
   embarque_client = true; debarque_client = true});
 ({station_id = 1515; voyage_id = "47421431-20160013multiint-1111100";
   arrivee = 68580; depart = 68580; num_sequence = 20450;
   embarque_client = true; debarque_client = true},
  {station_id = 1440; voyage_id = "47421431-20160013multiint-1111100";
   arrivee = 69695; depart = 69695; num_sequence = 20580;
   embarque_client = true; debarque_client = true});
 ({station_id = 1515; voyage_id = "47421579-20160013multiint-1111100";
   arrivee = 78360; depart = 78360; num_sequence = 20450;
   embarque_client = true; debarque_client = true},
  {station_id = 1440; voyage_id = "47421579-20160013multiint-1111100";
   arrivee = 79355; depart = 79355; num_sequence = 20580;
   embarque_client = true; debarque_client = true});
 ({station_id = 1515; voyage_id = "47421608-20160013multiint-1111100";
   arrivee = 46560; depart = 46560; num_sequence = 20450;
   embarque_client = true; debarque_client = true},
  {station_id = 1440; voyage_id = "47421608-20160013multiint-1111100";
   arrivee = 47795; depart = 47795; num_sequence = 20580;
   embarque_client = true; debarque_client = true});
 ({station_id = 1515; voyage_id = "47421606-20160013multiint-1111100";
   arrivee = 47700; depart = 47700; num_sequence = 20450;
   embarque_client = true; debarque_client = true},
  {station_id = 1440; voyage_id = "47421606-20160013multiint-1111100";
   arrivee = 48935; depart = 48935; num_sequence = 20580;
   embarque_client = true; debarque_client = true});
 ({station_id = 1515; voyage_id = "47421426-20160013multiint-1111100";
   arrivee = 65040; depart = 65040; num_sequence = 20450;
   embarque_client = true; debarque_client = true},
  {station_id = 1440; voyage_id = "47421426-20160013multiint-1111100";
   arrivee = 66215; depart = 66215; num_sequence = ...;
   embarque_client = ...; debarque_client = ...});
 ...]
# ;;

  
(* -- trouver_stations_environnantes ----------------------------------------- *)
(* Traitement des préconditions *)
trouver_stations_environnantes faux_gps 0.2;;
#         Exception: Erreur "Position GPS invalide".
# ;;
trouver_stations_environnantes pouliot_gps (-0.2);;
# Exception: Erreur "Rayon négatif".
# ;;

(* Comportement correct *)
trouver_stations_environnantes pouliot_gps 0.5;;
#     - : (int * float) list =
[(7011, 0.069886185689172819); (1557, 0.087605408732544174);
 (7010, 0.20810972051141796); (1556, 0.21536328285923306);
 (1558, 0.27367618271800442); (7012, 0.28600217404499445);
 (7000, 0.29580490977970575); (7008, 0.31672006960027688);
 (1515, 0.32609979009332923); (7009, 0.33212908540099945);
 (1561, 0.38610782496985857); (1559, 0.38956752844578879);
 (3172, 0.40479470611535578); (2190, 0.41792571514694232);
 (1999, 0.420798609229271); (1542, 0.432811544563683);
 (1501, 0.43317547426436431); (1554, 0.46002311521835049);
 (1830, 0.46684231873797472); (2145, 0.49256465128265803)]
# ;;
trouver_stations_environnantes pouliot_gps 0.2;;
# - : (int * float) list =
[(7011, 0.069886185689172819); (1557, 0.087605408732544174)]
# ;;
trouver_stations_environnantes desjardins_gps 0.2;;
# - : (int * float) list =
[(1561, 0.029089886927486971); (1515, 0.079511526522180562)]
# ;;

  
(* -- lister_lignes_passantes_station ---------------------------------------- *)
(* Traitement des préconditions *)
lister_lignes_passantes_station fausse_station;;
#         Exception: Erreur "Station inexistante ".
# ;;

(* Comportement correct *)
lister_lignes_passantes_station station_desjardins';;
#     - : string list =
["380"; "801"; "800"; "377"; "358"; "355"; "350"; "338"; "337"; "336"; "330";
 "295"; "87"; "915"; "16"; "13"; "384"; "374"; "372"; "315"; "294"; "93";
 "382"; "381"]
# ;;
lister_lignes_passantes_station station_desjardins;;
# - : string list =
["295"; "294"; "987"; "87"; "801"; "800"; "377"; "358"; "355"; "350"; "338";
 "337"; "336"; "330"; "18"; "931"; "16"; "13"; "384"; "380"; "374"; "372";
 "315"; "93"; "382"; "381"]
# ;;

  
(* -- lister_arrets_par_voyage ----------------------------------------------- *)
(* Traitement des préconditions *)
lister_arrets_par_voyage "0";;
#         Exception: Erreur "Voyage inexistant ".
# ;;

(* Comportement correct *)
trouver_voyages_sur_la_ligne "800";;
#     - : string list =
["47421584-20160013multiint-1111100"; "47421537-20160013multiint-1111100";
 "47421592-20160013multiint-1111100"; "47421512-20160013multiint-1111100";
 "47421567-20160013multiint-1111100"; "47421446-20160013multiint-1111100";
 "47421557-20160013multiint-1111100"; "47421582-20160013multiint-1111100";
 "47421545-20160013multiint-1111100"; "47421449-20160013multiint-1111100";
 "47421520-20160013multiint-1111100"; "47421600-20160013multiint-1111100";
 "47421500-20160013multiint-1111100"; "47421639-20160013multiint-1111100";
 "47421458-20160013multiint-1111100"; "47421508-20160013multiint-1111100";
 "47421570-20160013multiint-1111100"; "47421575-20160013multiint-1111100";
 "47421560-20160013multiint-1111100"; "47421580-20160013multiint-1111100";
 "47421549-20160013multiint-1111100"; "47421586-20160013multiint-1111100";
 "47421529-20160013multiint-1111100"; "47421612-20160013multiint-1111100";
 "47421489-20160013multiint-1111100"; "47421629-20160013multiint-1111100";
 "47421566-20160013multiint-1111100"; "47421577-20160013multiint-1111100";
 "47421556-20160013multiint-1111100"; "47421434-20160013multiint-1111100";
 "47421544-20160013multiint-1111100"; "47421619-20160013multiint-1111100";
 "47421482-20160013multiint-1111100"; "47421640-20160013multiint-1111100";
 "47421530-20160013multiint-1111100"; "47421594-20160013multiint-1111100";
 "47421507-20160013multiint-1111100"; "47421506-20160013multiint-1111100";
 "47421630-20160013multiint-1111100"; "47421471-20160013multiint-1111100";
 "47421543-20160013multiint-1111100"; "47421432-20160013multiint-1111100";
 "47421517-20160013multiint-1111100"; "47421620-20160013multiint-1111100";
 "47421481-20160013multiint-1111100"; "47421448-20160013multiint-1111100";
 "47421602-20160013multiint-1111100"; "47421498-20160013multiint-1111100";
 "47421642-20160013multiint-1111100"; "47421436-20160013multiint-1111100";
 "47421527-20160013multiint-1111100"; "47421445-20160013multiint-1111100";
 "47421505-20160013multiint-1111100"; "47421604-20160013multiint-1111100";
 "47421496-20160013multiint-1111100"; "47421622-20160013multiint-1111100";
 "47421479-20160013multiint-1111100"; "47421644-20160013multiint-1111100";
 "47421495-20160013multiint-1111100"; "47421623-20160013multiint-1111100";
 "47421478-20160013multiint-1111100"; "47421477-20160013multiint-1111100";
 "47421453-20160013multiint-1111100"; "47421540-20160013multiint-1111100";
 "47421591-20160013multiint-1111100"; "47421514-20160013multiint-1111100";
 "47421430-20160013multiint-1111100"; "47421462-20160013multiint-1111100";
 "47421513-20160013multiint-1111100"; "47421638-20160013multiint-1111100";
 "47421467-20160013multiint-1111100"; "47421593-20160013multiint-1111100";
 "47421510-20160013multiint-1111100"; "47421536-20160013multiint-1111100";
 "47421452-20160013multiint-1111100"; "47421511-20160013multiint-1111100";
 "47421459-20160013multiint-1111100"; "47421618-20160013multiint-1111100";
 "47421483-20160013multiint-1111100"; "47421611-20160013multiint-1111100";
 "47421490-20160013multiint-1111100"; "47421628-20160013multiint-1111100";
 "47421472-20160013multiint-1111100"; "47421601-20160013multiint-1111100";
 "47421499-20160013multiint-1111100"; "47421641-20160013multiint-1111100";
 "47421466-20160013multiint-1111100"; "47421533-20160013multiint-1111100";
 "47421457-20160013multiint-1111100"; "47421509-20160013multiint-1111100";
 "47421433-20160013multiint-1111100"; "47421605-20160013multiint-1111100";
 "47421645-20160013multiint-1111100"; "47421456-20160013multiint-1111100";
 "47421455-20160013multiint-1111100"; "47421565-20160013multiint-1111100";
 "47421463-20160013multiint-1111100"; "47421516-20160013multiint-1111100";
 "47421621-20160013multiint-1111100"; "47421480-20160013multiint-1111100";
 "47421643-20160013multiint-1111100"; "47421465-20160013multiint-1111100";
 "47421454-20160013multiint-1111100"; "47421563-20160013multiint-1111100";
 "47421607-20160013multiint-1111100"; "47421578-20160013multiint-1111100";
 "47421554-20160013multiint-1111100"; "47421583-20160013multiint-1111100";
 "47421541-20160013multiint-1111100"; "47421603-20160013multiint-1111100";
 "47421497-20160013multiint-1111100"; "47421613-20160013multiint-1111100";
 "47421488-20160013multiint-1111100"; "47421631-20160013multiint-1111100";
 "47421470-20160013multiint-1111100"; "47421460-20160013multiint-1111100";
 "47421440-20160013multiint-1111100"; "47421515-20160013multiint-1111100";
 "47421443-20160013multiint-1111100"; "47421573-20160013multiint-1111100";
 "47421587-20160013multiint-1111100"; "47421524-20160013multiint-1111100";
 "47421596-20160013multiint-1111100"; "47421504-20160013multiint-1111100";
 "47421633-20160013multiint-1111100"; "47421469-20160013multiint-1111100";
 "47421568-20160013multiint-1111100"; "47421576-20160013multiint-1111100";
 "47421558-20160013multiint-1111100"; "47421437-20160013multiint-1111100";
 "47421547-20160013multiint-1111100"; "47421597-20160013multiint-1111100";
 "47421503-20160013multiint-1111100"; "47421428-20160013multiint-1111100";
 "47421571-20160013multiint-1111100"; "47421451-20160013multiint-1111100";
 "47421561-20160013multiint-1111100"; "47421439-20160013multiint-1111100";
 "47421550-20160013multiint-1111100"; "47421522-20160013multiint-1111100";
 "47421598-20160013multiint-1111100"; "47421502-20160013multiint-1111100";
 "47421636-20160013multiint-1111100"; "47421468-20160013multiint-1111100";
 "47421572-20160013multiint-1111100"; "47421574-20160013multiint-1111100";
 "47421562-20160013multiint-1111100"; "47421585-20160013multiint-1111100";
 "47421532-20160013multiint-1111100"; "47421429-20160013multiint-1111100";
 "47421531-20160013multiint-1111100"; "47421590-20160013multiint-1111100";
 "47421444-20160013multiint-1111100"; "47421555-20160013multiint-1111100";
 "47421435-20160013multiint-1111100"; "47421542-20160013multiint-1111100";
 "47421546-20160013multiint-1111100"; "47421464-20160013multiint-1111100";
 "47421564-20160013multiint-1111100"; "47421461-20160013multiint-1111100";
 "47421441-20160013multiint-1111100"; "47421553-20160013multiint-1111100";
 "47421450-20160013multiint-1111100"; "47421539-20160013multiint-1111100";
 "47421427-20160013multiint-1111100"; "47421523-20160013multiint-1111100";
 "47421569-20160013multiint-1111100"; "47421447-20160013multiint-1111100";
 "47421559-20160013multiint-1111100"; "47421581-20160013multiint-1111100";
 "47421548-20160013multiint-1111100"; "47421588-20160013multiint-1111100";
 "47421425-20160013multiint-1111100"; "47421519-20160013multiint-1111100";
 "47421599-20160013multiint-1111100"; "47421589-20160013multiint-1111100";
 "47421518-20160013multiint-1111100"; "47421528-20160013multiint-1111100";
 "47421595-20160013multiint-1111100"; "47421526-20160013multiint-1111100";
 "47421614-20160013multiint-1111100"; "47421487-20160013multiint-1111100";
 "47421632-20160013multiint-1111100"; "47421426-20160013multiint-1111100";
 "47421525-20160013multiint-1111100"; "47421615-20160013multiint-1111100";
 "47421486-20160013multiint-1111100"; "47421634-20160013multiint-1111100";
 "47421538-20160013multiint-1111100"; "47421606-20160013multiint-1111100";
 "47421494-20160013multiint-1111100"; "47421624-20160013multiint-1111100";
 "47421476-20160013multiint-1111100"; "47421635-20160013multiint-1111100";
 "47421535-20160013multiint-1111100"; "47421608-20160013multiint-1111100";
 "47421493-20160013multiint-1111100"; "47421625-20160013multiint-1111100";
 "47421475-20160013multiint-1111100"; "47421616-20160013multiint-1111100";
 "47421485-20160013multiint-1111100"; "47421438-20160013multiint-1111100";
 "47421579-20160013multiint-1111100"; "47421551-20160013multiint-1111100";
 "47421431-20160013multiint-1111100"; "47421534-20160013multiint-1111100";
 "47421609-20160013multiint-1111100"; "47421492-20160013multiint-1111100";
 "47421626-20160013multiint-1111100"; "47421474-20160013multiint-1111100";
 "47421501-20160013multiint-1111100"; "47421521-20160013multiint-1111100";
 "47421617-20160013multiint-1111100"; "47421484-20160013multiint-1111100";
 "47421637-20160013multiint-1111100"; "47421610-20160013multiint-1111100";
 "47421491-20160013multiint-1111100"; "47421627-20160013multiint-1111100";
 "47421473-20160013multiint-1111100"; "47421442-20160013multiint-1111100";
 "47421552-20160013multiint-1111100"]
# ;;

lister_arrets_par_voyage "47421501-20160013multiint-1111100";;
#   - : int list =
[2009; 1445; 1807; 1913; 2112; 1437; 2113; 2115; 2117; 3875; 1823; 1824;
 1826; 1828; 1561; 1564; 1567; 1570; 1573; 1575; 1578; 1579; 1581; 1583;
 1560; 2664; 1191; 8002; 1104; 1105; 2562; 4903; 2563; 2564; 1346; 2565;
 1756; 1757; 2568; 2569; 2511; 2570; 2530; 2518; 2531; 2532; 3344; 2533;
 2535; 2639; 2454; 3351; 3355; 3358; 3361; 3365; 3364; 3473]
# ;;
lister_arrets_par_voyage "47421618-20160013multiint-1111100";;
# - : int list =
[3371; 3440; 3461; 3443; 3446; 3449; 3451; 2452; 2641; 2536; 3457; 3458;
 2537; 2547; 2548; 2538; 2549; 2551; 2481; 2555; 1723; 1724; 1375; 1376;
 2519; 2557; 4519; 2558; 1025; 1026; 1028; 1263; 1265; 1190; 1517; 1520;
 1522; 1523; 1525; 1081; 1528; 1531; 1534; 1537; 1515; 1787; 1776; 1790;
 1791; 2000; 2001; 2003; 2006; 1434; 2007; 4144; 3099; 1440; 2009]
# ;;

   
(* -- trouver_horaire_ligne_a_la_station -------------------------------------- *)
(* Traitement des préconditions *)
trouver_horaire_ligne_a_la_station ~date:0 "800" station_desjardins;;
#         Exception: Erreur "Date invalide ou pas prise en charge".
# ;;
trouver_horaire_ligne_a_la_station ~date:fin_annee "800" station_desjardins;;
# Exception: Erreur "Date invalide ou pas prise en charge".
# ;;
trouver_horaire_ligne_a_la_station ~heure:(-1) "800" station_desjardins;;
# Exception: Erreur "Heure négative".
# ;;
trouver_horaire_ligne_a_la_station "0" station_desjardins;;
# Exception: Erreur "La ligne ne passe pas par la station".
# ;;
trouver_horaire_ligne_a_la_station "800" fausse_station;;
# Exception: Erreur "Station inexistante ".
# ;;
trouver_horaire_ligne_a_la_station "800" 1076;;
# Exception: Erreur "La ligne ne passe pas par la station".
# ;;

(* Comportement correct *)
secs_a_heure (heure_actuelle());;
#     - : string = "12:54:19"
# ;;
  
trouver_horaire_ligne_a_la_station "800" station_desjardins';;
#   - : string list =
["12:56:00"; "13:06:00"; "13:15:00"; "13:25:00"; "13:35:00"; "13:45:00";
 "13:55:00"; "14:05:00"; "14:15:00"; "14:25:00"; "14:35:00"; "14:45:00";
 "14:56:00"; "15:06:00"; "15:16:00"; "15:26:00"; "15:37:00"; "15:48:00";
 "15:58:00"; "16:08:00"; "16:18:00"; "16:27:00"; "16:36:00"; "16:44:00";
 "16:52:00"; "17:00:00"; "17:08:00"; "17:16:00"; "17:24:00"; "17:30:00";
 "17:38:00"; "17:46:00"; "17:56:00"; "18:04:00"; "18:14:00"; "18:24:00";
 "18:34:00"; "18:43:00"; "18:53:00"; "19:03:00"; "19:17:00"; "19:32:00";
 "19:48:00"; "20:02:00"; "20:18:00"; "20:32:00"; "20:47:00"; "21:01:00";
 "21:16:00"; "21:31:00"; "21:46:00"; "22:01:00"; "22:16:00"; "22:31:00";
 "22:46:00"; "23:01:00"; "23:16:00"; "23:31:00"; "23:46:00"; "24:01:00";
 "24:16:00"; "24:31:00"; "24:46:00"; "25:01:00"; "25:16:00"]
# ;;
trouver_horaire_ligne_a_la_station "18" station_desjardins;;
# - : string list =
["13:04:00"; "13:37:00"; "13:59:00"; "14:09:56"; "14:33:00"; "14:59:00";
 "15:01:56"; "15:30:00"; "16:09:00"; "16:34:00"; "16:43:56"; "17:00:00";
 "17:18:56"; "17:19:00"; "17:33:00"; "17:48:00"; "18:03:00"; "18:18:00";
 "18:33:00"; "19:34:00"; "20:35:00"; "21:05:00"; "21:35:00"; "22:34:00"]
# ;;
trouver_horaire_ligne_a_la_station "800" station_desjardins;;
# - : string list =
["12:55:00"; "13:05:00"; "13:15:00"; "13:24:00"; "13:34:00"; "13:44:00";
 "13:54:00"; "14:04:00"; "14:14:00"; "14:24:00"; "14:34:00"; "14:44:00";
 "14:54:00"; "15:01:00"; "15:09:00"; "15:17:00"; "15:24:00"; "15:31:00";
 "15:38:00"; "15:45:00"; "15:52:00"; "15:58:00"; "16:05:00"; "16:12:00";
 "16:19:00"; "16:26:00"; "16:33:00"; "16:40:00"; "16:47:00"; "16:54:00";
 "17:01:00"; "17:08:00"; "17:16:00"; "17:23:00"; "17:32:00"; "17:41:00";
 "17:50:00"; "17:59:00"; "18:10:00"; "18:20:00"; "18:30:00"; "18:42:00";
 "18:54:00"; "19:08:00"; "19:23:00"; "19:38:00"; "19:54:00"; "20:08:00";
 "20:23:00"; "20:37:00"; "20:52:00"; "21:07:00"; "21:22:00"; "21:37:00";
 "21:55:00"; "22:09:00"; "22:24:00"; "22:39:00"; "22:56:00"; "23:12:00";
 "23:27:00"; "23:42:00"; "23:57:00"; "24:12:00"; "24:27:00"; "24:42:00";
 "24:57:00"; "25:12:00"]
# ;;


(* -- lister_stations_sur_itineraire_ligne ----------------------------------- *)
(* Traitement des préconditions *)
lister_stations_sur_itineraire_ligne "0";;
#         Exception: Erreur "Ligne inexistante ".
# ;;  

(* Comportement correct *)
lister_stations_sur_itineraire_ligne "11";;
#     - : (string * int list) list =
[("Place D'Youville / Vieux-QuÃ©bec (Est)",
  [2070; 2071; 3998; 1905; 1906; 1907; 1908; 1909; 1911; 1807; 1808; 1809;
   1810; 1811; 1812; 1813; 1814; 1815; 1816; 1817; 1818; 1820; 1441; 1823;
   1824; 1826; 1828; 1830; 1831; 1832; 1833; 1834; 1835; 1836; 1837; 1838;
   1839; 1840; 1841; 1073; 1074; 1075; 1076; 1077; 1078; 1844; 1845; 1846;
   1847; 1848; 1849; 1850; 1851; 1852; 1853; 1854; 1855; 1856; 1271; 1272;
   1274; 1275; 1276; 1134; 1124; 1259; 2625]);
 ("Pointe-de-Sainte-Foy (Ouest)",
  [1271; 1272; 1274; 1275; 1276; 1134; 1124; 1259; 2625; 1190; 1270; 1762;
   1763; 1764; 1765; 1766; 1767; 1768; 1769; 1770; 1771; 1772; 1773; 1774;
   1056; 1057; 1058; 1059; 1060; 1061; 1063; 1065; 1066; 1777; 1778; 1779;
   1780; 1781; 1782; 1783; 1999; 1787; 1776; 1790; 1791; 1793; 1794; 1795;
   1796; 1797; 1798; 1799; 1800; 1801; 1802; 1804; 1803; 1805; 1806; 3099;
   1440; 1882; 1883; 1884; 1885; 2070; 2071; 3998; 1905])]
# ;;
lister_stations_sur_itineraire_ligne "800";;
# - : (string * int list) list =
[("Beauport (Est)",
  [2009; 1445; 1807; 1913; 2112; 1437; 2113; 2115; 2117; 3875; 1823; 1824;
   1826; 1828; 1561; 1564; 1567; 1570; 1573; 1575; 1578; 1579; 1581; 1583;
   1560; 2664; 1191; 8002; 1104; 1105; 2562; 4903; 2563; 2564; 1346; 2565;
   1756; 1757; 2568; 2569; 2511; 2570; 2530; 2518; 2531; 2532; 3344; 2533;
   2535; 2639; 2454; 3351; 3355; 3358; 3361; 3365; 3364; 3473]);
 ("Pointe-de-Sainte-Foy (Ouest)",
  [3371; 3440; 3461; 3443; 3446; 3449; 3451; 2452; 2641; 2536; 3457; 3458;
   2537; 2547; 2548; 2538; 2549; 2551; 2481; 2555; 1723; 1724; 1375; 1376;
   2519; 2557; 4519; 2558; 1025; 1026; 1028; 1263; 1265; 1190; 1517; 1520;
   1522; 1523; 1525; 1081; 1528; 1531; 1534; 1537; 1515; 1787; 1776; 1790;
   1791; 2000; 2001; 2003; 2006; 1434; 2007; 4144; 3099; 1440; 2009])]
# ;;


(* -- ligne_passe_par_station ------------------------------------------------ *)
(* Traitement des préconditions *)
ligne_passe_par_station "0" station_desjardins';;
#         Exception: Erreur "Ligne inexistante".
# ;;
ligne_passe_par_station "801" fausse_station;;
# Exception: Erreur "Station inexistante".
# ;;

(* Comportement correct *)
ligne_passe_par_station "800" station_desjardins';;
#     - : bool = true
# ;;
ligne_passe_par_station "801" station_desjardins;;
# - : bool = true
# ;;
ligne_passe_par_station "11" 1076;;
# - : bool = true
# ;;

  
(* -- duree_du_prochain_voyage_partant --------------------------------------- *)
(* Traitement des préconditions *)
duree_du_prochain_voyage_partant ~date:0 "11" 1815 1271;;
#         Exception: Erreur "Date invalide ou pas prise en charge".
# ;;
duree_du_prochain_voyage_partant ~date:fin_annee "11" 1815 1271;;
# Exception: Erreur "Date invalide ou pas prise en charge".
# ;;
duree_du_prochain_voyage_partant ~heure:(-1) "11" 1815 1271;;
# Exception: Erreur "Heure invalide".
# ;;
duree_du_prochain_voyage_partant  "0" 1815 1271;;
# Exception: Erreur "Ligne inexistante".
# ;;
duree_du_prochain_voyage_partant  "11" fausse_station 1271;;
# Exception: Erreur "Station inexistante".
# ;;
duree_du_prochain_voyage_partant  "11" 1815 fausse_station;;
# Exception: Erreur "Station inexistante".
# ;;
duree_du_prochain_voyage_partant  "11" station_desjardins 1271;;
# Exception: Erreur "La ligne ne passe pas par la station de départ".
# ;;
duree_du_prochain_voyage_partant  "11" 1815 station_desjardins;;
# Exception: Erreur "La ligne ne passe pas par la station de destination".
# ;;

(* Comportement correct *)
duree_du_prochain_voyage_partant "800" station_desjardins' 1440;;
#     - : int = 20
# ;;  
duree_du_prochain_voyage_partant "11" 1815 1271;;
# - : int = 34
# ;;


(* -- duree_attente_prochain_arret_ligne_a_la_station ------------------------ *)
(* Traitement des préconditions *)
duree_attente_prochain_arret_ligne_a_la_station
  ~date:0 "800" station_desjardins';;
#           Exception: Erreur "Date invalide ou pas prise en charge".
# ;;
duree_attente_prochain_arret_ligne_a_la_station
  ~date:fin_annee "800" station_desjardins';;
#   Exception: Erreur "Date invalide ou pas prise en charge".
# ;;
duree_attente_prochain_arret_ligne_a_la_station
  ~heure:(-1) "800" station_desjardins';;
#   Exception: Erreur "Heure négative".
# ;;
duree_attente_prochain_arret_ligne_a_la_station "0" station_desjardins';;
# Exception: Erreur "Ligne inexistante".
# ;;
duree_attente_prochain_arret_ligne_a_la_station "800" fausse_station;;
# Exception: Erreur "Station inexistante".
# ;;

(* Comportement correct *)
duree_attente_prochain_arret_ligne_a_la_station "800" station_desjardins';;
#     - : int = 9
# ;;
duree_attente_prochain_arret_ligne_a_la_station "11" 1815;;
# - : int = 8
# ;;

secs_a_heure (heure_actuelle());;
#   - : string = "12:57:06"
# ;;
  
(* -- ligne_arrive_le_plus_tot ----------------------------------------------- *)
(* Traitement des préconditions *)
ligne_arrive_le_plus_tot ~date:0 station_desjardins' 1440;;
#       Exception: Erreur "Date invalide ou pas prise en charge".
# ;;
ligne_arrive_le_plus_tot ~date:fin_annee station_desjardins' 1440;;
# Exception: Erreur "Date invalide ou pas prise en charge".
# ;;
ligne_arrive_le_plus_tot ~heure:(-1) station_desjardins' 1440;;
# Exception: Erreur "Heure négative".
# ;;
ligne_arrive_le_plus_tot fausse_station 1440;;
# Exception: Erreur "Station de départ inexistante ".
# ;;
ligne_arrive_le_plus_tot station_desjardins' fausse_station;;
# Exception: Erreur "Station de destination inexistante ".
# ;;

(* Comportement correct *)
ligne_arrive_le_plus_tot station_desjardins' 1440;;
#     - : string * int = ("801", 23)
# ;;


(* -- ligne_met_le_moins_temps ----------------------------------------------- *)
(* Traitement des préconditions *)
ligne_met_le_moins_temps ~date:0 station_desjardins' 1440;;
#         Exception: Erreur "Date invalide ou pas prise en charge".
# ;;
ligne_met_le_moins_temps ~date:fin_annee station_desjardins' 1440;;
# Exception: Erreur "Date invalide ou pas prise en charge".
# ;;
ligne_met_le_moins_temps ~heure:(-1) station_desjardins' 1440;;
# Exception: Erreur "Heure négative".
# ;;
ligne_met_le_moins_temps fausse_station 1440;;
# Exception: Erreur "Station de départ inexistante ".
# ;;
ligne_met_le_moins_temps station_desjardins' fausse_station;;
# Exception: Erreur "Station de destination inexistante ".
# ;;

(* Comportement correct *)
ligne_met_le_moins_temps station_desjardins' 1440;;
#     - : string * int = ("915", 15)
# ;;

(* Pour terminer ... *)
timeRun (ligne_arrive_le_plus_tot station_desjardins') 1440;;
#     - : (string * int) * float = (("801", 20), 33.736289501190186)
# ;;
timeRun (ligne_met_le_moins_temps station_desjardins') 1440;;
# - : (string * int) * float = (("915", 15), 22.751316785812378)
# ;;
secs_a_heure (heure_actuelle());;
# - : string = "13:02:46"
# 

