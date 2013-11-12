select * from XYZ_POSHrs_Import PC
where PC.Hours_Allotted is null or cast(pc.Hours_Allotted as numeric) = 0.0