//%attributes = {"invisible":true}
  //GEN_DOC_DossierSuperieur
  //Créé par Stanislas Caron le 11/01/10
  //Renvoie le dossier supérieur du chemin d'accès passé
  //optionnel, on passe le séparateur souhaité sinon c'est celui de la plateforme courante

C_TEXT:C284($1;$chemin)
C_TEXT:C284($2;$sep)
C_LONGINT:C283($3;$nbNiveaux)
C_TEXT:C284($0;$dossier)
$chemin:=$1
If (Count parameters:C259>=2)
	$sep:=$2
Else 
	$sep:=""
End if 
If (Count parameters:C259>=3)
	$nbNiveaux:=$3
Else 
	$nbNiveaux:=0
End if 
$dossier:=""

C_LONGINT:C283($pos;$niveau)

If ($sep="")
	$sep:=Séparateur dossier:K24:12
End if 
If ($nbNiveaux=0)
	$nbNiveaux:=1
End if 
$sep:="\\"+$sep
$niveau:=0
While ($niveau<$nbNiveaux) & (Match regex:C1019($sep+"[^"+$sep+"]+"+$sep+"?$";$chemin;1;$pos))
	$dossier:=Substring:C12($chemin;1;$pos)
	$niveau:=$niveau+1
	$chemin:=$dossier
End while 

$0:=$dossier
