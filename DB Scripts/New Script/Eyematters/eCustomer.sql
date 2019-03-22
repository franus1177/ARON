
IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'AddeCustomer') AND TYPE IN (N'P'))
DROP PROCEDURE AddeCustomer
GO

CREATE PROCEDURE AddeCustomer
(
	@p_CustomerName			GenericName	/*NVARCHAR(50)*/,
	@p_CustomerAddress		ShortRemarks	/*NVARCHAR(100)*/,
	@p_ContactNumber		GenericName	/*NVARCHAR(50)*/,
	@p_DOB					DATE,
	@p_AnniversaryDate		DATE,

	@p_EndUserID			INT,
	@p_UserRoleID			INT,
	@p_ScreenID				SMALLINT,
	@p_AccessPoint			VARCHAR(25),
	@p_CustomerID			CustomerID	/*SMALLINT*/ OUTPUT
)
----WITH ENCRYPTION
AS
BEGIN

	Select @p_ScreenID = ScreenID FROM Screen WHERE ScreenName = 'Invoice Customer'

	INSERT INTO eCustomer
			(	CustomerName,CustomerAddress,ContactNumber,DOB,AnniversaryDate	)
		VALUES
			(	@p_CustomerName,@p_CustomerAddress,@p_ContactNumber,@p_DOB,@p_AnniversaryDate	);

	SET @p_CustomerID = SCOPE_IDENTITY();

	IF (@p_CustomerID > 0)
	BEGIN
		--==Audit Log====================================================================================================================
		DECLARE @AuditLogID		BIGINT,
				@IsDetailAudit	BIT,
				@ObjectID		VARCHAR(50)			-- PK/UK column(s separated by |)

		SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_CustomerID)
		EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'I', @p_AccessPoint , @AuditLogID OUT, @IsDetailAudit OUT;

	END
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'UpdateeCustomer') AND TYPE IN (N'P'))
DROP PROCEDURE UpdateeCustomer
GO

CREATE PROCEDURE UpdateeCustomer
(
	@p_CustomerID		CustomerID	/*SMALLINT*/,
	@p_CustomerName		GenericName	/*NVARCHAR(50)*/,
	@p_CustomerAddress	ShortRemarks	/*NVARCHAR(100)*/,
	@p_ContactNumber	GenericName	/*NVARCHAR(50)*/,
	@p_DOB				DATE,
	@p_AnniversaryDate	DATE,

	@p_EndUserID INT,
	@p_UserRoleID INT,
	@p_ScreenID SMALLINT,
	@p_AccessPoint VARCHAR(25)
)
----WITH ENCRYPTION
AS
BEGIN
	Select @p_ScreenID = ScreenID FROM Screen WHERE ScreenName = 'Invoice Customer'
	
	--== Audit Log Start================================================================================================================
	DECLARE @AuditLogID		BIGINT,
			@IsDetailAudit	BIT,
			@ObjectID		VARCHAR(50),			-- PK/UK column(s separated by |)
			@PreImage		XML

	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_CustomerID)
	EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'U', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

	IF(@IsDetailAudit = 1)
	BEGIN
		SET @PreImage = (	SELECT	CustomerName,CustomerAddress,ContactNumber,DOB,AnniversaryDate
							FROM	eCustomer
							WHERE	CustomerID	= @p_CustomerID
							FOR XML AUTO
						);

		IF(@PreImage IS NOT NULL)
			INSERT INTO  AuditPreImage
						(    AuditLogID, TableName, PreImage    )
					VALUES
						(    @AuditLogID, 'eCustomer', @PreImage     )

	END
	--== Audit Log End================================================================================================================

	UPDATE	eCustomer
	 SET	CustomerName	= @p_CustomerName,
			CustomerAddress	= @p_CustomerAddress,
			ContactNumber	= @p_ContactNumber,
			DOB				= @p_DOB,
			AnniversaryDate	= @p_AnniversaryDate
	WHERE	CustomerID		= @p_CustomerID

	IF (@@ROWCOUNT = 0)
	BEGIN
		RAISERROR('No Record found for e Customer',16,1)
		RETURN -1;
	END

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'DeleteeCustomer') AND TYPE IN (N'P'))
DROP PROCEDURE DeleteeCustomer
GO

