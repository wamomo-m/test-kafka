CREATE USER 'debezium'@'%' IDENTIFIED WITH mysql_native_password BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'debezium';
FLUSH PRIVILEGES;

CREATE DATABASE `sample`;
USE `sample`;

CREATE TABLE `outbox` (
  `id` VARCHAR(100) NOT NULL PRIMARY KEY
  , `key` VARCHAR(100) NOT NULL
  , `topic` VARCHAR(100) NOT NULL
  , `payload` TEXT NOT NULL
  , `timestamp` DATETIME default CURRENT_TIMESTAMP() NOT NULL
  , `schema_version` INT NOT NULL
);

INSERT INTO outbox(`id`, `key`, `topic`, `payload`, `schema_version`)
VALUES('00', '00', 'topic', '{"from": "mysql0"}', 1);
