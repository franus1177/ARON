
IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'AddInvoice') AND TYPE IN (N'P'))
DROP PROCEDURE AddInvoice
GO

CREATE PROCEDURE AddInvoice
(
	@p_CustomerID			CustomerID		/*SMALLINT*/,
	@p_OrderDate			SMALLDATETIME,
	@p_ExpectedDeliveryDate	DATE,
	@p_InvoiceName			GenericName		/*NVARCHAR(50)*/,
	@p_Frame				GenericName		/*NVARCHAR(50)*/,
	@p_Lens					GenericName		/*NVARCHAR(50)*/,
	@p_FrameAmount			DECIMAL(10,2),
	@p_LensAmount			DECIMAL(10,2),
	@p_RefractionBy			GenericName		/*NVARCHAR(50)*/,
	@p_Remarks				ShortRemarks	/*NVARCHAR(100)*/,
	@p_RESPH				VARCHAR(10),
	@p_RECYL				VARCHAR(10),
	@p_REAXIS				VARCHAR(10),
	@p_REVA					VARCHAR(10),
	@p_READD				VARCHAR(10),
	@p_LESPH				VARCHAR(10),
	@p_LECYL				VARCHAR(10),
	@p_LEAXIS				VARCHAR(10),
	@p_LEVA					VARCHAR(10),
	@p_LEADD				VARCHAR(10),

	@p_AdvanceAmount		SMALLINT = 0,
	@p_IsDelivery			BIT = 0,

	@p_EndUserID			INT,
	@p_UserRoleID			INT,
	@p_ScreenID				SMALLINT,
	@p_AccessPoint			VARCHAR(25),
	@p_InvoiceID			INT OUTPUT
)
----WITH ENCRYPTION
AS
BEGIN
	
	DECLARE @P_TotalAmount		DECIMAL(10,2),	
			@P_PendingAmount	DECIMAL(10,2)	

	SET @P_TotalAmount   = ISNULL(@p_FrameAmount,0)+ISNULL(@p_LensAmount,0)
	SET @P_PendingAmount = @P_TotalAmount - ISNULL(@p_AdvanceAmount,0)

	INSERT INTO Invoice
			(	CustomerID,OrderDate,ExpectedDeliveryDate,InvoiceName,Frame,Lens,FrameAmount,LensAmount,RefractionBy,Remarks,RESPH,RECYL,REAXIS,REVA,READD,LESPH,LECYL,LEAXIS,LEVA,LEADD,AdvanceAmount,TotalAmount, PendingAmount,IsDelivery	)
		VALUES
			(	@p_CustomerID,@p_OrderDate,@p_ExpectedDeliveryDate,@p_InvoiceName,@p_Frame,@p_Lens,@p_FrameAmount,@p_LensAmount,@p_RefractionBy,@p_Remarks,@p_RESPH,@p_RECYL,@p_REAXIS,@p_REVA,@p_READD,@p_LESPH,@p_LECYL,@p_LEAXIS,@p_LEVA,@p_LEADD,@p_AdvanceAmount,@P_TotalAmount,@P_PendingAmount,@p_IsDelivery	);

	SET @p_InvoiceID = SCOPE_IDENTITY();

	IF (@p_InvoiceID > 0)
	BEGIN
		--==Audit Log====================================================================================================================
		DECLARE
				@AuditLogID		BIGINT,
				@IsDetailAudit	BIT,
				@ObjectID		VARCHAR(50)			-- PK/UK column(s separated by |)

		SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_InvoiceID)
		EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'I', @p_AccessPoint , @AuditLogID OUT, @IsDetailAudit OUT;

	END
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'UpdateInvoice') AND TYPE IN (N'P'))
DROP PROCEDURE UpdateInvoice
GO

