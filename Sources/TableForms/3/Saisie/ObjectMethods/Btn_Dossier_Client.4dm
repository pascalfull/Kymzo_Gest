  // Méthode : [Preference].Saisie.Btn_Dossier_Client
  // Date et heure : 08/03/20, 18:18:44

C_TEXT:C284($Dossier)

$Dossier:=Select folder:C670("Sélectionner le dossier Client";10;Utiliser fenêtre feuille:K24:11)
If (OK=1)
	Form:C1466.Chemin_Dossier_Client:=$Dossier
End if 
