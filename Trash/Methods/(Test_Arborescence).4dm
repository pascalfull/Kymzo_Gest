//%attributes = {"invisible":true}
  // Méthode : Test_Arborescence
  // Date et heure : 13/04/20, 16:16:01

C_LONGINT:C283($Ref_Fen)
C_OBJECT:C1216($entClient;$entBiblio;$emp;$entDossierEnfant)

READ PICTURE FILE:C678(Get 4D folder:C485(Dossier Resources courant:K5:16)+"images"+Séparateur dossier:K24:12+"dossierFermer.png";vImgDossierFermer)
READ PICTURE FILE:C678(Get 4D folder:C485(Dossier Resources courant:K5:16)+"images"+Séparateur dossier:K24:12+"dossierOuvert.png";vImgDossierOuvert)
READ PICTURE FILE:C678(Get 4D folder:C485(Dossier Resources courant:K5:16)+"images"+Séparateur dossier:K24:12+"dossier.png";vImgDossier)
READ PICTURE FILE:C678(Get 4D folder:C485(Dossier Resources courant:K5:16)+"images"+Séparateur dossier:K24:12+"dossier1.png";vImgDossier1)
READ PICTURE FILE:C678(Get 4D folder:C485(Dossier Resources courant:K5:16)+"images"+Séparateur dossier:K24:12+"dossier2.png";vImgDossier2)
READ PICTURE FILE:C678(Get 4D folder:C485(Dossier Resources courant:K5:16)+"images"+Séparateur dossier:K24:12+"dossier3.png";vImgDossier3)
READ PICTURE FILE:C678(Get 4D folder:C485(Dossier Resources courant:K5:16)+"images"+Séparateur dossier:K24:12+"dossier4.png";vImgDossier4)
READ PICTURE FILE:C678(Get 4D folder:C485(Dossier Resources courant:K5:16)+"images"+Séparateur dossier:K24:12+"dossier5.png";vImgDossier5)
READ PICTURE FILE:C678(Get 4D folder:C485(Dossier Resources courant:K5:16)+"images"+Séparateur dossier:K24:12+"dossier6.png";vImgDossier6)
$entClient:=ds:C1482.Client.query("Nom = :1";"Bistrot@").orderBy("Nom").first()
entBiblio:=ds:C1482.Bibliotheque.query("Type = :1 & UUID_Client = :2 & DossierFichier = :3";0;$entClient.UUID;True:C214).orderBy("Path_")  //.orderBy("Path_, DossierFichier")
$Ref_Fen:=Open form window:C675([Bibliotheque:1];"Test";Fenêtre standard:K34:13)
DIALOG:C40([Bibliotheque:1];"Test")
CLOSE WINDOW:C154($Ref_Fen)

  //Pour chaque ($emp;$EntDossierBiblio)
  //$entDossierEnfant:=$entBiblio.query("PathParent = :1";$emp.Path_)

  //Fin de chaque 
