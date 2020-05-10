//%attributes = {"invisible":true}
  // Méthode : Sc_Dial_Consultation
  // Date et heure : 24/03/20, 23:01:11
  // Modifié le : 19/04/20, 12:57:52

C_LONGINT:C283($Col;$Ligne;$rech;$i;$LigneMenu;$g;$h;$d;$b;$triOrdre;$valTermo)
C_BOOLEAN:C305($motCles)
C_TEXT:C284($nomObjet;$DossierReferent;$chemin;$nomComplet;$Texte;$Saisie;$Dossier_Sup;$UUID_Client;$UUID_Groupe;\
$chemin;$RefUUID;$RefMenu;$RefMenuClient)
C_POINTER:C301($objet;$varCol;$Ptr_Chemin;$Ptr_Chercher)
C_OBJECT:C1216($entPref;$entBiblio;$entChemin;$entSelect;$objeImage;$objeImage;$entMotCle;$entClient;\
$EntDossierBiblio;$reglages;$entSelection;$entDossierEnfant;$emp;$entGroupe;$empClient)
C_COLLECTION:C1488($collecClient)
ARRAY TEXT:C222($t_nomCol;0)
ARRAY TEXT:C222($t_nomEntete;0)
ARRAY POINTER:C280($t_varCol;0)
ARRAY POINTER:C280($t_varEntete;0)
ARRAY BOOLEAN:C223($t_colVisible;0)
ARRAY POINTER:C280($t_style;0)
ARRAY TEXT:C222($PU_Action;0)
ARRAY TEXT:C222($t_Client_Nom;0)
ARRAY TEXT:C222($t_Client_UUID;0)

If (Count parameters:C259>=1)
	$objet:=$1
End if 
If (Is nil pointer:C315($objet))
	$nomObjet:=OBJECT Get name:C1087(Objet courant:K67:2)
End if 

