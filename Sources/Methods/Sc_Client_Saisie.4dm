//%attributes = {"invisible":true}
  // Méthode : Sc_Client_Saisie
  // Date et heure : 18/04/20, 23:55:47

C_LONGINT:C283($i;$LigneMenu)
C_TEXT:C284($nomObjet;$Dossier;$Texte)
C_POINTER:C301($objet)
C_OBJECT:C1216($entGroupe)
C_COLLECTION:C1488($collecGroupe)
ARRAY TEXT:C222($t_Groupe_Nom;0)
ARRAY TEXT:C222($t_Groupe_UUID;0)

If (Count parameters:C259>=1)
	$objet:=$1
End if 
If (Is nil pointer:C315($objet))
	$nomObjet:=OBJECT Get name:C1087(Objet courant:K67:2)
End if 

Case of 
	: ($objet=(->[Client:7]))  // Méthode formulaire [Client];"Saisie"
		OBJECT SET ENABLED:C1123([Client:7]Actualiser_Dossier:4;([Client:7]Chemin_Dossier:3#""))
		If (GEN_UuidValide ([Client:7]UUID_Groupe:5))
			$entGroupe:=ds:C1482.Groupe.query("UUID = :1";[Client:7]UUID_Groupe:5).first()
			(OBJECT Get pointer:C1124(Objet nommé:K67:5;"Champ_Groupe")->):=$entGroupe.Nom
		End if 
		
		
	: ($nomObjet="Btn_PopMenuGroupe")
		$entGroupe:=ds:C1482.Groupe.all().orderBy("Nom")
		$collecGroupe:=New collection:C1472
		$collecGroupe:=$entGroupe.toCollection()
		If ($collecGroupe.length>0)
			COLLECTION TO ARRAY:C1562($collecGroupe;$t_Groupe_Nom;"Nom";$t_Groupe_UUID;"UUID")
		End if 
		$Texte:=""
		For ($i;1;Size of array:C274($t_Groupe_Nom))
			$Texte:=$Texte+$t_Groupe_Nom{$i}
			If ($i<Size of array:C274($t_Groupe_Nom))
				$Texte:=$Texte+";"
			End if 
		End for 
		$LigneMenu:=Pop up menu:C542($Texte)
		If ($LigneMenu>0)
			(OBJECT Get pointer:C1124(Objet nommé:K67:5;"Champ_Groupe")->):=$t_Groupe_Nom{$LigneMenu}
			[Client:7]UUID_Groupe:5:=$t_Groupe_UUID{$LigneMenu}
		End if 
		
		
	: ($nomObjet="Btn_Dossier_Client")
		$Dossier:=Select folder:C670("Sélectionner le dossier des Travaux";10;Utiliser fenêtre feuille:K24:11)
		If (OK=1)
			[Client:7]Chemin_Dossier:3:=$Dossier
		End if 
		OBJECT SET ENABLED:C1123([Client:7]Actualiser_Dossier:4;([Client:7]Chemin_Dossier:3#""))
		[Client:7]Actualiser_Dossier:4:=([Client:7]Chemin_Dossier:3#"")
		
		
	: ($nomObjet="Btn_Valider")
		If ([Client:7]Nom:2="")
			ALERT:C41("Le nom de client est obligatoire.")
			GOTO OBJECT:C206([Client:7]Nom:2)
		Else 
			ACCEPT:C269
		End if 
		
End case 
