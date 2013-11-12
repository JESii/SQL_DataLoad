-- =======================================================================================
-- $Author:			Jon Seidel
-- $Create date:	2012-12-14
-- $Description:	Create MORS contract_job table 
-- =======================================================================================
-- $ISSUES / 2DOs:
-- =======================================================================================
-- $CHANGE LOG:
-- 2012-12-14 jes	- Initial creation
-- 2012-12-15 jes - Add BTRS_pos_number column for matching
-- =======================================================================================

USE XYZBTRS_SQL

DROP TABLE [mors_contract_job]

CREATE TABLE [mors_contract_job] (
[id] int  NOT NULL IDENTITY,
[contract_id] int  default NULL,
[job_number] varchar(45) NOT NULL,        -- This is the BTRS job number field
[BTRS_pos_number] varchar(20) NOT NULL,   -- BTRS pos number field
[month] tinyint  NOT NULL,
[year] tinyint  NOT NULL,
[start_date] date NOT NULL,
[end_date] date NOT NULL,
[authorized_units] int  NOT NULL,
[date_created] datetime default NULL,
[date_updated] datetime default NULL,
[created_by_user_id] int default NULL,
[updated_by_user_id] int default NULL,
PRIMARY KEY  ([id])
) 
PRINT '==> Created contract_job table'
