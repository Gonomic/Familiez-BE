DELIMITER $$
CREATE FUNCTION `fCheckPersonAlreadyExistsAsPartner`(PersonIdIn INT) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
    COMMENT 'Returns true if person already has a partner relation'
BEGIN
    DECLARE RecCount INT;

    SELECT COUNT(*) INTO RecCount
    FROM relations
    WHERE RelationPerson = PersonIdIn
      AND RelationName = 3;

    RETURN IF(RecCount > 0, 1, 0);
END$$
DELIMITER ;
