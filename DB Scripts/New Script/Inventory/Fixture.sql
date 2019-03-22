--IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'FixturePart_TableType' AND is_table_type = 1)
--DROP TYPE FixturePart_TableType
--GO

--CREATE TYPE FixturePart_TableType AS TABLE(
--	FixturePartID	AttributeID			NULL,
--	FixtureID		INT					NULL,
--	PartID			INT				NOT	NULL,
--	Quantity		DECIMAL(9,2)	NOT	NULL
--)
--GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'AddFixture') AND TYPE IN (N'P'))
DROP PROCEDURE AddFixture
GO

CREATE PROCEDURE AddFixture
(
	@p_FixtureName	NVARCHAR(200),
	@p_FixtureCost	DECIMAL(9,2),
	@p_FixtureCode  NVARCHAR(50),
	@p_FixturePart	FixturePart_TableType	 READONLY,

	@p_EndUserID INT,
	@p_UserRoleID INT,
	@p_ScreenID SMALLINT,
	@p_AccessPoint VARCHAR(25),
	@p_FixtureID	INT OUTPUT
)
AS
BEGIN

	INSERT INTO Fixture
			(	FixtureName,FixtureCost,FixtureCode	)
		VALUES
			(	@p_FixtureName,@p_FixtureCost,@p_FixtureCode	);

	SET @p_FixtureID = SCOPE_IDENTITY();

	IF (@p_FixtureID > 0)
	BEGIN

		INSERT INTO FixturePart
				(	FixtureID,PartID,Quantity	)
			SELECT	@p_FixtureID,PartID,Quantity
			FROM	@p_FixturePart

		UPDATE Fixture
		SET FixtureCost = ISNULL((	SELECT	sum(ISNULL(P.PartCost,0) * ISNULL(FP.Quantity,0))
									FROM	Part P
									JOIN	@p_FixturePart FP
												ON	P.PartID = FP.PartID
									--WHERE	FP.Quantity > 0
									--and      P.PartCost > 0
								  ),0)
		
		WHERE FixtureID = @p_FixtureID

		--==Audit Log====================================================================================================================
		DECLARE	@AuditLogID		BIGINT,
				@IsDetailAudit	BIT,
				@ObjectID		VARCHAR(50)			-- PK/UK column(s separated by |)

		SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_FixtureID)
		EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'I', @p_AccessPoint , @AuditLogID OUT, @IsDetailAudit OUT;

	END
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'UpdateFixture') AND TYPE IN (N'P'))
DROP PROCEDURE UpdateFixture
GO

CREATE PROCEDURE UpdateFixture
(
	@p_FixtureID	INT,
	@p_FixtureName	NVARCHAR(200),
	@p_FixtureCost	DECIMAL(9,2),
	@p_FixtureCode  NVARCHAR(50),
	@p_FixturePart	FixturePart_TableType	 READONLY,

	@p_EndUserID INT,
	@p_UserRoleID INT,
	@p_ScreenID SMALLINT,
	@p_AccessPoint VARCHAR(25)
)
AS
BEGIN
	--== Audit Log Start================================================================================================================
	DECLARE @AuditLogID		BIGINT,
			@IsDetailAudit	BIT,
			@ObjectID		VARCHAR(50),			-- PK/UK column(s separated by |)
			@PreImage		XML

	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_FixtureID)
	EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'U', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

	--IF(@IsDetailAudit = 1)
	--BEGIN
	--	SET @PreImage = (	SELECT	FixtureName,FixtureCost
	--						FROM	Fixture
	--						WHERE	FixtureID	= @p_FixtureID
	--						FOR XML AUTO
	--					);

	--	IF(@PreImage IS NOT NULL)
	--		INSERT INTO  AuditPreImage
	--					(    AuditLogID,TableName, PreImage    )
	--				VALUES
	--					(    @AuditLogID,'Fixture', @PreImage     )

	--	SET @PreImage = (	SELECT	FixturePartID,FixtureID,PartID,Quantity
	--						FROM	FixturePart
	--						WHERE	FixtureID	= @p_FixtureID
	--						FOR XML AUTO
	--					);

	--	IF(@PreImage IS NOT NULL)
	--		INSERT INTO  AuditPreImage
	--				(    AuditLogID, TableName, PreImage    )
	--			VALUES
	--				(    @AuditLogID, 'FixturePart', @PreImage     )

	--END
	--== Audit Log End================================================================================================================

	UPDATE	Fixture
	 SET	FixtureName	= @p_FixtureName,
			FixtureCost	= @p_FixtureCost,
			FixtureCode = @p_FixtureCode
	WHERE	FixtureID	= @p_FixtureID

	IF (@@ROWCOUNT = 0)
	BEGIN
		RAISERROR('No Record found for Fixture',16,1)
		RETURN -1;
	END
	
	UPDATE	A    
	SET		A.Quantity = B.Quantity   
	FROM	FixturePart A
	JOIN	@p_FixturePart B
				ON A.FixturePartID = B.FixturePartID
	where	B.FixturePartID IS NOT NULL

	INSERT INTO FixturePart
				(	FixtureID,PartID,Quantity	)
		SELECT	@p_FixtureID,PartID,Quantity
		FROM	@p_FixturePart
		WHERE	FixturePartID IS NULL

	DELETE FROM FixturePart	
	WHERE 	FixturePartID NOT IN (	SELECT	FixturePartID
									FROM	@p_FixturePart
								 )
	AND FixtureID	= @p_FixtureID


	UPDATE Fixture
	SET FixtureCost = ISNULL((	SELECT	sum(ISNULL(P.PartCost,0) * ISNULL(FP.Quantity,0))
								FROM	Part P
								JOIN	@p_FixturePart FP
											ON	P.PartID = FP.PartID
								--WHERE	FP.Quantity > 0
								--and      P.PartCost > 0
								),0)
		
	WHERE FixtureID = @p_FixtureID

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'DeleteFixture') AND TYPE IN (N'P'))
DROP PROCEDURE DeleteFixture
GO

