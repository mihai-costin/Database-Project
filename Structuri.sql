--1 

-- Sa se afiseze numele, pretul, redactia si data(luna/an) pentru editoriale aparute in luna aprilie

select p.nume Nume, p.pret Pret, r.nume NumeRedactie, to_char(e.aparitie,'mm/yyyy') DataAparitie from publicatii p, redactii r, editie e 
where (p.pubid=e.pubid) and (to_char(e.aparitie,'mm')='04') and (p.nrred=r.redid);

--2

-- Afisati numele, pretul, redactia si anul apartiei pentru cele mai ieftine publicatii, care au 
-- aparut in luna aprilie.


select p.nume Nume, p.pret Pret, r.nume NumeRedactie, to_char(e.aparitie,'yyyy') Anul from publicatii p, redactii r, editie e 
where (e.pubid=p.pubid) and (to_char(e.aparitie,'mm')='04') and (p.nrred=r.redid) and (p.pret=(select min(p1.pret) from publicatii p1,
editie e1 where (p1.pubid=e1.pubid) and (to_char(e1.aparitie,'mm')='04'))); 

--3

-- Acelesa enunt ca la 2, numai ca folosim o procedura pentru a returna datele cerute, procedura care primeste ca parametru
-- o luna( nu neaparat luna aprilie). Afisam toate publicatii, cu un mesaj corespunzator daca pretul lor respecta sau nu conditia de minim a pretului.
-- Tratam exceptiile.



create or replace procedure MinData (luna varchar2) as
minim number(8,2) :=0;
begin

for i in (select p.nume Nume, p.pret Pret, r.nume NumeRedactie, to_char(e.aparitie,'yyyy') Anul from publicatii p, redactii r, editie e 
where (e.pubid=p.pubid) and (to_char(e.aparitie,'mm')=luna) and (p.nrred=r.redid)) loop

select min(p1.pret) into minim from publicatii p1,
editie e1 where (p1.pubid=e1.pubid) and (to_char(e1.aparitie,'mm')=luna);

if i.Pret=minim then
dbms_output.put(' Publicatia ' || i.Nume || ' are pretul ' || i.Pret || 
' apartine redactiei ' || i.NumeRedactie || ' si a aparut in luna aprilie a anului ' || i.Anul);
else 
 dbms_output.put('Publicati ' || i.Nume || ' nu indeplineste conditia de minim!');
end if;
dbms_output.new_line;
end loop;

exception
when no_data_found then
raise_application_error(-20001,' Nu exista publicatii care au aparut in luna specificata!');
when others then
raise_application_error(-20002, ' Alta eroare!');

end;
/

set serveroutput on;
accept mon prompt 'Introduceti luna:';
declare
l varchar2(4):='&mon';
begin
MinData(l);
end;
/
set serveroutput off;

drop procedure MinData;

--4
-- determinati numarul de publicatii din categoria 'Politic' 
-- care au aparut in ultimii patru ani.

select count(*) Numar from publicatii p, editie e where
(p.pubid=e.pubid) and (months_between(sysdate,e.aparitie)<=48) 
and (lower(p.categorie)='politic');

--5 enuntul anterior, exceptand categoria, dar considerand publicatiile care
-- apartin de redactiile din judetul Alba. 
-- in plus, mai calculam media preturilor ale acestora.

select count(*) Numar, avg(p.pret) Medie from publicatii p, editie e, redactii r, adrese adr where
(p.pubid=e.pubid) and (months_between(sysdate,e.aparitie)<=48) 
and (p.nrred=r.redid) and (r.adresa=adr.adresa) 
and (lower(adr.judet)='alba');

--6 acelasi enunt ca la 4, dar pentru cele din categoria 'generalist',
-- care apartin de o redactie din judetul Alba.

create or replace procedure Numarare as
nr number:=0;
begin
select count(*) into nr  from publicatii p, editie e, redactii r, adrese adr
where (p.pubid=e.pubid) and (months_between(sysdate,e.aparitie)<=48) 
and (lower(p.categorie)='generalist') and (r.redid=p.nrred) 
and (r.adresa=adr.adresa) and (lower(adr.judet)='alba');

