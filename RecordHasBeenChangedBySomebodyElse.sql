CREATE FUNCTION `RecordHasBeenChangedBySomebodyElse`(`PersonIdIn` INT, `DateTimeIn` DATETIME) RETURNS tinyint(1)
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT 'Function to check, based om a timestamp, whether or not a record has been changed by somebody else.'
BEGIN



	DECLARE ReturnValue BOOL;

	DECLARE StoredDateTime timestamp;



SELECT persons.Timestamp FROM persons WHERE PersonID = PersonIdIn INTO StoredDateTime;

IF  StoredDateTime = DateTimeIn THEN

	SET ReturnValue = FALSE;

ELSE

	SET ReturnValue = TRUE;

END IF;



RETURN ReturnValue; 



END