CREATE PROCEDURE UpdateInvoice
(
	@p_InvoiceID			INT,
	@p_CustomerID			CustomerID		/*SMALLINT*/,
	@p_OrderDate			SMALLDATETIME,
	@p_ExpectedDeliveryDate	DATE,
	@p_InvoiceName			GenericName		/*NVARCHAR(50)*/,
	@p_Frame				GenericName		/*NVARCHAR(50)*/,
	@p_Lens					GenericName		/*NVARCHAR(50)*/,
	@p_FrameAmount			DECIMAL(10,2),
	@p_LensAmount			DECIMAL(10,2),
	@p_RefractionBy			GenericName		/*NVARCHAR(50)*/,
	@p_Remarks				ShortRemarks	/*NVARCHAR(100)*/,

	@p_RESPH				VARCHAR(10),
	@p_RECYL				VARCHAR(10),
	@p_REAXIS				VARCHAR(10),
	@p_REVA					VARCHAR(10),
	@p_READD				VARCHAR(10),
	@p_LESPH				VARCHAR(10),
	@p_LECYL				VARCHAR(10),
	@p_LEAXIS				VARCHAR(10),
	@p_LEVA					VARCHAR(10),
	@p_LEADD				VARCHAR(10),

	@p_AdvanceAmount		SMALLINT,
	@p_IsDelivery			BIT = 0,

	@p_EndUserID			INT,
	@p_UserRoleID			INT,
	@p_ScreenID				SMALLINT,
	@p_AccessPoint			VARCHAR(25)
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

	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_InvoiceID)
	EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'U', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

	--IF(@IsDetailAudit = 1)
	--BEGIN
	--	SET @PreImage = (	SELECT	CustomerID,OrderDate,ExpectedDeliveryDate,InvoiceName,Frame,Lens,FrameAmount,LensAmount,RefractionBy,Remarks,RESPH,RECYL,REAXIS,REVA,READD,LESPH,LECYL,LEAXIS,LEVA,LEADD
	--						FROM	Invoice
	--						WHERE	InvoiceID	= @p_InvoiceID
	--						FOR XML AUTO
	--					);

	--	IF(@PreImage IS NOT NULL)
	--		INSERT INTO  AuditPreImage
	--					(    AuditLogID, TableName, PreImage    )
	--				VALUES
	--					(    @AuditLogID, 'Invoice', @PreImage     )

	--END
	--== Audit Log End================================================================================================================

	DECLARE @P_TotalAmount		DECIMAL(10,2),	
			@P_PendingAmount	DECIMAL(10,2)	

	SET @P_TotalAmount   = ISNULL(@p_FrameAmount,0)+ISNULL(@p_LensAmount,0)
	SET @P_PendingAmount = @P_TotalAmount - ISNULL(@p_AdvanceAmount,0)

	UPDATE	Invoice
	 SET	CustomerID				= @p_CustomerID,
			OrderDate				= @p_OrderDate,
			ExpectedDeliveryDate	= @p_ExpectedDeliveryDate,
			InvoiceName				= @p_InvoiceName,
			Frame					= @p_Frame,
			Lens					= @p_Lens,
			FrameAmount				= @p_FrameAmount,
			LensAmount				= @p_LensAmount,
			RefractionBy			= @p_RefractionBy,
			Remarks					= @p_Remarks,
			RESPH					= @p_RESPH,
			RECYL					= @p_RECYL,
			REAXIS					= @p_REAXIS,
			REVA					= @p_REVA,
			READD					= @p_READD,
			LESPH					= @p_LESPH,
			LECYL					= @p_LECYL,
			LEAXIS					= @p_LEAXIS,
			LEVA					= @p_LEVA,
			LEADD					= @p_LEADD,
			AdvanceAmount			= @p_AdvanceAmount,
			TotalAmount				= @P_TotalAmount,
			PendingAmount			= @P_PendingAmount

	WHERE	InvoiceID				= @p_InvoiceID

	IF (@@ROWCOUNT = 0)
	BEGIN
		RAISERROR('No Record found for Invoice',16,1)
		RETURN -1;
	END

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'DeleteInvoice') AND TYPE IN (N'P'))
DROP PROCEDURE DeleteInvoice
GO

