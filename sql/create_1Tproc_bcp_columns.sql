USE [MHCBTRS_SQL]
GO
/*
 * Stored procedure to export data using bcp with column names for tables
 */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP PROCEDURE [dbo].[sp_Generic_frm_Dynamic_SQL_Export] 
GO
CREATE PROCEDURE [dbo].[sp_Generic_frm_Dynamic_SQL_Export] 
-- Add the parameters for the stored procedure here
-- @sWhere is additional Select Statemends from Form.
(@SQLBody  varchar(5000) = NULL,
 @sWhere  varchar(8000) = NULL,
 @sOrder  varchar(2000) = NULL,
 @DataPath nvarchar(500),
 @FileName nvarchar(50))

As

DECLARE @SelectSQL nvarchar(4000)
DECLARE @ExportSQL nvarchar(4000)
DECLARE @WhereSQL varchar(8000)
DECLARE @OrderSQL nvarchar(4000)
DECLARE @dt varchar(30)
DECLARE @loc Int
DECLARE @InsertSQL varchar(5000)
DECLARE @DirTree Table (subdirectory nvarchar(255),depth INT)
DECLARE @DBName sysname
DECLARE @FullFileName nvarchar(500)
DECLARE @BackSlash nvarchar(1)
DECLARE @lc_col varchar(1500)
DECLARE @lc_col_val varchar(2500)
DECLARE @Column_Name varchar(2500)
DECLARE @UnionSQL nvarchar(max)
DECLARE @CreateViewSQL varchar(30)
-- Get body of select statement
 Set @SelectSQL = @SQLBody
-- Get WHERE of select statement
 Set @WhereSQL = @sWhere 
-- Get ORDER BY of select statement
 Set @OrderSQL = @sOrder
-- Only add WHERE data when it has been passed from the form
Begin
 If len(@sWhere) > 0  
  Set @SelectSQL = @SelectSQL + ' ' + @WhereSQL    
End
-- Only add ORDER BY data when it has been passed from the form
Begin
 If len(@OrderSQL) > 0  
  Set @SelectSQL = @SelectSQL  + ' ' + @OrderSQL 
End
--Check to see if user added a backslash to the directory if not add one
SELECT @BackSlash =  LEFT(@DataPath,1)
IF @BackSlash = '\'
 BEGIN
  Set @FullFileName=@DataPath + @FileName
 END
ELSE
 BEGIN
  Set @FullFileName=@DataPath + '\' + @FileName
 END
Select @FullFileName As FullFileName

Set @DBName = 'MHCBTRS_SQL'
Insert into @DirTree(subdirectory, depth)
EXEC master.sys.xp_dirtree @DataPath
IF NOT EXISTS(SELECT 1 FROM @DirTree WHERE subdirectory=@DBName)
 EXEC master.dbo.xp_create_subdir @DataPath
DELETE FROM @DirTree
--Create a temporary table with query results of select statement
Set @InsertSQL = ' into mytmptable '
Set @InsertSQL = substring(@SelectSQL,1,charindex('From',@SelectSQL)-1) + @InsertSQL + substring(@SelectSQL,charindex('From',@SelectSQL)-1, len(@SelectSQL))
Select @Insertsql As 'Insert SQL Statement'
IF EXISTS(SELECT [name] FROM MHCBTRS_SQL..sysobjects WHERE [name] = N'mytmptable' AND xtype='U')
 DROP TABLE mytmptable
EXEC (@InsertSQL)
Select @@servername As 'Server'
--build field names for csv file 
Declare row2col_cursor CURSOR FOR 
SELECT [name] AS [Column name]
FROM syscolumns
WHERE id = (SELECT id
FROM sysobjects
WHERE type = 'U'
AND [NAME] = 'mytmptable')
 OPEN row2col_cursor 
Set @lc_col_val = 'Select '
Set @lc_col = 'Select '
 FETCH NEXT FROM row2col_cursor 
 INTO @column_name

SELECT [name] AS [Column Name]
FROM syscolumns
WHERE id = (SELECT id FROM sysobjects WHERE type = 'U' AND [Name] = 'mytmptable')
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  IF @lc_col_val = 'Select ' 
   BEGIN
    Set @lc_col_val = @lc_col_val + ''''+ @column_name + ''' As ' + '''' + @column_name + ''''
    Set @lc_col =  @lc_col + 'Cast([' + @column_name +'] As VarChar)'
   END
  ELSE
   BEGIN
    Set @lc_col_val = @lc_col_val + '' + ',' + ''''+ @column_name + ''' As ' + '''' + @column_name + ''''
    Set @lc_col =  @lc_col + ',Cast(['+ @column_name +'] As VarChar)'
   END
 FETCH NEXT FROM row2col_cursor 
 INTO @column_name
END
 CLOSE row2col_cursor  
 DEALLOCATE row2col_cursor

Set @lc_col = @lc_col + ' from mytmptable'
-- Drop the view used to extract the data and rebuild it
IF EXISTS(SELECT [name] FROM MHCBTRS_SQL..sysobjects WHERE [name] = N'v_temptable' AND xtype='V')
 DROP VIEW v_temptable
Set @CreateViewSQL = 'Create View v_temptable As '
Set @UnionSQL = @CreateViewSQL + @lc_col_val + ' union all ' + @lc_col
Select @UnionSQL
--recreate the view for the extract
Exec (@UnionSQL)
Set @ExportSQL = 'bcp [MHCBTRS_SQL]..v_temptable out ' + @FullFileName + ' -c -T -S' + @@servername
--extract the data to the specified csv file
EXEC master..xp_cmdshell @ExportSQL
--Clean up the mess
DROP TABLE mytmptable
DROP VIEW v_temptable