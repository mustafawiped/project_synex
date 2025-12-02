-- --------------------------------------------------------
-- Sunucu:                       127.0.0.1
-- Sunucu sürümü:                10.4.32-MariaDB - mariadb.org binary distribution
-- Sunucu İşletim Sistemi:       Win64
-- HeidiSQL Sürüm:               12.11.0.7065
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- synex için veritabanı yapısı dökülüyor
CREATE DATABASE IF NOT EXISTS `synex` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `synex`;

-- tablo yapısı dökülüyor synex.active_calls
CREATE TABLE IF NOT EXISTS `active_calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `caller_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `room_id` varchar(100) NOT NULL,
  `status` enum('ringing','accepted','ended') NOT NULL DEFAULT 'ringing',
  `started_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- synex.active_calls: ~0 rows (yaklaşık) tablosu için veriler indiriliyor

-- tablo yapısı dökülüyor synex.call_history
CREATE TABLE IF NOT EXISTS `call_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `caller_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `started_at` datetime NOT NULL,
  `ended_at` datetime NOT NULL,
  `status` enum('ringing','accepted','ended') NOT NULL DEFAULT 'ringing',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- synex.call_history: ~19 rows (yaklaşık) tablosu için veriler indiriliyor
INSERT INTO `call_history` (`id`, `caller_id`, `receiver_id`, `started_at`, `ended_at`, `status`) VALUES
	(32, 9, 8, '2025-09-07 17:53:12', '2025-09-07 17:53:17', 'accepted'),
	(33, 9, 8, '2025-09-07 17:53:28', '2025-09-07 17:53:32', 'ringing'),
	(34, 9, 8, '2025-09-07 17:58:04', '2025-09-07 17:58:10', 'accepted'),
	(35, 9, 8, '2025-09-07 17:59:02', '2025-09-07 17:59:09', 'accepted'),
	(36, 9, 8, '2025-09-07 17:59:57', '2025-09-07 18:00:03', 'accepted'),
	(37, 9, 8, '2025-09-07 18:00:20', '2025-09-07 18:00:25', 'accepted'),
	(38, 8, 9, '2025-09-07 18:25:30', '2025-09-07 18:25:48', 'accepted'),
	(39, 9, 9, '2025-09-07 18:41:04', '2025-09-07 18:41:20', 'ringing'),
	(40, 9, 8, '2025-09-07 18:41:53', '2025-09-07 18:42:02', 'ringing'),
	(41, 9, 8, '2025-09-07 18:43:17', '2025-09-07 18:43:20', 'ringing'),
	(42, 8, 9, '2025-09-07 18:44:07', '2025-09-07 18:44:11', 'ringing'),
	(43, 8, 9, '2025-09-07 18:44:28', '2025-09-07 18:44:38', 'accepted'),
	(44, 9, 8, '2025-09-07 18:44:56', '2025-09-07 18:45:14', 'ringing'),
	(45, 8, 9, '2025-09-08 12:01:02', '2025-09-08 12:01:51', 'ringing'),
	(46, 8, 9, '2025-09-08 12:08:32', '2025-09-08 12:20:03', 'ringing'),
	(47, 9, 8, '2025-09-08 12:20:34', '2025-09-08 12:20:51', 'ringing'),
	(48, 8, 9, '2025-09-08 12:28:22', '2025-09-08 12:28:40', 'ringing'),
	(49, 8, 9, '2025-09-08 12:38:06', '2025-09-08 12:38:44', 'ringing'),
	(50, 8, 9, '2025-09-08 12:52:31', '2025-09-08 12:52:45', 'ringing'),
	(51, 9, 8, '2025-09-08 12:53:23', '2025-09-08 12:53:33', 'ringing'),
	(52, 9, 8, '2025-09-08 12:53:34', '2025-09-08 12:53:45', 'ringing'),
	(53, 9, 11, '2025-09-09 11:58:29', '2025-09-09 11:58:35', 'ringing'),
	(54, 9, 11, '2025-09-09 11:58:40', '2025-09-09 11:58:51', 'accepted'),
	(55, 11, 9, '2025-09-09 11:58:55', '2025-09-09 11:59:14', 'accepted'),
	(56, 9, 11, '2025-09-09 12:00:59', '2025-09-09 12:01:21', 'accepted'),
	(57, 9, 11, '2025-09-09 12:33:32', '2025-09-09 12:33:41', 'accepted'),
	(58, 9, 11, '2025-09-09 12:33:42', '2025-09-09 12:33:53', 'accepted'),
	(59, 9, 11, '2025-09-09 12:33:55', '2025-09-09 12:33:58', 'ringing');

-- tablo yapısı dökülüyor synex.conversations
CREATE TABLE IF NOT EXISTS `conversations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user1_id` int(11) NOT NULL,
  `user2_id` int(11) NOT NULL,
  `last_message_id` bigint(20) DEFAULT NULL,
  `updated_at` datetime DEFAULT current_timestamp(),
  `unread_count_user1` int(11) DEFAULT 0,
  `unread_count_user2` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `user1_id` (`user1_id`),
  KEY `user2_id` (`user2_id`),
  KEY `last_message_id` (`last_message_id`),
  CONSTRAINT `conversations_ibfk_1` FOREIGN KEY (`user1_id`) REFERENCES `users` (`id`),
  CONSTRAINT `conversations_ibfk_2` FOREIGN KEY (`user2_id`) REFERENCES `users` (`id`),
  CONSTRAINT `conversations_ibfk_3` FOREIGN KEY (`last_message_id`) REFERENCES `messages` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- synex.conversations: ~5 rows (yaklaşık) tablosu için veriler indiriliyor
INSERT INTO `conversations` (`id`, `user1_id`, `user2_id`, `last_message_id`, `updated_at`, `unread_count_user1`, `unread_count_user2`) VALUES
	(1, 1, 8, 168, '2025-09-04 23:41:07', 0, 0),
	(2, 8, 6, 188, '2025-09-05 00:25:39', 0, 0),
	(3, 8, 3, NULL, '2025-09-05 13:04:09', 0, 0),
	(4, 6, 3, 186, '2025-09-06 10:19:06', 0, 2),
	(5, 9, 8, 253, '2025-09-06 13:26:22', 0, 0),
	(6, 11, 9, 251, '2025-09-09 14:55:00', 0, 1);

-- olay yapısı dökülüyor synex.delete_old_stories
DELIMITER //
CREATE DEFINER=`root`@`localhost` EVENT `delete_old_stories` ON SCHEDULE EVERY 1 HOUR STARTS '2025-09-08 17:08:04' ON COMPLETION NOT PRESERVE ENABLE DO DELETE FROM Stories
  WHERE CreatedAt < NOW() - INTERVAL 1 DAY//
DELIMITER ;

-- tablo yapısı dökülüyor synex.devicetokens
CREATE TABLE IF NOT EXISTS `devicetokens` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `UserId` int(11) NOT NULL,
  `Token` varchar(255) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- synex.devicetokens: ~5 rows (yaklaşık) tablosu için veriler indiriliyor
INSERT INTO `devicetokens` (`Id`, `UserId`, `Token`) VALUES
	(3, 8, 'fiS_Ac_dQ4aKQEtu1sZb0m:APA91bESh9IMGKll3PbZOBAkKe3q7h8NXbhuDWVoxvIcBTFIMjaNOYCaH_2qA4Qz3sLBq0GEUdlshUXNMgZzURiM65GKCXuHKuxKPCR9HJlvaoP1uHy3GAw'),
	(4, 9, 'cCho-n2MTjmsQNtH_tzf4O:APA91bFfgm4Y9_aBM-Z9-HQTHlpw3H8fPRroLJTvstAi6EJgYWEHYfMWMplXSF6QnxH4SJPmxbpkEQM3iw8zSKDLJO-oSD2cEP2loYJXr7UoKuvSZ-wYVhw'),
	(5, 8, 'cU6sQ9ZuTnWJpfdMwnMZwY:APA91bHhxhWRVqfg0KkHIwwQ64QS4ROJOY5G7cyp-2knkjeTadRlxUFEpnyQGaOUvn_V5U0akeMDLL_8a8oFFhu90_GiWnTl5dTWkuHgxm5WVetFfyBzvW0'),
	(6, 9, 'dM-O1I5QRrSJXo2uF66yLH:APA91bHpDJlqzX60s6sMW-uGVS8-m8KLOXqSS2lAfYr4XMCr0jK8AV15Oay4KQmDpKygsO7lxTXRXTw1F0qAudCDKXLLpleau68s9nYtnghF2WMgBddzurc'),
	(7, 8, 'dLSl4UimSh-YDeLilwxnXz:APA91bEz0sv_h6i5aW-oHI_RjSQn8clXxSiV3FyrTS0VyFJj3Z6BWNX-S7-Tb6aScBb6EbFfWPd1nesO5OYUkzaOvllHHn1YPudWJ36lIpguotBLUiVnWPc'),
	(8, 8, 'd3gu3ys7RImAtjpOWfuvui:APA91bEh756Webn0YDjacqYcIjmGHjmSaTQ32kZlMj0hO6s5NtUlqtxe9JOfy-JNgMDdQ0Wu6ts7duXIcrVBi5YfH6WIezbO12BCPc7Mi1k50Cu48YmUfDg'),
	(9, 9, 'fSuPqNXeQs6qL6YUWdrJYN:APA91bGS4yXPQJS3bu2l7wSXdxHZDRl5A2NrN7HjCWiWxEh3y157yIEApnxitwEpyq4fsaYh-JBN6fS2AWRzKAo2O3BwS48ZhT3SuSPKRgyqhkwHDZRPuUw');

-- tablo yapısı dökülüyor synex.messages
CREATE TABLE IF NOT EXISTS `messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `ConversationId` bigint(20) NOT NULL,
  `content` mediumtext DEFAULT NULL,
  `was_it_seen` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `seen_at` datetime DEFAULT NULL,
  `message_type` enum('text','image') NOT NULL DEFAULT 'text',
  PRIMARY KEY (`id`),
  KEY `sender_id` (`sender_id`),
  KEY `receiver_id` (`receiver_id`),
  KEY `fk_conversation` (`ConversationId`),
  CONSTRAINT `fk_conversation` FOREIGN KEY (`ConversationId`) REFERENCES `conversations` (`id`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`),
  CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=254 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- synex.messages: ~152 rows (yaklaşık) tablosu için veriler indiriliyor
INSERT INTO `messages` (`id`, `sender_id`, `receiver_id`, `ConversationId`, `content`, `was_it_seen`, `created_at`, `seen_at`, `message_type`) VALUES
	(55, 8, 1, 1, 'Kafana takma', 1, '2025-09-04 22:01:18', '2025-09-04 22:56:05', 'text'),
	(74, 1, 8, 1, 'asda', 1, '2025-09-04 22:52:27', '2025-09-04 22:57:40', 'text'),
	(75, 1, 8, 1, 'evet', 1, '2025-09-04 22:54:33', '2025-09-04 22:57:40', 'text'),
	(76, 1, 8, 1, 'hayr', 1, '2025-09-04 22:54:49', '2025-09-04 22:57:40', 'text'),
	(77, 1, 8, 1, 'sdf', 1, '2025-09-04 22:56:05', '2025-09-04 22:57:40', 'text'),
	(78, 8, 1, 1, 'Evet', 1, '2025-09-04 22:57:39', '2025-09-04 22:57:58', 'text'),
	(79, 8, 1, 1, 'Sen ona aşıksın', 1, '2025-09-04 23:00:32', '2025-09-04 23:02:26', 'text'),
	(80, 1, 8, 1, 'Hayr..', 1, '2025-09-04 23:02:46', '2025-09-04 23:05:13', 'text'),
	(81, 8, 1, 1, 'Degil', 1, '2025-09-04 23:05:01', '2025-09-04 23:05:01', 'text'),
	(82, 8, 1, 1, 'Uyudun mu?', 1, '2025-09-04 23:05:09', '2025-09-04 23:05:09', 'text'),
	(83, 8, 1, 1, 'Kafam senden bile güzel', 1, '2025-09-04 23:05:42', '2025-09-04 23:05:42', 'text'),
	(84, 8, 1, 1, 'Kimse bilmesin', 1, '2025-09-04 23:05:46', '2025-09-04 23:05:46', 'text'),
	(85, 8, 1, 1, 'Nerde oldugumu', 1, '2025-09-04 23:05:49', '2025-09-04 23:05:49', 'text'),
	(86, 8, 1, 1, 'Sodarlads soldu dersin', 1, '2025-09-04 23:05:53', '2025-09-04 23:05:53', 'text'),
	(87, 1, 8, 1, 'hayor', 1, '2025-09-04 23:06:02', '2025-09-04 23:06:02', 'text'),
	(88, 8, 1, 1, 'Niye ', 1, '2025-09-04 23:06:13', '2025-09-04 23:06:13', 'text'),
	(89, 8, 1, 1, 'Evet', 1, '2025-09-04 23:06:18', '2025-09-04 23:06:58', 'text'),
	(90, 8, 1, 1, 'Bu kadar mıydı?', 1, '2025-09-04 23:06:27', '2025-09-04 23:06:58', 'text'),
	(91, 8, 1, 1, '...', 1, '2025-09-04 23:06:29', '2025-09-04 23:06:58', 'text'),
	(92, 1, 8, 1, 'anlamyosun', 1, '2025-09-04 23:06:58', '2025-09-04 23:06:58', 'text'),
	(93, 8, 1, 1, 'Anlat o zaman', 1, '2025-09-04 23:07:11', '2025-09-04 23:07:11', 'text'),
	(94, 1, 8, 1, 'yapamam', 1, '2025-09-04 23:07:31', '2025-09-04 23:07:32', 'text'),
	(95, 8, 1, 1, 'Taemin', 1, '2025-09-05 09:48:09', '2025-09-05 09:48:42', 'text'),
	(96, 1, 8, 1, 'selammm', 1, '2025-09-05 09:49:58', '2025-09-05 09:50:41', 'text'),
	(97, 1, 8, 1, 'naber', 1, '2025-09-05 09:50:41', '2025-09-05 09:50:41', 'text'),
	(98, 1, 8, 1, 'Iyi sen', 1, '2025-09-05 09:50:52', '2025-09-05 09:51:41', 'text'),
	(99, 1, 8, 1, 'Ramen yer misin', 1, '2025-09-05 09:51:48', '2025-09-05 09:53:34', 'text'),
	(100, 1, 8, 1, 'adele', 1, '2025-09-05 09:53:55', '2025-09-05 09:55:42', 'text'),
	(101, 1, 8, 1, 'Someone like you', 1, '2025-09-05 09:55:59', '2025-09-05 09:56:01', 'text'),
	(102, 1, 8, 1, 'Adele cok iyi sarki soyler', 1, '2025-09-05 09:56:40', '2025-09-05 09:57:05', 'text'),
	(103, 1, 8, 1, 'Adeleyi seviyorum ve lanet olsun', 1, '2025-09-05 09:56:46', '2025-09-05 09:57:06', 'text'),
	(104, 1, 8, 1, 'Event brother dgoru düsünüyosun', 1, '2025-09-05 09:56:55', '2025-09-05 09:57:04', 'text'),
	(105, 1, 8, 1, 'Deneme mesajlari selam selam sosisssss', 1, '2025-09-05 09:57:03', '2025-09-05 09:57:05', 'text'),
	(106, 8, 1, 1, 'Hocam sağolun merhaba ve eserleri ', 1, '2025-09-05 09:57:48', '2025-09-05 09:57:58', 'text'),
	(107, 8, 1, 1, 'Naber nasılsın napiyorsunn merhaba ve eserleri ', 1, '2025-09-05 09:57:52', '2025-09-05 09:57:59', 'text'),
	(108, 8, 1, 1, 'Güzel mesajın içeriği kaynak ', 1, '2025-09-05 09:57:55', '2025-09-05 09:57:58', 'text'),
	(109, 8, 1, 1, 'Horizon', 1, '2025-09-05 09:59:35', '2025-09-05 09:59:38', 'text'),
	(110, 1, 8, 1, 'sdfgsdfgsdfhsdf', 1, '2025-09-05 10:00:49', '2025-09-05 10:00:50', 'text'),
	(111, 1, 8, 1, 'sdfhdsfhgsdf', 1, '2025-09-05 10:00:52', '2025-09-05 10:00:52', 'text'),
	(112, 1, 8, 1, 'Event öyle gercekten de', 1, '2025-09-05 10:00:59', '2025-09-05 10:01:00', 'text'),
	(113, 1, 8, 1, 'sfasdfsdf', 1, '2025-09-05 10:05:41', '2025-09-05 10:05:46', 'text'),
	(114, 1, 8, 1, 'asdfasdfasdfasdf', 1, '2025-09-05 10:05:42', '2025-09-05 10:05:47', 'text'),
	(115, 1, 8, 1, 'asdfasdfasfasdfa', 1, '2025-09-05 10:05:44', '2025-09-05 10:05:46', 'text'),
	(116, 8, 1, 1, 'Yok ben bu kadar güzel ki ben sana da ', 1, '2025-09-05 10:05:56', '2025-09-05 10:06:10', 'text'),
	(117, 8, 1, 1, 'He iyi bari nasılsın napiyorsunn merhaba ve eserleri taşlar yerine gelen ', 1, '2025-09-05 10:06:01', '2025-09-05 10:06:10', 'text'),
	(118, 8, 1, 1, 'He 551 058 45 03 nasılsın napiyorsunn merhaba ve eserleri taşlar ', 1, '2025-09-05 10:06:07', '2025-09-05 10:06:11', 'text'),
	(119, 1, 8, 1, 'soldier', 1, '2025-09-05 10:12:27', '2025-09-05 10:13:57', 'text'),
	(120, 1, 8, 1, 'hahahahahahaha', 1, '2025-09-05 10:13:56', '2025-09-05 10:13:57', 'text'),
	(121, 1, 8, 1, 'naber', 1, '2025-09-05 10:24:29', '2025-09-05 10:26:26', 'text'),
	(122, 8, 1, 1, 'Dream', 1, '2025-09-05 10:26:37', '2025-09-05 10:26:39', 'text'),
	(123, 1, 8, 1, 'naberererere', 1, '2025-09-05 10:26:49', '2025-09-05 10:26:55', 'text'),
	(124, 1, 8, 1, 'Black rose', 1, '2025-09-05 10:28:28', '2025-09-05 10:28:34', 'text'),
	(125, 1, 8, 1, 'guilty', 1, '2025-09-05 10:31:58', '2025-09-05 10:32:19', 'text'),
	(126, 8, 1, 1, 'Fhcjfcu', 1, '2025-09-05 10:32:56', '2025-09-05 10:33:05', 'text'),
	(127, 1, 8, 1, 'sdfsdafsdfsd', 1, '2025-09-05 10:33:42', '2025-09-05 10:33:47', 'text'),
	(128, 8, 1, 1, 'Ufuffuyxyfcyycyf', 1, '2025-09-05 10:37:40', '2025-09-05 10:38:47', 'text'),
	(129, 1, 8, 1, 'asdfasdfasdf', 1, '2025-09-05 10:38:54', '2025-09-05 10:39:11', 'text'),
	(130, 8, 1, 1, 'Jgcuucuf', 1, '2025-09-05 10:39:28', '2025-09-05 10:40:40', 'text'),
	(131, 1, 8, 1, 'naber', 1, '2025-09-05 10:40:44', '2025-09-05 10:41:00', 'text'),
	(132, 1, 8, 1, 'asdfasdfasd', 1, '2025-09-05 10:41:15', '2025-09-05 10:41:21', 'text'),
	(133, 8, 1, 1, 'Gffjfuufxuuf', 1, '2025-09-05 10:41:32', '2025-09-05 10:41:48', 'text'),
	(134, 8, 1, 1, 'Hxhfdyyfdyyd', 1, '2025-09-05 10:41:38', '2025-09-05 10:41:48', 'text'),
	(135, 8, 1, 1, 'Jcxhyxydsyssu', 1, '2025-09-05 10:41:42', '2025-09-05 10:41:47', 'text'),
	(136, 1, 8, 1, 'fiction', 1, '2025-09-05 11:04:43', '2025-09-05 16:32:02', 'text'),
	(137, 1, 8, 1, 'Sa', 1, '2025-09-05 11:15:19', '2025-09-05 16:32:03', 'text'),
	(138, 1, 8, 1, 'sdfsd', 1, '2025-09-05 11:37:23', '2025-09-05 16:32:03', 'text'),
	(139, 1, 8, 1, 'sdgsadgs', 1, '2025-09-05 11:37:25', '2025-09-05 16:32:03', 'text'),
	(140, 1, 8, 1, 'sdfsd', 1, '2025-09-05 11:37:30', '2025-09-05 16:32:03', 'text'),
	(145, 1, 8, 1, 'asdasdas', 1, '2025-09-05 16:25:31', '2025-09-05 16:32:01', 'text'),
	(146, 1, 8, 1, 'asfasfas', 1, '2025-09-05 16:25:36', '2025-09-05 16:32:04', 'text'),
	(149, 1, 8, 1, 'asdfasdfasdffasdgasdgas', 1, '2025-09-05 16:28:06', '2025-09-05 16:32:02', 'text'),
	(151, 8, 1, 1, 'http://192.168.1.115:5010/uploads/20fc7985-1735-46bc-a142-a4a7aa82a0af.jpg', 1, '2025-09-05 16:32:15', '2025-09-05 16:32:16', 'image'),
	(152, 8, 1, 1, 'Na', 1, '2025-09-05 16:32:29', '2025-09-05 16:32:30', 'text'),
	(153, 8, 1, 1, 'Nası amaaaa🙂', 1, '2025-09-05 16:32:43', '2025-09-05 16:32:43', 'text'),
	(154, 1, 8, 1, 'Cok iyi cok iyi mukemmel', 1, '2025-09-05 16:33:05', '2025-09-05 16:33:06', 'text'),
	(155, 8, 1, 1, 'Biliom', 1, '2025-09-05 16:33:14', '2025-09-05 16:33:15', 'text'),
	(156, 8, 1, 1, 'Sen naptin nasılsın ', 1, '2025-09-05 16:33:25', '2025-09-05 16:33:33', 'text'),
	(158, 1, 8, 1, 'hitori', 1, '2025-09-05 22:44:18', '2025-09-06 06:17:38', 'text'),
	(159, 1, 8, 1, 'yabanci', 1, '2025-09-05 22:44:22', '2025-09-06 06:17:37', 'text'),
	(160, 1, 8, 1, 'Aa haber', 1, '2025-09-06 06:18:54', '2025-09-06 06:52:16', 'text'),
	(161, 1, 8, 1, 'Aaa', 1, '2025-09-06 06:19:48', '2025-09-06 06:52:16', 'text'),
	(162, 1, 8, 1, 'Nbr', 1, '2025-09-06 06:27:28', '2025-09-06 06:52:16', 'text'),
	(163, 1, 8, 1, 'Hhh', 1, '2025-09-06 06:27:33', '2025-09-06 06:52:16', 'text'),
	(164, 1, 8, 1, 'Hhhh', 1, '2025-09-06 06:27:41', '2025-09-06 06:52:16', 'text'),
	(165, 1, 8, 1, 'Hh', 1, '2025-09-06 06:28:49', '2025-09-06 06:52:16', 'text'),
	(166, 1, 8, 1, 'Smmtjddj', 1, '2025-09-06 06:44:41', '2025-09-06 06:52:16', 'text'),
	(167, 1, 8, 1, 'Auausudjs', 1, '2025-09-06 06:44:54', '2025-09-06 06:52:16', 'text'),
	(168, 1, 8, 1, 'Malim', 1, '2025-09-06 06:44:58', '2025-09-06 06:52:15', 'text'),
	(169, 6, 8, 2, 'Live', 1, '2025-09-06 06:46:00', '2025-09-06 06:48:55', 'text'),
	(170, 6, 8, 2, 'Aynen neler yapio picler', 1, '2025-09-06 06:48:35', '2025-09-06 06:48:55', 'text'),
	(171, 6, 8, 2, 'Ee nasilsin', 1, '2025-09-06 06:50:50', '2025-09-06 06:52:09', 'text'),
	(172, 6, 8, 2, 'Alo balon kanka', 1, '2025-09-06 06:51:33', '2025-09-06 06:52:08', 'text'),
	(173, 8, 6, 2, 'jkjj', 1, '2025-09-06 06:53:34', '2025-09-06 06:57:22', 'text'),
	(174, 8, 6, 2, 'jjj', 1, '2025-09-06 06:56:46', '2025-09-06 06:57:23', 'text'),
	(175, 8, 6, 2, 'Jjj', 1, '2025-09-06 06:57:04', '2025-09-06 06:57:22', 'text'),
	(176, 6, 8, 2, 'Evet', 1, '2025-09-06 07:05:38', '2025-09-06 07:08:07', 'text'),
	(177, 8, 6, 2, 'wake', 1, '2025-09-06 07:08:40', '2025-09-06 07:11:06', 'text'),
	(178, 8, 6, 2, 'up', 1, '2025-09-06 07:08:47', '2025-09-06 07:11:05', 'text'),
	(179, 6, 8, 2, 'Evet doğrudur.', 1, '2025-09-06 07:11:22', '2025-09-06 07:11:45', 'text'),
	(180, 6, 8, 2, 'Ama sen bilmezsin', 1, '2025-09-06 07:11:29', '2025-09-06 07:11:45', 'text'),
	(181, 6, 8, 2, 'Çünkü bu işler farklidir', 1, '2025-09-06 07:11:36', '2025-09-06 07:11:44', 'text'),
	(182, 8, 6, 2, 'evet', 1, '2025-09-06 07:12:10', '2025-09-06 07:12:20', 'text'),
	(183, 6, 3, 4, 'Nbr', 0, '2025-09-06 07:19:10', NULL, 'text'),
	(184, 6, 8, 2, 'Öyle', 1, '2025-09-06 07:19:56', '2025-09-06 07:22:53', 'text'),
	(185, 8, 6, 2, 'evet', 1, '2025-09-06 07:22:54', '2025-09-06 07:23:44', 'text'),
	(186, 6, 3, 4, 'Loo', 0, '2025-09-06 07:23:36', NULL, 'text'),
	(187, 6, 8, 2, 'Buyur?', 1, '2025-09-06 07:23:48', '2025-09-06 07:24:23', 'text'),
	(188, 8, 6, 2, 'http://192.168.1.115:5010/uploads/4f7f3844-0637-4eb9-9fd1-fb6849475eb0.jpg', 1, '2025-09-06 07:24:36', '2025-09-09 11:08:17', 'image'),
	(189, 9, 8, 5, 'Merhaba', 1, '2025-09-06 10:26:27', '2025-09-06 10:26:48', 'text'),
	(190, 9, 8, 5, 'Nasılsın?', 1, '2025-09-06 10:26:32', '2025-09-06 10:26:48', 'text'),
	(191, 8, 9, 5, 'Iyiyim sen', 1, '2025-09-06 10:27:06', '2025-09-06 10:27:10', 'text'),
	(192, 9, 8, 5, 'İyiyim ben de teşekkür ederim ', 1, '2025-09-06 10:27:21', '2025-09-06 10:27:21', 'text'),
	(193, 9, 8, 5, 'http://192.168.1.115:5010/uploads/2d598bdc-b917-4e32-a996-e40c7f7a4bf3.jpg', 1, '2025-09-06 10:27:34', '2025-09-06 10:27:34', 'image'),
	(194, 9, 8, 5, 'Arabam nasıl ama?', 1, '2025-09-06 10:27:40', '2025-09-06 10:27:41', 'text'),
	(195, 8, 9, 5, 'Çok güzel masallah', 1, '2025-09-06 10:27:55', '2025-09-06 10:27:55', 'text'),
	(196, 8, 9, 5, 'Cok begendim', 1, '2025-09-06 10:28:05', '2025-09-06 10:28:27', 'text'),
	(197, 8, 9, 5, 'Asiri yani', 1, '2025-09-06 10:28:09', '2025-09-06 10:28:27', 'text'),
	(198, 8, 9, 5, 'Asiri begendim', 1, '2025-09-06 10:28:13', '2025-09-06 10:28:27', 'text'),
	(199, 8, 9, 5, 'http://192.168.1.115:5010/uploads/c3683d8c-eb1c-4288-88db-3c9ac421856c.jpg', 1, '2025-09-06 10:28:19', '2025-09-06 10:28:26', 'image'),
	(200, 9, 8, 5, 'Ah öyle mi? Teşekkür ederim', 1, '2025-09-06 10:28:45', '2025-09-06 10:29:05', 'text'),
	(201, 9, 8, 5, 'Cok naziksin', 1, '2025-09-06 10:28:50', '2025-09-06 10:29:05', 'text'),
	(202, 9, 8, 5, 'Daha iyileri senin olur umarim', 1, '2025-09-06 10:28:57', '2025-09-06 10:29:04', 'text'),
	(203, 9, 8, 5, 'Ee napiyorsun', 1, '2025-09-06 10:29:19', '2025-09-06 10:29:19', 'text'),
	(204, 9, 8, 5, 'Nasilsin?', 1, '2025-09-06 10:29:21', '2025-09-06 10:29:21', 'text'),
	(205, 8, 9, 5, 'Iyiyim ne olsun', 1, '2025-09-06 10:29:33', '2025-09-06 10:29:34', 'text'),
	(206, 8, 9, 5, 'Kosusturmaca', 1, '2025-09-06 10:29:38', '2025-09-06 10:29:39', 'text'),
	(207, 9, 8, 5, 'Ah oylemi', 1, '2025-09-06 10:29:44', '2025-09-06 10:29:45', 'text'),
	(208, 9, 8, 5, 'Ne güzel', 1, '2025-09-06 10:29:46', '2025-09-06 10:29:47', 'text'),
	(209, 9, 8, 5, '😄😇😇😄', 1, '2025-09-06 10:29:53', '2025-09-06 10:29:53', 'text'),
	(210, 9, 8, 5, 'Taemin cok iyi yaa', 1, '2025-09-06 10:30:04', '2025-09-06 10:30:05', 'text'),
	(211, 9, 8, 5, 'Değil mi', 1, '2025-09-06 10:30:06', '2025-09-06 10:30:07', 'text'),
	(212, 9, 8, 5, 'Aşırı iyi sanatci', 1, '2025-09-06 10:30:09', '2025-09-06 10:30:10', 'text'),
	(213, 9, 8, 5, 'Aksini iddia eden etmesin', 1, '2025-09-06 10:30:14', '2025-09-06 10:30:14', 'text'),
	(214, 8, 9, 5, 'tamam', 1, '2025-09-07 17:33:29', '2025-09-07 17:33:47', 'text'),
	(215, 8, 9, 5, 'yaparz', 1, '2025-09-07 17:33:34', '2025-09-07 17:33:48', 'text'),
	(216, 8, 9, 5, 'asdasda', 1, '2025-09-07 23:01:50', '2025-09-08 11:59:15', 'text'),
	(217, 8, 9, 5, 'hghhghg', 1, '2025-09-07 23:03:08', '2025-09-08 11:59:15', 'text'),
	(218, 8, 9, 5, 'Sdfsafsdf', 1, '2025-09-07 23:03:35', '2025-09-08 11:59:16', 'text'),
	(219, 8, 9, 5, 'Al ma li', 1, '2025-09-08 11:59:40', '2025-09-08 12:20:14', 'text'),
	(220, 8, 9, 5, 'Müsait misin', 1, '2025-09-08 12:00:08', '2025-09-08 12:20:15', 'text'),
	(221, 8, 9, 5, 'tamam', 1, '2025-09-08 12:00:51', '2025-09-08 12:20:15', 'text'),
	(222, 8, 9, 5, 'asdfasdf', 1, '2025-09-08 12:08:21', '2025-09-08 12:20:16', 'text'),
	(223, 8, 9, 5, 'asdfasdfasdfas', 1, '2025-09-08 12:19:33', '2025-09-08 12:20:13', 'text'),
	(224, 9, 8, 5, 'Jcchhfhf', 1, '2025-09-08 12:20:24', '2025-09-08 12:21:11', 'text'),
	(225, 8, 9, 5, 'dsgsdgsd', 1, '2025-09-08 12:28:08', '2025-09-08 12:29:22', 'text'),
	(226, 8, 9, 5, 'asdfsdfsd', 1, '2025-09-08 12:30:56', '2025-09-08 12:34:02', 'text'),
	(227, 8, 9, 5, 'asdfgasdgasdgsad', 1, '2025-09-08 12:34:11', '2025-09-08 12:52:07', 'text'),
	(228, 8, 9, 5, 'sdfhsdfhsd', 1, '2025-09-08 12:37:33', '2025-09-08 12:52:07', 'text'),
	(229, 8, 9, 5, 'hsdfhdsfhsdfhdsf', 1, '2025-09-08 12:37:45', '2025-09-08 12:52:07', 'text'),
	(230, 8, 9, 5, 'naber', 1, '2025-09-08 12:51:49', '2025-09-08 12:52:06', 'text'),
	(231, 8, 9, 5, 'yieiyeye', 1, '2025-09-08 12:52:12', '2025-09-08 12:52:17', 'text'),
	(232, 9, 8, 5, 'http://192.168.1.115:5010/uploads/16c0d33f-5a18-458d-8bea-254ddd348d9a.jpg', 1, '2025-09-08 12:54:00', '2025-09-08 12:54:06', 'image'),
	(233, 11, 9, 6, 'selam', 1, '2025-09-09 11:55:05', '2025-09-09 11:55:13', 'text'),
	(234, 9, 11, 6, 'Merhaba ', 1, '2025-09-09 11:55:26', '2025-09-09 11:55:26', 'text'),
	(235, 11, 9, 6, 'sohbetteyim', 1, '2025-09-09 11:55:38', '2025-09-09 11:55:39', 'text'),
	(236, 11, 9, 6, 'Selam and ', 1, '2025-09-09 11:55:53', '2025-09-09 11:55:53', 'text'),
	(237, 11, 9, 6, '🤣😂🙂☺️😇😍😍hhh', 1, '2025-09-09 11:56:06', '2025-09-09 11:56:07', 'text'),
	(238, 11, 9, 6, 'http://192.168.1.115:5010/uploads/0cc9808c-2920-4664-b10e-87507d59df8c.jpg', 1, '2025-09-09 11:56:17', '2025-09-09 11:56:18', 'image'),
	(239, 9, 11, 6, 'http://192.168.1.115:5010/uploads/c74d8075-94a1-434b-9893-07a20a949f50.jpg', 1, '2025-09-09 11:56:38', '2025-09-09 11:56:39', 'image'),
	(240, 9, 11, 6, 'Ggfhdhhd', 1, '2025-09-09 11:56:55', '2025-09-09 11:57:02', 'text'),
	(241, 9, 11, 6, 'Yfufjgjfdjdjjd', 1, '2025-09-09 11:57:10', '2025-09-09 11:57:24', 'text'),
	(242, 9, 11, 6, 'Djjxjxhxjx', 1, '2025-09-09 11:57:11', '2025-09-09 11:57:24', 'text'),
	(243, 9, 11, 6, 'Hxhxjx6', 1, '2025-09-09 11:57:12', '2025-09-09 11:57:24', 'text'),
	(244, 9, 11, 6, 'Chjchxhx', 1, '2025-09-09 11:57:15', '2025-09-09 11:57:24', 'text'),
	(245, 9, 11, 6, 'Son mesaj', 1, '2025-09-09 11:57:20', '2025-09-09 11:57:23', 'text'),
	(246, 9, 11, 6, 'Jcxjjxjd', 1, '2025-09-09 11:59:52', '2025-09-09 12:00:08', 'text'),
	(247, 9, 11, 6, 'Hfuffhhfhfgf', 1, '2025-09-09 12:00:17', '2025-09-09 12:00:26', 'text'),
	(248, 9, 11, 6, 'Bildirim', 1, '2025-09-09 12:00:40', '2025-09-09 12:00:47', 'text'),
	(249, 11, 9, 6, 'Malum soru', 1, '2025-09-09 12:32:57', '2025-09-09 12:33:02', 'text'),
	(250, 9, 11, 6, 'Oh My goshhh', 1, '2025-09-09 12:33:07', '2025-09-09 12:33:08', 'text'),
	(251, 11, 9, 6, 'Oy oy oyyy', 0, '2025-09-09 12:35:04', NULL, 'text'),
	(252, 8, 9, 5, 'asdgasdgasd', 1, '2025-09-09 12:35:21', '2025-09-09 12:35:26', 'text'),
	(253, 9, 8, 5, '7g7g6gc76c6c', 1, '2025-09-09 12:35:30', '2025-09-09 12:35:40', 'text');

-- tablo yapısı dökülüyor synex.stories
CREATE TABLE IF NOT EXISTS `stories` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `UserId` int(11) NOT NULL,
  `Content` text NOT NULL,
  `ContentMsg` text DEFAULT NULL,
  `SeenBy` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '[]' CHECK (json_valid(`SeenBy`)),
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- synex.stories: ~6 rows (yaklaşık) tablosu için veriler indiriliyor
INSERT INTO `stories` (`Id`, `UserId`, `Content`, `ContentMsg`, `SeenBy`, `CreatedAt`) VALUES
	(1, 8, 'http://192.168.1.115:5010/uploads/2c643bac-8820-43c3-8df0-3313f05c3deb.jpg', '', '[9,11]', '2025-09-08 17:09:09'),
	(2, 8, 'http://192.168.1.115:5010/uploads/2b649bd1-ec56-4b4e-aa31-81a1065cc0a5.jpg', 'boyiyiyiy', '[9,11]', '2025-09-08 17:10:08'),
	(3, 8, 'http://192.168.1.115:5010/uploads/7975f59d-a905-465e-bb78-a898ca207c61.jpg', 'asdasdasdasda', '[9,11]', '2025-09-09 08:03:40'),
	(4, 8, 'http://192.168.1.115:5010/uploads/d41af79c-059e-49b7-beb2-c48293aa6657.jpg', '', '[9,11]', '2025-09-09 08:05:30'),
	(5, 6, 'http://192.168.1.115:5010/uploads/b742d500-7497-4647-beb6-3d156f3cd1d9.jpg', 'hsfgdhdfghdfgjdf', '[9,11]', '2025-09-09 08:08:32'),
	(6, 8, 'http://192.168.1.115:5010/uploads/75c81434-91e9-4142-bbef-72ce786ecc86.jpg', 'asdgasdgasd', '[11,9]', '2025-09-09 08:08:50'),
	(7, 11, 'http://192.168.1.115:5010/uploads/3a2066d8-1ed8-4015-8c17-f377d5a7303c.jpg', 'merhaba', '[9]', '2025-09-09 08:53:33');

-- tablo yapısı dökülüyor synex.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` char(50) NOT NULL DEFAULT '0',
  `email` char(50) NOT NULL DEFAULT '0',
  `password` char(50) NOT NULL DEFAULT '0',
  `about` varchar(500) DEFAULT NULL,
  `title` char(50) DEFAULT NULL,
  `photo` text DEFAULT 'http://192.168.1.115:5010/user.png',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Kullanıcıların bulunduğu tablo';

-- synex.users: ~9 rows (yaklaşık) tablosu için veriler indiriliyor
INSERT INTO `users` (`id`, `username`, `email`, `password`, `about`, `title`, `photo`) VALUES
	(1, 'mustafa', 'eposta@gmail.com', '123', NULL, NULL, 'http://192.168.1.115:5010/user.png'),
	(2, 'merhaba', 'safgasdgasdg@gmail.com', 'asdflgkdsflgdsfgd', NULL, NULL, 'http://192.168.1.115:5010/user.png'),
	(3, 'aaaaaaaaaaaa', 'aaaaasdfs', 'asdgasdf', NULL, NULL, 'http://192.168.1.115:5010/user.png'),
	(4, 'string', 'string', 'string', NULL, NULL, 'http://192.168.1.115:5010/user.png'),
	(5, 'ssssssssss', 'lalala@gmail.com', '123321', NULL, NULL, 'http://192.168.1.115:5010/user.png'),
	(6, 'mustafasA', 'asdfsdf@gmail.com', '123321', 'merhaba ben synex kullanıytorum falan sadgfklşalga', 'CEO', 'http://192.168.1.115:5010/user.png'),
	(8, 'naber', 'taemin@gmail.com', '123123', 'nbr', 'asdfsdfdsfs', 'http://192.168.1.115:5010/uploads/d375c00e-7422-4a6a-b01f-19e2243fbf8d.jpg'),
	(9, 'mustafawiped', 'mustafawiped@gmail.com', 'wolves123', 'Selam, ben Mustafa!', 'Yazılım Geliştiricisi', 'http://192.168.1.115:5010/uploads/936ae391-3ff4-40fa-b71e-7994350ccbb3.jpg'),
	(10, 'sosis', 'sosis@gasdfga.com', '123123', NULL, NULL, 'http://192.168.1.115:5010/user.png'),
	(11, 'merhabaaaaaaa', 'sdfsdfds@gmail.com', '123123', 'Ben rumeysa', 'Yazilim gelistiricisi', 'http://192.168.1.115:5010/uploads/dd47257e-4289-45e8-89f0-6aeed89e88cd.jpg');

-- tablo yapısı dökülüyor synex.__efmigrationshistory
CREATE TABLE IF NOT EXISTS `__efmigrationshistory` (
  `MigrationId` varchar(150) NOT NULL,
  `ProductVersion` varchar(32) NOT NULL,
  PRIMARY KEY (`MigrationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- synex.__efmigrationshistory: ~0 rows (yaklaşık) tablosu için veriler indiriliyor

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
