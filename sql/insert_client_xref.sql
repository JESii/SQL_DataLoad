/* 
 * =======================================================================================
 * $Author:		    Jon Seidel
 * $Create date:  2012-12-24
 * $Description:	Insert data into MORS client xref table
 * =======================================================================================
 * $ISSUES / 2DOs:
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-24 jes - initial creation
 * =======================================================================================
 */

USE XYZBTRS_SQL

BULK INSERT MORS_client_xref
FROM 'c:\XYZ\dataload\export_client_xref.txt'
WITH (
FIELDTERMINATOR = '\t',
ROWTERMINATOR = '\n'
)
