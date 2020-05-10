//%attributes = {"invisible":true}
  // Méthode : Affichage_Vignettes
  // Date et heure : 21/03/20, 16:16:44
  // Modifié le : 18/04/20, 15:43:18

C_LONGINT:C283($g;$h;$d;$b;$largeur;$hauteur;$i;$largeurCol;$nbTab;$indice;$nbLigne;$Ligne;$numTab;$triOrdre)
C_TEXT:C284($indTxt)
C_POINTER:C301($ptr)
C_OBJECT:C1216($entBiblio;$EntFichier;$entVignette;$emp;$objeImage)
ARRAY TEXT:C222($t_nomCol;0)
ARRAY TEXT:C222($t_nomEntete;0)
ARRAY POINTER:C280($t_varCol;0)
ARRAY POINTER:C280($t_varEntete;0)
ARRAY BOOLEAN:C223($t_colVisible;0)
ARRAY POINTER:C280($t_style;0)

$entBiblio:=$1
(OBJECT Get pointer:C1124(Objet nommé:K67:5;"nbFiches")->):=$entBiblio.length
$largeurCol:=Y_Calcul_Largeur_Colonne 
OBJECT GET COORDINATES:C663(*;"lb_Liste_Image";$g;$h;$d;$b)
$largeur:=$d-$g
$hauteur:=$b-$h
$nbTab:=(($largeur\$largeurCol)+1)*2
LISTBOX GET ARRAYS:C832(*;"lb_Liste_Image";$t_nomCol;$t_nomEntete;$t_varCol;$t_varEntete;$t_colVisible;$t_style)
If (Not:C34(OB Is empty:C1297($entBiblio)))
	$EntFichier:=$entBiblio.query("DossierFichier = :1";False:C215)  // .orderBy("Path_")
	$triOrdre:=(Num:C11((OBJECT Get pointer:C1124(Objet nommé:K67:5;"cc_Tri1")->)=1))+(Num:C11((OBJECT Get pointer:C1124(Objet nommé:K67:5;"cc_Tri2")->)=1)*2)+(Num:C11((OBJECT Get pointer:C1124(Objet nommé:K67:5;"cc_Tri3")->)=1)*3)+(Num:C11((OBJECT Get pointer:C1124(Objet nommé:K67:5;"cc_Tri4")->)=1)*4)
	Case of 
		: ($triOrdre=1)  // Alpha croissant
			$EntFichier:=$EntFichier.orderBy("Path_")
			
		: ($triOrdre=2)  // Alpha décroissant
			$EntFichier:=$EntFichier.orderBy("Path_ desc")
			
		: ($triOrdre=3)  // Date croissante
			$EntFichier:=$EntFichier.orderBy("DateCreation, Path_")
			
		: ($triOrdre=4)  // Date croissante
			$EntFichier:=$EntFichier.orderBy("DateCreation desc, Path_ asc")
			
	End case 
	If ($EntFichier.length>0)
		  // Création des tableaux 
		Case of 
			: (Size of array:C274($t_varCol)<$nbTab)
				$indice:=Size of array:C274($t_varCol)+1
				$numTab:=(Size of array:C274($t_varCol)/2)+1
				While ($indice<=$nbTab)
					$indTxt:=String:C10($numTab)
					LISTBOX DUPLICATE COLUMN:C1273(*;"Col_lb_ListeImage_"+String:C10($numTab-1);$indice;"Col_lb_ListeImage_"+$indTxt;$ptr;"Ent_lb_ListeImage_"+$indTxt;$ptr)
					LISTBOX DUPLICATE COLUMN:C1273(*;"Col_lb_ListeImage_Info_"+String:C10($numTab-1);$indice+1;"Col_lb_ListeImage_Info_"+$indTxt;$ptr;"Ent_lb_ListeImage_Info_"+$indTxt;$ptr)
					$numTab:=$numTab+1
					$indice:=$indice+2
				End while 
				
			: (Size of array:C274($t_varCol)>$nbTab)
				LISTBOX DELETE COLUMN:C830(*;"lb_Liste_Image";$nbTab+1;Size of array:C274($t_varCol)-$nbTab+1)
				
		End case 
		  // Calcul du nombre de lignes
		$nbLigne:=($EntFichier.length\(($nbTab/2)-1))
		If (($EntFichier.length/(($nbTab/2)-1))#($EntFichier.length\(($nbTab/2)-1)))
			$nbLigne:=$nbLigne+1
		End if 
		  // Fixation de la hauteur et de la largeur et du nombre d'élément dans les tableaux
		LISTBOX SET ROWS HEIGHT:C835(*;"lb_Liste_Image";$largeurCol;lk pixels:K53:22)
		LISTBOX GET ARRAYS:C832(*;"lb_Liste_Image";$t_nomCol;$t_nomEntete;$t_varCol;$t_varEntete;$t_colVisible;$t_style)
		For ($i;1;Size of array:C274($t_varCol))
			If ($i%2=0)
				ARRAY OBJECT:C1221($t_varCol{$i}->;0)
				ARRAY OBJECT:C1221($t_varCol{$i}->;$nbLigne)
			Else 
				If (($i+1)<Size of array:C274($t_varCol))
					LISTBOX SET COLUMN WIDTH:C833($t_varCol{$i}->;$largeurCol)
				Else 
					LISTBOX SET COLUMN WIDTH:C833($t_varCol{$i}->;$largeur-15-($largeurCol*($i-1)))
				End if 
				ARRAY PICTURE:C279($t_varCol{$i}->;0)
				ARRAY PICTURE:C279($t_varCol{$i}->;$nbLigne)
			End if 
		End for 
		  // Boucle sur les fichiers à afficher
		$numTab:=1  // nombre de tableaux
		$Ligne:=1
		For each ($emp;$EntFichier)
			$entVignette:=ds:C1482.Vignette.query("UUID_Bibliotheque = :1";$emp.UUID).first()
			If (Not:C34($entVignette=Null:C1517))
				If ($largeurCol<320)
					$t_varCol{$numTab}->{$Ligne}:=$entVignette.Vignette_1
				Else 
					$t_varCol{$numTab}->{$Ligne}:=$entVignette.Vignette_2
				End if 
			Else 
				$t_varCol{$numTab}->{$Ligne}:=$emp.extension.icon
			End if 
			  // Fin de si 
			$numTab:=$numTab+1
			  // Infos fichier
			$objeImage:=New object:C1471
			OB SET:C1220($objeImage;"nom";$emp.Nom+$emp.ExtensionFichier)
			OB SET:C1220($objeImage;"uuidClient";$emp.UUID_Client)
			OB SET:C1220($objeImage;"path";$emp.Path_)
			OB SET:C1220($objeImage;"pathParent";$emp.PathParent)
			If ($emp.Largeur_Image#0)
				OB SET:C1220($objeImage;"taille";String:C10($emp.Largeur_Image)+" x "+String:C10($emp.Hauteur_Image)+" px")
			End if 
			OB SET:C1220($objeImage;"poids";$emp.PoidsFichier)
			OB SET:C1220($objeImage;"dateCrea";$emp.DateCreation)
			OB SET:C1220($objeImage;"dateModif";$emp.DateModification)
			$t_varCol{$numTab}->{$Ligne}:=$objeImage
			  // Peut-être changement de ligne 
			If ($numTab=($nbTab-2))
				$numTab:=1
				$Ligne:=$Ligne+1
			Else 
				$numTab:=$numTab+1
			End if 
		End for each 
		
	Else 
		For ($i;1;Size of array:C274($t_varCol))
			If ($i%2=0)
				ARRAY OBJECT:C1221($t_varCol{$i}->;0)
			Else 
				ARRAY PICTURE:C279($t_varCol{$i}->;0)
			End if 
		End for 
	End if 
Else 
	For ($i;1;Size of array:C274($t_varCol))
		If ($i%2=0)
			ARRAY OBJECT:C1221($t_varCol{$i}->;0)
		Else 
			ARRAY PICTURE:C279($t_varCol{$i}->;0)
		End if 
	End for 
End if 