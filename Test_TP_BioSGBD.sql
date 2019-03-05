
/* Create tablespace */
create tablespace bioinfo datafile 'C:\Users\Ilyes\Desktop\bd.dat' size 100m autoextend on;

/* Create user and its password */
create user Ilyes identified by Ilyes default tablespace bioinfo;
grant all privileges to ilyes;

/* Create table Hospital */
CREATE TABLE Hospital(
	code_Hospital NCHAR(5) PRIMARY KEY,
	name_Hospital VARCHAR2(30) not null,
	wilaya_Hospital INT,
	NB_service_Hospital INT,
	date_creation_Hospital NCHAR(10),	
	CONSTRAINT CHECK_wilaya_Hospital CHECK(wilaya_Hospital > 0 and wilaya_Hospital < 49),
	CONSTRAINT CHECK_NB_service_Hospital CHECK(NB_service_Hospital > -1)
);
	
/* Create table Service */
CREATE TABLE Service(
	code_Service NCHAR(5) not null,
	code_Hospital_Service NCHAR(5) not null,
	name_Service VARCHAR2(30) NOT NULL,
	batiment_Service NCHAR(5) NOT NULL,
	tel_Service NCHAR(13),
	CONSTRAINT PK_Service PRIMARY KEY (code_Service, code_Hospital_Service),
	CONSTRAINT FK_Hospital_Service FOREIGN KEY (code_Hospital_Service) REFERENCES Hospital(code_Hospital)
);

/* Create table Chambre */
CREATE TABLE Chambre(
	code_Hospital_Chambre NCHAR(5) NOT NULL,
	code_Service_Chambre NCHAR(5) NOT NULL,
	numero_Chambre INT NOT NULL,
	nb_Lits_Chambre INT,
	CONSTRAINT CHECK_nb_Lits_Chambre CHECK (nb_Lits_Chambre > 0),
	CONSTRAINT CHECK_numero_Chambre CHECK (numero_Chambre > 0),
	CONSTRAINT PK_Chambre PRIMARY KEY (code_Hospital_Chambre, code_Service_Chambre, numero_Chambre),
	CONSTRAINT FK_Hospital_Service_Chambre FOREIGN KEY (code_Hospital_Chambre, code_Service_Chambre) REFERENCES Service(code_Hospital_Service, code_Service)
);
	
/* Create table Patient */
CREATE TABLE Patient(
	nss_Patient INT PRIMARY KEY,
	name_Patient NCHAR(15),
	surname_Patient VARCHAR2(30),
	adresse_Patient VARCHAR2(50),
	tel_Patient NCHAR(13),
	mutuelle_Patient NCHAR(10)
);

/* Create table Hospitalisation */
CREATE TABLE Hospitalisation(
	nss_Patient_Hospitalisation INT NOT NULL,
	date_Hospitalisation NCHAR(10) NOT NULL,
	code_Service_Hospitalisation NCHAR(5) NOT NULL,
	code_Hospital_Hospitalisation NCHAR(5) NOT NULL,
	numero_Chambre_Hospitalisation INT NOT NULL,
	lit_Hospitalisation INT,
	CONSTRAINT PK_Hospitalisation PRIMARY KEY (nss_Patient_Hospitalisation, date_Hospitalisation),
	CONSTRAINT FK_Patient_Hospitalisation FOREIGN KEY (nss_Patient_Hospitalisation) REFERENCES Patient(nss_Patient),
	CONSTRAINT FK_Chambre_Hospitalisation FOREIGN KEY (numero_Chambre_Hospitalisation, code_Service_Hospitalisation, code_Hospital_Hospitalisation)
		REFERENCES Chambre(numero_Chambre, code_Service_Chambre, code_Hospital_Chambre)
);

