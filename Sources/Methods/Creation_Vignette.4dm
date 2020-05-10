//%attributes = {"invisible":true,"preemptive":"capable"}
  // Méthode : Creation_Vignette
  // Date et heure : 08/03/20, 17:09:17
  // Modifié le : 17/04/20, 09:04:23

C_LONGINT:C283($largeur;$hauteur;$largeurCol;$i;$hautTexte;$tailleTypo;$dimIconFichier)
C_REAL:C285($Coef;$hautBloc;$largBloc;$coordX_Img;$coordY_Img)
C_BOOLEAN:C305($creationFicheLien)
C_TEXT:C284($DossierReferent;$nomComplet;$mentionCopyright;$fournisseur;$titre1;$titre2;$paysRegion;$ville;$Texte;\
$Ref_SVG;$Ref_SVG_Image;$Ref_SVG_Texte)
C_PICTURE:C286($image;$ImageCreer;$ImageTemp)
C_OBJECT:C1216($entBiblioFichier;$entBiblioVignette;$entMotClef;$entLienMotClef;$entClient;$entExtension)
ARRAY TEXT:C222($t_Tkeywords;0)
ARRAY TEXT:C222($t_Categorie;0)
ARRAY TEXT:C222($t_Createur;0)
ARRAY TEXT:C222($t_ProfCreateur;0)
ARRAY TEXT:C222($t_LegendeDescription;0)

$entBiblioFichier:=$1
$entClient:=$2
$entBiblioVignette:=ds:C1482.Vignette.query("UUID_Bibliotheque = :1";$entBiblioFichier.UUID).first()
If ($entBiblioVignette=Null:C1517)
	$entBiblioVignette:=ds:C1482.Vignette.new()
	$entBiblioVignette.UUID_Bibliotheque:=$entBiblioFichier.UUID
