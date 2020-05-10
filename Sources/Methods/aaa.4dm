//%attributes = {"invisible":true}
  // Méthode : aaa
  // Date et heure : 18/03/20, 12:14:55

C_LONGINT:C283($cpt)
C_TEXT:C284($RefMenu;$RefMenuClient;$RefUUID)
C_OBJECT:C1216($entClient;$entGroupe;$emp;$empClient)

$RefMenu:=Create menu:C408
$entGroupe:=ds:C1482.Groupe.all().orderBy("Type, Nom")
For each ($emp;$entGroupe)
	$entClient:=ds:C1482.Client.query("UUID_Groupe = :1";$emp.UUID).orderBy("Nom")
	If ($entClient.length>0)
		$RefMenuClient:=Create menu:C408
		APPEND MENU ITEM:C411($RefMenuClient;$emp.Nom)
		SET MENU ITEM PARAMETER:C1004($RefMenuClient;-1;$emp.UUID)
		APPEND MENU ITEM:C411($RefMenuClient;"-")
		For each ($empClient;$entClient)
			APPEND MENU ITEM:C411($RefMenuClient;$empClient.Nom)
			SET MENU ITEM PARAMETER:C1004($RefMenuClient;-1;$empClient.UUID)
		End for each 
		APPEND MENU ITEM:C411($RefMenu;$emp.Nom;$RefMenuClient)
	End if 
End for each 
$entClient:=ds:C1482.Client.all().orderBy("Nom")
If ($entClient.length>0)
	For each ($empClient;$entClient)
		If (Not:C34(GEN_UuidValide ($empClient.UUID_Groupe)))
			If ($cpt=0)
				APPEND MENU ITEM:C411($RefMenu;"-")
				$cpt:=1
			End if 
			APPEND MENU ITEM:C411($RefMenu;$empClient.Nom)
			SET MENU ITEM PARAMETER:C1004($RefMenu;-1;$empClient.UUID)
		End if 
	End for each 
End if 
$RefUUID:=Dynamic pop up menu:C1006($RefMenu)


If (False:C215)
	C_LONGINT:C283($largImg;$hautImg;$largeurCol;$hautTexte;$tailleTypo)
	C_REAL:C285($Coef;$largBloc;$hautBloc;$coordX_Img;$coordY_Img)
	C_TEXT:C284($Texte;$Ref_SVG;$Ref_SVG_Image;$Ref_SVG_Texte)
	C_PICTURE:C286($ImageTemp)
	C_OBJECT:C1216($EntExtension)
	
	READ PICTURE FILE:C678("";$ImageTemp)
	If (OK=1)
		$EntExtension:=ds:C1482.Extension.query("Nom = :1";".jpeg").first()
		$largeurCol:=640
		$hautTexte:=30
		$Ref_SVG:=SVG_New ($largeurCol;$largeurCol)
		$Texte:=GEN_DOC_NomCourt (document)+"\r10/04/2020 - 2272 x 1704"
		PICTURE PROPERTIES:C457($ImageTemp;$largImg;$hautImg)
		If ($largImg>$hautImg)
			$Coef:=$hautImg/$largImg
			$largBloc:=$largeurCol-2
			$hautBloc:=Round:C94($largBloc*$Coef;1)
			$coordX_Img:=1
			$coordY_Img:=Round:C94(($largeurCol-2-$hautTexte-$hautBloc)/2;1)
		Else 
			$Coef:=$largImg/$hautImg
			$hautBloc:=$largeurCol-2-$hautTexte
			$largBloc:=Round:C94($hautBloc*$Coef;1)
			$coordY_Img:=1
			$coordX_Img:=Round:C94(($largeurCol-2-$largBloc)/2;1)
		End if 
		CREATE THUMBNAIL:C679($ImageTemp;$ImageTemp;$largBloc;$hautBloc;Proportionnelle centrée:K6:6)
		$tailleTypo:=10
		$Ref_SVG_Image:=SVG_New_embedded_image ($Ref_SVG;$ImageTemp;$coordX_Img;$coordY_Img)
		$Ref_SVG_Texte:=SVG_New_textArea ($Ref_SVG;$Texte;1;$largeurCol-1-$hautTexte;$largeurCol-2;$hautTexte;"Helvetica Neue";$tailleTypo;Normal:K14:1;Aligné au centre:K42:3)
		$ImageTemp:=$EntExtension.icon
		CREATE THUMBNAIL:C679($ImageTemp;$ImageTemp;50;50;Proportionnelle centrée:K6:6)
		CREATE THUMBNAIL:C679($ImageTemp;$ImageTemp;70;70;Proportionnelle centrée:K6:6)
		$Ref_SVG_Image:=SVG_New_embedded_image ($Ref_SVG;$ImageTemp;-8;0)
		$ImageTemp:=SVG_Export_to_picture ($Ref_SVG)
		WRITE PICTURE FILE:C680("";$ImageTemp)
	End if 
End if 

