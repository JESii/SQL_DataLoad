/*
 * Not necessarily accurate/useful at this time
 */
USE XYZBTRS_SQL

select count(*) from mors_time_header
select distinct REPLACE(xxxApplicant_Name,'"',''), PONumber from tblVisits
	order by PONumber
