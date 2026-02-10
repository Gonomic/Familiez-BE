CREATE FUNCTION `fPersonExists`(`PersonIdIn` INT) RETURNS tinyint(1)
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT 'Function to check if givven person exists'
BEGIN


	DECLARE Counter INT;

	DECLARE ReturnValue BOOL;

SELECT COUNT(*) FROM persons WHERE PersonID = PersonIdIn INTO Counter;

IF  Counter = 0 THEN

	SET ReturnValue = FALSE;

ELSE

	SET ReturnValue = TRUE;

END IF;

RETURN ReturnValue; 

END