-- =======================================================================================
-- $Author:		    Jon Seidel
-- $Create date:  2012-12-14
-- $Description:	Create MORS client xref table
-- =======================================================================================
-- $ISSUES / 2DOs:
-- =======================================================================================
-- $CHANGE LOG:
-- 2012-12-24 jes - initial creation
-- =======================================================================================
USE XYZBTRS_SQL
DROP TABLE [mors_client_xref]

CREATE TABLE [mors_client_xref] (
[id] int IDENTITY NOT NULL,  
[BTRS_client_number] varchar(20) default NULL,
[BTRS_client_name] varchar(60) default NULL,
[BTRS_UCI_match_name] varchar(60) default NULL
PRIMARY KEY  ([id])
) 
PRINT '==> Created client xref table'
