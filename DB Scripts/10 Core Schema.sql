/* ==================================================================================
	Source File		:	Core Schema.sql
	Author(s)		:	Jitendra Loyal
	Started On		:	May 01 2017
	==================================================================================
																		   Usage Notes
	----------------------------------------------------------------------------------
		Core Schema is that which contains tables that are common across modules

		Table definitions for BASE module
			ID .... IDENTITY (1,1)
			Code	Alphanumeric
			No		... Auto-generated... user-centric numbers like Subscription Number, Indent No, Invoice No
			RefID	... Not auto-generated... used for integration, etc
		All DateTime and Dates are specified in UTC
	==================================================================================
																	  Revision History
	----------------------------------------------------------------------------------
     JL : 01-May to ??-Jul-2017
		*   Initial versions
	==================================================================================*/



CREATE	TABLE	Location		-- These are physical locations
(
	LocationID			LocationID		NOT NULL	IDENTITY (1, 1)
													CONSTRAINT	Location_PK_LocationID
														PRIMARY KEY	NONCLUSTERED,
	LocationName		GenericName		NOT NULL,
	ParentLocationID	LocationID			NULL	CONSTRAINT	Location_FK_ParentLocationID
														REFERENCES	Location,

		-- (no parent or child can have this flag set)
		---- Above this is common physical hierarchical locations
		--- So all children below this location are the customers... customer nodes have the same Location Name as the Customer Name
		---- And below is customer specific hierarchical locations
		---- Any nodes of the Customer-specific hierarchy can have Items/Objects
	HasCustomers		BIT				NOT NULL,

		--	This is redudant data and needs to be managed properly and propagated below till leaf nodes.
		--	CustomerID should be present on all nodes below the node having HasCustomers flag.
		--	CustomerID should NOT be present on all nodes above the node having HasCustomers flag.
	CustomerID			CustomerID			NULL,	--		CONSTRAINT	Location_FK_CustomerID	is defined after Customer table definition

		--	Country is specified at only one level in any path from root to leaf;
		--	This means that when a Country is defined at a node, netiher any of the ancestors (parents) should have it, nor any descendants (children).
		--	Secondly, it must be defined on or above the node having HasCustomers flag. 
	CountryCode			CountryCode			NULL,

	Longitude			FLOAT				NULL,
	Latitude			FLOAT				NULL,
	Remarks				ShortRemarks		NULL,
	LocationSequence	DisplayOrder		NULL,

		CONSTRAINT	Location_UK_ParentLocationID_LocationName
			UNIQUE	CLUSTERED	(	ParentLocationID, LocationName	),
		CONSTRAINT Location_UK_ParentLocationID_LocationSequence
			UNIQUE NONCLUSTERED ( ParentLocationID, LocationSequence )
)
GO

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

	Logo				FileID					NULL	CONSTRAINT	Customer_FK_Logo
															REFERENCES	FolderFile,
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


ALTER	TABLE	Location
	ADD	CONSTRAINT	Location_FK_CustomerID
		FOREIGN KEY	(	CustomerID	)
			REFERENCES	Customer
GO

CREATE	TABLE	CustomerLanguage
(
	CustomerID			CustomerID			NOT	NULL	CONSTRAINT	CustomerLanguage_FK_CustomerID
															REFERENCES	Customer,
	LanguageCode		LanguageCode		NOT	NULL,

		CONSTRAINT	CustomerLanguage_PK_CustomerID_LanguageCode
			PRIMARY KEY	CLUSTERED	(	CustomerID, LanguageCode	)
)
GO

--- Specifies the Users that manage a set of Locations below the LocationID specified.
CREATE	TABLE	UserLocation
(
	ModuleCode			ModuleCode		NOT	NULL,
	ServiceLineCode		ServiceLineCode		NULL,
			--	Controllers are NOT specified here; these are other users Like Customers, Supervisors, Account Managers, etc.
	UserID				UserID			NOT NULL	CONSTRAINT	UserLocation_FK_UserID
														REFERENCES	EndUser,
		--- When a Location is specified for a User, there should NOT be any location below or above with the same user in the Module (and Service Line)
		---	In other words, a User can be specified only once in a hierarchy path for a Module (and Service Line).
		--- This means that a User can be assigned multiple locations in a Module (and Service Line), which are siblings.
	LocationID			LocationID		NOT	NULL	CONSTRAINT	UserLocation_FK_LocationID
														REFERENCES	Location,

	CONSTRAINT	UserLocation_UK_ModuleCode_ServiceLineCode_UserID_LocationID
		UNIQUE	CLUSTERED	(	ModuleCode, ServiceLineCode, UserID, LocationID	)
)
GO

