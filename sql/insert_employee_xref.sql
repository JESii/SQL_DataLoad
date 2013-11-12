/*
 * =======================================================================================
 * $Author:			Jon Seidel
 * $Create date:	2012-12-15
 * $Description:	Insert data into employee cross-reference table
 * =======================================================================================
 * $ISSUES / 2DOs:
 * ** NOTE **   The BTRS_full_name field has no quote (") characters in it!
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-15 jes	- Initial creation
 * 2012-12-18 jes - Add comment about no " in name field
 * 2013-01-13 jes - Add match_name column
 * 2013-01-31 jes - Select only Assignments starting with 2011/11/01
 *                  BUT... This is an employee select so ignore this selection
 * 2013-02-10 jes - Use tblAssignments now
 * 2013-02-16 jes - Make sure double-quotes stripped from names 
 *                (Should be happening in apply_assignments_fixup; just making sure)
 * =======================================================================================
 */
USE XYZBTRS_SQL

DELETE [mors_employee_xref]
INSERT INTO [mors_employee_xref]
SELECT
  MEID AS [employee_id]
  ,[employee_number] AS [BTRS_employee_number]
  ,REPLACE([BTRS_full_name],'"','') AS [BTRS_full_name]
  ,REPLACE(xxxappl_first_name,'"','') AS [BTRS_first_name]
  ,REPLACE(xxxappl_middle_name,'"','')AS [BTRS_middle_name]
  ,REPLACE(xxxappl_last_name,'"','')  AS [BTRS_last_name]
  ,dbo.fn_collapse_name(REPLACE(BTRS_full_name,'"','')) AS [BTRS_match_name]
  FROM (SELECT DISTINCT ME.id as MEID, [employee_number], 
    xxxappl_last_name + ', ' + xxxappl_first_name +  
    + CASE WHEN xxxappl_middle_name IS NOT NULL THEN ' ' + xxxappl_middle_name ELSE '' END AS [BTRS_full_name], 
    xxxappl_first_name, xxxappl_middle_name, xxxappl_last_name 
    FROM tblAssignments A
    
    JOIN [mors_employee] as ME ON ME.employee_number = A.[ApplicantID]
  ) Z

PRINT '==> ' +CONVERT(varchar(10), @@ROWCOUNT) + ' rows inserted into [mors_employee_xref]'    
