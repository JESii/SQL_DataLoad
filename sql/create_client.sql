/* 
 * =======================================================================================
 * $Author:		    Jon Seidel
 * $Create date:  2012-12-14
 * $Description:	Create MORS client table
 * =======================================================================================
 * $ISSUES / 2DOs:
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-13 jes - initial creation
 *  NOTE          - New field [BTRS_client_number] for matching purposes
 * 2012-12-23 jes - New field [BTRS_client_name] for matching purposes
 * 2013-02-15 jes - New field [middle_name] per JohnDoe's request
 * =======================================================================================
 */
USE XYZBTRS_SQL
DROP TABLE [mors_client]

CREATE TABLE [mors_client] (
[id] int NOT NULL IDENTITY,
[status] smallint NOT NULL default '0',
[uci_number] varchar(20) default NULL,
[BTRS_client_number] varchar(20) default NULL,
[BTRS_client_name] varchar(60) default NULL,
[title] varchar(50) default NULL,
[first_name] varchar(30) default NULL,
[middle_name] varchar(30) default NULL,
[last_name] varchar(30) default NULL,
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
PRINT '==> Created client table'
