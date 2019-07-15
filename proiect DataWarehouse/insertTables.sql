-- inserare in redactii                     
BEGIN

  FOR i IN 1..37 LOOP
      INSERT INTO REDACTII VALUES(i, 
                            'Red' || i, 
                            'Str.' || i,
                            '02460000' || i, i || '@email.com', 
                            'Redactor' || i);
  END LOOP;
END;
/

-- inserare publicatii                   
DECLARE 
idx PLS_INTEGER;
pret NUMBER(8,2);
nrred PLS_INTEGER;
-- vector de lungime fixa ce retine categoriile
TYPE VECTOR IS VARRAY(7) OF VARCHAR2(20);
cat VECTOR := VECTOR('Generalist', 'Sport', 'Cultural', 'Politic', 'Religios', 'Design', 'Economic');
BEGIN

  FOR i IN 1..100 LOOP
      -- generez aleator o categorie, un pret
      -- si o redactie 
      idx := DBMS_RANDOM.VALUE(1,7);
      pret := DBMS_RANDOM.VALUE(1,20);
      nrred := DBMS_RANDOM.VALUE(1,37);
      
      INSERT INTO PUBLICATII VALUES(i, 'Pub' || i, cat(idx), pret, nrred);
  END LOOP;
END;
/

-- inserare editie
DECLARE 
pubid PLS_INTEGER;
nred PLS_INTEGER;
-- data
zi PLS_INTEGER;
luna PLS_INTEGER;
an PLS_INTEGER;
ap varchar2(15);
BEGIN

 FOR i IN 1..500 LOOP
      -- generez aleator PubId, numarul editiei
      pubid := DBMS_RANDOM.VALUE(1,100);
      nred := DBMS_RANDOM.VALUE(1,500);
      
      -- random date
      luna := DBMS_RANDOM.VALUE(1,12);
      an := DBMS_RANDOM.VALUE(2016,2018);
      
      -- zi random in functie de luna
      IF luna = 2 THEN
         zi := DBMS_RANDOM.VALUE(1,28);
      ELSIF luna in (4,6,9,11) THEN
         zi := DBMS_RANDOM.VALUE(1,30);
      ELSE
         zi := DBMS_RANDOM.VALUE(1,31);
      END IF;
      
      ap := zi || '-' || luna || '-' || an;
      
      INSERT INTO EDITIE VALUES(pubid, to_date(ap, 'dd-mm-yyyy'), nred);
 END LOOP;
END;
/

-- inserare abonati
DECLARE 
idx PLS_INTEGER;
-- vector de lungime fixa ce retine tipul persoanei
TYPE VECTOR IS VARRAY(2) OF VARCHAR2(20);
tip VECTOR := VECTOR('FIZ','JUR');
BEGIN

 FOR i IN 1..1500 LOOP
      -- generez aleator tipul persoanei
      idx := DBMS_RANDOM.VALUE(1,2); 
                  
      INSERT INTO ABONATI VALUES(i, '074400' || i, 
                           i || '@yahoo.com', 'Str.' || i, 
                           tip(idx));
                           
      -- inserare in functie de tipul persoanei in tabel corespunzator
      IF idx = 1 THEN
         INSERT INTO PERSFIZ VALUES(i, 'Nume' || i, 'Prenume' || i);
      ELSIF idx = 2 THEN
         INSERT INTO PERSJUR VALUES(i, i || 'SRL', 'RO75321' || i);
      END IF;
 END LOOP;
END;
/

-- inserare angajati
INSERT INTO ANGAJATI VALUES(1, 'Popescu Ionescu', '0748628703', 'Bucuresti');
INSERT INTO ANGAJATI VALUES(2, 'George Vasile', '0748628723', 'Alba-Iulia');
INSERT INTO ANGAJATI VALUES(3, 'Asif Amir', '0748628163', 'Arad');
INSERT INTO ANGAJATI VALUES(4, 'Asif Bamir', '0748628153', 'Pitesti');
INSERT INTO ANGAJATI VALUES(5, 'Mihail Baher', '0748628143', 'Bacau');
INSERT INTO ANGAJATI VALUES(6, 'Henry Mikel', '0748628133', 'Oradea');
INSERT INTO ANGAJATI VALUES(7, 'John Smith', '0748628123', 'Iasi');
INSERT INTO ANGAJATI VALUES(8, 'Tortuga Alexander', '0748628793','Botosani');
INSERT INTO ANGAJATI VALUES(9, 'Alexander Kevin', '0748628783', 'Buzau');
INSERT INTO ANGAJATI VALUES(10, 'Ion Ionut', '0748628773', 'Giurgiu');

