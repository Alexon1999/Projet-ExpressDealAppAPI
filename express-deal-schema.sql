SET NAMES utf8mb4;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';
SET FOREIGN_KEY_CHECKS=0;

DROP SCHEMA IF EXISTS express_deal;
CREATE SCHEMA express_deal;
USE express_deal;


--
-- Structure de la table `adresse`
--
CREATE TABLE adresse (
  adresse_id int(10) NOT NULL AUTO_INCREMENT,
  adresse VARCHAR(50) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (adresse_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

--
-- Structure de la table `categorie`
--
CREATE TABLE categorie (
  categorie_id int(10) NOT NULL AUTO_INCREMENT,
  nom VARCHAR(25) NOT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (categorie_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;



--
-- Structure de la table `employe`
--
CREATE TABLE employe (
  employe_id int(10) NOT NULL AUTO_INCREMENT,
  nom VARCHAR(45) NOT NULL,
  prenom VARCHAR(45) NOT NULL,
  adresse_id int(10) NOT NULL,
  image_url VARCHAR(2048) DEFAULT NULL,
  email VARCHAR(50) DEFAULT NULL,
  magasin_id int(10) NOT NULL,
  actif BOOLEAN NOT NULL DEFAULT TRUE,
  login VARCHAR(16) NOT NULL,
  mdp VARCHAR(40) NOT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (employe_id),
  KEY idx_fk_magasin_id (magasin_id),
  KEY idx_fk_adresse_id (adresse_id),
  CONSTRAINT fk_employe_magasin_id FOREIGN KEY (magasin_id) REFERENCES magasin (magasin_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_employe_adresse FOREIGN KEY (adresse_id) REFERENCES adresse (adresse_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;



--
-- Structure de la table `materiel`
--
CREATE TABLE materiel (
  materiel_id int(10) NOT NULL AUTO_INCREMENT,
  categorie_id int(10) NOT NULL,
  nom VARCHAR(128) NOT NULL,
  description TEXT DEFAULT NULL,
  duree_location TINYINT UNSIGNED NOT NULL DEFAULT 3,
  cout_location DECIMAL(4, 2) NOT NULL DEFAULT 4.99,
  cout_remplacement DECIMAL(5, 2) NOT NULL DEFAULT 19.99,
  marque VARCHAR(45) NOT NULL,
  taille ENUM('Petit', 'Moyen', 'Grand') DEFAULT 'Petit',
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (materiel_id),
  KEY idx_nom (nom) ,
  KEY idx_fk_categorie_id(categorie_id),
  CONSTRAINT fk_materiel_categorie FOREIGN KEY(categorie_id) REFERENCES categorie(categorie_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

--
-- Structure de la table `inventaire`
--
CREATE TABLE inventaire (
  inventaire_id int(10) NOT NULL AUTO_INCREMENT,
  materiel_id int(10) NOT NULL,
  magasin_id int(10) NOT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (inventaire_id),
  KEY idx_fk_materiel_id (materiel_id),
  KEY idx_magasin_id_materiel_id (magasin_id, materiel_id),
  CONSTRAINT fk_inventaire_magasin FOREIGN KEY (magasin_id) REFERENCES magasin (magasin_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_inventaire_materiel FOREIGN KEY (materiel_id) REFERENCES materiel (materiel_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;


--
-- Structure de la table `magasin`
--
CREATE TABLE magasin (
  magasin_id int(10) NOT NULL AUTO_INCREMENT,
  directeur_personnel_id int(10) NOT NULL,
  adresse_id int(10) NOT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (magasin_id),
  UNIQUE KEY idx_unique_directeur (directeur_personnel_id),
  KEY idx_fk_adresse_id (adresse_id),
  CONSTRAINT fk_magasin_employe FOREIGN KEY (directeur_personnel_id) REFERENCES employe (employe_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_magasin_adresse FOREIGN KEY (adresse_id) REFERENCES adresse (adresse_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

--
-- Structure de la table `location`
--
CREATE TABLE location (
  location_id int(10) NOT NULL AUTO_INCREMENT,
  date_location DATETIME NOT NULL,
  inventaire_id int(10) NOT NULL,
  client_id int(10) NOT NULL,
  date_retour DATETIME DEFAULT NULL,
  employe_id int(10)  NOT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (location_id),
  UNIQUE KEY unique_location(date_location, inventaire_id, client_id),
  KEY idx_fk_inventaire_id (inventaire_id),
  KEY idx_fk_client_id (client_id),
  KEY idx_fk_employe_id (employe_id),
  CONSTRAINT fk_location_employe FOREIGN KEY (employe_id) REFERENCES employe (employe_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_location_inventaire FOREIGN KEY (inventaire_id) REFERENCES inventaire (inventaire_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_location_client FOREIGN KEY (client_id) REFERENCES client (client_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

--
-- Structure de la table `type_client`
--
CREATE TABLE type_client (
  type_client_id int(10) NOT NULL AUTO_INCREMENT,
  libelle VARCHAR(50) NOT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (type_client_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

--
-- Structure de la table `client`
--
CREATE TABLE client (
  client_id int(10) NOT NULL AUTO_INCREMENT,
  magasin_id int(10) NOT NULL,
  nom VARCHAR(45) NOT NULL,
  prenom VARCHAR(45) NOT NULL,
  email VARCHAR(50) DEFAULT NULL,
  adresse_id int(10) NOT NULL,
  type_client_id int(10) NOT NULL,
  actif BOOLEAN NOT NULL DEFAULT TRUE,
  created_at DATETIME NOT NULL ,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (client_id),
  KEY idx_fk_magasin_id (magasin_id),
  KEY idx_fk_adresse_id (adresse_id),
  KEY idx_prenom (prenom),
  CONSTRAINT fk_client_adresse FOREIGN KEY (adresse_id) REFERENCES adresse (adresse_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT fk_client_type_client FOREIGN KEY(type_client_id) REFERENCES type_client(type_client_id) ON UPDATE CASCADE;
  CONSTRAINT fk_client_magasin FOREIGN KEY (magasin_id) REFERENCES magasin (magasin_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

--
-- Structure de la table `paiement`
--
CREATE TABLE paiement (
  paiement_id int(10) NOT NULL AUTO_INCREMENT,
  client_id int(10) NOT NULL,
  employe_id int(10) NOT NULL,
  location_id int(10) DEFAULT NULL,
  montant DECIMAL(5, 2) NOT NULL,
  paiement_date DATETIME NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (paiement_id),
  KEY idx_fk_employe_id (employe_id),
  KEY idx_fk_client_id (client_id),
  CONSTRAINT fk_paiement_location FOREIGN KEY (location_id) REFERENCES location (location_id) ON DELETE
  SET
    NULL ON UPDATE CASCADE,
    CONSTRAINT fk_paiement_client FOREIGN KEY (client_id) REFERENCES client (client_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_paiement_employe FOREIGN KEY (employe_id) REFERENCES employe (employe_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TRIGGER client_create_date BEFORE INSERT ON client
	FOR EACH ROW SET NEW.created_at = NOW();


CREATE TRIGGER location_date BEFORE INSERT ON location
	FOR EACH ROW SET NEW.date_location = NOW();
  

CREATE TRIGGER paiement_date BEFORE INSERT ON paiement
	FOR EACH ROW SET NEW.paiement_date = NOW();



-- 1) get_nb_locations_aujourdhui_par_magasin
CREATE VIEW get_nb_locations_aujourdhui_par_magasin as
select e.magasin_id, count(*) from location l INNER JOIN employe e ON e.employe_id = l.employe_id where YEAR(l.date_location) = YEAR(now()) AND MONTH(l.date_location) = MONTH(NOW()) AND DAY(l.date_location) = DAY(NOW()) GROUP BY e.magasin_id

-- 2) magain_tries_par_ca
CREATE VIEW magain_tries_par_CA as
select e.magasin_id, SUM(m.cout_location) as CA from location l INNER JOIN employe e ON e.employe_id = l.employe_id INNER JOIN inventaire i on i.inventaire_id= l.inventaire_id INNER JOIN materiel m on m.materiel_id = i.materiel_id  GROUP BY e.magasin_id ORDER BY CA DESC


CREATE OR REPLACE VIEW materiel_tries_par_nbEmprunts AS select m.materiel_id, m.nom, count(m.materiel_id) AS emprunts from location l INNER JOIN employe e ON e.employe_id = l.employe_id INNER JOIN inventaire i on i.inventaire_id= l.inventaire_id INNER JOIN materiel m on m.materiel_id = i.materiel_id GROUP BY m.materiel_id ORDER BY emprunts DESC

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
SET FOREIGN_KEY_CHECKS=1