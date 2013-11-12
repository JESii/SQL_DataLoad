/*
 * Script to create workers (employees) views from BTRS
 */
USE [XYZBTRS_SQL]
GO

DROP VIEW [dbo].[vw_btrs_workers]
GO
/*
 * =======================================================================================
 * $Author:		Jon Seidel
 * $Create date: 2012-12-16
 * $Description:	View to access unique worker information from BTRS
 *                Uses tblAssignments which has been previously updated!!!
 * =======================================================================================
 * $ISSUES / 2DOs:
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-16 jes	- initial creation
 * 2013-01-31 jes - Ignore Assignments before 2011/11
 *                  Well, maybe not when creating a worker... to use later
 * 2013-02-08 jes - Don't use ignore date; want all workers
 * =======================================================================================
 */

CREATE VIEW [dbo].[vw_btrs_workers]
	(appl_number, BTRS_full_name, appl_first_name, appl_middle_name, appl_last_name, Appl_SSN, Appl_Home_Phone, Appl_Cell_Phone )
AS 
	SELECT DISTINCT [ApplicantID] as appl_number, xxxappl_last_name + ', ' + xxxappl_first_name +  
		+ CASE WHEN xxxappl_middle_name IS NOT NULL THEN ' ' + xxxappl_middle_name ELSE '' END AS [BTRS_full_name], 
		xxxappl_first_name, xxxappl_middle_name, xxxappl_last_name, xxxAppl_SSN, xxxAppl_Home_Phone, xxxAppl_Cell_Phone
    FROM tblAssignments
      WHERE [ApplicantID] IS NOT NULL
GO
