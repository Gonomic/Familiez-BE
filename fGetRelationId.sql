CREATE FUNCTION `fGetRelationId`(RelationNameIn CHAR(15)) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
    COMMENT 'Function to get the relation id belonging to a relation name (f.e. "Mother" or "Father").'
BEGIN

    DECLARE RetVal INT;
    DECLARE NewTranNo INT;
    
    SET NewTranNo = GetTranNo("fGetRelationId");

	-- Schrijf start van deze SQL transactie naar log 
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTranNo, 'null'), '. Start FUNC: fGetRelationId() voor relation name: ', IFNULL(RelationNameIn, '')),
		TestLogDateTime = NOW();
        
    select Relationtype INTO RetVal from humans.relationnames where RelationnameName = RelationNameIn; 
    
	-- Schrijf einde van deze SQL transactie naar log 
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTranNo, 'null'), '. End FUNC: fGetRelationId() voor relation name= ', IFNULL(RelationNameIn, ''), '. RelationId= ', IFNULL(RetVal, 'null')),
		TestLogDateTime = NOW();    
   
	RETURN RetVal; 
   
END