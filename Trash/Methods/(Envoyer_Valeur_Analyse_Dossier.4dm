//%attributes = {"invisible":true}
  // Méthode : Envoyer_Valeur_Analyse_Dossier
  // Date et heure : 26/04/20, 15:59:55

C_LONGINT:C283($numProcessAppellant)
C_BOOLEAN:C305($continuer)

$numProcessAppellant:=1
$continuer:=False:C215

RESUME PROCESS:C320($numProcessAppellant)
SET PROCESS VARIABLE:C370($numProcessAppellant;vEnAttente;$continuer)
