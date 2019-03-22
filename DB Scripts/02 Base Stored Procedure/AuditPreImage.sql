
IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'InsertAuditLog') AND TYPE IN (N'P'))
DROP PROCEDURE InsertAuditLog
GO

CREATE PROCEDURE InsertAuditLog
(
	@p_EndUserID		INTEGER,
	@p_UserRoleID		SMALLINT,
	@p_ScreenID			SMALLINT,
	@p_ObjectID			VARCHAR (50),
	@p_OperationType	CHAR (1),
	@p_AccessPoint		VARCHAR (25),
	@p_AuditLogID		BIGINT				OUTPUT,
	@p_IsAudit			BIT					OUTPUT
)
----WITH ENCRYPTION
AS
BEGIN
	INSERT	INTO	AuditLog
			(	EndUserID, UserRoleID, ScreenID, ObjectID, OperationType, OperationDateTime, AccessPoint	)
		VALUES
			(	@p_EndUserID, @p_UserRoleID, @p_ScreenID, @p_ObjectID, @p_OperationType, GETUTCDATE(), @p_AccessPoint	);
	SET @p_AuditLogID	=	SCOPE_IDENTITY();

	SET @p_IsAudit	=	0;
	IF (@p_OperationType IN ('U', 'D'))
	BEGIN
		IF EXISTS	(	SELECT	1
						FROM	Screen
						WHERE	ScreenID	=	@p_ScreenID
						AND	(	(	@p_OperationType = 'U'	AND	UpdateAudit = 1	)
							OR	(	@p_OperationType = 'D'	AND	DeleteAudit = 1	)
							)
					)
			SET @p_IsAudit	=	1;
	END
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetAuditLogReport') AND TYPE IN (N'P'))
DROP PROCEDURE GetAuditLogReport
GO
--- GetAuditLogReport null,'TR',null,'7/1/2017 12:00:00 AM','7/31/2018 12:00:00 AM','EN',57.00,null,null,null,null
CREATE PROCEDURE GetAuditLogReport
(
 @p_Object			VARCHAR(100),
 @p_ModuleCode		CHAR(2),
 @p_OperationType   CHAR(1),
 @p_StartDate		DATE = GETUTCDATE,
 @p_EndDate         DATE = GETUTCDATE,

 @p_LanguageCode    CHAR(2),
 @p_UTCOffset		NUMERIC(4,2),
 @p_EndUserID		INT,
 @p_UserRoleID		INT,
 @p_ScreenID		SMALLINT,
 @p_AccessPoint		VARCHAR(25)
)
----WITH ENCRYPTION
AS
BEGIN
 
	 SELECT	a.AuditLogID, 
			a.OperationType,
			a.ObjectID,
			a.OperationDateTime, 
			s.ModuleCode,
			DBO.GetDataUTC(tz.TimeZoneValue, a.OperationDateTime) AS OperationDateTime,

			a.AccessPoint,
			(FirstName + COALESCE(' ' + MiddleName,'') + COALESCE(' ' + LastName,'')) AS UserName,
			s.ScreenName,
			'' ObjectName,
			a.EndUserID,
			a.AccessPoint

	 FROM	AuditLog  a
	 JOIN	Screen s
				ON ( a.ScreenID = s.ScreenID )
	 JOIN	EndUser  e
				ON ( a.EndUserID = e.EndUserID )
	 JOIN	TimeZone tz
				ON ( tz.TimeZoneID = CONVERT(TINYINT,e.UTCOffset) )
    
	 WHERE	(	s.ModuleCode = @p_ModuleCode
			OR @p_ModuleCode IS NULL
			)
	AND		(	s.ScreenName = @p_Object
			OR @p_Object IS NULL
			)
	 AND	( a.EndUserID = @p_EndUserID
			OR @p_EndUserID IS NULL
			)

	 AND	( a.OperationType = @p_OperationType
			OR @p_OperationType IS NULL
			)

	 AND	(	CONVERT(DATE,a.OperationDateTime) BETWEEN CONVERT(DATE,@p_StartDate) AND CONVERT(DATE,@p_EndDate)
			OR	(	CONVERT(DATE,@p_StartDate) IS NULL
				AND CONVERT(DATE,@p_EndDate)  IS NULL
				)
			)
	 AND	( a.AccessPoint = @p_AccessPoint
			OR @p_AccessPoint IS NULL
			)
 
	 AND	a.OperationType <> 'S'

	 ORDER BY AuditLogID DESC

END
GO
 
IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetEntityDetails') AND TYPE IN (N'P'))
DROP PROCEDURE GetEntityDetails
GO
-- GetEntityDetails 127189,null,null,null,null,null,null	
CREATE PROCEDURE GetEntityDetails
(
	@p_AuditLogID		BIGINT,

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

	SELECT	AP.AuditLogID,
			AP.TableName,
			CONVERT(NVARCHAR(max),AP.PreImage) AS PreImageCustom,
			A.ObjectID,
			--A.OperationDateTime,
			DBO.GetDataUTC(e.TimeZoneValue, A.OperationDateTime) AS OperationDateTime,
			A.OperationType

	FROM	AuditLog  A
	JOIN	AuditPreImage AP
				ON	(	A.AuditLogID	=	AP.AuditLogID	)
	JOIN	EndUserView	e
				ON ( e.EndUserID = A.EndUserID )

	WHERE	A.ScreenID	=	(SELECT ScreenID FROM	AuditLog WHERE  AuditLogID	=	@p_AuditLogID)
	AND		A.ObjectID	=	(SELECT ObjectID FROM	AuditLog WHERE  AuditLogID	=	@p_AuditLogID)
	AND		A.OperationDateTime <= (SELECT OperationDateTime FROM	AuditLog WHERE  AuditLogID	=	@p_AuditLogID)
	ORDER BY	A.OperationDateTime DESC

END
GO

--IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'AddAuditPreImage') AND TYPE IN (N'P'))
--DROP PROCEDURE AddAuditPreImage
--GO

