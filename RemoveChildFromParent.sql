CREATE PROCEDURE `RemoveChildFromParent`(IN Child INT, IN Parent INT)
BEGIN

	-- ----------------------------------------------------------------------------------------------------------------------------------------------
    -- Author: 	Frans Dekkers (GoNomics)
    -- Date:	09-02-2020
    -- -----------------------------------
    -- Prurpose of this Sproc:
    -- Remove a child from a parent
    -- 
    -- Parameters of this Sproc:
    -- 'Parent'= The person to remove the child from
    -- 'Child'= The person to remove as child
    -- 
    -- High level flow of this Sproc:
    -- => Simply remove the record from table relations which ties one person as a child to another person as a parent
    --   
    -- Note:	None
    --		
    -- TODO's:
    -- => xx/xx/xxxx -> 
    -- ----------------------------------------------------------------------------------------------------------------------------------------------
    
    DECLARE CompletedOk INT;
    DECLARE NewTransNo INT;
    DECLARE TransResult INT;
    DECLARE GenderOfPerson INT;
    DECLARE RelationType INT;
    DECLARE RelationExisted BOOLEAN;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SET CompletedOk = 2;
		INSERT INTO humans.testlog 
			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured in SPROC: RemoveChildFromParrent(). Rollback executed. Not completed OK (NOK) for parent= ", IFNULL(Parent, 'null'), " and child= ", IFNULL(Child, 'null')),
				TestLogDateTime = NOW();
		SELECT "NOK" as Result;
	END;
	
    SET CompletedOk = true;
    SET TransResult = 0;
	SET NewTransNo = GetTranNo("RemoveChildFromParent");
	
    INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, ''),
						 '. Start SPROC: RemoveChildFromParent(). Remove a child from a parent. Child= ', IFNULL(Child, 'null'), '. Parent= ', IFNULL(Parent, 'null')),
		TestLogDateTime = NOW();

    SET GenderOfPerson = fGetGenderOfPerson(Parent);
    
    IF GenderOfPerson IS NULL THEN
		select 'Parent does not exist' as Result;
        INSERT INTO humans.testlog 
			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, ''),
								 '. SPROC: RemoveChildFromParent() to remove child with id= ', IFNULL(Child, null), ' from Parent with ID= ', IFNULL(Parent, null), ': parent does not exist.'),
				TestLogDateTime = NOW();
	ELSE
 		IF GenderOfPerson = 1 THEN
			SET RelationType = 1; -- Father
		ELSEIF GenderOfPerson = 0 THEN
			SET RelationType = 2; -- Mother
		ELSE 
			SET RelationType = 99; -- Gender was null, -99 signifies unexisting (parent) type
		END IF;

		IF fRelationExists(Child, RelationType, Parent) THEN
			INSERT INTO humans.testlog 
				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, ''),
								 '. SPROC: RemoveChildFromParent(). Relation with Child= ', IFNULL(Child, 'null'), ' and Parent= ', IFNULL(Parent, 'null'), ' exists.'),
				TestLogDateTime = NOW();
			SET RelationExisted = true;
			DELETE FROM relations 
				WHERE RelationPerson=Child
				AND RelationName=RelationType
				AND RelationWithPerson=Parent;
			IF RelationExisted AND fRelationExists(Child, RelationType, Parent) THEN
				SELECT "Relation not removed" as Result;
				INSERT INTO humans.testlog 
					SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, ''),
									 '. SPROC: RemoveChildFromParent(). Relation with Child= ', IFNULL(Child, 'null'), ' and Parent= ', IFNULL(Parent, 'null'), ' was not removed.'),
					TestLogDateTime = NOW();
			ELSE 
				SELECT "Relation removed" as Result;
				INSERT INTO humans.testlog 
					SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, ''),
									 '. SPROC: RemoveChildFromParent(). Relation with Child= ', IFNULL(Child, 'null'), ' and Parent= ', IFNULL(Parent, 'null'), ' was removed.'),
					TestLogDateTime = NOW();
			END IF;
		ELSE 
			SELECT "No existing relation" as Result;
			INSERT INTO humans.testlog 
				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, ''),
								 '. SPROC: RemoveChildFromParent(). Relation with Child= ', IFNULL(Child, 'null'), ' and Parent= ', IFNULL(Parent, 'null'), ' was non existent.'),
				TestLogDateTime = NOW();
		END IF;
	END IF;
	INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
			'. TransResult= ', IFNULL(TransResult, ''),
			'. End SPROC: RemoveChildFromParent(). Removed child: ', IFNULL(Child, 'null'), ' from parent: ', IFNULL(Parent, 'null')),
			TestLogDateTime = NOW();
END