/*
 * $DESCRIPTION:
 *	Update tblAssignments with the 'other' fields that BTRS didn't use
 *====================================================================
 * $CHANGE LOG:
 * 2013-02-10 jes - Initial creation
 * 2013-02-16 jes - Make sure double-quotes stripped from names 
 *====================================================================
 */
 USE XYZBTRS_SQL
update tblAssignments 
	set xxxClient_name = REPLACE(AI.client_name,'"',''),
		xxxContact = REPLACE(AI.Contact,'"',''),
		xxxContact_Phone = REPLACE(AI.Contact_Phone,'"',''),
		xxxAppl_First_Name = REPLACE(AI.Appl_First_Name,'"',''),
		xxxAppl_Last_Name = REPLACE(AI.Appl_Last_Name,'"',''),
		xxxAppl_Middle_Name = REPLACE(AI.Appl_Middle_Name,'"',''),
		xxxAppl_Home_Phone = REPLACE(AI.Appl_Home_Phone,'"',''),
		xxxAppl_Cell_Phone = REPLACE(AI.Appl_Cell_Phone,'"',''),
		xxxAppl_SSN = REPLACE(AI.Appl_SSN,'"','')
from XYZ_Assignments_Import AI where tblAssignments.AssignmentID = AI.Assignment#

PRINT '==> ' + CAST(@@ROWCOUNT as varchar(8)) + ' tblAssignments updates from XYZ_Assignments_Import'
