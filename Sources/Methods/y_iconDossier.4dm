//%attributes = {"invisible":true}
  // Méthode : y_iconDossier
  // Date et heure : 13/04/20, 18:36:57

C_LONGINT:C283($cpt)
C_TEXT:C284($chemin)
C_PICTURE:C286($imageTempo)

If (This:C1470.PathParent="")
	$imageTempo:=vImgDossier
Else 
	$chemin:=This:C1470.PathParent
	$cpt:=0
	While ($chemin#"")
		$cpt:=$cpt+1
		$chemin:=GEN_DOC_DossierSuperieur ($chemin)
	End while 
	Case of 
		: ($cpt=1)
			$imageTempo:=vImgDossier1
			
		: ($cpt=2)
			$imageTempo:=vImgDossier2
			
		: ($cpt=3)
			$imageTempo:=vImgDossier3
			
		: ($cpt=4)
			$imageTempo:=vImgDossier4
			
		: ($cpt=5)
			$imageTempo:=vImgDossier5
			
		Else 
			$imageTempo:=vImgDossier6
			
	End case 
	
End if 
$0:=$imageTempo