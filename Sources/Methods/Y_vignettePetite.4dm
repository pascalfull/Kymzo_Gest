//%attributes = {"invisible":true}
  // Méthode : Y_vignettePetite
  // Date et heure : 21/03/20, 15:51:10

C_PICTURE:C286($ImageVide;$Image)
C_OBJECT:C1216($entVignette)

If (This:C1470.DossierFichier=False:C215)
	$entVignette:=ds:C1482.Vignette.query("UUID_Bibliotheque = :1";This:C1470.UUID).first()
	If ($entVignette=Null:C1517)
		$Image:=$ImageVide
	Else 
		$Image:=$entVignette.Vignette_1
	End if 
Else 
	$Image:=$ImageVide
End if 
$0:=$Image