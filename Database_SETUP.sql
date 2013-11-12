/*
 * $Description:	Copy main tables in case we want to re-load them for testing
 *                Happens for newly-restored databases
 *
 * =======================================================================================
 * $ISSUES / 2DOs:
 * =======================================================================================
 * $CHANGE LOG:
 * 2013-02-08 jes - initial creation
 * =======================================================================================
 */

USE XYZBTRS_SQL

SELECT * INTO tblAssignments_copy FROM tblAssignments
SELECT * INTO tblPOSContracts_copy FROM tblPOSContracts
SELECT * INTO tblPOSHrs_copy FROM tblPOSHrs
SELECT * INTO tblVisits_copy FROM tblVisits
