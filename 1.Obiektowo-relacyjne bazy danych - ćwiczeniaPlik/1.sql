-- zadanie 1

CREATE TYPE SAMOCHOD AS OBJECT (
	marka VARCHAR2(20),
	model VARCHAR2(20),
	kilometry NUMBER,
	data_produkcji DATE,
	cena NUMBER(10,2)
);

desc samochod;

CREATE TABLE samochody OF samochod;

INSERT INTO samochody VALUES(SAMOCHOD('SEAT','IBIZA',60000,DATE '1998-10-10',5000));
INSERT INTO samochody VALUES(SAMOCHOD('SEAT','LEON',50000,DATE '1998-10-10',15500));
INSERT INTO samochody VALUES(SAMOCHOD('FIAT','BRAVA',60000,DATE '1998-11-30',25000));

select * from SAMOCHODY;

-- zadanie 2

CREATE TABLE wlasciciele(
	imie VARCHAR2(100),
	nazwisko VARCHAR2(100),
	auto SAMOCHOD
);

desc wlasciciele;

INSERT INTO wlasciciele VALUES('ADAM', 'NOWAK', SAMOCHOD('SEAT','IBIZA',60000,DATE '1998-10-10',5000));
INSERT INTO wlasciciele VALUES('ADAM', 'KOWALSKI', SAMOCHOD('SEAT','LEON',50000,DATE '1998-10-10',15500));


select * from wlasciciele;


-- zadanie 3

ALTER TYPE SAMOCHOD REPLACE AS OBJECT (
    marka VARCHAR2(20),
    model VARCHAR2(20),
    kilometry NUMBER,
    data_produkcji DATE,
    cena NUMBER(10, 2),
    MEMBER FUNCTION wartosc RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY SAMOCHOD AS
    MEMBER FUNCTION wartosc RETURN NUMBER IS
        BEGIN
            RETURN cena*POWER(0.9, EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji));
        END wartosc;
END;

SELECT s.marka, s.cena, s.wartosc() FROM SAMOCHODY s;

-- zadanie 4

ALTER TYPE SAMOCHOD ADD MAP MEMBER FUNCTION odwzoruj
RETURN NUMBER CASCADE INCLUDING TABLE DATA;

CREATE OR REPLACE TYPE BODY SAMOCHOD AS
	MEMBER FUNCTION wartosc RETURN NUMBER IS
		BEGIN
		   RETURN cena*POWER(0.9, EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji));
		END wartosc;
	MAP MEMBER FUNCTION odwzoruj RETURN NUMBER IS
		BEGIN
			RETURN (EXTRACT (YEAR FROM CURRENT_DATE) -  EXTRACT (YEAR FROM data_produkcji)) + kilometry/10000;
		END
END;		

SELECT * FROM SAMOCHODY s ORDER BY VALUE(s);

-- zadanie 5

CREATE TYPE wlasciciel AS OBJECT (
    imie varchar2(20),
    nazwisko varchar2(20));
	
	
ALTER TYPE SAMOCHOD ADD ATTRIBUTE (WLASC REF WLASCICIEL)
CASCADE INCLUDING TABLE DATA

CREATE TABLE wlascicieleObj OF WLASCICIEL

insert into wlascicieleObj values(NEW WLASCICIEL('Wiszymir','Szymborski'));
insert into wlascicieleObj values(NEW WLASCICIEL('Marvin','Nowak'));

UPDATE samochody s SET s.WLASC = (SELECT ref(a) from wlascicieleobj a where a.imie = 'Marvin')
	
-- zadanie 6

SET SERVEROUT ON;
DECLARE
 TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
 moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
 moje_przedmioty(1) := 'MATEMATYKA';
 moje_przedmioty.EXTEND(9);
 FOR i IN 2..10 LOOP
 moje_przedmioty(i) := 'PRZEDMIOT_' || i;
 END LOOP;
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
moje_przedmioty.TRIM(2);
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.EXTEND();
 moje_przedmioty(9) := 9;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.DELETE();
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;

-- zadanie 7
SET SERVEROUT ON;

DECLARE
 TYPE t_ksiazki IS VARRAY(10) OF VARCHAR2(20);
 moje_ksiazki t_ksiazki := t_ksiazki('');
