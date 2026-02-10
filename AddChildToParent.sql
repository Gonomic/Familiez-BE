CREATE PROCEDURE `AddChildToParent`(IN Child INT, IN Parent INT)
BEGIN

	-- ----------------------------------------------------------------------------------------------------------------------------------------------
    -- Author: 	Frans Dekkers (GoNomics)
    -- Date:	31-01-2020
    -- -----------------------------------
    -- Prurpose of this Sproc:
    -- Add a child to a parent
    -- 
    -- Parameters of this Sproc:
    -- 'Parent'= The person to add the child to
    -- 'Child'= The person to add as child
    -- 
    -- High level flow of this Sproc:
    -- => Simply add a record to table relations which ties one person as a child to another person as a father
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
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SET CompletedOk = 2;
		INSERT INTO humans.testlog 
			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured in SPROC: AddChildToParrent(). Rollback executed. Not completed OK (NOK) for parent= ", IFNULL(Parent, 'null'), " and child= ", IFNULL(Child, 'null')),
				TestLogDateTime = NOW();
		SELECT "NOK" as Result;
	END;
	
    SET CompletedOk = true;
    SET TransResult = 0;
    
    SET NewTransNo = GetTranNo("AddChildToParent");
    
    SET GenderOfPerson = fGetGenderOfPerson(Parent);
    
    IF GenderOfPerson = 1 THEN
		SET RelationType = 1; -- Father
	ELSEIF GenderOfPerson = 0 THEN
		SET RelationType = 2; -- Mother
	ELSE 
		SET RelationType = 99; -- Gender was null, -99 signifies unexisting (parent) type
    END IF;
      
    INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, ''),
							 '. Start SPROC: AddChildToParent(). Add a child to a parent. Child= ', IFNULL(Child, 'null'), '. Parent= ', IFNULL(Parent, 'null')),
			TestLogDateTime = NOW();
    
    
	INSERT INTO relations (RelationPerson, RelationName, RelationWithPerson) 
	VALUES (Child, RelationType, Parent);
   
	INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
			'. TransResult= ', IFNULL(TransResult, ''),
			'. End SPROC: AddChildToParent(). Added child: ', IFNULL(Child, 'null'), ' to parent: ', IFNULL(Parent, 'null')),
			TestLogDateTime = NOW();

SELECT 'OK' as Result;
   
END