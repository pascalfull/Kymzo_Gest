//%attributes = {"invisible":true}
  // Méthode : Gerer_Analyse_Dossiers
  // Date et heure : 22/02/20, 23:39:39
  // Modifié le : 26/04/20, 17:04:14

C_LONGINT:C283($i;$Rech;$process;$Ref_Fen;$idProgress)
C_OBJECT:C1216($entClient)

If (Count parameters:C259=0)
	$process:=New process:C317(Current method name:C684;0;"Analyser les Dossiers Clients";0;*)
	If (Process state:C330($process)>0)
		RESUME PROCESS:C320($process)
		SHOW PROCESS:C325($process)
		BRING TO FRONT:C326($process)
	End if 
Else 
	InitProcess 
	$Ref_Fen:=Open form window:C675([Client:7];"Dial_Choix_Analyse";Form fenêtre standard:K39:10;À gauche:K39:2;En haut:K39:5)
	DIALOG:C40([Client:7];"Dial_Choix_Analyse")
	CLOSE WINDOW:C154($Ref_Fen)
	If (OK=1)
		MESSAGES OFF:C175
		For ($i;1;Size of array:C274(t_Client_Select))
			If (t_Client_Select{$i})
				$entClient:=ds:C1482.Client.query("UUID = :1";t_Client_UUID{$i}).first()
				$idProgress:=Progress New 
				Progress SET TITLE ($idProgress;"Analyse du dossier client : "+$entClient.Nom+" en cours...";-1;"";True:C214)
				$Process:=New process:C317("Analyse_Dossier";0;"Analyse Client "+t_Client_Nom{$i};t_Client_UUID{$i};$idProgress)
				DELAY PROCESS:C323(Current process:C322;60*2)
			End if 
		End for 
		$Rech:=Process number:C372("Analyse Client@")
		While ($Rech>0)
			DELAY PROCESS:C323(Current process:C322;60*2)
			$Rech:=Process number:C372("Analyse Client@")
		End while 
		Progress QUIT (0)
		ALERT:C41("Analyse terminée.")
		MESSAGES ON:C181
	End if 
End if 
