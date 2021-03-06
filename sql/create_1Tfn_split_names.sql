/*
 * ====================================================================
 * Author:		Jon Seidel
 * Create date: 2013-02-15
 * Description:	Take a full name and split into 1st, middle, last
 * ====================================================================
 */
USE [MHCBTRS_SQL]
GO
DROP FUNCTION [dbo].[fn_split_names] 
GO
CREATE FUNCTION [dbo].[fn_split_names] 
(
	-- 1 = first name
	-- 2 = middle name
	-- 3 = last name
	@field int,
	@name varchar(60)
)
RETURNS varchar(60)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result_var varchar(30)
	DECLARE @fname varchar(60)
	DECLARE @mname varchar(60)
	DECLARE @lname varchar(60)
	DECLARE @tmpname varchar(60)
	IF @name IS NULL OR LEN(@name) = 0
	BEGIN
		SET @result_var = NULL
		RETURN @result_var
	END
	ELSE
	IF CHARINDEX(',', @name) = 0
	BEGIN
		SET @fname = ''
		SET @mname = ''
		SET @lname = @name
	END
	ELSE
	BEGIN
		SET @lname = SUBSTRING(@name,1,CHARINDEX(',',@name) -1)
		SET @tmpname = SQL#.String_Trim(SUBSTRING(@name,CHARINDEX(',',@name) +2, 60))
		IF CHARINDEX(' ',@tmpname) = 0
		BEGIN
			SET @mname = ''
			SET @fname = @tmpname
		END
		ELSE
		BEGIN
			SET @fname = SUBSTRING(@tmpname, 1, CHARINDEX(' ',@tmpname) -1)
			SET @mname = SUBSTRING(@tmpname, CHARINDEX(' ', @tmpname) +1, 60)
		END

	END
	IF @field = 1
		SET @result_var = @fname
	ELSE
	IF @field = 2
		SET @result_var = @mname
	ELSE
	IF @field = 3
		SET @result_var = @lname
	ELSE
		SET @result_var = NULL			
	RETURN @result_var
END
