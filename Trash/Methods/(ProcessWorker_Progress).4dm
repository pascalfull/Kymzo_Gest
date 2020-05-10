//%attributes = {"invisible":true}
  // Méthode : ProcessWorker_Progress
  // Date et heure : 08/04/20, 23:27:40

C_LONGINT:C283($process;$procStatut;$procTemps;$numProcessAppel)
C_BOOLEAN:C305($continuer)
C_TEXT:C284($procNom;$message)

$procNom:=$1
$message:=$2
$numProcessAppel:=$3
DELAY PROCESS:C323($process;2*60)
$process:=Process number:C372($procNom)
If ($process#0)
	$continuer:=True:C214
	While ($continuer)
		DELAY PROCESS:C323(Current process:C322;5*60)
		PROCESS PROPERTIES:C336($numProcessAppel;$procNom;$procStatut;$procTemps)
		If ($procStatut=Détruit:K13:1)
			PROCESS PROPERTIES:C336($process;$procNom;$procStatut;$procTemps)
			If ($procStatut=En attente événement:K13:9)
				DELAY PROCESS:C323(Current process:C322;10*60)
				PROCESS PROPERTIES:C336($process;$procNom;$procStatut;$procTemps)
				If ($procStatut=En attente événement:K13:9)
					$continuer:=False:C215
				End if 
			End if 
		End if 
	End while 
	ALERT:C41($message)
End if 

