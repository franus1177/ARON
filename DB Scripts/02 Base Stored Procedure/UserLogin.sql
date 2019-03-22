
----UPDATE	EndUser
----SET		UserIdentity = HASHBYTES ('MD5', N'admin123')

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'UserLogin') AND TYPE IN (N'P'))
DROP PROCEDURE UserLogin
GO
-- UserLogin 'InventoryAdmin',N'demo123',''
CREATE PROCEDURE UserLogin
(
	@p_LoginID			NVARCHAR(50),
	@p_UserIdentity		NVARCHAR(16),--must be NVARCHAR
	@p_LastAccessPoint	VARCHAR(25)
)
----WITH ENCRYPTION
AS
	if(@p_LastAccessPoint is null) set @p_LastAccessPoint = '0.0.0.0';
	DECLARE	@EndUserID			INTEGER;
	DECLARE	@UserRoleID			SMALLINT;
	DECLARE	@UserName			NVARCHAR(50);
	DECLARE	@LanguageCode		LanguageCode;
	DECLARE	@UTCOffset			DECIMAL(4,2);
	DECLARE	@DefaultModuleCode	CHAR(2);
	DECLARE @IsSingleInstance	BIT = 0;
	DECLARE @IsCustomerUser		BIT = 0;
	DECLARE @CustomerID			SMALLINT = NULL;
	DECLARE @CustomerName		NVARCHAR(50) = NULL;
	DECLARE @date				DATETIME = GETUTCDATE();

BEGIN
	SELECT			@EndUserID			=	E.EndUserID,
					@UserName			=	E.LoginID,
					@LanguageCode		=	E.LanguageCode,
					@UTCOffset			=	E.UTCOffset,
					@DefaultModuleCode	=	E.DefaultModuleCode,
					@IsCustomerUser     =   0--(CASE WHEN CC.UserID IS NOT NULL THEN 1 ELSE 0 END)
	
	FROM		EndUser E
	--LEFT JOIN	CustomerContact CC
	--				ON	E.EndUserID =	CC.UserID
	WHERE		LoginID				=	@p_LoginID
	AND			E.UserIdentity		=	HASHBYTES ('MD5', @p_UserIdentity)
	
	IF (@@ROWCOUNT > 0)
	BEGIN
		SELECT TOP 1									--	currently just returning single user role ID
				@UserRoleID	=	UserRoleID
		FROM	UserRoleUser
		WHERE	EndUserID = @EndUserID;

		SELECT	@EndUserID			AS		EndUserID,
				UserRoleID,
				@UserName			AS		UserName,
				@LanguageCode		AS		LanguageCode,
				@UTCOffset			AS		UTCOffset,
				@DefaultModuleCode	AS		DefaultModuleCode,
				@IsCustomerUser		AS		IsCustomerUser
		FROM	UserRoleUser
		WHERE	EndUserID = @EndUserID;

		UPDATE	EndUser 
		SET		LastAccessPoint	=	@p_LastAccessPoint,
				LastLoginDTM	=	GETUTCDATE()
		WHERE	EndUserID = @EndUserID;

		EXEC	GetMenuAndScreenData @UserRoleID;

		SELECT	 EndUserModule.ModuleCode,m.SequenceNo
		FROM	 EndUserModule
		JOIN	dbo.__GetConfigurationModule(@LanguageCode) as m
					ON	EndUserModule.ModuleCode	=	m.ModuleCode
		WHERE	 EndUserID	= @EndUserID
		ORDER BY m.SequenceNo;

		--IF( @IsCustomerUser = 1 )
		--BEGIN
		--	SET @IsSingleInstance = 1;

		--	SELECT	@CustomerID		=	c.CustomerID,
		--			@CustomerName	=	c.CustomerName
		--	FROM	Customer c
		--	JOIN	CustomerContact cc
		--				ON	c.CustomerID	= cc.CustomerID
		--	WHERE	cc.UserID				= @EndUserID;
			
		--END
		--ELSE IF((SELECT COUNT(*) FROM CUSTOMER) = 1)
		--BEGIN
		--	SET @IsSingleInstance = 1;

		--	SELECT	@CustomerID		=	CustomerID,
		--			@CustomerName	=	CustomerName
		--	FROM	Customer;
		--END
		--ELSE
		--BEGIN
		--	DECLARE	@CustomerList TABLE (CustomerID CustomerID NOT NULL, Customername LongName );
		--	INSERT INTO @CustomerList(CustomerID,Customername) EXEC GetUserCustomer NULL, NULL, null, @date, @LanguageCode, NULL, @EndUserID, @UserRoleID, 1, @p_LastAccessPoint
			
		--	IF(@@ROWCOUNT = 1)
		--	BEGIN
		--		SELECT	@CustomerID		=	Customer.CustomerID,
		--				@CustomerName	=	Customer.CustomerName
		--		FROM	Customer
		--		JOIN	@CustomerList CT
		--					ON	Customer.CustomerID	=	CT.CustomerID;
		--		SET @IsSingleInstance = 1;
		--	END
		--END

		SELECT @IsSingleInstance as IsSingleUserCustomer,@IsSingleInstance as IsSingleInstance,@CustomerID as CustomerID,@CustomerName as CustomerName;

	END
	ELSE
	BEGIN
		RAISERROR('Invalid username and/or password.',16,1);
	END

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'ChangePassword') AND TYPE IN (N'P'))
DROP PROCEDURE ChangePassword
GO