BEGIN
moje_ksiazki(1) := 'MATEMATYKA CZESC 1';
moje_ksiazki.extend(5);
moje_ksiazki(2) := 'MATEMATYKA CZESC 2';
moje_ksiazki(3) := 'MATEMATYKA CZESC 3';
moje_ksiazki(4) := 'MATEMATYKA CZESC 4';
moje_ksiazki(5) := 'MATEMATYKA CZESC 5';
moje_ksiazki.TRIM(3)
moje_ksiazki.DELETE();
DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
END;

-- zadanie 8
DECLARE
 TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
 moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
 moi_wykladowcy.EXTEND(2);
 moi_wykladowcy(1) := 'MORZY';
 moi_wykladowcy(2) := 'WOJCIECHOWSKI';
 moi_wykladowcy.EXTEND(8);
 FOR i IN 3..10 LOOP
 moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
 END LOOP;
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.TRIM(2);
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.DELETE(5,7);
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 moi_wykladowcy(5) := 'ZAKRZEWICZ';
 moi_wykladowcy(6) := 'KROLIKOWSKI';
 moi_wykladowcy(7) := 'KOSZLAJDA';
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;

--zadanie 9

DECLARE
    TYPE t_miesiace IS TABLE OF VARCHAR2(12);
    miesiace t_miesiace := t_miesiace();
BEGIN
    miesiace.extend(12);
    FOR i IN 1..12 LOOP miesiace(i) := TO_CHAR(TO_DATE(i, 'MM'), 'MONTH');
    END LOOP;
    miesiace.delete(7);
	miesiace.delete(10);
    FOR i IN miesiace.first()..miesiace.last() LOOP 
		IF miesiace.EXISTS(i) THEN
			dbms_output.put_line(miesiace(i));
		END IF;
    END LOOP;
END;

-- zadanie 10
CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/
CREATE TYPE stypendium AS OBJECT (
 nazwa VARCHAR2(50),
 kraj VARCHAR2(30),
 jezyki jezyki_obce );
/
CREATE TABLE stypendia OF stypendium;
INSERT INTO stypendia VALUES
('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES
('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));
SELECT * FROM stypendia;
SELECT s.jezyki FROM stypendia s;
UPDATE STYPENDIA
SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
WHERE nazwa = 'ERASMUS';
CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/
CREATE TYPE semestr AS OBJECT (
 numer NUMBER,
 egzaminy lista_egzaminow );
/
CREATE TABLE semestry OF semestr
NESTED TABLE egzaminy STORE AS tab_egzaminy;
INSERT INTO semestry VALUES
(semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES
(semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));
SELECT s.numer, e.*
FROM semestry s, TABLE(s.egzaminy) e;
SELECT e.*
FROM semestry s, TABLE ( s.egzaminy ) e;
SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );
INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
VALUES ('METODY NUMERYCZNE');
UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';
DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
WHERE e.column_value = 'BAZY DANYCH';

-- zadanie 11

CREATE TYPE koszyk_produktow AS TABLE OF VARCHAR2(20);

CREATE TYPE zakup AS OBJECT (
 numer_klienta NUMBER,
 produkty koszyk_produktow );
 
CREATE TABLE zakupy OF zakup
NESTED TABLE produkty STORE AS tabela_produkty;

INSERT INTO zakupy VALUES
(zakup(1,koszyk_produktow('produkt_1','produkt_2','produkt_3')));
INSERT INTO zakupy VALUES
(zakup(2,koszyk_produktow('produkt_2','produkt_4')));
INSERT INTO zakupy VALUES
(zakup(3,koszyk_produktow('produkt_6','produkt_7', 'produkt_8')));
INSERT INTO zakupy VALUES
(zakup(3,koszyk_produktow('produkt_5')));

SELECT * FROM ZAKUPY;

DELETE FROM zakupy 
WHERE numer_klienta in (
SELECT z.numer_klienta
FROM zakupy z, TABLE(z.produkty) p
where p.column_value = 'produkt_8');



-- zadanie 12
CREATE TYPE instrument AS OBJECT (
 nazwa VARCHAR2(20),
 dzwiek VARCHAR2(20),
 MEMBER FUNCTION graj RETURN VARCHAR2 ) NOT FINAL;
CREATE TYPE BODY instrument AS
 MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN dzwiek;
 END;
END;
/
CREATE TYPE instrument_dety UNDER instrument (
 material VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_dety AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'dmucham: '||dzwiek;
 END;
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
 BEGIN
 RETURN glosnosc||':'||dzwiek;
 END;
END;
/
CREATE TYPE instrument_klawiszowy UNDER instrument (
 producent VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'stukam w klawisze: '||dzwiek;
 END;
END;
/
DECLARE
 tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
 trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
 fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','pingping','steinway');
BEGIN
 dbms_output.put_line(tamburyn.graj);
 dbms_output.put_line(trabka.graj);
 dbms_output.put_line(trabka.graj('glosno');
 dbms_output.put_line(fortepian.graj);
END;

-- zadanie 13
CREATE TYPE istota AS OBJECT (
 nazwa VARCHAR2(20),
 NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR )
 NOT INSTANTIABLE NOT FINAL;
CREATE TYPE lew UNDER istota (
 liczba_nog NUMBER,
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR );
CREATE OR REPLACE TYPE BODY lew AS
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
 BEGIN
 RETURN 'upolowana ofiara: '||ofiara;
 END;
END;
DECLARE
 KrolLew lew := lew('LEW',4);
 InnaIstota istota := istota('JAKIES ZWIERZE');
BEGIN
 DBMS_OUTPUT.PUT_LINE( KrolLew.poluj('antylopa') );
END;

-- zadanie 14
DECLARE
 tamburyn instrument;
 cymbalki instrument;
 trabka instrument_dety;
 saksofon instrument_dety;
BEGIN
 tamburyn := instrument('tamburyn','brzdek-brzdek');
 cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
 trabka := instrument_dety('trabka','tra-ta-ta','metalowa');
 -- saksofon := instrument('saksofon','tra-taaaa');
 -- saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);
END;

-- zadanie 15
CREATE TABLE instrumenty OF instrument;
INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES ( instrument_dety('trabka','tra-ta-ta','metalowa')
);
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','pingping','steinway') );
SELECT i.nazwa, i.graj() FROM instrumenty i;

-- zadanie 16
CREATE TABLE PRZEDMIOTY (
 NAZWA VARCHAR2(50),
 NAUCZYCIEL NUMBER REFERENCES PRACOWNICY(ID_PRAC)
);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',100);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',100);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',110);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',110);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',120);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',120);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',130);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',140);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',140);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',140);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',150);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',150);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',160);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',160);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',170);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',180);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',180);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',190);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',200);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',210);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',220);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',220);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',230);

