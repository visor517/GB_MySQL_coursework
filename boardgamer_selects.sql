USE boardgamer;

CREATE OR REPLACE VIEW games_table AS
SELECT
	games.name,
	name_original,
	(SELECT name FROM publishers WHERE id = pg.publisher_id) AS publisher,
	published_at,
	IF (playing_time_to IS NULL,
		concat('~',playing_time_from,' минут'),
	 	concat(playing_time_from,' - ',playing_time_to,' минут')
	) AS playing_time,
	concat(age,'+') AS age,
	concat(players_from,'-',players_to) AS players,
	games.description,
	rating / 10 AS rating
FROM games JOIN publishers_games AS pg ON games.id = pg.game_id;

SELECT * FROM games_table;


SELECT
	games.name,
	rating / 10 AS rating,
	vote,
	(SELECT nick_name FROM users WHERE user_id = id) AS user
FROM rating_votes JOIN games ON game_id = id ORDER BY name,vote;

