DELIMITER $$
CREATE PROCEDURE `Clean_temptable_and_testlog`()
BEGIN
	-- ----------------------------------------------------------------------------------------------------------------------------------------------
    -- Author: 	Frans Dekkers (GoNomics)
    -- Date:	05-01-2020
    -- -----------------------------------
    -- Prurpose of this Sproc:
    -- Clean temporary table "FamilyTree" (this temporary table is used by SPROC GetFamilyTree as a "scratch" table to build a family tree based on an API request
    -- Clean non-temporary table "testlog"(this table is used to log SQL actions as executed by the various Sprocs's and Sfunc's 
    --		
    -- TODO's:
    -- => Nothing yet
    
	drop temporary table IF EXISTS FamilyTree;
	delete from testlog where TestlogID > 0;
	SHOW TABLEs LIKE 'FamilyTree';
	select * from testlog;
    
END$$
DELIMITER ;
