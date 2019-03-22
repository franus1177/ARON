
IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetScreenTableFunction') AND TYPE IN (N'FN'))
	DROP FUNCTION GetScreenTableFunction
GO

CREATE FUNCTION GetScreenTableFunction
(
	@p_ScreenID INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

	 DECLARE @listStr NVARCHAR(MAX) = ''
	 
	 SELECT	@listStr = COALESCE((CASE WHEN LEN(@listStr) >= 0 THEN  @listStr ELSE '' END) ,'') + 
			'{ScreenID:"'			+	CONVERT(VARCHAR, ScreenTable.ScreenID) +
			'",TableName:"'			+	CONVERT(VARCHAR, ScreenTable.TableName) +
			'",IsSingleTuple:"'		+	CONVERT(VARCHAR, CASE WHEN IsSingleTuple = 1 THEN 'true' ELSE 'false' END) +
			'",IsDetailFetched:"'	+	CONVERT(VARCHAR, CASE WHEN IsDetailFetched = 1 THEN 'true' ELSE 'false' END) + '"},'

	 FROM	ScreenTable
	 WHERE	ScreenTable.ScreenID = @p_ScreenID
 
	 IF(@listStr != '' ) 
		SET @listStr = '[' + left(@listStr, LEN(@listStr) - 1) + ']'
	 ELSE
		SET @listStr = null

	 RETURN @listStr				-- Return the result of the function

END
GO


IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetScreenActionFunction') AND TYPE IN (N'FN'))
	DROP FUNCTION GetScreenActionFunction
GO

CREATE FUNCTION GetScreenActionFunction
(
	@p_ScreenID INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

	 DECLARE @listStr NVARCHAR(MAX) = ''
	 
	 SELECT	@listStr = COALESCE((CASE WHEN LEN(@listStr) >= 0 THEN  @listStr ELSE '' END) ,'') + 
			'{ScreenID:"'		+	CONVERT(VARCHAR, ScreenAction.ScreenID) +
			'",ActionCode:"'	+	CONVERT(VARCHAR, ScreenAction.ActionCode) +
			'",ActionName:"'	+	CONVERT(VARCHAR, ActionName) +
			'",Sequence:"'		+	CONVERT(VARCHAR, Sequence) +
			'",IsAudited:"'		+	CONVERT(VARCHAR, CASE WHEN IsAudited = 1 THEN 'true' ELSE 'false' END) +
			'",IsRendered:"'	+	CONVERT(VARCHAR, CASE WHEN IsRendered = 1 THEN 'true' ELSE 'false' END) +	'"},'

	 FROM	ScreenAction
	 WHERE	ScreenAction.ScreenID = @p_ScreenID
	 
	 ORDER BY	ScreenAction.Sequence
 
	 IF(@listStr != '' ) 
		SET @listStr = '[' + left(@listStr, LEN(@listStr)-1) + ']'
	 ELSE
		SET @listStr = null

	 RETURN @listStr							-- Return the result of the function

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetAdditionalScreenAction') AND TYPE IN (N'FN'))
	DROP FUNCTION GetAdditionalScreenAction
GO

CREATE FUNCTION GetAdditionalScreenAction
(
	@p_ScreenID int,
	@p_UserRoleID int
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

	 DECLARE @listStr NVARCHAR(MAX) = ''
	 
	 SELECT	
			@listStr = COALESCE((CASE WHEN len(@listStr) >= 0 THEN  @listStr ELSE '' END) ,'') + 
			'{ScreenID:"'		+		CONVERT(VARCHAR, ScreenAction.ScreenID)	+
			'",ActionCode:"'	+		CONVERT(VARCHAR, ScreenAction.ActionCode)	+
			'",ActionName:"'	+		CONVERT(VARCHAR, ActionName)	+
			'",Sequence:"'		+		CONVERT(VARCHAR, Sequence)	+
			'",IsAudited:"'		+		CONVERT(VARCHAR, IsAudited)	+
			'",IsRendered:"'	+		CONVERT(VARCHAR, IsRendered)	+
			'",ActionCodeUserRole:"'+	CONVERT(VARCHAR, ''	+ ISNULL((
																	SELECT	UserRoleScreenAction.ActionCode 
																	FROM	UserRoleScreenAction 
																	WHERE	UserRoleScreenAction.ActionCode = ScreenAction.ActionCode 
																	AND		UserRoleScreenAction.ScreenID = ScreenAction.ScreenID 
																	AND		UserRoleScreenAction.UserRoleID = @p_UserRoleID),'') )	+''+
			'"},'

	 FROM   ScreenAction
	 WHERE  ScreenAction.ScreenID = @p_ScreenID
	 
	 ORDER BY ScreenAction.Sequence
 
	 IF(@listStr != '' )
		SET @listStr = ''+	left(@listStr, len(@listStr)-1)	+''
	 ELSE
		SET @listStr = null

	 RETURN @listStr			-- Return the result of the function

END