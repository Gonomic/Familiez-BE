CREATE FUNCTION `RowCountForFamilyTree`() RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
    COMMENT 'Function to count the number of rows in the FamilyTree table'
BEGIN
	DECLARE RowCountToBeReturned INT(11);
	SELECT count(*) FROM FamilyTree INTO RowCountToBeReturned; 
	RETURN RowCountToBeReturned;
END