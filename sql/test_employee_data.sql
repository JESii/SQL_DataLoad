/*
 * Outdated... still uses MHC_Assignments_Import 
 */
SELECT TOP 1000 [id],[status],[employee_number],[title],[first_name],[BTRS_middle_name],[last_name],[BTRS_full_name],[BTRS_match_name],[company]
,[email_address],[address],[address2],[city],[state],[zip],[country],[day_phone],[home_phone],[fax],[notes],[date_created],[date_updated],[created_by_user_id],[updated_by_user_id]
  FROM [MHCBTRS_SQL].[dbo].[mors_employee]
  order by btrs_match_name

use MHCBTRS_SQL  
/*select btrs_match_name from mors_employee ME
	group by btrs_match_name
	having count(*) > 1
*/	
select distinct btrs_match_name as ME_match_name from mors_employee
	where btrs_match_name is not null
	order by btrs_match_name
select distinct btrs_full_name as ME_full_name from mors_employee
	where btrs_full_name is not null
	order by btrs_full_name
select distinct V.xxxApplicant_Name V_full_name from tblVisits V
	where xxxApplicant_Name is not null
	order by V.xxxApplicant_Name
/*
 * This gets all the names from the Assignments import table
 */
select COUNT(*) as V_count from ( select distinct V.xxxApplicant_Name from tblVisits V) Z
select COUNT(*) as AI_count from (select distinct ai.Appl_Last_Name + ai.Appl_First_Name + ai.Appl_Middle_Name as squashed_name from MHC_Assignments_Import AI) Z
print '==> processing MHC_Assignments_Import'
declare @tmp table (match_name varchar(60))
insert @tmp
 select * from (select distinct dbo.fn_collapse_name(ai.Appl_Last_Name + ai.Appl_First_Name + ai.Appl_Middle_Name) as AI_match_name 
		from MHC_Assignments_Import AI) Z
	order by AI_match_name
select * from @tmp	
select * from @tmp	
	where match_name not in (select btrs_match_name from mors_employee)
-------------------
delete @tmp 
print '==> processing tblVisits'
insert @tmp
 select * from (select distinct dbo.fn_collapse_name(V.xxxApplicant_Name) as V_match_name 
		from tblVisits V) Z
	order by V_match_name
select * from @tmp	
PRINT '==> select from dbo.fn_collapse_name(V.xxxApplicant_Name) is less than ' + CHAR(10)
    + '    select from V.xxxApplicant_Name (1440 vs 1500 on 2013-01-13) ' + CHAR(10)
	+ '    which means that the double-space issue affects 60 names'
select * from @tmp	
	where match_name not in (select btrs_match_name from mors_employee)
		