CREATE PROCEDURE ChangePassword
(
	@p_EndUserID			INTEGER,
	@p_OldPassword			NVARCHAR(16),
	@p_NewPassword			NVARCHAR(16)
)
----WITH ENCRYPTION
AS
BEGIN
	IF  EXISTS (SELECT TOP 1 1 FROM EndUser WHERE EndUserID	= @p_EndUserID AND UserIdentity	= HASHBYTES ('MD5', @p_OldPassword))
	BEGIN
		UPDATE	EndUser 
		SET		UserIdentity	=	HASHBYTES ('MD5', @p_NewPassword)
		WHERE	EndUserID		=	@p_EndUserID;
	END
	ELSE
		RAISERROR('Invalid password.',16,1);

END
GO


IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'ResetPassword') AND TYPE IN (N'P'))
DROP PROCEDURE ResetPassword
GO

CREATE PROCEDURE ResetPassword
(
	@p_EndUserID			INTEGER,
	@p_NewPassword			NVARCHAR(16),
	@p_LoginID				NVARCHAR(50)
)
----WITH ENCRYPTION
AS
BEGIN
	IF  EXISTS (SELECT TOP 1 1 FROM EndUser WHERE EndUserID	= @p_EndUserID AND LoginID = @p_LoginID)
	BEGIN
	
		UPDATE	EndUser 
		SET		UserIdentity	=	HASHBYTES ('MD5', @p_NewPassword)
		WHERE	EndUserID		=	@p_EndUserID
		AND		LoginID			=	@p_LoginID;
		
		IF (@@ROWCOUNT > 0)
		BEGIN
			UPDATE	PublishedURL
			SET		URLExpiryDTM	=	GETUTCDATE()
			WHERE	URLID			=	( SELECT  ResetPasswordURLID FROM	EndUser WHERE  EndUserID = @p_EndUserID AND LoginID = @p_LoginID)
		END
		
		SELECT EndUserID FROM EndUser WHERE EndUserID	= @p_EndUserID
	END
	ELSE
		RAISERROR('Invalid email and/or link.',16,1);

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'CheckForgotPasswordURL') AND TYPE IN (N'P'))
DROP PROCEDURE CheckForgotPasswordURL
GO

CREATE PROCEDURE CheckForgotPasswordURL
(
	@p_EndUserID			INTEGER
)
----WITH ENCRYPTION
AS
BEGIN
		
		SELECT		URLID 
		FROM		PublishedURL 
		WHERE		URLID	 =	( SELECT top 1  ResetPasswordURLID FROM	EndUser WHERE  EndUserID = @p_EndUserID)
		AND			URLExpiryDTM  >= GETUTCDATE()
	
END
GO