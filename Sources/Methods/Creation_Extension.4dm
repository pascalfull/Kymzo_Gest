//%attributes = {"invisible":true}
  // Méthode : Creation_Extension
  // Date et heure : 08/03/20, 22:19:31
  // Modifié le : 05/04/20, 16:27:50

C_LONGINT:C283($i;$Rech;$Process)
C_TEXT:C284($DossierReferent;$nomComplet;$msg)
C_OBJECT:C1216($entExtension;$entBiblioFichier;$entPref)
ARRAY TEXT:C222($t_ext;0)
ARRAY TEXT:C222($t_ext_Exist;0)

If (Count parameters:C259=0)
	$msg:="Voulez-vous réellement analyser la base de données pour créer les extensions de fichiers manquantes ?"
	CONFIRM:C162($msg;"Continuer";"Annuler")
	If (OK=1)
		$Process:=New process:C317(Current method name:C684;0;"Creation des extensions des fichiers";0;*)
		If (Process state:C330($Process)>0)
			RESUME PROCESS:C320($Process)
			SHOW PROCESS:C325($Process)
			BRING TO FRONT:C326($Process)
		End if 
	End if 
Else 
	InitProcess 
	$entPref:=ds:C1482.Preference.all().first()
	$DossierReferent:=$entPref.Chemin_Dossier_Client
	READ WRITE:C146([Extension:4])
	ALL RECORDS:C47([Extension:4])
	SELECTION TO ARRAY:C260([Extension:4]Nom:2;$t_ext_Exist)
	QUERY:C277([Bibliotheque:1];[Bibliotheque:1]Type:2=0;*)
	QUERY:C277([Bibliotheque:1]; & ;[Bibliotheque:1]DossierFichier:12=False:C215)
	DISTINCT VALUES:C339([Bibliotheque:1]ExtensionFichier:10;$t_ext)
	For ($i;1;Size of array:C274($t_ext))
		$Rech:=Find in array:C230($t_ext_Exist;$t_ext{$i})
		If ($Rech=-1)
			$entBiblioFichier:=ds:C1482.Bibliotheque.query("ExtensionFichier = :1";$t_ext{$i}).first()
			$nomComplet:=$DossierReferent+$entBiblioFichier.Path_
			If (Test path name:C476($nomComplet)=Est un document:K24:1)
				$entExtension:=ds:C1482.Extension.new()
				$entExtension.Nom:=$t_ext{$i}
				$entExtension.icon:=File:C1566($nomComplet;fk chemin plateforme:K87:2).getIcon(256)
				$entExtension.Lisibe_4D:=Is picture file:C1113($nomComplet)
				$entExtension.save()
			End if 
		End if 
	End for 
	QUERY:C277([Bibliotheque:1];[Bibliotheque:1]Type:2=0;*)
	QUERY:C277([Bibliotheque:1]; & ;[Bibliotheque:1]DossierFichier:12=True:C214)
	REDUCE SELECTION:C351([Bibliotheque:1];1)
	$Rech:=Find in array:C230($t_ext_Exist;"")
	If ($Rech=-1)
		$entBiblioFichier:=ds:C1482.Bibliotheque.query("DossierFichier = :1";True:C214).first()
		$nomComplet:=$DossierReferent+$entBiblioFichier.Path_
		If (Test path name:C476($nomComplet)=Est un dossier:K24:2)
			$entExtension:=ds:C1482.Extension.new()
			$entExtension.Nom:=""
			$entExtension.icon:=Folder:C1567($nomComplet;fk chemin plateforme:K87:2).getIcon(256)
			$entExtension.save()
		End if 
	End if 
	UNLOAD RECORD:C212([Extension:4])
	READ ONLY:C145([Extension:4])
	ALERT:C41("Analyse terminée.")
End if 