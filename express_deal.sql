-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3309
-- Généré le :  ven. 07 mai 2021 à 20:02
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `adresse`
--

INSERT INTO `adresse` (`adresse_id`, `adresse`, `phone`, `updated_at`) VALUES
(1, '62  Place de la Madeleine 75008 Paris', '09784541464', '2021-04-27 16:12:47'),
(2, '130  place de Miremont 75019 Paris', '09784541463', '2021-04-27 16:21:23'),
(3, '89  avenue du Marechal Juin 97436 SAINT-LEU', '0167966435', '2021-05-04 22:16:29'),
(4, '39  rue Nationale 75003 PARIS', '01692047870', '2021-05-04 22:34:50'),
(5, '90  rue La Boétie, 75013 Paris', '01327179278', '2021-05-06 10:04:52'),
(6, '100  Faubourg Saint Honoré, 75019 Paris', '01788451056', '2021-05-06 10:06:00');

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
  `type_client_id` int(10) NOT NULL,
  PRIMARY KEY (`client_id`),
  KEY `idx_fk_magasin_id` (`magasin_id`),
  KEY `idx_fk_adresse_id` (`adresse_id`),
  KEY `idx_prenom` (`prenom`),
  KEY `idx_fk_type_client_id` (`type_client_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `client`
--

INSERT INTO `client` (`client_id`, `magasin_id`, `nom`, `prenom`, `email`, `adresse_id`, `actif`, `created_at`, `updated_at`, `type_client_id`) VALUES
(1, 1, 'Thomas', 'Chandler', 'tc@gmail.com', 3, 1, '2021-05-05 00:17:33', '2021-05-04 22:30:49', 1),
(2, 1, 'Brie', 'Bessons', 'bb@gmail.com', 4, 1, '2021-05-05 00:36:14', '2021-05-04 22:36:14', 2),
(3, 2, 'Chaloux', 'Felicienne', 'cf@gmail.com', 5, 1, '2021-05-06 12:07:11', '2021-05-06 10:07:11', 2),
(4, 2, 'Courtemanche', 'Cerise', 'cc@gmail.com', 6, 1, '2021-05-06 12:08:05', '2021-05-06 10:08:05', 1);

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
-- Doublure de structure pour la vue `client_fidele`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `client_fidele`;
CREATE TABLE IF NOT EXISTS `client_fidele` (
`client_id` int(10)
,`nom` varchar(45)
,`prenom` varchar(45)
,`nb_locs` bigint(21)
,`nb_returned_locs` bigint(21)
);

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
-- Doublure de structure pour la vue `get_nb_locations_aujourdhui_par_magasin`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `get_nb_locations_aujourdhui_par_magasin`;
CREATE TABLE IF NOT EXISTS `get_nb_locations_aujourdhui_par_magasin` (
`magasin_id` int(10)
,`count(*)` bigint(21)
);

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
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `inventaire`
--

INSERT INTO `inventaire` (`inventaire_id`, `materiel_id`, `magasin_id`, `updated_at`) VALUES
(1, 1, 1, '2021-04-28 01:04:18'),
(4, 1, 1, '2021-05-04 15:47:37'),
(5, 1, 1, '2021-05-04 15:57:22'),
(6, 2, 1, '2021-05-04 16:08:04'),
(7, 2, 1, '2021-05-04 16:08:04'),
(8, 4, 1, '2021-05-04 16:08:15'),
(9, 4, 1, '2021-05-04 16:08:15'),
(10, 4, 1, '2021-05-04 16:08:15'),
(11, 4, 1, '2021-05-04 16:08:15'),
(12, 4, 1, '2021-05-04 16:08:15'),
(13, 3, 1, '2021-05-04 16:08:27'),
(14, 3, 1, '2021-05-04 16:08:27'),
(15, 3, 1, '2021-05-04 16:08:27'),
(16, 3, 1, '2021-05-04 16:08:27'),
(17, 6, 1, '2021-05-04 16:08:39'),
(18, 6, 1, '2021-05-04 16:08:39'),
(19, 6, 1, '2021-05-04 16:08:39'),
(20, 6, 1, '2021-05-04 16:08:39'),
(21, 6, 1, '2021-05-04 16:08:39'),
(22, 6, 1, '2021-05-04 16:08:39'),
(23, 6, 1, '2021-05-04 16:08:39'),
(24, 6, 1, '2021-05-04 16:08:39'),
(25, 6, 1, '2021-05-04 16:08:39'),
(26, 6, 1, '2021-05-04 16:08:39'),
(27, 6, 1, '2021-05-04 16:08:39'),
(28, 6, 1, '2021-05-04 16:08:39'),
(29, 6, 1, '2021-05-04 16:08:39'),
(30, 6, 1, '2021-05-04 16:08:39'),
(31, 5, 1, '2021-05-04 16:08:53'),
(32, 5, 1, '2021-05-04 16:08:53'),
(33, 5, 1, '2021-05-04 16:08:53'),
(34, 5, 1, '2021-05-04 16:08:53'),
(35, 5, 1, '2021-05-04 16:08:53'),
(36, 5, 1, '2021-05-04 16:08:53'),
(37, 5, 1, '2021-05-04 16:08:53'),
(38, 5, 1, '2021-05-04 16:08:53'),
(39, 5, 1, '2021-05-04 16:08:53'),
(40, 5, 1, '2021-05-04 16:36:03'),
(41, 6, 1, '2021-05-04 16:36:20'),
(42, 1, 1, '2021-05-04 17:39:53'),
(43, 1, 1, '2021-05-04 17:39:53'),
(44, 7, 1, '2021-05-04 21:33:46'),
(45, 7, 1, '2021-05-04 21:33:46'),
(46, 7, 1, '2021-05-04 21:33:46'),
(47, 7, 1, '2021-05-04 21:33:46'),
(48, 8, 1, '2021-05-04 21:35:32'),
(49, 8, 1, '2021-05-04 21:35:32'),
(50, 9, 1, '2021-05-04 22:00:21'),
(51, 9, 1, '2021-05-04 22:00:21'),
(52, 9, 1, '2021-05-04 22:00:21'),
(53, 9, 1, '2021-05-04 22:00:21'),
(54, 9, 1, '2021-05-04 22:00:21'),
(55, 9, 1, '2021-05-04 22:00:21'),
(56, 10, 2, '2021-05-05 13:53:09'),
(57, 10, 2, '2021-05-05 13:53:09'),
(58, 4, 2, '2021-05-05 13:54:50'),
(59, 4, 2, '2021-05-05 13:54:50'),
(60, 4, 2, '2021-05-05 13:54:50'),
(61, 4, 2, '2021-05-05 13:54:50');

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
  `date_retour` datetime DEFAULT NULL,
  `employe_id` int(10) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`location_id`),
  UNIQUE KEY `unique_location` (`date_location`,`inventaire_id`,`client_id`),
  KEY `idx_fk_inventaire_id` (`inventaire_id`),
  KEY `idx_fk_client_id` (`client_id`),
  KEY `idx_fk_employe_id` (`employe_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `location`
--

INSERT INTO `location` (`location_id`, `date_location`, `inventaire_id`, `client_id`, `date_retour`, `employe_id`, `updated_at`) VALUES
(1, '2021-05-05 00:37:15', 1, 1, '2021-05-06 00:00:00', 3, '2021-05-07 18:46:36'),
(2, '2021-05-05 00:37:47', 4, 1, NULL, 3, '2021-05-04 22:38:36'),
(3, '2021-05-05 00:38:17', 5, 2, NULL, 3, '2021-05-04 22:38:17'),
(6, '2021-05-05 20:58:46', 31, 2, NULL, 3, '2021-05-05 18:58:46'),
(8, '2021-05-06 12:09:09', 56, 3, NULL, 4, '2021-05-06 12:51:18'),
(9, '2021-05-06 12:10:39', 59, 4, NULL, 4, '2021-05-06 12:51:29'),
(11, '2021-05-06 13:55:58', 7, 3, NULL, 3, '2021-05-06 11:55:58'),
(12, '2021-05-06 14:15:07', 13, 1, NULL, 1, '2021-05-06 12:15:07');

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
-- Doublure de structure pour la vue `magain_tries_par_ca`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `magain_tries_par_ca`;
CREATE TABLE IF NOT EXISTS `magain_tries_par_ca` (
`magasin_id` int(10)
,`CA` double
);

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `materiel`
--

INSERT INTO `materiel` (`materiel_id`, `categorie_id`, `nom`, `description`, `marque`, `duree_location`, `cout_location`, `cout_remplacement`, `taille`, `updated_at`) VALUES
(1, 2, 'Cloueuse pneumatique PT18 ARROW', 'La cloueuse pneumatique PT18 est un outil pneumatique compact et robuste. Sa prise en main ergonomique permet de travailler avec une cadence soutenue. Le chargement des pointes s\'effectue par l\'arrière de l\'appareil.\r\n\r\nCette cloueuse professionnelle est sécurisé : le système ne peut pas se déclencher tant que la machine n\'est pas en appui contre la surface à clouer.\r\n', 'ARROW', 7, 19.99, 62.9, 'Petit', '2021-05-05 21:25:30'),
(2, 2, 'Coffret tournevis porte-embouts universels', 'Avec tous les embouts courants, spéciaux et embouts de sécurité.\r\nTournevis porte-embouts avec manche bi-matières', 'KRAFTWERK', 3, 19.99, 34.9, 'Petit', '2021-05-04 16:01:25'),
(3, 3, 'Ébrancheur à 2 mains', 'Sécateurs professionnels pour la taille en viticulture.\r\nLame robuste à affûtage double rayon. Butées amortisseurs limitant la fatigue. Lames croisantes.\r\nCoupe tirante. Très résistant, ces sécateurs sont adaptés à la taille et à l\'élagage de grosses branches et de pieds de vigne.', 'BAHCO', 7, 39.99, 99.99, 'Petit', '2021-05-04 16:02:33'),
(4, 3, 'Désherbeur électrique 2000 W - DT 2000B', 'Le désherbeur électrique DT 2000B est économique et écologique car il n\'utilise pas de gaz. Par conséquent, il n\'y a pas de produits chimiques ni de rejet de CO2 lors de son utilisation.\r\n\r\nIl est utilisable sans perche en fonction décapeur thermique ce qui le rend pratique à l\'atelier ou pour les loisirs créatifs avec ses deux allures de chauffe de 50°C ou 600°C.', 'FARTOOLS', 5, 19.99, 26.99, 'Petit', '2021-05-04 16:03:59'),
(5, 4, 'Scarificateur électrique aérateur - 40 cm - 1600 W - GE-SA 1640', 'Cet appareil électrique double fonctions est à la fois un scarificateur puissant et un aérateur.\r\nLe produit est destiné à des surfaces de terrain allant jusqu\'à 800 m2.\r\nC\'est le complément parfait de votre tondeuse pour obtenir une belle surface de jardin.', 'EINHELL ', 6, 19.99, 149.99, 'Moyen', '2021-05-04 16:05:18'),
(6, 5, 'Escabeau PRO plateforme Aluminium', 'Escabeau équipé d\'une large plateforme 405x510mm avec garde corps et stabilisateurs télescopiques pour éviter tous les risques de chute.\r\nHauteur du garde corps 115mm\r\nPlateforme perforée permettant l\'évacuation rapide des liquides ou saletés.\r\nMarches monoblocs striées de profondeur 85mm.\r\nPlateau porte-outils.\r\nSystème de fermeture rapide comme un simple escabeau.\r\nSe déplace facilement grâce aux deux roulettes 150mm sur l\'arrière.\r\nCharge maxi 150kg.', 'OUTIFRANCE ', 3, 30.99, 80.9, 'Petit', '2021-05-05 21:29:08'),
(7, 2, 'test', 'et Du hdhd', 'ikea', 3, 56.9, 99.99, 'Grand', '2021-05-04 21:28:25'),
(8, 4, 'test 2', 'ftg ', 'le roi merlin', 8, 54.78, 73.67, 'Moyen', '2021-05-04 21:35:16'),
(9, 1, 'test 3', 'eh eh eh eh duej ', 'ikea', 7, 65.08, 43.6, 'Grand', '2021-05-04 22:00:05'),
(10, 2, 'Polisseuse filaire MAKITA Sa7000c, 1600 W', '5 plages de réglage de vitesse pour une finition parfaite. Régulateur électronique pour un démarrage sans à-coups et un maintien du régime sélectionné. Moteur puissant avec protection électronique contre les surcharges Makpower. Protection de la machine contre les poussières optimisée, carter en aluminium. Charbons autorupteurs pour éviter l\' endommagement de l\'induit', 'makita', 4, 16.99, 56.99, 'Petit', '2021-05-05 13:44:15');

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `materiel_tries_par_nbemprunts`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `materiel_tries_par_nbemprunts`;
CREATE TABLE IF NOT EXISTS `materiel_tries_par_nbemprunts` (
`materiel_id` int(10)
,`nom` varchar(128)
,`emprunts` bigint(21)
);

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `type_client`
--

INSERT INTO `type_client` (`type_client_id`, `libelle`, `updated_at`) VALUES
(1, 'Particulier', '2021-05-04 22:19:29'),
(2, 'Professionnel', '2021-05-04 22:19:42');

-- --------------------------------------------------------

--
-- Structure de la vue `client_fidele`
--
DROP TABLE IF EXISTS `client_fidele`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `client_fidele`  AS  select `l`.`client_id` AS `client_id`,`c`.`nom` AS `nom`,`c`.`prenom` AS `prenom`,count(0) AS `nb_locs`,count(`l`.`date_retour`) AS `nb_returned_locs` from (`location` `l` join `client` `c` on((`c`.`client_id` = `l`.`client_id`))) group by `l`.`client_id` order by `nb_locs` desc,`nb_returned_locs` desc ;

-- --------------------------------------------------------

--
-- Structure de la vue `get_nb_locations_aujourdhui_par_magasin`
--
DROP TABLE IF EXISTS `get_nb_locations_aujourdhui_par_magasin`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `get_nb_locations_aujourdhui_par_magasin`  AS  select `e`.`magasin_id` AS `magasin_id`,count(0) AS `count(*)` from (`location` `l` join `employe` `e` on((`e`.`employe_id` = `l`.`employe_id`))) where ((year(`l`.`date_location`) = year(now())) and (month(`l`.`date_location`) = month(now())) and (dayofmonth(`l`.`date_location`) = dayofmonth(now()))) group by `e`.`magasin_id` ;

-- --------------------------------------------------------

--
-- Structure de la vue `magain_tries_par_ca`
--
DROP TABLE IF EXISTS `magain_tries_par_ca`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `magain_tries_par_ca`  AS  select `e`.`magasin_id` AS `magasin_id`,sum(`m`.`cout_location`) AS `CA` from (((`location` `l` join `employe` `e` on((`e`.`employe_id` = `l`.`employe_id`))) join `inventaire` `i` on((`i`.`inventaire_id` = `l`.`inventaire_id`))) join `materiel` `m` on((`m`.`materiel_id` = `i`.`materiel_id`))) group by `e`.`magasin_id` order by `CA` desc ;

-- --------------------------------------------------------

--
-- Structure de la vue `materiel_tries_par_nbemprunts`
--
DROP TABLE IF EXISTS `materiel_tries_par_nbemprunts`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `materiel_tries_par_nbemprunts`  AS  select `m`.`materiel_id` AS `materiel_id`,`m`.`nom` AS `nom`,count(`m`.`materiel_id`) AS `emprunts` from (((`location` `l` join `employe` `e` on((`e`.`employe_id` = `l`.`employe_id`))) join `inventaire` `i` on((`i`.`inventaire_id` = `l`.`inventaire_id`))) join `materiel` `m` on((`m`.`materiel_id` = `i`.`materiel_id`))) group by `m`.`materiel_id` order by `emprunts` desc ;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `client`
--
ALTER TABLE `client`
  ADD CONSTRAINT `fk_client_adresse` FOREIGN KEY (`adresse_id`) REFERENCES `adresse` (`adresse_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_client_magasin` FOREIGN KEY (`magasin_id`) REFERENCES `magasin` (`magasin_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_client_type_client` FOREIGN KEY (`type_client_id`) REFERENCES `type_client` (`type_client_id`) ON UPDATE CASCADE;

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
