//%attributes = {"invisible":true}
  // Méthode : Gerer_Client
  // Date et heure : 06/04/20, 23:45:35

C_LONGINT:C283($Process;$Ref_Fen)

If (Count parameters:C259=0)
	$Process:=New process:C317(Current method name:C684;0;"Liste des clients";0;*)
	If (Process state:C330($Process)>0)
		RESUME PROCESS:C320($Process)
		SHOW PROCESS:C325($Process)
		BRING TO FRONT:C326($Process)
	End if 
Else 
	InitProcess 
	ALL RECORDS:C47([Client:7])
	If (Records in selection:C76([Client:7])>1)
		ORDER BY:C49([Client:7];[Client:7]Nom:2;>)
	End if 
	$Ref_Fen:=Open form window:C675([Client:7];"Liste";Form fenêtre standard:K39:10;À gauche:K39:2;En haut:K39:5)
	DIALOG:C40([Client:7];"Liste")
	CLOSE WINDOW:C154($Ref_Fen)
	
End if 
