//%attributes = {"invisible":true}
  // Méthode : Sc_MotCles_Liste
  // Date et heure : 07/04/20, 23:06:43

C_LONGINT:C283($Ref_Fen)
C_TEXT:C284($nomObjet;$msg)
C_POINTER:C301($objet)
C_OBJECT:C1216($entBiblioMotCles;$entNotDrop)

If (Count parameters:C259>=1)
	$objet:=$1
End if 
If (Is nil pointer:C315($objet))
	$nomObjet:=OBJECT Get name:C1087(Objet courant:K67:2)
End if 

Case of 
	: ($objet=(->[Mot_Clef:5]))  // Méthode formulaire [Mot_Clef];"Liste"
		OBJECT SET ENABLED:C1123(*;"Btn_Supprimer";False:C215)
		CREATE EMPTY SET:C140([Mot_Clef:5];"$ListboxSet_ListeMotsCles")
		(OBJECT Get pointer:C1124(Objet nommé:K67:5;"nbFiches")->):=Records in selection:C76([Mot_Clef:5])
		
		
	: ($nomObjet="lb_ListeMotsCles")
		Case of 
			: (Form event code:C388=Sur double clic:K2:5)
				COPY NAMED SELECTION:C331([Mot_Clef:5];"Liste_MotsCles")
				COPY SET:C600("$ListboxSet_ListeMotsCles";"MotCle_Modif")
				READ WRITE:C146([Mot_Clef:5])
				USE SET:C118("$ListboxSet_ListeMotsCles")
				$Ref_Fen:=Open form window:C675([Mot_Clef:5];"Saisie";Form fenêtre standard:K39:10;Centrée horizontalement:K39:1;Centrée verticalement:K39:4)
				DIALOG:C40([Mot_Clef:5];"Saisie")
				CLOSE WINDOW:C154($Ref_Fen)
				If (OK=1)
					SAVE RECORD:C53([Mot_Clef:5])
				End if 
				UNLOAD RECORD:C212([Mot_Clef:5])
				READ ONLY:C145([Mot_Clef:5])
				USE NAMED SELECTION:C332("Liste_MotsCles")
				CLEAR NAMED SELECTION:C333("Liste_MotsCles")
				COPY SET:C600("MotCle_Modif";"$ListboxSet_ListeMotsCles")
				CLEAR SET:C117("MotCle_Modif")
				OBJECT SET ENABLED:C1123(*;"Btn_Supprimer";(Records in set:C195("$ListboxSet_ListeMotsCles")#0))
				
			: (Form event code:C388=Sur nouvelle sélection:K2:29)
				OBJECT SET ENABLED:C1123(*;"Btn_Supprimer";(Records in set:C195("$ListboxSet_ListeMotsCles")#0))
				
		End case 
		
		
	: ($nomObjet="Btn_Supprimer")
		If (Records in set:C195("$ListboxSet_ListeMotsCles")=1)
			LOAD RECORD:C52([Mot_Clef:5])
			$entBiblioMotCles:=ds:C1482.Biblio_MotClef.query("UUID_MotClef = :1";[Mot_Clef:5]UUID:1)
			$msg:="Voulez-vous réellement supprimer le mot-clé \""+[Mot_Clef:5]Libelle:3+"\" "
			If ($entBiblioMotCles.length>0)
				$msg:=$msg+"et ses "+String:C10($entBiblioMotCles.length)+" lien(s) vers les images de la bibliothèque "
			End if 
			$msg:=$msg+"?\rCette opération est irréversible."
			CONFIRM:C162($msg;"Supprimer";"Annuler")
			If (OK=1)
				READ WRITE:C146([Mot_Clef:5])
				USE SET:C118("$ListboxSet_ListeMotsCles")
				  // Suppression des fiches de liens
				$entNotDrop:=$entBiblioMotCles.drop()
				  // Suppression du mot-clé
				DELETE RECORD:C58([Mot_Clef:5])
				READ ONLY:C145([Mot_Clef:5])
				ALL RECORDS:C47([Mot_Clef:5])
				If (Records in selection:C76([Mot_Clef:5])>1)
					ORDER BY:C49([Mot_Clef:5];[Mot_Clef:5]Libelle:3;>)
				End if 
				(OBJECT Get pointer:C1124(Objet nommé:K67:5;"nbFiches")->):=Records in selection:C76([Mot_Clef:5])
				OBJECT SET ENABLED:C1123(*;"Btn_Supprimer";False:C215)
				CREATE EMPTY SET:C140([Mot_Clef:5];"$ListboxSet_ListeMotsCles")
			End if 
		Else 
			$msg:="Voulez-vous réellement supprimer les "+String:C10(Records in set:C195("$ListboxSet_ListeMotsCles"))+" mots-clés sélectionnés et leurs liens vers les images de la bibliothèque ?\rCette opération est irréversible."
			CONFIRM:C162($msg;"Supprimer";"Annuler")
			If (OK=1)
				READ WRITE:C146([Mot_Clef:5])
				READ WRITE:C146([Biblio_MotClef:6])
				USE SET:C118("$ListboxSet_ListeMotsCles")
				SELECTION TO ARRAY:C260([Mot_Clef:5]UUID:1;$t_UUID_MotCle)
				  // Recherche et suppression des fiches de liens
				QUERY WITH ARRAY:C644([Biblio_MotClef:6]UUID_MotClef:3;$t_UUID_MotCle)
				If (Records in selection:C76([Biblio_MotClef:6])>0)
					DELETE SELECTION:C66([Biblio_MotClef:6])
				End if 
				  // Suppression des mots-clés
				DELETE SELECTION:C66([Mot_Clef:5])
				READ ONLY:C145([Mot_Clef:5])
				READ ONLY:C145([Biblio_MotClef:6])
				ALL RECORDS:C47([Mot_Clef:5])
				If (Records in selection:C76([Mot_Clef:5])>1)
					ORDER BY:C49([Mot_Clef:5];[Mot_Clef:5]Libelle:3;>)
				End if 
				(OBJECT Get pointer:C1124(Objet nommé:K67:5;"nbFiches")->):=Records in selection:C76([Mot_Clef:5])
				OBJECT SET ENABLED:C1123(*;"Btn_Supprimer";False:C215)
				CREATE EMPTY SET:C140([Mot_Clef:5];"$ListboxSet_ListeMotsCles")
			End if 
		End if 
		
End case 
