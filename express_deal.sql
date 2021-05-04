-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3309
-- Généré le :  mar. 04 mai 2021 à 12:20
-- Version du serveur :  5.7.26
-- Version de PHP :  7.3.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `express_deal`
--

DELIMITER $$
--
-- Procédures
--
DROP PROCEDURE IF EXISTS `get_employe_par_identifiants`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_employe_par_identifiants` (IN `p_login` VARCHAR(16), IN `p_mdp` VARCHAR(40))  NO SQL
BEGIN
     SELECT * from employe WHERE employe.login = p_login AND employe.mdp = 		p_mdp;
END$$

--
-- Fonctions
--
DROP FUNCTION IF EXISTS `se_connecter`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `se_connecter` (`p_login` VARCHAR(16), `p_mdp` VARCHAR(40)) RETURNS TINYINT(1) NO SQL
BEGIN
	IF(EXISTS(select * FROM employe WHERE login = p_login AND mdp = p_mdp))         THEN
        RETURN TRUE;
    END IF;
       
    RETURN FALSE;


END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `adresse`
--

DROP TABLE IF EXISTS `adresse`;
CREATE TABLE IF NOT EXISTS `adresse` (
  `adresse_id` int(10) NOT NULL AUTO_INCREMENT,
  `adresse` varchar(50) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`adresse_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `adresse`
--

INSERT INTO `adresse` (`adresse_id`, `adresse`, `phone`, `updated_at`) VALUES
(1, '62  Place de la Madeleine 75008 Paris', '09784541464', '2021-04-27 16:12:47'),
(2, '130  place de Miremont 75019 Paris', '09784541463', '2021-04-27 16:21:23');

-- --------------------------------------------------------

--
-- Structure de la table `categorie`
--

