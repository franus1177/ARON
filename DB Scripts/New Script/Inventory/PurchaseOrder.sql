--create type POItem_TableType AS TABLE(	FixtureID			INT				NOT NULL,
--											POFixtureQuantity	INT				NOT NULL,
--											FixtureCommission	FLOAT 			    NULL,
--											FixturePrice		DECIMAL(10,2)		NULL
--										)
--go


--create type POPart_TableType AS TABLE  (	POPartID			INT				    NULL,
--											PartID				INT				NOT NULL,
--											Quantity			DECIMAL(10,2)	NOT	NULL
--										)
--go


IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'AddPurchaseOrder') AND TYPE IN (N'P'))
DROP PROCEDURE AddPurchaseOrder
GO

CREATE PROCEDURE AddPurchaseOrder
(
	@p_PONumber			NVARCHAR(50),
	@p_POItemID			INT,
	@p_PORecDate		DATE,
	@p_POEstShipDate	DATE,
	@p_POActShipDate	DATE,
	@p_POCost			DECIMAL(9,2),
	@p_POPrice			DECIMAL(9,2),
	@p_POCompleted		BIT,
	@p_CreatedAt		SMALLDATETIME,
	@p_POPartID			INT,
	@p_CustomerID		INT				= null,
	@p_CustomerName		NVARCHAR(200)	= null,

	@p_POItem			POItem_TableType READONLY,
	@p_POPart			POPart_TableType READONLY,
	@p_EndUserID		INT,
	@p_UserRoleID		INT,
	@p_ScreenID			SMALLINT,
	@p_AccessPoint		VARCHAR(25),
	@p_POID				INT OUTPUT
)
----WITH ENCRYPTION
AS
BEGIN
	
	if ( @p_CustomerID is null and @p_CustomerName is not null )
	begin
		set @p_CustomerID = (select top 1 CustomerID from Customer where lower(CustomerName) = lower(@p_CustomerName))
	end
	--else 
	if ( @p_CustomerID is null and @p_CustomerName is not null )
	BEGIN
		insert into Customer (  CustomerName,
								Remarks,
								AccountManagerID,
								EffectiveFromDate,
								EffectiveTillDate)values(@p_CustomerName,'Auto Created',@p_EndUserID,getUTCdate(),null)
	
		SET @p_CustomerID = SCOPE_IDENTITY();
	END
	else if not exists(select top 1 1 from Customer where CustomerID = @p_CustomerID and lower(CustomerName) = lower(@p_CustomerName)) and @p_CustomerID is not null
	BEGIN
		insert into Customer (  CustomerName,
								Remarks,
								AccountManagerID,
								EffectiveFromDate,
								EffectiveTillDate)values(@p_CustomerName,'Auto Created',@p_EndUserID,getUTCdate(),null)
	
		SET @p_CustomerID = SCOPE_IDENTITY();
	END

	INSERT INTO PurchaseOrder
			(	PONumber,POItemID,PORecDate,POEstShipDate,POActShipDate,POCost,POPrice,POCompleted,CreatedAt,POPartID,CustomerID	)
		VALUES
			(	@p_PONumber,@p_POItemID,@p_PORecDate,@p_POEstShipDate,@p_POActShipDate,@p_POCost,@p_POPrice,@p_POCompleted,getUTCdate(),@p_POPartID,@p_CustomerID	);

	SET @p_POID = SCOPE_IDENTITY();

	IF (@p_POID > 0)
	BEGIN
		
		INSERT INTO POFixture
				(	POID, FixtureID, FixturePrice, FixtureCommision, FixtureQuantity	)
			SELECT	@p_POID, FixtureID, FixturePrice, FixtureCommission, POFixtureQuantity
			FROM	@p_POItem c
			WHERE	c.POFixtureQuantity > 0
		
		--delete from POPart where POID = @p_POID;
		INSERT INTO POPart
				(	PartID, Quantity,  POID	)
		 select a.PartID,a.Quantity, @p_POID 
		 from @p_POPart a

		update PurchaseOrder set POCost  =  isnull((select	sum((fp.Quantity*p.PartCost) * pof.FixtureQuantity)  
		from	POFixture pof 
		join	FixturePart fp  on fp.FixtureID = pof.FixtureID 
		join	Part		 p	on p.PartID		= fp.PartID 

		where pof.POID = PurchaseOrder.POID),0)
										  + isnull((select	sum(Part.PartCost*POPart.Quantity)
													from	POPart
													JOIN	Part
																ON	POPart.PartID = Part.PartID

													where POPart.POID = PurchaseOrder.POID),0)
		where PurchaseOrder.POID = @p_POID

		update PurchaseOrder set POPrice =  isnull((select sum(FixturePrice)                 from POFixture where POFixture.POID = PurchaseOrder.POID),0)
		where PurchaseOrder.POID = @p_POID

		--==Audit Log====================================================================================================================
		DECLARE	@AuditLogID		BIGINT,
				@IsDetailAudit	BIT,
				@ObjectID		VARCHAR(50)	-- PK/UK column(s separated by |)

		SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_POID)
		EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'I', @p_AccessPoint , @AuditLogID OUT, @IsDetailAudit OUT;

	END
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'UpdatePurchaseOrder') AND TYPE IN (N'P'))
DROP PROCEDURE UpdatePurchaseOrder
GO

