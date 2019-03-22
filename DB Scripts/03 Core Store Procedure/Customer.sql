 
IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'AddCustomer') AND TYPE IN (N'P'))
DROP PROCEDURE AddCustomer
GO

CREATE PROCEDURE AddCustomer
(
	@p_CustomerShortCode	NVARCHAR(10) = null,
	@p_CustomerName			GenericName = null	/*NVARCHAR(50)*/,
	@p_LegalEntityName		GenericName = null	/*NVARCHAR(50)*/,
	@p_Logo					BIGINT = null,
	@p_Remarks				ShortRemarks = null	/*NVARCHAR(100)*/,
	@p_AccountManagerID		UserID = null	/*INT*/,
	@p_EffectiveFromDate	DATE = null,
	@p_EffectiveTillDate	DATE = null,

	--@p_CustomerLanguage		CustomerLanguage_TableType			READONLY,
	--@p_CustomerLocation		CustomerLocation_TableType			READONLY,
	--@p_CustomerModule		CustomerModule_TableType			READONLY,
	--@p_CustomerServiceLine	CustomerServiceLine_TableType		READONLY,

	@p_LanguageCode CHAR(2),
	@p_UTCOffset NUMERIC(4,2),
	@p_EndUserID INT,
	@p_UserRoleID INT,
	@p_ScreenID SMALLINT,
	@p_AccessPoint VARCHAR(25),
	@p_CustomerID	CustomerID	/*SMALLINT*/ OUTPUT
)
----WITH ENCRYPTION
AS
BEGIN

	INSERT INTO Customer
			(	CustomerShortCode,CustomerName,LegalEntityName,Remarks,AccountManagerID,EffectiveFromDate,EffectiveTillDate	)
		VALUES
			(	@p_CustomerShortCode,@p_CustomerName,@p_LegalEntityName,@p_Remarks,1,@p_EffectiveFromDate,@p_EffectiveTillDate	);

	SET @p_CustomerID = SCOPE_IDENTITY();

	IF (@p_CustomerID > 0)
	BEGIN

		--INSERT INTO CustomerLanguage
		--		(	CustomerID,LanguageCode	)
		--	SELECT	@p_CustomerID,LanguageCode
		--	FROM	@p_CustomerLanguage

		--INSERT INTO CustomerModule
		--		(	CustomerID,ModuleCode	)
		--	SELECT	@p_CustomerID,ModuleCode
		--	FROM	@p_CustomerModule

		--INSERT INTO CustomerServiceLine
		--		(	CustomerID,ServiceLineCode	)
		--	SELECT	@p_CustomerID,ServiceLineCode
		--	FROM	@p_CustomerServiceLine

		---- Start Cursor for add dummy location for Customer
		--DECLARE	@Cur_Location	CURSOR,
		--		@LocationID		INT,
		--		@NewLocationID	INT,
		--		@LocationName	NVARCHAR(100)

		--SET @Cur_Location =	  CURSOR For SELECT l.LocationID,(@p_CustomerShortCode + '-' + l.LocationName) AS LocationName
		--								 FROM	@p_CustomerLocation cl 
		--								 JOIN	Location l 
		--											ON cl.LocationID	= l.LocationID

		--OPEN @Cur_Location FETCH NEXT FROM @Cur_Location INTO @LocationID,	@LocationName
		--WHILE @@FETCH_STATUS = 0
		--BEGIN
		--	SET	@NewLocationID	=	0;
			
		--	-- add dummy location for Customer
		--	DECLARE @cLocationSequence SMALLINT = isnull((SELECT MAX(LocationSequence) FROM Location WHERE ParentLocationID = @LocationID ),0)+1;
		--	INSERT INTO Location
		--		(	LocationName, ParentLocationID, HasCustomers, CustomerID, LocationSequence	)
		--	SELECT	@LocationName, @LocationID, 0, @p_CustomerID, @cLocationSequence
			
		--	SET @NewLocationID = SCOPE_IDENTITY();
			
		--	-- Add new Location
		--	IF(@NewLocationID > 0)
		--		INSERT INTO CustomerLocation
		--		(	CustomerID,LocationID	)
		--		SELECT	@p_CustomerID,@NewLocationID
				 
		--	FETCH NEXT FROM @Cur_Location INTO @LocationID,	@LocationName
		--END

		--CLOSE @Cur_Location; DEALLOCATE @Cur_Location;
		---- End Cursor for add dummy location for Customer

		--==Audit Log====================================================================================================================
		DECLARE
				@AuditLogID		BIGINT,
				@IsDetailAudit	BIT,
				@ObjectID		VARCHAR(50)			-- PK/UK column(s separated by |)

		SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_CustomerID)
		EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'I', @p_AccessPoint , @AuditLogID OUT, @IsDetailAudit OUT;

	END
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'UpdateCustomer') AND TYPE IN (N'P'))
DROP PROCEDURE UpdateCustomer
GO