DROP TABLE IF EXISTS `categorie`;
CREATE TABLE IF NOT EXISTS `categorie` (
  `categorie_id` int(10) NOT NULL AUTO_INCREMENT,
  `nom` varchar(25) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`categorie_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `categorie`
--

INSERT INTO `categorie` (`categorie_id`, `nom`, `updated_at`) VALUES
(1, 'Electro', '2021-04-28 00:50:34'),
(2, 'Outillage', '2021-04-28 00:50:46'),
(3, 'Jardin', '2021-04-28 00:50:53'),
(4, 'Motoculture', '2021-04-28 00:51:03'),
(5, 'Chantier', '2021-04-28 00:51:10');

-- --------------------------------------------------------

--
-- Structure de la table `client`
--

DROP TABLE IF EXISTS `client`;
CREATE TABLE IF NOT EXISTS `client` (
  `client_id` int(10) NOT NULL AUTO_INCREMENT,
  `magasin_id` int(10) NOT NULL,
  `nom` varchar(45) NOT NULL,
  `prenom` varchar(45) NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  `adresse_id` int(10) NOT NULL,
  `actif` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`client_id`),
  KEY `idx_fk_magasin_id` (`magasin_id`),
  KEY `idx_fk_adresse_id` (`adresse_id`),
  KEY `idx_prenom` (`prenom`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déclencheurs `client`
--
DROP TRIGGER IF EXISTS `client_create_date`;
DELIMITER $$
CREATE TRIGGER `client_create_date` BEFORE INSERT ON `client` FOR EACH ROW SET NEW.created_at = NOW()
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `employe`
--

DROP TABLE IF EXISTS `employe`;
CREATE TABLE IF NOT EXISTS `employe` (
  `employe_id` int(10) NOT NULL AUTO_INCREMENT,
  `nom` varchar(45) NOT NULL,
  `prenom` varchar(45) NOT NULL,
  `adresse_id` int(10) NOT NULL,
  `image_url` varchar(2048) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `magasin_id` int(10) NOT NULL,
  `actif` tinyint(1) NOT NULL DEFAULT '1',
  `login` varchar(16) NOT NULL,
  `mdp` varchar(40) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`employe_id`),
  KEY `idx_fk_magasin_id` (`magasin_id`),
  KEY `idx_fk_adresse_id` (`adresse_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `employe`
--

INSERT INTO `employe` (`employe_id`, `nom`, `prenom`, `adresse_id`, `image_url`, `email`, `magasin_id`, `actif`, `login`, `mdp`, `updated_at`) VALUES
(1, 'Garllot', 'Dorine', 1, NULL, 'dorine@express-deal.com', 1, 1, 'gdorine', '1234', '2021-04-27 16:07:11'),
(3, 'Martin', 'Robert', 1, NULL, 'mr@express-deal.com', 1, 1, 'mrobert', '1234', '2021-04-27 16:20:02'),
(4, 'Durand', 'Thomas', 2, NULL, 'dt@express-deal.com', 2, 1, 'dthomas', '1234', '2021-04-27 16:24:26'),
(5, 'Goudreau', 'Leroy', 2, NULL, 'lg@express-deal.com', 2, 1, 'gleroy', '1234', '2021-04-27 16:38:13');

-- --------------------------------------------------------

--
-- Structure de la table `inventaire`
--

DROP TABLE IF EXISTS `inventaire`;
CREATE TABLE IF NOT EXISTS `inventaire` (
  `inventaire_id` int(10) NOT NULL AUTO_INCREMENT,
  `materiel_id` int(10) NOT NULL,
  `magasin_id` int(10) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`inventaire_id`),
  KEY `idx_fk_materiel_id` (`materiel_id`),
  KEY `idx_magasin_id_materiel_id` (`magasin_id`,`materiel_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `inventaire`
--

INSERT INTO `inventaire` (`inventaire_id`, `materiel_id`, `magasin_id`, `updated_at`) VALUES
(1, 1, 1, '2021-04-28 01:04:18');

-- --------------------------------------------------------

--
-- Structure de la table `location`
--

DROP TABLE IF EXISTS `location`;
CREATE TABLE IF NOT EXISTS `location` (
  `location_id` int(10) NOT NULL AUTO_INCREMENT,
  `date_location` datetime NOT NULL,
  `inventaire_id` int(10) NOT NULL,
  `client_id` int(10) NOT NULL,
  `return_date` datetime DEFAULT NULL,
  `employe_id` int(10) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`location_id`),
  UNIQUE KEY `unique_location` (`date_location`,`inventaire_id`,`client_id`),
  KEY `idx_fk_inventaire_id` (`inventaire_id`),
  KEY `idx_fk_client_id` (`client_id`),
  KEY `idx_fk_employe_id` (`employe_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déclencheurs `location`
--
DROP TRIGGER IF EXISTS `location_date`;
DELIMITER $$
CREATE TRIGGER `location_date` BEFORE INSERT ON `location` FOR EACH ROW SET NEW.date_location = NOW()
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `magasin`
--

DROP TABLE IF EXISTS `magasin`;
CREATE TABLE IF NOT EXISTS `magasin` (
  `magasin_id` int(10) NOT NULL AUTO_INCREMENT,
  `directeur_personnel_id` int(10) NOT NULL,
  `adresse_id` int(10) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`magasin_id`),
  UNIQUE KEY `idx_unique_directeur` (`directeur_personnel_id`),
  KEY `idx_fk_adresse_id` (`adresse_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `magasin`
--

INSERT INTO `magasin` (`magasin_id`, `directeur_personnel_id`, `adresse_id`, `updated_at`) VALUES
(1, 3, 1, '2021-04-27 16:18:23'),
(2, 4, 2, '2021-04-27 16:24:46');

-- --------------------------------------------------------

--
-- Structure de la table `materiel`
--

DROP TABLE IF EXISTS `materiel`;
CREATE TABLE IF NOT EXISTS `materiel` (
  `materiel_id` int(10) NOT NULL AUTO_INCREMENT,
  `categorie_id` int(10) NOT NULL,
  `nom` varchar(128) NOT NULL,
  `description` text,
  `marque` varchar(45) NOT NULL,
  `duree_location` tinyint(3) UNSIGNED NOT NULL DEFAULT '3',
  `cout_location` float NOT NULL DEFAULT '4.99',
  `cout_remplacement` float NOT NULL DEFAULT '19.99',
  `taille` enum('Petit','Moyen','Grand') DEFAULT 'Petit',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`materiel_id`),
  KEY `idx_nom` (`nom`),
  KEY `idx_fk_categorie_id` (`categorie_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `materiel`
--

INSERT INTO `materiel` (`materiel_id`, `categorie_id`, `nom`, `description`, `marque`, `duree_location`, `cout_location`, `cout_remplacement`, `taille`, `updated_at`) VALUES
(1, 1, 'Cloueuse pneumatique PT18 ARROW\r\n', 'La cloueuse pneumatique PT18 est un outil pneumatique compact et robuste. Sa prise en main ergonomique permet de travailler avec une cadence soutenue. Le chargement des pointes s\'effectue par l\'arrière de l\'appareil.\r\n\r\nCette cloueuse professionnelle est sécurisé : le système ne peut pas se déclencher tant que la machine n\'est pas en appui contre la surface à clouer.\r\n', 'ARROW', 7, 19.99, 62.9, 'Petit', '2021-04-28 15:44:38');

-- --------------------------------------------------------

--
-- Structure de la table `paiement`
--

DROP TABLE IF EXISTS `paiement`;
CREATE TABLE IF NOT EXISTS `paiement` (
  `paiement_id` int(10) NOT NULL AUTO_INCREMENT,
  `client_id` int(10) NOT NULL,
  `employe_id` int(10) NOT NULL,
  `location_id` int(10) DEFAULT NULL,
  `montant` float NOT NULL,
  `paiement_date` datetime NOT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`paiement_id`),
  KEY `idx_fk_employe_id` (`employe_id`),
  KEY `idx_fk_client_id` (`client_id`),
  KEY `fk_paiement_location` (`location_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déclencheurs `paiement`
--
DROP TRIGGER IF EXISTS `paiement_date`;
DELIMITER $$
CREATE TRIGGER `paiement_date` BEFORE INSERT ON `paiement` FOR EACH ROW SET NEW.paiement_date = NOW()
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `type_client`
--

DROP TABLE IF EXISTS `type_client`;
CREATE TABLE IF NOT EXISTS `type_client` (
  `type_client_id` int(10) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(50) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`type_client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `client`
--
ALTER TABLE `client`
  ADD CONSTRAINT `fk_client_adresse` FOREIGN KEY (`adresse_id`) REFERENCES `adresse` (`adresse_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_client_magasin` FOREIGN KEY (`magasin_id`) REFERENCES `magasin` (`magasin_id`) ON UPDATE CASCADE;

--
-- Contraintes pour la table `employe`
--
ALTER TABLE `employe`
  ADD CONSTRAINT `fk_employe_adresse` FOREIGN KEY (`adresse_id`) REFERENCES `adresse` (`adresse_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_employe_magasin_id` FOREIGN KEY (`magasin_id`) REFERENCES `magasin` (`magasin_id`) ON UPDATE CASCADE;

--
-- Contraintes pour la table `inventaire`
--
ALTER TABLE `inventaire`
  ADD CONSTRAINT `fk_inventaire_magasin` FOREIGN KEY (`magasin_id`) REFERENCES `magasin` (`magasin_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inventaire_materiel` FOREIGN KEY (`materiel_id`) REFERENCES `materiel` (`materiel_id`) ON UPDATE CASCADE;

--
-- Contraintes pour la table `location`
--
ALTER TABLE `location`
  ADD CONSTRAINT `fk_location_client` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_location_employe` FOREIGN KEY (`employe_id`) REFERENCES `employe` (`employe_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_location_inventaire` FOREIGN KEY (`inventaire_id`) REFERENCES `inventaire` (`inventaire_id`) ON UPDATE CASCADE;

--
-- Contraintes pour la table `magasin`
--
ALTER TABLE `magasin`
  ADD CONSTRAINT `fk_magasin_adresse` FOREIGN KEY (`adresse_id`) REFERENCES `adresse` (`adresse_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_magasin_employe` FOREIGN KEY (`directeur_personnel_id`) REFERENCES `employe` (`employe_id`) ON UPDATE CASCADE;

--
-- Contraintes pour la table `materiel`
--
ALTER TABLE `materiel`
  ADD CONSTRAINT `fk_materiel_categorie` FOREIGN KEY (`categorie_id`) REFERENCES `categorie` (`categorie_id`);

--
-- Contraintes pour la table `paiement`
--
ALTER TABLE `paiement`
  ADD CONSTRAINT `fk_paiement_client` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_paiement_employe` FOREIGN KEY (`employe_id`) REFERENCES `employe` (`employe_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_paiement_location` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
