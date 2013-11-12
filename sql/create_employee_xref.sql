/* 
 * =======================================================================================
 * $Author:			Jon Seidel
 * $Create date:	2012-12-15
 * $Description:	Create employee cross-reference table
 *                Used to deal with the name/id issue for employee/applicants
 * =======================================================================================
 * $ISSUES / 2DOs:
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-15 jes	- Initial creation
 * 2013-01-13 jes - Add collapsed match_name
 * =======================================================================================
 */
USE XYZBTRS_SQL

DROP TABLE [mors_employee_xref]

CREATE TABLE [mors_employee_xref] (
[id] int NOT NULL IDENTITY,
[employee_id] int NOT NULL,
[BTRS_employee_number] varchar(20) default NULL,
[BTRS_full_name] varchar(60) default NULL,
[BTRS_first_name] varchar(30) default NULL,
[BTRS_middle_name] varchar(30) default NULL,
[BTRS_last_name] varchar(30) default NULL,
[BTRS_match_name] varchar(30) default NULL,
PRIMARY KEY  ([id])
) 

PRINT '==> Created employee_xref table'
