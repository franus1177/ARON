
--== QR Code will be at only leaf node
IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetQRCode') AND TYPE IN (N'FN'))
	DROP FUNCTION GetQRCode
GO

CREATE FUNCTION GetQRCode
(
	@p_CustomerID CustomerID, @F_ObjectInstanceID ObjectInstanceID
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	
	 DECLARE @p_CustomerShortCode NVARCHAR(40) = (SELECT CustomerShortCode FROM Customer WHERE CustomerID	=	@p_CustomerID)

	 RETURN CONVERT(VARCHAR(100),ISNULL(@p_CustomerShortCode,'')) + '-A-' + CONVERT(VARCHAR(100),REPLACE(STR(@F_ObjectInstanceID, 8), SPACE(1), '0'));

END
GO

--== QR Code will be at only leaf node
IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetLocationQRCode') AND TYPE IN (N'FN'))
	DROP FUNCTION GetLocationQRCode
GO

CREATE FUNCTION GetLocationQRCode
(
	@p_CustomerID CustomerID, @p_LocationID LocationID
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	 IF(@p_CustomerID IS NULL)
	 RETURN	NULL;

	 DECLARE @p_CustomerShortCode NVARCHAR(40) = (SELECT CustomerShortCode FROM Customer WHERE CustomerID	=	@p_CustomerID)

	 RETURN CONVERT(VARCHAR(100),ISNULL(@p_CustomerShortCode,''))+'-L-'+ CONVERT(VARCHAR(100),REPLACE(STR(@p_LocationID, 8), SPACE(1), '0'));

END
GO