//%attributes = {"invisible":true}
  // Méthode : A_Propos
  // Date et heure : 22/02/20, 23:06:53

C_LONGINT:C283($Fen)
C_OBJECT:C1216($options)

$options:=New object:C1471
$options.version:=<>Version_Num
$options.date:=String:C10(<>Version_Date)
$Fen:=Open form window:C675("A_Propos";Form fenêtre standard:K39:10;Centrée horizontalement:K39:1;Centrée verticalement:K39:4)
DIALOG:C40("A_Propos";$options)
CLOSE WINDOW:C154($Fen)
