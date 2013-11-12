/*
 * =======================================================================================
 * $Author:                 Jon Seidel
 * $Create date:  2013-01-06
 * $Description:        Insert data into MORS POS# "fixup" table
 * =======================================================================================
 * $ISSUES / 2DOs:
 *  Note: File provided by JohnDoe1 is called: "Data Transfer, Job Orders, No Name or POS C1.xls"
 *        Renamed for easier handling and first row deleted (very long comment would have caused
 *        the insert to fail. Also saved as tab-delimited text file, not xls
 *  Note: JohnDoe1 may update this file with "Hours Allotted" since these are not in POSHrs
 * =======================================================================================
 * $CHANGE LOG:
 * 2013-01-06 jes - initial creation
 * 2013-02-07 jes - adjust column definitions
 * =======================================================================================
 */

USE XYZBTRS_SQL
DROP TABLE [mors_fixup_pos_numbers]
CREATE TABLE [mors_fixup_pos_numbers] (
  [job_number] VARCHAR(20) NOT NULL,
  [dummy_1] VARCHAR(10) DEFAULT NULL,
  [BTRS_client_number] VARCHAR(20) NOT NULL,
  [client_last_name] VARCHAR(30) DEFAULT NULL,
  [client_first_name] VARCHAR(30) DEFAULT NULL,
  [pos_authorization_number] VARCHAR(30) NOT NULL,
  [uci_number] VARCHAR(30) DEFAULT NULL,
  [dummy_2] VARCHAR(30) DEFAULT NULL,
  [dummy_3] VARCHAR(30) DEFAULT NULL,
  [bill_rate] VARCHAR(30) DEFAULT NULL,         -- column J
  [pay_rate] VARCHAR(30) DEFAULT NULL,         -- column K
  [job_start_date] VARCHAR(10) DEFAULT NULL,
  [job_end_date] VARCHAR(10) DEFAULT NULL,
  [dummy_4] VARCHAR(30) DEFAULT NULL,
  [dummy_5] VARCHAR(30) DEFAULT NULL,
  [dummy_6] VARCHAR(30) DEFAULT NULL,
  [dummy_7] VARCHAR(30) DEFAULT NULL,
  [dummy_8] VARCHAR(30) DEFAULT NULL,
  [contract_period] VARCHAR(10) DEFAULT NULL, -- column S
  [contract_month] VARCHAR(10) DEFAULT NULL,  -- column T
  [dummy_9] VARCHAR(60) DEFAULT NULL,
  CONSTRAINT job_number_UNIQUE UNIQUE (job_number)
  )

BULK INSERT [mors_fixup_pos_numbers]
FROM 'c:\XYZ\dataload\pos_fixups.txt'
WITH (
FIELDTERMINATOR = '\t',
ROWTERMINATOR = '\n'
)

PRINT '==> Created & inserted POS Fixup table'
