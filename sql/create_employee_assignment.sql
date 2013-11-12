-- =======================================================================================
-- $Author:			Jon Seidel
-- $Create date:	2012-12-14
-- $Description:	Create MORS Employee Assignment table 
-- =======================================================================================
-- $ISSUES / 2DOs:
-- =======================================================================================
-- $CHANGE LOG:
-- 2012-12-14 jes	- Initial creation
--  NOTE          - Added BTRS employee number column for matching purposes
-- =======================================================================================

USE XYZBTRS_SQL

DROP TABLE [mors_employee_assignment]

CREATE TABLE [mors_employee_assignment] (
[id] int NOT NULL IDENTITY,
[employee_id] int  NOT NULL,
[BTRS_employee_number] varchar(20) NULL,    -- BTRS Applicant#
[contract_id] int  NOT NULL,
[status] tinyint  NOT NULL,
[start_date] date NOT NULL,
[end_date] date NOT NULL,
[date_created] datetime default NULL,
[date_updated] datetime default NULL,
[created_by_user_id] int default NULL,
[updated_by_user_id] int default NULL,
PRIMARY KEY  ([id])
) 

PRINT '==> Created employee_assignment table...'