if nr<>0 then
dbms_output.put_line(' In judetul Alba exista ' || nr || ' publicatii generaliste care au aparut in ultimii patru ani!');
else dbms_output.put_line(' In judetul Alba nu exista publicatii generaliste care au aparut in ultimii patru ani!');
end if;

end;
/

execute Numarare;

drop procedure Numarare;

--7
-- folosing o functie determinat numarul de publicatii dintr-o
-- categorie, care au aparut in ultimii doi ani. Tratam exceptiile.

create or replace function Numar (cat varchar) 
return number as

nr number:=0;
begin

select count(*) into nr from publicatii p, editie e 
where (p.pubid=e.pubid) and (months_between(sysdate,e.aparitie)<=24) 
and (lower(p.categorie)=lower(cat));

if nr=0 then raise_application_error(-20012,' Categoria data nu are nicio publicatie care a aparut in ultimii doi ani!');
end if;
return nr;

exception 
when NO_DATA_FOUND then
raise_application_error(-20010,' Categoria specificata nu exista!');
when others then
raise_application_error(-20011,'Alta Eroare!');
end;
/

set serveroutput on;
accept cate prompt 'Introduceti categoria:';

declare
ct varchar(20):='&cate';
rez number; 
begin
rez:=Numar(ct);
if(rez<>0) then 
dbms_output.put_line(' In categoria ' || ct || ' sunt ' || rez || ' publicatii!');
end if;
end;
/
set serveroutput off;

drop function Numar;

--8

-- Folosind o functie determinati numarul de publicatii din 
-- doua categorie, care au aparut in ultimii 3 ani.

create or replace type numbers is table of number;
/

create or replace function Numar1 (cat1 varchar2, cat2 varchar2) 
return numbers as

numbs numbers:=numbers();
begin

numbs.extend();
select count(*) into numbs(1) from publicatii p, editie e 
where (p.pubid=e.pubid) and (months_between(sysdate,e.aparitie)<=36)
and (lower(p.categorie)=lower(cat1));

numbs.extend();
select count(*) into numbs(2) from publicatii p, editie e 
where (p.pubid=e.pubid) and (months_between(sysdate,e.aparitie)<=36)
and (lower(p.categorie)=lower(cat2));

if numbs(1)=0 or numbs(2)=0 then raise_application_error(-20021,' Una dintre aplicatiile date nu are nicio publicatie aparuta in ultimii doi ani!');
end if;
return numbs;

exception 
when no_data_found then
raise_application_error(-20022,' Categoriile specificate nu exista!');
when others then
raise_application_error(-20023,'Alta Eroare!');
end;
/

select * from table(Numar1 ('Politic','Generalist'));

DROP TYPE numbers;
DROP FUNCTION Numar1;

--9 

--Creati o vizualizare care sa contina pentru fiecare redactie, numarul total de publicatii
--cat si pretul total; dar si pretul minim si maxim.


create or replace view Viz as
select r.nume Nume, sum(nvl(p.pret,0)) valoare , min(p.pret) minim, max(p.pret) maxim  from
redactii r, publicatii p where r.redid=p.nrred(+) group by r.nume order by r.nume; 

select * from viz;

drop view viz;

--10

-- Utilizand un trigger definiti o constragere asupra pretului unui publicatii, conform 
-- careia acesta nu poate avea valori negativi (sau egale cu zero) si nici mai mari de 250. 

create or replace trigger trig
before insert or update of pret on publicatii 
for each row
begin
if(:new.pret<=0) or (:new.pret>250) then raise_application_error(-20991,' Nu este permisa introducerea unui pret negativ sau mai mare ca 250!');
end if;
end;
/

update publicatii set
pret=-1 where pubid=3;

insert into publicatii(pubid,nume,pret,nrred) values(15,'Dilema Veche',-1,2);

update publicatii set 
pret=25 where pubid=4;

insert into publicatii(pubid,nume,pret,nrred) values(15,'Dilema Veche',2,3);

rollback;
drop trigger trig;