If (False:C215)
	C_COLLECTION:C1488($collecExtension;$collecExtensionValid;$collecBibliothesque)
	ARRAY TEXT:C222($t_Ext_ImgLisible;0)
	ARRAY TEXT:C222($t_Ext_Valid;0)
	ARRAY TEXT:C222($t_Dos_Nom;0)
	
	$collecExtension:=ds:C1482.Extension.query("NePasAnalyser = :1";False:C215).distinct("Nom")
	COLLECTION TO ARRAY:C1562($collecExtension;$t_Ext_Valid)
	$collecExtensionValid:=ds:C1482.Extension.query("NePasAnalyser = :1 & Lisibe_4D = :2";False:C215;True:C214).distinct("Nom")
	COLLECTION TO ARRAY:C1562($collecExtensionValid;$t_Ext_ImgLisible)
	
	$collecBibliothesque:=ds:C1482.Bibliotheque.query("Type = :1 & DossierFichier = :2";0;True:C214).distinct("Path_")
	COLLECTION TO ARRAY:C1562($collecBibliothesque;$t_Dos_Nom)
End if 

If (False:C215)
	C_OBJECT:C1216($entClient)
	C_COLLECTION:C1488($collecClient)
	ARRAY TEXT:C222($t_Client_Nom;0)
	ARRAY TEXT:C222($t_Client_UUID;0)
	$entClient:=ds:C1482.Client.query("Chemin_Dossier # :1";"")
	$collecClient:=New collection:C1472
	$collecClient:=$entClient.toCollection()
	  //$collecClient.insert(0;"Tous")
	  //$collecClient.insert(-1;"-")
	COLLECTION TO ARRAY:C1562($collecClient;$t_Client_Nom;"Nom";$t_Client_UUID;"UUID")
End if 

If (False:C215)
	C_DATE:C307($date)
	C_PICTURE:C286($Image)
	C_TEXT:C284($texte)
	ARRAY TEXT:C222($tTkeywords;0)
	
	READ PICTURE FILE:C678("";$Image)
	If (OK=1)
		GET PICTURE METADATA:C1122($Image;IPTC Keywords:K68:118;$tTkeywords)  // Mot clé
		GET PICTURE METADATA:C1122($Image;IPTC category:K68:101;$tTkeywords)  // Catégorie
		GET PICTURE METADATA:C1122($Image;IPTC Byline:K68:98;$tTkeywords)  // Créateur
		GET PICTURE METADATA:C1122($Image;IPTC Byline title:K68:99;$tTkeywords)  // Profession créateur
		GET PICTURE METADATA:C1122($Image;IPTC caption abstract:K68:100;$tTkeywords)  // Légende description
		GET PICTURE METADATA:C1122($Image;IPTC copyright notice:K68:106;$texte)  // Mention de copyright
		GET PICTURE METADATA:C1122($Image;IPTC credit:K68:109;$texte)  // Fournisseur
		GET PICTURE METADATA:C1122($Image;IPTC headline:K68:115;$texte)  // Titre
		GET PICTURE METADATA:C1122($Image;IPTC city:K68:102;$texte)  // Ville
		GET PICTURE METADATA:C1122($Image;IPTC contact:K68:103;$tTkeywords)  //
		GET PICTURE METADATA:C1122($Image;IPTC content location code:K68:104;$tTkeywords)  //
		GET PICTURE METADATA:C1122($Image;IPTC content location code:K68:104;$tTkeywords)  //
		GET PICTURE METADATA:C1122($Image;IPTC country primary location code:K68:107;$texte)  //
		GET PICTURE METADATA:C1122($Image;IPTC country primary location name:K68:108;$texte)  // Pays Région
		GET PICTURE METADATA:C1122($Image;IPTC edit status:K68:112;$texte)  //
		GET PICTURE METADATA:C1122($Image;IPTC fixture identifier:K68:114;$texte)  //
		GET PICTURE METADATA:C1122($Image;IPTC Image type:K68:117;$texte)  //
		GET PICTURE METADATA:C1122($Image;IPTC Object attribute reference:K68:120;$texte)  //
		GET PICTURE METADATA:C1122($Image;IPTC Object cycle:K68:121;$texte)  //
		GET PICTURE METADATA:C1122($Image;IPTC Object name:K68:122;$texte)  // Titre
		GET PICTURE METADATA:C1122($Image;IPTC source:K68:129;$texte)  //
		GET PICTURE METADATA:C1122($Image;IPTC special instructions:K68:130;$texte)  //
		GET PICTURE METADATA:C1122($Image;IPTC sub location:K68:132;$texte)  //
		GET PICTURE METADATA:C1122($Image;IPTC subject reference:K68:133;$texte)  //
		GET PICTURE METADATA:C1122($Image;IPTC supplemental category:K68:134;$tTkeywords)  //
		GET PICTURE METADATA:C1122($Image;IPTC Writer editor:K68:136;$tTkeywords)  //
		GET PICTURE METADATA:C1122($Image;IPTC date time created:K68:110;$texte)  //
		GET PICTURE METADATA:C1122($Image;IPTC date time created:K68:110;$date)  //
	End if 
End if 