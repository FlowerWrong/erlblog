# Database design of erlblog.
DROP DATABASE IF EXISTS `erlblog`;
CREATE DATABASE IF NOT EXISTS `erlblog` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `erlblog`;

SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS counters;
DROP TABLE IF EXISTS authors;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS post_tags;

SET FOREIGN_KEY_CHECKS=1;


# Counter features
CREATE TABLE counters (
  name VARCHAR(255) PRIMARY KEY,
  value INTEGER DEFAULT 0
);


CREATE TABLE authors (
  id MEDIUMINT NOT NULL AUTO_INCREMENT,
  username VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  avatar VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO authors (username, password, avatar) VALUES('yangfusheng', '963b4fdae702bc7e83e6fe52769f381a', 'https://www.4008-517-517.cn/cn/static/1438099935002/assets/86/img/mcdelivery_logo_zh.jpg');


CREATE TABLE posts (
  id MEDIUMINT NOT NULL AUTO_INCREMENT,
  image VARCHAR(255) DEFAULT NULL,
  title VARCHAR(255) NOT NULL,
  summary TEXT DEFAULT NULL,
  content TEXT NOT NULL,
  markdown TEXT DEFAULT NULL,
  author_id MEDIUMINT NOT NULL,
  PRIMARY KEY (id),
  KEY `author_id` (`author_id`),
  CONSTRAINT `post_author_id` FOREIGN KEY (`author_id`) REFERENCES `authors` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE tags (
  id MEDIUMINT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE post_tags (
  id MEDIUMINT NOT NULL AUTO_INCREMENT,
  post_id MEDIUMINT NOT NULL,
  tag_id MEDIUMINT NOT NULL,
  PRIMARY KEY (id),
  KEY `post_id` (`post_id`),
  CONSTRAINT `tag_post_id` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  KEY `tag_id` (`tag_id`),
  CONSTRAINT `post_tag_id` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

# SHOW ENGINE INNODB STATUS;
