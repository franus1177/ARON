IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetControlledCustomerWise') AND TYPE IN (N'FN'))
	DROP FUNCTION GetControlledCustomerWise
GO

CREATE FUNCTION GetControlledCustomerWise
(
	@p_CustomerID INT
)
RETURNS INT
AS
BEGIN
	DECLARE @ControlledCount INT;
	DECLARE @ObjectInstanceInspectionCount INT;
	DECLARE @ObjectInstanceCount INT;

	SELECT @ObjectInstanceInspectionCount=COUNT(A.ObjectInstanceID) 
	FROM	(	SELECT		OI.ObjectInstanceID 
				FROM		ObjectInstanceInspection OII
				JOIN		ObjectInstance OI
					ON		OII.ObjectInstanceID	=	OI.ObjectInstanceID
				JOIN		Location L 
				ON			OI.LocationID=L.LocationID
				JOIN	Customer C
					ON	C.CustomerID	=	L.CustomerID
				WHERE	C.CustomerID	=	@p_CustomerID
				GROUP BY OI.ObjectInstanceID) AS A
	
	SELECT	@ObjectInstanceCount	= COUNT(*) 
	FROM	ObjectInstance	OI
	JOIN	Location L 
		ON	OI.LocationID=L.LocationID
	JOIN	Customer C
		ON	C.CustomerID	=	L.CustomerID
	WHERE	C.CustomerID	=	@p_CustomerID

	IF(@ObjectInstanceCount	=	0)
	BEGIN
	SET @ObjectInstanceCount=1
	END

	 SELECT	@ControlledCount	=	(SELECT (@ObjectInstanceInspectionCount * 100 ) / (@ObjectInstanceCount))

	RETURN @ControlledCount;

END
