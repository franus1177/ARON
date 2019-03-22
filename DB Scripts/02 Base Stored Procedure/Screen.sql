IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetScreen') AND TYPE IN (N'P'))
DROP PROCEDURE GetScreen
GO
-- GetScreenAccess null,1,NULL
CREATE PROCEDURE GetScreen

----WITH ENCRYPTION
AS
BEGIN

	SELECT		Screen.ScreenID,		 
				Screen.ScreenName
	FROM		Screen
	ORDER BY	Screen.Sequence

END
GO