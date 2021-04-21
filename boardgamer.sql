DROP DATABASE IF EXISTS boardgamer;

CREATE DATABASE boardgamer;

USE boardgamer;

CREATE TABLE games (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  	name VARCHAR(127) NOT NULL, -- названия не уникально, тк совпадения бывают
  	name_sub VARCHAR(255) DEFAULT NULL, # доп название
  	name_original VARCHAR(127) DEFAULT NULL,
  	playing_time_from SMALLINT NOT NULL,
  	playing_time_to SMALLINT DEFAULT NULL, -- возможно только одно время в первой колонке
  	age TINYINT DEFAULT 0,
  	players_from TINYINT DEFAULT 1,
  	players_to TINYINT DEFAULT NULL,
  	description TEXT DEFAULT NULL, 
  	rating TINYINT UNSIGNED DEFAULT NULL, -- предполагается использовать ячейку до 100, а уже выводить как от 0.0 до 10.0 (с десятыми)
  	logo VARCHAR(31) DEFAULT NULL -- 'name.jpg'	
);

-- издатель
CREATE TABLE publishers (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(63) NOT NULL UNIQUE,
	description VARCHAR(255)
);

-- таблица связи издателя и игр
CREATE TABLE publishers_games (
	game_id BIGINT UNSIGNED NOT NULL,
    publisher_id BIGINT UNSIGNED NOT NULL,
    published_at YEAR DEFAULT NULL,
    INDEX fk_publishers_games_game_idx (game_id),
    INDEX fk_publishers_games_category_idx (publisher_id),
    CONSTRAINT fk_publishers_games_game FOREIGN KEY (game_id) REFERENCES games (id),
    CONSTRAINT fk_publishers_games_publisher FOREIGN KEY (publisher_id) REFERENCES publishers (id),
    PRIMARY KEY (game_id, publisher_id)
); 

-- категории
CREATE TABLE categories (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(63) NOT NULL UNIQUE,
	description VARCHAR(255)
);

-- таблица связи категорий и игр
CREATE TABLE categories_games (
	game_id BIGINT UNSIGNED NOT NULL,
    category_id BIGINT UNSIGNED NOT NULL,
    INDEX fk_categories_games_game_idx (game_id),
    INDEX fk_categories_games_category_idx (category_id),
    CONSTRAINT fk_categories_games_game FOREIGN KEY (game_id) REFERENCES games (id),
    CONSTRAINT fk_categories_games_category FOREIGN KEY (category_id) REFERENCES categories (id),
    PRIMARY KEY (game_id, category_id)
);

-- изображения
CREATE TABLE medias (
	game_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	url VARCHAR(127) NOT NULL,
	media_type ENUM('img', 'pdf', 'file') NOT NULL,
	INDEX fk_images_games_game_idx (game_id),
    CONSTRAINT fk_images_games_game FOREIGN KEY (game_id) REFERENCES games (id)
);

-- пользователи
CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nick_name VARCHAR(145) NOT NULL,
    first_name VARCHAR(145) DEFAULT NULL,
    last_name VARCHAR(145) DEFAULT NULL,
    email VARCHAR(145) NOT NULL,
    phone CHAR(11) DEFAULT NULL,
    password_hash CHAR(65) DEFAULT NULL,
    birthday DATE NOT NULL,
    user_status VARCHAR(31),
    city VARCHAR(127),
    country VARCHAR(127),
    gender ENUM('w', 'm', 'x') DEFAULT 'x',
    logo VARCHAR(31) DEFAULT NULL, -- 'name.jpg'
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE INDEX email_unique (email),
    UNIQUE INDEX phone_unique (phone)
);

-- отзывы на игры
CREATE TABLE reviews (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    game_id BIGINT UNSIGNED NOT NULL,
    txt TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX fk_reviews_user_idx (user_id),
    INDEX fk_reviews_game_idx (game_id),
    CONSTRAINT fk_reviews_users_user FOREIGN KEY (user_id) REFERENCES users (id),
    CONSTRAINT fk_reviews_games_game FOREIGN KEY (game_id) REFERENCES games (id)
);

CREATE TABLE review_likes (
	user_id BIGINT UNSIGNED NOT NULL,
    review_id BIGINT UNSIGNED NOT NULL,
    like_type BOOLEAN,
    INDEX fk_likes_users_idx (user_id),
    INDEX fk_likes_reviews_idx (review_id),
    CONSTRAINT fk_likes_users_user FOREIGN KEY (user_id) REFERENCES users (id),
    CONSTRAINT fk_likes_reviews_review FOREIGN KEY (review_id) REFERENCES reviews (id),
    PRIMARY KEY (user_id, review_id)
);

CREATE TABLE rating_votes (
	user_id BIGINT UNSIGNED NOT NULL,
	game_id BIGINT UNSIGNED NOT NULL,
	vote TINYINT UNSIGNED NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- возможно пригодится, чтобы давать свежим голосам больший вес
	INDEX fk_votes_author_idx (user_id),
    INDEX fk_votes_game_idx (game_id),
    CONSTRAINT fk_votes_users_user FOREIGN KEY (user_id) REFERENCES users (id),
    CONSTRAINT fk_votes_games_game FOREIGN KEY (game_id) REFERENCES games (id),
    PRIMARY KEY (user_id, game_id)
);

CREATE TABLE collections (
	user_id BIGINT UNSIGNED NOT NULL,
    game_id BIGINT UNSIGNED NOT NULL,
    INDEX fk_collections_user_idx (user_id),
    INDEX fk_collections_game_idx (game_id),
    CONSTRAINT fk_collections_users_user FOREIGN KEY (user_id) REFERENCES users (id),
    CONSTRAINT fk_collections_games_game FOREIGN KEY (game_id) REFERENCES games (id),
    PRIMARY KEY (user_id, game_id)
);
