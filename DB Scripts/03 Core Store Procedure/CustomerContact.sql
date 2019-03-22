	
--IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'AddCustomerContact') AND TYPE IN (N'P'))
--DROP PROCEDURE AddCustomerContact
--GO
-- --Is used in update procedure as given in below.
--CREATE PROCEDURE AddCustomerContact
--(
--	@p_CustomerID					CustomerID	/*SMALLINT*/,
--	@p_ContactName					GenericName	/*NVARCHAR(50)*/,
--	@p_Email						Email		/*VARCHAR(100)*/,
--	@p_Telephone					Telephone = NULL	/*VARCHAR(50)*/,
--	@p_Mobile						Mobile = NULL		/*VARCHAR(50)*/,
--	@p_IsPrimaryContact				BIT,
	
--	@p_UserID						INT,-- Customer Contact Person has web portal access

--	@p_LanguageCode					CHAR(2),
--	@p_UTCOffset					NUMERIC(4,2),
--	@p_EndUserID					INT,
--	@p_UserRoleID					INT,
--	@p_ScreenID						SMALLINT = NULL,
--	@p_AccessPoint					VARCHAR(25) = NULL
--)
------WITH ENCRYPTION
--AS
--BEGIN

--	INSERT INTO CustomerContact
--			(	CustomerID,ContactName,Email,Telephone,Mobile,IsPrimaryContact,UserID	)
--		VALUES
--			(	@p_CustomerID,@p_ContactName,@p_Email,@p_Telephone,@p_Mobile,@p_IsPrimaryContact,@p_UserID	);

--	IF (@@ROWCOUNT > 0)
--	BEGIN
--		--==Audit Log====================================================================================================================
--		DECLARE
--				@AuditLogID		BIGINT,
--				@IsDetailAudit	BIT,
--				@ObjectID		VARCHAR(50)			-- PK/UK column(s separated by |)

--		SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_CustomerID)+'|'+CONVERT(VARCHAR(MAX),@p_ContactName)
--		EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'I', @p_AccessPoint , @AuditLogID OUT, @IsDetailAudit OUT;

--	END
--END
--GO

--IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'UpdateCustomerContact') AND TYPE IN (N'P'))
--DROP PROCEDURE UpdateCustomerContact
--GO

--CREATE PROCEDURE UpdateCustomerContact
--(
--	@p_CustomerID					CustomerID	/*SMALLINT*/,
--	@p_ContactName					GenericName	/*NVARCHAR(50)*/,
--	@p_ContactNameOld				GenericName	/*NVARCHAR(50)*/,
--	@p_Email						Email	/*VARCHAR(100)*/,
--	@p_Telephone					Telephone	/*VARCHAR(50)*/,
--	@p_Mobile						Mobile	/*VARCHAR(50)*/,
--	@p_IsPrimaryContact				BIT,
	
--	@p_IsWebAccess					BIT,-- Customer Contact Person has web portal access
--	@p_UserID						INT,
	
--	@p_CustomerContactLanguageCode	LanguageCode	/*CHAR(2)*/,
	
--	@p_CustomerContactUTCOffset		NUMERIC(4,2),
--	@p_DefaultModuleCode			CHAR(2),
--	@p_Gender						VARCHAR(10),
--	@p_UserIdentity					NVARCHAR(16),
--	@p_EndUserModule				EndUserModule_TableType	 READONLY,
--	@p_UserRoleUser					UserRoleUser_TableType	 READONLY,

--	@p_LanguageCode CHAR(2),
--	@p_UTCOffset NUMERIC(4,2),
--	@p_EndUserID INT,
--	@p_UserRoleID INT,
--	@p_ScreenID SMALLINT,
--	@p_AccessPoint VARCHAR(25)
--)
------WITH ENCRYPTION
--AS
--BEGIN
--	DECLARE @p_EndUserID2	INT;
	
