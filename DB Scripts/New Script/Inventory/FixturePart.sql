
IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'AddFixturePart') AND TYPE IN (N'P'))
DROP PROCEDURE AddFixturePart
GO

CREATE PROCEDURE AddFixturePart
(
	@p_FixtureID	INT,
	@p_PartID	INT,
	@p_Quantity	INT,

	@p_EndUserID INT,
	@p_UserRoleID INT,
	@p_ScreenID SMALLINT,
	@p_AccessPoint VARCHAR(25),
	@p_FixturePartID	INT OUTPUT
)
------WITH ENCRYPTION
AS
BEGIN

	INSERT INTO FixturePart
			(	FixtureID,PartID,Quantity	)
		VALUES
			(	@p_FixtureID,@p_PartID,@p_Quantity	);

	SET @p_FixturePartID = SCOPE_IDENTITY();

	IF (@p_FixturePartID > 0)
	BEGIN
		--==Audit Log====================================================================================================================
		DECLARE
				@AuditLogID		BIGINT,
				@IsDetailAudit	BIT,
				@ObjectID		VARCHAR(50)			-- PK/UK column(s separated by |)

		SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_FixturePartID)
		EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'I', @p_AccessPoint , @AuditLogID OUT, @IsDetailAudit OUT;

	END
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'UpdateFixturePart') AND TYPE IN (N'P'))
DROP PROCEDURE UpdateFixturePart
GO

CREATE PROCEDURE UpdateFixturePart
(
	@p_FixturePartID	INT,
	@p_FixtureID	INT,
	@p_PartID	INT,
	@p_Quantity	INT,

	@p_EndUserID INT,
	@p_UserRoleID INT,
	@p_ScreenID SMALLINT,
	@p_AccessPoint VARCHAR(25)
)
------WITH ENCRYPTION
AS
BEGIN
	--== Audit Log Start================================================================================================================
	DECLARE
			@AuditLogID		BIGINT,
			@IsDetailAudit	BIT,
			@ObjectID		VARCHAR(50),			-- PK/UK column(s separated by |)
			@PreImage		XML

	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_FixturePartID)
	EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'U', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

	--IF(@IsDetailAudit = 1)
	--BEGIN
	--	SET @PreImage = (	SELECT	FixtureID,PartID,Quantity
	--						FROM	FixturePart
	--						WHERE	FixturePartID	= @p_FixturePartID
	--						FOR XML AUTO
	--					);

	--	IF(@PreImage IS NOT NULL)
	--		INSERT INTO  AuditPreImage
	--					(    AuditLogID,TableName, PreImage    )
	--				VALUES
	--					(    @AuditLogID,'FixturePart', @PreImage     )

	--END
	--== Audit Log End================================================================================================================

	UPDATE	FixturePart
	 SET	FixtureID	= @p_FixtureID,
			PartID	= @p_PartID,
			Quantity	= @p_Quantity
	WHERE	FixturePartID	= @p_FixturePartID

	IF (@@ROWCOUNT = 0)
	BEGIN
		RAISERROR('No Record found for Fixture Part',16,1)
		RETURN -1;
	END

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'DeleteFixturePart') AND TYPE IN (N'P'))
DROP PROCEDURE DeleteFixturePart
GO

CREATE PROCEDURE DeleteFixturePart
(
	@p_FixturePartID	INT,

	@p_EndUserID INT,
	@p_UserRoleID INT,
	@p_ScreenID SMALLINT,
	@p_AccessPoint VARCHAR(25)
)
------WITH ENCRYPTION
AS
BEGIN
	--== Audit Log Start================================================================================================================
	DECLARE
			@AuditLogID		BIGINT,
			@IsDetailAudit	BIT,
			@ObjectID		VARCHAR(50),			-- PK/UK column(s separated by |)
			@PreImage		XML

	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_FixturePartID)
	EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'D', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

	--IF(@IsDetailAudit = 1)
	--BEGIN
	--	SET @PreImage = (	SELECT	FixtureID,PartID,Quantity
	--						FROM	FixturePart
	--						WHERE	FixturePartID	= @p_FixturePartID
	--						FOR XML AUTO
	--					);

	--	IF(@PreImage IS NOT NULL)
	--		INSERT INTO  AuditPreImage
	--					(    AuditLogID,TableName, PreImage    )
	--				VALUES
	--					(    @AuditLogID,'FixturePart', @PreImage     )

	--END
	--== Audit Log End================================================================================================================

	DELETE
	FROM	FixturePart
	WHERE	FixturePartID	= @p_FixturePartID

	IF (@@ROWCOUNT = 0)
	BEGIN
		RAISERROR('No Record found for Fixture Part',16,1)
		RETURN -1;
	END

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetFixturePart') AND TYPE IN (N'P'))
DROP PROCEDURE GetFixturePart
GO

CREATE PROCEDURE GetFixturePart
(
	@p_FixturePartID	INT,
	@p_FixtureID		INT,
	@p_PartID			INT,
	@p_Quantity			INT

)
------WITH ENCRYPTION
AS
BEGIN
	SELECT	FixturePartID,
			FixtureID,
			PartID,
			Quantity
	FROM	FixturePart
	WHERE	(	FixturePartID	=	@p_FixturePartID
			OR	@p_FixturePartID	IS NULL
			)
	AND		(	FixtureID	=	@p_FixtureID
			OR	@p_FixtureID	IS NULL
			)
	AND		(	PartID	=	@p_PartID
			OR	@p_PartID	IS NULL
			)
	AND		(	Quantity	=	@p_Quantity
			OR	@p_Quantity	IS NULL
			)

END
GO

-- 960554B9C722DDE7F830810941A506