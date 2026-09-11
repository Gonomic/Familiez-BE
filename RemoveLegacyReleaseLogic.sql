DELIMITER $$
DROP PROCEDURE IF EXISTS `GetReleasesByComponent`$$
DELIMITER ;

DROP TABLE IF EXISTS `fe_release_changes`;
DROP TABLE IF EXISTS `fe_releases`;
DROP TABLE IF EXISTS `mw_release_changes`;
DROP TABLE IF EXISTS `mw_releases`;
DROP TABLE IF EXISTS `be_release_changes`;
DROP TABLE IF EXISTS `be_releases`;