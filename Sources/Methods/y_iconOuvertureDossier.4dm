//%attributes = {"invisible":true}
  // Méthode : y_iconOuvertureDossier
  // Date et heure : 13/04/20, 16:38:18

C_PICTURE:C286($imageTempo)
C_OBJECT:C1216($entDossierEnfant;$EntDossierBiblio)

$entDossierEnfant:=entDossierBiblio.query("PathParent = :1";This:C1470.Path_)
If ($entDossierEnfant.length>0)
	$EntDossierBiblio:=Form:C1466.docs
	If ($EntDossierBiblio.contains($entDossierEnfant.first()))
		$imageTempo:=vImgDossierOuvert
	Else 
		$imageTempo:=vImgDossierFermer
	End if 
End if 
$0:=$imageTempo
