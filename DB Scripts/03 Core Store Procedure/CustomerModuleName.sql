IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'CustomerModuleName') AND TYPE IN (N'P'))
DROP PROCEDURE CustomerModuleName
GO
CREATE PROCEDURE CustomerModuleName
(
	@CustomerID	INT,
	@p_LanguageCode CHAR(2) = 'EN'
)
----WITH ENCRYPTION
AS
BEGIN

	SELECT b.ModuleName,b.ModuleCode,CustomerID 
	FROM	__GetConfigurationModule(@p_LanguageCode)  b
	JOIN	CustomerModule
		ON	CustomerModule.ModuleCode	=	b.ModuleCode
	WHERE CustomerID = @CustomerID

END
GO