-- inserare abonatila
DECLARE 
nrpub PLS_INTEGER;
-- data
zi PLS_INTEGER;
luna PLS_INTEGER;
an PLS_INTEGER;
ap varchar2(15);
ap2 varchar2(15);
BEGIN

 FOR i IN 1..1500 LOOP
      -- generam aleator id publicatiei
      nrpub := DBMS_RANDOM.VALUE(1,100);
      -- random date
      luna := DBMS_RANDOM.VALUE(1,12);
      an := DBMS_RANDOM.VALUE(2016,2018);
      
      -- zi random in functie de luna
      IF luna = 2 THEN
         zi := DBMS_RANDOM.VALUE(1,28);
      ELSIF luna in (4,6,9,11) THEN
         zi := DBMS_RANDOM.VALUE(1,30);
      ELSE
         zi := DBMS_RANDOM.VALUE(1,31);
      END IF;
      
      ap := zi || '-' || luna || '-' || an;
      an := an + 1;
      ap2 := zi || '-' || luna || '-' || an;
      INSERT INTO ABONATILA VALUES(i, nrpub, to_date(ap,'dd-mm-yyyy'),
                             to_date(ap2,'dd-mm-yyyy'), 1); 
 END LOOP;
END;
/

-- inserare livrari
-- pentru o publicatie random
-- cate s-au livrat in ziua X
DECLARE 
nr NUMBER(8);
nrpub PLS_INTEGER;
-- data
zi PLS_INTEGER;
luna PLS_INTEGER;
an PLS_INTEGER;
ap varchar2(15);
BEGIN

 FOR i IN 1..200 LOOP
      -- generam aleator id publicatiei
      nrpub := DBMS_RANDOM.VALUE(1,100);
      nr := 0;
            
      -- random date
      luna := DBMS_RANDOM.VALUE(1,12);
      an := DBMS_RANDOM.VALUE(2016,2018);
      
      -- zi random in functie de luna
      IF luna = 2 THEN
         zi := DBMS_RANDOM.VALUE(1,28);
      ELSIF luna in (4,6,9,11) THEN
         zi := DBMS_RANDOM.VALUE(1,30);
      ELSE
         zi := DBMS_RANDOM.VALUE(1,31);
      END IF;
      
      ap := zi || '-' || luna || '-' || an;
      
      SELECT COUNT(*) INTO NR FROM ABONATILA 
      WHERE PUBID = nrpub AND to_date(ap,'dd-mm-yyyy') >= STARTDATE 
      AND to_date(ap,'dd-mm-yyyy') <= ENDDATE;
      
      INSERT INTO LIVRARI VALUES(i, to_date(ap,'dd-mm-yyyy'), NR, nrpub); 
 END LOOP;
END;
/

-- inserare vanzari
DECLARE
-- calculam cat s-a vandut intr-o anume zi
-- zi extrasa din tabelul livrari
valoare PUBLICATII.PRET%TYPE := 0;
pret PUBLICATII.PRET%TYPE;
CURSOR C IS SELECT LivId, TotalLiv, NrPub FROM LIVRARI;
BEGIN
  
  FOR idx IN C LOOP
      pret := 0;
      SELECT PUB.PRET INTO pret FROM PUBLICATII PUB
      WHERE idx.NrPub = PUB.PUBID;
      
      valoare := idx.TotalLiv*pret;
      INSERT INTO VANZARI VALUES(idx.LivId, idx.NrPub, valoare);
  END LOOP;
END;
/

COMMIT;