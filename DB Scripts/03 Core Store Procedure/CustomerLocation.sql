 
----IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'AddCustomerLocationRiskLevel') AND TYPE IN (N'P'))
----DROP PROCEDURE AddCustomerLocationRiskLevel
----GO

----CREATE PROCEDURE AddCustomerLocationRiskLevel
----(
----	@p_LocationName	GenericName	/*NVARCHAR(50)*/,
----	@p_ParentLocationID	LocationID	/*INT*/,
----	@p_HasCustomers	BIT,
----	@p_CustomerID	CustomerID,
----	@p_Longitude	FLOAT,
----	@p_Latitude	FLOAT,
----	@p_Remarks	ShortRemarks	/*NVARCHAR(100)*/,
----	@p_LocationRiskLevel	LocationRiskLevel_TableTypeList	 READONLY,
	
----	@p_LanguageCode CHAR(2),
----	@p_UTCOffset NUMERIC(4,2),
----	@p_EndUserID INT,
----	@p_UserRoleID INT,
----	@p_ScreenID SMALLINT,
----	@p_AccessPoint VARCHAR(25),
----	@p_LocationID	LocationID	/*INT*/ OUTPUT
----)
--------WITH ENCRYPTION
----AS
----BEGIN
----	DECLARE @cnt	INT;
	
----	IF EXISTS(SELECT TOP 1 1 FROM ObjectInstance WHERE LocationID = @p_ParentLocationID )
----	BEGIN
----		RAISERROR('ObjectInstance_CK_LocationHasObjectInstanceThenDontAddNewLocation',16,1)
----		RETURN -1;
----	END

----	SELECT	@cnt =	COUNT (*)
----	FROM	@p_LocationRiskLevel;

----	DECLARE @cLocationSequence SMALLINT;

----	SET @cLocationSequence = (SELECT MAX(LocationSequence) FROM Location WHERE ParentLocationID = @p_ParentLocationID );

----	INSERT INTO Location
----			(	LocationName,ParentLocationID,HasCustomers,CustomerID,Longitude,Latitude,Remarks,LocationSequence)
----		VALUES
----			(	@p_LocationName,@p_ParentLocationID,@p_HasCustomers,@p_CustomerID,@p_Longitude,@p_Latitude,@p_Remarks, ISNULL(@cLocationSequence,0)+1);

----	SET @p_LocationID = SCOPE_IDENTITY();

----	IF (@p_LocationID > 0 AND @cnt > 0)
----	BEGIN
	
----		INSERT INTO LocationRiskLevel
----			(	ModuleCode,LocationID,RiskLevelID	)
----		SELECT	ModuleCode,@p_LocationID,RiskLevelID
----		FROM	@p_LocationRiskLevel
			
			
----		--==Audit Log====================================================================================================================
----		DECLARE
----				@AuditLogID		BIGINT,
----				@IsDetailAudit	BIT,
----				@ObjectID		VARCHAR(50)			-- PK/UK column(s separated by |)

----		SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_LocationID)
----		EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'I', @p_AccessPoint , @AuditLogID OUT, @IsDetailAudit OUT;
----	END
----END
----GO

----IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'UpdateCustomerLocationRiskLevel') AND TYPE IN (N'P'))
----DROP PROCEDURE UpdateCustomerLocationRiskLevel
----GO

----CREATE PROCEDURE UpdateCustomerLocationRiskLevel
----(
----	@p_LocationID	LocationID	/*INT*/,
----	@p_LocationName	GenericName	/*NVARCHAR(50)*/,
----	@p_ParentLocationID	LocationID	/*INT*/,
----	@p_HasCustomers	BIT,
----	@p_CustomerID	CustomerID,
----	@p_Longitude	FLOAT,
----	@p_Latitude	FLOAT,
----	@p_Remarks	ShortRemarks	/*NVARCHAR(100)*/,
----	@p_LocationRiskLevel	LocationRiskLevel_TableTypeList	 READONLY,
----	@p_LanguageCode CHAR(2),
----	@p_UTCOffset NUMERIC(4,2),
----	@p_EndUserID INT,
----	@p_UserRoleID INT,
----	@p_ScreenID SMALLINT,
----	@p_AccessPoint VARCHAR(25)
----)
--------WITH ENCRYPTION
----AS
----BEGIN

----	DECLARE @cnt	INT;
----	SELECT	@cnt	=	COUNT (*)
----	FROM	@p_LocationRiskLevel;
	
----	--== Audit Log Start================================================================================================================
----	DECLARE
----			@AuditLogID		BIGINT,
----			@IsDetailAudit	BIT,
----			@ObjectID		VARCHAR(50),			-- PK/UK column(s separated by |)
----			@PreImage		XML

----	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_LocationID)
----	EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'U', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

----	IF(@IsDetailAudit = 1)
----	BEGIN
----		SET @PreImage = (	SELECT	LocationName,ParentLocationID,HasCustomers,CustomerID,CountryCode,Longitude,Latitude,Remarks,LocationSequence
----							FROM	Location
----							WHERE	LocationID	= @p_LocationID
----							FOR XML AUTO
----						);

