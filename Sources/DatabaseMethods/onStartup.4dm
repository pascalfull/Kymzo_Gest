  // Méthode : Sur ouverture
  // Date et heure : 22/02/20, 23:03:00

C_LONGINT:C283($G;$H;$D;$B)

GEN_InitGlobale 
GEN_VTB_FixerIdBase ("Kymzo_Gest")

Compiler_Variables_Inter 

x_Constante 

SET ABOUT:C316("A propos de Kymzo Gest...";"A_PROPOS")
GET WINDOW RECT:C443($G;$H;$D;$B)
SET WINDOW RECT:C444($G;$H;$G+800;$H+540)
SET WINDOW TITLE:C213("Version N° "+<>Version_Num+" du "+String:C10(<>Version_Date))