CREATE PROCEDURE DeleteInvoice
(
	@p_InvoiceID	INT,

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

	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_InvoiceID)
	EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'D', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

	--IF(@IsDetailAudit = 1)
	--BEGIN
	--	SET @PreImage = (	SELECT	CustomerID,OrderDate,ExpectedDeliveryDate,InvoiceName,Frame,Lens,FrameAmount,LensAmount,RefractionBy,Remarks,RESPH,RECYL,REAXIS,REVA,READD,LESPH,LECYL,LEAXIS,LEVA,LEADD
	--						FROM	Invoice
	--						WHERE	InvoiceID	= @p_InvoiceID
	--						FOR XML AUTO
	--					);

	--	IF(@PreImage IS NOT NULL)
	--		INSERT INTO  AuditPreImage
	--					(    AuditLogID, TableName, PreImage    )
	--				VALUES
	--					(    @AuditLogID, 'Invoice', @PreImage     )

	--END
	--== Audit Log End================================================================================================================

	DELETE
	FROM	Invoice
	WHERE	InvoiceID	= @p_InvoiceID

	IF (@@ROWCOUNT = 0)
	BEGIN
		RAISERROR('No Record found for Invoice',16,1)
		RETURN -1;
	END

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetInvoice') AND TYPE IN (N'P'))
DROP PROCEDURE GetInvoice
GO

CREATE PROCEDURE GetInvoice
(
	@p_InvoiceID			INT				= NULL,
	@p_CustomerID			CustomerID		= NULL	/*SMALLINT*/,
	@p_CustomerName			VARCHAR(100)	= NULL,
	@p_OrderDate			SMALLDATETIME	= NULL,
	@p_ExpectedDeliveryDate	DATE			= NULL,
	@P_IsDelivery			BIT				= NULL,

	@p_EndUserID			INT				= NULL,
	@p_UserRoleID			INT				= NULL,
	@p_ScreenID				SMALLINT		= NULL,
	@p_AccessPoint			VARCHAR(25)		= NULL
)
----WITH ENCRYPTION
AS
BEGIN
	SELECT	InvoiceID,
			Invoice.CustomerID,
			OrderDate,
			ExpectedDeliveryDate,
			InvoiceName,
			Frame,
			Lens,
			FrameAmount,
			LensAmount,
			RefractionBy,
			Remarks,
			RESPH,
			RECYL,
			REAXIS,
			REVA,
			READD,
			LESPH,
			LECYL,
			LEAXIS,
			LEVA,
			LEADD,
			AdvanceAmount,
			TotalAmount,
			PendingAmount,
			IsDelivery,

			eCustomer.ContactNumber,
			eCustomer.CustomerAddress,
			(CustomerName + COALESCE(' | ' + ContactNumber ,'') + COALESCE(' | ' + REPLACE(CONVERT(NVARCHAR,DOB, 106), ' ', '-'),'')) as GlobalID,
			eCustomer.CustomerName,
			eCustomer.DOB

	FROM	Invoice
	JOIN	eCustomer
				ON	Invoice.CustomerID = eCustomer.CustomerID
	WHERE	(	InvoiceID	=	@p_InvoiceID
			OR	@p_InvoiceID	IS NULL
			)
	AND		(	Invoice.CustomerID	=	@p_CustomerID
			OR	@p_CustomerID	IS NULL
			)
	AND		(	OrderDate	=	@p_OrderDate
			OR	@p_OrderDate	IS NULL
			)
	AND		(	ExpectedDeliveryDate	=	@p_ExpectedDeliveryDate
			OR	@p_ExpectedDeliveryDate	IS NULL
			)

END
GO

-- 7513282AE38A13DEDDEB5E8C046C02