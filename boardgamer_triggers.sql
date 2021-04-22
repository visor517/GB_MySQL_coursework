USE boardgamer;

DROP TRIGGER IF EXISTS rating_votes_check;
DROP FUNCTION IF EXISTS get_rating;
DROP TRIGGER IF EXISTS do_vote;

DELIMITER //

-- ограничение голосования (допустимые значения 1..10)
CREATE TRIGGER rating_vote_check BEFORE INSERT ON rating_votes
FOR EACH ROW
BEGIN
	IF NEW.vote NOT IN (1,2,3,4,5,6,7,8,9,10) THEN
		SIGNAL SQLSTATE '45000' SET message_text = 'Insert Canceled. Vote может принимать значения от 1 до 10';
	END IF;
END //

-- подсчет рейтинга
CREATE FUNCTION get_rating (id BIGINT)
RETURNS INT READS SQL DATA
BEGIN
	RETURN (SELECT ROUND(AVG(vote) * 10) FROM rating_votes WHERE game_id = id);
END //

-- проголосовать
CREATE TRIGGER do_vote AFTER INSERT ON rating_votes
FOR EACH ROW 
BEGIN
	UPDATE games SET rating = get_rating(NEW.game_id) WHERE id = NEW.game_id;
END

DELIMITER ;

-- процедуры не понадобились, зато есть функция и триггеры

