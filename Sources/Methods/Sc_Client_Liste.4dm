//%attributes = {"invisible":true}
  // Méthode : Sc_Client_Liste
  // Date et heure : 06/04/20, 23:29:39
  // Modifié le : 19/04/20, 00:09:05

C_LONGINT:C283($Ref_Fen;$cpt;$ID_Progress)
C_TEXT:C284($nomObjet;$Saisie;$msg)
C_POINTER:C301($objet)
C_OBJECT:C1216($entClient;$entBiblio;$entVignette;$emp;$entBiblioMot;$emp2;$EntNbFiche;$entMotCles;$entNotDrop)

If (Count parameters:C259>=1)
	$objet:=$1
End if 
If (Is nil pointer:C315($objet))
	$nomObjet:=OBJECT Get name:C1087(Objet courant:K67:2)
End if 

Case of 
	: ($objet=(->[Client:7]))  // Méthode formulaire [Client];"Liste"
		OBJECT SET ENABLED:C1123(*;"Btn_Supprimer";False:C215)
		CREATE EMPTY SET:C140([Client:7];"$ListboxSet_ListeClients")
		
		
	: ($nomObjet="lb_ListeClients")
		Case of 
			: (Form event code:C388=Sur affichage corps:K2:22)
				If (GEN_UuidValide ([Client:7]UUID_Groupe:5))
					QUERY:C277([Groupe:8];[Groupe:8]UUID:1=[Client:7]UUID_Groupe:5)
				Else 
					REDUCE SELECTION:C351([Groupe:8];0)
				End if 
				
			: (Form event code:C388=Sur double clic:K2:5)
				COPY NAMED SELECTION:C331([Client:7];"Liste_Clients")
				COPY SET:C600("$ListboxSet_ListeClients";"Client_Modif")
				READ WRITE:C146([Client:7])
				USE SET:C118("$ListboxSet_ListeClients")
				$Ref_Fen:=Open form window:C675([Client:7];"Saisie";Form fenêtre standard:K39:10;Centrée horizontalement:K39:1;Centrée verticalement:K39:4)
				DIALOG:C40([Client:7];"Saisie")
				CLOSE WINDOW:C154($Ref_Fen)
				If (OK=1)
					SAVE RECORD:C53([Client:7])
				End if 
				UNLOAD RECORD:C212([Client:7])
				READ ONLY:C145([Client:7])
				USE NAMED SELECTION:C332("Liste_Clients")
				CLEAR NAMED SELECTION:C333("Liste_Clients")
				COPY SET:C600("Client_Modif";"$ListboxSet_ListeClients")
				CLEAR SET:C117("Client_Modif")
				OBJECT SET ENABLED:C1123(*;"Btn_Supprimer";(Records in set:C195("$ListboxSet_ListeClients")#0))
				
			: (Form event code:C388=Sur nouvelle sélection:K2:29)
				OBJECT SET ENABLED:C1123(*;"Btn_Supprimer";(Records in set:C195("$ListboxSet_ListeClients")#0))
				
		End case 
		
		
	: ($nomObjet="Btn_Ajouter")
		COPY NAMED SELECTION:C331([Client:7];"Liste_Clients")
		START TRANSACTION:C239
		$Saisie:="Client"
		$entClient:=ds:C1482.Client.query("Nom = :1";$Saisie)
		If ($entClient.length#0)
			$cpt:=0
			While ($entClient.length#0)
				$cpt:=$cpt+1
				$Saisie:=$Saisie+String:C10($cpt)
				$entClient:=ds:C1482.Client.query("Nom = :1";$Saisie)
			End while 
		End if 
		READ WRITE:C146([Client:7])
		CREATE RECORD:C68([Client:7])
		[Client:7]Nom:2:=$Saisie
		SAVE RECORD:C53([Client:7])
		$Ref_Fen:=Open form window:C675([Client:7];"Saisie";Form fenêtre standard:K39:10;Centrée horizontalement:K39:1;Centrée verticalement:K39:4)
		DIALOG:C40([Client:7];"Saisie")
		CLOSE WINDOW:C154($Ref_Fen)
		If (OK=1)
			SAVE RECORD:C53([Client:7])
			VALIDATE TRANSACTION:C240
			CREATE SET:C116([Client:7];"Client_Ajout")
			ALL RECORDS:C47([Client:7])
			If (Records in selection:C76([Client:7])>1)
				ORDER BY:C49([Client:7];[Client:7]Nom:2;>)
			End if 
		Else 
			CANCEL TRANSACTION:C241
			CREATE EMPTY SET:C140([Client:7];"Client_Ajout")
			USE NAMED SELECTION:C332("Liste_Clients")
		End if 
		UNLOAD RECORD:C212([Client:7])
		READ ONLY:C145([Client:7])
		CLEAR NAMED SELECTION:C333("Liste_Clients")
		COPY SET:C600("Client_Ajout";"$ListboxSet_ListeClients")
		CLEAR SET:C117("Client_Ajout")
		OBJECT SET ENABLED:C1123(*;"Btn_Supprimer";(Records in set:C195("$ListboxSet_ListeClients")#0))
		
		
	: ($nomObjet="Btn_Supprimer")
		LOAD RECORD:C52([Client:7])
		$entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & DossierFichier = :2 & UUID_Client = :3";0;False:C215;[Client:7]UUID:1)
		$msg:="Voulez-vous réellement supprimer le client \""+[Client:7]Nom:2+"\" "
		If ($entBiblio.length>0)
			$msg:=$msg+"et ses "+String:C10($entBiblio.length)+" fichiers "
		End if 
		$msg:=$msg+"de la base de données ?\rCette opération est irréversible."
		CONFIRM:C162($msg;"Supprimer";"Annuler")
		If (OK=1)
			$ID_Progress:=Progress New 
			Progress SET TITLE ($ID_Progress;"Suppression des éléments en cours...";-1;"";True:C214)
			START TRANSACTION:C239
			READ WRITE:C146([Client:7])
			USE SET:C118("$ListboxSet_ListeClients")
			  // On cherche toutes les fiches du clients Dossiers et Fichiers
			$entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & UUID_Client = :2";0;[Client:7]UUID:1)
			  // suppression des éléments des tables liées
			If ($entBiblio.length>0)
				  // On boucle sur chaque fiche pour voir s'il y a des mots-clés
				For each ($emp;$entBiblio)
					If ($emp.DossierFichier)
						  // C'est un dossier on supprime direct
						
					Else 
						  // On cherche s'il y a des vignettes
						$entVignette:=ds:C1482.Vignette.query("UUID_Bibliotheque = :1";$emp.UUID)
						If ($entVignette.length>0)
							$entNotDrop:=$entVignette.drop()
						End if 
						  // On cherche s'il y a des mots-clés
						$entBiblioMot:=ds:C1482.Biblio_MotClef.query("UUID_Bibliotheque = :1";$emp.UUID)
						If ($entBiblioMot.length>0)
							  // Pour chaque fiche de lien vers le mot-clé on regarde s'il y a plusieurs ficheq de lien pour ce mot-clé
							For each ($emp2;$entBiblioMot)
								$EntNbFiche:=ds:C1482.Biblio_MotClef.query("UUID_MotClef = :1";$emp2.UUID_MotClef)
								If ($EntNbFiche.length=1)
									  // On recherche la fiche de Mot-clés pour la supprimer
									$entMotCles:=ds:C1482.Mot_Clef.query("UUID = :1";$EntNbFiche.UUID_MotClef[0])
									$entNotDrop:=$entMotCles.drop()
								End if 
								  // On supprime la fiche de lien
								$entNotDrop:=$emp2.drop()
							End for each 
						End if 
					End if 
					  // On supprime la fiche [Bibliotheque]
					$entNotDrop:=$emp.drop()
				End for each 
			End if 
			DELETE RECORD:C58([Client:7])
			READ ONLY:C145([Client:7])
			Progress QUIT (0)
			VALIDATE TRANSACTION:C240
			ALL RECORDS:C47([Client:7])
			If (Records in selection:C76([Client:7])>1)
				ORDER BY:C49([Client:7];[Client:7]Nom:2;>)
			End if 
			CREATE EMPTY SET:C140([Client:7];"$ListboxSet_ListeClients")
			OBJECT SET ENABLED:C1123(*;"Btn_Supprimer";(Records in set:C195("$ListboxSet_ListeClients")#0))
		End if 
		
End case 
