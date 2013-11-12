/* 
 * =======================================================================================
 * $Author:			Jon Seidel
 * $Create date:	2012-12-14
 * $Description:	Create MORS Time Entry table 
 * =======================================================================================
 * $ISSUES / 2DOs:
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-14 jes	- Initial creation
 * 2013-01-27 jes - Add BTRS tblVisits ID
 * 2013-01-31 jes - Add job number
 * =======================================================================================
 */
USE XYZBTRS_SQL

DROP TABLE [mors_time_entry]

CREATE TABLE [mors_time_entry] (
[id] int  NOT NULL IDENTITY,
[time_header_id] int  NOT NULL,
[status] tinyint  default NULL,
[status_reason_code] varchar(50) default NULL,
[date_of_service] date NOT NULL,
[start_time] time NOT NULL,
[end_time] time NOT NULL,
[hours] float default '0',
[miles] tinyint  default NULL,
[reviewed_by_id] int  default NULL,
[reviewed_date] datetime default NULL,
[approved_by_id] int  default NULL,
[approved_date] datetime default NULL,
[date_paid] datetime default NULL,
[date_invoiced] datetime default NULL,
[invoice_number] varchar(45) default NULL,
[remitted_by_customer] date default NULL,
[customer_remittance_number] varchar(45) default NULL,
[denied_by_customer] tinyint  default '0',
[date_created] datetime default NULL,
[created_by_user_id] int  default NULL,
[date_updated] datetime default NULL,
[updated_by_user_id] int  default NULL,
[BTRS_visit_id] int NOT NULL,
[job_number] int NOT NULL,
PRIMARY KEY  ([id])
) 
PRINT '==> Created time_entry table'
