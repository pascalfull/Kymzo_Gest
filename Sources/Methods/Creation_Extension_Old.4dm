//%attributes = {"invisible":true}
  //  // Méthode : Creation_Extension
  //  // Date et heure : 08/03/20, 22:19:31
  //  // Modifié le : 05/04/20, 16:27:50

  //C_ENTIER LONG($i;$Rech;$Process)
  //C_TEXTE($DossierReferent;$nomComplet;$msg)
  //C_OBJET($entExtension;$entBiblioFichier;$entPref)
  //TABLEAU TEXTE($t_ext;0)
  //TABLEAU TEXTE($t_ext_Exist;0)

  //Si (Nombre de paramètres=0)
  //$msg:="Voulez-vous réellement analyser la base de données pour créer les extensions de fichiers manquantes ?"
  //CONFIRMER($msg;"Continuer";"Annuler")
  //Si (OK=1)
  //$Process:=Nouveau process(Nom méthode courante;0;"Creation des extensions des fichiers";0;*)
  //Si (Statut du process($Process)>0)
  //RÉACTIVER PROCESS($Process)
  //MONTRER PROCESS($Process)
  //PASSER AU PREMIER PLAN($Process)
  //Fin de si 
  //Fin de si 
  //Sinon 
  //InitProcess 
  //$entPref:=ds.Preference.all().first()
  //$DossierReferent:=$entPref.Chemin_Dossier_Client
  //LECTURE ÉCRITURE([Extension])
  //TOUT SÉLECTIONNER([Extension])
  //SÉLECTION VERS TABLEAU([Extension]Nom;$t_ext_Exist)
  //CHERCHER([Bibliotheque];[Bibliotheque]Type=0;*)
  //CHERCHER([Bibliotheque]; & ;[Bibliotheque]DossierFichier=Faux)
  //VALEURS DISTINCTES([Bibliotheque]ExtensionFichier;$t_ext)
  //Boucle ($i;1;Taille tableau($t_ext))
  //$Rech:=Chercher dans tableau($t_ext_Exist;$t_ext{$i})
  //Si ($Rech=-1)
  //$entBiblioFichier:=ds.Bibliotheque.query("ExtensionFichier = :1";$t_ext{$i}).first()
  //$nomComplet:=$DossierReferent+$entBiblioFichier.Path_
  //Si (Tester chemin acces($nomComplet)=Est un document)
  //$entExtension:=ds.Extension.new()
  //$entExtension.Nom:=$t_ext{$i}
  //$entExtension.icon:=Fichier($nomComplet;fk chemin plateforme).getIcon(256)
  //$entExtension.Lisibe_4D:=Est un fichier image($nomComplet)
  //$entExtension.save()
  //Fin de si 
  //Fin de si 
  //Fin de boucle 
  //CHERCHER([Bibliotheque];[Bibliotheque]Type=0;*)
  //CHERCHER([Bibliotheque]; & ;[Bibliotheque]DossierFichier=Vrai)
  //RÉDUIRE SÉLECTION([Bibliotheque];1)
  //$Rech:=Chercher dans tableau($t_ext_Exist;"")
  //Si ($Rech=-1)
  //$entBiblioFichier:=ds.Bibliotheque.query("DossierFichier = :1";Vrai).first()
  //$nomComplet:=$DossierReferent+$entBiblioFichier.Path_
  //Si (Tester chemin acces($nomComplet)=Est un dossier)
  //$entExtension:=ds.Extension.new()
  //$entExtension.Nom:=""
  //$entExtension.icon:=Dossier($nomComplet;fk chemin plateforme).getIcon(256)
  //$entExtension.save()
  //Fin de si 
  //Fin de si 
  //LIBÉRER ENREGISTREMENT([Extension])
  //LECTURE SEULEMENT([Extension])
  //ALERTE("Analyse terminée.")
  //Fin de si 