----		IF(@PreImage IS NOT NULL)
----			INSERT INTO  AuditPreImage
----						(    AuditLogID, TableName, PreImage    )
----					VALUES
----						(    @AuditLogID, 'Location', @PreImage     )
		
		
----		IF(@PreImage	IS NOT NULL)
----		BEGIN
----			SET @PreImage = (	SELECT	ModuleCode,
----									 	RiskLevelID
----								FROM	LocationRiskLevel
----								WHERE	LocationID	= @p_LocationID
----								FOR XML AUTO
----							);

----			IF(@PreImage	IS NOT NULL)
----				INSERT INTO  AuditPreImage
----						(    AuditLogID, TableName, PreImage    )
----					VALUES
----						(    @AuditLogID, 'LocationRiskLevel', @PreImage     )
----		END

----	END
	
----	--== Audit Log End================================================================================================================

----	UPDATE	Location
----	 SET	LocationName		= @p_LocationName,
----			ParentLocationID	= @p_ParentLocationID,
----			HasCustomers		= @p_HasCustomers,
----			CustomerID			= @p_CustomerID,
----			Longitude			= @p_Longitude,
----			Latitude			= @p_Latitude,
----			Remarks				= @p_Remarks
----	WHERE	LocationID			= @p_LocationID

----	IF (@@ROWCOUNT = 0)
----	BEGIN
----		RAISERROR('No Record found for Location',16,1)
----		RETURN -1;
----	END
	
----	IF (@cnt >	0)
----	BEGIN
	
----		DELETE FROM LocationRiskLevel	 WHERE 	LocationID	= @p_LocationID

----		INSERT INTO LocationRiskLevel
----					(	ModuleCode,LocationID,RiskLevelID	)
----				SELECT	ModuleCode,@p_LocationID,RiskLevelID
----				FROM	@p_LocationRiskLevel
	
----	END

----END
----GO

----IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'DeleteCustomerLocationRiskLevel') AND TYPE IN (N'P'))
----DROP PROCEDURE DeleteCustomerLocationRiskLevel
----GO
------	 DeleteCustomerLocationRiskLevel 17,'EN',null,1,1,6,'10.01'
----CREATE PROCEDURE DeleteCustomerLocationRiskLevel
----(
----	@p_LocationID	LocationID	/*INT*/,

----	@p_LanguageCode CHAR(2),
----	@p_UTCOffset NUMERIC(4,2),
----	@p_EndUserID INT,
----	@p_UserRoleID INT,
----	@p_ScreenID SMALLINT,
----	@p_AccessPoint VARCHAR(25)
----)
--------WITH ENCRYPTION
----AS
----BEGIN
----	--== Audit Log Start================================================================================================================
----	DECLARE
----			@AuditLogID		BIGINT,
----			@IsDetailAudit	BIT,
----			@ObjectID		VARCHAR(50),			-- PK/UK column(s separated by |)
----			@PreImage		XML

----	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_LocationID)
----	EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'D', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

----	IF(@IsDetailAudit = 1)
----	BEGIN
----		SET @PreImage = (	SELECT	LocationName,ParentLocationID,HasCustomers,CustomerID,CountryCode,Longitude,Latitude,Remarks,LocationSequence
----							FROM	Location
----							WHERE	LocationID	= @p_LocationID
----							FOR XML AUTO
----						);

----		IF(@PreImage IS NOT NULL)
----			INSERT INTO  AuditPreImage
----						(    AuditLogID, TableName, PreImage    )
----					VALUES
----						(    @AuditLogID, 'Location', @PreImage     )
						
 
----		SET @PreImage = (	SELECT	ModuleCode,
----									RiskLevelID
----							FROM	LocationRiskLevel
----							WHERE	LocationID	= @p_LocationID
----							FOR XML AUTO
----						);

----		IF(@PreImage	IS NOT NULL)
----			INSERT INTO  AuditPreImage
----					(    AuditLogID, TableName, PreImage    )
----				VALUES
----					(    @AuditLogID, 'LocationRiskLevel', @PreImage     )

----	END
----	--== Audit Log End================================================================================================================
	 

----	DELETE 
----	FROM	UserLocation	 
----	WHERE 	LocationID	= @p_LocationID

----	DELETE 
----	FROM	UserLeafLocation	 
----	WHERE 	LocationID	= @p_LocationID

----	DELETE 
----	FROM	LocationRiskLevel	 
----	WHERE 	LocationID	= @p_LocationID

----	DELETE
----	FROM	Location
----	WHERE	LocationID	= @p_LocationID

----	IF (@@ROWCOUNT = 0)
----	BEGIN
----		RAISERROR('No Record found for Location',16,1)
----		RETURN -1;
----	END

----END
----GO

----IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetCustomerLocationRiskLevel') AND TYPE IN (N'P'))
----DROP PROCEDURE GetCustomerLocationRiskLevel
----GO