--	IF(@p_UserID IS NULL AND @p_Email IS NOT NULL)
--		SET @p_UserID	=	(SELECT TOP 1 EndUserID FROM Enduser WHERE LoginID	=	@p_Email);
--	ELSE
--		SET @p_EndUserID2	=	@p_UserID;
	
--	IF (@p_UserID IS NULL AND @p_IsWebAccess	=  1)
--	BEGIN
--		EXEC AddEndUser 	@p_LoginID				=	@p_Email,
--							@p_FirstName			=	@p_ContactName,
--							@p_MiddleName			=	NULL,
--							@p_LastName				=	'Admin',
--							@p_LanguageCode			=	@p_CustomerContactLanguageCode,
--							@p_UTCOffset			=	@p_CustomerContactUTCOffset,
--							@p_DefaultModuleCode	=	@p_DefaultModuleCode,
--							@p_Gender				=   @p_Gender,
--							@p_EmailID				=	@p_Email,
--							@p_UserIdentity			=	@p_UserIdentity,
--							@p_ActivatedDTM			=	NULL,
--							@p_LastAccessPoint		=	NULL,
--							@p_LastLoginDTM			=	NULL,
--							@p_SecretQuestion		=	NULL,
--							@p_SecretAnswer			=	NULL,
--							@p_ActivationURLID		=	NULL,
--							@p_ResetPasswordURLID	=	NULL,
--							@p_EndUserModule		=	@p_EndUserModule,
--							@p_UserRoleUser			=	@p_UserRoleUser,
								
--							@p_CurrentLanguageCode	=	@p_LanguageCode,
--							@p_CurrentUTCOffset		=	@p_UTCOffset,
--							@p_CurrentEndUserID		=	@p_EndUserID,
--							@p_CurrentUserRoleID	=	@p_UserRoleID,
--							@p_CurrentScreenID		=	@p_ScreenID,
--							@p_CurrentAccessPoint	=	@p_AccessPoint,
--							@p_EndUserID			=	@p_EndUserID2	OUTPUT

--		SET	@p_UserID	=	@p_EndUserID2;
--	END
--	ELSE IF(@p_UserID IS NOT NULL AND @p_IsWebAccess	=  1)
--	BEGIN
--		EXEC UpdateEndUser	@p_EndUserID			=	@p_UserID,
--							@p_LoginID				=	@p_Email,
--							@p_FirstName			=	@p_ContactName,
--							@p_MiddleName			=	NULL,
--							@p_LastName				=	'Admin',
--							@p_LanguageCode			=	@p_CustomerContactLanguageCode,
--							@p_UTCOffset			=	@p_CustomerContactUTCOffset,
--							@p_DefaultModuleCode	=	@p_DefaultModuleCode,
--							@p_Gender				=	@p_Gender,
--							@p_EmailID				=	@p_Email,
--							@p_UserIdentity			=	@p_UserIdentity,
							
--							@p_ActivatedDTM			=	NULL,
--							@p_LastAccessPoint		=	NULL,
--							@p_LastLoginDTM			=	NULL,
--							@p_SecretQuestion		=	NULL,
--							@p_SecretAnswer			=	NULL,
--							@p_ActivationURLID		=	NULL,
--							@p_ResetPasswordURLID	=	NULL,

--							@p_EndUserModule		=	@p_EndUserModule,
--							@p_UserRoleUser			=	@p_UserRoleUser,

--							@p_CurrentLanguageCode	=	@p_LanguageCode,
--							@p_CurrentUTCOffset		=	@p_UTCOffset,
--							@p_CurrentEndUserID		=	@p_EndUserID,
--							@p_CurrentUserRoleID	=	@p_UserRoleID,
--							@p_CurrentScreenID		=	@p_ScreenID,
--							@p_CurrentAccessPoint	=	@p_AccessPoint
		
--		SET @p_EndUserID2 = @p_UserID;
 
