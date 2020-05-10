//%attributes = {"invisible":true}
  // Méthode : Y_Calcul_Largeur_Colonne
  // Date et heure : 22/03/20, 13:44:05

C_LONGINT:C283($valTermo)
C_REAL:C285($largeurCol)

$valTermo:=(OBJECT Get pointer:C1124(Objet nommé:K67:5;"thermoLargeurCol")->)
Case of 
	: ($valTermo>=0) & ($valTermo<10)
		$largeurCol:=50+(($valTermo/100)*50)
		
	: ($valTermo>=10) & ($valTermo<20)
		$largeurCol:=100+((($valTermo-10)/100)*50)
		
	: ($valTermo>=20) & ($valTermo<30)
		$largeurCol:=150+((($valTermo-20)/100)*50)
		
	: ($valTermo>=30) & ($valTermo<40)
		$largeurCol:=200+((($valTermo-30)/100)*50)
		
	: ($valTermo>=40) & ($valTermo<50)
		$largeurCol:=250+((($valTermo-40)/100)*50)
		
	: ($valTermo>=50) & ($valTermo<60)
		$largeurCol:=300+((($valTermo-50)/100)*50)
		
	: ($valTermo>=60) & ($valTermo<70)
		$largeurCol:=350+(($valTermo-60)*10)
		
	: ($valTermo>=70) & ($valTermo<80)
		$largeurCol:=450+(($valTermo-70)*15)
		
	: ($valTermo>=80) & ($valTermo<90)
		$largeurCol:=600+(($valTermo-80)*20)
		
	: ($valTermo>=90)
		$largeurCol:=800+(($valTermo-90)*25)
		
End case 
$0:=Round:C94($largeurCol;0)