----CREATE PROCEDURE GetCustomerLocationRiskLevel
----(
----	@p_LocationID	LocationID	/*INT*/,
----	@p_LocationName	GenericName	/*NVARCHAR(50)*/,
----	@p_ParentLocationID	LocationID	/*INT*/,
----	@p_HasCustomers	BIT,
----	@p_CustomerID	CustomerID,
----	@p_Longitude	FLOAT,
----	@p_Latitude	FLOAT,
----	@p_Remarks	ShortRemarks	/*NVARCHAR(100)*/,
----	@p_IsChildResult	BIT,
----	@p_LanguageCode CHAR(2),
----	@p_UTCOffset NUMERIC(4,2),
----	@p_EndUserID INT,
----	@p_UserRoleID INT,
----	@p_ScreenID SMALLINT,
----	@p_AccessPoint VARCHAR(25)
----)
--------WITH ENCRYPTION
----AS
----BEGIN
----	SELECT	l.LocationID,
----			l.LocationName,
----			l.ParentLocationID,
----			l.HasCustomers,
----			l.CustomerID,
----			l.Longitude,
----			l.Latitude,
----			l.Remarks,
----			(	SELECT	COUNT(lc.LocationID) 
----				FROM	Location lc
----					JOIN	CustomerLocation cl
----						ON	lc.LocationID	=	cl.LocationID
----				WHERE	lc.ParentLocationID	=	l.LocationID
----			)	As	CustomerCount

----	FROM	Location l
----	WHERE	(	l.LocationID	=	@p_LocationID
----			OR	@p_LocationID	IS NULL
----			)
----	AND		l.LocationName LIKE  N'%' + COALESCE(@p_LocationName, N'') +  N'%'
----	AND		(	l.ParentLocationID	=	@p_ParentLocationID
----			OR	@p_ParentLocationID	IS NULL
----			)
----	AND		(	l.HasCustomers	=	@p_HasCustomers
----			OR	@p_HasCustomers	IS NULL
----			)
----	AND		(	l.Longitude	=	@p_Longitude
----			OR	@p_Longitude	IS NULL
----			)
----	AND		(	l.Latitude	=	@p_Latitude
----			OR	@p_Latitude	IS NULL
----			)
----	AND		(	l.Remarks LIKE  N'%' + COALESCE(@p_Remarks, N'') +  N'%'
----			OR	@p_Remarks	IS NULL
----			)
			
----	IF(@@ROWCOUNT = 1 AND @p_IsChildResult = 1)
----	BEGIN
----		SELECT	ModuleCode,
----				LocationID,
----				RiskLevelID
----		FROM	LocationRiskLevel
----		WHERE	LocationID	= @p_LocationID

----	END

----	SELECT 
----	ff.fileid AS FileID,
----	fv.FilePath + '.'+ fv.FileType AS FileRelativePath
----	FROM FolderFile ff
----	JOIN
----	GetFileinfo_View fv
----		ON ff.FileID = fv.FileID
----	WHERE ObjectType = 'Object Data' and ObjectInstanceID = @p_LocationID
	
----END
----GO


----IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetRootAndChildCustomerLocationRiskLevel') AND TYPE IN (N'P'))
----DROP PROCEDURE GetRootAndChildCustomerLocationRiskLevel
----GO
------ EXEC GetRootAndChildCustomerLocationRiskLevel 333 
----CREATE PROCEDURE GetRootAndChildCustomerLocationRiskLevel 
----(
----	@p_LocationID	LocationID
----)
--------WITH ENCRYPTION
----AS
----BEGIN
	
----	 CREATE TABLE #LocationRiskLevelTemp(LocationID INT, text VARCHAR(100),LocationName VARCHAR(200),ParentLocationID INT,HasCustomers BIT,HasChild BIT);
----	 INSERT INTO #LocationRiskLevelTemp EXEC GetChildLocation @p_LocationID = @p_LocationID
 		
---- 	select top 2 * from (
---- 		SELECT	ModuleCode,
----				LocationID,
----				RiskLevelID,
----				'Root' AS Node
----		FROM	LocationRiskLevel
----		WHERE	LocationID	=  ( SELECT ParentLocationID FROM Location WHERE LocationID = @p_LocationID )
					
----		UNION ALL
		
----		SELECT	irl.ModuleCode,
----				irl.LocationID,
----				irl.RiskLevelID,
----				'Child' AS Node
----		FROM	LocationRiskLevel irl
----		  JOIN	#LocationRiskLevelTemp lt
----			ON	( lt.LocationID	=	irl.LocationID )
----	) as a 
----	where a.Node = 'Child' or a.Node = 'Root'
----	order by a.RiskLevelID
		
----END
----GO

----IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetHasCustomerLocations') AND TYPE IN (N'P'))
----DROP PROCEDURE GetHasCustomerLocations
----GO

----CREATE PROCEDURE GetHasCustomerLocations
----AS
----BEGIN
----	SELECT LocationID , LocationName 
----	FROM location 
----	WHERE hascustomers = 1
----END

----GO

------ 07E37902B754BCA25B076523F2E87E