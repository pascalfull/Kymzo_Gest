  // Méthode : [Mot_Clef].Saisie1.Btn_Valider
  // Date et heure : 08/04/20, 00:15:52

If ([Mot_Clef:5]Libelle:3="")
	ALERT:C41("Le libellé est obligatoire.")
	GOTO OBJECT:C206([Mot_Clef:5]Libelle:3)
Else 
	ACCEPT:C269
End if 
