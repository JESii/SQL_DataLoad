/*
 * =======================================================================================
 * $Author:		Jon Seidel
 * $Create date:	2013-01-04
 * $Description:  Insert data into mors_job_rates table
 * =======================================================================================
 * $ISSUES / 2DOs:
 *  ** This code assumes that IGNORE_DUP_KEY is st on job_number
 *     There are definitely duplicates because of differing bill & pay rate values
 *     ... For now, we just take the first one and ignore the rest
 * =======================================================================================
 * $CHANGE LOG:
 * 2013-01-04 jes	- initial creation
 * 2013-01-31 jes - Select only Assignments starting with 2011/11/01
 * 2013-02-08 jes - Change ignore date to 2011/10/01
 * 2013-02-09 jes - Exclude any Assignments with zero pay hours
 * =======================================================================================
 */

USE XYZBTRS_SQL

DELETE [mors_job_rates]

INSERT INTO [mors_job_rates]
SELECT DISTINCT
  A.PONumber AS pos_authorization_number,
  A.JobID AS job_number,
  A.bill_rate AS unit_rate,
  A.pay_rate AS unit_cost
  FROM tblAssignments A
    WHERE A.PONumber IS NOT NULL AND A.JobID IS NOT NULL
      AND CAST(A.[Asgn_Start_Date] AS datetime) >= '2011-10-01'
      AND CAST(A.Asgn_Total_Hours AS NUMERIC) <> 0.0
PRINT '==> ' + CAST(@@ROWCOUNT AS VARCHAR(8)) + ' rows inserted into mors_job_rates table'  
DECLARE @cnt1 INT = (
  SELECT COUNT(*) FROM (
    SELECT DISTINCT A.PONumber, A.JobID, A.Bill_Rate, A.Pay_Rate FROM tblAssignments A
      WHERE A.PONumber IS NOT NULL AND A.JobID IS NOT NULL
        AND CAST(A.[Asgn_Start_Date] AS datetime) >= '2011-10-01'
        AND CAST(A.Asgn_Total_Hours AS NUMERIC) <> 0.0) Z
    )
PRINT '==> ' + CAST(@cnt1 AS VARCHAR(8)) + ' candidate JobID rows in tblAssignments'
