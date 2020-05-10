//%attributes = {"invisible":true}
  // Méthode : Gerer_Groupe
  // Date et heure : 18/04/20, 16:18:48

C_LONGINT:C283($Process;$Ref_Fen)

If (Count parameters:C259=0)
	$Process:=New process:C317(Current method name:C684;0;"Liste des groupes";0;*)
	If (Process state:C330($Process)>0)
		RESUME PROCESS:C320($Process)
		SHOW PROCESS:C325($Process)
		BRING TO FRONT:C326($Process)
	End if 
Else 
	InitProcess 
	ALL RECORDS:C47([Groupe:8])
	If (Records in selection:C76([Groupe:8])>1)
		ORDER BY:C49([Groupe:8];[Groupe:8]Nom:2;>)
	End if 
	$Ref_Fen:=Open form window:C675([Groupe:8];"Liste";Form fenêtre standard:K39:10;À gauche:K39:2;En haut:K39:5)
	DIALOG:C40([Groupe:8];"Liste")
	CLOSE WINDOW:C154($Ref_Fen)
	
End if 
