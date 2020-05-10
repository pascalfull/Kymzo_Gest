C_LONGINT:C283($col;$ligne)
C_POINTER:C301($varcol)
C_OBJECT:C1216($entDossierEnfant;$entSelection;$EntDossierBiblio;$emp)

If (Form event code:C388=Sur clic:K2:4)
	LISTBOX GET CELL POSITION:C971(*;"lb_bibiothequeDossier";$col;$ligne)
	If ($col=1)
		$entSelection:=Form:C1466.SelectionDoc.first()
		$entDossierEnfant:=entBiblio.query("PathParent = :1";$entSelection.Path_)
		If ($entDossierEnfant.length>0)
			$EntDossierBiblio:=Form:C1466.docs
			If ($EntDossierBiblio.contains($entDossierEnfant.first()))
				$chemin:=$entSelection.Path_+"@"
				$entDossierEnfant:=entBiblio.query("PathParent = :1";$chemin)
				For each ($emp;$entDossierEnfant)
					$EntDossierBiblio:=$EntDossierBiblio.minus($emp)
				End for each 
			Else 
				For each ($emp;$entDossierEnfant)
					$EntDossierBiblio.add($emp)
				End for each 
			End if 
			$EntDossierBiblio:=$EntDossierBiblio.orderBy("Path_")
			Form:C1466.docs:=$EntDossierBiblio
		End if 
	End if 
End if 
