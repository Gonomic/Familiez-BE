DELIMITER $$
CREATE PROCEDURE `GetFamilyTree`(PersonToStartWith int, NumberOfGenerationsToGoUp int, NumberOfGenerationsToGoDown int, InclusivePartners bool)
BEGIN
	-- ----------------------------------------------------------------------------------------------------------------------------------------------
    -- Author: 	Frans Dekkers (GoNomics)
    -- Date:	25-12-2019
    -- -----------------------------------
    -- Prurpose of this Sproc:
    -- Build a temporary table to contain the family tree of a specific person (= 'PersonToStartWith')
    -- Return this family tree to frond-end programs and apps in order to be able to manage the family tree of the requested person
    -- Intends to (initialy) feed the Genealogy app written by Frans Dekkers
    -- 
    -- Parameters of this Sproc:
    -- 'PersonToStartWith'= Person to build the family tree for
    -- 'NumberOfGenerationsToGoUp'= determines to which level ancestors of 'PersonToStartWith'will be included in the family tree
    -- 'NumberOfGenerationsToGoDown'= determines to which level (grand) childen of 'PersonToStartWith' will be included in the family tree
    -- 'InclusivePartners'= determines whether or not partners of (grand) childern of 'PersonToStartWith' will be included in the family tree
    --						this parameters also determines if partner of 'PersonToStartWith'(and partner's children) will be included
    -- 
    -- High level flow of this Sproc:
    -- => Create a temporary table "FamilyTree" to hold the family tree build based on the passed parameters
    -- => In this temporary table first store basic details for 'PersonToStartWith'
    -- => Then create a cursor to first traverse through this temporary table to get (from humans tabels) and store (in temporary FamilyTree table) the
    -- 	  basic details for the ancestors of 'PersonToStartWith'
    -- => Then use the cursor to traverse through this temporary table to get (from humans tables) and store (in temporary FamilyTree table) the
    --	  basic details for (grand) children of 'PerSonToStartWith'
    -- => Last but not least return the temporary table to the requesting Front-end app / program- or middleware API
    
    -- Notes:	The 'humans' database will include "all" humans, this Sproc will just deliver a subset of this based on the parameters as filled 
    -- 			in by the requesting frond-end or API middleware.
    --
    --			Adapted a "trick" to prevent persons form geeting added to the FamilyTree more then once as follows:
    --				Added "UNIQUE" to PersonId in creating temporary table FamilyTree and added "IGNORE" when inserting records into table FamilyTree.
    --				This in effect results in a warning when (trying) to add duplicate PersonId's and at the same time these record not being added.
    --		
    -- TODO's:
    -- => 25/12/19 Check if not much more efficient to use table 'relations'with some filters applied depended on input param's of this Sproc.
    -- => 27/12/19 GenerationCounter does not work as desired (counting of ancestor levels goes wrong). Repair.
    -- => 21/12/10 Replace where possible functions, fGetMother(), fGetFather() and fGetPartner() with proper SELECT FROM <relations table> and <relationname table>
    -- => 01/01/20 Change current quick & dirty solution which is now used to make ceratin all RecordId's are found, even if nbr of RecordId's <> nbr or records in FamilyTree
    --             The current quick & dirty solution is to just go throught the loop a couple of more times then that there are records
    -- => 01/01/20 Procedure aanpassen om de partners te vinden van kinderen tijdens de inleiding naar de loop. Nu werkt het alleen in geval er maar een kind is
    --             en gaat het (waarschijnlijk) mis als er meerdere kinderen zijn. 
    -- ----------------------------------------------------------------------------------------------------------------------------------------------
    
    
	DECLARE GenerationStartingLevel INT DEFAULT 0;
    DECLARE GenerationCounter INT;
    DECLARE pMother INT;
    DECLARE MotherAsNExtPerson INT;
    DECLARE FatherAsNextPerson INT;
    DECLARE PartnerAsNextPerson INT;
    DECLARE pFather INT;
    DECLARE pPartner INT;
    DECLARE pPersonsParentsPartners INT;
    DECLARE FatherFoundAsPerson BOOL;
    DECLARE MotherFoundAsPerson BOOL;
    DECLARE NextPerson INT;
    DECLARE NextPersonToGetChildrenFor INT;
    DECLARE PersonToFindBack INT;
    DECLARE PartnerToFindBack INT;
    DECLARE CompletedOk INT;
    DECLARE NewTransNo INT;
    DECLARE TransResult INT;
    DECLARE PersonAlreadyInFamilyTree INT;
    DECLARE RecordIndex INT;
	
    
    SET CompletedOk = true;
    SET TransResult = 0;
    SET NewTransNo = GetTranNo("GetFamilyTree");
    
    INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
        '. TransResult= ', IFNULL(TransResult, ''),
        '. Start SPROC: GetFamilyTree() voor persoon met ID= ', IFNULL(PersonToStartWith, 'null'),
        '. Number of generations to go up= ', IFNULL(NumberOfGenerationsToGoUp, 'null'),
        '. Number of generations to go down= ', IFNULL(NumberOfGenerationsToGoDown, 'null'),
        '. Include partner= ', IFNULL(InclusivePartners, 'null')),
		TestLogDateTime = NOW();

     -- Get/set details from the givven person him/herself in the temporary table
     INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
			'. TransResult= ', IFNULL(TransResult, ''),
			'. Opslaan data voor persoon met ID= ', IFNULL(PersonToStartWith, 'null')),
			TestLogDateTime = NOW();
    CREATE TEMPORARY TABLE IF NOT EXISTS FamilyTree(
		RecordId  INT NOT NULL AUTO_INCREMENT,
        PersonId INT NOT NULL UNIQUE,
        PersonName CHAR(50),
        PersonIsMale BOOL,
        PersonBirth DATE,
        PersonDeath DATE,
        PersonsFather INT,
        FatherFetched BOOL,
        PersonsMother INT,
        MotherFetched BOOL,
        PersonsParentsArePartners BOOL,
        PersonsPartner INT,
        PartnerFetched BOOL,
        PRIMARY KEY (RecordId, PersonId))
	AS       
      select PersonId,  CONCAT(PersonGivvenName, " ", PersonFamilyName) as PersonName,  PersonDateOfBirth as PersonBirth, PersonDateOfDeath as PersonDeath, PersonIsMale FROM persons where persons.PersonId = PersonToStartWith;
     
    SET pMother = fGetMother(PersonToStartWith);
	SET pFather = fGetFather(PersonToStartWith);
	SET pPartner = fGetPartner(PersonToStartWith);  
	UPDATE FamilyTree SET PersonsFather = pFather, FatherFetched = false, PersonsMother = pMother, MotherFetched=false, PersonsPartner = pPartner, PartnerFetched=false, PersonsParentsArePartners = pPersonsParentsPartners WHERE (PersonId = PersonToStartWith AND RecordId <> 0);
    
	-- Loop to get the familytree about the givven person, going up the familytree
    SET GenerationCounter = GenerationStartingLevel + 1;
    SET RecordIndex = 1;
    
    INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
						'. TransResult= ', IFNULL(TransResult, ''),
						'. =====>> Going up! Getting all ancestors (up until requested ancestor level)'),
						TestLogDateTime = NOW();
    
    going_up: LOOP
    
		-- FDE 27-12-2019 Note (!):
        -- Apparently a "SELECT <somefields> INTO <somevars> does not combine with EXIST, hence split it into two seperate lines / commands
        IF EXISTS (SELECT RecordId FROM FamilyTree WHERE RecordId = RecordIndex) THEN 
			SELECT PersonsFather, PersonsMother, PersonsPartner INTO @FatherAsNextPerson, @MotherAsNextPerson, @PartnerAsNextPerson FROM FamilyTree WHERE RecordId = RecordIndex;
    
			-- Find details of the Mother of previous person
            IF ! ISNULL(@MotherAsNextPerson) THEN
				SELECT COUNT(*) FROM FamilyTree WHERE PersonId = @MotherAsNextPerson LIMIT 1 INTO PersonAlreadyInFamilyTree;
				IF PersonAlreadyInFamilyTree = 0 THEN
					INSERT INTO humans.testlog 
						SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
						'. TransResult= ', IFNULL(TransResult, ''),
						'. Begin opslaan data voor persoon met ID= ', IFNULL(@MotherAsNextPerson, 'null')),
						TestLogDateTime = NOW();
					INSERT INTO FamilyTree (PersonId, PersonName, PersonBirth, PersonDeath, PersonIsMale)
						SELECT PersonId, CONCAT(PersonGivvenName, " ", PersonFamilyName), PersonDateOfBirth, PersonDateOfDeath, PersonIsMale FROM persons WHERE persons.PersonId = @MotherAsNextPerson;
					SET pMother = fGetMother(@MotherAsNextPerson);
					SET pFather = fGetFather(@MotherAsNextPerson);
					SET pPartner = fGetPartner(@MotherAsNextPerson);  
					UPDATE FamilyTree SET PersonsFather = pFather, FatherFetched = false, PersonsMother = pMother, MotherFetched=false, PersonsPartner = pPartner, PartnerFetched=false, PersonsParentsArePartners = pPersonsParentsPartners WHERE (PersonId = @MotherAsNextPerson AND RecordId <> 0);
					INSERT INTO humans.testlog
						SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
						'. TransResult= ', IFNULL(TransResult, ''),
						'. Gegevens opgeslagen voor persoon met ID= ', IFNULL(@MotherAsNextPerson, 'null')),
						TestLogDateTime = NOW();
				END IF;
			END IF; 
        
			-- Find details of the Father of previous person
			IF ! ISNULL(@FatherAsNextPerson) THEN
				SELECT COUNT(*) FROM FamilyTree WHERE PersonId = @FatherAsNextPerson LIMIT 1 INTO PersonAlreadyInFamilyTree;
				IF PersonAlreadyInFamilyTree = 0 THEN
					INSERT INTO humans.testlog
						SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
						'. TransResult= ', IFNULL(TransResult, ''),
						'. Begin opslaan data voor persoon met ID= ', IFNULL(@FatherAsNextPerson, 'null')),
						TestLogDateTime = NOW();
					INSERT INTO FamilyTree (PersonId, PersonName, PersonBirth, PersonDeath, PersonIsMale)
						SELECT PersonId, CONCAT(PersonGivvenName, " ", PersonFamilyName), PersonDateOfBirth, PersonDateOfDeath, PersonIsMale FROM persons WHERE persons.PersonId = @FatherAsNextPerson;
					SET pMother = fGetMother(@FatherAsNextPerson);
					SET pFather = fGetFather(@FatherAsNextPerson);
					SET pPartner = fGetPartner(@FatherAsNextPerson);  
					UPDATE FamilyTree SET PersonsFather = pFather, FatherFetched = false, PersonsMother = pMother, MotherFetched=false, PersonsPartner = pPartner, PartnerFetched=false, PersonsParentsArePartners = pPersonsParentsPartners WHERE (PersonId = @FatherAsNextPerson AND RecordId <> 0);
					INSERT INTO humans.testlog
						SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
						'. TransResult= ', IFNULL(TransResult, ''),
						'. Gegevens opgeslagen voor persoon met ID= ', IFNULL(@FatherAsNextPerson, 'null')),
						TestLogDateTime = NOW();
				END IF;
			END IF;
        
			-- Find details of the Partner of previous person (if SPROC parameter 'InclusivePartners' set to yes
			IF InclusivePartners = 1 THEN
				IF ! ISNULL(@PartnerAsNextPerson) THEN
					SELECT COUNT(*) FROM FamilyTree WHERE PersonId = @PartnerAsNextPerson LIMIT 1 INTO PersonAlreadyInFamilyTree;
					IF PersonAlreadyInFamilyTree = 0 THEN
						INSERT INTO humans.testlog
							SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
							'. TransResult= ', IFNULL(TransResult, ''),
							'. Begin opslaan data voor persoon met ID= ', IFNULL(@PartnerAsNextPerson, 'null')),
							TestLogDateTime = NOW();
						INSERT INTO FamilyTree (PersonId, PersonName, PersonBirth, PersonDeath, PersonIsMale)
							SELECT PersonId, CONCAT(PersonGivvenName, " ", PersonFamilyName), PersonDateOfBirth, PersonDateOfDeath, PersonIsMale FROM persons WHERE persons.PersonId = @PartnerAsNextPerson;
						SET pMother = fGetMother(@PartnerAsNextPerson);
						SET pFather = fGetFather(@PartnerAsNextPerson);
						SET pPartner = fGetPartner(@PartnerAsNextPerson);  
						UPDATE FamilyTree SET PersonsFather = pFather, FatherFetched = false, PersonsMother = pMother, MotherFetched=false, PersonsPartner = pPartner, PartnerFetched=false, PersonsParentsArePartners = pPersonsParentsPartners WHERE (PersonId = @PartnerAsNextPerson AND RecordId <> 0);
						INSERT INTO humans.testlog
							SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
							'. TransResult= ', IFNULL(TransResult, ''),
							'. Gegevens opgeslagen voor persoon met ID= ', IFNULL(@PartnerAsNextPerson, 'null')),
							TestLogDateTime = NOW();
					END IF;
				END IF;
			END IF;
			-- SET GenerationCounter = GenerationCounter + 1; 
		ELSE
			LEAVE going_up;
		END IF;
        
        SET GenerationCounter = GenerationCounter + 1;
        SET RecordIndex = RecordIndex + 1;
     
        IF GenerationCounter >= NumberOfGenerationsToGoUp THEN
			LEAVE going_up;
		END IF;
    END LOOP going_up;
    
    -- SET REcordIndex = RecordIndex + 1;
    
	INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
			'. TransResult= ', IFNULL(TransResult, ''),
			'. =====>> Going down! Getting all (grand) children (down to the requested level) for person= ', IFNULL(PersonToStartWith, 'null')),
			TestLogDateTime = NOW();
   

	INSERT INTO FamilyTree (PersonId, PersonName, PersonBirth, PersonDeath, PersonsFather, PersonsMother, PersonsPartner, PersonIsMale)
		SELECT DISTINCT PersonID as PersonId,  CONCAT(PersonGivvenName, " ", PersonFamilyName) as PersonName,  PersonDateOfBirth as PersonBirth, PersonDateOfDeath as PersonDeath, fGetFather(PersonID) AS PersonsFather, fGetMother(PersonID) AS PersonsMother, fGetPartner(PersonID) as PersonsPartner, PersonIsMale FROM persons 
			WHERE PersonID IN 
				(SELECT RelationPerson FROM relations
				WHERE RelationWithPerson = PersonToStartWith 
				AND (RelationName = 1 OR RelationName = 2));
                  
	IF InclusivePartners = 1 THEN
		
        INSERT INTO humans.testlog 
				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
					'. TransResult= ', IFNULL(TransResult, ''),
					'. ----->> Before inclusive partner. RecordIndex= ', IFNULL(RecordIndex, 'null')),
					TestLogDateTime = NOW();
                    
		IF EXISTS (SELECT RecordId FROM FamilyTree WHERE RecordId = RecordIndex) THEN
			SELECT PersonId, PersonsPartner INTO @PersonToFindBack, @PartnerToFindBack FROM FamilyTree WHERE RecordId = RecordIndex;
            
			INSERT INTO humans.testlog 
				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
					'. TransResult= ', IFNULL(TransResult, ''),
					'. ----->> Before inclusive partner. Finding partner= ', IFNULL(@PartnerToFindBack, 'null'), ' for person= ', IFNULL(@PersonToFindBack, 'null')),
					TestLogDateTime = NOW();
    

			INSERT INTO FamilyTree (PersonId, PersonName, PersonBirth, PersonDeath, PersonsFather, PersonsMother, PersonIsMale)
			SELECT DISTINCT PersonID as PersonId,  CONCAT(PersonGivvenName, " ", PersonFamilyName) as PersonName,  PersonDateOfBirth as PersonBirth, PersonDateOfDeath as PersonDeath, fGetFather(PersonID) AS PersonsFather, fGetMother(PersonID) AS PersonsMother, PersonIsMale 
				FROM persons JOIN relations ON persons.PersonID = relations.RelationWithPerson 
					WHERE RelationPerson =  @PersonToFindBack
						AND RelationWithPerson = @PartnerToFindBack 
						AND RelationName = 3;
               
			INSERT INTO humans.testlog 
				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
					'. TransResult= ', IFNULL(TransResult, ''),
					'. ----->> After inclusive partner'),
					TestLogDateTime = NOW();
                   
		END IF;
	END IF;
   
   SET GenerationCounter = GenerationStartingLevel + 1;
                    
	-- Loop to get the familitree about the givven person, going down the familytree
    going_down: LOOP
    
		INSERT INTO humans.testlog 
			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
				'. TransResult= ', IFNULL(TransResult, ''),
				'. ++++++++++++++++=> Looping. Top of loop. RecordIndex= ', IFNULL(RecordIndex, 'null'), '. RowCount=',  RowCountForFamilyTree()),
				TestLogDateTime = NOW();
    
		-- FDE 2020: This is the DIRTY solution
        IF RecordIndex <= (RowCountForFamilyTree() + 5) THEN 
        
			INSERT INTO humans.testlog 
				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
					'. TransResult= ', IFNULL(TransResult, ''),
					'. ++++++++++++++++=> Looping. First step of loop. RecordIndex= ', IFNULL(RecordIndex, 'null'), '. RowCount=',  RowCountForFamilyTree()),
					TestLogDateTime = NOW();
        
 			SELECT DISTINCT PersonId from FamilyTree WHERE RecordId = RecordIndex LIMIT 1 INTO NextPersonToGetChildrenFor; 
            
            IF NextPersonToGetChildrenFor = 0 THEN
				INSERT INTO humans.testlog 
					SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
						'. TransResult= ', IFNULL(TransResult, ''),
						'. ++++++++++++++++=> Looping. NextPersonToGetChildrenFor IS NULL'),
						TestLogDateTime = NOW();
				
            ELSE
            
				INSERT INTO humans.testlog 
				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
					'. TransResult= ', IFNULL(TransResult, ''),
					'. ++++++++++++++++=> Looping. Second step. Finding the (grand)children for grandfather/mother= ', IFNULL(PersonToStartWith, 'null'), ' and father/mother (NextPersonTogetChildrenFor)=', IFNULL(NextPersonToGetChildrenFor, 'null'), ' WITHOUT the partners of the (grand)children.'),
					TestLogDateTime = NOW();
				
				INSERT IGNORE INTO FamilyTree (PersonId, PersonName, PersonBirth, PersonDeath, PersonsFather, PersonsMother, PersonsPartner, PersonIsMale)
				SELECT DISTINCT PersonID as PersonId,  CONCAT(PersonGivvenName, " ", PersonFamilyName) as PersonName,  PersonDateOfBirth as PersonBirth, PersonDateOfDeath as PersonDeath, fGetFather(PersonID) AS PersonsFather, fGetMother(PersonID) AS PersonsMother, fGetPartner(PersonID) as PersonsPartner, PersonIsMale FROM persons 
					WHERE PersonID IN 
						(SELECT RelationPerson FROM relations
						 WHERE RelationWithPerson = NextPersonToGetChildrenFor 
						 AND (RelationName = 1 OR RelationName = 2));
                         
                         
				IF InclusivePartners = 1 THEN
					INSERT INTO humans.testlog 
						SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
						'. TransResult= ', IFNULL(TransResult, ''),
						'. ++++++++++++++++=> Looping. Second step. Finding the partners for the (grand)children of grandfather/mother= ', IFNULL(PersonToStartWith, 'null'), ' and father/mother (NextPersonTogetChildrenFor)=', IFNULL(NextPersonToGetChildrenFor, 'null')),
						TestLogDateTime = NOW();
                        
                        
					
                    INSERT IGNORE INTO FamilyTree (PersonId, PersonName, PersonBirth, PersonDeath, PersonsFather, PersonsMother, PersonsPartner, PersonIsMale)
					SELECT DISTINCT PersonID as PersonId,  CONCAT(PersonGivvenName, " ", PersonFamilyName) as PersonName,  PersonDateOfBirth as PersonBirth, PersonDateOfDeath as PersonDeath, fGetFather(PersonID) AS PersonsFather, fGetMother(PersonID) AS PersonsMother, fGetPartner(PersonID) as PersonsPartner, PersonIsMale FROM persons 
					WHERE PersonID IN   
						(SELECT DISTINCT RelationPerson FROM relations WHERE RelationName = 3 AND RelationWithPerson IN
							(SELECT RelationPerson FROM relations
							WHERE RelationWithPerson = NextPersonToGetChildrenFor 
							AND (RelationName = 1 OR RelationName = 2)));
					
                        
				END IF;
				SET NextPersonToGetChildrenFor = 0;
 			END IF;
			SET RecordIndex = RecordIndex  + 1;      
		ELSE 
			LEAVE going_down;
        END IF;
        -- SET RecordIndex = RecordIndex  + 1;
		SET GenerationCounter = GenerationCounter + 1;
        IF GenerationCounter = NumberOfGenerationsToGoDown THEN
				LEAVE going_down;
		END IF;
    END LOOP going_down;
    
    SELECT * FROM FamilyTree;
    
    DROP TEMPORARY TABLE FamilyTree;
    
    INSERT INTO humans.testlog 
			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
				'. TransResult= ', IFNULL(TransResult, ''),
				'. Einde SPROC: GetFamilyTRee() voor persoon met ID= ', IFNULL(PersonToStartWith, 'null')),
				TestLogDateTime = NOW();
	END$$
DELIMITER ;
