DELIMITER $$
CREATE PROCEDURE `GetAllParentCouples`(IN `FamilyName` varchar(50))
    SQL SECURITY INVOKER
    COMMENT 'To get all parents'
BEGIN

  SELECT DISTINCT

    CONCAT(Parent1.PersonGivvenName, ' ', Parent1.PersonFamilyName) AS 'Parent 1',

    CONCAT(Parent2.PersonGivvenName, ' ', Parent2.PersonFamilyName) AS 'Parent 2'

  FROM relations AllRelations

    #   Get all records from relations which define partnership

    INNER JOIN relationnames IsParent

      ON AllRelations.RelationName = IsParent.RelationNameID

      AND (IsParent.RelationnameName = 'Vader' OR IsParent.RelationnameName='Moeder')

    #   Get the first parent 

    INNER JOIN persons Parent1

      ON AllRelations.RelationPerson = Parent1.PersonID

    # Get the second parent

    INNER JOIN persons Parent2

      ON AllRelations.RelationWithPerson = Parent2.PersonID;

#  WHERE Parent1.PersonFamilyName LIKE CONCAT(FamilyName, '%')

#    OR Parent2.PersonFamilyName LIKE CONCAT (FamilyName, '%')

#  ORDER BY Parent1.PersonFamilyName, Parent1.PersonDateOfBirth;

END$$
DELIMITER ;
