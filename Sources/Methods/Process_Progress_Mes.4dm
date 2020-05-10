//%attributes = {"invisible":true}
  // Méthode : Process_Progress_Mes
  // Date et heure : 26/04/20, 15:49:20

C_LONGINT:C283($idProgress)
C_REAL:C285($valProgression)
C_TEXT:C284($message)

$idProgress:=$1
$valProgression:=$2
$message:=$3
Progress SET PROGRESS ($idProgress;$valProgression;$message)