/* Fill tables */
INSERT INTO Hospital VALUES ('TW56', 'Hindou Kole', 42, 56, '10/10/2019');
INSERT INTO Hospital VALUES ('KDHH1', 'Ouplash Jim', 16, 100, '10/10/2019');
INSERT INTO Hospital VALUES ('MPACH', 'Mustapha Pacha', 16, 100, '10/10/2019');
INSERT INTO Service VALUES ('PED', 'TW56', 'Pediaterie', 'Tol', '+213776815023');
INSERT INTO Service VALUES ('CARD', 'TW56', 'Cardiologie', 'smql', '+213559631240');
INSERT INTO Service VALUES ('ORL', 'TW56', 'ORL', 'ssqa', '+21354669332');
INSERT INTO Service VALUES ('CARD', 'KDHH1', 'Cardiologie', 'smql', '+213559631240');
INSERT INTO Service VALUES ('ORL', 'KDHH1', 'ORL', 'kbdc1', '+213664825320');
INSERT INTO Service VALUES ('PED', 'KDHH1', 'Pediaterie', 'smql', '+213778523214');
INSERT INTO Service VALUES ('DERM', 'KDHH1', 'Dermatologie', 'd1225', '+213559631240');
INSERT INTO Service VALUES ('NEURO', 'KDHH1', 'Neurologie', 'd1225', '+213665483324');
INSERT INTO Service VALUES ('PED', 'MPACH', 'Pediaterie', 'DLK41', '+213774123259');
INSERT INTO Chambre VALUES ('TW56', 'PED', 1, 5);
INSERT INTO Chambre VALUES ('TW56', 'PED', 2, 2);
INSERT INTO Chambre VALUES ('TW56', 'PED', 3, 4);
INSERT INTO Chambre VALUES ('TW56', 'PED', 4, 5);
INSERT INTO Chambre VALUES ('TW56', 'PED', 5, 5);
INSERT INTO Chambre VALUES ('TW56', 'CARD', 6, 2);
INSERT INTO Chambre VALUES ('TW56', 'CARD', 7, 2);
INSERT INTO Chambre VALUES ('KDHH1', 'PED', 1, 5);
INSERT INTO Chambre VALUES ('KDHH1', 'PED', 2, 2);
INSERT INTO Chambre VALUES ('KDHH1', 'PED', 3, 4);
INSERT INTO Chambre VALUES ('KDHH1', 'PED', 4, 5);
INSERT INTO Chambre VALUES ('KDHH1', 'PED', 5, 5);
INSERT INTO Chambre VALUES ('KDHH1', 'CARD', 6, 2);
INSERT INTO Chambre VALUES ('KDHH1', 'CARD', 7, 2);
INSERT INTO Chambre VALUES ('MPACH', 'PED', 1, 10);
INSERT INTO Chambre VALUES ('MPACH', 'PED', 13, 10);
INSERT INTO Patient VALUES (2234568, 'TAZI', 'Mohamed Ilyes', 'Batiment A1 ZHUN', '+213779856321', 'MUTUELLE');
INSERT INTO Patient VALUES (2234558, 'ABLA', 'Adem', 'Batiment A1 ZHUN', '+213779856321', 'MUTUELLE');
INSERT INTO Patient VALUES (2234566, 'BATOUCHE', 'AbdelRahmen Oussama', 'Batiment A1 ZHUN', '+213779856321', 'MUTUELLE');
INSERT INTO Patient VALUES (2234168, 'SKLAB', 'Madani', 'Batiment A1 ZHUN', '+213779856321', 'MUTUELLE');
INSERT INTO Patient VALUES (1134568, 'JOJO', 'Djamel', 'Batiment A1 ZHUN', '+213779856321', 'MUTUELLE');
INSERT INTO Hospitalisation VALUES (1134568, '12/12/2013', 'PED', 'MPACH', 1, 2);
INSERT INTO Hospitalisation VALUES (2234168, '12/12/2013', 'PED', 'MPACH', 13, 1);

/* Some requests on relations */

/* Question 15 : Retourner les numeros des patients hospitalisés dans la chambre 13
du service Cardio dans l'hopital Mustapha pacha */ 
SELECT nss_Patient_Hospitalisation
FROM Hospitalisation hosp, Hospital hop
WHERE numero_Chambre_Hospitalisation = 13
AND hop.name_Hospital LIKE 'Mustapha Pacha'
AND hop.code_Hospital = hosp.code_Hospital_Hospitalisation ;

/* Question 16 : Retourner le nombre des hospitalisés dans chaque service de chaque hopital */
SELECT code_Hospital_Hospitalisation, code_Service_Hospitalisation, Count(*)
FROM Hospitalisation
GROUP BY code_Hospital_Hospitalisation, code_Service_Hospitalisation ;

/* Question 18 : Retourner les hopitaux ayant le nombre de lit supérieur à la moyenne
au niveau national */
CREATE VIEW NombreLit_Hospital (CodeHopital, Nombre_Lit)
AS
SELECT code_Hospital_Chambre, SUM(nb_Lits_Chambre)
FROM Chambre
GROUP BY code_Hospital_Chambre; 

SELECT code_Hospital_Chambre
FROM Chambre, NombreLit_Hospital
WHERE Nombre_Lit > (SELECT AVG(Nombre_Lit)
					FROM NombreLit_Hospital)
GROUP BY code_Hospital_Chambre;
