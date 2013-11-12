USE XYZBTRS_SQL 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM [dbo].[sysobjects]
           WHERE ID = object_id(N'[dbo].[fn_collapse_name]') AND
                 XTYPE IN (N'FN', N'IF', N'TF'))
    DROP FUNCTION [dbo].[fn_collapse_name]
GO
/*
 * =============================================
 * Author:		Jon Seidel
 * Create date: 2013-01-13
 * Description:	Collapse names to alphanumeric characters only
 * =============================================
 */

CREATE FUNCTION [dbo].[fn_collapse_name]
(
	@name varchar(60)
)
RETURNS varchar(60)
AS
BEGIN
	DECLARE @result_var varchar(60)

	SET @result_var = SQL#.RegEx_Replace(@name, '[ .,'']', '', -1, 1, '')

	RETURN @result_var

END
GO

