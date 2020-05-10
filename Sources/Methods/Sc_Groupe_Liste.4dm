//%attributes = {"invisible":true}
  // Méthode : Sc_Groupe_Liste
  // Date et heure : 18/04/20, 16:10:36

C_LONGINT:C283($Ref_Fen;$cpt)
C_BOOLEAN:C305($continuer)
C_TEXT:C284($nomObjet;$Saisie;$msg)
C_POINTER:C301($objet)
C_OBJECT:C1216($entGroupe;$entClient;$emp)

If (Count parameters:C259>=1)
	$objet:=$1
End if 
If (Is nil pointer:C315($objet))
	$nomObjet:=OBJECT Get name:C1087(Objet courant:K67:2)
End if 

Case of 
	: ($objet=(->[Groupe:8]))  // Méthode formulaire [Groupe];"Liste"
		OBJECT SET ENABLED:C1123(*;"Btn_Supprimer";False:C215)
		CREATE EMPTY SET:C140([Groupe:8];"$ListboxSet_ListeGroupes")
		
		
	: ($nomObjet="lb_ListeGroupes")
		Case of 
			: (Form event code:C388=Sur double clic:K2:5)
				COPY NAMED SELECTION:C331([Groupe:8];"Liste_Groupes")
				COPY SET:C600("$ListboxSet_ListeGroupes";"Groupe_Modif")
				READ WRITE:C146([Groupe:8])
				USE SET:C118("$ListboxSet_ListeGroupes")
				$Ref_Fen:=Open form window:C675([Groupe:8];"Saisie";Form fenêtre standard:K39:10;Centrée horizontalement:K39:1;Centrée verticalement:K39:4)
				DIALOG:C40([Groupe:8];"Saisie")
				CLOSE WINDOW:C154($Ref_Fen)
				If (OK=1)
					SAVE RECORD:C53([Groupe:8])
				End if 
				UNLOAD RECORD:C212([Groupe:8])
				READ ONLY:C145([Groupe:8])
				USE NAMED SELECTION:C332("Liste_Groupes")
				CLEAR NAMED SELECTION:C333("Liste_Groupes")
				COPY SET:C600("Groupe_Modif";"$ListboxSet_ListeGroupes")
				CLEAR SET:C117("Groupe_Modif")
				OBJECT SET ENABLED:C1123(*;"Btn_Supprimer";(Records in set:C195("$ListboxSet_ListeGroupes")#0))
				
			: (Form event code:C388=Sur nouvelle sélection:K2:29)
				OBJECT SET ENABLED:C1123(*;"Btn_Supprimer";(Records in set:C195("$ListboxSet_ListeGroupes")#0))
				
		End case 
		
		
	: ($nomObjet="Btn_Ajouter")
		COPY NAMED SELECTION:C331([Groupe:8];"Liste_Groupes")
		START TRANSACTION:C239
		$Saisie:="Groupe"
		$entGroupe:=ds:C1482.Groupe.query("Nom = :1";$Saisie)
		If ($entGroupe.length#0)
			$cpt:=0
			While ($entGroupe.length#0)
				$cpt:=$cpt+1
				$Saisie:=$Saisie+String:C10($cpt)
				$entGroupe:=ds:C1482.Groupe.query("Nom = :1";$Saisie)
			End while 
		End if 
		READ WRITE:C146([Groupe:8])
		CREATE RECORD:C68([Groupe:8])
		[Groupe:8]Nom:2:=$Saisie
		SAVE RECORD:C53([Groupe:8])
		$Ref_Fen:=Open form window:C675([Groupe:8];"Saisie";Form fenêtre standard:K39:10;Centrée horizontalement:K39:1;Centrée verticalement:K39:4)
		DIALOG:C40([Groupe:8];"Saisie")
		CLOSE WINDOW:C154($Ref_Fen)
		If (OK=1)
			SAVE RECORD:C53([Groupe:8])
			VALIDATE TRANSACTION:C240
			CREATE SET:C116([Groupe:8];"Groupe_Ajout")
			ALL RECORDS:C47([Groupe:8])
			If (Records in selection:C76([Groupe:8])>1)
				ORDER BY:C49([Groupe:8];[Groupe:8]Nom:2;>)
			End if 
		Else 
			CANCEL TRANSACTION:C241
			CREATE EMPTY SET:C140([Groupe:8];"Groupe_Ajout")
			USE NAMED SELECTION:C332("Liste_Groupes")
		End if 
		UNLOAD RECORD:C212([Groupe:8])
		READ ONLY:C145([Groupe:8])
		CLEAR NAMED SELECTION:C333("Liste_Groupes")
		COPY SET:C600("Groupe_Ajout";"$ListboxSet_ListeGroupes")
		CLEAR SET:C117("Groupe_Ajout")
		OBJECT SET ENABLED:C1123(*;"Btn_Supprimer";(Records in set:C195("$ListboxSet_ListeGroupes")#0))
		
		
	: ($nomObjet="Btn_Supprimer")
		LOAD RECORD:C52([Groupe:8])
		$entClient:=ds:C1482.Client.query("UUID_Groupe = :1";[Groupe:8]UUID:1)
		$continuer:=True:C214
		If ($entClient.length>0)
			$msg:="Le groupe "+[Groupe:8]Nom:2+" est affecté à "+String:C10($entClient.length)+" fiche(s) client.\r\rVoulez-vous quand même supprimer ce groupe et supprimer ce lien dans le(s) fiche(s) Client ?"
			CONFIRM:C162($msg;"Supprimer";"Annuler")
			If (OK=0)
				$continuer:=False:C215
			End if 
		End if 
		If ($continuer)
			If ($entClient.length>0)
				For each ($emp;$entClient)
					$emp.UUID_Groupe:=""
					$emp.save()
				End for each 
			End if 
			DELETE RECORD:C58([Groupe:8])
			READ ONLY:C145([Groupe:8])
			ALL RECORDS:C47([Groupe:8])
			If (Records in selection:C76([Groupe:8])>1)
				ORDER BY:C49([Groupe:8];[Groupe:8]Nom:2;>)
			End if 
			CREATE EMPTY SET:C140([Groupe:8];"$ListboxSet_ListeGroupes")
			OBJECT SET ENABLED:C1123(*;"Btn_Supprimer";(Records in set:C195("$ListboxSet_ListeGroupes")#0))
		End if 
		
End case 
