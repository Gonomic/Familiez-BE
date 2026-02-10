DELIMITER $$
CREATE FUNCTION `GetTranNo`(`SystemNameIn` VARCHAR(50)) RETURNS int(11)
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT 'Function to get a transactionnumber while at the same time storing the last number and the system it was used for.'
BEGIN



	DECLARE LastTranNo INT;



INSERT INTO humans.transnos

	SET SystemName = SystemNameIn,

		 TransNoDateTime = NOW();



SET LastTranNo = LAST_INSERT_ID();



RETURN LastTranNo;



END$$
DELIMITER ;