CREATE PROCEDURE UpdatePurchaseOrder
(
	@p_POID				INT,
	@p_PONumber			NVARCHAR(50),
	@p_POItemID			INT,
	@p_PORecDate		DATE,
	@p_POEstShipDate	DATE,
	@p_POActShipDate	DATE,
	@p_POCost			DECIMAL(9,2),
	@p_POPrice			DECIMAL(9,2),
	@p_POCompleted		BIT,
	@p_CreatedAt		SMALLDATETIME,
	@p_POPartID			INT,

	@p_CustomerID		INT				= null,
	@p_CustomerName		NVARCHAR(200)	= null,
	
	@p_POItem			POItem_TableType	 READONLY,
	@p_POPart			POPart_TableType	 READONLY,

	@p_EndUserID INT,
	@p_UserRoleID INT,
	@p_ScreenID SMALLINT,
	@p_AccessPoint VARCHAR(25)
)
----WITH ENCRYPTION
AS
BEGIN
	--== Audit Log Start================================================================================================================
	DECLARE @AuditLogID		BIGINT,
			@IsDetailAudit	BIT,
			@ObjectID		VARCHAR(50),			-- PK/UK column(s separated by |)
			@PreImage		XML

	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_POID)
	EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'U', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;


	if ( @p_CustomerID is null and @p_CustomerName is not null )
	begin
		set @p_CustomerID = (select top 1 CustomerID from Customer where lower(CustomerName) = lower(@p_CustomerName))
	end
	--else 
	if ( @p_CustomerID is null and @p_CustomerName is not null )
	BEGIN
		insert into Customer (  CustomerName,
								Remarks,
								AccountManagerID,
								EffectiveFromDate,
								EffectiveTillDate)values(@p_CustomerName,'Auto Created',@p_EndUserID,getUTCdate(),null)
	
		SET @p_CustomerID = SCOPE_IDENTITY();
	END
	else if not exists(select top 1 1 from Customer where CustomerID = @p_CustomerID and lower(CustomerName) = lower(@p_CustomerName)) and @p_CustomerID is not null
	BEGIN
		insert into Customer (  CustomerName,
								Remarks,
								AccountManagerID,
								EffectiveFromDate,
								EffectiveTillDate)values(@p_CustomerName,'Auto Created',@p_EndUserID,getUTCdate(),null)
	
		SET @p_CustomerID = SCOPE_IDENTITY();
	END

	UPDATE	PurchaseOrder
	 SET	--PONumber		= @p_PONumber,
			--POItemID		= @p_POItemID,
			PORecDate		= @p_PORecDate,
			POEstShipDate	= @p_POEstShipDate,
			POActShipDate	= @p_POActShipDate,
			POCompleted		= @p_POCompleted
			--,CustomerID		= @p_CustomerID

	WHERE	POID			= @p_POID

	DELETE FROM POFixture WHERE POID = @p_POID
	INSERT INTO POFixture
			(	POID, FixtureID,FixturePrice,FixtureCommision,FixtureQuantity	)
		SELECT	@p_POID, FixtureID, FixturePrice, FixtureCommission, POFixtureQuantity
		FROM	@p_POItem c
		WHERE	c.POFixtureQuantity > 0

	DELETE from POPart WHERE POID = @p_POID;
	INSERT INTO POPart
			(	PartID, Quantity,  POID	)
		SELECT a.PartID,a.Quantity, @p_POID 
		FROM @p_POPart a

		UPDATE PurchaseOrder set POCost  =  ISNULL((SELECT	SUM(FixturePrice *FixtureQuantity) from POFixture where POFixture.POID = PurchaseOrder.POID),0)
										  + ISNULL((SELECT	SUM(Part.PartCost*POPart.Quantity)
													FROM	POPart
													JOIN	Part
																ON	POPart.PartID = Part.PartID

													where POPart.POID = PurchaseOrder.POID),0)
		where PurchaseOrder.POID = @p_POID

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'DeletePurchaseOrder') AND TYPE IN (N'P'))
DROP PROCEDURE DeletePurchaseOrder
GO

