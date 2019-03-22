	---	Customers are across Service Lines
CREATE	TABLE	Customer
(
	CustomerID			CustomerID			NOT	NULL	IDENTITY (1, 1)
														CONSTRAINT	Customer_PK_CustomerID
															PRIMARY KEY	NONCLUSTERED,
	CustomerShortCode	NVARCHAR (10)		NOT	NULL	CONSTRAINT	Customer_UK_CustomerCode
															UNIQUE	NONCLUSTERED,
	CustomerName		GenericName			NOT	NULL	CONSTRAINT	Customer_UK_CustomerName
															UNIQUE	CLUSTERED,
	LegalEntityName		GenericName				NULL,
	WebURL				LongName				NULL,

	Logo				FileID					NULL,

	Remarks				ShortRemarks			NULL,
	AccountManagerID	UserID				NOT	NULL	CONSTRAINT	Customer_FK_AccountManagerID
															REFERENCES	EndUser,

	EffectiveFromDate	DATE				NOT NULL,

		--- future only
	EffectiveTillDate	DATE					NULL,

		CONSTRAINT	Customer_CK_EffectiveFromDate_EffectiveTillDate
			CHECK	(	EffectiveFromDate <=	EffectiveTillDate	)
)
GO

CREATE	TABLE	CustomerAddress
(
	CustomerID			CustomerID		NOT	NULL	CONSTRAINT	CustomerAddress_FK_CustomerID
														REFERENCES	Customer,
	AddressType			ShortName		NOT NULL,
	AddressLine1		AddressLine		NOT NULL,
	AddressLine2		AddressLine			NULL,
	CityName			ShortName		NOT	NULL,
	StateName			ShortName			NULL,
	CountryName			ShortName		NOT	NULL,
	Pincode				NVARCHAR (10)		NULL,
	IsPrimaryAddress	BIT				NOT NULL,

		CONSTRAINT	CustomerAddress_PK_CustomerID_AddressType
			PRIMARY KEY	CLUSTERED	(	CustomerID, AddressType	)
)
GO

CREATE	TABLE	CustomerContact
(
	CustomerID			CustomerID		NOT	NULL	CONSTRAINT	CustomerContact_FK_CustomerID
														REFERENCES	Customer,
	ContactName			GenericName		NOT NULL,
	Email				Email				NULL,
	Telephone			Telephone			NULL,
	Mobile				Mobile				NULL,
	IsPrimaryContact	BIT				NOT NULL,
	UserID				INTEGER				NULL	CONSTRAINT	CustomerContact_FK_UserID
														REFERENCES	EndUser,

		CONSTRAINT	CustomerContact_PK_CustomerID_ContactName
			PRIMARY KEY	CLUSTERED	(	CustomerID, ContactName	)
)
GO