CREATE PROCEDURE DeleteFixture
(
	@p_FixtureID	INT,

	@p_EndUserID INT,
	@p_UserRoleID INT,
	@p_ScreenID SMALLINT,
	@p_AccessPoint VARCHAR(25)
)
AS
BEGIN
	--== Audit Log Start================================================================================================================
	DECLARE @AuditLogID		BIGINT,
			@IsDetailAudit	BIT,
			@ObjectID		VARCHAR(50),			-- PK/UK column(s separated by |)
			@PreImage		XML

	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_FixtureID)
	EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'D', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

	--IF(@IsDetailAudit = 1)
	--BEGIN
	--	SET @PreImage = (	SELECT	FixtureName,FixtureCost
	--						FROM	Fixture
	--						WHERE	FixtureID	= @p_FixtureID
	--						FOR XML AUTO
	--					);

	--	IF(@PreImage IS NOT NULL)
	--		INSERT INTO  AuditPreImage
	--					(    AuditLogID,TableName, PreImage    )
	--				VALUES
	--					(    @AuditLogID,'Fixture', @PreImage     )

	--	SET @PreImage = (	SELECT	FixturePartID,FixtureID,PartID,Quantity
	--						FROM	FixturePart
	--						WHERE	FixtureID	= @p_FixtureID
	--						FOR XML AUTO
	--					);

	--	IF(@PreImage IS NOT NULL)
	--		INSERT INTO  AuditPreImage
	--				(    AuditLogID, TableName, PreImage    )
	--			VALUES
	--				(    @AuditLogID, 'FixturePart', @PreImage     )

	--END
	--== Audit Log End================================================================================================================

	DELETE
	FROM	FixturePart
	WHERE	FixtureID	= @p_FixtureID

	DELETE
	FROM	Fixture
	WHERE	FixtureID	= @p_FixtureID

	IF (@@ROWCOUNT = 0)
	BEGIN
		RAISERROR('No Record found for Fixture',16,1)
		RETURN -1;
	END

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetFixture') AND TYPE IN (N'P'))
DROP PROCEDURE GetFixture
GO
-- GetFixture 1,NULL,NULL,1
-- GetFixture 3,NULL,NULL,1
CREATE PROCEDURE GetFixture
(
	@p_FixtureID		INT = null,
	@p_FixtureName		NVARCHAR(200) = null,
	@p_FixtureCost		DECIMAL(9,2) = null,
	@p_FixtureCode		NVARCHAR(50) = null,
	@p_IsChildResult	BIT = null

)
AS
BEGIN
	SELECT	FixtureID,
			FixtureName,
			FixtureCost,
			FixtureCode
	FROM	Fixture
	WHERE	(	FixtureID	=	@p_FixtureID
			OR	@p_FixtureID	IS NULL
			)
	AND		FixtureName LIKE  N'%' + COALESCE(@p_FixtureName, N'') +  N'%'
	AND		(	FixtureCost	=	@p_FixtureCost
			OR	@p_FixtureCost	IS NULL
			)
	
	IF(@@ROWCOUNT = 1 AND @p_IsChildResult = 1)
		SELECT		(SELECT TOP 1 FixturePartID	FROM FixturePart b WHERE a.PartID = b.PartID AND b.FixtureID	= @p_FixtureID) AS FixturePartID,
					(SELECT TOP 1 FixtureID		FROM FixturePart b WHERE a.PartID = b.PartID AND b.FixtureID	= @p_FixtureID) AS FixtureID,
					(SELECT TOP 1 Quantity		FROM FixturePart b WHERE a.PartID = b.PartID AND b.FixtureID	= @p_FixtureID) AS Quantity,

					a.PartID,
					a.PartName--,
					--a.PartDescription,
					--a.PartVendor,
					--a.PartCost,
					--a.PartQuantity

		FROM		Part a

END
GO

-- 263448407FAF94E45685455391F6AE