End if 
$DossierReferent:=$entClient.Chemin_Dossier
$nomComplet:=$DossierReferent+$entBiblioFichier.Path_
If (Test path name:C476($nomComplet)=Est un document:K24:1)
	$hautTexte:=30
	$tailleTypo:=10
	  // Composition du nom du fichier + date ≠ Dimensions x et y
	$Texte:=$entBiblioFichier.Nom+$entBiblioFichier.ExtensionFichier
	$Texte:=$Texte+"\r"+String:C10($entBiblioFichier.DateCreation)
	  // Recherche de l'extension
	$entExtension:=ds:C1482.Extension.query("Nom = :1";$entBiblioFichier.ExtensionFichier).first()
	READ PICTURE FILE:C678($nomComplet;$image)
	If ($entExtension.Lisibe_4D)
		  // Mots Clef
		GET PICTURE METADATA:C1122($Image;IPTC Keywords:K68:118;$t_Tkeywords)  // Mots-clés
		GET PICTURE METADATA:C1122($Image;IPTC category:K68:101;$t_Categorie)  // Catégorie
		GET PICTURE METADATA:C1122($Image;IPTC Byline:K68:98;$t_Createur)  // Créateur
		GET PICTURE METADATA:C1122($Image;IPTC Byline title:K68:99;$t_ProfCreateur)  // Profession créateur
		GET PICTURE METADATA:C1122($Image;IPTC caption abstract:K68:100;$t_LegendeDescription)  // Légende description ex : Pointe de Chaucre vue du ciel
		GET PICTURE METADATA:C1122($Image;IPTC copyright notice:K68:106;$mentionCopyright)  // Mention de copyright
		GET PICTURE METADATA:C1122($Image;IPTC credit:K68:109;$fournisseur)  // Fournisseur
		GET PICTURE METADATA:C1122($Image;IPTC headline:K68:115;$titre1)  // Titre
		GET PICTURE METADATA:C1122($Image;IPTC Object name:K68:122;$titre2)  // Titre
		GET PICTURE METADATA:C1122($Image;IPTC city:K68:102;$ville)  // Ville
		GET PICTURE METADATA:C1122($Image;IPTC country primary location name:K68:108;$paysRegion)  // Pays Région
		If (Size of array:C274($t_Tkeywords)>0) | (Size of array:C274($t_Categorie)>0) | (Size of array:C274($t_Createur)>0) | \
			(Size of array:C274($t_LegendeDescription)>0) | ($fournisseur#"") | ($mentionCopyright#"") | ($titre1#"") | \
			($titre2#"") | ($paysRegion#"") | ($ville#"")
			  // Categorie = "Mot-clé"
			For ($i;1;Size of array:C274($t_Tkeywords))
				If (Length:C16($t_Tkeywords{$i})>=3)
					$creationFicheLien:=False:C215
					$entMotClef:=ds:C1482.Mot_Clef.query("Libelle = :1";$t_Tkeywords{$i}).first()
					If ($entMotClef=Null:C1517)
						$entMotClef:=ds:C1482.Mot_Clef.new()
						$entMotClef.Libelle:=$t_Tkeywords{$i}
						$entMotClef.save()
						$creationFicheLien:=True:C214
					Else 
						$entLienMotClef:=ds:C1482.Biblio_MotClef.query("UUID_Bibliotheque = :1 & UUID_MotClef = :2";$entBiblioFichier.UUID;$entMotClef.UUID).first()
						If ($entLienMotClef=Null:C1517)
							$creationFicheLien:=True:C214
						End if 
					End if 
					If ($creationFicheLien)
						$entLienMotClef:=ds:C1482.Biblio_MotClef.new()
						$entLienMotClef.UUID_Bibliotheque:=$entBiblioFichier.UUID
						$entLienMotClef.UUID_MotClef:=$entMotClef.UUID
						$entLienMotClef.save()
					End if 
				End if 
			End for 
			  // Categorie = "Catégorie"
			For ($i;1;Size of array:C274($t_Categorie))
				If (Length:C16($t_Categorie{$i})>=3)
					$creationFicheLien:=False:C215
					$entMotClef:=ds:C1482.Mot_Clef.query("Libelle = :1";$t_Categorie{$i}).first()
					If ($entMotClef=Null:C1517)
						$entMotClef:=ds:C1482.Mot_Clef.new()
						$entMotClef.Categorie:=True:C214
						$entMotClef.Libelle:=$t_Categorie{$i}
						$entMotClef.save()
						$creationFicheLien:=True:C214
					Else 
						If (Not:C34($entMotClef.Categorie))
							$entMotClef.Categorie:=True:C214
							$entMotClef.save()
						End if 
						$entLienMotClef:=ds:C1482.Biblio_MotClef.query("UUID_Bibliotheque = :1 & UUID_MotClef = :2";$entBiblioFichier.UUID;$entMotClef.UUID).first()
						If ($entLienMotClef=Null:C1517)
							$creationFicheLien:=True:C214
						End if 
					End if 
					If ($creationFicheLien)
						$entLienMotClef:=ds:C1482.Biblio_MotClef.new()
						$entLienMotClef.UUID_Bibliotheque:=$entBiblioFichier.UUID
						$entLienMotClef.UUID_MotClef:=$entMotClef.UUID
						$entLienMotClef.save()
					End if 
				End if 
			End for 
			  // Categorie = "Créateur"
			For ($i;1;Size of array:C274($t_Createur))
				If (Length:C16($t_Createur{$i})>=3)
					$creationFicheLien:=False:C215
					$entMotClef:=ds:C1482.Mot_Clef.query("Libelle = :1";$t_Createur{$i}).first()
					If ($entMotClef=Null:C1517)
						$entMotClef:=ds:C1482.Mot_Clef.new()
						$entMotClef.Createur:=True:C214
						$entMotClef.Libelle:=$t_Createur{$i}
						$entMotClef.save()
						$creationFicheLien:=True:C214
					Else 
						If (Not:C34($entMotClef.Createur))
							$entMotClef.Createur:=True:C214
							$entMotClef.save()
						End if 
						$entLienMotClef:=ds:C1482.Biblio_MotClef.query("UUID_Bibliotheque = :1 & UUID_MotClef = :2";$entBiblioFichier.UUID;$entMotClef.UUID).first()
						If ($entLienMotClef=Null:C1517)
							$creationFicheLien:=True:C214
						End if 
					End if 
					If ($creationFicheLien)
						$entLienMotClef:=ds:C1482.Biblio_MotClef.new()
						$entLienMotClef.UUID_Bibliotheque:=$entBiblioFichier.UUID
						$entLienMotClef.UUID_MotClef:=$entMotClef.UUID
						$entLienMotClef.save()
					End if 
				End if 
			End for 
			  // Categorie = "Profession créateur"
			For ($i;1;Size of array:C274($t_ProfCreateur))
				If (Length:C16($t_ProfCreateur{$i})>=3)
					$creationFicheLien:=False:C215
					$entMotClef:=ds:C1482.Mot_Clef.query("Libelle = :1";$t_ProfCreateur{$i}).first()
					If ($entMotClef=Null:C1517)
						$entMotClef:=ds:C1482.Mot_Clef.new()
						$entMotClef.Prof_Createur:=True:C214
						$entMotClef.Libelle:=$t_ProfCreateur{$i}
						$entMotClef.save()
						$creationFicheLien:=True:C214
					Else 
						If (Not:C34($entMotClef.Prof_Createur))
							$entMotClef.Prof_Createur:=True:C214
							$entMotClef.save()
						End if 
						$entLienMotClef:=ds:C1482.Biblio_MotClef.query("UUID_Bibliotheque = :1 & UUID_MotClef = :2";$entBiblioFichier.UUID;$entMotClef.UUID).first()
						If ($entLienMotClef=Null:C1517)
							$creationFicheLien:=True:C214
						End if 
					End if 
					If ($creationFicheLien)
						$entLienMotClef:=ds:C1482.Biblio_MotClef.new()
						$entLienMotClef.UUID_Bibliotheque:=$entBiblioFichier.UUID
						$entLienMotClef.UUID_MotClef:=$entMotClef.UUID
						$entLienMotClef.save()
					End if 
				End if 
			End for 
			  // Categorie = "Légende description"
			For ($i;1;Size of array:C274($t_LegendeDescription))
				If (Length:C16($t_LegendeDescription{$i})>=3)
					$creationFicheLien:=False:C215
					$entMotClef:=ds:C1482.Mot_Clef.query("Libelle = :1";$t_LegendeDescription{$i}).first()
					If ($entMotClef=Null:C1517)
						$entMotClef:=ds:C1482.Mot_Clef.new()
						$entMotClef.Legende_Description:=True:C214
						$entMotClef.Libelle:=$t_LegendeDescription{$i}
						$entMotClef.save()
						$creationFicheLien:=True:C214
					Else 
						If (Not:C34($entMotClef.Legende_Description))
							$entMotClef.Legende_Description:=True:C214
							$entMotClef.save()
						End if 
						$entLienMotClef:=ds:C1482.Biblio_MotClef.query("UUID_Bibliotheque = :1 & UUID_MotClef = :2";$entBiblioFichier.UUID;$entMotClef.UUID).first()
						If ($entLienMotClef=Null:C1517)
							$creationFicheLien:=True:C214
						End if 
					End if 
					If ($creationFicheLien)
						$entLienMotClef:=ds:C1482.Biblio_MotClef.new()
						$entLienMotClef.UUID_Bibliotheque:=$entBiblioFichier.UUID
						$entLienMotClef.UUID_MotClef:=$entMotClef.UUID
						$entLienMotClef.save()
					End if 
				End if 
			End for 
			  // Categorie = "Mention de copyright"
			If ($mentionCopyright#"")
				If (Length:C16($mentionCopyright)>=3)
					$creationFicheLien:=False:C215
					$entMotClef:=ds:C1482.Mot_Clef.query("Libelle = :1";$mentionCopyright).first()
					If ($entMotClef=Null:C1517)
						$entMotClef:=ds:C1482.Mot_Clef.new()
						$entMotClef.Mention_Copy:=True:C214
						$entMotClef.Libelle:=$mentionCopyright
						$entMotClef.save()
						$creationFicheLien:=True:C214
					Else 
						If (Not:C34($entMotClef.Mention_Copy))
							$entMotClef.Mention_Copy:=True:C214
							$entMotClef.save()
						End if 
						$entLienMotClef:=ds:C1482.Biblio_MotClef.query("UUID_Bibliotheque = :1 & UUID_MotClef = :2";$entBiblioFichier.UUID;$entMotClef.UUID).first()
						If ($entLienMotClef=Null:C1517)
							$creationFicheLien:=True:C214
						End if 
					End if 
					If ($creationFicheLien)
						$entLienMotClef:=ds:C1482.Biblio_MotClef.new()
						$entLienMotClef.UUID_Bibliotheque:=$entBiblioFichier.UUID
						$entLienMotClef.UUID_MotClef:=$entMotClef.UUID
						$entLienMotClef.save()
					End if 
				End if 
			End if 
			  // Categorie = "Fournisseur"
			If ($fournisseur#"")
				If (Length:C16($mentionCopyright)>=3)
					$creationFicheLien:=False:C215
					$entMotClef:=ds:C1482.Mot_Clef.query("Libelle = :1";$fournisseur).first()
					If ($entMotClef=Null:C1517)
						$entMotClef:=ds:C1482.Mot_Clef.new()
						$entMotClef.Fournisseur:=True:C214
						$entMotClef.Libelle:=$fournisseur
						$entMotClef.save()
						$creationFicheLien:=True:C214
					Else 
						If (Not:C34($entMotClef.Fournisseur))
							$entMotClef.Fournisseur:=True:C214
							$entMotClef.save()
						End if 
						$entLienMotClef:=ds:C1482.Biblio_MotClef.query("UUID_Bibliotheque = :1 & UUID_MotClef = :2";$entBiblioFichier.UUID;$entMotClef.UUID).first()
						If ($entLienMotClef=Null:C1517)
							$creationFicheLien:=True:C214
						End if 
					End if 
					If ($creationFicheLien)
						$entLienMotClef:=ds:C1482.Biblio_MotClef.new()
						$entLienMotClef.UUID_Bibliotheque:=$entBiblioFichier.UUID
						$entLienMotClef.UUID_MotClef:=$entMotClef.UUID
						$entLienMotClef.save()
					End if 
				End if 
			End if 
			  // Categorie = "Titre"
			If ($titre1#"")
				If (Length:C16($titre1)>=3)
					$creationFicheLien:=False:C215
					$entMotClef:=ds:C1482.Mot_Clef.query("Libelle = :1";$titre1).first()
					If ($entMotClef=Null:C1517)
						$entMotClef:=ds:C1482.Mot_Clef.new()
						$entMotClef.Titre:=True:C214
						$entMotClef.Libelle:=$titre1
						$entMotClef.save()
						$creationFicheLien:=True:C214
					Else 
						If (Not:C34($entMotClef.Titre))
							$entMotClef.Titre:=True:C214
							$entMotClef.save()
						End if 
						$entLienMotClef:=ds:C1482.Biblio_MotClef.query("UUID_Bibliotheque = :1 & UUID_MotClef = :2";$entBiblioFichier.UUID;$entMotClef.UUID).first()
						If ($entLienMotClef=Null:C1517)
							$creationFicheLien:=True:C214
						End if 
					End if 
					If ($creationFicheLien)
						$entLienMotClef:=ds:C1482.Biblio_MotClef.new()
						$entLienMotClef.UUID_Bibliotheque:=$entBiblioFichier.UUID
						$entLienMotClef.UUID_MotClef:=$entMotClef.UUID
						$entLienMotClef.save()
					End if 
				End if 
			End if 
			If ($titre2#"")
				If (Length:C16($titre2)>=3)
					$creationFicheLien:=False:C215
					$entMotClef:=ds:C1482.Mot_Clef.query("Libelle = :1";$titre2).first()
					If ($entMotClef=Null:C1517)
						$entMotClef:=ds:C1482.Mot_Clef.new()
						$entMotClef.Titre:=True:C214
						$entMotClef.Libelle:=$titre2
						$entMotClef.save()
						$creationFicheLien:=True:C214
					Else 
						If (Not:C34($entMotClef.Titre))
							$entMotClef.Titre:=True:C214
							$entMotClef.save()
						End if 
						$entLienMotClef:=ds:C1482.Biblio_MotClef.query("UUID_Bibliotheque = :1 & UUID_MotClef = :2";$entBiblioFichier.UUID;$entMotClef.UUID).first()
						If ($entLienMotClef=Null:C1517)
							$creationFicheLien:=True:C214
						End if 
					End if 
					If ($creationFicheLien)
						$entLienMotClef:=ds:C1482.Biblio_MotClef.new()
						$entLienMotClef.UUID_Bibliotheque:=$entBiblioFichier.UUID
						$entLienMotClef.UUID_MotClef:=$entMotClef.UUID
						$entLienMotClef.save()
					End if 
				End if 
			End if 
			  // Categorie = "Pays région"
			If ($paysRegion#"")
				If (Length:C16($paysRegion)>=3)
					$creationFicheLien:=False:C215
					$entMotClef:=ds:C1482.Mot_Clef.query("Libelle = :1";$paysRegion).first()
					If ($entMotClef=Null:C1517)
						$entMotClef:=ds:C1482.Mot_Clef.new()
						$entMotClef.Pays_Region:=True:C214
						$entMotClef.Libelle:=$paysRegion
						$entMotClef.save()
						$creationFicheLien:=True:C214
					Else 
						If (Not:C34($entMotClef.Pays_Region))
							$entMotClef.Pays_Region:=True:C214
							$entMotClef.save()
						End if 
						$entLienMotClef:=ds:C1482.Biblio_MotClef.query("UUID_Bibliotheque = :1 & UUID_MotClef = :2";$entBiblioFichier.UUID;$entMotClef.UUID).first()
						If ($entLienMotClef=Null:C1517)
							$creationFicheLien:=True:C214
						End if 
					End if 
					If ($creationFicheLien)
						$entLienMotClef:=ds:C1482.Biblio_MotClef.new()
						$entLienMotClef.UUID_Bibliotheque:=$entBiblioFichier.UUID
						$entLienMotClef.UUID_MotClef:=$entMotClef.UUID
						$entLienMotClef.save()
					End if 
				End if 
			End if 
			  // Categorie = "Ville"
			If ($ville#"")
				If (Length:C16($ville)>=3)
					$creationFicheLien:=False:C215
					$entMotClef:=ds:C1482.Mot_Clef.query("Libelle = :1";$ville).first()
					If ($entMotClef=Null:C1517)
						$entMotClef:=ds:C1482.Mot_Clef.new()
						$entMotClef.Ville:=True:C214
						$entMotClef.Libelle:=$ville
						$entMotClef.save()
						$creationFicheLien:=True:C214
					Else 
						If (Not:C34($entMotClef.Ville))
							$entMotClef.Ville:=True:C214
							$entMotClef.save()
						End if 
						$entLienMotClef:=ds:C1482.Biblio_MotClef.query("UUID_Bibliotheque = :1 & UUID_MotClef = :2";$entBiblioFichier.UUID;$entMotClef.UUID).first()
						If ($entLienMotClef=Null:C1517)
							$creationFicheLien:=True:C214
						End if 
					End if 
					If ($creationFicheLien)
						$entLienMotClef:=ds:C1482.Biblio_MotClef.new()
						$entLienMotClef.UUID_Bibliotheque:=$entBiblioFichier.UUID
						$entLienMotClef.UUID_MotClef:=$entMotClef.UUID
						$entLienMotClef.save()
					End if 
				End if 
			End if 
		End if 
		PICTURE PROPERTIES:C457($image;$largeur;$hauteur)
		$entBiblioFichier.Largeur_Image:=$largeur
		$entBiblioFichier.Hauteur_Image:=$hauteur
		Case of 
			: ($largeur<$hauteur)
				$Coef:=$largeur/$hauteur
				
			: ($largeur>$hauteur)
				$Coef:=$hauteur/$largeur
				
			Else 
				$Coef:=1
				
		End case 
		If ($entBiblioFichier.ExtensionFichier#".pdf")
			$Texte:=$Texte+" - "+String:C10($entBiblioFichier.Largeur_Image)+"x"+String:C10($entBiblioFichier.Hauteur_Image)
		End if 
	End if 
	For ($i;1;2)
		Case of 
			: ($i=1)  // 256x256 px
				$largeurCol:=256
				$dimIconFichier:=50
				
			: ($i=2)  // 640x480 px
				$largeurCol:=640
				$dimIconFichier:=70
				
			: ($i=3)  // 1280x960 px
				$largeurCol:=1280
				$dimIconFichier:=90
				
		End case 
		$Ref_SVG:=SVG_New ($largeurCol;$largeurCol)
		If ($entExtension.Lisibe_4D)  // Fichier image
			Case of 
				: ($largeur<=$hauteur)
					$hautBloc:=$largeurCol-2-$hautTexte
					$largBloc:=Round:C94($hautBloc*$Coef;1)
					$coordY_Img:=1
					$coordX_Img:=Round:C94(($largeurCol-2-$largBloc)/2;1)
					
				: ($largeur>$hauteur)
					$largBloc:=$largeurCol-2
					$hautBloc:=Round:C94($largBloc*$Coef;1)
					$coordX_Img:=1
					$coordY_Img:=Round:C94(($largeurCol-2-$hautTexte-$hautBloc)/2;1)
					
			End case 
			CREATE THUMBNAIL:C679($image;$ImageTemp;$largBloc;$hautBloc;Proportionnelle centrée:K6:6)
			$Ref_SVG_Image:=SVG_New_embedded_image ($Ref_SVG;$ImageTemp;$coordX_Img;$coordY_Img)
			$Ref_SVG_Texte:=SVG_New_textArea ($Ref_SVG;$Texte;1;$largeurCol-1-$hautTexte;$largeurCol-2;$hautTexte;"Helvetica Neue";$tailleTypo;Normal:K14:1;Aligné au centre:K42:3)
			$ImageTemp:=$EntExtension.icon
			CREATE THUMBNAIL:C679($ImageTemp;$ImageTemp;$dimIconFichier;$dimIconFichier;Proportionnelle centrée:K6:6)
			$Ref_SVG_Image:=SVG_New_embedded_image ($Ref_SVG;$ImageTemp;-5;0)
		Else   //Autre fichier --> on met l'icon du fichier
			$ImageTemp:=$EntExtension.icon
			If ($largeurCol=256)
				$dimIconFichier:=128
				CREATE THUMBNAIL:C679($ImageTemp;$ImageTemp;$dimIconFichier;$dimIconFichier;Proportionnelle centrée:K6:6)
			Else 
				$dimIconFichier:=256
			End if 
			$coordX_Img:=($largeurCol-$dimIconFichier)/2
			$coordY_Img:=Round:C94(($largeurCol-2-$hautTexte-$dimIconFichier)/2;1)
			$Ref_SVG_Image:=SVG_New_embedded_image ($Ref_SVG;$ImageTemp;$coordX_Img;$coordY_Img)
			$Ref_SVG_Texte:=SVG_New_textArea ($Ref_SVG;$Texte;1;$largeurCol-1-$hautTexte;$largeurCol-2;$hautTexte;"Helvetica Neue";$tailleTypo;Normal:K14:1;Aligné au centre:K42:3)
		End if 
		$ImageCreer:=SVG_Export_to_picture ($Ref_SVG)
		Case of 
			: ($i=1)  // 256x256 px
				  //CRÉER IMAGETTE($image;$ImageCreer;$largeurImg;$hauteurImg;Proportionnelle)
				CONVERT PICTURE:C1002($ImageCreer;".jpg";0.9)
				$entBiblioVignette.Vignette_1:=$ImageCreer
				
			: ($i=2)  // 640x480 px
				  //CRÉER IMAGETTE($image;$ImageCreer;$largeurImg;$hauteurImg;Proportionnelle)
				CONVERT PICTURE:C1002($ImageCreer;".jpg";0.8)
				$entBiblioVignette.Vignette_2:=$ImageCreer
				
			: ($i=3)  // 1280x960 px
				  //CRÉER IMAGETTE($image;$ImageCreer;$largeurImg;$hauteurImg;Proportionnelle)
				CONVERT PICTURE:C1002($ImageCreer;".jpg";0.7)
				$entBiblioVignette.Vignette_3:=$ImageCreer
				
		End case 
	End for 
	$entBiblioVignette.save()
End if 
