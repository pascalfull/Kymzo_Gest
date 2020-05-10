//%attributes = {"invisible":true}
  // Méthode : Gerer_Bibiotheque
  // Date et heure : 10/03/20, 07:52:43
  // Modifié le : 13/04/20, 23:02:15

C_LONGINT:C283($Process;$Ref_Fen;$g;$h;$d;$b)
C_OBJECT:C1216($entPref)

If (Count parameters:C259=0)
	If (Macintosh option down:C545 | Windows Alt down:C563)
		$Process:=New process:C317(Current method name:C684;0;"Visu Recherche Bibliotheque";0)
	Else 
		$Process:=New process:C317(Current method name:C684;0;"Visu Recherche Bibliotheque";0;*)
		If (Process state:C330($Process)>0)
			RESUME PROCESS:C320($Process)
			SHOW PROCESS:C325($Process)
			BRING TO FRONT:C326($Process)
		End if 
	End if 
Else 
	InitProcess 
	x_Chargement_Images 
	$entPref:=ds:C1482.Preference.all().first()
	If ($entPref.Reglages.coordD=Null:C1517) | (Shift down:C543)
		$g:=5
		$h:=Menu bar height:C440+20+5
		$d:=Screen width:C187-5
		$b:=Screen height:C188-5
	Else 
		If ($entPref.Reglages.coordD<Screen width:C187) & ($entPref.Reglages.coordB<Screen height:C188)
			$g:=$entPref.Reglages.coordG
			$h:=$entPref.Reglages.coordH
			$d:=$entPref.Reglages.coordD
			$b:=$entPref.Reglages.coordB
		Else 
			$g:=5
			$h:=Menu bar height:C440+20+5
			$d:=Screen width:C187-5
			$b:=Screen height:C188-5
		End if 
	End if 
	$Ref_Fen:=Open window:C153($g;$h;$d;$b;Fenêtre standard:K34:13;"Bibliothèque")
	DIALOG:C40([Bibliotheque:1];"VisuBiblio")
	CLOSE WINDOW:C154($Ref_Fen)
	
End if 
