/* 
 * =======================================================================================
 * $Author:		    Jon Seidel
 * $Create date:  2013-01-04
 * $Description:	Create MORS job_rates table
 * =======================================================================================
 * $ISSUES / 2DOs:
 *  ** IGNORE_DUP_KEY ON for bulk insert from tblAssignments
 * =======================================================================================
 * $CHANGE LOG:
 * 2013-01-04 jes - initial creation
 * =======================================================================================
 */
USE XYZBTRS_SQL
DROP TABLE [mors_job_rates]

CREATE TABLE [mors_job_rates] (
[id] int NOT NULL IDENTITY,
[pos_authorization_number] VARCHAR(50) NOT NULL,
[job_number] varchar(45) NOT NULL,
[unit_rate] float DEFAULT NULL,
[unit_cost] float DEFAULT NULL,
PRIMARY KEY  ([id]),
CONSTRAINT pos_job_numbers_UNIQUE UNIQUE (pos_authorization_number, job_number)
	WITH (IGNORE_DUP_KEY = ON)
) 
PRINT '==> Created job_rates table'
