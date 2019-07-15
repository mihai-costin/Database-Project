-- crearea tabelelor
-- tabel redactii
CREATE TABLE REDACTII(RedId int, Nume varchar2(35) NOT NULL,
                      Adresa varchar2(50) NOT NULL,
                      Telefon varchar2(10), 
                      Email varchar2(50), 
                      RedactorSef varchar2(50));

ALTER TABLE REDACTII ADD PRIMARY KEY(REDID);

-- tabel publicatii si editii
CREATE TABLE PUBLICATII(PubId int, Nume varchar2(50) NOT NULL, 
                        Categorie varchar2(20), 
                        Pret Number(8,2) NOT NULL, 
                        NrRed int NOT NULL);
                        
ALTER TABLE PUBLICATII ADD PRIMARY KEY(PubId);
ALTER TABLE PUBLICATII ADD FOREIGN KEY(NrRed)
REFERENCES REDACTII(RedId) ON DELETE SET NULL;

CREATE TABLE EDITIE(PubId int, Aparitie date NOT NULL, NrEditie int);

ALTER TABLE EDITIE ADD PRIMARY KEY(PubId, Aparitie);
ALTER TABLE EDITIE ADD FOREIGN KEY(PubId) REFERENCES PUBLICATII(PubId)
ON DELETE SET NULL;

-- tabel abonati
CREATE TABLE ABONATI(AbnId int, Telefon varchar2(10) NOT NULL, 
                     Email varchar2(50), 
                     Adresa varchar2(50),  
                     TipPers varchar2(5) NOT NULL);

ALTER TABLE ABONATI ADD PRIMARY KEY(AbnId);

-- persoane fizice
CREATE TABLE PERSFIZ(AbnId int, Nume varchar2(25) 
                     NOT NULL, Prenume varchar2(25));

ALTER TABLE PERSFIZ ADD PRIMARY KEY(AbnId);

-- persoane juridice
CREATE TABLE PERSJUR(AbnId int, Nume varchar2(25) 
                     NOT NULL, CIF varchar2(12) NOT NULL);

ALTER TABLE PERSJUR ADD PRIMARY KEY(AbnId);
   
-- tabel abonamente
CREATE TABLE ABONATILA(AbnId int, PubId int, 
                       StartDate date, 
                       EndDate date, NrPub int NOT NULL);

ALTER TABLE ABONATILA ADD PRIMARY KEY(AbnId, PubId);

-- tabel angajati
CREATE TABLE ANGAJATI(AngId int, Nume varchar2(25) NOT NULL,
                      Telefon varchar2(10) NOT NULL,
                      OrasOp varchar2(25));

ALTER TABLE ANGAJATI ADD PRIMARY KEY(AngId); 

-- tabel livrari
CREATE TABLE LIVRARI(LivId int, Data date NOT NULL, TotalLiv int, NrPub int);

ALTER TABLE LIVRARI ADD PRIMARY KEY(LivId);

-- tabel vanzari
CREATE TABLE VANZARI(LivId int, PubId int, Valoarea Number(8,2));