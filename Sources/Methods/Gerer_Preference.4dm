//%attributes = {"invisible":true}
  // Méthode : Gerer_Preference
  // Date et heure : 08/03/20, 18:20:37

C_LONGINT:C283($Process;$Ref_Fen)
C_OBJECT:C1216($entPref)

If (Count parameters:C259=0)
	$Process:=New process:C317(Current method name:C684;0;"Préférences";0;*)
	If (Process state:C330($Process)>0)
		RESUME PROCESS:C320($Process)
		SHOW PROCESS:C325($Process)
		BRING TO FRONT:C326($Process)
	End if 
Else 
	InitProcess 
	If (Records in table:C83([Preference:3])=0)
		$entPref:=ds:C1482.Preference.new()
		$entPref.save()
	End if 
	READ WRITE:C146([Preference:3])
	$entPref:=ds:C1482.Preference.all().first()
	READ WRITE:C146([Extension:4])
	ALL RECORDS:C47([Extension:4])
	ORDER BY:C49([Extension:4];[Extension:4]Nom:2;>)
	$Ref_Fen:=Open form window:C675([Preference:3];"Saisie";Form fenêtre standard:K39:10;À gauche:K39:2;En haut:K39:5)
	DIALOG:C40([Preference:3];"Saisie";$entPref)
	If (OK=1)
		$entPref.save()
	End if 
	CLOSE WINDOW:C154($Ref_Fen)
	UNLOAD RECORD:C212([Preference:3])
	READ ONLY:C145([Preference:3])
	UNLOAD RECORD:C212([Extension:4])
	READ ONLY:C145([Extension:4])
End if 