-- zadanie 17
CREATE TYPE ZESPOL AS OBJECT (
 ID_ZESP NUMBER,
 NAZWA VARCHAR2(50),
 ADRES VARCHAR2(100)
);
/

-- zadanie 18
CREATE OR REPLACE VIEW ZESPOLY_V OF ZESPOL
WITH OBJECT IDENTIFIER(ID_ZESP)
AS SELECT ID_ZESP, NAZWA, ADRES FROM ZESPOLY;
-- zadanie 19
CREATE TYPE PRZEDMIOTY_TAB AS TABLE OF VARCHAR2(100);
/
CREATE TYPE PRACOWNIK AS OBJECT (
 ID_PRAC NUMBER,
 NAZWISKO VARCHAR2(30),
 ETAT VARCHAR2(20),
 ZATRUDNIONY DATE,
 PLACA_POD NUMBER(10,2),
 MIEJSCE_PRACY REF ZESPOL,
 PRZEDMIOTY PRZEDMIOTY_TAB,
 MEMBER FUNCTION ILE_PRZEDMIOTOW RETURN NUMBER
);
/
CREATE OR REPLACE TYPE BODY PRACOWNIK AS
 MEMBER FUNCTION ILE_PRZEDMIOTOW RETURN NUMBER IS
 BEGIN
 RETURN PRZEDMIOTY.COUNT();
 END ILE_PRZEDMIOTOW;
END;
-- zadanie 20
CREATE OR REPLACE VIEW PRACOWNICY_V OF PRACOWNIK
WITH OBJECT IDENTIFIER (ID_PRAC)
AS SELECT ID_PRAC, NAZWISKO, ETAT, ZATRUDNIONY, PLACA_POD,
 MAKE_REF(ZESPOLY_V,ID_ZESP),
 CAST(MULTISET( SELECT NAZWA FROM PRZEDMIOTY WHERE NAUCZYCIEL=P.ID_PRAC ) AS
PRZEDMIOTY_TAB )
FROM PRACOWNICY P;

