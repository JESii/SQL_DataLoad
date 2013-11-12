USE [XYZBTRS_SQL]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP VIEW [dbo].[vw_btrs_timesheets]
GO
/*
 * =======================================================================================
 * $Author:		Jon Seidel
 * $Create date: 2012-12-16
 * $Description:	View to unique 'timesheet' information from BTRS
 * 				Uses the the tblVisits table
 * =======================================================================================
 * $ISSUES / 2DOs:
 * **	Items in tblVisits with NULL POS Number are excluded!
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-16 jes	- initial creation
 * 2012-12-18 jes	- Correct xxxApplicant_Name and add contract & employee Foreign Keys
 * 2013-01-02 jes - JOIN to tblPOSContracts to get more non-NULL POS Numbers
 * 2013-01-13 jes - Use fn_collapse_name() & match to BTRS_match_name (18115 => 18456 rows)
 * 2013-02-06 jes - Add JOIN for clients to get client id (no loss of records)
 * =======================================================================================
 */
CREATE VIEW [dbo].[vw_btrs_timesheets]
AS
SELECT DISTINCT V.Progress_Date, PC.PONumber AS pos_number, V.ClientID AS client_number, ME.employee_number, 
	    ME.BTRS_full_name AS appl_full_name, MP.id as contract_id, ME.id as employee_id
	    ,MC.id as client_id
  FROM dbo.tblVisits AS V 
  JOIN tblPOSContracts as PC ON PC.JobID = V.JobID
  INNER JOIN dbo.mors_employee AS ME ON dbo.fn_collapse_name(V.xxxApplicant_Name) = ME.BTRS_match_name 
  INNER JOIN dbo.mors_contract as MP ON PC.PONumber = MP.pos_authorization_number
  INNER JOIN dbo.mors_client as MC ON PC.ClientID = MC.BTRS_client_number
    WHERE (PC.PONumber IS NOT NULL)

GO