--	END
--	ELSE IF(@p_IsWebAccess	=  0)
--	BEGIN 
--		SET @p_EndUserID2 = NULL;
--	END

--	IF EXISTS (SELECT 1 FROM CustomerContact WHERE CustomerID = @p_CustomerID AND ContactName	= @p_ContactNameOld)
--	BEGIN
--		--== Audit Log Start================================================================================================================
--		DECLARE
--				@AuditLogID		BIGINT,
--				@IsDetailAudit	BIT,
--				@ObjectID		VARCHAR(50),			-- PK/UK column(s separated by |)
--				@PreImage		XML

--		SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_CustomerID)+'|'+CONVERT(VARCHAR(MAX),@p_ContactNameOld)
--		EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'U', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

--		IF(@IsDetailAudit = 1)
--		BEGIN
--			SET @PreImage = (	SELECT	ContactName,Email,Telephone,Mobile,IsPrimaryContact
--								FROM	CustomerContact
--								WHERE	CustomerID	= @p_CustomerID
--								AND		ContactName	= @p_ContactNameOld
--								FOR XML AUTO
--							);

--			IF(@PreImage IS NOT NULL)
--				INSERT INTO  AuditPreImage
--							(    AuditLogID, PreImage    )
--						VALUES
--							(    @AuditLogID, @PreImage     )

--		END
--		--== Audit Log End================================================================================================================

--		UPDATE	CustomerContact
--		 SET	Email				= @p_Email,
--				ContactName			= @p_ContactName,
--				Telephone			= @p_Telephone,
--				Mobile				= @p_Mobile,
--				IsPrimaryContact	= @p_IsPrimaryContact,
--				UserID				= @p_EndUserID2
--		WHERE	CustomerID			= @p_CustomerID
--		AND		ContactName			= @p_ContactNameOld

--		IF (@@ROWCOUNT = 0)
--		BEGIN
--			RAISERROR('No Record found for Customer Contact',16,1)
--			RETURN -1;
--		END
--	END
--	ELSE
--	BEGIN
--		EXEC AddCustomerContact @p_CustomerID		= @p_CustomerID,
--								@p_ContactName		= @p_ContactName,
--								@p_Email			= @p_Email,
--								@p_Telephone		= @p_Telephone,
--								@p_Mobile			= @p_Mobile,
--								@p_IsPrimaryContact	= @p_IsPrimaryContact,
--								@p_UserID			= @p_EndUserID2,
									
--								@p_LanguageCode		= @p_LanguageCode,
--								@p_UTCOffset		= @p_UTCOffset,
--								@p_EndUserID		= @p_EndUserID,
--								@p_UserRoleID		= @p_UserRoleID,
--								@p_ScreenID			= @p_ScreenID,
--								@p_AccessPoint		= @p_AccessPoint
--	END

--END
--GO

--IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'DeleteCustomerContact') AND TYPE IN (N'P'))
--DROP PROCEDURE DeleteCustomerContact
--GO

--CREATE PROCEDURE DeleteCustomerContact
--(
--	@p_CustomerID	CustomerID	/*SMALLINT*/,
--	@p_ContactName	GenericName	/*NVARCHAR(50)*/,

--	@p_LanguageCode CHAR(2),
--	@p_UTCOffset NUMERIC(4,2),
--	@p_EndUserID INT,
--	@p_UserRoleID INT,
--	@p_ScreenID SMALLINT,
--	@p_AccessPoint VARCHAR(25)
--)
------WITH ENCRYPTION
--AS
--BEGIN
--	--== Audit Log Start================================================================================================================
--	DECLARE
--			@AuditLogID		BIGINT,
--			@IsDetailAudit	BIT,
--			@ObjectID		VARCHAR(50),			-- PK/UK column(s separated by |)
--			@PreImage		XML

--	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_CustomerID)+'|'+CONVERT(VARCHAR(MAX),@p_ContactName)
--	EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'D', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

