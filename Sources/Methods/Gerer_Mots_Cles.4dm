//%attributes = {"invisible":true}
  // Méthode : Gerer_Mots_Cles
  // Date et heure : 07/04/20, 09:02:56

C_LONGINT:C283($Process;$Ref_Fen)

If (Count parameters:C259=0)
	$Process:=New process:C317(Current method name:C684;0;"Liste des Mots-clés";0;*)
	If (Process state:C330($Process)>0)
		RESUME PROCESS:C320($Process)
		SHOW PROCESS:C325($Process)
		BRING TO FRONT:C326($Process)
	End if 
Else 
	InitProcess 
	ALL RECORDS:C47([Mot_Clef:5])
	If (Records in selection:C76([Mot_Clef:5])>1)
		ORDER BY:C49([Mot_Clef:5];[Mot_Clef:5]Libelle:3;>)
	End if 
	$Ref_Fen:=Open form window:C675([Mot_Clef:5];"Liste";Form fenêtre standard:K39:10;À gauche:K39:2;En haut:K39:5)
	DIALOG:C40([Mot_Clef:5];"Liste")
	CLOSE WINDOW:C154($Ref_Fen)
	
End if 
