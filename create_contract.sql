-- =======================================================================================
-- $Author:		Jon Seidel
-- $Create date:  2012-12-13 
-- $Description:	Create MORS contract table
-- =======================================================================================
-- $ISSUES / 2DOs:
-- =======================================================================================
-- $CHANGE LOG:
-- 2012-12-13 jes - initial creation
-- 2012-12-14 jes - Add BTRS_client_number column for matching purposes
-- =======================================================================================
USE XYZBTRS_SQL

DROP TABLE [mors_contract]

CREATE TABLE [mors_contract] (
[id] int NOT NULL IDENTITY,
[customer_id] int default NULL,
[date_of_contract] date NOT NULL,
[pos_authorization_number] varchar(50) NOT NULL,
[client_id] int NOT NULL,
[BTRS_client_number] varchar(20) NULL,
[case_manager_name] varchar(50) default NULL,
[case_manager_id] varchar(20) default NULL,
[contract_period] tinyint default NULL,
[employee_type] tinyint default NULL,
[service_type] tinyint default NULL,
[start_date] date default NULL,
[end_date] date default NULL,
[budget_code] varchar(45) default NULL,
[account_code] varchar(45) default NULL,
[number_of_months] tinyint default NULL,
[dos_code] varchar(20) default NULL,
[dos_subcode] varchar(20) default NULL,
[authorized_units] int default NULL,
[unit_rate] float default NULL,
[unit_cost] float default NULL,
[contingent_months] tinyint default NULL,
[date_created] datetime default NULL,
[date_updated] datetime default NULL,
[created_by_user_id] int default NULL,
[updated_by_user_id] int default NULL,
PRIMARY KEY  ([id])
) 

PRINT '==> Created contract table'
