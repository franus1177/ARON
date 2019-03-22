IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'AddEndUser') AND TYPE IN (N'P'))
DROP PROCEDURE AddEndUser
GO
CREATE PROCEDURE AddEndUser
(
	@p_LoginID				NVARCHAR(50),
	@p_FirstName			NVARCHAR(30),
	@p_MiddleName			NVARCHAR(30),
	@p_LastName				NVARCHAR(30),
	@p_LanguageCode			LanguageCode	/*CHAR(2)*/,
	@p_UTCOffset			NUMERIC(4,2),
	@p_DefaultModuleCode	CHAR(2),
	@p_Gender				VARCHAR(10),
	@p_EmailID				NVARCHAR(50),
	@p_UserIdentity			NVARCHAR(16),
	@p_ActivatedDTM			DATETIME,
	@p_LastAccessPoint		VARCHAR(25),
	@p_LastLoginDTM			DATETIME,
	@p_SecretQuestion		NVARCHAR(100),
	@p_SecretAnswer			NVARCHAR(100),
	@p_ActivationURLID		INT,
	@p_ResetPasswordURLID	INT,
	@p_DesignationID		DesignationID	/*SMALLINT*/,
	@p_DepartmentID			DepartmentID	/*SMALLINT*/,

	@p_EndUserModule		EndUserModule_TableType	 READONLY,
	@p_UserRoleUser			UserRoleUser_TableType	 READONLY,

	@p_CurrentLanguageCode CHAR(2),
	@p_CurrentUTCOffset NUMERIC(4,2),
	@p_CurrentEndUserID INT,
	@p_CurrentUserRoleID INT,
	@p_CurrentScreenID SMALLINT,
	@p_CurrentAccessPoint VARCHAR(25),
	@p_EndUserID	INT OUTPUT
)
----WITH ENCRYPTION
AS
BEGIN
 
	INSERT INTO EndUser
			(	LoginID,FirstName,MiddleName,LastName,LanguageCode,UTCOffset,DefaultModuleCode,Gender,EmailID,UserIdentity,ActivatedDTM,
			LastAccessPoint,LastLoginDTM,SecretQuestion,SecretAnswer,ActivationURLID,ResetPasswordURLID, DesignationID, DepartmentID )
		VALUES
			(	@p_LoginID,@p_FirstName,@p_MiddleName,@p_LastName,@p_LanguageCode,@p_UTCOffset,@p_DefaultModuleCode,@p_Gender,@p_EmailID,
			CONVERT(VARBINARY(16), HASHBYTES ('MD5', @p_UserIdentity)),@p_ActivatedDTM,
			@p_LastAccessPoint,@p_LastLoginDTM,@p_SecretQuestion,@p_SecretAnswer,@p_ActivationURLID,@p_ResetPasswordURLID, @p_DesignationID, @p_DepartmentID	);

	SET @p_EndUserID = SCOPE_IDENTITY();

	IF (@p_EndUserID > 0)
	BEGIN
		--Important update for password update WHEN NOT SEND FROM ui
		IF(@p_UserIdentity IS NULL)
			UPDATE	EndUser
				SET	UserIdentity	= CONVERT(VARBINARY(16), HASHBYTES ('MD5', N'demo123'))
			WHERE	EndUserID		= @p_EndUserID

		INSERT INTO EndUserModule
				(	EndUserID,ModuleCode	)
			SELECT	@p_EndUserID,ModuleCode
			FROM	@p_EndUserModule

		INSERT INTO UserRoleUser
				(	UserRoleID,EndUserID	)
			SELECT	UserRoleID,@p_EndUserID
			FROM	@p_UserRoleUser

		--==Audit Log====================================================================================================================
		DECLARE
				@AuditLogID		BIGINT,
				@IsDetailAudit	BIT,
				@ObjectID		VARCHAR(50)	-- PK/UK column(s separated by |)

		SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_EndUserID)
		EXEC InsertAuditLog @p_EndUserID, @p_CurrentUserRoleID, @p_CurrentScreenID, @ObjectID, 'I', @p_CurrentAccessPoint , @AuditLogID OUT, @IsDetailAudit OUT;

	END
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'UpdateEndUser') AND TYPE IN (N'P'))
DROP PROCEDURE UpdateEndUser
GO
CREATE PROCEDURE UpdateEndUser
(
	@p_EndUserID			INT,
	@p_LoginID				NVARCHAR(50),
	@p_FirstName			NVARCHAR(30),
	@p_MiddleName			NVARCHAR(30),
	@p_LastName				NVARCHAR(30),
	@p_LanguageCode			LanguageCode	/*CHAR(2)*/,
	@p_UTCOffset			NUMERIC(4,2),
	@p_DefaultModuleCode	CHAR(2),
	@p_Gender				VARCHAR(10),
	@p_EmailID				NVARCHAR(50),
	@p_UserIdentity			NVARCHAR(16),

	@p_ActivatedDTM			DATETIME,
	@p_LastAccessPoint		VARCHAR(25),
	@p_LastLoginDTM			DATETIME,
	@p_SecretQuestion		NVARCHAR(100),
	@p_SecretAnswer			NVARCHAR(100),
	@p_ActivationURLID		INT,
	@p_ResetPasswordURLID	INT,
	@p_DesignationID		DesignationID = NULL/*SMALLINT*/,
	@p_DepartmentID			DepartmentID = NULL	/*SMALLINT*/,

	@p_EndUserModule		EndUserModule_TableType	 READONLY,
	@p_UserRoleUser			UserRoleUser_TableType	 READONLY,

	@p_CurrentLanguageCode CHAR(2),
	@p_CurrentUTCOffset NUMERIC(4,2),
	@p_CurrentEndUserID INT,
	@p_CurrentUserRoleID INT,
	@p_CurrentScreenID SMALLINT,
	@p_CurrentAccessPoint VARCHAR(25)
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

	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_EndUserID)
	EXEC InsertAuditLog @p_EndUserID, @p_CurrentUserRoleID, @p_CurrentScreenID, @ObjectID, 'U', @p_CurrentAccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

	IF(@IsDetailAudit = 1)
	BEGIN
		SET @PreImage = (	SELECT	LoginID,FirstName,MiddleName,LastName,LanguageCode,UTCOffset,DefaultModuleCode,Gender,EmailID,ActivatedDTM,LastAccessPoint,LastLoginDTM,SecretQuestion,SecretAnswer,ActivationURLID,ResetPasswordURLID, DesignationID, DepartmentID 
							FROM	EndUser
							WHERE	EndUserID	= @p_EndUserID
							FOR XML AUTO
						);

		IF(@PreImage IS NOT NULL)
			INSERT INTO  AuditPreImage
						(    AuditLogID,TableName, PreImage    )
					VALUES
						(    @AuditLogID,'EndUser', @PreImage     )

 
		SET @PreImage = (	SELECT	ModuleCode
							FROM	EndUserModule
							WHERE	EndUserID	= @p_EndUserID
							FOR XML AUTO
						);

		IF(@PreImage	IS NOT NULL)
			INSERT INTO  AuditPreImage
					(    AuditLogID, TableName, PreImage    )
				VALUES
					(    @AuditLogID, 'EndUserModule', @PreImage     )
 
 
		SET @PreImage = (	SELECT	UserRoleID
							FROM	UserRoleUser
							WHERE	EndUserID	= @p_EndUserID
							FOR XML AUTO
						);

		IF(@PreImage	IS NOT NULL)
			INSERT INTO  AuditPreImage
					(    AuditLogID, TableName, PreImage    )
				VALUES
					(    @AuditLogID, 'UserRoleUser', @PreImage     )

		SET @PreImage = (	SELECT	LocationID
							FROM	UserLeafLocation
							WHERE	UserID = @p_EndUserID
							FOR XML AUTO
						);

		IF(@PreImage	IS NOT NULL)
			INSERT INTO  AuditPreImage
					(    AuditLogID, TableName, PreImage    )
				VALUES
					(    @AuditLogID, 'UserLeafLocation', @PreImage     )

	END
	--== Audit Log End================================================================================================================

	IF(@p_UserIdentity IS NOT NULL)
		UPDATE	EndUser
			SET	UserIdentity	= CONVERT(VARBINARY(16), HASHBYTES ('MD5', @p_UserIdentity))
		WHERE	EndUserID		= @p_EndUserID

	UPDATE	EndUser
	 SET	FirstName			= @p_FirstName,
			MiddleName			= @p_MiddleName,
			LastName			= @p_LastName,
			LanguageCode		= @p_LanguageCode,
			UTCOffset			= @p_UTCOffset,
			DefaultModuleCode	= @p_DefaultModuleCode,
			Gender				= @p_Gender,
			EmailID				= @p_EmailID,
			DesignationID		= @p_DesignationID,
			DepartmentID		= @p_DepartmentID
	WHERE	EndUserID			= @p_EndUserID
	
	IF (@@ROWCOUNT = 0)
	BEGIN
		RAISERROR('No Record found for End User',16,1)
		RETURN -1;
	END
			 
	DELETE FROM EndUserModule	 WHERE 	EndUserID	= @p_EndUserID	

	INSERT INTO EndUserModule
				(	EndUserID,ModuleCode	)
		SELECT	@p_EndUserID,ModuleCode
		FROM	@p_EndUserModule

	DELETE FROM UserRoleUser	 WHERE 	EndUserID	= @p_EndUserID	

	INSERT INTO UserRoleUser
				(	UserRoleID,EndUserID	)
		SELECT	UserRoleID,@p_EndUserID
		FROM	@p_UserRoleUser

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'DeleteEndUser') AND TYPE IN (N'P'))
DROP PROCEDURE DeleteEndUser
GO
CREATE PROCEDURE DeleteEndUser
(
	@p_EndUserID	INT,

	@p_CurrentLanguageCode CHAR(2),
	@p_CurrentUTCOffset NUMERIC(4,2),
	@p_CurrentEndUserID INT,
	@p_CurrentUserRoleID INT,
	@p_CurrentScreenID SMALLINT,
	@p_CurrentAccessPoint VARCHAR(25)
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

	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_EndUserID)
	EXEC InsertAuditLog @p_EndUserID, @p_CurrentUserRoleID, @p_CurrentScreenID, @ObjectID, 'D', @p_CurrentAccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

	IF(@IsDetailAudit = 1)
	BEGIN
		SET @PreImage = (	SELECT	LoginID,FirstName,MiddleName,LastName,LanguageCode,UTCOffset,DefaultModuleCode,Gender,EmailID,ActivatedDTM,LastAccessPoint,LastLoginDTM,SecretQuestion,SecretAnswer,ActivationURLID,ResetPasswordURLID,DesignationID, DepartmentID 
							FROM	EndUser
							WHERE	EndUserID	= @p_EndUserID
							FOR XML AUTO
						);

		IF(@PreImage IS NOT NULL)
			INSERT INTO  AuditPreImage
						(    AuditLogID, TableName, PreImage    )
					VALUES
						(    @AuditLogID,'EndUser', @PreImage     )

	 
		SET @PreImage = (	SELECT	ModuleCode
							FROM	EndUserModule
							WHERE	EndUserID	= @p_EndUserID
							FOR XML AUTO
						);

		IF(@PreImage	IS NOT NULL)
			INSERT INTO  AuditPreImage
					(    AuditLogID, TableName, PreImage    )
				VALUES
					(    @AuditLogID, 'EndUserModule', @PreImage     )
 
	 
		SET @PreImage = (	SELECT	UserRoleID
							FROM	UserRoleUser
							WHERE	EndUserID	= @p_EndUserID
							FOR XML AUTO
						);

		IF(@PreImage	IS NOT NULL)
			INSERT INTO  AuditPreImage
					(    AuditLogID, TableName, PreImage    )
				VALUES
					(    @AuditLogID, 'UserRoleUser', @PreImage     )

		 
		SET @PreImage = (	SELECT	ModuleCode,ServiceLineCode,UserID,LocationID
							FROM	UserLocation
							WHERE	UserID	= @p_EndUserID
							FOR XML AUTO
						);

		IF(@PreImage	IS NOT NULL)
			INSERT INTO  AuditPreImage
					(    AuditLogID, TableName, PreImage    )
				VALUES
					(    @AuditLogID, 'UserLocation', @PreImage     )

	END
	--== Audit Log End================================================================================================================
	DELETE
	FROM	UserLocation
	WHERE	UserID	= @p_EndUserID

	DELETE
	FROM	EndUserModule
	WHERE	EndUserID	= @p_EndUserID
	DELETE
	FROM	UserRoleUser
	WHERE	EndUserID	= @p_EndUserID
	DELETE
	FROM	EndUser
	WHERE	EndUserID	= @p_EndUserID

	IF (@@ROWCOUNT = 0)
	BEGIN
		RAISERROR('No Record found for End User',16,1)
		RETURN -1;
	END

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'EndUserView') AND TYPE IN (N'V'))
DROP VIEW EndUserView
GO
CREATE	VIEW EndUserView
AS
	SELECT	EndUserID,
			LoginID,
			(FirstName + COALESCE(' ' + MiddleName,'') + COALESCE(' ' + LastName,''))	AS Name,
			FirstName,
			MiddleName,
			LastName,
			DesignationID, 
			DepartmentID ,
			LanguageCode,
			UTCOffset,
			tz.TimeZoneID,
			tz.TimeZoneValue,
			DefaultModuleCode,
			Gender,
			EmailID,
			ActivatedDTM,
			LastAccessPoint,
			LastLoginDTM,
			SecretQuestion,
			SecretAnswer,
			ActivationURLID,
			ResetPasswordURLID,
			(SELECT TOP 1 UserRoleID FROM UserRoleUser WHERE EndUserID = EndUser.EndUserID) AS UserRoleID,
			(SELECT TOP 1 UserRoleName FROM UserRole WHERE UserRoleID = (SELECT TOP 1 UserRoleID FROM UserRoleUser WHERE EndUserID = EndUser.EndUserID)) AS UserRoleName

	FROM	EndUser
	JOIN	TimeZone	tz
			ON	(	tz.TimeZoneID	=	CONVERT(TINYINT,UTCOffset) )

GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetEndUser') AND TYPE IN (N'P'))
	DROP PROCEDURE GetEndUser
GO
CREATE PROCEDURE GetEndUser
(
	@p_EndUserID			INT,
	@p_LoginID				NVARCHAR(50),
	@p_FirstName			NVARCHAR(30),
	@p_MiddleName			NVARCHAR(30),
	@p_LastName				NVARCHAR(30),
	@p_Name					NVARCHAR(50) = NULL,
	@p_LanguageCode			LanguageCode	/*CHAR(2)*/,
	@p_UTCOffset			NUMERIC(4,2),
	@p_DefaultModuleCode	CHAR(2),
	@p_Gender				VARCHAR(10),
	@p_EmailID				NVARCHAR(50),
	@p_UserRoleName			NVARCHAR(50) = NULL,
	@p_IsChildResult		BIT,
	@p_IsCustomerUser		BIT = 0  -- SET DEFAULT 0 AS NAFFCO LEVEL USERS & 1= CUSTOMER USERS
)
----WITH ENCRYPTION
AS
BEGIN
	SELECT	EndUserID,
			LoginID,
			Name,
			FirstName,
			MiddleName,
			LastName,
			LanguageCode,
			DesignationID, 
			DepartmentID,
			UTCOffset,
			DefaultModuleCode,
			Gender,
			EmailID,
			ActivatedDTM,
			LastAccessPoint,
			LastLoginDTM,
			SecretQuestion,
			SecretAnswer,
			ActivationURLID,
			ResetPasswordURLID,
			UserRoleID,
			UserRoleName

	FROM		EndUserView EndUser
	LEFT JOIN	CustomerContact
					ON EndUser.EndUserID	=	CustomerContact.UserID
	WHERE	(	EndUserID	=	@p_EndUserID
			OR	@p_EndUserID	IS NULL
			)
	AND		LoginID LIKE  N'%' + COALESCE(@p_LoginID, N'') +  N'%'
	AND		FirstName LIKE  N'%' + COALESCE(@p_FirstName, N'') +  N'%'
	AND		(	MiddleName LIKE  N'%' + COALESCE(@p_MiddleName, N'') +  N'%'
			OR	@p_MiddleName	IS NULL
			)
	AND		LastName LIKE  N'%' + COALESCE(@p_LastName, N'') +  N'%'
	AND		LanguageCode LIKE  '%' + COALESCE(@p_LanguageCode, '') +  '%'
	AND		(	UTCOffset	=	@p_UTCOffset
			OR	@p_UTCOffset	IS NULL
			)
	AND     Name LIKE  N'%' + COALESCE(@p_Name, N'') +  N'%'
	AND		LoginID LIKE  N'%' + COALESCE(@p_LoginID, N'') +  N'%'
	AND		EmailID LIKE  N'%' + COALESCE(@p_EmailID, N'') +  N'%'
	AND		(	EndUserID	IN (
									SELECT UserRoleUser.EndUserID 
									FROM UserRole 
									JOIN UserRoleUser 
											ON UserRole.UserRoleID = UserRoleUser.UserRoleID 
									AND EndUser.EndUserID = UserRoleUser.EndUserID
									WHERE UserRoleName LIKE  N'%' + COALESCE(@p_UserRoleName, N'') +  N'%'
									AND @p_UserRoleName IS NOT NULL
	  						   )
				OR	@p_UserRoleName	IS NULL
			)
	AND		(	(	CustomerContact.UserID  IS     NULL AND @p_IsCustomerUser	= 0
				OR CustomerContact.UserID  IS NOT  NULL AND @p_IsCustomerUser	= 1
				)
			--OR	@p_IsCustomerUser	IS NULL
			)
	
	IF(@@ROWCOUNT = 1 AND @p_IsChildResult = 1)
	BEGIN
		SELECT	EndUserID,
				ModuleCode
		FROM	EndUserModule
		WHERE	EndUserID	= @p_EndUserID

		SELECT	UserRoleID,
				EndUserID
		FROM	UserRoleUser
		WHERE	EndUserID	= @p_EndUserID
	END
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetEndUserName') AND TYPE IN (N'P'))
DROP PROCEDURE GetEndUserName
GO
CREATE PROCEDURE GetEndUserName
(
	@p_UserName	NVARCHAR(30),
	@p_UserRoleName	NVARCHAR(30) = NULL
)
----WITH ENCRYPTION
AS
BEGIN
	SELECT	EndUser.EndUserID,
			EndUser.Name
			
	FROM	EndUserView EndUser
	JOIN	UserRoleUser 
				ON	(EndUser.EndUserID = UserRoleUser.EndUserID)
	JOIN	UserRole
				ON	(UserRoleUser.UserRoleID = UserRole.UserRoleID)
	WHERE	EndUser.Name LIKE  '%' + COALESCE(@p_UserName, '') +  '%' 
	AND		(	@p_UserRoleName IS NOT NULL
			OR	(@p_UserRoleName IS NULL AND userrole.UserRoleName = 'Controller')
			)
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetUserCustomer') AND TYPE IN (N'P'))
DROP PROCEDURE GetUserCustomer
GO
--	GetUserCustomer 'SF', 'FR' ,NULL,NULL,'EN',null,1,null,null,null		
CREATE PROCEDURE GetUserCustomer
(
	@p_ModuleCode		ModuleCode,
	@p_ServiceLineCode	ServiceLineCode,
	@p_CustomerName		GenericName	= NULL,
	@p_Date				DATETIME,

	@p_LanguageCode CHAR(2),
	@p_UTCOffset	NUMERIC(4,2),
	@p_EndUserID	UserID,
	@p_UserRoleID   INT,
	@p_ScreenID		SMALLINT,
	@p_AccessPoint  VARCHAR(25)
)
----WITH ENCRYPTION
AS
BEGIN
		DECLARE	@Customertable TABLE (CustomerID CustomerID NOT NULL);
	
		-- Location directly point to Customer
		INSERT INTO @Customertable(CustomerID)
		SELECT	CustomerID 
		FROM	UserLocation 
		JOIN	Location 
					ON Location.locationID = UserLocation.LocationID
		WHERE	CustomerID							IS NOT NULL
		AND		UserLocation.UserID				=	@p_EndUserID
		--AND		UserLocation.ModuleCode			=	@p_ModuleCode
		--AND		(	UserLocation.ServiceLineCode	=	@p_ServiceLineCode
		--		OR	(UserLocation.ServiceLineCode IS NULL AND @p_ServiceLineCode IS NULL)
		--		)
		GROUP BY CustomerID

		UNION ALL 
	
		-- Customer Account manager
		SELECT CustomerID 
		FROM   Customer 
		WHERE  AccountManagerID = @p_EndUserID
	
		--Controller Tagging
		UNION ALL
		SELECT	L.CustomerID
		FROM	ControllerTagging CT
		JOIN	ControllerTaggingLocation CTL
					ON	CT.ControllerTaggingID	=	CTL.ControllerTaggingID
		JOIN	Location L 
					ON L.locationID = CTL.LocationID
		WHERE	@p_Date			BETWEEN CT.StartDate AND	CT.EndDate
		AND		CT.ControllerID = @p_EndUserID
		GROUP BY CustomerID

		-- Organization Level Locations is tagged to User
		IF  EXISTS(	SELECT TOP 1 1
					FROM	UserLocation UL 
					JOIN	Location L 
								ON L.locationID = UL.LocationID
					WHERE	L.CustomerID	IS NULL
					AND		UL.UserID				=	@p_EndUserID
					--AND		UL.ModuleCode			=	@p_ModuleCode
					--AND		(	UL.ServiceLineCode	=	@p_ServiceLineCode
					--		OR	(UL.ServiceLineCode IS NULL AND @p_ServiceLineCode IS NULL)
					--		)		
				 )
		BEGIN
			;WITH LocationTable(CustomerID,LocationID,ParentLocationID,LocationName)
			AS
			(	
				SELECT  L.CustomerID, L.LocationID, L.ParentLocationID, L.LocationName
				FROM	UserLocation UL 
				JOIN	Location L 
							ON L.locationID = UL.LocationID
				WHERE	L.CustomerID	IS NULL
				AND		UL.UserID				=	@p_EndUserID
				--AND		UL.ModuleCode			=	@p_ModuleCode
				--AND		(	UL.ServiceLineCode	=	@p_ServiceLineCode
				--		OR	(UL.ServiceLineCode IS NULL AND @p_ServiceLineCode IS NULL)
				--		)
				GROUP BY L.CustomerID, L.LocationID, L.ParentLocationID, L.LocationName

				UNION ALL

				SELECT L.CustomerID, L.LocationID, L.ParentLocationID, L.LocationName
				FROM Location L
				JOIN LocationTable
						ON L.ParentLocationID = LocationTable.LocationID
				--JOIN CustomerLocation 		
				--		ON CustomerLocation.CustomerID = LocationTable.CustomerID
			)

			INSERT INTO @Customertable(	CustomerID	)
									SELECT CustomerID 
									FROM LocationTable 
									WHERE CustomerID IS NOT NULL 
									GROUP BY CustomerID
		END
		
		-- IF BLANK THEN CONSIDER IT AS ADMIN
		IF NOT EXISTS(	SELECT TOP 1 1 FROM @Customertable GROUP BY CustomerID)
		BEGIN
			SELECT	CustomerID,CustomerName
			FROM	Customer
			WHERE	CustomerName LIKE  N'%' + COALESCE(@p_CustomerName, N'') +  N'%'
			ORDER BY CustomerName
		END
		ELSE
		BEGIN
			SELECT	C.CustomerID, C.CustomerName
			FROM	@Customertable CT
			JOIN	Customer C
						ON	CT.CustomerID	=	C.CustomerID
			WHERE	C.CustomerName LIKE  N'%' + COALESCE(@p_CustomerName, N'') +  N'%'
			GROUP BY C.CustomerID,C.CustomerName
			ORDER BY C.CustomerName
		END

		-- CUSTOMER CONTACT UNION IS REMAINS
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetUserCustomerLocation') AND TYPE IN (N'P'))
DROP PROCEDURE GetUserCustomerLocation
GO
--	GetUserCustomerLocation 5, 2 ,'SF','FR','EN',5,1,1,null,null	
-- if Location is pass then return 1 step down eligible locations
CREATE PROCEDURE GetUserCustomerLocation
(
	@p_CustomerID		CustomerID,
	@p_LocationID		LocationID		= NULL,
	@p_ModuleCode		ModuleCode		= NULL,
	@p_ServiceLineCode	ServiceLineCode = NULL,
	
	@p_LanguageCode CHAR(2),
	@p_UTCOffset	NUMERIC(4,2),
	@p_EndUserID	UserID,
	@p_UserRoleID   INT,
	@p_ScreenID		SMALLINT,
	@p_AccessPoint  VARCHAR(25)
)
----WITH ENCRYPTION
AS
BEGIN
	DECLARE @p_Date	DATETIME = GETUTCDATE();

	DECLARE @LocationList	 AS TABLE ( LocationID			LocationID	NOT NULL,
										LocationName		GenericName NOT NULL, 
										ParentLocationID	LocationID		NULL, 
										IsStop				BIT				NULL
									  );

	DECLARE @AllLocationList AS TABLE	(  LocationID		LocationID	NOT NULL,
										 LocationName		GenericName NOT NULL, 
										 ParentLocationID	LocationID		NULL, 
										 IsStop				BIT				NULL,
										 HasChild			BIT				NULL
										);

	DECLARE	@IsController BIT = 0;
	IF EXISTS(	SELECT TOP 1 1				--Currently just returning single user role ID
				FROM	UserRoleUser	uru
				JOIN	UserRole		ur
						ON	(	ur.UserRoleID	=	uru.UserRoleID
							AND	UserRoleName	=	'Controller'
							)
				WHERE	EndUserID = @p_EndUserID)

			SET	@IsController = 1;

	IF(@IsController = 1)
	BEGIN
		;WITH LocationTable(CustomerID,LocationID,ParentLocationID,LocationName,IsStop)
		 AS
		 ( (	SELECT Location.CustomerID, Location.LocationID,Location.ParentLocationID,Location.LocationName,CONVERT(BIT,null)
				FROM    ControllerTagging CT
				JOIN	ControllerTaggingLocation CTL
							ON	CT.ControllerTaggingID	=	CTL.ControllerTaggingID
				JOIN	Location		
							ON CTL.LocationID	= Location.LocationID
				WHERE	@p_Date	BETWEEN CT.StartDate AND	CT.EndDate
				AND		CT.ControllerID			= @p_EndUserID
				AND		Location.CustomerID		= @p_CustomerID  
			)
			UNION ALL
			SELECT Location.CustomerID, 
				   Location.LocationID, 
				   Location.ParentLocationID,
				   
				   ( CASE WHEN CustomerLocation.LocationID = Location.LocationID
					THEN (SELECT LocationName	FROM Location a WHERE Location.ParentLocationID = a.LocationID )
					ELSE Location.LocationName  END
				   ) as LocationName,
				   CONVERT(BIT,(CASE WHEN CustomerLocation.LocationID = Location.LocationID THEN 1 ELSE 0  END))

			FROM Location
			JOIN LocationTable
				ON Location.LocationID = LocationTable.ParentLocationID
			JOIN CustomerLocation 		
				ON CustomerLocation.CustomerID = @p_CustomerID
		 )

		 INSERT INTO @LocationList(LocationID, LocationName, ParentLocationID, IsStop)
		 SELECT LocationTable.LocationID,LocationTable.LocationName,LocationTable.ParentLocationID,LocationTable.IsStop
		 FROM LocationTable
		 GROUP BY	LocationTable.LocationID,LocationTable.LocationName,LocationTable.ParentLocationID,LocationTable.IsStop

		;WITH UserLocationTable(CustomerID,LocationID,ParentLocationID,LocationName,IsStop)
		 AS
		 (SELECT @p_CustomerID,CTL.LocationID,Location.ParentLocationID,Location.LocationName,CONVERT(BIT,0)
		  FROM  ControllerTagging CT
		  JOIN	ControllerTaggingLocation CTL
					ON	CT.ControllerTaggingID	=	CTL.ControllerTaggingID
		  JOIN	@LocationList L 
					ON	L.LocationID = CTL.LocationID
		  JOIN	Location
					ON (	Location.LocationID = CTL.LocationID
						AND	Location.CustomerID = @p_CustomerID
					   )
			WHERE	@p_Date	BETWEEN CT.StartDate AND	CT.EndDate
				AND		CT.ControllerID			= @p_EndUserID
				AND		Location.CustomerID		= @p_CustomerID  

			UNION ALL
			SELECT @p_CustomerID,Location.LocationID,Location.ParentLocationID,Location.LocationName,CONVERT(BIT,0)
			FROM Location 
				JOIN UserLocationTable
					ON	Location.ParentLocationID = UserLocationTable.LocationID
			)

			INSERT INTO @AllLocationList
			Select LocationID,LocationName,ParentLocationID,IsStop,
	 			(	CASE	WHEN (	(	SELECT	COUNT(LocationID) 
										FROM	Location t 
										WHERE	UserLocationTable.LocationID	=	t.ParentLocationID	)	> 0 										
								 )
						THEN 1 
						ELSE 0
					END
				)	AS	HasChild
			 FROM UserLocationTable
			 UNION
			 SELECT *,
	 			(	CASE	WHEN (	(	SELECT	COUNT(LocationID) 
									FROM	Location t 
									WHERE	L.LocationID	=	t.ParentLocationID	)	> 0 										
								)
						THEN 1 
						ELSE 0
					END
				)	AS	HasChild
		 FROM @LocationList L			

	END	
	ELSE IF EXISTS(	SELECT TOP 1 1 FROM UserLocation  /*FOR Non Controller Users*/
					JOIN	Location
								ON Location.locationID = UserLocation.LocationID 
					AND		UserID				 = @p_EndUserID
					AND		ModuleCode			 = @p_ModuleCode  
					AND		Location.CustomerID  = @p_CustomerID 
				  )
	BEGIN
		/*===================================== IF Customer Has Access to Specific Locations =======================================*/
		;WITH LocationTable(CustomerID,LocationID,ParentLocationID,LocationName,IsStop)
		 AS
		 ( (	SELECT Location.CustomerID, Location.LocationID,Location.ParentLocationID,Location.LocationName,CONVERT(BIT,null)
				FROM UserLocation
				JOIN Location
						ON UserLocation.LocationID  = Location.LocationID
				WHERE	UserID					= @p_EndUserID
				AND		ModuleCode				= @p_ModuleCode  
				AND		Location.CustomerID		= @p_CustomerID  
				AND		( ServiceLineCode		= @p_ServiceLineCode
						OR ServiceLineCode		IS NULL
	 					)

			)
			UNION ALL
			SELECT Location.CustomerID, 
				   Location.LocationID, 
				   Location.ParentLocationID,
				   --Location.LocationName, 
				   ( CASE WHEN CustomerLocation.LocationID = Location.LocationID
					THEN (SELECT LocationName FROM Location a WHERE Location.ParentLocationID = a.LocationID )
					ELSE Location.LocationName  END
				   ) as LocationName,
				   CONVERT(BIT,(CASE WHEN CustomerLocation.LocationID = Location.LocationID THEN 1 ELSE 0  END))

			FROM Location
			JOIN LocationTable
				ON Location.LocationID = LocationTable.ParentLocationID
			JOIN CustomerLocation 		
				ON CustomerLocation.CustomerID = @p_CustomerID
		 )

		 INSERT INTO @LocationList(LocationID, LocationName, ParentLocationID, IsStop)
		 SELECT LocationTable.LocationID,LocationTable.LocationName,LocationTable.ParentLocationID,LocationTable.IsStop
		 FROM LocationTable
		 GROUP BY	LocationTable.LocationID,LocationTable.LocationName,LocationTable.ParentLocationID,LocationTable.IsStop

		;WITH UserLocationTable(CustomerID,LocationID,ParentLocationID,LocationName,IsStop)
		 AS
		 (SELECT @p_CustomerID,UserLocation.LocationID,Location.ParentLocationID,Location.LocationName,CONVERT(BIT,0)
		  FROM @LocationList L
		  JOIN UserLocation 
					ON UserLocation.LocationID = L.LocationID
		  JOIN Location
					ON (	Location.LocationID = UserLocation.LocationID
						AND	Location.CustomerID = @p_CustomerID
					   )	
			UNION ALL
			SELECT @p_CustomerID,Location.LocationID,Location.ParentLocationID,Location.LocationName,CONVERT(BIT,0)
			FROM Location 
				JOIN UserLocationTable
					ON	Location.ParentLocationID = UserLocationTable.LocationID
			)

			INSERT INTO @AllLocationList
			Select LocationID,LocationName,ParentLocationID,IsStop,
	 			(	CASE	WHEN (	(	SELECT	COUNT(LocationID) 
									FROM	Location t 
									WHERE	UserLocationTable.LocationID	=	t.ParentLocationID	)	> 0 										
								)
						THEN 1 
						ELSE 0
					END
				)	AS	HasChild
			 FROM UserLocationTable
			 UNION
			 SELECT *,(	CASE	WHEN (	(	SELECT	COUNT(LocationID) 
										FROM	Location t 
										WHERE	L.LocationID	=	t.ParentLocationID	)	> 0 										
									 )
								THEN 1 
								ELSE 0
						END
				)	AS	HasChild
		 FROM @LocationList L

		/*===========================================================================================================================*/
			--SELECT DISTINCT LocationID,LocationName,ParentLocationID,ISNULL(IsStop,0) AS IsStop,CONVERT(BIT,HasChild) AS HasChild
			--FROM @AllLocationList L
			--WHERE (@p_LocationID IS NOT NULL OR L.IsStop = 1) 
			--	AND (@p_LocationID IS NULL OR L.ParentLocationID = @p_LocationID)
	END
	ELSE
	BEGIN
		/*===================================== IF User not specified for perticuler location of Customer then Has Full Access =======================================*/
		;WITH LocationTable(CustomerID,LocationID,ParentLocationID,LocationName,IsStop)
		 AS
		 (  SELECT	Location.CustomerID, Location.LocationID,Location.ParentLocationID,Location.LocationName,Convert(bit,null)
			FROM	Location
			WHERE	Location.CustomerID  = @p_CustomerID 

			UNION ALL
			SELECT  Location.CustomerID, 
					Location.LocationID, 
					Location.ParentLocationID,
					( CASE WHEN CustomerLocation.LocationID = Location.LocationID
					THEN (SELECT LocationName FROM Location a WHERE Location.ParentLocationID = a.LocationID )
					ELSE Location.LocationName  END
					) as LocationName,
					CONVERT(BIT,(CASE WHEN CustomerLocation.LocationID = Location.LocationID THEN 1 ELSE 0  END))
			FROM	Location
			JOIN	LocationTable
						ON Location.LocationID = LocationTable.ParentLocationID
			JOIN	CustomerLocation 		
						ON CustomerLocation.CustomerID = @p_CustomerID
		 )

		 INSERT INTO	@LocationList(LocationID, LocationName, ParentLocationID, IsStop)
		 SELECT distinct LocationTable.LocationID,LocationTable.LocationName,LocationTable.ParentLocationID,LocationTable.IsStop
		 FROM LocationTable
	
		;WITH UserLocationTable(CustomerID, LocationID, ParentLocationID, LocationName, IsStop)
		 AS(	SELECT	@p_CustomerID,Location.LocationID,Location.ParentLocationID,Location.LocationName,CONVERT(BIT,0)
				FROM	@LocationList L			
				JOIN	Location
							ON (	Location.LocationID = L.LocationID
								AND	Location.CustomerID = @p_CustomerID
							   )
				UNION ALL
				SELECT @p_CustomerID,Location.LocationID,Location.ParentLocationID,Location.LocationName,CONVERT(BIT,0)
				FROM Location 
					JOIN UserLocationTable
						ON	Location.ParentLocationID = UserLocationTable.LocationID
			)

		INSERT INTO @AllLocationList
		Select LocationID,LocationName,ParentLocationID,IsStop,
	 		(	CASE	WHEN (	(	SELECT	COUNT(LocationID) 
								FROM	Location t 
								WHERE	UserLocationTable.LocationID	=	t.ParentLocationID	)	> 0 										
							)
					THEN 1 
					ELSE 0
			END
		)	AS	HasChild
		
		FROM UserLocationTable

		UNION

		SELECT *,(	CASE	WHEN (	(	SELECT	COUNT(LocationID) 
										FROM	Location t 
										WHERE	L.LocationID	=	t.ParentLocationID	)	> 0 										
								 )
					THEN 1
					ELSE 0
					END
				)	AS	HasChild
		 
		 FROM @LocationList L
	END
	
	/*===========================================================================================================================*/
	--SELECT DISTINCT LocationID,LocationName,ParentLocationID,ISNULL(IsStop,0) AS IsStop,CONVERT(BIT,HasChild) AS HasChild
	--FROM @AllLocationList L
	--WHERE (@p_LocationID IS NOT NULL OR L.IsStop = 1) 
	--	AND (@p_LocationID IS NULL OR L.ParentLocationID = @p_LocationID)
	--ORDER BY LocationName

	SELECT DISTINCT L.LocationID,
		CASE WHEN CL.LocationID  IS NOT NULL THEN (	SELECT  l2.LocationName
													FROM Location l1
													join Location l2
																ON l1.ParentLocationID  = l2.LocationID
													WHERE l1.LocationID			  = CL.LocationID
												  ) ELSE L.LocationName END LocationName,
			L.ParentLocationID,
			ISNULL(/*IsStop*/CONVERT(BIT,0),0) AS IsStop,  /*commented due to return multiple locations on controller tagging*/
			CONVERT(BIT,HasChild) AS HasChild , CL.LocationID AS RootLocationID, Loc.LocationSequence
	FROM		@AllLocationList L 
	JOIN	Location Loc 
		ON Loc.LocationID = L.LocationID
	LEFT JOIN	CustomerLocation CL 
		ON CL.LocationID = L.LocationID
	WHERE (
			(	@p_LocationID IS NOT NULL OR CL.LocationID IS NOT NULL/*L.IsStop = 1*/)
			AND (@p_LocationID IS NULL OR L.ParentLocationID = @p_LocationID)
		  )
	
	ORDER BY Loc.LocationSequence

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetOrganizationAndCustomer') AND TYPE IN (N'P'))
DROP PROCEDURE GetOrganizationAndCustomer	
GO
CREATE PROCEDURE GetOrganizationAndCustomer
(
	@p_LocationID			LocationID	/*SMALLINT*/,
	
	@p_LanguageCode CHAR(2) = 'EN',
	@p_EndUserID	UserID,
	@p_UserRoleID   INT,
	@p_ScreenID		SMALLINT,
	@p_AccessPoint  VARCHAR(25)
)
----WITH ENCRYPTION
AS
BEGIN

	DECLARE @DATE DATE =  GETDATE();

	SELECT	c.CustomerID,
			c.CustomerName

	FROM	Location l
	JOIN	Customer c
				ON	( l.CustomerID  =  c.CustomerID )
	WHERE	(	LocationID  = @p_LocationID
			OR	@p_LocationID IS NULL
			)

	GROUP BY  c.CustomerID, c.CustomerName
END
GO