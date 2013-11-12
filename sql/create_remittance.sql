/* 
 * =======================================================================================
 * $Author:		    Jon Seidel
 * $Create date:  2012-12-23
 * $Description:	Create MORS remittance table
 * =======================================================================================
 * $ISSUES / 2DOs:
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-23 jes - initial creation
 * 2012-12-24 jes - Add [BTRS_UCI_match_name] for matching to client table
 *                (many messy name differences; see create_client.sql for notes)
 * =======================================================================================
 */
USE XYZBTRS_SQL
DROP TABLE [mors_remittance]

CREATE TABLE [mors_remittance] (
[id] int NOT NULL IDENTITY,
[line_no] int NOT NULL default '0',
[consumer_name] varchar(60) default NULL,
[uci_no] varchar(20) NOT NULL,
[service_code] varchar(10) NOT NULL,
[sub_code] varchar(10) default NULL,
[pos_authorization_no] varchar(50) NOT NULL,
[service_MY] varchar(10) NOT NULL,
[units] decimal(10,2) NOT NULL,
[amount] decimal(10,2) NOT NULL,
[adjustment_code] varchar(10) default NULL,
[ebill_id] varchar(10) NOT NULL,
[invoice_no] varchar(10) NOT NULL,
[BTRS_UCI_match_name] varchar(60) default NULL,
PRIMARY KEY  ([id])
) 
PRINT '==> Created remittance table'

