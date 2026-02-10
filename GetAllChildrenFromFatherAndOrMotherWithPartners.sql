DELIMITER $$
CREATE PROCEDURE `GetAllChildrenFromFatherAndOrMotherWithPartners`(IN `Father` int(11), IN `Mother` int(11))
    SQL SECURITY INVOKER
    COMMENT 'Gets all children from a specific father and/or mother and show'
BEGIN

  SELECT DISTINCT

    CONCAT(Children.PersonGivvenName, ' ', Children.PersonFamilyName) AS 'Naam kind',

    Partner.PartNaam AS 'Naam partner van kind'

  FROM relations AllRelations

    #   Get all records from relations from specific persons who are either father or mother

    INNER JOIN relationnames IsChild

      ON AllRelations.RelationName = IsChild.RelationNameID

      AND (IsChild.RelationnameName = 'Vader'

      OR IsChild.RelationnameName = 'Moeder')

      AND (AllRelations.RelationWithPerson = Father

      OR AllRelations.RelationWithPerson = Mother)

    #   Get all the children from these specific persons who are either father or mother

    INNER JOIN persons Children

      ON AllRelations.RelationPerson = Children.PersonID

    #Get all partners of the above found children

    LEFT JOIN (SELECT

        AllPartners.RelationPerson AS LinkToPartner,

        CONCAT(Partner.PersonGivvenName, ' ', Partner.PersonFamilyName) AS PartNaam

      FROM relations AllPartners

        INNER JOIN relationnames IsPartner

          ON AllPartners.RelationName = IsPartner.RelationnameID

          AND IsPartner.RelationnameName = 'Partner'

        INNER JOIN persons Partner

          ON AllPartners.RelationWithPerson = Partner.PersonID) AS Partner

      ON Children.PersonID = Partner.LinkToPartner

  ORDER BY Children.PersonDateOfBirth;

END$$
DELIMITER ;
