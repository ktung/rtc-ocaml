(* duree_du_prochain_voyage_partant *)
# duree_du_prochain_voyage_partant "800" station_desjardins station_desjardins';;
Exception: Erreur "Pas de tel prochain voyage pour la ligne!".

           
(* duree_attente_prochain_arret_ligne_a_la_station *)
# secs_a_heure (heure_actuelle());;
- : string = "15:47:46"

# duree_attente_prochain_arret_ligne_a_la_station "11" 1815;;
- : int = 22

# duree_attente_prochain_arret_ligne_a_la_station ~heure:(heure_a_nbsecs "23:55:00") "11" 1815;;
Exception: Erreur "Pas de prochain arrêt pour cette ligne-station!".

# trouver_horaire_ligne_a_la_station "11" 1815;;
- : string list =
["16:09:50"; "16:39:50"; "16:52:50"; "17:09:50"; "17:21:02"; "17:36:02";
 "18:06:02"; "18:36:02"; "19:06:02"; "19:35:02"; "20:03:02"; "20:32:02";
 "21:02:02"; "21:32:02"; "22:01:02"; "22:31:02"; "23:01:02"; "23:31:02"]

  
(* ligne_arrive_le_plus_tot *)
# ligne_arrive_le_plus_tot station_desjardins 5268;;
Exception: Erreur "Pas de prochain tel itinéraire!".

           
(* ligne_met_le_moins_temps *)
# ligne_met_le_moins_temps station_desjardins 5268;;
Exception: Erreur "Pas de prochain tel itinéraire!".