CREATE	TABLE	CustomerModule
(
	CustomerID		CustomerID		NOT	NULL	CONSTRAINT	CustomerModule_FK_CustomerID
																REFERENCES	Customer,
	ModuleCode		ModuleCode		NOT	NULL,

		CONSTRAINT	CustomerModule_PK_CustomerID_ModuleCode
			PRIMARY KEY	CLUSTERED	(	CustomerID, ModuleCode	)
)
GO

CREATE	TABLE	CustomerLocation
(
	CustomerLocationID	CustomerLocationID	NOT	NULL	IDENTITY (1, 1)
														CONSTRAINT	Customer_PK_CustomerLocationID
															PRIMARY KEY	NONCLUSTERED,
	CustomerID			CustomerID			NOT	NULL	CONSTRAINT	CustomerLocation_FK_CustomerID
															REFERENCES	Customer,
		-- While showing, we have to show it's parents
	LocationID			LocationID			NOT	NULL	CONSTRAINT	CustomerLocation_FK_LocationID
															REFERENCES	Location,

		CONSTRAINT	CustomerLocation_UK_CustomerID_LocationID
			UNIQUE	CLUSTERED	(	CustomerID, LocationID	)
)
GO

CREATE	TABLE	CountryHoliday
(
	CountryCode			CountryCode		NOT NULL,
	HolidayDate			DATE			NOT NULL,

		CONSTRAINT	CustomerHoliday_PK_CountryCode_HolidayDate
			PRIMARY	KEY	CLUSTERED	(	CountryCode, HolidayDate	)
)
GO

CREATE	TABLE	CountryHolidayName
(
	CountryCode			CountryCode		NOT NULL,
	HolidayDate			DATE			NOT NULL,
	LanguageCode		LanguageCode	NOT	NULL,
	HolidayName			GenericName		NOT NULL,

		CONSTRAINT	CustomerHolidayName_PK_CountryCode_HolidayDate_LanguageCode
			PRIMARY	KEY	CLUSTERED	(	CountryCode, HolidayDate, LanguageCode	),

		CONSTRAINT	CustomerHolidayName_FK_CountryCode_HolidayDate
			FOREIGN	KEY	(	CountryCode, HolidayDate	)
				REFERENCES	CountryHoliday
)
GO

CREATE	TABLE	CustomerLocationHoliday
(
	CustomerLocationID	CustomerLocationID	NOT	NULL	CONSTRAINT	CustomerLocationHoliday_FK_CustomerLocationID
															REFERENCES	CustomerLocation,
	HolidayDate			DATE				NOT NULL,

		CONSTRAINT	CustomerLocationHoliday_PK_CustomerLocationID_HolidayDate
			PRIMARY	KEY	CLUSTERED	(	CustomerLocationID, HolidayDate	)
)
GO

CREATE	TABLE	CustomerLocationHolidayName
(
	CustomerLocationID	CustomerLocationID	NOT	NULL,
	HolidayDate			DATE				NOT NULL,
	LanguageCode		LanguageCode		NOT	NULL,
	HolidayName			GenericName			NOT NULL,

		CONSTRAINT	CustomerLocationHolidayName_PK_CustomerLocationID_HolidayDate_LanguageCode
			PRIMARY	KEY	CLUSTERED	(	CustomerLocationID, HolidayDate, LanguageCode	),

		CONSTRAINT	CustomerLocationHolidayName_FK_CustomerLocationID_HolidayDate
			FOREIGN	KEY	(	CustomerLocationID, HolidayDate	)
				REFERENCES	CustomerLocationHoliday
)
GO