CREATE PROCEDURE UpdateCustomer
(
	@p_CustomerID	CustomerID	/*SMALLINT*/,
	@p_CustomerShortCode	NVARCHAR(10),
	@p_CustomerName	GenericName	/*NVARCHAR(50)*/,
	@p_LegalEntityName	GenericName	/*NVARCHAR(50)*/,
	@p_Logo	BIGINT,
	@p_Remarks	ShortRemarks	/*NVARCHAR(100)*/,
	@p_AccountManagerID	UserID	/*INT*/,
	@p_EffectiveFromDate	DATE,
	@p_EffectiveTillDate	DATE,

	--@p_CustomerLanguage		CustomerLanguage_TableType			READONLY,
	--@p_CustomerLocation		CustomerLocation_TableType			READONLY,
	--@p_CustomerModule		CustomerModule_TableType			READONLY,
	--@p_CustomerServiceLine	CustomerServiceLine_TableType		READONLY,

	@p_LanguageCode CHAR(2),
	@p_UTCOffset NUMERIC(4,2),
	@p_EndUserID INT,
	@p_UserRoleID INT,
	@p_ScreenID SMALLINT,
	@p_AccessPoint VARCHAR(25)
)
----WITH ENCRYPTION
AS
BEGIN
	--== Audit Log Start================================================================================================================

	DECLARE @AuditLogID		BIGINT,
			@IsDetailAudit	BIT,
			@ObjectID		VARCHAR(50),			-- PK/UK column(s separated by |)
			@PreImage		XML
	
	BEGIN TRAN

	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_CustomerID)
	EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'U', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

	--IF(@IsDetailAudit = 1)
	--BEGIN
	--	SET @PreImage = (	SELECT	CustomerShortCode,CustomerName,LegalEntityName,WebURL,Logo,Remarks,AccountManagerID,EffectiveFromDate,EffectiveTillDate
	--						FROM	Customer
	--						WHERE	CustomerID	= @p_CustomerID
	--						FOR XML AUTO
	--					);

	--	IF(@PreImage IS NOT NULL)
	--		INSERT INTO  AuditPreImage
	--					(    AuditLogID,TableName, PreImage    )
	--				VALUES
	--					(    @AuditLogID,'Customer', @PreImage     )

		  
	--	SET @PreImage = (	SELECT	LanguageCode
	--						FROM	CustomerLanguage
	--						WHERE	CustomerID	= @p_CustomerID
	--						FOR XML AUTO
	--					);

	--	IF(@PreImage	IS NOT NULL)
	--		INSERT INTO  AuditPreImage
	--				(    AuditLogID, TableName, PreImage    )
	--			VALUES
	--				(    @AuditLogID, 'CustomerLanguage', @PreImage     )

		 
	--	SET @PreImage = (	SELECT	LocationID
	--						FROM	CustomerLocation
	--						WHERE	CustomerID	= @p_CustomerID
	--						FOR XML AUTO
	--					);

	--	IF(@PreImage	IS NOT NULL)
	--		INSERT INTO  AuditPreImage
	--				(    AuditLogID, TableName, PreImage    )
	--			VALUES
	--				(    @AuditLogID, 'CustomerLocation', @PreImage     )

		 
	--	SET @PreImage = (	SELECT	ModuleCode
	--						FROM	CustomerModule
	--						WHERE	CustomerID	= @p_CustomerID
	--						FOR XML AUTO
	--					);

	--	IF(@PreImage	IS NOT NULL)
	--		INSERT INTO  AuditPreImage
	--				(    AuditLogID, TableName, PreImage    )
	--			VALUES
	--				(    @AuditLogID, 'CustomerModule', @PreImage     )

		 
	--	SET @PreImage = (	SELECT	ServiceLineCode
	--						FROM	CustomerServiceLine
	--						WHERE	CustomerID	= @p_CustomerID
	--						FOR XML AUTO
	--					);

	--	IF(@PreImage	IS NOT NULL)
	--		INSERT INTO  AuditPreImage
	--				(    AuditLogID, TableName, PreImage    )
	--			VALUES
	--				(    @AuditLogID, 'CustomerServiceLine', @PreImage     )

	--END
	--== Audit Log End================================================================================================================

	UPDATE	Customer
	 SET	CustomerName		= @p_CustomerName,
			LegalEntityName		= @p_LegalEntityName,
			
			Remarks				= @p_Remarks,
			AccountManagerID	= 1,
			EffectiveFromDate	= @p_EffectiveFromDate,
			EffectiveTillDate	= @p_EffectiveTillDate
	WHERE	CustomerID			= @p_CustomerID

	--IF (@@ROWCOUNT = 0)
	--BEGIN
	--	RAISERROR('No Record found for Customer',16,1)
	--	RETURN -1;
	--END
	--ELSE IF(@p_Logo	IS NOT NULL)
	--	UPDATE	Customer
	--	SET	 Logo	= @p_Logo
	--	WHERE	CustomerID	= @p_CustomerID

	--DELETE FROM CustomerLanguage	 WHERE 	CustomerID	= @p_CustomerID	
	--	INSERT INTO CustomerLanguage
	--				(	CustomerID,LanguageCode	)
	--		SELECT	@p_CustomerID,LanguageCode
	--		FROM	@p_CustomerLanguage
		
	--DELETE FROM CustomerModule	 WHERE 	CustomerID	= @p_CustomerID	
	--	INSERT INTO CustomerModule
	--			(	CustomerID,ModuleCode	)
	--		SELECT	@p_CustomerID,ModuleCode
	--		FROM	@p_CustomerModule

	--DELETE FROM CustomerServiceLine	 WHERE 	CustomerID	= @p_CustomerID	
	--INSERT INTO CustomerServiceLine
	--			(	CustomerID,ServiceLineCode	)
	--	SELECT	@p_CustomerID,ServiceLineCode
	--	FROM	@p_CustomerServiceLine

	--/* Delete locations which are deleted from fron end */
	--DECLARE @tempLocation TABLE (LocationID INT)
	--INSERT INTO @tempLocation SELECT Location.Locationid 
	--					      FROM CustomerLocation 
	--						  join location
	--									on CustomerLocation.Locationid = Location.locationid
	--						   where CustomerLocation.customerid = @p_CustomerID
	--						   and ParentLocationID NOT IN (	SELECT LocationID 
	--															FROM @p_CustomerLocation
	--													   )

	--DELETE FROM CustomerLocation WHERE LocationID IN (	SELECT LocationID FROM @tempLocation	)

	--DELETE FROM Location		 WHERE LocationID IN (	SELECT LocationID FROM @tempLocation	)

	---- Start Cursor for add dummy location for Customer
	--DECLARE @Cur_Location	CURSOR,
	--		@LocationID		INT,
	--		@NewLocationID	INT,
	--		@LocationName	NVARCHAR(100);

	--SET @Cur_Location =	  CURSOR For SELECT l.LocationID,(@p_CustomerShortCode + '-' + l.LocationName) AS LocationName
	--								 FROM	@p_CustomerLocation cl 
	--								 JOIN	Location l 
	--											ON cl.LocationID	= l.LocationID

	--OPEN @Cur_Location FETCH NEXT FROM @Cur_Location INTO @LocationID,	@LocationName
	--WHILE @@FETCH_STATUS = 0
	--BEGIN
	--	set @NewLocationID = 0;

	--	IF NOT EXISTS(	SELECT 1 
	--					FROM Location l 
	--					JOIN CustomerLocation  cl 
	--							ON l.Locationid = cl.Locationid  
	--					WHERE	cl.CustomerID = @p_CustomerID
	--					AND		l.ParentLocationID = @LocationID 
	--				 )
	--	BEGIN
			
	--		-- add dummy location for Customer
	--		DECLARE @cLocationSequence SMALLINT = isnull((SELECT MAX(LocationSequence) FROM Location WHERE ParentLocationID = @LocationID ),0)+1;
	--		INSERT INTO Location
	--			(	LocationName,	ParentLocationID,HasCustomers,CustomerID, LocationSequence	)			-- CustomerID newly added by Govind
	--		SELECT	@LocationName,	@LocationID, 0, @p_CustomerID, @cLocationSequence
			
	--		SET @NewLocationID = SCOPE_IDENTITY();
			
	--		-- Add new Location
	--		IF(@NewLocationID > 0)
	--			INSERT INTO CustomerLocation (	CustomerID,LocationID	)
	--			SELECT	@p_CustomerID,@NewLocationID
	--	END

	--	FETCH NEXT FROM @Cur_Location INTO @LocationID,	@LocationName
	--END
	--CLOSE @Cur_Location; DEALLOCATE @Cur_Location;
		
	--IF (@@ERROR <> 0)
	--BEGIN
	--	RAISERROR('Unexpected error occurred in Customer!',0,0);
	--	ROLLBACK TRAN;
	--END
	
	--COMMIT TRAN;
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'DeleteCustomer') AND TYPE IN (N'P'))
DROP PROCEDURE DeleteCustomer
GO

