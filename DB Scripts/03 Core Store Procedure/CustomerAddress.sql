
IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'AddCustomerAddress') AND TYPE IN (N'P'))
DROP PROCEDURE AddCustomerAddress
GO

CREATE PROCEDURE AddCustomerAddress
(
	@p_CustomerID		CustomerID	/*SMALLINT*/,
	@p_AddressType		ShortName	/*NVARCHAR(25)*/,
	@p_AddressLine1		AddressLine	/*NVARCHAR(100)*/,
	@p_AddressLine2		AddressLine	/*NVARCHAR(100)*/,
	@p_CityName			ShortName	/*NVARCHAR(25)*/,
	@p_StateName		ShortName	/*NVARCHAR(25)*/,
	@p_CountryName		ShortName	/*NVARCHAR(25)*/,
	@p_Pincode			NVARCHAR(10),
	@p_IsPrimaryAddress	BIT,

	@p_LanguageCode		CHAR(2),
	@p_UTCOffset		NUMERIC(4,2),
	@p_EndUserID		INT,
	@p_UserRoleID		INT,
	@p_ScreenID			SMALLINT,
	@p_AccessPoint		VARCHAR(25)
)
----WITH ENCRYPTION
AS
BEGIN

	INSERT INTO CustomerAddress
			(	CustomerID,AddressType,AddressLine1,AddressLine2,CityName,StateName,CountryName,Pincode,IsPrimaryAddress	)
		VALUES
			(	@p_CustomerID,@p_AddressType,@p_AddressLine1,@p_AddressLine2,@p_CityName,@p_StateName,@p_CountryName,@p_Pincode,@p_IsPrimaryAddress	);

	IF (@@ROWCOUNT > 0)
	BEGIN
		--==Audit Log====================================================================================================================
		DECLARE
				@AuditLogID		BIGINT,
				@IsDetailAudit	BIT,
				@ObjectID		VARCHAR(50)			-- PK/UK column(s separated by |)

		SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_CustomerID)+'|'+CONVERT(VARCHAR(MAX),@p_AddressType)
		EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'I', @p_AccessPoint , @AuditLogID OUT, @IsDetailAudit OUT;

	END
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'UpdateCustomerAddress') AND TYPE IN (N'P'))
DROP PROCEDURE UpdateCustomerAddress
GO

CREATE PROCEDURE UpdateCustomerAddress
(
	@p_CustomerID		CustomerID	/*SMALLINT*/,
	@p_AddressType		ShortName	/*NVARCHAR(25)*/,
	@p_AddressTypeOld	ShortName	/*NVARCHAR(25)*/,
	@p_AddressLine1		AddressLine	/*NVARCHAR(100)*/,
	@p_AddressLine2		AddressLine	/*NVARCHAR(100)*/,
	@p_CityName			ShortName	/*NVARCHAR(25)*/,
	@p_StateName		ShortName	/*NVARCHAR(25)*/,
	@p_CountryName		ShortName	/*NVARCHAR(25)*/,
	@p_Pincode			NVARCHAR(10),
	@p_IsPrimaryAddress	BIT,

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
	IF EXISTS (SELECT 1 FROM CustomerAddress WHERE CustomerID = @p_CustomerID AND AddressType	= @p_AddressTypeOld)
	BEGIN
		--== Audit Log Start================================================================================================================
		DECLARE
				@AuditLogID		BIGINT,
				@IsDetailAudit	BIT,
				@ObjectID		VARCHAR(50),			-- PK/UK column(s separated by |)
				@PreImage		XML

		SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_CustomerID)+'|'+CONVERT(VARCHAR(MAX),@p_AddressTypeOld)
		EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'U', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

		IF(@IsDetailAudit = 1)
		BEGIN
			SET @PreImage = (	SELECT	AddressType,AddressLine1,AddressLine2,CityName,StateName,CountryName,Pincode,IsPrimaryAddress
								FROM	CustomerAddress
								WHERE	CustomerID	= @p_CustomerID
								AND		AddressType	= @p_AddressTypeOld
								FOR XML AUTO
							);

			IF(@PreImage IS NOT NULL)
				INSERT INTO  AuditPreImage
							(    AuditLogID, PreImage    )
						VALUES
							(    @AuditLogID, @PreImage     )

		END
		--== Audit Log End================================================================================================================

		UPDATE	CustomerAddress
		 SET	AddressType			= @p_AddressType,
				AddressLine1		= @p_AddressLine1,
				AddressLine2		= @p_AddressLine2,
				CityName			= @p_CityName,
				StateName			= @p_StateName,
				CountryName			= @p_CountryName,
				Pincode				= @p_Pincode,
				IsPrimaryAddress	= @p_IsPrimaryAddress

		WHERE	CustomerID			= @p_CustomerID
		AND		AddressType			= @p_AddressTypeOld

		IF (@@ROWCOUNT = 0)
		BEGIN
			RAISERROR('No Record found for Customer Address',16,1)
			RETURN -1;
		END
	END
	ELSE
	BEGIN

		EXEC AddCustomerAddress @p_CustomerID		= @p_CustomerID,
								@p_AddressType		= @p_AddressType,
								@p_AddressLine1		= @p_AddressLine1,
								@p_AddressLine2		= @p_AddressLine2,
								@p_CityName			= @p_CityName,
								@p_StateName		= @p_StateName,
								@p_CountryName		= @p_CountryName,
								@p_Pincode			= @p_Pincode,
								@p_IsPrimaryAddress	= @p_IsPrimaryAddress,
								@p_LanguageCode		= @p_LanguageCode,
								@p_UTCOffset		= @p_UTCOffset,
								@p_EndUserID		= @p_EndUserID,
								@p_UserRoleID		= @p_UserRoleID,
								@p_ScreenID			= @p_ScreenID,
								@p_AccessPoint		= @p_AccessPoint
	END
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'DeleteCustomerAddress') AND TYPE IN (N'P'))
DROP PROCEDURE DeleteCustomerAddress
GO

