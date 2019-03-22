-- =============================================================================
		---- like 	Reset Password, Activation, etc
CREATE	TABLE	URLUsageType
(
	URLUsageType	VARCHAR (15)		NOT NULL	CONSTRAINT	URLUsageType_PK_URLUsageType
														PRIMARY KEY	CLUSTERED
)
GO

-- =============================================================================

CREATE	TABLE	PublishedURL
(
	URLID				INTEGER			NOT NULL	IDENTITY (1, 1)
													CONSTRAINT	PublishedURL_URLID
														PRIMARY KEY	CLUSTERED,
	URL					VARCHAR (100)	NOT	NULL,
	URLUsageType		VARCHAR (15)	NOT NULL	CONSTRAINT	PublishedURL_FK_URLUsageType
														REFERENCES	URLUsageType,
	URLExpiryDTM		DATETIME		NOT NULL
)
GO

-- =============================================================================

CREATE TABLE TimeZone
(
	TimeZoneID		TINYINT			NOT	NULL	CONSTRAINT	TimeZone_PK_TimeZoneID
													PRIMARY	KEY	NONCLUSTERED,
	TimeZoneValue	FLOAT			NOT	NULL,
	Descriptions	LongName		NOT	NULL,

	CONSTRAINT	TimeZone_UK_TimeZoneID_TimeZoneValue_Descriptions
			UNIQUE CLUSTERED	(	TimeZoneID, TimeZoneValue, Descriptions	),	
)
GO

INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (1, -720, N'(GMT-12:00) International Date Line West')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (2, -660, N'(GMT-11:00) Midway Island, Samoa')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (3, -600, N'(GMT-10:00) Hawaii')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (4, -540, N'(GMT-09:00) Alaska')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (5, -480, N'(GMT-08:00) Pacific Time (US & Canada)')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (6, -480, N'(GMT-08:00) Tijuana, Baja California')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (7, -420, N'(GMT-07:00) Arizona')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (8, -420, N'(GMT-07:00) Chihuahua, La Paz, Mazatlan')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (9, -420, N'(GMT-07:00) Mountain Time (US & Canada)')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (10, -360, N'(GMT-06:00) Central America')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (11, -360, N'(GMT-06:00) Central Time (US & Canada)')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (12, -360, N'(GMT-06:00) Guadalajara, Mexico City, Monterrey')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (13, -360, N'(GMT-06:00) Saskatchewan')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (14, -300, N'(GMT-05:00) Bogota, Lima, Quito, Rio Branco')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (15, -300, N'(GMT-05:00) Eastern Time (US & Canada)')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (16, -300, N'(GMT-05:00) Indiana (East)')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (17, -240, N'(GMT-04:00) Atlantic Time (Canada)')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (18, -240, N'(GMT-04:00) Caracas, La Paz')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (19, -240, N'(GMT-04:00) Manaus')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (20, -240, N'(GMT-04:00) Santiago')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (21, -210, N'(GMT-03:30) Newfoundland')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (22, -180, N'(GMT-03:00) Brasilia')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (23, -180, N'(GMT-03:00) Buenos Aires, Georgetown')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (24, -180, N'(GMT-03:00) Greenland')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (25, -180, N'(GMT-03:00) Montevideo')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (26, -120, N'(GMT-02:00) Mid-Atlantic')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (27, -60, N'(GMT-01:00) Cape Verde Is.')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (28, -60, N'(GMT-01:00) Azores')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (29, 0, N'(GMT+00:00) Casablanca, Monrovia, Reykjavik')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (30, 0, N'(GMT+00:00) Greenwich Mean Time : Dublin, Edinburgh, Lisbon, London')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (31, 60, N'(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (32, 60, N'(GMT+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (33, 60, N'(GMT+01:00) Brussels, Copenhagen, Madrid, Paris')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (34, 60, N'(GMT+01:00) Sarajevo, Skopje, Warsaw, Zagreb')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (35, 60, N'(GMT+01:00) West Central Africa')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (36, 120, N'(GMT+02:00) Amman')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (37, 120, N'(GMT+02:00) Athens, Bucharest, Istanbul')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (38, 120, N'(GMT+02:00) Beirut')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (39, 120, N'(GMT+02:00) Cairo')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (40, 120, N'(GMT+02:00) Harare, Pretoria')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (41, 120, N'(GMT+02:00) Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (42, 120, N'(GMT+02:00) Jerusalem')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (43, 120, N'(GMT+02:00) Minsk')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (44, 120, N'(GMT+02:00) Windhoek')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (45, 180, N'(GMT+03:00) Kuwait, Riyadh, Baghdad')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (46, 180, N'(GMT+03:00) Moscow, St. Petersburg, Volgograd')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (47, 180, N'(GMT+03:00) Nairobi')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (48, 180, N'(GMT+03:00) Tbilisi')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (49, 210, N'(GMT+03:30) Tehran')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (50, 240, N'(GMT+04:00) Abu Dhabi, Muscat')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (51, 240, N'(GMT+04:00) Baku')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (52, 240, N'(GMT+04:00) Yerevan')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (53, 270, N'(GMT+04:30) Kabul')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (54, 300, N'(GMT+05:00) Yekaterinburg')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (55, 300, N'(GMT+05:00) Islamabad, Karachi, Tashkent')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (56, 330, N'(GMT+05:30) Sri Jayawardenapura')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (57, 330, N'(GMT+05:30) Chennai, Kolkata, Mumbai, New Delhi, India')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (58, 345, N'(GMT+05:45) Kathmandu')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (59, 360, N'(GMT+06:00) Almaty, Novosibirsk')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (60, 360, N'(GMT+06:00) Astana, Dhaka')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (61, 390, N'(GMT+06:30) Yangon (Rangoon)')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (62, 420, N'(GMT+07:00) Bangkok, Hanoi, Jakarta')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (63, 420, N'(GMT+07:00) Krasnoyarsk')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (64, 480, N'(GMT+08:00) Beijing, Chongqing, Hong Kong, Urumqi')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (65, 480, N'(GMT+08:00) Kuala Lumpur, Singapore')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (66, 480, N'(GMT+08:00) Irkutsk, Ulaan Bataar')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (67, 480, N'(GMT+08:00) Perth')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (68, 480, N'(GMT+08:00) Taipei')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (69, 540, N'(GMT+09:00) Osaka, Sapporo, Tokyo')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (70, 540, N'(GMT+09:00) Seoul')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (71, 540, N'(GMT+09:00) Yakutsk')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (72, 570, N'(GMT+09:30) Adelaide')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (73, 570, N'(GMT+09:30) Darwin')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (74, 600, N'(GMT+10:00) Brisbane')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (75, 600, N'(GMT+10:00) Canberra, Melbourne, Sydney')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (76, 600, N'(GMT+10:00) Hobart')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (77, 600, N'(GMT+10:00) Guam, Port Moresby')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (78, 600, N'(GMT+10:00) Vladivostok')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (79, 660, N'(GMT+11:00) Magadan, Solomon Is., New Caledonia')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (80, 720, N'(GMT+12:00) Auckland, Wellington')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (81, 720, N'(GMT+12:00) Fiji, Kamchatka, Marshall Is.')
GO
INSERT TimeZone (TimeZoneID, TimeZoneValue, Descriptions) VALUES (82, 780, N'(GMT+13:00) Nuku''alofa')
GO

/* Script here due to EndUser columns*/
CREATE	TABLE	Department
(
	DepartmentID			DepartmentID		NOT NULL	IDENTITY (1, 1)
															CONSTRAINT	Department_PK_DepartmentID
																PRIMARY	KEY	NONCLUSTERED,
	IsExternal				BIT					NOT NULL,
	ContractorCode			ShortName				NULL,
	Email					Email					NULL,
	WebURL					LongName				NULL,
	TelePhone				Telephone				NULL,
	Address					AddressLine				NULL,
	ZipCode					VARCHAR(50)				NULL,
	City					GenericName				NULL,
	ContactPerson			GenericName				NULL,
	
	CONSTRAINT	Department_CK_IsExternal_IsExternal_ContractorCode_Email_WebURL_TelePhone_Address_ZipCode_City
			CHECK	(	(	IsExternal	= 0			AND		ContractorCode	IS NULL		AND		WebURL	IS NULL 
						AND		Address			IS NULL		AND		ZipCode		IS NULL  
						AND City		IS NULL
						)
					OR	IsExternal	= 1	
					)
)
GO
CREATE	TABLE	DepartmentLanguage
(
	DepartmentID		DepartmentID		NOT NULL	CONSTRAINT	DepartmentLanguage_FK_DepartmentID
															REFERENCES	Department,
 	LanguageCode		LanguageCode		NOT	NULL,
	DepartmentName		GenericName			NOT NULL,

		
		CONSTRAINT	DepartmentLanguage_UK_LanguageCode_DepartmentName
			UNIQUE NONCLUSTERED	(	LanguageCode, DepartmentName	),
		CONSTRAINT	CourseTypeNameLanguage_PK_DepartmentID_LanguageCode
			PRIMARY KEY	CLUSTERED	(	DepartmentID, LanguageCode	)
)
GO	

CREATE	TABLE	Designation
(
	DesignationID			DesignationID		NOT NULL	IDENTITY (1, 1)
															CONSTRAINT	Designation_PK_DesignationID
																PRIMARY	KEY	NONCLUSTERED
)
GO
CREATE	TABLE	DesignationLanguage
(
	DesignationID		DesignationID		NOT NULL	CONSTRAINT	DesignationLanguage_FK_DesignationID
															REFERENCES	Designation,
 	LanguageCode		LanguageCode		NOT	NULL,
	DesignationName		GenericName			NOT NULL,
		
		CONSTRAINT	DesignationLanguage_UK_LanguageCode_DesignationName
			UNIQUE NONCLUSTERED	(	LanguageCode, DesignationName	),
		CONSTRAINT	DesignationLanguage_PK_DesignationID_LanguageCode
			PRIMARY KEY	CLUSTERED	(	DesignationID, LanguageCode	)
)
GO	

--=============================================================================
CREATE	TABLE	EndUser
(
	EndUserID			INTEGER			NOT NULL	IDENTITY (1, 1)
													CONSTRAINT	EndUser_PK_EndUserID
														PRIMARY KEY	NONCLUSTERED,

	LoginID				NVARCHAR (50)	NOT	NULL	CONSTRAINT	EndUser_UK_LoginID
														UNIQUE	CLUSTERED,

	FirstName			NVARCHAR (30)	NOT	NULL,
	MiddleName			NVARCHAR (30)		NULL,
	LastName			NVARCHAR (30)	NOT	NULL,
	LanguageCode		LanguageCode	NOT	NULL,
	UTCOffset			NUMERIC (4,2)	NOT	NULL,
	DefaultModuleCode	CHAR (2)		NOT NULL,

	Gender				VARCHAR (10)	NOT	NULL,
	EmailID				NVARCHAR (50)	NOT	NULL,

	UserIdentity		VARBINARY (16)		NULL,

	ActivatedDTM		DATETIME			NULL,
	LastAccessPoint		VARCHAR (25)		NULL,
	LastLoginDTM		DATETIME			NULL,

	SecretQuestion		NVARCHAR (100)		NULL,
	SecretAnswer		NVARCHAR (100)		NULL,

	ActivationURLID		INTEGER				NULL	CONSTRAINT	EndUser_FK_ActivationURLID
														REFERENCES	PublishedURL,

	ResetPasswordURLID	INTEGER				NULL	CONSTRAINT	EndUser_FK_ResetPasswordURLID
														REFERENCES	PublishedURL,
	DeviceID			VARCHAR(200)		NULL,
	DesignationID		DesignationID		NULL	CONSTRAINT	EndUser_FK_DesignationID
														REFERENCES	Designation,
	DepartmentID		DepartmentID		NULL	CONSTRAINT	EndUser_FK_DepartmentID
														REFERENCES	Department
)
GO

CREATE	TABLE	EndUserModule
(
	EndUserID		INTEGER			NOT NULL	CONSTRAINT	EndUserModule_FK_EndUserID
													REFERENCES	EndUser,
	ModuleCode		CHAR (2)		NOT NULL,

		CONSTRAINT	EndUserModule_PK_EndUserID_ModuleCode
			PRIMARY	KEY	CLUSTERED	(	EndUserID, ModuleCode	)
)
		
-- =============================================================================

CREATE	TABLE	UserRole
(
	UserRoleID		SMALLINT		NOT NULL	IDENTITY (1, 1)
												CONSTRAINT	UserRole_PK_UserRoleID
													PRIMARY	KEY		CLUSTERED,
	UserRoleName	VARCHAR (50)	NOT	NULL	CONSTRAINT	UserRole_UK_UserRoleName
													UNIQUE	NONCLUSTERED
)
GO

-- =============================================================================

CREATE	TABLE	UserRoleUser
(
	UserRoleID		SMALLINT		NOT	NULL	CONSTRAINT	UserRoleUser_FK_UserRoleID
													REFERENCES	UserRole,
	EndUserID		INTEGER			NOT NULL	CONSTRAINT	UserRoleUser_FK_EndUserID
													REFERENCES	EndUser,

		CONSTRAINT	UserRoleUser_PK_UserRoleID_EndUser
			PRIMARY	KEY	CLUSTERED	(	EndUserID, UserRoleID	)
)
GO

-- =============================================================================

CREATE	TABLE	Menu
(
	MenuCode		VARCHAR (15)	NOT	NULL	CONSTRAINT	Menu_PK_MenuCode
													PRIMARY	KEY		CLUSTERED,
	MenuName		VARCHAR (50)	NOT	NULL,

	Sequence		TINYINT			NOT NULL,

	ParentMenuCode	VARCHAR (15)		NULL	CONSTRAINT	Menu_FK_ParentMenuCode
													REFERENCES	Menu,

		CONSTRAINT	Menu_UK_ParentMenuCode_MenuName
			UNIQUE	NONCLUSTERED	(	ParentMenuCode, MenuName	),

		CONSTRAINT	Menu_UK_ParentMenuCode_Sequence
			UNIQUE	NONCLUSTERED	(	ParentMenuCode, Sequence	)
)
GO

-- =============================================================================

CREATE	TABLE	Screen
(
	ScreenID	SMALLINT		NOT	NULL	CONSTRAINT	Screen_PK_ScreenID
												PRIMARY	KEY		CLUSTERED,
	ScreenName	VARCHAR (50)	NOT	NULL,

	MenuCode	VARCHAR (15)		NULL	CONSTRAINT	Screen_FK_MenuCode
												REFERENCES	Menu,

	ModuleCode	CHAR (2)		NOT NULL,

	Sequence	TINYINT			NOT NULL,

	HasInsert	BIT				NOT	NULL	CONSTRAINT	Screen_DF_HasInsert
												DEFAULT	0,
	HasUpdate	BIT				NOT	NULL	CONSTRAINT	Screen_DF_HasUpdate
												DEFAULT	0,
	HasDelete	BIT				NOT	NULL	CONSTRAINT	Screen_DF_HasDelete
												DEFAULT	0,
	HasSelect	BIT				NOT	NULL	CONSTRAINT	Screen_DF_HasSelect
												DEFAULT	0,
	HasImport	BIT				NOT	NULL	CONSTRAINT	Screen_DF_HasImport
												DEFAULT	0,
	HasExport	BIT				NOT	NULL	CONSTRAINT	Screen_DF_HasExport
												DEFAULT	0,

	UpdateAudit	BIT				NOT	NULL	CONSTRAINT	Screen_DF_UpdateAudit
												DEFAULT	0,
	DeleteAudit	BIT				NOT	NULL	CONSTRAINT	Screen_DF_DeleteAudit
												DEFAULT	0,

		CONSTRAINT	Screen_UK_MenuCode_ScreenName
			UNIQUE	NONCLUSTERED	(	MenuCode, ScreenName),
		
		--commented due to screen duplicate required under menu
		--CONSTRAINT	Screen_UK_MenuCode_Sequence
		--	UNIQUE	NONCLUSTERED	(	ModuleCode, MenuCode, Sequence	),

		CONSTRAINT	Screen_CK_HasInsert_HasUpdate_HasDelete_HasSelect
			CHECK	(	HasInsert	=	1
					OR	HasUpdate	=	1
					OR	HasDelete	=	1
					OR	HasSelect	=	1
					),

		CONSTRAINT	Screen_CK_HasUpdate_HasDelete_HasSelect
			CHECK	(	(	HasUpdate	=	0	AND	HasDelete	=	0	)
					OR	(	HasUpdate	=	1	AND	HasSelect	=	1	)
					OR	(	HasDelete	=	1	AND	HasSelect	=	1	)
					),

		CONSTRAINT	Screen_CK_HasUpdate_UpdateAudit
			CHECK	(	(	UpdateAudit	=	0	)
					OR	(	UpdateAudit	=	1	AND	HasUpdate	=	1	)
					),

		CONSTRAINT	Screen_CK_HasDelete_DeleteAudit
			CHECK	(	(	DeleteAudit	=	0	)
					OR	(	DeleteAudit	=	1	AND	HasDelete	=	1	)
					)
)
GO


-- =============================================================================

CREATE	TABLE	ScreenAction
(
	ScreenID	SMALLINT		NOT	NULL	CONSTRAINT	ScreenAction_FK_ScreenID
												REFERENCES	Screen,
	ActionCode	VARCHAR (15)	NOT NULL,
	ActionName	VARCHAR (50)	NOT NULL,
	Sequence	TINYINT			NOT NULL,

	IsAudited	BIT				NOT	NULL	CONSTRAINT	ScreenAction_DF_IsAudited
												DEFAULT	0,

	IsRendered	BIT				NOT	NULL	CONSTRAINT	ScreenAction_DF_IsRendered
												DEFAULT	1,

		CONSTRAINT	ScreenAction_PK_ScreenID_ActionCode
			PRIMARY	KEY	CLUSTERED	(	ScreenID, ActionCode	),

		CONSTRAINT	ScreenAction_UK_ScreenID_ActionName
			UNIQUE	NONCLUSTERED	(	ScreenID, ActionName	),

		CONSTRAINT	ScreenAction_UK_ScreenID_Sequence
			UNIQUE	NONCLUSTERED	(	ScreenID, Sequence	)
)
GO

-- =============================================================================

CREATE	TABLE	ScreenTable
(
	ScreenID		SMALLINT		NOT	NULL	CONSTRAINT	ScreenTable_FK_ScreenID
													REFERENCES	Screen,
	TableName		VARCHAR (50)	NOT NULL,

	IsSingleTuple	BIT				NOT	NULL	CONSTRAINT	ScreenTable_DF_IsSingleTuple
													DEFAULT	1,

		---	1	comma-separated VALUES as emitted in Get
		---	0	A separate call is made for GetDetails
	IsDetailFetched	BIT					NULL,

		CONSTRAINT	ScreenTable_PK_ScreenID_TableName
			PRIMARY	KEY	CLUSTERED	(	ScreenID, TableName	),

		CONSTRAINT	ScreenTable_CK_IsSingleTuple_IsDetailFetched
			CHECK	(	(	IsSingleTuple	=	0	AND	IsDetailFetched	IS	NOT NULL	)
					OR	(	IsSingleTuple	=	1	AND	IsDetailFetched	IS		NULL	)
					)
)
GO

-- =============================================================================

CREATE TABLE GetOnlySPsTable
(
	 TableName		VARCHAR(50)			NOT	NULL	CONSTRAINT	GetOnlySPsTable_PK_TableName
														PRIMARY KEY CLUSTERED 
)
Go

-- =============================================================================


CREATE	TABLE	UserRoleMenu
(
	UserRoleID	SMALLINT		NOT	NULL	CONSTRAINT	UserRoleMenu_FK_UserRoleID
												REFERENCES	UserRole,
	MenuCode	VARCHAR (15)	NOT NULL	CONSTRAINT	UserRoleMenu_FK_MenuCode
												REFERENCES	Menu,

		CONSTRAINT	UserRoleMenu_PK_UserRoleID_MenuCode
			PRIMARY	KEY	CLUSTERED	(	UserRoleID, MenuCode	)
)
GO

-- =============================================================================


CREATE	TABLE	UserRoleScreen
(
	UserRoleID		SMALLINT		NOT	NULL	CONSTRAINT	UserRoleScreen_FK_UserRoleID
													REFERENCES	UserRole,
	ScreenID		SMALLINT		NOT NULL	CONSTRAINT	UserRoleScreen_FK_ScreenID
													REFERENCES	Screen,

	HasInsert		BIT				NOT	NULL	CONSTRAINT	UserRoleScreen_DF_HasInsert
													DEFAULT	0,
	HasUpdate		BIT				NOT	NULL	CONSTRAINT	UserRoleScreen_DF_HasUpdate
													DEFAULT	0,
	HasDelete		BIT				NOT	NULL	CONSTRAINT	UserRoleScreen_DF_HasDelete
													DEFAULT	0,
	HasSelect		BIT				NOT	NULL	CONSTRAINT	UserRoleScreen_DF_HasSelect
													DEFAULT	0,
	HasImport		BIT				NOT	NULL	CONSTRAINT	UserRoleScreen_DF_HasImport
													DEFAULT	0,
	HasExport		BIT				NOT	NULL	CONSTRAINT	UserRoleScreen_DF_HasExport
													DEFAULT	0,

		CONSTRAINT	UserRoleScreen_PK_UserRoleID_ScreenID
			PRIMARY	KEY	CLUSTERED	(	UserRoleID, ScreenID	),

		CONSTRAINT	UserRoleScreen_CK_HasInsert_HasUpdate_HasDelete_HasSelect_HasImport_HasExport
			CHECK	(	HasInsert	=	1
					OR	HasUpdate	=	1
					OR	HasDelete	=	1
					OR	HasSelect	=	1
					OR	HasExport	=	1
					OR	HasImport	=	1
					)
)
GO

-- =============================================================================

CREATE	TABLE	UserRoleScreenAction
(
	UserRoleID		SMALLINT		NOT	NULL	CONSTRAINT	UserRoleScreenAction_FK_UserRoleID
													REFERENCES	UserRole,
	ScreenID		SMALLINT		NOT	NULL,
	ActionCode		VARCHAR (15)	NOT NULL,

		CONSTRAINT	UserRoleScreenAction_PK_ScreenID_ActionCode
			PRIMARY	KEY	CLUSTERED	(	UserRoleID, ScreenID, ActionCode	),

		CONSTRAINT	UserRoleScreenAction_FK_UserRoleID_ScreenID
			FOREIGN	KEY	(	UserRoleID, ScreenID	)
				REFERENCES	UserRoleScreen,

		CONSTRAINT	UserRoleScreenAction_FK_ScreenID_ActionCode
			FOREIGN	KEY	(	ScreenID, ActionCode	)
				REFERENCES	ScreenAction
)
GO

-- =============================================================================

CREATE	TABLE	AuditLog
(
	AuditLogID			BIGINT			NOT NULL	IDENTITY (1, 1)
													CONSTRAINT	AuditLog_PK_AuditLogID
														PRIMARY KEY	CLUSTERED,

	EndUserID			INTEGER			NOT NULL,
	UserRoleID			SMALLINT		NOT	NULL,
	ScreenID			SMALLINT		NOT	NULL,
	ObjectID			NVARCHAR (50)	NOT NULL,

	OperationType		CHAR (1)		NOT	NULL	CONSTRAINT	AuditLog_CK_OperationType
														CHECK	(	OperationType	IN	(	'I',	--	Insert
																							'U',	--	Update
																							'D',	--	Delete
																							'S',	--	Select / Print
																							'M',	--	iMport
																							'E',	--	Export
																							'A'		--	Action
																						)
																),
	OperationDateTime	DATETIME		NOT	NULL,
	AccessPoint			VARCHAR (25)	NOT	NULL
)
GO

-- =============================================================================

CREATE	TABLE	AuditPreImage
(
	AuditLogID		BIGINT			NOT NULL	CONSTRAINT	AuditPreImage_FK_AuditLogID
													REFERENCES	AuditLog,
	TableName		VARCHAR (50)		NULL,
	PreImage		XML				NOT	NULL,

		CONSTRAINT	AuditPreImage_UK_AuditLogID_TableName
			UNIQUE	CLUSTERED	(	AuditLogID, TableName	)
)
GO


-- =============================================================================
	---- NOTE. This function is used for the getting the value for specified system code
-- =============================================================================

CREATE	FUNCTION	GetInformationValue
(
		@p_value_int		INT,
		@p_value_varchar	NVARCHAR (50),
		@p_value_dt			DATE,
		@p_value_dtm		DATETIME
)
	RETURNS NVARCHAR (50)

WITH ENCRYPTION
AS
BEGIN
    DECLARE	@v_info_value			NVARCHAR (50)

    SELECT	@v_info_value =
		CASE
			WHEN	@p_value_int		IS NOT NULL		THEN	CONVERT	(NVARCHAR, 		@p_value_int		)
			WHEN	@p_value_varchar	IS NOT NULL		THEN	@p_value_varchar
			WHEN	@p_value_dt			IS NOT NULL		THEN	CONVERT (NVARCHAR (11), 	@p_value_dt,	106	)
			WHEN	@p_value_dtm		IS NOT NULL		THEN	CONVERT (NVARCHAR (24), 	@p_value_dtm, 	113	)
		END
    RETURN	@v_info_value
END
GO

-- =============================================================================

CREATE	TABLE	InformationCode
(
	InformationCode		VARCHAR (25)	NOT NULL	CONSTRAINT	InformationCode_PK_InformationCode
														PRIMARY KEY CLUSTERED,
	InformationName		VARCHAR (100)	NOT NULL	CONSTRAINT	InformationCode_UK_InformationName
														UNIQUE	NONCLUSTERED,
	Remarks				VARCHAR (200)		NULL
)
GO


-- =============================================================================

CREATE	TABLE	InformationValue
(
	InformationCode		VARCHAR (25)	NOT NULL	CONSTRAINT	InformationValue_FK_InfoCd
														REFERENCES	InformationCode,
	InformationValue	AS	dbo.GetInformationValue (	ValueInt, ValueVarchar, ValueDate, ValueDateTime	),

	ValueInt			INT					NULL,
	ValueVarchar		NVARCHAR (50)		NULL,
	ValueDate			DATE				NULL,
	ValueDateTime		DATETIME			NULL,

		CONSTRAINT	InformationValue_UK_InformationCode_ValueInt_ValueVarchar_ValueDtate_ValueDateTime
			UNIQUE NONCLUSTERED 	(	InformationCode, ValueInt, ValueVarchar, ValueDate, ValueDateTime	),

		CONSTRAINT	InformationValue_CK_ValueInt_ValueVarchar_ValueDtate_ValueDateTime
			CHECK	(	(	ValueInt		IS NOT 	NULL
						AND	ValueVarchar	IS  	NULL
						AND	ValueDate		IS  	NULL
						AND	ValueDateTime	IS 	 	NULL
						)
					OR
						(	ValueInt		IS  	NULL
						AND	ValueVarchar	IS NOT 	NULL
						AND	ValueDate		IS  	NULL
						AND	ValueDateTime	IS 	 	NULL
						)
					OR
						(	ValueInt		IS  	NULL
						AND	ValueVarchar	IS  	NULL
						AND	ValueDate		IS NOT 	NULL
						AND	ValueDateTime	IS 	 	NULL
						)
					OR
						(	ValueInt		IS  	NULL
						AND	ValueVarchar	IS  	NULL
						AND	ValueDate		IS  	NULL
						AND	ValueDateTime	IS NOT 	NULL
						)
					)
)
GO

-- =============================================================================

CREATE TABLE WorkingShift
(
	ShiftCode  		ShiftCode  		NOT NULL 	CONSTRAINT WorkingShift_PK_Shiftcode
													PRIMARY KEY CLUSTERED,
	StartTime  		TIME   			NOT NULL,
	EndTime   		TIME   			NOT NULL,
	Remarks   		GenericName  	NOT NULL,

		CONSTRAINT WorkingShift_UK_StartTime_EndTime
			UNIQUE NONCLUSTERED ( StartTime, EndTime)
)
GO

-- =============================================================================

CREATE TABLE Squad
(
	SquadCode  		SquadCode  		NOT NULL 	CONSTRAINT Squad_PK_SquadCode
													PRIMARY KEY CLUSTERED
)
GO

-- =============================================================================


CREATE	TABLE	Employee
(
	EmployeeID				INTEGER			NOT	NULL	IDENTITY (1, 1)
														CONSTRAINT	Employee_PK_EmployeeID
															PRIMARY	KEY		NONCLUSTERED,
	HRMSEmployeeID			SourceReference		NULL,
	Salutation				VARCHAR(5)		NOT	NULL,
	FirstName				NVARCHAR(30)	NOT	NULL,
	MiddleName				NVARCHAR(30)		NULL,
	LastName				NVARCHAR(30)	NOT	NULL,

	Gender					CHAR(1)			NOT NULL,
	ShortCode				NVARCHAR(5)			NULL,
	DOB						DATE				NULL,
	FullEmployeeAddress		Remarks				NULL,
	TelephoneNo				Telephone			NULL,
	CellNo					Mobile				NULL,
	ExtensionNo				NVARCHAR(25)		NULL,

	Email					Email			NOT	NULL,

	EmergencyContact1		NVARCHAR(50)		NULL,
	EmergencyContact2		NVARCHAR(50)		NULL,

	ReportingEmployeeID		INTEGER				NULL	CONSTRAINT	Employee_FK_ReportingEmployeeID
															REFERENCES	Employee,
	AppointmentDate			DATE			NOT NULL,
	LeavingDate				DATE				NULL,
	DesignationID			DesignationID	NOT NULL,
	DepartmentID			DepartmentID	NOT NULL,
	EndUserID				UserID				NULL,
	
	--VD- Add EmployeeID FK from Employee
		CONSTRAINT	Employee_FK_EndUserID
			FOREIGN	KEY	(	EndUserID	)	REFERENCES	EndUser,
		
		CONSTRAINT	Employee_CK_AppointmentDate_LeavingDate
			CHECK	(	(	LeavingDate	IS		NULL	)
					OR	(	LeavingDate	IS	NOT	NULL	AND	AppointmentDate	<	LeavingDate	)
					),

		CONSTRAINT	Employee_FK_DesignationID
			FOREIGN	KEY	(	DesignationID	)	REFERENCES	Designation,

		CONSTRAINT	Employee_FK_DepartmentID
			FOREIGN	KEY	(	DepartmentID	)	REFERENCES	Department
)
GO

-- =============================================================================
CREATE	TABLE	EmployeeSquad
(
	EmployeeID			EmployeeID		NOT NULL	CONSTRAINT	EmployeeSquad_FK_EmployeeID
														REFERENCES	Employee,
 	SquadCode			SquadCode		NOT	NULL	CONSTRAINT	EmployeeSquad_FK_SquadCode
														REFERENCES	Squad,
	EffectiveFrom		DATETIME			NULL,
	EffectiveTill		DATETIME			NULL,

			CONSTRAINT	EmployeeSquad_CK_EffectiveFrom_EffectiveTill
				CHECK	(	EffectiveFrom	<=	EffectiveTill	)
)

-- =============================================================================
-- VD: this has to be though through since shift allocation process is differemnt for different airports. best way is to have datewise shift whioch
-- could also be uploaded from attendnance or allocated

-- Added on 5 May 2018
CREATE	TABLE	EmployeeShift
(
	EmployeeID			EmployeeID		NOT NULL	CONSTRAINT	EmployeeShift_FK_EmployeeID
														REFERENCES	Employee,
	
	ShiftCode			ShiftCode		NOT	NULL	CONSTRAINT	EmployeeShift_FK_ShiftCode
														REFERENCES	WorkingShift,
	EffectiveFrom		DATETIME			NULL,
	EffectiveTill		DATETIME			NULL,

			CONSTRAINT	EmployeeShift_CK_EffectiveFrom_EffectiveTill
				CHECK	(	EffectiveFrom	<=	EffectiveTill	)
)


CREATE	TABLE	ChecklistTaskGroup
(
	ChecklistTaskGroupID		GroupID			NOT NULL	IDENTITY (1, 1)
														CONSTRAINT	ChecklistTaskGroup_PK_ChecklistTaskGroupID
														PRIMARY	KEY	NONCLUSTERED,
	ModuleCode					ModuleCode		NOT NULL,
	GroupSequence				DisplayOrder	NOT NULL,
	
		CONSTRAINT	ChecklistTaskGroup_UK_ModuleCode_GroupSequence
			UNIQUE	NONCLUSTERED	(	ModuleCode, GroupSequence)													
)
GO

-- =============================================================================

CREATE	TABLE	ChecklistTaskGroupLanguage
(
	ChecklistTaskGroupID		GroupID				NOT NULL	CONSTRAINT	ChecklistTaskGroupLanguage_FK_ChecklistTaskGroupID
																	REFERENCES	ChecklistTaskGroup,
 	LanguageCode				LanguageCode		NOT	NULL,
	ChecklistTaskGroupName		GenericName			NOT NULL,

		CONSTRAINT	ChecklistTaskGroupLanguage_PK_ChecklistTaskGroupID_LanguageCode
			PRIMARY KEY	CLUSTERED	(	ChecklistTaskGroupID, LanguageCode	),
		
		CONSTRAINT	ChecklistTaskGroupLanguage_UK_LanguageCode_ChecklistTaskGroupName
			UNIQUE	NONCLUSTERED	(	LanguageCode, ChecklistTaskGroupName)
)
GO


CREATE TABLE KPI
(
	 SrNo			 SMALLINT		NOT NULL	CONSTRAINT KPI_PK_SrNo
													PRIMARY KEY CLUSTERED,
	 KPIName		 NVARCHAR(500)  NOT NULL,
	 BenchmarkValue  INT				NULL,
	 BenchmarkUnit   TimeUnitCode		NULL	CONSTRAINT	KPI_FK_BenchmarkUnit
													REFERENCES	UOM,
	 FunctionName    VARCHAR(50)        NULL,

	 CONSTRAINT KPI_UK_KPIName
			UNIQUE NONCLUSTERED ( KPIName )
)
GO