CREATE PROCEDURE DeleteCustomer
(
	@p_CustomerID	CustomerID	/*SMALLINT*/,

	@p_LanguageCode CHAR(2),
	@p_UTCOffset NUMERIC(4,2),
	@p_EndUserID INT,
	@p_UserRoleID INT,
	@p_ScreenID SMALLINT,
	@p_AccessPoint VARCHAR(25)
)
----WITH ENCRYPTION
AS
BEGIN
	--== Audit Log Start================================================================================================================
	DECLARE
			@AuditLogID		BIGINT,
			@IsDetailAudit	BIT,
			@ObjectID		VARCHAR(50),			-- PK/UK column(s separated by |)
			@PreImage		XML

	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_CustomerID)
	EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'D', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

	--IF(@IsDetailAudit = 1)
	--BEGIN
	--	SET @PreImage = (	SELECT	CustomerShortCode,CustomerName,LegalEntityName,WebURL,Logo,Remarks,AccountManagerID,EffectiveFromDate,EffectiveTillDate
	--						FROM	Customer
	--						WHERE	CustomerID	= @p_CustomerID
	--						FOR XML AUTO
	--					);

	--	INSERT INTO  AuditPreImage
	--				(    AuditLogID, TableName, PreImage    )
	--			VALUES
	--				(    @AuditLogID,'Customer', @PreImage     )

	--	SET @PreImage = (	SELECT	LanguageCode
	--						FROM	CustomerLanguage
	--						WHERE	CustomerID	= @p_CustomerID
	--						FOR XML AUTO
	--					);

	--	IF(@PreImage	IS NOT NULL)
	--		INSERT INTO  AuditPreImage
	--				(    AuditLogID, TableName, PreImage    )
	--			VALUES
	--				(    @AuditLogID, 'CustomerLanguage', @PreImage     )

	--	SET @PreImage = (	SELECT	LocationID
	--						FROM	CustomerLocation
	--						WHERE	CustomerID	= @p_CustomerID
	--						FOR XML AUTO
	--					);

	--	IF(@PreImage	IS NOT NULL)
	--		INSERT INTO  AuditPreImage
	--				(    AuditLogID, TableName, PreImage    )
	--			VALUES
	--				(    @AuditLogID, 'CustomerLocation', @PreImage     )

	--	SET @PreImage = (	SELECT	ModuleCode
	--						FROM	CustomerModule
	--						WHERE	CustomerID	= @p_CustomerID
	--						FOR XML AUTO
	--					);

	--	IF(@PreImage	IS NOT NULL)
	--		INSERT INTO  AuditPreImage
	--				(    AuditLogID, TableName, PreImage    )
	--			VALUES
	--				(    @AuditLogID, 'CustomerModule', @PreImage     )

	--	SET @PreImage = (	SELECT	ServiceLineCode
	--						FROM	CustomerServiceLine
	--						WHERE	CustomerID	= @p_CustomerID
	--						FOR XML AUTO
	--					);

	--	IF(@PreImage	IS NOT NULL)
	--		INSERT INTO  AuditPreImage
	--				(    AuditLogID, TableName, PreImage    )
	--			VALUES
	--				(    @AuditLogID, 'CustomerServiceLine', @PreImage     )

	--	SET @PreImage = (	SELECT	ContactName,Email,Telephone,Mobile,IsPrimaryContact,UserID
	--						FROM	CustomerContact
	--						WHERE	CustomerID	= @p_CustomerID
	--						FOR XML AUTO
	--					);

	--	IF(@PreImage	IS NOT NULL)
	--		INSERT INTO  AuditPreImage
	--				(    AuditLogID, TableName, PreImage    )
	--			VALUES
	--				(    @AuditLogID, 'CustomerContact', @PreImage     )

	--	SET @PreImage = (	SELECT	AddressType, AddressLine1, AddressLine2, CityName, StateName,CountryName,Pincode,IsPrimaryAddress
	--						FROM	CustomerAddress
	--						WHERE	CustomerID	= @p_CustomerID
	--						FOR XML AUTO
	--					);

	--	IF(@PreImage	IS NOT NULL)
	--		INSERT INTO  AuditPreImage
	--				(    AuditLogID, TableName, PreImage    )
	--			VALUES
	--				(    @AuditLogID, 'CustomerAddress', @PreImage     )
	--END
	--== Audit Log End================================================================================================================

	--Start Delete Customer Dummy locations---------------------------------------------
	--DECLARE @Table	TABLE(LocationID INT NOT NULL); 
	--INSERT INTO @Table	SELECT LocationID FROM CustomerLocation WHERE	CustomerID	= @p_CustomerID

	--Delete Customr Location
	--DELETE
	--FROM	CustomerLocation
	--WHERE	CustomerID	= @p_CustomerID

	IF (@@ROWCOUNT > 0)
	BEGIN
		--DELETE	L
		--FROM	Location L
		--JOIN	@Table TL
		--			ON TL.LocationID	=	L.LocationID
		
		--End Delete Customer Dummy locations------------------------------------------------------------------------

		--DELETE
		--FROM	CustomerLanguage
		--WHERE	CustomerID	= @p_CustomerID

		--DELETE 
		--FROM	CustomerModule
		--WHERE 	CustomerID	= @p_CustomerID	

		--DELETE
		--FROM	CustomerServiceLineConfiguration
		--WHERE	CustomerID	= @p_CustomerID

		--DELETE
		--FROM	CustomerServiceLine
		--WHERE	CustomerID	= @p_CustomerID

		DELETE
		FROM	CustomerContact
		WHERE	CustomerID	= @p_CustomerID

		DELETE
		FROM	CustomerAddress
		WHERE	CustomerID	= @p_CustomerID

		DELETE
		FROM	Customer
		WHERE	CustomerID	= @p_CustomerID

		IF (@@ROWCOUNT = 0)
		BEGIN
			RAISERROR('No Record found for Customer',16,1)
			RETURN -1;
		END
	END
