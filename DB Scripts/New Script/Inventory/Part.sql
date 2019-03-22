
IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'AddPart') AND TYPE IN (N'P'))
DROP PROCEDURE AddPart
GO

CREATE PROCEDURE AddPart
(
	@p_PartName			NVARCHAR(200),
	@p_PartDescription	NVARCHAR(500),
	@p_PartVendor		NVARCHAR(50),
	@p_PartCost			DECIMAL(9,2),
	@p_PartQuantity		INT,

	@p_EndUserID INT,
	@p_UserRoleID INT,
	@p_ScreenID SMALLINT,
	@p_AccessPoint VARCHAR(25),
	@p_PartID	INT OUTPUT
)
------WITH ENCRYPTION
AS
BEGIN

	INSERT INTO Part
			(	PartName,PartDescription,PartVendor,PartCost,PartQuantity	)
		VALUES
			(	@p_PartName,@p_PartDescription,@p_PartVendor,@p_PartCost,@p_PartQuantity	);

	SET @p_PartID = SCOPE_IDENTITY();

	IF (@p_PartID > 0)
	BEGIN
		--==Audit Log====================================================================================================================
		DECLARE
				@AuditLogID		BIGINT,
				@IsDetailAudit	BIT,
				@ObjectID		VARCHAR(50)			-- PK/UK column(s separated by |)

		SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_PartID)
		EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'I', @p_AccessPoint , @AuditLogID OUT, @IsDetailAudit OUT;

	END
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'UpdatePart') AND TYPE IN (N'P'))
DROP PROCEDURE UpdatePart
GO

CREATE PROCEDURE UpdatePart
(
	@p_PartID	INT,
	@p_PartName	NVARCHAR(200),
	@p_PartDescription	NVARCHAR(500),
	@p_PartVendor	NVARCHAR(50),
	@p_PartCost	DECIMAL(9,2),
	@p_PartQuantity	INT,

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

	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_PartID)
	EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'U', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

	--IF(@IsDetailAudit = 1)
	--BEGIN
	--	SET @PreImage = (	SELECT	PartName,PartDescription,PartVendor,PartCost,PartQuantity
	--						FROM	Part
	--						WHERE	PartID	= @p_PartID
	--						FOR XML AUTO
	--					);

	--	IF(@PreImage IS NOT NULL)
	--		INSERT INTO  AuditPreImage
	--					(    AuditLogID,TableName, PreImage    )
	--				VALUES
	--					(    @AuditLogID,'Part', @PreImage     )

	--END
	--== Audit Log End================================================================================================================

	UPDATE	Part
	 SET	PartName	= @p_PartName,
			PartDescription	= @p_PartDescription,
			PartVendor	= @p_PartVendor,
			PartCost	= @p_PartCost,
			PartQuantity	= @p_PartQuantity
	WHERE	PartID	= @p_PartID

	IF (@@ROWCOUNT = 0)
	BEGIN
		RAISERROR('No Record found for Part',16,1)
		RETURN -1;
	END

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'DeletePart') AND TYPE IN (N'P'))
DROP PROCEDURE DeletePart
GO

CREATE PROCEDURE DeletePart
(
	@p_PartID	INT,

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

	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_PartID)
	EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'D', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

	--IF(@IsDetailAudit = 1)
	--BEGIN
	--	SET @PreImage = (	SELECT	PartName,PartDescription,PartVendor,PartCost,PartQuantity
	--						FROM	Part
	--						WHERE	PartID	= @p_PartID
	--						FOR XML AUTO
	--					);

	--	IF(@PreImage IS NOT NULL)
	--		INSERT INTO  AuditPreImage
	--					(    AuditLogID,TableName, PreImage    )
	--				VALUES
	--					(    @AuditLogID,'Part', @PreImage     )

	--END
	--== Audit Log End================================================================================================================

	DELETE
	FROM	Part
	WHERE	PartID	= @p_PartID

	IF (@@ROWCOUNT = 0)
	BEGIN
		RAISERROR('No Record found for Part',16,1)
		RETURN -1;
	END

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetPart') AND TYPE IN (N'P'))
DROP PROCEDURE GetPart
GO

CREATE PROCEDURE GetPart
(
	@p_PartID			INT,
	@p_PartName			NVARCHAR(200),
	@p_PartDescription	NVARCHAR(500),
	@p_PartVendor		NVARCHAR(50),
	@p_PartCost			DECIMAL(9,2),
	@p_PartQuantity		INT
)
------WITH ENCRYPTION
AS
BEGIN
	SELECT	PartID,
			PartName,
			PartDescription,
			PartVendor,
			PartCost,
			PartQuantity
	FROM	Part
	WHERE	(	PartID	=	@p_PartID
			OR	@p_PartID	IS NULL
			)
	AND		(	PartName LIKE  N'%' + COALESCE(@p_PartName, N'') +  N'%'
			OR	@p_PartName	IS NULL
			)
	AND		(	PartDescription LIKE  N'%' + COALESCE(@p_PartDescription, N'') +  N'%'
			OR	@p_PartDescription	IS NULL
			)
	AND		(	PartVendor LIKE  N'%' + COALESCE(@p_PartVendor, N'') +  N'%'
			OR	@p_PartVendor	IS NULL
			)
	AND		(	PartCost	=	@p_PartCost
			OR	@p_PartCost	IS NULL
			)
	AND		(	PartQuantity	=	@p_PartQuantity
			OR	@p_PartQuantity	IS NULL
			)

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetPartDDL') AND TYPE IN (N'P'))
DROP PROCEDURE GetPartDDL
GO

CREATE PROCEDURE GetPartDDL
(
	@p_PartName	NVARCHAR(500)
)
------WITH ENCRYPTION
AS
BEGIN
	SELECT	PartID,
			PartName--,
			--PartDescription,
			--PartVendor,
			--PartCost,
			--PartQuantity
	FROM	Part
	WHERE	--(	PartID	=	@p_PartID
			--OR	@p_PartID	IS NULL
			--)
	--AND		
			(	PartName LIKE  N'%' + COALESCE(@p_PartName, N'') +  N'%'
			OR	@p_PartName	IS NULL
			)
	--AND		(	PartDescription LIKE  N'%' + COALESCE(@p_PartDescription, N'') +  N'%'
	--		OR	@p_PartDescription	IS NULL
	--		)
	--AND		(	PartVendor LIKE  N'%' + COALESCE(@p_PartVendor, N'') +  N'%'
	--		OR	@p_PartVendor	IS NULL
	--		)
	--AND		(	PartCost	=	@p_PartCost
	--		OR	@p_PartCost	IS NULL
	--		)
	--AND		(	PartQuantity	=	@p_PartQuantity
	--		OR	@p_PartQuantity	IS NULL
	--		)
	ORDER BY PartName
END
GO

-- FF2D7A2E53F090738B69B97B36D6DF