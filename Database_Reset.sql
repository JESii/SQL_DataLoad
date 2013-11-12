/*
 * Restore original state of database
 * Do this if you've run a dataload and want to start fresh
 * without having to restore the database. Useful for testing
 */
USE XYZBTRS_SQL

DROP TABLE tblAssignments
DROP TABLE tblPOSContracts
DROP TABLE tblPOSHrs
DROP TABLE tblVisits

EXEC sp_rename 'tblAssignments_copy', 'tblAssignments';
EXEC sp_rename 'tblPOSContracts_copy', 'tblPOSContracts';
EXEC sp_rename 'tblPOSHrs_copy', 'tblPOSHrs';
EXEC sp_rename 'tblVisits_copy', 'tblVisits';
 
SELECT * INTO tblAssignments_copy FROM tblAssignments
SELECT * INTO tblPOSContracts_copy FROM tblPOSContracts
SELECT * INTO tblPOSHrs_copy FROM tblPOSHrs
SELECT * INTO tblVisits_copy FROM tblVisits
