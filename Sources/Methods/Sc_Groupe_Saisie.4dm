//%attributes = {"invisible":true}
  // Méthode : Sc_Groupe_Saisie
  // Date et heure : 18/04/20, 23:34:34

C_TEXT:C284($nomObjet)
C_POINTER:C301($objet)

If (Count parameters:C259>=1)
	$objet:=$1
End if 
If (Is nil pointer:C315($objet))
	$nomObjet:=OBJECT Get name:C1087(Objet courant:K67:2)
End if 

Case of 
	: ($objet=(->[Groupe:8]))  // Méthode formulaire [Groupe];"Saisie"
		Case of 
			: ([Groupe:8]Type:3=0)  // Client
				(OBJECT Get pointer:C1124(Objet nommé:K67:5;"cc1")->):=1
				
			: ([Groupe:8]Type:3=1)  // Eléments personnel
				(OBJECT Get pointer:C1124(Objet nommé:K67:5;"cc2")->):=1
				
			: ([Groupe:8]Type:3=2)  // Photothèque externe
				(OBJECT Get pointer:C1124(Objet nommé:K67:5;"cc3")->):=1
				
		End case 
		
		
	: ($nomObjet="cc1") | ($nomObjet="cc2") | ($nomObjet="cc3")
		Case of 
			: ($nomObjet="cc1")
				[Groupe:8]Type:3:=0
				
			: ($nomObjet="cc2")
				[Groupe:8]Type:3:=1
				
			: ($nomObjet="cc3")
				[Groupe:8]Type:3:=2
				
		End case 
		
		
	: ($nomObjet="Btn_Valider")
		If ([Groupe:8]Nom:2="")
			ALERT:C41("Le nom du groupe est obligatoire.")
			GOTO OBJECT:C206([Groupe:8]Nom:2)
		Else 
			ACCEPT:C269
		End if 
		
End case 