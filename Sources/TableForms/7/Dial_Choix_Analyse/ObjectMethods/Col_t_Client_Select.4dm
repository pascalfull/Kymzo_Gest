  // Méthode : [Client].Dial_Choix_Analyse.Col_t_Client_Select
  // Date et heure : 08/04/20, 22:34:41

C_LONGINT:C283($ligne)

$ligne:=t_Client_Dossier_introuvable
Case of 
	: (Form event code:C388=Sur avant saisie:K2:39)
		If (t_Client_Dossier_introuvable{$ligne})
			$0:=-1
		End if 
		
	: (Form event code:C388=Sur données modifiées:K2:15)
		OBJECT SET ENABLED:C1123(*;"Btn_Lancer_Analyser";(Count in array:C907(t_Client_Select;True:C214)>0))
		
End case 