CREATE PROCEDURE DeleteeCustomer
(
	@p_CustomerID	CustomerID	/*SMALLINT*/,

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

	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_CustomerID)
	EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'D', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

	IF(@IsDetailAudit = 1)
	BEGIN
		SET @PreImage = (	SELECT	CustomerName,CustomerAddress,ContactNumber,DOB,AnniversaryDate
							FROM	eCustomer
							WHERE	CustomerID	= @p_CustomerID
							FOR XML AUTO
						);

		IF(@PreImage IS NOT NULL)
			INSERT INTO  AuditPreImage
						(    AuditLogID, TableName, PreImage    )
					VALUES
						(    @AuditLogID, 'eCustomer', @PreImage     )

	END
	--== Audit Log End================================================================================================================

	DELETE
	FROM	eCustomer
	WHERE	CustomerID	= @p_CustomerID

	IF (@@ROWCOUNT = 0)
	BEGIN
		RAISERROR('No Record found for e Customer',16,1)
		RETURN -1;
	END

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GeteCustomer') AND TYPE IN (N'P'))
DROP PROCEDURE GeteCustomer
GO

CREATE PROCEDURE GeteCustomer
(
	@p_CustomerID		CustomerID		= null/*SMALLINT*/,
	@p_CustomerName		GenericName		= null	/*NVARCHAR(50)*/,
	@p_CustomerAddress	ShortRemarks	= null	/*NVARCHAR(100)*/,
	@p_ContactNumber	GenericName		= null	/*NVARCHAR(50)*/,
	@p_DOB				DATE			= null,
	@p_AnniversaryDate	DATE			= null,

	@p_EndUserID INT					= null,
	@p_UserRoleID INT					= null,
	@p_ScreenID SMALLINT				= null,
	@p_AccessPoint VARCHAR(25)			= null
)
----WITH ENCRYPTION
AS
BEGIN
	SELECT	CustomerID,
			CustomerName,
			CustomerAddress,
			ContactNumber,
			DOB,
			AnniversaryDate,
			(CustomerName + COALESCE(' | ' + ContactNumber ,'') + COALESCE(' | ' + REPLACE(CONVERT(NVARCHAR,DOB, 106), ' ', '-'),'')) as GlobalID 
	FROM	eCustomer
	WHERE	(	CustomerID	=	@p_CustomerID
			OR	@p_CustomerID	IS NULL
			)
	AND		CustomerName LIKE  N'%' + COALESCE(@p_CustomerName, N'') +  N'%'
	AND		(	CustomerAddress LIKE  N'%' + COALESCE(@p_CustomerAddress, N'') +  N'%'
			OR	@p_CustomerAddress	IS NULL
			)
	AND		(	ContactNumber LIKE  N'%' + COALESCE(@p_ContactNumber, N'') +  N'%'
			OR	@p_ContactNumber	IS NULL
			)
	AND		(	DOB	=	@p_DOB
			OR	@p_DOB	IS NULL
			)
	AND		(	AnniversaryDate	=	@p_AnniversaryDate
			OR	@p_AnniversaryDate	IS NULL
			)

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GeteCustomerDDL') AND TYPE IN (N'P'))
DROP PROCEDURE GeteCustomerDDL
GO

CREATE PROCEDURE GeteCustomerDDL
(
	@p_Search	GenericName
)
----WITH ENCRYPTION
AS
BEGIN
	
	SELECT	CustomerID,
			(CustomerName + COALESCE(' | ' + ContactNumber ,'') + COALESCE(' | ' + REPLACE(CONVERT(NVARCHAR,DOB, 106), ' ', '-'),'')) as CustomerName
			
	FROM	eCustomer
	WHERE	CustomerName  LIKE  N'%' + COALESCE(@p_Search, N'') +  N'%'
	OR		ContactNumber LIKE  N'%' + COALESCE(@p_Search, N'') +  N'%'
	OR		REPLACE(CONVERT(NVARCHAR,DOB, 106), ' ', '-') LIKE  N'%' + COALESCE(@p_Search, N'') +  N'%'
	OR		(CustomerName + COALESCE(' | ' + ContactNumber ,'') + COALESCE(' | ' + REPLACE(CONVERT(NVARCHAR,DOB, 106), ' ', '-'),'')) LIKE  N'%' + COALESCE(@p_Search, N'') +  N'%'
	ORDER BY eCustomer.CustomerName
	
END
GO

-- ED1C85AEA4F071948EC5C8D7A134CD