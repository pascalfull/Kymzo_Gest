Form:C1466.elmtCourantDoc:=New object:C1471
Form:C1466.posCourantDoc:=New object:C1471
Form:C1466.SelectionDoc:=New object:C1471
Form:C1466.docs:=entBiblio.query("DossierFichier = :1 & PathParent = :2";True:C214;"").orderBy("Path_")
