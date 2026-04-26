DELIMITER $$
DROP PROCEDURE IF EXISTS `GetUserPreferences`$$
CREATE PROCEDURE `GetUserPreferences`(IN `UsernameIn` VARCHAR(100))
    SQL SECURITY INVOKER
    COMMENT 'Get linked tree preferences for one username'
BEGIN

    SELECT
        P.username AS username,
        P.linked_person_id AS linked_person_id,
        P.generations_up AS generations_up,
        P.generations_down AS generations_down,
        P.auto_show_tree AS auto_show_tree
    FROM humans.familiez_user_preferences P
    WHERE P.username = TRIM(UsernameIn);

END$$
DELIMITER ;