CREATE PROCEDURE DeletePurchaseOrder
(
	@p_POID			INT,

	@p_EndUserID	INT,
	@p_UserRoleID	INT,
	@p_ScreenID		SMALLINT,
	@p_AccessPoint	VARCHAR(25)
)
----WITH ENCRYPTION
AS
BEGIN
	--== Audit Log Start================================================================================================================
	DECLARE @AuditLogID		BIGINT,
			@IsDetailAudit	BIT,
			@ObjectID		VARCHAR(50),			-- PK/UK column(s separated by |)
			@PreImage		XML

	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_POID)
	EXEC InsertAuditLog @p_EndUserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'D', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

	DELETE
	FROM	POFixture
	WHERE	POID	= @p_POID

	DELETE
	FROM	POPart 
	WHERE	POID	= @p_POID
	
	DELETE
	FROM	PurchaseOrder
	WHERE	POID	= @p_POID

	IF (@@ROWCOUNT = 0)
	BEGIN
		RAISERROR('No Record found for Purchase Order',16,1)
		RETURN -1;
	END

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetPurchaseOrder') AND TYPE IN (N'P'))
DROP PROCEDURE GetPurchaseOrder
GO
-- GetPurchaseOrder 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,1, NULL, NULL, NULL, NULL		
CREATE PROCEDURE GetPurchaseOrder
(
	@p_POID				INT,
	@p_PONumber			NVARCHAR(50),
	@p_POItemID			INT,
	@p_PORecDate		DATE,
	@p_POEstShipDate	DATE,
	@p_POActShipDate	DATE,
	@p_POCost			DECIMAL(9,2),
	@p_POPrice			DECIMAL(9,2),
	@p_POCompleted		BIT,
	@p_CreatedAt		SMALLDATETIME,
	@p_POPartID			INT,
	@p_CustomerID		INT				= null,
	@p_CustomerName		NVARCHAR(200)	= null,

	@p_IsChildResult	BIT,

	@p_EndUserID		INT,
	@p_UserRoleID		INT,
	@p_ScreenID			SMALLINT,
	@p_AccessPoint		VARCHAR(25)
)
------WITH ENCRYPTION
AS
BEGIN
	
	SELECT	PurchaseOrder.POID,
			PurchaseOrder.PONumber,
			PurchaseOrder.POItemID,
			PurchaseOrder.PORecDate,
			PurchaseOrder.POEstShipDate,
			PurchaseOrder.POActShipDate,
			PurchaseOrder.POCost,
			PurchaseOrder.POPrice,
			PurchaseOrder.POCompleted,
			PurchaseOrder.CreatedAt,
			PurchaseOrder.POPartID,
			Convert(int,PurchaseOrder.CustomerID) as CustomerID,
			Customer.CustomerName

	FROM	PurchaseOrder
	JOIN	Customer
				ON PurchaseOrder.CustomerID = Customer.CustomerID
	WHERE	(	POID	=	@p_POID
			OR	@p_POID	IS NULL
			)
	AND		(	PONumber LIKE  N'%' + COALESCE(@p_PONumber, N'') +  N'%'
			OR	@p_PONumber	IS NULL
			)
	--AND		(	POItemID	=	@p_POItemID
	--		OR	@p_POItemID	IS NULL
	--		)
	--AND		(	PORecCate LIKE  N'%' + COALESCE(@p_PORecCate, N'') +  N'%'
	--		OR	@p_PORecCate	IS NULL
	--		)
	--AND		(	POEstShipDate	=	@p_POEstShipDate
	--		OR	@p_POEstShipDate	IS NULL
	--		)
	--AND		(	POActShipDate	=	@p_POActShipDate
	--		OR	@p_POActShipDate	IS NULL
	--		)
	--AND		(	POCost	=	@p_POCost
	--		OR	@p_POCost	IS NULL
	--		)
	--AND		(	POPrice	=	@p_POPrice
	--		OR	@p_POPrice	IS NULL
	--		)
	AND		(	POCompleted	=	@p_POCompleted
			OR	@p_POCompleted	IS NULL
			)
	--AND		(	CreatedAt	=	@p_CreatedAt
	--		OR	@p_CreatedAt	IS NULL
	--		)
	AND		(	Convert(int,PurchaseOrder.CustomerID) =	@p_CustomerID
			OR	@p_CustomerID	IS NULL
			)

	IF(@@ROWCOUNT = 1 AND @p_IsChildResult = 1)
	BEGIN
				
		SELECT	POFixture.POID,
				POFixture.FixtureID,
				POFixture.FixturePrice,
				POFixture.FixtureCommision,
				POFixture.FixtureQuantity AS POFixtureQuantity,
				POFixture.FixtureQuantityCompleted,
				POFixture.FixtureQuantityShipped,
				--POFixture.FixtureCost
				Fixture.FixtureCost

		FROM	POFixture
		JOIN	Fixture
					ON POFixture.FixtureID = Fixture.FixtureID
		WHERE	POID	= @p_POID

		SELECT		Part.PartID,
					Part.PartName,
					Part.PartDescription,
					Part.PartVendor,
					Part.PartCost,
					Part.PartQuantity,

					pp.POPartID,
					--pp.PartID,
					pp.Quantity

		FROM		Part
		JOIN		POPart pp
						ON	Part.PartID = pp.PartID
						AND pp.POID	=	@p_POID

	END
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetPurchaseOrderPart') AND TYPE IN (N'P'))
DROP PROCEDURE GetPurchaseOrderPart
GO
-- GetPurchaseOrderPart 2,0
CREATE PROCEDURE GetPurchaseOrderPart
(
	@p_POID		INT,
	@Flag		BIT = 0
)
------WITH ENCRYPTION
AS
BEGIN

	SELECT		Part.PartID,
				Part.PartName,
				Part.PartDescription,
				Part.PartVendor,
				Part.PartCost,
				Part.PartQuantity,

				pp.POPartID,
				pp.PartID,
				pp.Quantity

	FROM		Part
	LEFT JOIN	POPart pp
					ON	Part.PartID = pp.PartID
					and pp.POID	=	@p_POID
END
GO


IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'AddPurchaseOrderPart') AND TYPE IN (N'P'))
DROP PROCEDURE AddPurchaseOrderPart
GO

CREATE PROCEDURE AddPurchaseOrderPart
(
	@p_POID			INT,
	@p_POPart		POPart_TableType READONLY,

	@p_EndUserID	INT,
	@p_UserRoleID	INT,
	@p_ScreenID		SMALLINT,
	@p_AccessPoint	VARCHAR(25)
	
)
------WITH ENCRYPTION
AS
BEGIN
	
	delete from POPart where POID = @p_POID;

	INSERT INTO POPart
			(	PartID, Quantity,  POID	)
	 select a.PartID,a.Quantity, @p_POID 
	 from @p_POPart a
	 
END
GO
 
-- 21CEC9631E03FA4BD622D6D63F6855