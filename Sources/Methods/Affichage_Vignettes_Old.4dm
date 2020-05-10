//%attributes = {"invisible":true}
  //  // Méthode : Affichage_Vignettes
  //  // Date et heure : 21/03/20, 16:16:44
  //  // Modifié le : 13/04/20, 13:59:58

  //C_ENTIER LONG($g;$h;$d;$b;$largeur;$hauteur;$i;$largeurCol;$nbTab;$indice;$nbLigne;$Ligne;$numTab;$triOrdre;$tailleTypo;$hautTexte)
  //C_RÉEL($Coef;$largBloc;$hautBloc;$largImg;$hautImg;$coordX_Img;$coordY_Img)
  //C_BOOLÉEN($affNomFich;$affDateFich;$affTailleFich)
  //C_TEXTE($indTxt;$Ref_SVG;$Texte;$Ref_SVG_Image;$Ref_SVG_Texte)
  //C_POINTEUR($ptr)
  //C_IMAGE($ImageTemp)
  //C_OBJET($entBiblio;$EntFichier;$entVignette;$emp;$objeImage)
  //TABLEAU TEXTE($t_nomCol;0)
  //TABLEAU TEXTE($t_nomEntete;0)
  //TABLEAU POINTEUR($t_varCol;0)
  //TABLEAU POINTEUR($t_varEntete;0)
  //TABLEAU BOOLÉEN($t_colVisible;0)
  //TABLEAU POINTEUR($t_style;0)

  //$entBiblio:=$1
  //(OBJET Lire pointeur(Objet nommé;"nbFiches")->):=$entBiblio.length
  //$largeurCol:=Y_Calcul_Largeur_Colonne 
  //OBJET LIRE COORDONNÉES(*;"lb_Liste_Image";$g;$h;$d;$b)
  //$largeur:=$d-$g
  //$hauteur:=$b-$h
  //$nbTab:=(($largeur\$largeurCol)+1)*2
  //LISTBOX LIRE TABLEAUX(*;"lb_Liste_Image";$t_nomCol;$t_nomEntete;$t_varCol;$t_varEntete;$t_colVisible;$t_style)
  //Si (Non(OB Est vide($entBiblio)))
  //$EntFichier:=$entBiblio.query("DossierFichier = :1";Faux)  // .orderBy("Path_")
  //$triOrdre:=(Num((OBJET Lire pointeur(Objet nommé;"cc_Tri1")->)=1))+(Num((OBJET Lire pointeur(Objet nommé;"cc_Tri2")->)=1)*2)+(Num((OBJET Lire pointeur(Objet nommé;"cc_Tri3")->)=1)*3)+(Num((OBJET Lire pointeur(Objet nommé;"cc_Tri4")->)=1)*4)
  //Au cas ou 
  //: ($triOrdre=1)  // Alpha croissant
  //$EntFichier:=$EntFichier.orderBy("Path_")

  //: ($triOrdre=2)  // Alpha décroissant
  //$EntFichier:=$EntFichier.orderBy("Path_ desc")

  //: ($triOrdre=3)  // Date croissante
  //$EntFichier:=$EntFichier.orderBy("DateCreation, Path_")

  //: ($triOrdre=4)  // Date croissante
  //$EntFichier:=$EntFichier.orderBy("DateCreation desc, Path_ asc")

  //Fin de cas 
  //Si ($EntFichier.length>0)
  //  // Création des tableaux 
  //Au cas ou 
  //: (Taille tableau($t_varCol)<$nbTab)
  //$indice:=Taille tableau($t_varCol)+1
  //$numTab:=(Taille tableau($t_varCol)/2)+1
  //Tant que ($indice<=$nbTab)
  //$indTxt:=Chaîne($numTab)
  //LISTBOX DUPLIQUER COLONNE(*;"Col_lb_ListeImage_"+Chaîne($numTab-1);$indice;"Col_lb_ListeImage_"+$indTxt;$ptr;"Ent_lb_ListeImage_"+$indTxt;$ptr)
  //LISTBOX DUPLIQUER COLONNE(*;"Col_lb_ListeImage_Info_"+Chaîne($numTab-1);$indice+1;"Col_lb_ListeImage_Info_"+$indTxt;$ptr;"Ent_lb_ListeImage_Info_"+$indTxt;$ptr)
  //$numTab:=$numTab+1
  //$indice:=$indice+2
  //Fin tant que 

  //: (Taille tableau($t_varCol)>$nbTab)
  //LISTBOX SUPPRIMER COLONNE(*;"lb_Liste_Image";$nbTab+1;Taille tableau($t_varCol)-$nbTab+1)

  //Fin de cas 
  //  // Calcul du nombre de lignes
  //$nbLigne:=($EntFichier.length\(($nbTab/2)-1))
  //Si (($EntFichier.length/(($nbTab/2)-1))#($EntFichier.length\(($nbTab/2)-1)))
  //$nbLigne:=$nbLigne+1
  //Fin de si 
  //  // Fixation de la hauteur et de la largeur et du nombre d'élément dans les tableaux
  //LISTBOX FIXER HAUTEUR LIGNES(*;"lb_Liste_Image";$largeurCol;lk pixels)
  //LISTBOX LIRE TABLEAUX(*;"lb_Liste_Image";$t_nomCol;$t_nomEntete;$t_varCol;$t_varEntete;$t_colVisible;$t_style)
  //Boucle ($i;1;Taille tableau($t_varCol))
  //Si ($i%2=0)
  //TABLEAU OBJET($t_varCol{$i}->;0)
  //TABLEAU OBJET($t_varCol{$i}->;$nbLigne)
  //Sinon 
  //Si (($i+1)<Taille tableau($t_varCol))
  //LISTBOX FIXER LARGEUR COLONNE($t_varCol{$i}->;$largeurCol)
  //Sinon 
  //LISTBOX FIXER LARGEUR COLONNE($t_varCol{$i}->;$largeur-15-($largeurCol*($i-1)))
  //Fin de si 
  //TABLEAU IMAGE($t_varCol{$i}->;0)
  //TABLEAU IMAGE($t_varCol{$i}->;$nbLigne)
  //Fin de si 
  //Fin de boucle 
  //  // Lecture des paramètres
  //$affNomFich:=((OBJET Lire pointeur(Objet nommé;"Btn_Affichage_Nom")->)=1)
  //$affDateFich:=((OBJET Lire pointeur(Objet nommé;"Btn_Affichage_Date")->)=1)
  //$affTailleFich:=((OBJET Lire pointeur(Objet nommé;"Btn_Affichage_Taille")->)=1)
  //  // Boucle sur les fichiers à afficher
  //$numTab:=1  // nombre de tableaux
  //$Ligne:=1
  //Pour chaque ($emp;$EntFichier)
  //$entVignette:=ds.Vignette.query("UUID_Bibliotheque = :1";$emp.UUID).first()
  //Si ($affNomFich)  // Si affichage du Nom donc on passe en SVG
  //$hautTexte:=18
  //Si ($affDateFich | $affTailleFich)
  //$hautTexte:=$hautTexte+12
  //Fin de si 
  //  // Création du nom du fichier en svg
  //$Ref_SVG:=SVG_New ($largeurCol;$largeurCol)
  //$Texte:=$emp.Nom+$emp.ExtensionFichier
  //Si ($affDateFich)
  //$Texte:=$Texte+"\r"+Chaîne($emp.DateCreation;Système date court)
  //Fin de si 
  //Si (Non($entVignette=Null))
  //Si ($emp.ExtensionFichier#".pdf")
  //Si ($affTailleFich)
  //Si (Non($affDateFich))
  //$Texte:=$Texte+"\r"
  //Sinon 
  //$Texte:=$Texte+" - ("
  //Fin de si 
  //$Texte:=$Texte+Chaîne($emp.Largeur_Image)+"x"+Chaîne($emp.Hauteur_Image)
  //Si ($affDateFich)
  //$Texte:=$Texte+")"
  //Fin de si 
  //Fin de si 
  //Fin de si 
  //Si ($largeurCol<256)
  //$ImageTemp:=$entVignette.Vignette_1
  //Sinon 
  //$ImageTemp:=$entVignette.Vignette_2
  //Fin de si 
  //PROPRIÉTÉS IMAGE($ImageTemp;$largImg;$hautImg)
  //Si ($largImg>$hautImg)
  //$Coef:=$hautImg/$largImg
  //$largBloc:=$largeurCol-2
  //$hautBloc:=Arrondi($largBloc*$Coef;1)
  //$coordX_Img:=1
  //$coordY_Img:=Arrondi(($largeurCol-2-$hautTexte-$hautBloc)/2;1)
  //Sinon 
  //$Coef:=$largImg/$hautImg
  //$hautBloc:=$largeurCol-2-$hautTexte
  //$largBloc:=Arrondi($hautBloc*$Coef;1)
  //$coordY_Img:=1
  //$coordX_Img:=Arrondi(($largeurCol-2-$largBloc)/2;1)
  //Fin de si 
  //CRÉER IMAGETTE($ImageTemp;$ImageTemp;$largBloc;$hautBloc;Proportionnelle centrée)
  //Sinon 
  //$ImageTemp:=$emp.extension.icon
  //Si ($largeurCol>160)
  //$largImg:=160
  //$hautImg:=160
  //Sinon 
  //$largImg:=$largeurCol-2-$hautTexte
  //$hautImg:=$largImg
  //Fin de si 
  //CRÉER IMAGETTE($ImageTemp;$ImageTemp;$largImg;$largImg;Proportionnelle centrée)
  //$coordX_Img:=Arrondi(($largeurCol-2-$largImg)/2;1)
  //$coordY_Img:=Arrondi(($largeurCol-2-$hautTexte-$hautImg)/2;1)
  //Fin de si 
  //$tailleTypo:=10
  //$Ref_SVG_Image:=SVG_New_embedded_image ($Ref_SVG;$ImageTemp;$coordX_Img;$coordY_Img)
  //$Ref_SVG_Texte:=SVG_New_textArea ($Ref_SVG;$Texte;1;$largeurCol-1-$hautTexte;$largeurCol-2;$hautTexte;"Helvetica Neue";$tailleTypo;Normal;Aligné au centre)
  //$ImageTemp:=SVG_Export_to_picture ($Ref_SVG)
  //$t_varCol{$numTab}->{$Ligne}:=$ImageTemp
  //Sinon   // Affichage sans le nom des fichiers donc directement depuis les images vignettes
  //Si (Non($entVignette=Null))
  //Si ($largeurCol<256)
  //$t_varCol{$numTab}->{$Ligne}:=$entVignette.Vignette_1
  //Sinon 
  //$t_varCol{$numTab}->{$Ligne}:=$entVignette.Vignette_2
  //Fin de si 
  //Sinon 
  //$t_varCol{$numTab}->{$Ligne}:=$emp.extension.icon
  //Fin de si 
  //Fin de si 
  //$numTab:=$numTab+1
  //  // Infos fichier
  //$objeImage:=Créer objet
  //OB FIXER($objeImage;"nom";$emp.Nom+$emp.ExtensionFichier)
  //OB FIXER($objeImage;"uuidClient";$emp.UUID_Client)
  //OB FIXER($objeImage;"path";$emp.Path_)
  //OB FIXER($objeImage;"pathParent";$emp.PathParent)
  //Si ($emp.Largeur_Image#0)
  //OB FIXER($objeImage;"taille";Chaîne($emp.Largeur_Image)+" x "+Chaîne($emp.Hauteur_Image)+" px")
  //Fin de si 
  //OB FIXER($objeImage;"poids";$emp.PoidsFichier)
  //OB FIXER($objeImage;"dateCrea";$emp.DateCreation)
  //OB FIXER($objeImage;"dateModif";$emp.DateModification)
  //$t_varCol{$numTab}->{$Ligne}:=$objeImage
  //  // Peut-être changement de ligne 
  //Si ($numTab=($nbTab-2))
  //$numTab:=1
  //$Ligne:=$Ligne+1
  //Sinon 
  //$numTab:=$numTab+1
  //Fin de si 
  //Fin de chaque 

  //Sinon 
  //Boucle ($i;1;Taille tableau($t_varCol))
  //Si ($i%2=0)
  //TABLEAU OBJET($t_varCol{$i}->;0)
  //Sinon 
  //TABLEAU IMAGE($t_varCol{$i}->;0)
  //Fin de si 
  //Fin de boucle 
  //Fin de si 
  //Sinon 
  //Boucle ($i;1;Taille tableau($t_varCol))
  //Si ($i%2=0)
  //TABLEAU OBJET($t_varCol{$i}->;0)
  //Sinon 
  //TABLEAU IMAGE($t_varCol{$i}->;0)
  //Fin de si 
  //Fin de boucle 
  //Fin de si 