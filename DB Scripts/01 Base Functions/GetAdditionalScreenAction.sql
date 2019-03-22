
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
	 BEGIN
		SET @listStr = ''+	left(@listStr, len(@listStr)-1)	+''
	 END
	 ELSE
	 BEGIN 
		SET @listStr = null
	 END

	 RETURN @listStr			-- Return the result of the function

END