-- zadanie 21
SELECT *
FROM PRACOWNICY_V;
SELECT P.NAZWISKO, P.ETAT, P.MIEJSCE_PRACY.NAZWA
FROM PRACOWNICY_V P;
SELECT P.NAZWISKO, P.ILE_PRZEDMIOTOW()
FROM PRACOWNICY_V P;
SELECT *
FROM TABLE( SELECT PRZEDMIOTY FROM PRACOWNICY_V WHERE NAZWISKO='WEGLARZ' );
SELECT NAZWISKO, CURSOR( SELECT PRZEDMIOTY
FROM PRACOWNICY_V
WHERE ID_PRAC=P.ID_PRAC)
FROM PRACOWNICY_V P;

-- zadanie 22

CREATE TYPE tabela_pisarze (
 ID_PISARZA NUMBER,
 NAZWISKO VARCHAR2(20),
 DATA_UR DATE,
 KSIAZKI tabela_ksiazki,
 MEMBER FUNCTION num_ksiazki RETURN NUMBER);
 
CREATE TYPE tabela_ksiazki AS TABLE OF KSIAZKI;

CREATE OR REPLACE TYPE BODY tabela_pisarze AS
MEMBER FUNCTION num_ksiazki RETURN NUMBER IS
	BEGIN
		RETURN tabela_ksiazki.COUNT();
	END num_ksiazki;
END;

CREATE TYPE KSIAZKA AS OBJECT(
    ID_KSIAZKI NUMBER,
    ID_PISARZA REF tabela_pisarze,
    TYTUL VARCHAR2(50),
    DATA_WYDANIE DATE,
    MEMBER FUNCTION wiek_ksiazki RETURN NUMBER
)

CREATE OR REPLACE TYPE BODY KSIAZKA AS
MEMBER FUNCTION wiek_ksiazki RETURN NUMBER IS
	BEGIN
		RETURN (EXTRACT (YEAR FROM CURRENT_DATE) -  EXTRACT (YEAR FROM DATA_WYDANIE));
	END wiek_ksiazki;
END;

CREATE OR REPLACE VIEW view_pisarze OF tabela_pisarze
WITH OBJECT IDENTIFIER (ID_PISARZA)
AS SELECT ID_PISARZA, NAZWISKO, DATA_UR, CAST(MULTISET( SELECT TYTUL FROM KSIAZKI WHERE ID_PISARZA=P.ID_PISARZA ) AS tabela_ksiazki  )
FROM PISARZE P;

CREATE OR REPLACE VIEW view_ksiazki OF KSIAZKA
WITH OBJECT IDENTIFIER (ID_PISARZA)
AS SELECT ID_KSIAZKI, MAKE_REF(view_pisarze, ID_PISARZA), TYTUL, DATA_WYDANIE
FROM KSIAZKA;



-- zadanie 23
CREATE TYPE AUTO AS OBJECT (
 MARKA VARCHAR2(20),
 MODEL VARCHAR2(20),
 KILOMETRY NUMBER,
 DATA_PRODUKCJI DATE,
 CENA NUMBER(10,2),
 MEMBER FUNCTION WARTOSC RETURN NUMBER
);

CREATE TYPE AUTO_OSOBOWE UNDER AUTO (
    liczba_miejsc number,
    klimatyzacja CHAR(10),
    OVERRIDING MEMBER FUNCTION WARTOSC RETURN NUMBER
);
CREATE TYPE AUTO_CIEZAROWE UNDER AUTO (
    ladownosc number,
    OVERRIDING MEMBER FUNCTION WARTOSC RETURN NUMBER
);
CREATE TYPE BODY AUTO_OSOBOWE AS
 OVERRIDING MEMBER FUNCTION WARTOSC RETURN NUMBER IS
 BEGIN
 IF (klimatyzacja = 'tak') THEN
 WARTOSC := WARTOSC*1.5;
 END IF;
 RETURN WARTOSC;
END;

CREATE TYPE BODY AUTO_CIEZAROWE AS
 OVERRIDING MEMBER FUNCTION WARTOSC RETURN NUMBER IS
 BEGIN
 IF (ladownosc > 10) THEN
 WARTOSC := WARTOSC*2;
 END IF;
 RETURN WARTOSC;
END;

CREATE TABLE AUTA OF AUTO;
INSERT INTO AUTA VALUES (AUTO_OSOBOWE('FIAT','BRAVA',60000,DATE '1999-11-30',25000,6,'tak'));
INSERT INTO AUTA VALUES (AUTO_CIEZAROWE('FORD','MONDEO',80000,DATE '1997-05-10',45000,'20'));
INSERT INTO AUTA VALUES (AUTO_CIEZAROWE('MAZDA','323',12000,DATE '2000-09-22',52000,'5'));