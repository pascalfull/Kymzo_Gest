//%attributes = {"invisible":true}
  // Méthode : Sc_Dial_Choix_Analyse
  // Date et heure : 08/04/20, 22:06:54
  // Modifié le : 26/04/20, 16:51:01

C_LONGINT:C283($i;$nbFiches;$col;$ligne;$ligneMenu)
C_BOOLEAN:C305($Alt)
C_TEXT:C284($nomObjet;$msg)
C_POINTER:C301($objet;$ptr)
C_OBJECT:C1216($entClient;$emp;$entGroupe)

If (Count parameters:C259>=1)
	$objet:=$1
End if 
If (Is nil pointer:C315($objet))
	$nomObjet:=OBJECT Get name:C1087(Objet courant:K67:2)
End if 

Case of 
	: ($objet=(->[Client:7]))  // Méthode formulaire [Client];"Dial_Choix_Analyse"
		GEN_TAB_Dimensionner (7;->t_Client_Analyse)
		t_Client_Analyse{1}:=->t_Client_Select
		t_Client_Analyse{2}:=->t_Client_Groupe
		t_Client_Analyse{3}:=->t_Client_Nom
		t_Client_Analyse{4}:=->t_Client_Dossier
		t_Client_Analyse{5}:=->t_Client_UUID
		t_Client_Analyse{6}:=->t_Client_Dossier_introuvable
		t_Client_Analyse{7}:=->t_Client_Coul
		$entClient:=ds:C1482.Client.query("Chemin_Dossier # :1";"").orderBy("Nom")
		GEN_TAP_Dimensionner ($entClient.length;->t_Client_Analyse)
		$i:=0
		For each ($emp;$entClient)
			$i:=$i+1
			  //t_Client_Select{$i}:=$emp.Actualiser_Dossier
			t_Client_Nom{$i}:=$emp.Nom
			t_Client_Dossier{$i}:=$emp.Chemin_Dossier
			If (GEN_UuidValide ($emp.UUID_Groupe))
				$entGroupe:=ds:C1482.Groupe.query("UUID = :1";$emp.UUID_Groupe).first()
				t_Client_Groupe{$i}:=$entGroupe.Nom
			Else 
				t_Client_Groupe{$i}:=""
			End if 
			t_Client_UUID{$i}:=$emp.UUID
			t_Client_Dossier_introuvable{$i}:=(Test path name:C476($emp.Chemin_Dossier)#Est un dossier:K24:2)
			If (t_Client_Dossier_introuvable{$i})
				t_Client_Select{$i}:=False:C215
				t_Client_Coul{$i}:=0x00FF0000  // Rouge
			Else 
				t_Client_Coul{$i}:=lk hérité:K53:26
			End if 
		End for each 
		OBJECT SET ENABLED:C1123(*;"Btn_Lancer_Analyser";(Count in array:C907(t_Client_Select;True:C214)>0))
		
		
	: ($nomObjet="lb_ListeClients")
		Case of 
			: (Form event code:C388=Sur clic entête:K2:40)
				$ptr:=OBJECT Get pointer:C1124(Objet courant:K67:2)
				If ($ptr=OBJECT Get pointer:C1124(Objet nommé:K67:5;"Ent_lb_ListeClients_Actualiser"))
					$Alt:=(Macintosh option down:C545 | Windows Alt down:C563)
					For ($i;1;Size of array:C274(t_Client_Select))
						If ($Alt)
							t_Client_Select{$i}:=False:C215
						Else 
							If (Not:C34(t_Client_Dossier_introuvable{$i}))
								t_Client_Select{$i}:=True:C214
							End if 
						End if 
					End for 
					OBJECT SET ENABLED:C1123(*;"Btn_Lancer_Analyser";(Count in array:C907(t_Client_Select;True:C214)>0))
				End if 
				
			: (Form event code:C388=Sur clic:K2:4)
				LISTBOX GET CELL POSITION:C971(*;"lb_ListeClients";$col;$ligne;$ptr)
				If ($ligne>0)
					If (Contextual click:C713)
						If (Not:C34(t_Client_Dossier_introuvable{$ligne})) & ($ptr=(->t_Client_Dossier))
							$ligneMenu:=Pop up menu:C542("Afficher dans le Finder")
							If ($ligneMenu>0)
								SHOW ON DISK:C922(t_Client_Dossier{$ligne})
							End if 
						End if 
					End if 
				End if 
				
		End case 
		
		
	: ($nomObjet="Btn_Lancer_Analyser")
		$nbFiches:=Count in array:C907(t_Client_Select;True:C214)
		$msg:="Voulez-vous réellement analyser "
		If ($nbFiches=1)
			$msg:=$msg+"le dossier client"
		Else 
			$msg:=$msg+"les "+String:C10($nbFiches)+" dossiers clients"
		End if 
		$msg:=$msg+"?\r\rCela peut prendre un certain temps ?"
		CONFIRM:C162($msg;"Continuer";"Annuler")
		If (OK=1)
			ACCEPT:C269
		End if 
		
		
End case 