--Newly added table by pradip
CREATE TABLE CustomerWeeklyOff
(
	 LocationID		LocationID		NOT NULL,
	 DayName		NVARCHAR(15)	NOT NULL,

	 CONSTRAINT CustomerWeeklyOff_PK_LocationID_DayName
		PRIMARY KEY CLUSTERED ( LocationID, DayName )
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

-- VG Specifies the Leaf locations from user location and Controller tagging table 
CREATE	TABLE	UserLeafLocation
(	
	UserID				UserID			NOT NULL	CONSTRAINT	UserLeafLocation_FK_UserID
														REFERENCES	EndUser,
	--- Only leaf locations will be insterted here
	LocationID			LocationID		NOT	NULL	CONSTRAINT	UserLeafLocation_FK_LocationID
														REFERENCES	Location,

	CONSTRAINT	UserLeafLocation_PK_UserID_LocationID
			PRIMARY KEY	CLUSTERED	(	UserID, LocationID	)
	
)
GO

-- It's use will be to specify certain Customer specific configurable items like No. of Check-list Items
CREATE	TABLE	CustomerModuleConfiguration
(
	CustomerID			CustomerID			NOT	NULL,
	ModuleCode			ModuleCode			NOT	NULL,
 	ConfigurationCode	ConfigurationCode	NOT	NULL,
	ConfigurationValue	INTEGER					NULL,

		CONSTRAINT	CustomerModuleConfiguration_PK_CustomerID_ModuleCode_ConfigurationCode
			PRIMARY KEY	CLUSTERED	(	CustomerID, ModuleCode, ConfigurationCode	),

		CONSTRAINT	CustomerModuleConfiguration_FK_CustomerID_ModuleCode
			FOREIGN KEY	(	CustomerID, ModuleCode	)
				REFERENCES	CustomerModule
)
GO

CREATE	TABLE	LocationRiskLevel
(
	ModuleCode			ModuleCode		NOT	NULL,
	LocationID			LocationID		NOT	NULL	CONSTRAINT	LocationRiskLevel_FK_LocationID
														REFERENCES	Location,
			--- Up in the hierarchy, RiskLevelID should be lower (number is greater)
			--- As we go down the hierarchy, the same Risk Level is applicable as Parent (or Ancestor)
			--- Unless it is defined at that node, which should be a higher Risk Level (lower number of RiskLevelID)
	RiskLevelID			RiskLevelID		NOT NULL,

		CONSTRAINT	LocationRiskLevel_PK_ModuleCode_LocationID
			PRIMARY	KEY	CLUSTERED	(	ModuleCode, LocationID	)
)
GO

CREATE	TABLE	UOM
(
	UOMID		UOMID			NOT NULL	IDENTITY (1, 1)
											CONSTRAINT	UOM_PK_UOMID
												PRIMARY	KEY	CLUSTERED
)
GO

CREATE	TABLE	UOMLanguage
(
	UOMID			UOMID			NOT NULL	CONSTRAINT	UOMLanguage_FK_UOMID
														REFERENCES	UOM,
 	LanguageCode	LanguageCode	NOT	NULL,
	UOMName			GenericName		NOT NULL,

		CONSTRAINT	UOMLanguage_PK_LanguageCode_UOMName
			PRIMARY KEY	CLUSTERED	(	LanguageCode, UOMName	),

		CONSTRAINT	UOMLanguage_UK_UOMID_LanguageCode
			UNIQUE	NONCLUSTERED	(	UOMID, LanguageCode	)
)
GO

CREATE	TABLE	Attribute
(
	AttributeID			AttributeID		NOT NULL	IDENTITY (1001, 1)
													CONSTRAINT	Attribute_PK_AttributeID
														PRIMARY	KEY	NONCLUSTERED,
		--	Only those Attributes for which IsUsedForObjects is set
	AttributeType		AttributeType	NOT	NULL,

		-- TextLength can be specified for String types of attributes
	TextLength			TINYINT				NULL,

		-- Float and precision are specified for Float types of attributes
	FloatPrecision		TINYINT				NULL,
	FloatScale			TINYINT				NULL
)
GO

CREATE	TABLE	AttributeLanguage
(
	AttributeID			AttributeID		NOT NULL	CONSTRAINT	AttributeLanguage_FK_AttributeID
														REFERENCES	Attribute,
 	LanguageCode		LanguageCode	NOT	NULL,
	AttributeName		GenericName		NOT NULL,

		CONSTRAINT	AttributeLanguage_PK_LanguageCode_AttributeName
			PRIMARY KEY	CLUSTERED	(	LanguageCode, AttributeName	),

		CONSTRAINT	AttributeLanguage_UK_AttributeID_LanguageCode
			UNIQUE	NONCLUSTERED	(	AttributeID, LanguageCode	)
)
GO


