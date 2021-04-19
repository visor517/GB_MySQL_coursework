DROP DATABASE IF EXISTS boardgamer;

CREATE DATABASE boardgamer;

USE boardgamer;

CREATE TABLE games (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  	name VARCHAR(127) NOT NULL, -- названия не уникально, тк совпадения бывают
  	name_sub VARCHAR(255) DEFAULT NULL, # доп название
  	name_original VARCHAR(127) DEFAULT NULL,
  	playing_time VARCHAR(15) NOT NULL,  -- ~60 мин, 45-60. Разные формы записи
  	age VARCHAR(15) NOT NULL, -- здесь обычно 12+, 6+, но быввает и 12-99, так что лучше строка
  	players VARCHAR(15) NOT NULL, -- 2-4, 2+ вариантов много
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
    published_at DATETIME DEFAULT NULL,
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
	url VARCHAR(63) NOT NULL,
	media_type ENUM('img', 'pdf', 'file') NOT NULL,
	INDEX fk_images_games_game_idx (game_id),
    CONSTRAINT fk_images_games_game FOREIGN KEY (game_id) REFERENCES games (id)
);

-- пользователи
CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(145) NOT NULL,
    last_name VARCHAR(145) NOT NULL,
    email VARCHAR(145) NOT NULL,
    phone INT UNSIGNED NOT NULL,
    password_hash CHAR(65) DEFAULT NULL,
    birthday DATE NOT NULL,
    user_status VARCHAR(31),
    city VARCHAR(127),
    country VARCHAR(127),
    gender ENUM('f', 'm', 'x') NOT NULL,
    logo VARCHAR(31) DEFAULT NULL, -- 'name.jpg'
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE INDEX email_unique (email),
    UNIQUE INDEX phone_unique (phone)
);

-- отзывы на игры
CREATE TABLE reviews (
    user_id BIGINT UNSIGNED NOT NULL,
    game_id BIGINT UNSIGNED NOT NULL,
    txt TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX fk_reviews_user_idx (user_id),
    INDEX fk_reviews_game_idx (game_id),
    CONSTRAINT fk_reviews_users_user FOREIGN KEY (user_id) REFERENCES users (id),
    CONSTRAINT fk_reviews_games_game FOREIGN KEY (game_id) REFERENCES games (id),
    PRIMARY KEY (user_id, game_id)
);

CREATE TABLE rating_votes (
	id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
	game_id BIGINT UNSIGNED NOT NULL,
	vote ENUM('1', '2', '3', '4', '5', '6', '7', '8', '9', '10') NOT NULL,
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
