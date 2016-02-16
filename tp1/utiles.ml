(* --------------------------------------------------------------------------- *)
(* ----------------------- TP1 - IFT-3000 - Hiver 2016 ----------------------- *)
(* --------------------------------------------------------------------------- *)

(* --------------------------------------------------------------------------- *)
(* -- FONCTIONS ET MODULES UTILES -------------------------------------------- *)
(* --------------------------------------------------------------------------- *)

#load "str.cma";;
#load "unix.cma";;

(* Type exception pour la gestion des entrées/paramètres des fonctions 
     Utilisé dans tout le TP: «raise (Erreur "message")» pour soulever une 
     exception
 *)
exception Erreur of string;;	                
exception Non_Implante of string;;

module Utiles = struct

  module U = Unix
  module S = String
  module L = List
               
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      :  timeRun : ('a -> 'b) -> 'a -> 'b * float                *)
  (* @Description   :  Cette fonction permettant d'estimer la durée d'exécution   
		       d'une fonction passée en argument; elle prend en argument
                       la fonction à évaluer et un argument, et retourne le
                       résultat de cette application ainsi que la durée de cette
                       application                                             *)                      
  let timeRun f x =
    let	time1 = U.gettimeofday() in
    let r = f x in
    let time2 = U.gettimeofday() in
    (r,time2 -. time1)


  (* -- Simplification de chaines -------------------------------------------- *)
  (* @Fonction      :  decouper_chaine : string -> string -> string list       *)
  (* @Description   :  Cette fonction découpe une chaine selon un séparateur 
                       donné
			  # decouper_chaine "chaine separateur" " ";;
                          - : string list = ["chaine"; "separateur"]           *)
  let decouper_chaine chaine separateur = 
    Str.split (Str.regexp separateur) chaine

  (* ------------------------------------------------------------------------- *)
  (* @Fonction      :  enlever_guillemets : string -> string
	 *)
  (* @Description   :  Cette fonction enlève les guillemets au debut et à la fin 
		       d'une string s'il y en a.                               *)
  let enlever_guillemets s = 
    let l = S.length s in 
    if l <> 0 && s.[0] = '"' && s.[l-1] = '"' 
    then S.sub s 1 (l-2) 
    else s

  (* -- Simplification de listes --------------------------------------------- *)  
  (* @Fonction      :  uniques : 'a list -> 'a list
	 *)
  (* @Description   :  Elimine les doublons dans une liste. Ex:
                          # uniques [1;2;1;1;2;3;4;5;5;6;7;8];;
                          - : int list = [1; 2; 3; 4; 5; 6; 7; 8]              *)
  let uniques liste =
    L.rev
      (L.fold_left (fun acc e -> if L.mem e acc then acc else e::acc)
                      [] liste)

  (* ------------------------------------------------------------------------- *)
  (* @Fonction      :  top_liste : ('a -> 'a -> 'a) -> 'a list -> 'a
	 *)
  (* @Description   :  Cette fonction permet de retourner le min ou le max 
                       d'une liste au reagard de la fonction de comparaison 
                       spécifiée. Elle est générique et marche donc avec on 
                       peut même trouver le min d'une liste de n'importe quel 
                       type d'objets. 
                       Ex: (les fonctions min et max sont prédéfinies)

		       1- mininimum d'une liste
                       # top_liste min [2;4;1;5;3];;
                       - : int = 1

                       2- maximum d'une liste
                       # top_liste max [2;4;1;5;3];;
                       - : int = 5
		       
                       3- plus petite liste (d'une liste de listes)
                       # top_liste 
                             (fun x y -> if (List.length x)< (List.length y) 
                                         then x else y) 
                             [[20;2;8;0;1];[1;2];[3;6;0;1;5;9]];;
                       - : int list = [1; 2]  
                       
                       Rq: le dernier exemple aurait pu être écrit comme suit:
                           # top_liste min [[20;2;8;0;1];[1;2];[3;6;0;1;5;9]];;*)
  let top_liste comp liste = match liste with
    | [] -> raise (Failure "Liste vide")
    | [e] -> e
    | e::r -> L.fold_left comp e r
             

  (* ------------------------------------------------------------------------- *)
  (* @Fonction      :  ( ++ ) : 'a list -> 'a list -> 'a list                  *)
  (* @Description   :  Intersection de deux ensembles. Par exemple,
                       # [3;1;5;2;4] ++ [20;2;8;0;1];;
                       - : int list = [1; 2]                                   *)
  let (++) liste liste' =
    L.rev
      (L.fold_left (fun acc e -> if L.mem e liste' then e::acc else acc)
                      [] liste)
                   
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      :  cles : ('a, 'b) Hashtbl.t -> 'a list                    *)
  (* @Description   :  Cette fonction retourne toutes les clés d'une table de
                       hachage                                                 *)
  let cles th =   
    Hashtbl.fold (fun k _ acc -> if L.mem k acc then acc else k::acc) th []

end;;
	        
(* -- Dates et Heures -------------------------------------------------------- *)
module Date = struct

  open Unix
         
  module S = String
  module L = List
     
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      :  date_a_nbjours : string -> int                          *)
  (* @Description   :  Cette fonction donne le nombre de jours depuis 1970-01-01 
                       pour la date en parametre. Cette dernière doit être au 
                       format "YYYYMMDD"                                       *)    
  let date_a_nbjours date =
    let shuffle_year_month year month =
      let month = month - 2 in
      if month <= 0 then (year - 1, month + 12) else (year, month)
    in
    let year = int_of_string(S.sub date 0 4) in
    let month = int_of_string(S.sub date 4 2) in
    let day = int_of_string(S.sub date 6 2) in
    let year, month = shuffle_year_month year month in
    let days = year / 4 - year / 100 + year / 400 + 367 * month / 12 + day in
    days + 365 * year - 719499 

  (* ------------------------------------------------------------------------- *)
  (* @Fonction      :  date_actuelle : unit -> int                             *)
  (* @Description   :  Cette fonction donne le nombre de jours depuis 
                       1970-01-01                                              *)  	
  let date_actuelle () = 
    let shuffle_year_month year month =
      let month = month - 2 in
      if month <= 0 then (year - 1, month + 12) else (year, month)
    in
    let t = Unix.localtime (Unix.time ()) in 
    let year, month, day = t.tm_year +1900, t.tm_mon +1, t.tm_mday in
    let year, month = shuffle_year_month year month in
    let days = year / 4 - year / 100 + year / 400 + 367 * month / 12 + day in
    days + 365 * year - 719499 
		
  (* @Fonction      :  heure_a_nbsecs : string -> int                          *)
  (* @Description   :  Cette fonction donne le nombre de secondes depuis 
		       00:00:00 pour l'heure en parametre, qui doit être au
		       format  "HH:MM:SS"                                      *)  
  let heure_a_nbsecs heure =
    let l = L.map int_of_string (Utiles.decouper_chaine heure ":") in 
    let heure = L.nth l 0 in 
    let min = L.nth l 1 in 
    let sec = L.nth l 2 in 
    let mins = (60 * heure) + min in (60 * mins) + sec
		
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      :  secs_a_heure : int -> string                            *)
  (* @Description   :  Cette fonction fait l'inverse de ce que celle qui est 
                       ci-dessus. C-à-d retourne au format "HH:MM:SS" un nombre 
                       de secondes depuis minuit                               *)    
  let secs_a_heure secs = 
    (* Cette fonction fait l'inverse de ce que celle qui est ci-dessus fait    *)
    let soi i = if i < 10 then "0"^(string_of_int i) else (string_of_int i) in
    let heure = soi (secs / 3600) in 
    let min = soi ((secs mod 3600) /60)  in 
    let sec = soi (secs mod 60) in
    heure ^ ":" ^ min ^ ":" ^ sec
	
  (* ------------------------------------------------------------------------- *)
  (* @Fonction      :  heure_actuelle : unit -> int                            *)
  (* @Description   :  Cette fonction donne le nombre de secondes depuis 
                       00:00:00                                                *)
  let heure_actuelle () = 
  	let t = Unix.localtime (Unix.time ()) in 
  	(60 * (60 * t.tm_hour + t.tm_min)) + t.tm_sec
  	         
end;;
  