--	IF(@IsDetailAudit = 1)
--	BEGIN
--		SET @PreImage = (	SELECT	ContactName,Email,Telephone,Mobile,IsPrimaryContact,UserID
--							FROM	CustomerContact
--							WHERE	CustomerID	= @p_CustomerID
--							AND		ContactName	= @p_ContactName
--							FOR XML AUTO
--						);

--		IF(@PreImage IS NOT NULL)
--			INSERT INTO  AuditPreImage
--						(    AuditLogID, PreImage    )
--					VALUES
--						(    @AuditLogID, @PreImage     )

--	END
--	--== Audit Log End================================================================================================================
--	DECLARE @UserID INT = (SELECT	UserID FROM	CustomerContact WHERE	CustomerID	= @p_CustomerID AND	ContactName	= @p_ContactName)
	
--	DELETE
--	FROM	CustomerContact
--	WHERE	CustomerID	= @p_CustomerID
--	AND		ContactName	= @p_ContactName

--	IF (@@ROWCOUNT = 0)
--	BEGIN
--		RAISERROR('No Record found for Customer Contact',16,1)
--		RETURN -1;
--	END

--	IF(@UserID IS NOT NULL)
--	EXEC	DeleteEndUser	@p_EndUserID			= @UserID,
--							@p_CurrentLanguageCode	= @p_LanguageCode,
--							@p_CurrentUTCOffset		= @p_UTCOffset,
--							@p_CurrentEndUserID		= @p_EndUserID,
--							@p_CurrentUserRoleID	= @p_UserRoleID,
--							@p_CurrentScreenID		= @p_ScreenID,
--							@p_CurrentAccessPoint	= @p_AccessPoint
	
--END
--GO

--IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetCustomerContact') AND TYPE IN (N'P'))
--DROP PROCEDURE GetCustomerContact
--GO

--CREATE PROCEDURE GetCustomerContact
--(
--	@p_CustomerID		CustomerID	/*SMALLINT*/,
--	@p_ContactName		GenericName	/*NVARCHAR(50)*/,
--	@p_Email			Email	/*VARCHAR(100)*/,
--	@p_Telephone		Telephone	/*VARCHAR(50)*/,
--	@p_Mobile			Mobile	/*VARCHAR(50)*/,
--	@p_IsPrimaryContact	BIT,
	
--	@p_LanguageCode CHAR(2),
--	@p_UTCOffset NUMERIC(4,2),
--	@p_EndUserID INT,
--	@p_UserRoleID INT,
--	@p_ScreenID SMALLINT,
--	@p_AccessPoint VARCHAR(25)
--)
------WITH ENCRYPTION
--AS
--BEGIN
--	SELECT	cc.CustomerID,
--			cc.ContactName,
--			cc.Email,
--			cc.Telephone,
--			cc.Mobile,
--			cc.IsPrimaryContact,
--			cc.UserID
--	FROM		CustomerContact cc
--	WHERE	(	cc.CustomerID	=	@p_CustomerID
--			OR	@p_CustomerID	IS NULL
--			)
--	AND		ContactName LIKE  N'%' + COALESCE(@p_ContactName, N'') +  N'%'
--	AND		(	cc.Email LIKE  '%' + COALESCE(@p_Email, '') +  '%'
--			OR	@p_Email	IS NULL
--			)
--	AND		(	cc.Telephone LIKE  '%' + COALESCE(@p_Telephone, '') +  '%'
--			OR	@p_Telephone	IS NULL
--			)
--	AND		(	cc.Mobile LIKE  '%' + COALESCE(@p_Mobile, '') +  '%'
--			OR	@p_Mobile	IS NULL
--			)
--	AND		(	cc.IsPrimaryContact	=	@p_IsPrimaryContact
--			OR	@p_IsPrimaryContact	IS NULL
--			)
--END
--GO

---- B6B1744309AA4BF2CBCFF91F11E8FD