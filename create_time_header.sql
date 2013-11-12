/* 
 * =======================================================================================
 * $Author:			Jon Seidel
 * $Create date:	2012-12-14
 * $Description:	Create MORS Time Header table 
 * =======================================================================================
 * $ISSUES / 2DOs:
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-14 jes	- Initial creation
 * 2012-12-15 jes - Add BTRS matching columns
 * 2013-02-06 jes - Add client id
 * =======================================================================================
 */
USE XYZBTRS_SQL

DROP TABLE [mors_time_header]

CREATE TABLE [mors_time_header] (
[id] int  NOT NULL IDENTITY,
[employee_id] int NOT NULL,
[BTRS_employee_number] varchar(20) default NULL,
[contract_id] int NOT NULL,
[client_id] int NOT NULL,
[BTRS_pos_number] varchar(20) NOT NULL,
[BTRS_progress_date] date NOT NULL,
[date_created] datetime default NULL,
[date_updated] datetime default NULL,
[created_by_user_id] int default NULL,
[updated_by_user_id] int default NULL,
PRIMARY KEY  ([id])
) 
PRINT '==> Created time_header table'