CREATE PROCEDURE DeleteCustomerAddress
(
	@p_CustomerID	CustomerID	/*SMALLINT*/,
	@p_AddressType	ShortName	/*NVARCHAR(25)*/,

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

	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_CustomerID)+'|'+CONVERT(VARCHAR(MAX),@p_AddressType)
	EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'D', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

	IF(@IsDetailAudit = 1)
	BEGIN
		SET @PreImage = (	SELECT	AddressType,AddressLine1,AddressLine2,CityName,StateName,CountryName,Pincode,IsPrimaryAddress
							FROM	CustomerAddress
							WHERE	CustomerID	= @p_CustomerID
							AND		AddressType	= @p_AddressType
							FOR XML AUTO
						);

		IF(@PreImage IS NOT NULL)
			INSERT INTO  AuditPreImage
						(    AuditLogID, PreImage    )
					VALUES
						(    @AuditLogID, @PreImage     )

	END
	--== Audit Log End================================================================================================================

	DELETE
	FROM	CustomerAddress
	WHERE	CustomerID	= @p_CustomerID
	AND		AddressType	= @p_AddressType

	IF (@@ROWCOUNT = 0)
	BEGIN
		RAISERROR('No Record found for Customer Address',16,1)
		RETURN -1;
	END

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetCustomerAddress') AND TYPE IN (N'P'))
DROP PROCEDURE GetCustomerAddress
GO

CREATE PROCEDURE GetCustomerAddress
(
	@p_CustomerID	CustomerID	/*SMALLINT*/,
	@p_AddressType	ShortName	/*NVARCHAR(25)*/,
	@p_AddressLine1	AddressLine	/*NVARCHAR(100)*/,
	@p_AddressLine2	AddressLine	/*NVARCHAR(100)*/,
	@p_CityName	ShortName	/*NVARCHAR(25)*/,
	@p_StateName	ShortName	/*NVARCHAR(25)*/,
	@p_CountryName	ShortName	/*NVARCHAR(25)*/,
	@p_Pincode	NVARCHAR(10),
	@p_IsPrimaryAddress	BIT,

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
	SELECT	CustomerID,
			AddressType,
			AddressLine1,
			AddressLine2,
			CityName,
			StateName,
			CountryName,
			Pincode,
			IsPrimaryAddress
	FROM	CustomerAddress
	WHERE	(	CustomerID	=	@p_CustomerID
			OR	@p_CustomerID	IS NULL
			)
	AND		AddressType LIKE  N'%' + COALESCE(@p_AddressType, N'') +  N'%'
	AND		AddressLine1 LIKE  N'%' + COALESCE(@p_AddressLine1, N'') +  N'%'
	AND		(	AddressLine2 LIKE  N'%' + COALESCE(@p_AddressLine2, N'') +  N'%'
			OR	@p_AddressLine2	IS NULL
			)
	AND		CityName LIKE  N'%' + COALESCE(@p_CityName, N'') +  N'%'
	AND		(	StateName LIKE  N'%' + COALESCE(@p_StateName, N'') +  N'%'
			OR	@p_StateName	IS NULL
			)
	AND		CountryName LIKE  N'%' + COALESCE(@p_CountryName, N'') +  N'%'
	AND		(	Pincode LIKE  N'%' + COALESCE(@p_Pincode, N'') +  N'%'
			OR	@p_Pincode	IS NULL
			)
	AND		(	IsPrimaryAddress	=	@p_IsPrimaryAddress
			OR	@p_IsPrimaryAddress	IS NULL
			)

END
GO

-- CFCA4737B157EB22FC7BFFA304F752