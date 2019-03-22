IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetBaseDashboardCustomerList') AND TYPE IN (N'P'))
DROP PROCEDURE GetBaseDashboardCustomerList
GO
--   GetBaseDashboardCustomerList 1,null,'EN',4.50,1,1,0,'102.120.36.25'	
CREATE PROCEDURE GetBaseDashboardCustomerList
(
	@p_MonthDuration	INT,
	@p_CustomerID		CustomerID,

	@p_LanguageCode		CHAR(2),
	@p_UTCOffset		NUMERIC(4,2),
	@p_EndUserID		INT = 0,
	@p_UserRoleID		INT,
	@p_ScreenID			SMALLINT,
	@p_AccessPoint		VARCHAR(25)
 )
----WITH ENCRYPTION
AS
BEGIN

	DECLARE @DATE DATE =  GETUTCDATE()-- For Controller validity
	DECLARE @CustomerList Customer_TableType
	INSERT INTO @CustomerList(CustomerID,CustomerName) EXEC GetUserCustomer 'SF', 'FR', NULL, @DATE,@p_LanguageCode,@p_UTCOffset,@p_EndUserID,@p_UserRoleID,@p_ScreenID,@p_AccessPoint

	DECLARE @MonthDuration DATETIME = NULL;
	
	SET	@MonthDuration = DATEADD(MONTH, - (@p_MonthDuration), GETDATE())
		
		SELECT	CU.CustomerID,
				CU.CustomerName,
				dbo.GetControlledCustomerWise(CU.CustomerID) AS Controlled,
				(0
				--	SELECT	 COUNT(*) 
				--	FROM	Incident I	
				--	JOIN	IncidentLocation IL
				--		ON	I.IncidentID	=	IL.IncidentID
				--	JOIN	Location L
				--		ON	IL.LocationID	=	L.LocationID
				--	JOIN	Customer	C
				--		ON	C.CustomerID	=	L.CustomerID
				--	WHERE	C.CustomerID	=	CU.CustomerID
				) AS IncidentCount,  
				(0
				--	SELECT	COUNT(*) 
				--	FROM	Drill D
				--	JOIN	Location L
				--		ON	D.LocationID	=	L.LocationID
				--	JOIN	Customer	C
				--		ON	C.CustomerID	=	L.CustomerID
				--	WHERE	C.CustomerID	=	CU.CustomerID
				--	AND		ClosureDateTime IS NOT NULL
				) AS DrillActionClosureCount,  
				(	/*Select COUNT(*) from Training */ 85) AS TrainingStatusCount, 
				0 AS Risk
		FROM	Customer CU
		JOIN	@CustomerList CL
					ON	CU.CustomerID	=	CL.CustomerID
		WHERE	(	CU.CustomerID	=	@p_CustomerID
				OR	@p_CustomerID IS NULL 
				)

	SELECT	EndUserID,
			ModuleCode 
	FROM	EndUserModule
	WHERE	EndUserID	=	@p_EndUserID

END
GO
