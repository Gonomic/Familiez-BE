DELIMITER $$
DROP FUNCTION IF EXISTS `fPersonExistsByIdentity`$$
CREATE FUNCTION `fPersonExistsByIdentity`(
    GenderIn TINYINT(1),
    GivenNameIn VARCHAR(25),
    FamilyNameIn VARCHAR(50),
    DateOfBirthIn DATE
)
    RETURNS TINYINT(1)
    SQL SECURITY INVOKER
    READS SQL DATA
    COMMENT 'Returns true when a person with the same gender, names, and date of birth exists'
BEGIN
    DECLARE ExistingCount INT DEFAULT 0;

    SELECT COUNT(*) INTO ExistingCount
    FROM humans.persons
    WHERE PersonIsMale <=> GenderIn
      AND PersonGivvenName = GivenNameIn
      AND PersonFamilyName = FamilyNameIn
      AND PersonDateOfBirth = DateOfBirthIn;

    RETURN IF(ExistingCount > 0, 1, 0);
END$$
DELIMITER ;