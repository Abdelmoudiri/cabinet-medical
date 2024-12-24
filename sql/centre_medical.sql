-- Active: 1733407253980@@127.0.0.1@3306@centre_medical
CREATE DATABASE centre_medical;

USE centre_medical;

CREATE TABLE utilisateurs(
	id_utilisateur INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(30) NOT NULL,
	prenom VARCHAR(30) NOT NULL,
    type_utilisateur ENUM('patient','medecin') NOT NULL
);

CREATE TABLE rendez_vous(
	id_rdv INT AUTO_INCREMENT PRIMARY KEY,
    id_patient INT NOT NULL,
    id_medecin INT NOT NULL,
    date_rdv DATE NOT NULL,
    statut ENUM('confirme','non confirme') DEFAULT 'confirme',
    FOREIGN KEY (id_patient) REFERENCES utilisateurs(id_utilisateur) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_medecin) REFERENCES utilisateurs(id_utilisateur) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE factures(
	id_facture INT AUTO_INCREMENT PRIMARY KEY,
	id_rdv INT NOT NULL UNIQUE,
	montant FLOAT NOT NULL,
	date_facture DATE NOT NULL,
	FOREIGN KEY (id_rdv) REFERENCES rendez_vous(id_rdv) ON DELETE CASCADE ON UPDATE CASCADE
);


INSERT INTO utilisateurs(nom,prenom,type_utilisateur)
VALUES ('achraf','hakimi','medecin'),
       ('ibrahim','diaz','patient'),
       ('hakim','ziyech','patient'),
       ('sofian','amrabt','medecin'),
       ('kevin','De bruyne','patient'),
       ('luka','modric','patient'),
       ('leo','messi','medecin');


INSERT INTO rendez_vous(id_patient,id_medecin,date_rdv)
VALUES (2,1,'2024-12-30'),
       (5,1,'2024-12-30'),
       (3,7,'2024-12-26'),
       (2,4,'2024-12-26'),
       (6,7,'2024-12-24'),
       (6,4,'2024-12-24'),
       (3,1,'2024-12-31'),
       (2,1,'2024-12-31'),
       (5,7,'2024-12-28');
       

INSERT INTO factures(id_rdv,montant,date_facture)
VALUES (1,2000,'2025-01-01'),
       (3,1540,'2025-01-03'),
       (5,3200,'2025-01-05'),
       (7,1150,'2025-01-02'),
       (9,650,'2025-01-04'),
       (2,2450,'2025-01-06');



TRUNCATE TABLE utilisateurs;
TRUNCATE TABLE rendez_vous;
set foreign_key_checks=0;
set foreign_key_checks=1;
TRUNCATE TABLE factures;

-- Afficher tous les rendez-vous d'un patient particulier.
SELECT CONCAT(U.nom,' ',U.prenom) as 'nom complet', R.date_rdv,R.statut
FROM rendez_vous R
     JOIN utilisateurs U 
     ON U.id_utilisateur = R.id_patient
     WHERE R.id_patient = 2 ;




-- Afficher tous les rendez-vous confirmés ou non confirmés.

SELECT U.nom, U.prenom, R.id_medecin, R.date_rdv, R.statut
FROM rendez_vous R 
	 JOIN utilisateurs U 
     ON R.id_patient = U.id_utilisateur
WHERE statut = 'confirme';

-- non confirmer

SELECT CONCAT(U.nom, ' ',U.prenom) as 'nom complet', R.id_medecin, R.date_rdv, R.statut
FROM rendez_vous R 
	 JOIN utilisateurs U 
     ON R.id_patient = U.id_utilisateur
WHERE statut = 'non confirme';



-- Afficher le détail des rendez-vous avec les informations sur les utilisateurs et les médecins (utilisation de jointures)

select u_p.nom , u_p.prenom,u_m.nom , u_m.prenom,r.* from rendez_vous r 
        join utilisateurs u_p on r.id_patient=u_p.id_utilisateur 
        join utilisateurs u_m on u_m.id_utilisateur=r.id_medecin  ;








-- Exercice 4 : Mise à jour des données
-- Écrivez une requête SQL pour modifier le statut d'un rendez-vous, par exemple pour passer de "non confirmé" à "confirmé".

UPDATE rendez_vous
SET statut = 'non confirme'
WHERE id_rdv = 1;


-- Exercice 5 : Suppression des données
-- Écrivez une requête SQL pour supprimer un rendez-vous ou un utilisateur (patient ou médecin).

DELETE FROM rendez_vous
WHERE id_rdv = 1;



DELETE FROM utilisateurs
WHERE id_utilisateur = 4;



-- 6 Calcul du nombre total de rendez-vous par patient :
-- Écrivez une requête SQL pour compter combien de rendez-vous ont été pris par chaque patient

SELECT CONCAT(U.prenom,' ',U.nom) AS nom_complet,
	   COUNT(R.id_rdv) AS nombre_rdv
FROM rendez_vous R 
	 JOIN utilisateurs U
     ON U.id_utilisateur = R.id_patient
     GROUP BY nom_complet;



-- Somme des montants des factures par patient :
-- Écrivez une requête SQL pour afficher la somme totale des montants facturés pour chaque patient.

SELECT CONCAT(U.prenom,' ',U.nom) AS nom_complet,
	   SUM(F.montant) AS montant_total
FROM rendez_vous R 
	 JOIN utilisateurs U ON U.id_utilisateur = R.id_patient
     JOIN factures F ON F.id_rdv = R.id_rdv
GROUP BY nom_complet;


-- Moyenne des montants des factures pour tous les rendez-vous confirmés :
-- Écrivez une requête SQL pour calculer la moyenne des montants des factures où le statut du rendez-vous est "confirmé".


SELECT AVG(F.montant) AS moyenne_montant
FROM rendez_vous R 
     JOIN factures F ON F.id_rdv = R.id_rdv
WHERE R.statut = 'confirme';

-- Écrivez une requête SQL pour trouver la date du rendez-vous le plus récent et du plus ancien.

SELECT max(date_rdv) as 'datemax', min(date_rdv) as 'datemin'  from rendez_vous;

-- Écrivez une requête SQL pour afficher les médecins qui ont le plus de rendez-vous confirmés (avec un classement optionnel par ordre décroissant).
SELECT CONCAT(u_m.prenom,' ',u_m.nom ) as 'medecine' ,COUNT(r.id_rdv) as 'nombre_de_RDV' from rendez_vous r
                join utilisateurs u_m on r.id_medecin=u_m.id_utilisateur
                where statut='confirme'  GROUP BY medecine HAVING LENGTH(medecine)>9  ORDER BY nombre_de_RDV DESC;