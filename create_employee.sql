/* 
 * =======================================================================================
 * $Author:			Jon Seidel
 * $Create date:	2012-12-14
 * $Description:	Create MORS Employee table 
 * =======================================================================================
 * $ISSUES / 2DOs:
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-14 jes	- Initial creation
 *	NOTE			- Added new field 'BTRS_middle_name' to support proper name/id matching
 *  NOTE      - Added new field 'BTRS_full_name' as well
 * 2013-01-13 jes - New BTRS_match_name for matching
 * =======================================================================================
 */


USE XYZBTRS_SQL

DROP TABLE [mors_employee]

CREATE TABLE [mors_employee] (
[id] int NOT NULL IDENTITY,
[status] smallint NOT NULL default '0',
[employee_number] varchar(20) default NULL,		-- This must be the U/Staff number
[title] varchar(50) default NULL,
[first_name] varchar(30) default NULL,
[BTRS_middle_name] varchar(30) default NULL,			-- Added for DataLoad matching
[last_name] varchar(30) default NULL,
[BTRS_full_name] varchar(60) default NULL,        -- Added for data load matching
[BTRS_match_name] varchar(60) default NULL,        -- Added for data load matching
[company] varchar(50) default NULL,
[email_address] varchar(128) default NULL,
[address] varchar(50) default NULL,
[address2] varchar(50) default NULL,
[city] varchar(30) default NULL,
[state] varchar(50) default NULL,
[zip] varchar(20) default NULL,
[country] varchar(2) default NULL,
[day_phone] varchar(20) default NULL,
[home_phone] varchar(20) default NULL,
[fax] varchar(20) default NULL,
[notes] text,
[date_created] datetime default NULL,
[date_updated] datetime default NULL,
[created_by_user_id] int default NULL,
[updated_by_user_id] int default NULL,
PRIMARY KEY  ([id])
) 
PRINT '==> Created employee table'
