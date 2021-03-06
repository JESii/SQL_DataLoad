ALTER FUNCTION [fn_column_names] (@table_name VARCHAR(50) )
RETURNS TABLE
RETURN ( 
/*
SELECT TOP 100 c.COLUMN_NAME AS ColumnName
FROM INFORMATION_SCHEMA.TABLES t
INNER JOIN INFORMATION_SCHEMA.COLUMNS c ON c.TABLE_CATALOG = t.TABLE_CATALOG
			AND c.TABLE_SCHEMA = t.TABLE_SCHEMA
			AND c.TABLE_NAME = t.TABLE_NAME
LEFT JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE u ON c.TABLE_CATALOG = u.TABLE_CATALOG
			AND c.TABLE_SCHEMA = u.TABLE_SCHEMA
			AND c.TABLE_NAME = u.TABLE_NAME
			AND c.COLUMN_NAME = u.COLUMN_NAME
WHERE TABLE_TYPE='BASE TABLE'
        and c.TABLE_NAME = @table_name
ORDER BY c.ORDINAL_POSITION
*/ 
SELECT TOP 150 COLUMN_NAME
    FROM INFORMATION_SCHEMA.Columns
    WHERE TABLE_NAME = @table_name
    ORDER BY ORDINAL_POSITION
   
)