
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
	 BEGIN
		SET @listStr = '[' + left(@listStr, LEN(@listStr)-1) + ']'
	 END
	 ELSE
	 BEGIN
		SET @listStr = null
	 END

	 RETURN @listStr							-- Return the result of the function

END

