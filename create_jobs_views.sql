/*
 * Create the BTRS jobs views script
 */

USE [XYZBTRS_SQL]
GO
/* =======================================================================================
 $Author:		Jon Seidel
 $Create date: 2012-12-16
 $Description:	View to access job information from BTRS
					Uses the XYZ_POSContracts_Import table	
 =======================================================================================
 $ISSUES / 2DOs:
 2012-12-16	- There are duplicate POS Numbers in this file; i.e., the same POS Number
				is specified for more than one client. 
			* This is the raw data INCLUDING duplicates
			* See vw_btrs_cjobs_{duplicates/uniques} for more selective results
 =======================================================================================
 $CHANGE LOG:
 2012-12-16 jes	- initial creation
 =======================================================================================*/
DROP VIEW [dbo].[vw_btrs_jobs]
GO
CREATE VIEW [dbo].[vw_btrs_jobs]
AS
SELECT DISTINCT PO_Number AS pos_number, [Client#] AS client_number, [Job#] as job_number
  FROM dbo.XYZ_POSContracts_Import
    WHERE (PO_Number IS NOT NULL) AND (Client# IS NOT NULL) 
    GROUP BY PO_Number, Client#, JOB#
GO