--CREATE PROCEDURE AddAuditPreImage
--(
--	@p_AuditLogID BIGINT,
--	@p_PreImage XML,
--	@p_UserID INT,
--	@p_UserRoleID INT,
--	@p_ScreenID SMALLINT,
--	@p_AccessPoint VARCHAR(25)
--)
------WITH ENCRYPTION
--AS
--BEGIN

--	INSERT INTO AuditPreImage
--			(	AuditLogID,PreImage	)
--		VALUES
--			(	@p_AuditLogID,@p_PreImage	);

--	DECLARE
--			@AuditLogID		BIGINT,
--			@IsDetailAudit	BIT,
--			@ObjectID		VARCHAR(50)			-- PK/UK column(s separated by |)

--	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_AuditLogID)
--	EXEC InsertAuditLog @p_UserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'I', @p_AccessPoint , @AuditLogID OUT, @IsDetailAudit OUT;


--END
--GO

--IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'UpdateAuditPreImage') AND TYPE IN (N'P'))
--DROP PROCEDURE UpdateAuditPreImage
--GO

--CREATE PROCEDURE UpdateAuditPreImage
--(
--	@p_AuditLogID	BIGINT,
--	@p_PreImage	XML,
--	@p_UserID INT,
--	@p_UserRoleID INT,
--	@p_ScreenID SMALLINT,
--	@p_AccessPoint VARCHAR(25)
--)
------WITH ENCRYPTION
--AS
--BEGIN

--	DECLARE
--			@AuditLogID		BIGINT,
--			@IsDetailAudit	BIT,
--			@ObjectID		VARCHAR(50),			-- PK/UK column(s separated by |)
--			@PreImage		XML

--	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_AuditLogID)
--	EXEC InsertAuditLog @p_UserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'U', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

--	IF(@IsDetailAudit = 1)
--	BEGIN

--		SET @PreImage = (	SELECT	PreImage
--							FROM	AuditPreImage
--							WHERE	AuditLogID	= @p_AuditLogID
--							FOR XML AUTO
--						);

--		INSERT INTO  AuditPreImage
--					(    AuditLogID, PreImage    )
--				VALUES
--					(    @AuditLogID, @PreImage     )

--	END

--	UPDATE	AuditPreImage
--		 SET	PreImage	= @p_PreImage
--	WHERE	AuditLogID	= @p_AuditLogID

--	IF(@@ROWCOUNT = 0)
--		 RAISERROR('No Record found for Audit Pre Image',16,1)
--END
--GO

--IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'DeleteAuditPreImage') AND TYPE IN (N'P'))
--DROP PROCEDURE DeleteAuditPreImage
--GO

--CREATE PROCEDURE DeleteAuditPreImage
--(
--	@p_AuditLogID BIGINT,
--	@p_UserID INT,
--	@p_UserRoleID INT,
--	@p_ScreenID SMALLINT,
--	@p_AccessPoint VARCHAR(25)
--)
------WITH ENCRYPTION
--AS
--BEGIN

--	DECLARE
--			@AuditLogID		BIGINT,
--			@IsDetailAudit	BIT,
--			@ObjectID		VARCHAR(50),			-- PK/UK column(s separated by |)
--			@PreImage		XML

--	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_AuditLogID)
--	EXEC InsertAuditLog @p_UserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'D', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

--	IF(@IsDetailAudit = 1)
--	BEGIN

--		SET @PreImage = (	SELECT	PreImage
--							FROM	AuditPreImage
--							WHERE	AuditLogID	= @p_AuditLogID
--							FOR XML AUTO
--						);

--		INSERT INTO  AuditPreImage
--					(    AuditLogID, PreImage    )
--				VALUES
--					(    @AuditLogID, @PreImage     )

--	END

--	DELETE
--	FROM	AuditPreImage
--	WHERE	AuditLogID	= @p_AuditLogID

--	IF(@@ROWCOUNT = 0)
--		 RAISERROR('No Record found for Audit Pre Image',16,1)
--END
--GO

--IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetAuditPreImage') AND TYPE IN (N'P'))
--DROP PROCEDURE GetAuditPreImage
--GO

--CREATE PROCEDURE GetAuditPreImage
--(
--	@p_AuditLogID BIGINT
--)
------WITH ENCRYPTION
--AS
--BEGIN
--	SELECT	AuditLogID,
--			PreImage
--	 FROM	AuditPreImage
--	WHERE	(	AuditLogID	=	@p_AuditLogID			
--			OR	@p_AuditLogID	IS NULL
--			)
--	--AND		(	PreImage	=	@p_PreImage			
--	--		OR	@p_PreImage	IS NULL
--	--		)

--END
--GO

-- 08B0BB5138BD1798846EF02326F38C