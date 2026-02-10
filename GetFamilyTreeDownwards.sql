CREATE PROCEDURE `GetFamilyTreeDownwards`(IN personIdIn INT, IN numberOfGenerationsIn INT, IN logIn BOOL)
BEGIN
	DECLARE CompletedOk INT;
	DECLARE NewTransNo INT;
	DECLARE TransResult INT;
    DECLARE MessageText CHAR;
	DECLARE ReturnedSqlState INT;
	DECLARE MySQLErrNo INT;
        
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET CURRENT DIAGNOSTICS CONDITION 1 MessageText = message_text, ReturnedSqlState = RETURNED_SQLSTATE, MySqlErrNo = MYSQL_ERRNO;
			ROLLBACK;

			SET CompletedOk = 2;

			IF logIn THEN
				INSERT INTO humans.testlog 
				SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". SPROC GetFamilyTreeDownwards(). Error occured. Rollback executed. CompletedOk= ", IFNULL(CompletedOk, 'null'),
									'. MessageText= ', IFNULL(MessageText, "null"), " / State=", IFNULL(ReturnedSqlState, "null"), " / ErrNo=", IFNULL(MySqlErrNo, "null")), 
									TestLogDateTime = NOW();
			END IF;
            
			SELECT CompletedOk;
		END;

main_proc:
	BEGIN
	START TRANSACTION;

	SET CompletedOk = 0;

	SET TransResult = 0;

	SET NewTransNo = GetTranNo("GetFamilyTreeDownwards");
    
	IF logIn THEN
		INSERT INTO humans.testlog 
			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Start GetFamilyTreeDownwards() with params: personIdIn= ', IFNULL(personIdIn, "null"), ' , numberOfGenerations= ', IFNULL(numberOfGenerationsIn, "null"), ' and logIn= ', IFNULL(logIn, "null") ),
			TestLogDateTime = NOW();
	END IF;
    
    
	IF logIn THEN
		INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. GetFamilyTreeDownwards(): running CTE to get the Familytree.'),
			TestLogDateTime = NOW();
	END IF;

    WITH RECURSIVE FamTree (Limitter, PersonId, PersonName, PersonBirth, PersonDeath, PersonIsMale, Father, Mother, Partner, ParentsArePartners) AS 
		(
			SELECT	
				1 as Limitter, 
				PersonID, 
                CONCAT(PersonGivvenName, ' ', PersonFamilyName) as PersonName,
				PersonDateOfBirth, 
				PersonDateOfDeath, 
				PersonIsMale,
				rf.RelationWithPerson as Father,
                rm.RelationWithPerson as Mother,
                rp.RelationWithPerson as Partner,
                fCheckIfParentsAreAlsoPartners(PersonID) as ParentsAreAlsoPartners
			FROM persons p 
				LEFT JOIN relations rf ON p.PersonID = rf.RelationPerson AND rf.RelationName = "1"
				LEFT JOIN relations rm ON p.PersonID = rm.RelationPerson AND rm.RelationName = "2"            
				LEFT JOIN relations rp ON p.PersonID = rp.RelationPerson AND rp.RelationName = "3"      
			WHERE p.PersonId = personIdIn
			UNION ALL
			SELECT	
                Limitter + 1,
				p.PersonID, 
                CONCAT(p.PersonGivvenName, ' ', p.PersonFamilyName) as PersonName,
				p.PersonDateOfBirth, 
				p.PersonDateOfDeath, 
				p.PersonIsMale,
				rf.RelationWithPerson as Father,
                rm.RelationWithPerson as Mother,
                rp.RelationWithPerson as Partner,
                fCheckIfParentsAreAlsoPartners(p.PersonID) as ParentsAreAlsoPartners
 			FROM persons p 
				LEFT JOIN relations rf ON p.PersonID = rf.RelationPerson AND rf.RelationName = "1"
				LEFT JOIN relations rm ON p.PersonID = rm.RelationPerson AND rm.RelationName = "2"            
				LEFT JOIN relations rp ON p.PersonID = rp.RelationPerson AND rp.RelationName = "3"      
				INNER JOIN FamTree FT ON FT.PersonId = rf.RelationWithPerson 
				WHERE Limitter < numberOfGenerationsIn
			) 
			SELECT * FROM FamTree;
    
	IF logIn THEN
		INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. End GetFamilyTreeDownwards() with result: ', IFNULL(TransResult, "null")),
			TestLogDateTime = NOW();
	END IF;
    
  END;  
    
END