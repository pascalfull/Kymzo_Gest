//%attributes = {"invisible":true,"preemptive":"capable"}
  // Méthode : Analyse_Dossier
  // Date et heure : 24/04/20, 01:27:30
  // Modifié le : 26/04/20, 17:08:32

C_LONGINT:C283($nbDossier;$nbFichier;$i;$Rech;$process;$idProgress)
C_BOOLEAN:C305($continuer)
C_TEXT:C284($DossierReferent;$DossierParent;$UUID_Client)
C_OBJECT:C1216($entBiblioDossier;$entBiblioFichier;$entClient)
C_COLLECTION:C1488($allFolders;$allFiles;$collecExtension;$collecExtensionValid;$collecBibliothesque)
ARRAY TEXT:C222($t_Dos_Nom;0)
ARRAY TEXT:C222($t_Ext_ImgLisible;0)
ARRAY TEXT:C222($t_Ext_Valid;0)

READ ONLY:C145(*)
Compiler 
Compiler_Arrays 

$UUID_Client:=$1
$idProgress:=$2
$entClient:=ds:C1482.Client.query("UUID = :1";$UUID_Client).first()
$DossierReferent:=$entClient.Chemin_Dossier
$allFolders:=Folder:C1567($DossierReferent;fk chemin plateforme:K87:2).folders(fk récursif:K87:7+fk ignorer invisibles:K87:22)
$allFiles:=Folder:C1567($DossierReferent;fk chemin plateforme:K87:2).files(fk récursif:K87:7+fk ignorer invisibles:K87:22)
$nbDossier:=$allFolders.length
$nbFichier:=$allFiles.length
If ($nbDossier>0) | ($nbFichier>0)
	If ($nbDossier>0)
		$collecBibliothesque:=ds:C1482.Bibliotheque.query("Type = :1 & DossierFichier = :2 & UUID_Client = :3";0;True:C214;$entClient.UUID).distinct("Path_")
		COLLECTION TO ARRAY:C1562($collecBibliothesque;$t_Dos_Nom)
		  //CHERCHER([Bibliotheque];[Bibliotheque]Type=0;*)
		  //CHERCHER([Bibliotheque]; & ;[Bibliotheque]DossierFichier=Vrai)
		  //SÉLECTION VERS TABLEAU([Bibliotheque]Path_;$t_Dos_Nom)
		For ($i;1;$nbDossier)
			$DossierParent:=Replace string:C233($allFolders[$i-1].platformPath;$DossierReferent;"")
			$Rech:=Find in array:C230($t_Dos_Nom;$DossierParent)
			If ($Rech=-1)
				$entBiblioDossier:=ds:C1482.Bibliotheque.new()
				$entBiblioDossier.Type:=0
				$entBiblioDossier.UUID_Client:=$entClient.UUID
				$entBiblioDossier.Nom:=$allFolders[$i-1].name
				$entBiblioDossier.DateCreation:=$allFolders[$i-1].creationDate
				$entBiblioDossier.HeureCreation:=Time:C179($allFolders[$i-1].creationTime)
				$entBiblioDossier.DateModification:=$allFolders[$i-1].modificationDate
				$entBiblioDossier.HeureModification:=Time:C179($allFolders[$i-1].modificationTime)
				$entBiblioDossier.Path_:=$DossierParent
				$entBiblioDossier.PathParent:=_GEN_DOC_DossierSuperieur ($DossierParent)
				$entBiblioDossier.DossierFichier:=True:C214
				$entBiblioDossier.save()
			End if 
		End for 
	End if 
	If ($nbFichier>0)
		$collecExtension:=ds:C1482.Extension.query("NePasAnalyser = :1";False:C215).distinct("Nom")
		COLLECTION TO ARRAY:C1562($collecExtension;$t_Ext_Valid)
		$collecExtensionValid:=ds:C1482.Extension.query("NePasAnalyser = :1 & Lisibe_4D = :2";False:C215;True:C214).distinct("Nom")
		COLLECTION TO ARRAY:C1562($collecExtensionValid;$t_Ext_ImgLisible)
		$collecBibliothesque:=ds:C1482.Bibliotheque.query("Type = :1 & DossierFichier = :2 & UUID_Client = :3";0;False:C215;$entClient.UUID).distinct("Path_")
		COLLECTION TO ARRAY:C1562($collecBibliothesque;$t_Dos_Nom)
		  //CHERCHER([Bibliotheque];[Bibliotheque]Type=0;*)
		  //CHERCHER([Bibliotheque]; & ;[Bibliotheque]DossierFichier=Faux)
		  //SÉLECTION VERS TABLEAU([Bibliotheque]Path_;$t_Dos_Nom)
		  // \rCréation des imagettes en cours.
		For ($i;1;$nbFichier)
			If ($i%10=0)
				$process:=New process:C317("Process_Progress_Mes";0;"Progress Message";$idProgress;$i/$nbFichier;"Création des fichiers et des vignettes...")
			End if 
			  //Progress SET PROGRESS ($idProgress;$i/$nbFichier;"Création des fichiers et des vignettes...")
			$continuer:=False:C215
			  // Contrôle si l'extension du fichier est à traiter
			If (Find in array:C230($t_Ext_Valid;$allFiles[$i-1].extension)#-1)
				$DossierParent:=Replace string:C233($allFiles[$i-1].platformPath;$DossierReferent;"")
				$Rech:=Find in array:C230($t_Dos_Nom;$DossierParent)
				If ($Rech=-1)
					$entBiblioFichier:=ds:C1482.Bibliotheque.new()
					$entBiblioFichier.Type:=0
					$entBiblioFichier.UUID_Client:=$entClient.UUID
					$entBiblioFichier.Nom:=$allFiles[$i-1].name
					$entBiblioFichier.Path_:=$DossierParent
					$entBiblioFichier.PathParent:=_GEN_DOC_DossierSuperieur ($DossierParent)
					$entBiblioFichier.ExtensionFichier:=$allFiles[$i-1].extension
					$entBiblioFichier.DossierFichier:=False:C215
					$continuer:=True:C214
				Else 
					$entBiblioFichier:=ds:C1482.Bibliotheque.query("Path_ = :1";$DossierParent).first()
					If ($entBiblioFichier.DateCreation#$allFiles[$i-1].creationDate) | \
						($entBiblioFichier.HeureCreation#Time:C179($allFiles[$i-1].creationTime)) | \
						($entBiblioFichier.DateModification#$allFiles[$i-1].modificationDate) | \
						($entBiblioFichier.HeureModification#Time:C179($allFiles[$i-1].modificationTime))
						$continuer:=True:C214
					End if 
				End if 
				If ($continuer)
					$entBiblioFichier.DateCreation:=$allFiles[$i-1].creationDate
					$entBiblioFichier.HeureCreation:=Time:C179($allFiles[$i-1].creationTime)
					$entBiblioFichier.DateModification:=$allFiles[$i-1].modificationDate
					$entBiblioFichier.HeureModification:=Time:C179($allFiles[$i-1].modificationTime)
					$entBiblioFichier.PoidsFichier:=$allFiles[$i-1].size
					  //$entBiblioFichier.ATraiter:=Vrai
					  //$Rech:=Chercher dans tableau($t_Ext_ImgLisible;$entBiblioFichier.ExtensionFichier)
					  //Si ($Rech#-1)
					Creation_Vignette ($entBiblioFichier;$entClient)
					  //Fin de si 
					$entBiblioFichier.save()
				End if 
			End if 
		End for 
	End if 
End if 
