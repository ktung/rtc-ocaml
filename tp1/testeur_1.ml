(* --------------------------------------------------------------------------- *)
(* ----------------------- TP1 - IFT-3000 - Hiver 2016 ----------------------- *)
(* --------------------------------------------------------------------------- *)
(* Fichier pertmettant de tester les fonctions implantées du TP                *)
(* --------------------------------------------------------------------------- *)
(* On suppose que le Tp1 est chargé dans la mémoire de l'interpréteur;         *)
(* il suffit alors d'entrer dans l'interpréteur ce qui suit:                   *)
(*                                                                             *)
(* # #use "testeur.ml";;                                                       *)
(*                                                                             *)
(* Par la suite:                                                               *)
(*                                                                             *)
(* # test();;  (* Teste toutes les fonctions                           *)      *)
(* # test'();; (* Charge les données et teste toutes les fonctions     *)      *)
(*             (* N'oubliez pas de vous assurer que le chemin indiqué  *)      *)
(*             (* pour le chargement des fichiers du RTC est le bon    *)      *)
(* # testn();; (* n = 1 ou 2 ...; teste la fonction numéro n           *)      *)
(*                                                                             *)
(* Lorsque le fichier tp1.ml est modifié, vous n'avez juste qu'à:              *)
(* - recharger le fichier tp1.ml (#use ou #load, selon);                       *)
(* - recharger le fichier testeur.ml.                                          *)
(* Par la suite, vous pouvez de nouveau effectuer les tests (test(); testn())  *)
(* --------------------------------------------------------------------------- *)

open Utiles;;
open Date;;
open Reseau_de_transport;;    (* ou Reseau, si version compilé du Tp *)
open Gestionnaire_transport;; (* ou Tp1, si version compilé du Tp    *)

(* --------------------------------------------------------------------------- *)
(* -- FONCTIONS UTILES ------------------------------------------------------- *)
(* --------------------------------------------------------------------------- *)
let fail () = print_endline ("....................." ^ "Fail")
and pass () = print_endline ("....................." ^ "Pass");;
  
let assert_equal nom_test a b = 
  print_endline (String.uppercase nom_test); 
  if a = b then pass() else fail();;
  
let assert_equal_list nom_test a b = 
  print_endline (String.uppercase nom_test); 
  if (a ++ b) = a then pass() else fail();;
  
let assert_throw_exception nom_test lazy_expression =
  print_endline (String.uppercase nom_test);
  match lazy_expression () with
  | exception (Erreur _) -> pass()
  | exception _ -> fail()
  | _ -> fail();;
  
let assert_true nom_test lazy_expression =
  print_endline (String.uppercase nom_test);
  match lazy_expression () with
  | true -> pass()
  | false -> fail();;  
  

(* -- À IMPLANTER/COMPLÉTER (6 PTS) ---------------------------------------- *)
(* @Fonction      : lister_numero_lignes_par_type : 
                    ?types:type_ligne list -> unit 
                    -> (type_ligne * string list) list                       *)
(* @Description   : liste tous les numeros des lignes du réseau  groupés par 
                    type dans la liste de types en paramètre,...             *)
(* @Precondition  : aucune                                                   *)
(* @Postcondition : la liste retournée est correcte                          *)
let test1() =
  try
    let metrobus = ["802"; "803"; "800"; "801"] and
        express = 
          ["279"; "274"; "580"; "254"; "272"; "581"; "536"; "273"; "372"; "282";
           "255"; "558"; "250"; "337"; "374"; "354"; "355"; "350"; "290"; "537";
           "538"; "215"; "289"; "338"; "358"; "550"; "555"; "315"; "280"; "336";
           "574"; "281"; "332"; "380"; "572"; "295"; "284"; "330"; "214"; "230";
           "391"; "582"; "236"; "382"; "239"; "294"; "277"; "530"; "331"; "577";
           "251"; "238"; "584"; "283"; "381"; "384"; "377"] and
        lebus = 
          ["16"; "39"; "95"; "185"; "21"; "93"; "59"; "29"; "72"; "84g"; "4"; "136";
           "61"; "14a"; "54g"; "86g"; "50"; "81"; "32"; "82"; "18"; "15b"; "74";
           "79b"; "88"; "1"; "31"; "14g"; "107"; "54"; "14"; "9"; "55g"; "80"; "77";
           "13"; "36"; "22"; "15"; "58"; "85"; "94"; "92a"; "25"; "133"; "3"; "53";
           "78"; "1a"; "10"; "15a"; "79"; "44"; "55h"; "34"; "80g"; "52"; "79a";
           "92"; "84"; "37"; "125"; "28"; "33"; "86"; "7"; "54a"; "79g"; "25g"; "75";
           "70"; "13b"; "3g"; "55"; "87"; "80a"; "11g"; "55a"; "82a"; "3a"; "11";
           "64"; "13a"; "111"; "65"; "57"] and
        couchetard = ["984"; "915"; "954"; "936"; "925"; "972"; "980"; "992"; "907"; "931";
                      "987"; "950"; "982"] in
    let obtenu = snd (List.nth (lister_numero_lignes_par_type ~types:[LeBus] ()) 0) in
    begin
      assert_equal "lister_numero_lignes_par_type@longueur_bus_correct" 
	           (List.length obtenu) (List.length lebus) ;
      assert_equal_list "lister_numero_lignes_par_type@contenu_bus _correct" lebus obtenu
    end;
    let obtenu = snd (List.nth (lister_numero_lignes_par_type ~types:[MetroBus] ()) 0) in
    begin
      assert_equal "lister_numero_lignes_par_type@longueur_metrobus_correct" 
	           (List.length obtenu) (List.length metrobus) ;
      assert_equal_list "lister_numero_lignes_par_type@contenu_metrobus _correct" metrobus obtenu;
      let obtenu = snd (List.nth (lister_numero_lignes_par_type ~types:[CoucheTard] ()) 0) in
      assert_equal "lister_numero_lignes_par_type@longueur_couchetard_correct" 
	           (List.length obtenu) (List.length couchetard) ;
      assert_equal_list "lister_numero_lignes_par_type@contenu_couchetard_correct" couchetard obtenu
    end;
    let obtenu = snd (List.nth (lister_numero_lignes_par_type ~types:[Express] ()) 0) in
    begin
      assert_equal "lister_numero_lignes_par_type@longueur_express_correct" 
	           (List.length obtenu) (List.length express) ;
      assert_equal_list "lister_numero_lignes_par_type@contenu_express_correct" express obtenu
    end;
    let obtenu = lister_numero_lignes_par_type ~types:[CoucheTard; Express] () in
    assert_equal "lister_numero_lignes_par_type@longueur_correct" 
	         (List.length obtenu) 2
  with 
  | Non_Implante exn -> print_endline exn
  | _ -> print_endline (String.uppercase "lister_numero_lignes_par_type@Test_non_complete");;


(* -- À IMPLANTER/COMPLÉTER (4 PTS) ---------------------------------------- *)
(* @Fonction      : trouver_service : ?date:int -> unit -> string list       *)
(* @Description   : trouve  les numéros des services associées à une date    *)
(* @Precondition  : la date doit exister dans les dates référées dans la 
                    table de hachage des services (si elle n'y existe pas, la
                    date sera éventuellement non valide)                     *)
(* @Postcondition : la liste retournée est correcte                          *)
let test2() =
  try
    let obtenu = trouver_service () ~date:(date_a_nbjours "20160227") in 
    let attendu = ["20161511multiint-0000010"] in
    begin
      assert_equal "trouver_service@longueur_correct1"
                   (List.length obtenu) (List.length attendu) ;
      assert_equal_list "trouver_service@contenu_correct1" obtenu attendu
    end;
    let obtenu = trouver_service () ~date:(date_a_nbjours "20160226") in 
    let attendu = ["20160013multiint-1111100"; "20160013multiint-0001100";
                   "20160013multiint-0000100"] in
    begin
      assert_equal "trouver_service@longueur_correct2"
                   (List.length obtenu) (List.length attendu) ;
      assert_equal_list "trouver_service@contenu_correct2" obtenu attendu;
      assert_throw_exception
      "trouver_service@date_invalide" 
      (fun () -> trouver_service () ~date:(date_a_nbjours "20150201"))
    end
  with 
  | Non_Implante exn -> print_endline exn
  | _ -> print_endline (String.uppercase "trouver_service@Test_non_complete");;
 
		
(* -- À IMPLANTER/COMPLÉTER (4 PTS) ---------------------------------------- *)
(* @Fonction      : trouver_voyages_par_date : 
                    ?date:int -> unit -> string list                         *)
(* @Description   : trouve les ids de tous les voyages du réseau pour une 
                    date donnée                                              *)
(* @Precondition  : la date doit exister dans les dates référées dans la 
                    table de hachage des services                            *)
(* @Postcondition : la liste retournée est correcte                          *)
let test3() =
  try
    let obtenu = trouver_voyages_par_date () ~date:(date_a_nbjours "20160212") in
    assert_equal "trouver_voyages_par_date@longueur_correct1" (List.length obtenu) 4173;
    let obtenu = trouver_voyages_par_date () ~date:(date_a_nbjours "20160228") in
    begin
      assert_equal "trouver_voyages_par_date@longueur_correct2" (List.length obtenu) 2290;
      assert_throw_exception "trouver_voyages_par_date@date_invalide" 
  	                     (fun () -> trouver_voyages_par_date () ~date:(date_a_nbjours "20150101"))
    end
  with 
  | Non_Implante exn -> print_endline exn
  | _ -> print_endline (String.uppercase "trouver_voyages_par_date@Test_non_complete");;
  

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
let test4() =
  try
    let pouliot = {latitude = 46.778826; longitude = -71.275169} in 
    let obtenu = trouver_stations_environnantes pouliot 0.5 in 
    let attendu = [(7011, 0.0698861856891728195); (1557, 0.0876054087325441738);
                   (7010, 0.208109720511417962); (1556, 0.215363282859233063);
                   (1558, 0.273676182718004424); (7012, 0.286002174044994451);
                   (7000, 0.295804909779705749); (7008, 0.316720069600276877);
                   (1515, 0.326099790093329234); (7009, 0.332129085400999446);
                   (1561, 0.386107824969858571); (1559, 0.389567528445788791);
                   (3172, 0.404794706115355785); (2190, 0.417925715146942323);
                   (1999, 0.420798609229271); (1542, 0.432811544563683);
                   (1501, 0.433175474264364313); (1554, 0.460023115218350487);
                   (1830, 0.466842318737974715); (2145, 0.492564651282658028)] in
    begin
      assert_equal
        "trouver_stations_environnantes@longueur_correct" (List.length obtenu)
        (List.length attendu);
      assert_equal_list "trouver_stations_environnantes@contenu_correct" obtenu
  	                attendu;
      assert_equal "trouver_stations_environnantes@contenu_en ordre" obtenu
  	           attendu;
      assert_throw_exception
        "trouver_stations_environnantes@rayon_invalide" 
        (fun () -> trouver_stations_environnantes pouliot (-5.)) ;
      assert_throw_exception
        "trouver_stations_environnantes@position_invalide" 
        (fun () -> trouver_stations_environnantes {latitude = -46.778826; longitude = -71.275169} 0.5)
    end
  with 
  | Non_Implante exn -> print_endline exn
  | _ -> print_endline (String.uppercase "trouver_stations_environnantes@Test_non_complete");;
	

(* -- À IMPLANTER/COMPLÉTER (8 PTS) ---------------------------------------- *)
(* @Fonction      : lister_lignes_passantes_station : int -> string list     *)
(* @Description   : Lister toutes les lignes passantes par une station.
	      la réponse ne doit pas dépendre d'une date particulière  *)
(* @Precondition  : la station existe                                        *)
(* @Postcondition : la liste doit être correcte même si l'ordre n'est pas 
                    important                                                *) 
let test5() =
  try
    let obtenu = lister_lignes_passantes_station 1515 in
    let attendu = ["380"; "801"; "800"; "377"; "358"; "355"; "350"; "338"; "337"; "336"; "330";
                   "295"; "87"; "915"; "16"; "13"; "384"; "374"; "372"; "315"; "294"; "93"; "382"; "381"]  in
    begin
      assert_equal "lister_lignes_passantes_station@longueur_correct1" (List.length obtenu)
  	           (List.length attendu);
      assert_equal_list "lister_lignes_passantes_station@contenu_correct1"  obtenu attendu
    end;
    let obtenu = lister_lignes_passantes_station 1473 in
    let attendu = ["95"; "94"; "380"; "79"; "377"; "358"; "355"; "350"; "338"; "337"; "336";
 	           "330"; "7"; "907"; "384"; "374"; "372"; "315"; "93"; "382"; "381"] in
    begin
      assert_equal "lister_lignes_passantes_station@longueur_correct1" (List.length obtenu)
  	           (List.length attendu);
      assert_equal_list "lister_lignes_passantes_station@contenu_correct1"  obtenu attendu;
      assert_throw_exception "lister_lignes_passantes_station@station_invalide" 
  	                     (fun () -> lister_lignes_passantes_station (-1))
    end
  with 
  | Non_Implante exn -> print_endline exn
  | _ -> print_endline (String.uppercase "lister_lignes_passantes_station@Test_non_complete");;
  

(* -- À IMPLANTER/COMPLÉTER (6 PTS) ---------------------------------------- *)
(* @Fonction      : lister_arrets_par_voyage : string -> int list            *)
(* @Description   : lister tous les arrêts se trouvant dans un voyage.
                    la liste est triée par le numéro de séquence de chaque
                    arrêt.                                                   *)
(* @Precondition  : le numero du voyage doit exister                         *)
(* @Postcondition : la liste est correcte                                    *)
let test6() =
  try
    let obtenu = lister_arrets_par_voyage "47330345-20161511multiint-0000010" in
    let attendu =   [2625; 1190; 1517; 1519; 2447; 1549; 1767; 1768; 1769; 1770; 1771; 1772;
                     1773; 1774; 1056; 1057; 1058; 1059; 1060; 1061; 1063; 1065; 1066; 1777;
                     1778; 1779; 1780; 1781; 1782; 1783; 1999; 1787; 1776; 1790; 1791; 1793;
                     1794; 1795; 1796; 1797; 1798; 1799; 1800; 1801; 1802; 1804; 1803; 1805;
                     1806; 3099; 1440; 1882; 1883; 1884; 1885; 2070] in
    begin
      assert_equal "lister_arrets_par_voyage@longueur_correct1" (List.length obtenu)
  	           (List.length attendu);
      assert_equal_list "lister_arrets_par_voyage@contenu_correct1"  obtenu attendu;
      assert_equal "lister_arrets_par_voyage@ordre_correct1"  obtenu attendu
    end;
    let obtenu = lister_arrets_par_voyage "47334083-20161611multiint-0000001"in
    let attendu = [3924; 2838; 2839; 2842; 2844; 2847; 2849; 2851; 2853; 2855; 2857; 2930;
                   3943; 2934; 2862; 2933; 2869; 2870; 2874; 5852; 1239; 1241; 1243; 1246;
                   1249; 1252; 1254; 1257; 1260; 1262; 1263; 1265; 1190; 1517; 1520; 1522;
                   1523; 1525; 1081; 1528; 1531; 1534; 1537; 1515; 1787; 1776; 1790; 1791;
                   2000; 2001; 2003; 2006; 1434; 2007; 4144; 3099; 1440; 2009] in
    begin
      assert_equal "lister_arrets_par_voyage@longueur_correct2" (List.length obtenu)
  	           (List.length attendu);
      assert_equal_list "lister_arrets_par_voyage@contenu_correct2"  obtenu attendu;
      assert_equal "lister_arrets_par_voyage@ordre_correct2"  obtenu attendu;
      assert_throw_exception "lister_arrets_par_voyage@station_invalide" 
  	                     (fun () -> lister_arrets_par_voyage "toto")
    end
  with 
  | Non_Implante exn -> print_endline exn
  | _ -> print_endline (String.uppercase "lister_arrets_par_voyage@Test_non_complete");;


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
let test7() =
  try
    let obtenu = trouver_horaire_ligne_a_la_station "800" 1515 ~date:(date_a_nbjours "20160212") 
                                                    ~heure:(heure_a_nbsecs "12:10:00") in
    let attendu = [
        "12:16:00"; "12:26:00"; "12:36:00"; "12:46:00"; "12:56:00"; "13:06:00";
        "13:15:00"; "13:25:00"; "13:35:00"; "13:45:00"; "13:55:00"; "14:05:00";
        "14:15:00"; "14:25:00"; "14:35:00"; "14:45:00"; "14:56:00"; "15:06:00";
        "15:16:00"; "15:26:00"; "15:37:00"; "15:48:00"; "15:58:00"; "16:08:00";
        "16:18:00"; "16:27:00"; "16:36:00"; "16:44:00"; "16:52:00"; "17:00:00";
        "17:08:00"; "17:16:00"; "17:24:00"; "17:30:00"; "17:38:00"; "17:46:00";
        "17:56:00"; "18:04:00"; "18:14:00"; "18:24:00"; "18:34:00"; "18:43:00";
        "18:53:00"; "19:03:00"; "19:17:00"; "19:32:00"; "19:48:00"; "20:02:00";
        "20:18:00"; "20:32:00"; "20:47:00"; "21:01:00"; "21:16:00"; "21:31:00";
        "21:46:00"; "22:01:00"; "22:16:00"; "22:31:00"; "22:46:00"; "23:01:00";
        "23:16:00"; "23:31:00"; "23:46:00"; "24:01:00"; "24:16:00"; "24:31:00";
        "24:46:00"; "25:01:00"; "25:16:00"] in
    begin
      assert_equal "trouver_horaire_ligne_a_la_station@longueur_correct1" (List.length obtenu)
  	           (List.length attendu);
      assert_equal_list "trouver_horaire_ligne_a_la_station@contenu_correct1" obtenu
  	                attendu;
      assert_equal "trouver_horaire_ligne_a_la_station@contenu_en ordre1" obtenu
  	           attendu
    end;
    let obtenu = trouver_horaire_ligne_a_la_station "800" 1515 ~date:(date_a_nbjours "20160226") 
                                                    ~heure:(heure_a_nbsecs "15:00:00") in
    let attendu = ["15:06:00"; "15:16:00"; "15:26:00"; "15:37:00"; "15:48:00"; "15:58:00";
                   "16:08:00"; "16:18:00"; "16:27:00"; "16:36:00"; "16:44:00"; "16:52:00";
                   "17:00:00"; "17:08:00"; "17:16:00"; "17:24:00"; "17:30:00"; "17:38:00";
                   "17:46:00"; "17:56:00"; "18:04:00"; "18:14:00"; "18:24:00"; "18:34:00";
                   "18:43:00"; "18:53:00"; "19:03:00"; "19:17:00"; "19:32:00"; "19:48:00";
                   "20:02:00"; "20:18:00"; "20:32:00"; "20:47:00"; "21:01:00"; "21:16:00";
                   "21:31:00"; "21:46:00"; "22:01:00"; "22:16:00"; "22:31:00"; "22:46:00";
                   "23:01:00"; "23:16:00"; "23:31:00"; "23:46:00"; "24:01:00"; "24:16:00";
                   "24:31:00"; "24:46:00"; "25:01:00"; "25:16:00"] in
    begin
      assert_equal "trouver_horaire_ligne_a_la_station@longueur_correct2" (List.length obtenu)
  	           (List.length attendu);
      assert_equal_list "trouver_horaire_ligne_a_la_station@contenu_correct2" obtenu
  	                attendu;
      assert_equal "trouver_horaire_ligne_a_la_station@contenu_en ordre2" obtenu
  	           attendu;	
      assert_throw_exception "trouver_horaire_ligne_a_la_station@date_invalide" 
  	                     (fun () -> trouver_horaire_ligne_a_la_station "800" 1515 ~date:(date_a_nbjours "20150201") 
                                                                           ~heure:(heure_a_nbsecs "12:10:00")) ;
      assert_throw_exception "trouver_horaire_ligne_a_la_station@ligne_invalide" 
  	                     (fun () -> trouver_horaire_ligne_a_la_station "806" 1515 ~date:(date_a_nbjours "20160212") 
                                                                           ~heure:(heure_a_nbsecs "12:10:00")) ;
      assert_throw_exception "trouver_horaire_ligne_a_la_station@heure_invalide" 
  	                     (fun () -> trouver_horaire_ligne_a_la_station "800" 1515 ~date:(date_a_nbjours "20160212") 
                                                                           ~heure:(-4)) ;
      assert_throw_exception "trouver_horaire_ligne_a_la_station@station_invalide" 
  	                     (fun () -> trouver_horaire_ligne_a_la_station "800" 0 ~date:(date_a_nbjours "20160212") 
                                                                           ~heure:(heure_a_nbsecs "12:10:00"))
    end
  with 
  | Non_Implante exn -> print_endline exn
  | _ -> print_endline (String.uppercase "trouver_horaire_ligne_a_la_station@Test_non_complete");;


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
let test8() =
  try
    let obtenu  = lister_stations_sur_itineraire_ligne "11" ~date:None in 
    let direction1_attendu = ("Place D'Youville / Vieux-QuÃ©bec (Est)",
                              [2070; 2071; 3998; 1905; 1906; 1907; 1908; 1909; 1911; 1807; 1808; 1809;
                               1810; 1811; 1812; 1813; 1814; 1815; 1816; 1817; 1818; 1820; 1441; 1823;
                               1824; 1826; 1828; 1830; 1831; 1832; 1833; 1834; 1835; 1836; 1837; 1838;
                               1839; 1840; 1841; 1073; 1074; 1075; 1076; 1077; 1078; 1844; 1845; 1846;
                               1847; 1848; 1849; 1850; 1851; 1852; 1853; 1854; 1855; 1856; 1271; 1272;
                               1274; 1275; 1276; 1134; 1124; 1259; 2625]) in
    let direction2_attendu = ("Pointe-de-Sainte-Foy (Ouest)",
                              [1271; 1272; 1274; 1275; 1276; 1134; 1124; 1259; 2625; 1190; 1270; 1762;
                               1763; 1764; 1765; 1766; 1767; 1768; 1769; 1770; 1771; 1772; 1773; 1774;
                               1056; 1057; 1058; 1059; 1060; 1061; 1063; 1065; 1066; 1777; 1778; 1779;
                               1780; 1781; 1782; 1783; 1999; 1787; 1776; 1790; 1791; 1793; 1794; 1795;
                               1796; 1797; 1798; 1799; 1800; 1801; 1802; 1804; 1803; 1805; 1806; 3099;
                               1440; 1882; 1883; 1884; 1885; 2070; 2071; 3998; 1905]) in
    let attendu = [ direction1_attendu; direction2_attendu ] in
    begin
      assert_equal "lister_stations_sur_itineraire_ligne@longueur_correct" (List.length obtenu)
  	           (List.length attendu);
      assert_true "lister_stations_sur_itineraire_ligne@direction1_valide" (fun () -> List.mem direction1_attendu obtenu);
      assert_true "lister_stations_sur_itineraire_ligne@direction2_valide" (fun () -> List.mem direction2_attendu obtenu);
      assert_throw_exception "lister_stations_sur_itineraire_ligne@ligne_invalide" 
  	                     (fun () -> lister_stations_sur_itineraire_ligne "807")
    end
  with 
  | Non_Implante exn -> print_endline exn
  | _ -> print_endline (String.uppercase "lister_stations_sur_itineraire_ligne@Test_non_complete");;
 

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
let test9() =
  try
    assert_true "ligne_passe_par_station@cas_vrai" 
                (fun () -> ligne_passe_par_station "800" 1807 ~date:(Some(date_a_nbjours "20160212")));
    assert_true "ligne_passe_par_station@cas_faux"
                (fun () -> not(ligne_passe_par_station "7" 1515 ~date:(Some(date_a_nbjours "20160226"))));
    assert_true "ligne_passe_par_station@casvrai"
                (fun () -> ligne_passe_par_station "380" 1515 ~date:(Some(date_a_nbjours "20160226")));
    assert_true "ligne_passe_par_station@casfaux"
                (fun () -> not(ligne_passe_par_station "380" 1515 ~date:(Some(date_a_nbjours "20160227"))));
    assert_throw_exception "ligne_passe_par_station@station_invalide" 
  	                   (fun () -> ligne_passe_par_station "800" 0) ;
    assert_throw_exception "ligne_passe_par_station@ligne_invalide" 
  	                   (fun () -> ligne_passe_par_station "808" 1807)
  with 
  | Non_Implante exn -> print_endline exn
  | _ -> print_endline (String.uppercase "ligne_passe_par_station@Test_non_complete");;
	

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
let test10() =
  try
    let obtenu = duree_du_prochain_voyage_partant "800" 1807 1561 ~date:(date_a_nbjours "20160212") 
  		                                  ~heure:(heure_a_nbsecs "12:10:00") in
    let attendu = 18 in
    begin
      assert_equal "duree_du_prochain_voyage_partant@duree_correcte" obtenu attendu;
      assert_throw_exception "duree_du_prochain_voyage_partant@date_invalide" 
  	                     (fun () -> duree_du_prochain_voyage_partant "800" 1807 1561 ~date:(date_a_nbjours "20150201") 
  		                                                         ~heure:(heure_a_nbsecs "12:10:00")) ;
      assert_throw_exception "duree_du_prochain_voyage_partant@ligne_invalide" 
  	                     (fun () -> duree_du_prochain_voyage_partant "807" 1807 1561 ~date:(date_a_nbjours "20160212") 
  		                                                         ~heure:(heure_a_nbsecs "12:10:00")) ;
      assert_throw_exception "duree_du_prochain_voyage_partant@heure_invalide" 
  	                     (fun () -> duree_du_prochain_voyage_partant "800" 1807 1561 ~date:(date_a_nbjours "20160212") 
  		                                                         ~heure:(-5)) ;
      assert_throw_exception "duree_du_prochain_voyage_partant@station1_invalide" 
  	                     (fun () -> duree_du_prochain_voyage_partant "800" 0 1561 ~date:(date_a_nbjours "20160212") 
  		                                                         ~heure:(heure_a_nbsecs "12:10:00")) ;
      assert_throw_exception "duree_du_prochain_voyage_partant@station2_invalide" 
  	                     (fun () -> duree_du_prochain_voyage_partant "800" 1807 0 ~date:(date_a_nbjours "20160212") 
  		                                                         ~heure:(heure_a_nbsecs "12:10:00")) ;
      assert_throw_exception "duree_du_prochain_voyage_partant@station1_non_passante" 
  	                     (fun () -> duree_du_prochain_voyage_partant "800" 4716 1561 ~date:(date_a_nbjours "20160212") 
  		                                                         ~heure:(heure_a_nbsecs "12:10:00")) ;
      assert_throw_exception "duree_du_prochain_voyage_partant@station2_non_passante" 
  	                     (fun () -> duree_du_prochain_voyage_partant "800" 1807 4716 ~date:(date_a_nbjours "20160212") 
  		                                                         ~heure:(heure_a_nbsecs "12:10:00")) ;
      assert_throw_exception "duree_du_prochain_voyage_partant@pas_ditineraire_passant" 
  	                     (fun () -> duree_du_prochain_voyage_partant "800" 1515 1561 ~date:(date_a_nbjours "20160212") 
  		                                                         ~heure:(heure_a_nbsecs "12:10:00"))
    end
  with 
  | Non_Implante exn -> print_endline exn
  | _ -> print_endline (String.uppercase "duree_du_prochain_voyage_partant@Test_non_complete");;


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
let test11() =
  try
    let obtenu = duree_attente_prochain_arret_ligne_a_la_station "801" 1515 ~date:(date_a_nbjours "20160212") 
  		                                                 ~heure:(heure_a_nbsecs "12:12:00") in
    let attendu = 9 in
    begin
      assert_equal "duree_attente_prochain_arret_ligne_a_la_station@sortie_correcte" obtenu attendu;
      assert_throw_exception "duree_attente_prochain_arret_ligne_a_la_station@date_invalide" 
  	                     (fun () -> duree_attente_prochain_arret_ligne_a_la_station "801" 1515 ~date:(date_a_nbjours "20150201") 
  		                                                                        ~heure:(heure_a_nbsecs "12:12:00")) ;
      assert_throw_exception "duree_attente_prochain_arret_ligne_a_la_station@ligne_invalide" 
  	                     (fun () -> duree_attente_prochain_arret_ligne_a_la_station "808" 1515 ~date:(date_a_nbjours "20160212") 
  		                                                                        ~heure:(heure_a_nbsecs "12:12:00")) ;
      assert_throw_exception "duree_attente_prochain_arret_ligne_a_la_station@heure_invalide" 
  	                     (fun () -> duree_attente_prochain_arret_ligne_a_la_station "801" 1515 ~date:(date_a_nbjours "20160212") 
  		                                                                        ~heure:(-4)) ;
      assert_throw_exception "duree_attente_prochain_arret_ligne_a_la_station@station_invalide" 
  	                     (fun () -> duree_attente_prochain_arret_ligne_a_la_station "801" 0 ~date:(date_a_nbjours "20160212") 
  		                                                                        ~heure:(heure_a_nbsecs "12:12:00")) ;
      assert_throw_exception "duree_attente_prochain_arret_ligne_a_la_station@plus_de_passage" 
  	                     (fun () -> duree_attente_prochain_arret_ligne_a_la_station "11" 1807 ~date:(date_a_nbjours "20160212") 
  		                                                                        ~heure:(heure_a_nbsecs "25:59:00"))
    end
  with 
  | Non_Implante exn -> print_endline exn
  | _ -> print_endline (String.uppercase "duree_attente_prochain_arret_ligne_a_la_station@Test_non_complete");;


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
let test12() =
  try
    let obtenu = ligne_arrive_le_plus_tot 1807 1561 ~date:(date_a_nbjours "20160212") 
  		                          ~heure:(heure_a_nbsecs "12:12:00") in
    let attendu = ("801", 18) in
    begin
      assert_equal "ligne_arrive_le_plus_tot@sortie_correcte" obtenu attendu;
      assert_throw_exception "ligne_arrive_le_plus_tot@date_invalide" 
  	                     (fun () -> ligne_arrive_le_plus_tot 1807 1515 ~date:(date_a_nbjours "20150201") 
  		                                                 ~heure:(heure_a_nbsecs "12:12:00")) ;
      assert_throw_exception "ligne_arrive_le_plus_tot@station1_invalide" 
  	                     (fun () -> ligne_arrive_le_plus_tot 0 1515 ~date:(date_a_nbjours "20160212") 
  		                                                 ~heure:(heure_a_nbsecs "12:12:00")) ;
      assert_throw_exception "ligne_arrive_le_plus_tot@station2_invalide" 
  	                     (fun () -> ligne_arrive_le_plus_tot 1807 0 ~date:(date_a_nbjours "20160212") 
  		                                                 ~heure:(heure_a_nbsecs "12:12:00")) ;
      assert_throw_exception "ligne_arrive_le_plus_tot@heure_invalide" 
  	                     (fun () -> ligne_arrive_le_plus_tot 1807 1515 ~date:(date_a_nbjours "20160212") 
  		                                                 ~heure:(-4));
      assert_throw_exception "ligne_arrive_le_plus_tot@pas_ditineraire" 
  	                     (fun () -> ligne_arrive_le_plus_tot 1807 5268 ~date:(date_a_nbjours "20160212") 
  		                                                 ~heure:(heure_a_nbsecs "12:12:00"))
    end
  with 
  | Non_Implante exn -> print_endline exn
  | _ -> print_endline (String.uppercase "ligne_arrive_le_plus_tot@Test_non_complete");;
 

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
let test13() =
  try
    let obtenu = ligne_met_le_moins_temps 1807 1561 ~date:(date_a_nbjours "20160212") 
  		                          ~heure:(heure_a_nbsecs "12:12:00") in
    let attendu = ("800", 18) in
    begin
      assert_equal "ligne_met_le_moins_temps@sortie_correcte" obtenu attendu;
      assert_throw_exception "ligne_met_le_moins_temps@date_invalide" 
  	                     (fun () -> ligne_met_le_moins_temps 1807 1515 ~date:(date_a_nbjours "20150201") 
  		                                                 ~heure:(heure_a_nbsecs "12:12:00")) ;
      assert_throw_exception "ligne_met_le_moins_temps@station1_invalide" 
  	                     (fun () -> ligne_met_le_moins_temps 0 1515 ~date:(date_a_nbjours "20160212") 
  		                                                 ~heure:(heure_a_nbsecs "12:12:00")) ;
      assert_throw_exception "ligne_met_le_moins_temps@station2_invalide" 
  	                     (fun () -> ligne_met_le_moins_temps 1807 0 ~date:(date_a_nbjours "20160212") 
  		                                                 ~heure:(heure_a_nbsecs "12:12:00")) ;
      assert_throw_exception "ligne_met_le_moins_temps@heure_invalide" 
  	                     (fun () -> ligne_met_le_moins_temps 1807 1515 ~date:(date_a_nbjours "20160212") 
  		                                                 ~heure:(-4));
      assert_throw_exception "ligne_met_le_moins_temps@pas_ditineraire" 
  	                     (fun () -> ligne_met_le_moins_temps 1807 5268 ~date:(date_a_nbjours "20160212") 
  		                                                 ~heure:(heure_a_nbsecs "12:12:00"))
    end
  with 
  | Non_Implante exn -> print_endline exn
  | _ -> print_endline (String.uppercase "ligne_met_le_moins_temps@Test_non_complete");;


(* --------------------------------------------------------------------------- *)
(* -- TESTE TOUT ------------------------------------------------------------- *)
(* --------------------------------------------------------------------------- *)

let test() =
  let all = [ test1; test2; test3; test4; test5; test6; test7; test8; test9; 
              test10; test11; test12; test13
            ]
  in
  begin
    print_endline "\n-------";
    print_endline "D-TESTS";
    print_endline "-------\n";
    List.iter 
      (fun t -> let (_,d) = timeRun t () in Printf.printf "*** DUREE TEST: %.1f sec\n\n\n" d) 
      all;
    print_endline "-------";
    print_endline "F-TESTS";
    print_endline "-------\n";
  end;;

let test'() =
  let (_,d) = timeRun (charger_tout ~rep:"/home/etudiant/workspace/tp1/rtc_data/") () in
  begin
    Printf.printf "*** DUREE CHARGEMENT: %.1f sec\n" d;
    test()
  end;;
  