Case of 
	: ($objet=(->[Bibliotheque:1]))  // Méthode formulaire [Bibliotheque];"VisuBiblio"
		Case of 
			: (Form event code:C388=Sur chargement:K2:1)
				  // Recherche du dernier Client sélectionné enregistré dans les Pref
				$entPref:=ds:C1482.Preference.all().first()
				If (GEN_UuidValide ($entPref.UUID_DernierClientConsulter))
					$UUID_Client:=$entPref.UUID_DernierClientConsulter
				End if 
				If (GEN_UuidValide ($entPref.UUID_DernierGroupeConsulter))
					$UUID_Groupe:=$entPref.UUID_DernierGroupeConsulter
				End if 
				$motCles:=$entPref.Reglages.motscles
				(OBJECT Get pointer:C1124(Objet nommé:K67:5;"Btn_MotsCles")->):=(Num:C11($motCles))
				If ($motCles)
					OBJECT SET VISIBLE:C603(*;"lb_ListeMotsCles";True:C214)
					LISTBOX SET COLUMN WIDTH:C833(*;"Col_lb_bibio_Nom";345)
					OBJECT MOVE:C664(*;"lb_bibiothequeDossier";0;210;150;-210)
					OBJECT MOVE:C664(*;"thermoLargeurCol";150;0)
					OBJECT MOVE:C664(*;"lb_Liste_Image";150;0;-150;0)
				Else 
					Form:C1466.MotsCles:=New object:C1471
					OBJECT SET VISIBLE:C603(*;"lb_ListeMotsCles";False:C215)
				End if 
				If ($entPref.Reglages.tailleImage>0)
					(OBJECT Get pointer:C1124(Objet nommé:K67:5;"thermoLargeurCol")->):=$entPref.Reglages.tailleImage
				Else 
					(OBJECT Get pointer:C1124(Objet nommé:K67:5;"thermoLargeurCol")->):=20
				End if 
				(OBJECT Get pointer:C1124(Objet nommé:K67:5;"cc_Tri1")->):=1
				If (GEN_UuidValide ($UUID_Client)) | (GEN_UuidValide ($UUID_Groupe))
					  // Recherche du client
					If (GEN_UuidValide ($UUID_Client))
						$entClient:=ds:C1482.Client.query("UUID = :1";$UUID_Client).first()
						(OBJECT Get pointer:C1124(Objet nommé:K67:5;"vUUID_Client")->):=$UUID_Client
						(OBJECT Get pointer:C1124(Objet nommé:K67:5;"vClient")->):=$entClient.Nom
					Else 
						$entGroupe:=ds:C1482.Groupe.query("UUID = :1";$UUID_Groupe).first()
						$entClient:=ds:C1482.Client.query("UUID_Groupe = :1";$UUID_Groupe).orderBy("Nom")
						(OBJECT Get pointer:C1124(Objet nommé:K67:5;"vUUID_Groupe")->):=$UUID_Groupe
						(OBJECT Get pointer:C1124(Objet nommé:K67:5;"vClient")->):=$entGroupe.Nom
					End if 
				Else 
					entBiblio:=New object:C1471
					$entChemin:=New object:C1471
					Form:C1466.docs:=$entBiblio
				End if 
				Sc_Dial_Consultation (->[Bibliotheque:1]UUID:1;"Chargement")
				Form:C1466.elmtCourantDoc:=New object:C1471
				Form:C1466.posCourantDoc:=New object:C1471
				Form:C1466.SelectionDoc:=New object:C1471
				Form:C1466.elmtCourantMotsCles:=New object:C1471
				Form:C1466.posCourantMotsCles:=New object:C1471
				Form:C1466.SelectionMotsCles:=New object:C1471
				SET TIMER:C645(-1)
				
				
			: (Form event code:C388=Sur redimensionnement:K2:27)
				SET TIMER:C645(10)
				
			: (Form event code:C388=Sur minuteur:K2:25)
				SET TIMER:C645(0)
				If ((OBJECT Get pointer:C1124(Objet nommé:K67:5;"vClient")->)#"")
					Affichage_Vignettes (entBiblio)
				End if 
				
		End case 
		
		
	: ($nomObjet="Btn_PopMenuClient")  // Choix des Groupes/clients
		$RefMenu:=Create menu:C408
		$entGroupe:=ds:C1482.Groupe.all().orderBy("Type, Nom")
		For each ($emp;$entGroupe)
			$entClient:=ds:C1482.Client.query("UUID_Groupe = :1";$emp.UUID).orderBy("Nom")
			If ($entClient.length>0)
				$RefMenuClient:=Create menu:C408
				APPEND MENU ITEM:C411($RefMenuClient;$emp.Nom)
				SET MENU ITEM PARAMETER:C1004($RefMenuClient;-1;$emp.UUID)
				APPEND MENU ITEM:C411($RefMenuClient;"-")
				For each ($empClient;$entClient)
					APPEND MENU ITEM:C411($RefMenuClient;$empClient.Nom)
					SET MENU ITEM PARAMETER:C1004($RefMenuClient;-1;$empClient.UUID)
				End for each 
				APPEND MENU ITEM:C411($RefMenu;$emp.Nom;$RefMenuClient)
			End if 
		End for each 
		  // Liste des clients non rattaché à un groupe
		$entClient:=ds:C1482.Client.all().orderBy("Nom")
		If ($entClient.length>0)
			$Ligne:=0
			For each ($empClient;$entClient)
				If (Not:C34(GEN_UuidValide ($empClient.UUID_Groupe)))
					If ($Ligne=0)
						APPEND MENU ITEM:C411($RefMenu;"-")
						$Ligne:=1
					End if 
					APPEND MENU ITEM:C411($RefMenu;$empClient.Nom)
					SET MENU ITEM PARAMETER:C1004($RefMenu;-1;$empClient.UUID)
				End if 
			End for each 
		End if 
		$RefUUID:=Dynamic pop up menu:C1006($RefMenu)
		If ($RefUUID#"")
			(OBJECT Get pointer:C1124(Objet nommé:K67:5;"Chemin_courant")->):=""
			$entClient:=ds:C1482.Client.query("UUID = :1";$RefUUID).orderBy("Nom")
			If ($entClient.length>0)
				$entClient:=$entClient.first()
				(OBJECT Get pointer:C1124(Objet nommé:K67:5;"vClient")->):=$entClient.Nom
				(OBJECT Get pointer:C1124(Objet nommé:K67:5;"vUUID_Client")->):=$RefUUID
				(OBJECT Get pointer:C1124(Objet nommé:K67:5;"vUUID_Groupe")->):=""
			Else 
				$entGroupe:=ds:C1482.Groupe.query("UUID = :1";$RefUUID).orderBy("Nom").first()
				$entClient:=ds:C1482.Client.query("UUID_Groupe = :1";$RefUUID).orderBy("Nom")
				(OBJECT Get pointer:C1124(Objet nommé:K67:5;"vClient")->):=$entGroupe.Nom
				(OBJECT Get pointer:C1124(Objet nommé:K67:5;"vUUID_Client")->):=""
				(OBJECT Get pointer:C1124(Objet nommé:K67:5;"vUUID_Groupe")->):=$RefUUID
			End if 
			Sc_Dial_Consultation (->[Bibliotheque:1]UUID:1;"PopUp_Client")
		End if 
		
		
	: ($nomObjet="Btn_PopMenuClient1")  // Choix des clients
		  // Recherched des Clients ayant un dossier de documents
		$entClient:=ds:C1482.Client.query("Chemin_Dossier # :1";"").orderBy("Nom")
		$collecClient:=New collection:C1472
		$collecClient:=$entClient.toCollection()
		If ($collecClient.length>0)
			COLLECTION TO ARRAY:C1562($collecClient;$t_Client_Nom;"Nom";$t_Client_UUID;"UUID")
		End if 
		INSERT IN ARRAY:C227($t_Client_Nom;1)
		$t_Client_Nom{1}:="Tous les clients"
		INSERT IN ARRAY:C227($t_Client_UUID;1)
		If ($collecClient.length>0)
			INSERT IN ARRAY:C227($t_Client_Nom;2)
			$t_Client_Nom{2}:="-"
			INSERT IN ARRAY:C227($t_Client_UUID;2)
		End if 
		$Texte:=""
		For ($i;1;Size of array:C274($t_Client_Nom))
			$Texte:=$Texte+$t_Client_Nom{$i}
			If ($i<Size of array:C274($t_Client_Nom))
				$Texte:=$Texte+";"
			End if 
		End for 
		$LigneMenu:=Pop up menu:C542($Texte)
		If ($LigneMenu>0)
			(OBJECT Get pointer:C1124(Objet nommé:K67:5;"Chemin_courant")->):=""
			(OBJECT Get pointer:C1124(Objet nommé:K67:5;"vClient")->):=$t_Client_Nom{$LigneMenu}
			(OBJECT Get pointer:C1124(Objet nommé:K67:5;"vUUID_Client")->):=$t_Client_UUID{$LigneMenu}
			Sc_Dial_Consultation (->[Bibliotheque:1]UUID:1;"PopUp_Client")
		End if 
		
		
	: ($objet=(->[Bibliotheque:1]UUID:1))  // Recherche 
		  // $2 = D'ou on vient
		$UUID_Client:=OBJECT Get pointer:C1124(Objet nommé:K67:5;"vUUID_Client")->
		$UUID_Groupe:=OBJECT Get pointer:C1124(Objet nommé:K67:5;"vUUID_Groupe")->
		$motCles:=((OBJECT Get pointer:C1124(Objet nommé:K67:5;"Btn_MotsCles")->)=1)
		$Ptr_Chemin:=OBJECT Get pointer:C1124(Objet nommé:K67:5;"Chemin_courant")
		$Ptr_Chercher:=OBJECT Get pointer:C1124(Objet nommé:K67:5;"chercherChaine")
		$triOrdre:=(Num:C11((OBJECT Get pointer:C1124(Objet nommé:K67:5;"cc_Tri1")->)=1))+(Num:C11((OBJECT Get pointer:C1124(Objet nommé:K67:5;"cc_Tri2")->)=1)*2)+(Num:C11((OBJECT Get pointer:C1124(Objet nommé:K67:5;"cc_Tri3")->)=1)*3)+(Num:C11((OBJECT Get pointer:C1124(Objet nommé:K67:5;"cc_Tri4")->)=1)*4)
		Case of 
			: ($2="Chargement") | ($2="PopUp_Client")
				  // Choix du client --> que les dossier et pas d'affichage des fichiers biblio
				$Ptr_Chercher->:=""
				Case of 
					: ($UUID_Client#"")
						entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & UUID_Client = :2";0;$UUID_Client)  //.orderBy("Path_, DossierFichier")
						
					: ($UUID_Groupe#"")
						entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & Lien_client.UUID_Groupe = :2";0;$UUID_Groupe)  //.orderBy("Path_, DossierFichier")
						
					Else 
						entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & DossierFichier = :2";0;True:C214)  //.orderBy("Path_, DossierFichier")
						
				End case 
				entDossierBiblio:=entBiblio.query("DossierFichier = :1";True:C214).orderBy("Path_")
				Form:C1466.docs:=entBiblio.query("DossierFichier = :1 & PathParent = :2";True:C214;"").orderBy("Path_")
				entBiblio:=entBiblio.query("PathParent = :1";"")
				  //$entChemin:=entBiblio.first()
				  //(OBJET Lire pointeur(Objet nommé;"Chemin_courant")->):=$entChemin.PathParent
				If ($motCles)
					Sc_Dial_Consultation (->[Bibliotheque:1]UUID:1;"Case_MotCles")
				End if 
				If ($2="PopUp_Client")
					Affichage_Vignettes (entBiblio)
				End if 
				
			: ($2="Bouton_Home")
				$Ptr_Chercher->:=""
				If ($motCles)
					Sc_Dial_Consultation (->[Bibliotheque:1]UUID:1;"Case_MotCles")
				End if 
				Case of 
					: ($UUID_Client#"")
						entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & PathParent = :2 & UUID_Client = :3";0;"";$UUID_Client)  //.orderBy("Path_, DossierFichier")
						
					: ($UUID_Groupe#"")
						entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & PathParent = :2 & Lien_client.UUID_Groupe = :3";0;"";$UUID_Groupe)  //.orderBy("Path_, DossierFichier")
						
					Else 
						entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & PathParent = :2";0;"")  //.orderBy("Path_, DossierFichier")
						
				End case 
				(OBJECT Get pointer:C1124(Objet nommé:K67:5;"Chemin_courant")->):=""
				entBiblio:=entBiblio.query("PathParent = :1";"")
				  //$EntDossierBiblio:=entBiblio.query("DossierFichier = :1";Vrai).orderBy("Path_")
				  //Form.docs:=$EntDossierBiblio
				Affichage_Vignettes (entBiblio)
				
			: ($2="Bouton_Retour")
				$Ptr_Chercher->:=""
				If ($motCles)
					Sc_Dial_Consultation (->[Bibliotheque:1]UUID:1;"Case_MotCles")
				End if 
				$entSelect:=Form:C1466.elmtCourantDoc
				$Dossier_Sup:=GEN_DOC_DossierSuperieur ($Ptr_Chemin->)
				$Ptr_Chemin->:=$Dossier_Sup
				Case of 
					: ($UUID_Client#"")
						entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & PathParent = :2 & UUID_Client = :3";0;$Dossier_Sup;$UUID_Client)  //.orderBy("Path_, DossierFichier")
						
					: ($UUID_Groupe#"")
						entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & PathParent = :2 & Lien_client.UUID_Groupe = :3";0;$Dossier_Sup;$UUID_Groupe)  //.orderBy("Path_, DossierFichier")
						
					Else 
						entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & PathParent = :2";0;$Dossier_Sup)  //.orderBy("Path_, DossierFichier")
						
				End case 
				  //$EntDossierBiblio:=entBiblio.query("DossierFichier = :1";Vrai).orderBy("Path_")
				  //Form.docs:=$EntDossierBiblio
				Affichage_Vignettes (entBiblio)
				
			: ($2="Case_MotCles")
				$entMotCle:=ds:C1482.Mot_Clef.all().orderBy("Libelle")
				Case of 
					: ($UUID_Client#"")
						$entMotCle:=$entMotCle.query("Retour_motclef.Lien_bliotheque.UUID_Client = :1";$UUID_Client).orderBy("Libelle")
						
					: ($UUID_Groupe#"")
						$entMotCle:=$entMotCle.query("Retour_motclef.Lien_bliotheque.Lien_client.UUID_Groupe = :1";$UUID_Groupe).orderBy("Libelle")
						
				End case 
				Form:C1466.MotsCles:=$entMotCle
				
			: ($2="Chercher")
				$Saisie:=$3
				If (Count parameters:C259<4)
					If ($Saisie="")
						$Saisie:="@"
					Else 
						$Saisie:="@"+$Saisie+"@"
					End if 
				End if 
				If ($motCles)  // Recherche sur les mots clés
					If (Count parameters:C259<4)
						Case of 
							: ($UUID_Client#"")
								$entMotCle:=ds:C1482.Mot_Clef.query("Libelle = :1 & Retour_motclef.Lien_bliotheque.UUID_Client = :2";$Saisie;$UUID_Client).orderBy("Libelle")
								
							: ($UUID_Groupe#"")
								$entMotCle:=ds:C1482.Mot_Clef.query("Libelle = :1 & Retour_motclef.Lien_bliotheque.Lien_client.UUID_Groupe = :2";$Saisie;$UUID_Groupe).orderBy("Libelle")
								
							Else 
								$entMotCle:=ds:C1482.Mot_Clef.query("Libelle = :1";$Saisie).orderBy("Libelle")
								
						End case 
						Form:C1466.MotsCles:=$entMotCle
					End if 
					Case of 
						: ($UUID_Client#"")
							entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & Retour_bibliotheque.Lien_motclef.Libelle = :2 & UUID_Client = :3";0;$Saisie;$UUID_Client)  //.orderBy("Path_, DossierFichier")
							
						: ($UUID_Groupe#"")
							entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & Retour_bibliotheque.Lien_motclef.Libelle = :2 & Lien_client.UUID_Groupe = :3";0;$Saisie;$UUID_Groupe)  //.orderBy("Path_, DossierFichier")
							
						Else 
							entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & Retour_bibliotheque.Lien_motclef.Libelle = :2";0;$Saisie)  //.orderBy("Path_, DossierFichier")
							
					End case 
				Else   // recherche sur le nom des fichiers
					Case of 
						: ($UUID_Client#"")
							entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & Nom = :2 & UUID_Client = :3";0;$Saisie;$UUID_Client)  //.orderBy("Path_, DossierFichier")
							
						: ($UUID_Groupe#"")
							entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & Nom = :2 & Lien_client.UUID_Groupe = :3";0;$Saisie;$UUID_Groupe)  //.orderBy("Path_, DossierFichier")
							
						Else 
							entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & Nom = :2";0;$Saisie)  //.orderBy("Path_, DossierFichier")
							
					End case 
				End if 
				  //Si ($motCles)
				  //  // Chercher les dossiers Parents des fichiers trouvés par les mots-clés
				  //$collecDossier:=entBiblio.distinct("PathParent")
				  //Si ($collecDossier.length>0)
				  //$EntDossierBiblio:=Créer Entity Selection([Bibliotheque])
				  //Boucle ($i;0;$collecDossier.length-1)
				  //$entBiblio:=ds.Bibliotheque.query("Type = :1 & Path_ = :2 & DossierFichier = :3";0;$collecDossier[$i];Vrai).first()
				  //$EntDossierBiblio.add($entBiblio)
				  //Fin de boucle 
				  //$EntDossierBiblio:=$EntDossierBiblio.orderBy("Path_")
				  //Fin de si 
				  //Sinon 
				  //$EntDossierBiblio:=entBiblio.query("DossierFichier = :1";Vrai).orderBy("Path_")
				  //Fin de si 
				  //Form.docs:=$EntDossierBiblio
				Affichage_Vignettes (entBiblio)
				
			: ($2="Clic_Sur_Dossier")
				Case of 
					: ($UUID_Client#"")
						entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & Path_ = :2 & UUID_Client = :3";0;$Ptr_Chemin->+"@";$UUID_Client)  //.orderBy("Path_, DossierFichier")
						
					: ($UUID_Groupe#"")
						entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & Path_ = :2 & Lien_client.UUID_Groupe = :3";0;$Ptr_Chemin->+"@";$UUID_Groupe)  //.orderBy("Path_, DossierFichier")
						
					Else 
						entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & Path_ = :2";0;$Ptr_Chemin->+"@")  //.orderBy("Path_, DossierFichier")
						
				End case 
				Affichage_Vignettes (entBiblio)
				
			: ($2="DoubleClic_Sur_Dossier")
				$Ptr_Chercher->:=""
				$entSelect:=Form:C1466.elmtCourantDoc
				Case of 
					: ($UUID_Client#"")
						entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & PathParent = :2 & UUID_Client = :3";0;$entSelect.Path_;$UUID_Client)  //.orderBy("Path_, DossierFichier")
						
					: ($UUID_Groupe#"")
						entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & PathParent = :2 & Lien_client.UUID_Groupe = :3";0;$entSelect.Path_;$UUID_Groupe)  //.orderBy("Path_, DossierFichier")
						
					Else 
						entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & PathParent = :2";0;$entSelect.Path_)  //.orderBy("Path_, DossierFichier")
						
				End case 
				  //$EntDossierBiblio:=entBiblio.query("DossierFichier = :1";Vrai).orderBy("Path_")
				  //Form.docs:=$EntDossierBiblio
				Affichage_Vignettes (entBiblio)
				
		End case 
		
		
	: ($nomObjet="Btn_Home")  // retour dossier Racine
		Sc_Dial_Consultation (->[Bibliotheque:1]UUID:1;"Bouton_Home")
		
		
	: ($nomObjet="Btn_Retour")  // retour dossier Parent
		Sc_Dial_Consultation (->[Bibliotheque:1]UUID:1;"Bouton_Retour")
		
		
	: ($nomObjet="chercherChaine")  // Champ de recherche 
		(OBJECT Get pointer:C1124(Objet nommé:K67:5;"Chemin_courant")->):=""
		$Saisie:=Get edited text:C655
		If (Length:C16($Saisie)>2)
			Sc_Dial_Consultation (->[Bibliotheque:1]UUID:1;"Chercher";$Saisie)
		Else 
			If ($Saisie="")
				Sc_Dial_Consultation (->[Bibliotheque:1]UUID:1;"Chercher";$Saisie)
			End if 
		End if 
		
		
	: ($nomObjet="lb_bibiothequeDossier")  // Listbox des noms de dossiers et de fichier
		Case of 
			: (Form event code:C388=Sur clic:K2:4)
				If (Not:C34(Form:C1466.elmtCourantDoc=Null:C1517))
					LISTBOX GET CELL POSITION:C971(*;"lb_bibiothequeDossier";$col;$ligne)
					If ($col=1)
						$entSelection:=Form:C1466.SelectionDoc.first()
						$entDossierEnfant:=entDossierBiblio.query("PathParent = :1";$entSelection.Path_)
						If ($entDossierEnfant.length>0)
							$EntDossierBiblio:=Form:C1466.docs
							If ($EntDossierBiblio.contains($entDossierEnfant.first()))
								$chemin:=$entSelection.Path_+"@"
								$entDossierEnfant:=entDossierBiblio.query("PathParent = :1";$chemin)
								For each ($emp;$entDossierEnfant)
									$EntDossierBiblio:=$EntDossierBiblio.minus($emp)
								End for each 
							Else 
								For each ($emp;$entDossierEnfant)
									$EntDossierBiblio.add($emp)
								End for each 
							End if 
							$EntDossierBiblio:=$EntDossierBiblio.orderBy("Path_")
							Form:C1466.docs:=$EntDossierBiblio
						End if 
					End if 
					  // Affiche le contenu du dossier référence et de ses dossiers enfants
					$entSelect:=Form:C1466.SelectionDoc.first()
					$Ptr_Chemin:=OBJECT Get pointer:C1124(Objet nommé:K67:5;"Chemin_courant")
					$Ptr_Chemin->:=$entSelect.Path_
					Sc_Dial_Consultation (->[Bibliotheque:1]UUID:1;"Clic_Sur_Dossier")
					If (Contextual click:C713)
						$entClient:=ds:C1482.Client.query("UUID = :1";$entSelect.UUID_Client).first()
						$DossierReferent:=$entClient.Chemin_Dossier
						$Ligne:=Pop up menu:C542("Afficher dans le Finder")
						If ($Ligne>0)
							$nomComplet:=$DossierReferent+$entSelect.Path_
							SHOW ON DISK:C922($nomComplet)
						End if 
					End if 
				End if 
				
				  //: (Événement formulaire code=Sur double clic)
				  //Si (Non(Form.elmtCourantDoc=Null))
				  //Sc_Dial_Consultation (->[Bibliotheque]UUID;"DoubleClic_Sur_Dossier")
				  //Fin de si 
				
		End case 
		
		
	: ($nomObjet="Btn_MotsCles")
		If ((OBJECT Get pointer:C1124(Objet nommé:K67:5;"Btn_MotsCles")->)=1)
			OBJECT SET VISIBLE:C603(*;"lb_ListeMotsCles";True:C214)
			LISTBOX SET COLUMN WIDTH:C833(*;"Col_lb_bibio_Nom";345)
			OBJECT MOVE:C664(*;"lb_bibiothequeDossier";0;210;150;-210)
			OBJECT MOVE:C664(*;"thermoLargeurCol";150;0)
			OBJECT MOVE:C664(*;"lb_Liste_Image";150;0;-150;0)
		Else 
			LISTBOX SET COLUMN WIDTH:C833(*;"Col_lb_bibio_Nom";195)
			OBJECT MOVE:C664(*;"lb_bibiothequeDossier";0;-210;-150;210)
			OBJECT SET VISIBLE:C603(*;"lb_ListeMotsCles";False:C215)
			OBJECT MOVE:C664(*;"thermoLargeurCol";-150;0)
			OBJECT MOVE:C664(*;"lb_Liste_Image";-150;0;150;0)
		End if 
		Sc_Dial_Consultation (->[Bibliotheque:1]UUID:1;"Case_MotCles")
		
		
	: ($nomObjet="Btn_Affichage_Date") | ($nomObjet="Btn_Affichage_Taille")
		Affichage_Vignettes (entBiblio)
		
		
	: ($nomObjet="lb_ListeMotsCles")  // Listbox des mots-clés
		Case of 
			: (Form event code:C388=Sur clic:K2:4)
				If (Not:C34(Form:C1466.elmtCourantMotsCles=Null:C1517))
					$entSelect:=Form:C1466.elmtCourantMotsCles.first()
					$entSelect:=Form:C1466.SelectionMotsCles.first()
					$Saisie:=$entSelect.Libelle
					Sc_Dial_Consultation (->[Bibliotheque:1]UUID:1;"Chercher";$Saisie;True:C214)
				End if 
				
		End case 
		
		
	: ($nomObjet="cc_Tri1") | ($nomObjet="cc_Tri2") | ($nomObjet="cc_Tri3") | ($nomObjet="cc_Tri4")
		Affichage_Vignettes (entBiblio)
		
		
	: ($nomObjet="lb_Liste_Image")  // Listbox d'affichage des vignettes
		Case of 
			: (Form event code:C388=Sur clic:K2:4)
				LISTBOX GET CELL POSITION:C971(*;"lb_Liste_Image";$Col;$Ligne;$varCol)
				If ($Ligne>0)
					LISTBOX GET ARRAYS:C832(*;"lb_Liste_Image";$t_nomCol;$t_nomEntete;$t_varCol;$t_varEntete;$t_colVisible;$t_style)
					$rech:=Find in array:C230($t_varCol;$varCol)
					If ($rech#-1) & ($rech<Size of array:C274($t_varCol))
						$objeImage:=$t_varCol{$rech+1}->{$Ligne}
						If ((OBJECT Get pointer:C1124(Objet nommé:K67:5;"Btn_MotsCles")->)=1)
							  // Si on est sur la recherche par mots-clés et que l'on clic sur une image ou un fichier on renseigne le chemin du dossier parent
							(OBJECT Get pointer:C1124(Objet nommé:K67:5;"Chemin_courant")->):=$objeImage.pathParent
						End if 
						If (Contextual click:C713)
							APPEND TO ARRAY:C911($PU_Action;"<IInfos : ")
							APPEND TO ARRAY:C911($PU_Action;Char:C90(1)+"- Nom : "+$objeImage.nom)
							If (Not:C34($objeImage.taille=Null:C1517))
								APPEND TO ARRAY:C911($PU_Action;Char:C90(1)+"- Taille. : "+$objeImage.taille)
							End if 
							APPEND TO ARRAY:C911($PU_Action;Char:C90(1)+"- Date créa. : "+String:C10($objeImage.dateCrea))
							APPEND TO ARRAY:C911($PU_Action;Char:C90(1)+"- Date modif. : "+String:C10($objeImage.dateModif))
							APPEND TO ARRAY:C911($PU_Action;Char:C90(1)+"- Poids fichier : "+String:C10(Round:C94($objeImage.poids/1024/1024;1);"|Decimale1AvecouSans")+" Mo")
							APPEND TO ARRAY:C911($PU_Action;"-")
							APPEND TO ARRAY:C911($PU_Action;"Afficher dans le Finder")
							APPEND TO ARRAY:C911($PU_Action;"Ouvrir le fichier...")
							$Texte:=""
							For ($i;1;Size of array:C274($PU_Action))
								$Texte:=$Texte+$PU_Action{$i}
								If ($i<Size of array:C274($PU_Action))
									$Texte:=$Texte+";"
								End if 
							End for 
							$LigneMenu:=Pop up menu:C542($Texte)
							If ($LigneMenu>0)
								$entClient:=ds:C1482.Client.query("UUID = :1";$objeImage.uuidClient).first()
								$DossierReferent:=$entClient.Chemin_Dossier
								$nomComplet:=$DossierReferent+$objeImage.path
								Case of 
									: ($LigneMenu=(Size of array:C274($PU_Action)-1))
										SHOW ON DISK:C922($nomComplet)
										
									: ($LigneMenu=Size of array:C274($PU_Action))
										OPEN URL:C673($nomComplet)
										
								End case 
							End if 
						End if 
					End if 
				End if 
				
		End case 
		
		
	: ($nomObjet="thermoLargeurCol")  // Règle Taille vignette
		SET TIMER:C645(-1)
		
		
	: ($nomObjet="btn_thermoLargeurCol_moins")  // Bouton caché réduit la taille des images
		$valTermo:=(OBJECT Get pointer:C1124(Objet nommé:K67:5;"thermoLargeurCol")->)
		If ($valTermo>10)
			$valTermo:=$valTermo-10
			(OBJECT Get pointer:C1124(Objet nommé:K67:5;"thermoLargeurCol")->):=$valTermo
			SET TIMER:C645(-1)
		End if 
		
		
	: ($nomObjet="btn_thermoLargeurCol_plus")  // Bouton caché agrandit la taille des images
		$valTermo:=(OBJECT Get pointer:C1124(Objet nommé:K67:5;"thermoLargeurCol")->)
		If ($valTermo<90)
			$valTermo:=$valTermo+10
			(OBJECT Get pointer:C1124(Objet nommé:K67:5;"thermoLargeurCol")->):=$valTermo
			SET TIMER:C645(-1)
		End if 
		
		
	: ($nomObjet="Btn_Fermer")
		$UUID_Client:=(OBJECT Get pointer:C1124(Objet nommé:K67:5;"vUUID_Client")->)
		$UUID_Groupe:=(OBJECT Get pointer:C1124(Objet nommé:K67:5;"vUUID_Groupe")->)
		$entPref:=ds:C1482.Preference.all().first()
		If ($UUID_Client#"")
			$entPref.UUID_DernierClientConsulter:=$UUID_Client
		Else 
			$entPref.UUID_DernierClientConsulter:=""
		End if 
		If ($UUID_Groupe#"")
			$entPref.UUID_DernierGroupeConsulter:=$UUID_Groupe
		Else 
			$entPref.UUID_DernierGroupeConsulter:=""
		End if 
		GET WINDOW RECT:C443($g;$h;$d;$b)
		$reglages:=New object:C1471
		OB SET:C1220($reglages;"motscles";((OBJECT Get pointer:C1124(Objet nommé:K67:5;"Btn_MotsCles")->)=1))
		OB SET:C1220($reglages;"tailleImage";(OBJECT Get pointer:C1124(Objet nommé:K67:5;"thermoLargeurCol")->))
		OB SET:C1220($reglages;"coordG";$g;"coordH";$h;"coordD";$d;"coordB";$b)
		$entPref.Reglages:=$reglages
		$entPref.save()
		
End case 
