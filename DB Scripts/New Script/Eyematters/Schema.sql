USE eSafecTest

CREATE	TABLE	eCustomer
(
	CustomerID			CustomerID			NOT	NULL	IDENTITY (1, 1)
														CONSTRAINT	eCustomer_PK_CustomerID
															PRIMARY KEY	NONCLUSTERED,
	
	CustomerName		GenericName			NOT	NULL,	--CONSTRAINT	eCustomer_UK_CustomerName
															--UNIQUE	CLUSTERED,
	
	CustomerAddress		ShortRemarks			NULL,
	ContactNumber		GenericName				NULL,
	DOB					DATE					NULL,
	AnniversaryDate		DATE					NULL
)
GO

--ALTER TABLE eCustomer DROP Constraint eCustomer_UK_CustomerName

CREATE	TABLE	Invoice
(
	InvoiceID				INTEGER					NOT	NULL	IDENTITY (1, 1)
														CONSTRAINT	Invoice_PK_InvoiceID
															PRIMARY KEY	NONCLUSTERED,
	
	CustomerID				CustomerID				NOT	NULL	CONSTRAINT	Invoice_FK_CustomerID
															REFERENCES	eCustomer,
	
	OrderDate				SMALLDATETIME			NOT NULL,
	ExpectedDeliveryDate	DATE					NULL,
	InvoiceName				GenericName				NOT NULL,
	Frame					GenericName				NULL,
	Lens					GenericName				NULL,
	FrameAmount				Decimal(10,2)			NOT NULL,
	LensAmount				Decimal(10,2)			NOT NULL,
	RefractionBy			GenericName				NULL,
	Remarks					ShortRemarks			NULL,

	RESPH					VARCHAR(10)				NULL,
	RECYL					VARCHAR(10)				NULL,
	REAXIS					VARCHAR(10)				NULL,
	REVA					VARCHAR(10)				NULL,
	READD					VARCHAR(10)				NULL,

	LESPH					VARCHAR(10)				NULL,
	LECYL					VARCHAR(10)				NULL,
	LEAXIS					VARCHAR(10)				NULL,
	LEVA					VARCHAR(10)				NULL,
	LEADD					VARCHAR(10)				NULL,
	AdvanceAmount			smallint				NOT NULL,
	TotalAmount				smallint				NOT NULL,
	PendingAmount			smallint				NOT NULL,
	IsDelivery				bit						NOT NULL,
	DeliveryDate			SMALLDATETIME				NULL,
)