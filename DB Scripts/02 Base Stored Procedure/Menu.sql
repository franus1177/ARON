 
IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetMenu') AND TYPE IN (N'P'))
DROP PROCEDURE GetMenu
GO
-- GetMenu null,null,null,null,'BS'
CREATE PROCEDURE GetMenu 
(
	@p_MenuCode VARCHAR(15),
	@p_MenuName VARCHAR(50),
	@p_Sequence TINYINT,
	@p_ParentMenuCode VARCHAR(15),
	@p_ModuleCode CHAR(2)
)
----WITH ENCRYPTION
AS
BEGIN

	DECLARE @MenuTable TABLE (/*ModuleCode CHAR(2),*/MenuCode VARCHAR(15)) --select distinct modulecode , menucode from screen where menucode is not null
	INSERT INTO @MenuTable
	SELECT DISTINCT MenuCode FROM Screen WHERE MenuCode IS NOT NULL AND ModuleCode = @p_ModuleCode


	SELECT	Menu.MenuCode,
			MenuName,
			Sequence,
			ParentMenuCode
	 FROM	Menu
	 JOIN	@MenuTable M ON M.MenuCode = Menu.MenuCode
	WHERE	(	Menu.MenuCode LIKE  '%' + COALESCE(@p_MenuCode, '') +  '%'
			OR	@p_MenuName	IS NULL
			)
	AND		(	Menu.MenuName LIKE  '%' + COALESCE(@p_MenuName, '') +  '%'
			OR	@p_MenuName	IS NULL
			)
	AND		(	Menu.Sequence	=	@p_Sequence			
			OR	@p_Sequence	IS NULL
			)
	AND		(	Menu.ParentMenuCode LIKE  '%' + COALESCE(@p_ParentMenuCode, '') +  '%'
			OR	@p_ParentMenuCode	IS NULL
			)

END
GO

-- 11FC0DD6943F438B8F6DE6AC046F0B