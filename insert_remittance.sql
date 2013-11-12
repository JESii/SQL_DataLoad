/* 
 * =======================================================================================
 * $Author:		    Jon Seidel
 * $Create date:  2012-12-14
 * $Description:	Insert data into MORS remittance table
 * =======================================================================================
 * $ISSUES / 2DOs:
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-23 jes - initial creation
 * 2013-01-13 jes - Printout for tracking progress
 * =======================================================================================
 */

USE XYZBTRS_SQL

DELETE MORS_remittance

BULK INSERT MORS_remittance
FROM 'c:\XYZ\dataload\remittance.txt'
WITH (
FIELDTERMINATOR = '\t',
ROWTERMINATOR = '\n'
)

PRINT '==> Inserted ' + CAST(@@ROWCOUNT AS VARCHAR(8)) + ' rows in mors_remittance'
