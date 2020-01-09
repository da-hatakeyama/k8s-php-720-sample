-- データベース作成
CREATE DATABASE `mysql_db`;

-- ユーザ作成
CREATE USER `mysql_user`;
GRANT ALL PRIVILEGES ON `mysql_db`.* TO 'mysql_user'@'%' IDENTIFIED BY 'mysql_user_passwd' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- データベースへ接続
use `mysql_db`;

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `user_name` longtext,
  `user_password` longtext,
  PRIMARY KEY (`user_name`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

INSERT INTO users VALUES ('mysql_user1', 'mysql_user1pass');
INSERT INTO users VALUES ('mysql_user2', 'mysql_user2pass');
INSERT INTO users VALUES ('mysql_user3', 'mysql_user3pass');