END
GO


IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'UpdateCustomerLogo') AND TYPE IN (N'P'))
DROP PROCEDURE UpdateCustomerLogo
GO

CREATE PROCEDURE UpdateCustomerLogo
(
	@p_CustomerID	CustomerID	/*SMALLINT*/,
	@p_Logo	BIGINT,

	@p_LanguageCode CHAR(2),
	@p_UTCOffset NUMERIC(4,2),
	@p_EndUserID INT,
	@p_UserRoleID INT,
	@p_ScreenID SMALLINT,
	@p_AccessPoint VARCHAR(25)
)
----WITH ENCRYPTION
AS
BEGIN

	UPDATE	Customer
	 SET	Logo		= @p_Logo
	WHERE	CustomerID	= @p_CustomerID

	IF (@@ROWCOUNT = 0)
	BEGIN
		RAISERROR('No Record found for Customer',16,1)
		RETURN -1;
	END
	
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetCustomer') AND TYPE IN (N'P'))
DROP PROCEDURE GetCustomer	
GO
-- GetCustomer null,null,null,null,null,null,null,null,1,'EN',4.50,20,20,0,'102.120.36.25'	
CREATE PROCEDURE GetCustomer
(
	@p_CustomerID			CustomerID	/*SMALLINT*/,
	@p_CustomerShortCode	NVARCHAR(10),
	@p_CustomerName			GenericName	/*NVARCHAR(50)*/,
	@p_LegalEntityName		GenericName	/*NVARCHAR(50)*/,
	@p_Remarks				ShortRemarks	/*NVARCHAR(100)*/,
	@p_AccountManagerID		UserID	/*INT*/,
	@p_EffectiveFromDate	DATE,
	@p_EffectiveTillDate	DATE,
	@p_IsChildResult		BIT,

	@p_LanguageCode CHAR(2),
	@p_UTCOffset NUMERIC(4,2),
	@p_EndUserID INT,
	@p_UserRoleID INT,
	@p_ScreenID SMALLINT,
	@p_AccessPoint VARCHAR(25)
)
----WITH ENCRYPTION
AS
BEGIN

	--DECLARE @DATE DATE =  GETUTCDATE()-- For Controller validity
	--DECLARE @CustomerList Customer_TableType
	--INSERT INTO @CustomerList(CustomerID,CustomerName) EXEC GetUserCustomer 'SF', 'FR', @p_CustomerName, @DATE,@p_LanguageCode,@p_UTCOffset,@p_EndUserID,@p_UserRoleID,@p_ScreenID,@p_AccessPoint

	SELECT	Customer.CustomerID,
			CustomerShortCode,
			Customer.CustomerName,
			LegalEntityName,
			Logo,
			'' FileType,
			'' LogoString,
			Remarks,
			AccountManagerID,
			FirstName + ' ' + LastName as AccountManagerName,
			EffectiveFromDate,
			EffectiveTillDate
	FROM	Customer
	--JOIN	@CustomerList CL
	--			ON	(CL.CustomerID	=	Customer.CustomerID)
	JOIN	EndUser
				ON	(Customer.AccountManagerID	=	EndUser.EndUserID)
	--LEFT JOIN GetFileinfo_View
	--			ON Logo = GetFileinfo_View.FileID
	
	WHERE	(	Customer.CustomerID	=	@p_CustomerID
			OR	@p_CustomerID	IS NULL
			)
	AND		CustomerShortCode		LIKE  N'%' + COALESCE(@p_CustomerShortCode, N'') +  N'%'
	AND		Customer.CustomerName	LIKE  N'%' + COALESCE(@p_CustomerName, N'') +  N'%'
	AND		(	LegalEntityName		LIKE  N'%' + COALESCE(@p_LegalEntityName, N'') +  N'%'
			OR	@p_LegalEntityName	IS NULL
			)
	AND		(	Remarks				LIKE  N'%' + COALESCE(@p_Remarks, N'') +  N'%'
			OR	@p_Remarks	IS NULL
			)
	AND		(	AccountManagerID	=	@p_AccountManagerID
			OR	@p_AccountManagerID	IS NULL
			)
	AND		(	EffectiveFromDate	=	@p_EffectiveFromDate
			OR	@p_EffectiveFromDate	IS NULL
			)
	AND		(	EffectiveTillDate	=	@p_EffectiveTillDate
			OR	@p_EffectiveTillDate	IS NULL
			)

	--IF(@@ROWCOUNT = 1 AND @p_IsChildResult = 1)
	--BEGIN
	--	SELECT	CustomerID,
	--			LanguageCode
	--	FROM	CustomerLanguage
	--	WHERE	CustomerID	= @p_CustomerID

	--	SELECT	cl.CustomerID,
	--			cl.LocationID,
	--			l.ParentLocationID,			
	--			CONVERT(BIT,(	CASE	WHEN (	(	SELECT	COUNT(LocationID) 
	--									FROM	Location t 
	--									WHERE	cl.LocationID	=	t.ParentLocationID	)	> 0 
	--								)
	--						THEN 1 
	--						ELSE 0
	--				END
	--			))	AS	HasChild
							
	--	FROM	CustomerLocation	cl
	--	JOIN	Location			l
	--			ON	cl.LocationID	=	l.LocationID		
	--	WHERE	cl.CustomerID	= @p_CustomerID

	--	SELECT	CustomerID,
	--			ModuleCode
	--	FROM	CustomerModule
	--	WHERE	CustomerID	= @p_CustomerID

	--	SELECT	CustomerID,
	--			ServiceLineCode
	--	FROM	CustomerServiceLine
	--	WHERE	CustomerID	= @p_CustomerID

	--END

END
GO


IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetCustomerDDL') AND TYPE IN (N'P'))
DROP PROCEDURE GetCustomerDDL	
GO
-- GetCustomerDDL null,null,null,null,null,null,null,null,1,'EN',4.50,20,20,0,'102.120.36.25'	
CREATE PROCEDURE GetCustomerDDL
(
	@p_CustomerName			GenericName	/*NVARCHAR(50)*/
)
----WITH ENCRYPTION
AS
BEGIN

	SELECT	Customer.CustomerID,
			Customer.CustomerName
	FROM	Customer
	WHERE	CustomerShortCode		LIKE  N'%' + COALESCE(@p_CustomerName, N'') +  N'%'
	or		Customer.CustomerName	LIKE  N'%' + COALESCE(@p_CustomerName, N'') +  N'%'

END
GO



-- FCF9E11BDB6D6192AE49ADE2D15F89