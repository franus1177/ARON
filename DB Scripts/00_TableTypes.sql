
IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'AttributeLanguage_TableType' AND is_table_type = 1)
DROP TYPE AttributeLanguage_TableType
GO

CREATE TYPE AttributeLanguage_TableType AS TABLE 
(
	LanguageCode	LanguageCode	/*CHAR(2)*/	NOT NULL,
	AttributeName	GenericName	/*NVARCHAR(50)*/	NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'ObjectAttribute_TableType' AND is_table_type = 1)
DROP TYPE ObjectAttribute_TableType
GO

CREATE TYPE ObjectAttribute_TableType AS TABLE(
	AttributeID AttributeID NOT NULL,
	ValueBit BIT NULL,
	ValueFloat FLOAT NULL,
	ValueDate DATETIME NULL,
	ValueText NVARCHAR(4000) NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'ObjectLanguage_TableType' AND is_table_type = 1)
DROP TYPE ObjectLanguage_TableType
GO
CREATE TYPE ObjectLanguage_TableType AS TABLE(
	LanguageCode	LanguageCode NOT NULL,
	ObjectName		GenericName NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'ObjectRepairComponent_TableType' AND is_table_type = 1)
DROP TYPE ObjectRepairComponent_TableType
GO

CREATE TYPE ObjectRepairComponent_TableType AS TABLE(
	RepairComponentID	RepairComponentID NOT NULL,
	MaxUseQuantity		FLOAT NULL,
	DefaultQuantity		FLOAT NULL
)
GO


IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'CategoryAttribute_TableType' AND is_table_type = 1)
DROP TYPE CategoryAttribute_TableType
GO

CREATE TYPE CategoryAttribute_TableType AS TABLE 
(
	AttributeID	AttributeID	/*SMALLINT*/	NOT NULL,
	AttributeSequence	DisplayOrder	/*SMALLINT*/	NOT NULL,
	IsMandatory	BIT	NOT NULL,
	MinFloatValue	FLOAT		NULL,
	MaxFloatValue	FLOAT		NULL,
	UOMID	UOMID	/*SMALLINT*/		NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'CategoryLanguage_TableType' AND is_table_type = 1)
DROP TYPE CategoryLanguage_TableType
GO

CREATE TYPE CategoryLanguage_TableType AS TABLE 
(
	LanguageCode	LanguageCode	/*CHAR(2)*/	NOT NULL,
	CategoryName	GenericName	/*NVARCHAR(50)*/	NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'CustomerLanguage_TableType' AND is_table_type = 1)
DROP TYPE CustomerLanguage_TableType
GO

CREATE TYPE CustomerLanguage_TableType AS TABLE 
(
	LanguageCode	LanguageCode	/*CHAR(2)*/	NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'CustomerModule_TableType' AND is_table_type = 1)
DROP TYPE CustomerModule_TableType
GO

CREATE TYPE CustomerModule_TableType AS TABLE 
(
	ModuleCode ModuleCode /*CHAR(2)*/ NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'CustomerLocation_TableType' AND is_table_type = 1)
DROP TYPE CustomerLocation_TableType
GO

CREATE TYPE CustomerLocation_TableType AS TABLE 
(
	LocationID	LocationID	/*INT*/	NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'CustomerServiceLine_TableType' AND is_table_type = 1)
DROP TYPE CustomerServiceLine_TableType
GO

CREATE TYPE CustomerServiceLine_TableType AS TABLE 
(
	ServiceLineCode	ServiceLineCode	/*CHAR(2)*/	NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'DeviationTypeLanguage_TableType' AND is_table_type = 1)
DROP TYPE DeviationTypeLanguage_TableType
GO

CREATE TYPE DeviationTypeLanguage_TableType AS TABLE 
(
	LanguageCode		LanguageCode	/*CHAR(2)*/	NOT NULL,
	DeviationTypeName	HugeName	/*NVARCHAR(200)*/	NOT NULL
)
GO


IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'DeviationTypeResolutionLanguage_TableType' AND is_table_type = 1)
DROP TYPE DeviationTypeResolutionLanguage_TableType
GO

CREATE TYPE DeviationTypeResolutionLanguage_TableType AS TABLE 
(
	LanguageCode	LanguageCode	/*CHAR(2)*/	NOT NULL,
	ResolutionName	HugeName	/*NVARCHAR(200)*/	NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'DeviationTypeResolutionRepairComponent_TableType' AND is_table_type = 1)
DROP TYPE DeviationTypeResolutionRepairComponent_TableType
GO

CREATE TYPE DeviationTypeResolutionRepairComponent_TableType AS TABLE 
(
	ObjectID					ObjectID	/*SMALLINT*/		NULL,
	RepairComponentID			RepairComponentID	/*SMALLINT*/	NOT NULL,
	MaxUseQuantity				FLOAT		NULL,
	DefaultQuantity				FLOAT		NULL
)
GO


IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'AdditionalFrequencyCheckList_TableType' AND is_table_type = 1)
DROP TYPE AdditionalFrequencyCheckList_TableType
GO

CREATE TYPE AdditionalFrequencyCheckList_TableType AS TABLE 
(
	AdditionalCheckListID	CheckListID	NOT	NULL,
	CheckListSequence		SMALLINT	NOT NULL
)
GO


IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'CheckListTaskDeviationType_TableType' AND is_table_type = 1)
DROP TYPE CheckListTaskDeviationType_TableType
GO

CREATE TYPE CheckListTaskDeviationType_TableType AS TABLE 
(
	RowID					INT									NULL,
	DeviationTypeID			DeviationTypeID	/*SMALLINT*/	NOT NULL,
	DeviationTypeSequence	DisplayOrder	/*SMALLINT*/	NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'CheckListTaskLanguage_TableType' AND is_table_type = 1)
DROP TYPE CheckListTaskLanguage_TableType
GO

CREATE TYPE CheckListTaskLanguage_TableType AS TABLE 
(
	RowID				INT									NULL,
	LanguageCode		LanguageCode /*CHAR(2)*/		NOT NULL,
	CheckListTaskName	HugeName	 /*NVARCHAR(200)*/	NOT NULL
)
GO


IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'ControllerSpecialization_TableType' AND is_table_type = 1)
DROP TYPE ControllerSpecialization_TableType
GO

CREATE TYPE ControllerSpecialization_TableType AS TABLE 
(
	ServiceLineCode	ServiceLineCode	/*CHAR(2)*/	NOT NULL,
	CategoryID		CategoryID	/*SMALLINT*/		NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'UserRoleUser_TableType' AND is_table_type = 1)
DROP TYPE UserRoleUser_TableType
GO

CREATE TYPE UserRoleUser_TableType AS TABLE 
(
	UserRoleID	SMALLINT	NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'NotInUseReasonLanguage_TableType' AND is_table_type = 1)
DROP TYPE NotInUseReasonLanguage_TableType
GO

CREATE TYPE NotInUseReasonLanguage_TableType AS TABLE 
(
	LanguageCode		LanguageCode	/*CHAR(2)*/		NOT NULL,
	NotInUseReasonName	LongName	/*NVARCHAR(100)*/	NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'RepairComponentLanguage_TableType' AND is_table_type = 1)
DROP TYPE RepairComponentLanguage_TableType
GO

CREATE TYPE RepairComponentLanguage_TableType AS TABLE 
(
	LanguageCode		LanguageCode	/*CHAR(2)*/		NOT NULL,
	RepairComponentName	GenericName	/*NVARCHAR(50)*/	NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'UOMLanguage_TableType' AND is_table_type = 1)
DROP TYPE UOMLanguage_TableType
GO

CREATE TYPE UOMLanguage_TableType AS TABLE 
(
	LanguageCode	LanguageCode	/*CHAR(2)*/		NOT NULL,
	UOMName			GenericName	/*NVARCHAR(50)*/	NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'ObjectInstance_TableType' AND is_table_type = 1)
DROP TYPE ObjectInstance_TableType
GO

CREATE TYPE ObjectInstance_TableType AS TABLE 
(
	LocationName			GenericName		NOT NULL,
	ObjectID				ObjectID		NOT NULL,
	SerialNumber			NVARCHAR(40)		NULL,
	Longitude				FLOAT				NULL,
	Latitude				FLOAT				NULL,
	NotInUseReasonName		LongName			NULL,
	EffectiveFromDate		DATE				NULL,
	EffectiveTillDate		DATE				NULL,
	AMCStartDate			DATE				NULL,
	AMCEndDate				DATE				NULL,
	WarrantyEndDate			DATE				NULL,
	SourceRefID				GenericName			NULL,
	Make					GenericName			NULL,
	Remarks					ShortRemarks		NULL
)
GO


IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'ObjectInspectionList_TableType' AND is_table_type = 1)
DROP TYPE ObjectInspectionList_TableType
GO

CREATE TYPE ObjectInspectionList_TableType AS TABLE 
(
	ObjectInstanceID		ObjectInstanceID	NOT NULL
)
GO


IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'CheckListTask_TableType' AND is_table_type = 1)
	DROP TYPE CheckListTask_TableType
GO
CREATE TYPE CheckListTask_TableType AS TABLE 
(
	RowID						INT,
	CheckListID					CheckListID	/*SMALLINT*/,
	TaskSequence				SMALLINT	/*SMALLINT*/,
	ChecklistTaskGroupID		GroupID		/*SMALLINT*/,
	IsMandatory					BIT,
	ChecklistTaskCode			GenericCode,
	AttributeType				AttributeType	/*VARCHAR(10)*/,
	TextLength					SMALLINT,
	FloatPrecision				TINYINT,
	FloatScale					TINYINT,
	UOMID						UOMID	/*SMALLINT*/,
	DeviationIfFalse			BIT,
	BoolDeviationTypeID			DeviationTypeID	/*SMALLINT*/,
	DeviationIfLessValue		FLOAT,
	LessValueDeviationTypeID	DeviationTypeID	/*SMALLINT*/,
	DeviationIfMoreValue		FLOAT,
	MoreValueDeviationTypeID	DeviationTypeID	/*SMALLINT*/,
	EffectiveFrom				DATE,
	EffectiveTill				DATE
)
GO


IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'CountryHolidayName_TableType' AND is_table_type = 1)
DROP TYPE CountryHolidayName_TableType
GO

CREATE TYPE CountryHolidayName_TableType AS TABLE 
(
	CountryCode		CountryCode	/*VARCHAR(5)*/		NOT NULL,
	HolidayDate		DATE							NOT NULL,
	LanguageCode	LanguageCode	/*CHAR(2)*/		NOT NULL,
	HolidayName		GenericName	/*NVARCHAR(50)*/	NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'CustomerLocationHolidayName_TableType' AND is_table_type = 1)
DROP TYPE CustomerLocationHolidayName_TableType
GO

CREATE TYPE CustomerLocationHolidayName_TableType AS TABLE 
(
	CustomerLocationID	CustomerLocationID				NOT	NULL,
	HolidayDate			DATE							NOT NULL,
	LanguageCode		LanguageCode	/*CHAR(2)*/		NOT NULL,
	HolidayName			GenericName	/*NVARCHAR(50)*/	NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'Deviation_TableType' AND is_table_type = 1)
DROP TYPE Deviation_TableType
GO

CREATE TYPE Deviation_TableType AS TABLE 
(
	RowID						INT						NULL,
	InspectionID				InspectionID		NOT	NULL,
	LocationID					LocationID			NOT	NULL,
	DeviationTypeID				DeviationTypeID			NULL,
	DeviationDescription		LongName				NULL,
	DeviationDateTime			DATETIME			NOT NULL,
	DeviationRemarks			LongRemarks				NULL
)
Go


--IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'DesignationLanguage_TableType' AND is_table_type = 1)
--DROP TYPE DesignationLanguage_TableType
--GO

--CREATE TYPE DesignationLanguage_TableType AS TABLE 
--(
--	LanguageCode	LanguageCode	/*CHAR(2)*/	NOT NULL,
--	DesignationName	GenericName	/*NVARCHAR(50)*/	NOT NULL
--)
--GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'DeviationLocationPhotoElement_TableType' AND is_table_type = 1)
DROP TYPE DeviationLocationPhotoElement_TableType
GO
-- old DeviationLocationPhoto_TableType
CREATE TYPE DeviationLocationPhotoElement_TableType AS TABLE 
(
	DeviationPhotoID	DeviationPhotoID		NULL,
	PhotoDateTime		DATETIME			NOT NULL,
	PhotoSequence		TINYINT				NOT NULL,
	Photo				FileID	/*BIGINT*/		NULL,
	SmallPhoto			FileID	/*BIGINT*/		NULL,

	FileName			NVARCHAR (100)			NULL,
	FileType			VARCHAR (10)			NULL,
	FileSize			BIGINT					NULL,
	FileRemarks			NVARCHAR (200)			NULL,

	SmallFileName		NVARCHAR (100)			NULL,
	SmallFileType		VARCHAR (10)			NULL,
	SmallFileSize		BIGINT					NULL,
	SmallFileRemarks	NVARCHAR (200)			NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'DeviationLocationPhoto_TableType' AND is_table_type = 1)
DROP TYPE DeviationLocationPhoto_TableType
GO
-- old DeviationLocationPhotoInstance_TableType
CREATE TYPE DeviationLocationPhoto_TableType AS TABLE 
(
	PhotoDateTime	DATETIME	NOT NULL,
	Remarks	ShortRemarks	/*NVARCHAR(100)*/		NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'ContractCategory_TableType' AND is_table_type = 1)
DROP TYPE ContractCategory_TableType
GO

CREATE TYPE ContractCategory_TableType AS TABLE 
(
	CategoryID		CategoryID	/*SMALLINT*/	NOT NULL,
	ServiceLevelID	ServiceLevelID	/*TINYINT*/		NULL,
	Frequency		TimeUnitCode	/*CHAR(2)*/		NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'ContractLocation_TableType' AND is_table_type = 1)
DROP TYPE ContractLocation_TableType
GO

CREATE TYPE ContractLocation_TableType AS TABLE 
(
	LocationID				LocationID	/*INT*/	NOT NULL,
	IsLocationScheduled		BIT						NULL
)
GO



IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'ObjectInstanceTask_TableType' AND is_table_type = 1)
DROP TYPE ObjectInstanceTask_TableType
GO

CREATE TYPE ObjectInstanceTask_TableType AS TABLE 
(
	InspectionID				InspectionID		NOT NULL,
	ObjectInstanceID			ObjectInstanceID	NOT NULL,

	CheckListTaskID				CheckListTaskID		NOT NULL,
	InspectionValueBit			BIT						NULL,
	InspectionValueFloat		FLOAT					NULL,
	InspectionValueDateTime		DATETIME				NULL,
	InspectionValueString		NVARCHAR(4000)			NULL,

	Photo						FileID					NULL,
	FileName					NVARCHAR(100)			NULL,
	FileType					VARCHAR(10)				NULL,
	FileSize					BIGINT					NULL,
	FileRemarks					NVARCHAR(200)			NULL,
	
	PhotoSmall					FileID					NULL,	-- will have when image is change
	FileNameSmall				NVARCHAR(100)			NULL,
	FileTypeSmall				VARCHAR(10)				NULL,
	FileSizeSmall				BIGINT					NULL,
	FileRemarksSmall			NVARCHAR(200)			NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'InspectionDeviationTypeDeviation_TableType' AND is_table_type = 1)
DROP TYPE InspectionDeviationTypeDeviation_TableType
GO
-- Use to add/edit from Inspection form.
CREATE TYPE InspectionDeviationTypeDeviation_TableType AS TABLE 
(
	InspectionID				InspectionID		NOT NULL,
	ObjectInstanceID			ObjectInstanceID	NOT NULL,

	DeviationID					DeviationID				NULL, -- will have value while edit
	DeviationTypeID				DeviationTypeID		NOT NULL,
	DeviationDescription		LongRemarks				NULL,
	CheckListTaskID				CheckListTaskID			NULL,
	DeviationDateTime			DATETIME				NULL,  -- UTCTIME COMES FROM CONTROLLER LEVEL & WILL have value when new or update deviation remarks

	IsSpotResolved				BIT						NULL,
	ResolutionRemarks			LongRemarks				NULL
)
GO


IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'ObjectDeviationPhotoElement_TableType' AND is_table_type = 1)
	DROP TYPE ObjectDeviationPhotoElement_TableType
GO
-- Use to add/edit from Inspection form. old ObjectPhoto_TableType
CREATE TYPE ObjectDeviationPhotoElement_TableType AS TABLE 
(
	--InspectionID				InspectionID			NOT NULL,  --need to check why this column is droped from here
	--ObjectInstanceID			ObjectInstanceID		NOT NULL,

	DeviationTypeID				DeviationTypeID			NOT NULL,
	DeviationID					DeviationID					NULL,	-- will have value while edit
	
	PhotoDateTime				DATETIME					NULL,	-- will have value while edit/utc time at controller level
	
	Remarks						ShortRemarks				NULL,	--nvarchar 100
	
	ObjectDeviationPhotoID		ObjectPhotoID				NULL,
	PhotoSequence				TINYINT						NULL,
	
	Photo						FileID						NULL,
	FileName					NVARCHAR(100)				NULL,
	FileType					VARCHAR(10)					NULL,
	FileSize					BIGINT						NULL,
	FileRemarks					NVARCHAR(200)				NULL,
	
	PhotoSmall					FileID						NULL,	-- will have when image is change
	FileNameSmall				NVARCHAR(100)				NULL,
	FileTypeSmall				VARCHAR(10)					NULL,
	FileSizeSmall				BIGINT						NULL,
	FileRemarksSmall			NVARCHAR(200)				NULL
)
GO


IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'ObjectInspectionPhotoElement_TableType' AND is_table_type = 1)
DROP TYPE ObjectInspectionPhotoElement_TableType
GO
-- Use to add/edit from Inspection form. old ObjectPhoto_TableType
CREATE TYPE ObjectInspectionPhotoElement_TableType AS TABLE 
(
	ObjectInstanceID			ObjectInstanceID	NOT NULL,
	PhotoDateTime				DATETIME				NULL,	-- will have value while edit/utc time at controller level
	PhotoSequence				TINYINT					NULL,

	Photo						FileID					NULL,
	FileName					NVARCHAR(100)			NULL,
	FileType					VARCHAR(10)				NULL,
	FileSize					BIGINT					NULL,
	FileRemarks					NVARCHAR(200)			NULL,

	PhotoSmall					FileID					NULL,	-- will have when image is change
	FileNameSmall				NVARCHAR(100)			NULL,
	FileTypeSmall				VARCHAR(10)				NULL,
	FileSizeSmall				BIGINT					NULL,
	FileRemarksSmall			NVARCHAR(200)			NULL,

	Longitude					FLOAT					NULL,
	Latitude					FLOAT					NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'ServiceLineCode_TableTypeList' AND is_table_type = 1)
DROP TYPE ServiceLineCode_TableTypeList
GO
-- Use to add/edit from Inspection form.
CREATE TYPE ServiceLineCode_TableTypeList AS TABLE 
(
	ServiceLineCode			ServiceLineCode		NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'LocationRiskLevel_TableTypeList' AND is_table_type = 1)
DROP TYPE LocationRiskLevel_TableTypeList
GO
CREATE TYPE LocationRiskLevel_TableTypeList AS TABLE 
(
	ModuleCode			ModuleCode		NOT NULL,
	RiskLevelID			RiskLevelID		NOT NULL
)
GO


IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'InspectionType_TableTypeList' AND is_table_type = 1)
DROP TYPE InspectionType_TableTypeList
GO

CREATE TYPE InspectionType_TableTypeList AS TABLE 
(
	InspectionTypeCode   NVARCHAR(20) NOT NULL
)
GO


IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'EmergencyInspectionCategory_TableType' AND is_table_type = 1)
DROP TYPE EmergencyInspectionCategory_TableType
GO

CREATE TYPE EmergencyInspectionCategory_TableType AS TABLE 
(
	CategoryID	CategoryID	NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'CustomerWeeklyOffName_TableType' AND is_table_type = 1)
DROP TYPE CustomerWeeklyOffName_TableType
GO

CREATE TYPE CustomerWeeklyOffName_TableType AS TABLE 
(
	DayName  NVARCHAR(15) NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'Controller_TableType' AND is_table_type = 1)
DROP TYPE Controller_TableType
GO

CREATE TYPE Controller_TableType AS TABLE 
(
	EndUserID			INTEGER			NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'InspectionDates_TableType' AND is_table_type = 1)
	DROP TYPE InspectionDates_TableType
GO

CREATE TYPE InspectionDates_TableType AS TABLE 
(
	InspectionNo		SMALLINT	NOT NULL,
	InspectionStartDate	DATE		NOT NULL,
	InspectionEndDate	DATE		NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'DeviationRepairComponent_TableTypeList' AND is_table_type = 1)
DROP TYPE DeviationRepairComponent_TableTypeList
GO

CREATE TYPE DeviationRepairComponent_TableTypeList AS TABLE 
(
	DeviationID				DeviationID			NOT NULL,
 	RepairComponentID		RepairComponentID	NOT	NULL,
	UsedQuantity			FLOAT					NULL,
	RequiredQuantity		FLOAT					NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'DeviationDeviationTypeResolution_TableTypeList' AND is_table_type = 1)
DROP TYPE DeviationDeviationTypeResolution_TableTypeList
GO

CREATE TYPE DeviationDeviationTypeResolution_TableTypeList AS TABLE 
(
	DeviationID						DeviationID					NOT NULL,
 	DeviationTypeResolutionID		DeviationTypeResolutionID	NOT	NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'CheckListTaskList_TableType' AND is_table_type = 1)
DROP TYPE CheckListTaskList_TableType
GO

CREATE TYPE CheckListTaskList_TableType AS TABLE (
	
	CheckListTaskID		CheckListTaskID NOT NULL
)
GO


IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'UserLocation_TableType' AND is_table_type = 1)
DROP TYPE UserLocation_TableType
GO

CREATE TYPE UserLocation_TableType AS TABLE 
(
	 ModuleCode ModuleCode /*CHAR(2)*/ NOT NULL,
	 ServiceLineCode	ServiceLineCode	/*CHAR(2)*/	 NULL,
	 LocationID	LocationID	/*INT*/	NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'SchedulerEditDates_TableType' AND is_table_type = 1)
	DROP TYPE SchedulerEditDates_TableType
GO

CREATE TYPE SchedulerEditDates_TableType AS TABLE 
(
	InspectionID		INTEGER	NOT NULL,
	InspectionStartDate	DATE	NOT NULL,
	InspectionEndDate	DATE	NOT NULL
)
GO

/* Use for Drop down search*/
IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'Customer_TableType' AND is_table_type = 1)
DROP TYPE Customer_TableType
GO

CREATE TYPE Customer_TableType AS TABLE 
(
	 CustomerID		CustomerID /*short*/ NOT NULL,
	 CustomerName	GenericName	 NULL
)
GO
 
IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'DeviationList_TableType' AND is_table_type = 1)
DROP TYPE DeviationList_TableType
GO
-- Use to add/edit from Inspection form.
CREATE TYPE DeviationList_TableType AS TABLE 
(
	DeviationID					DeviationID				NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'DeviationResolutionRemarksPhotoElement_TableType' AND is_table_type = 1)
	DROP TYPE DeviationResolutionRemarksPhotoElement_TableType
GO
-- Use to add/edit from Inspection form. old ObjectPhoto_TableType
CREATE TYPE DeviationResolutionRemarksPhotoElement_TableType AS TABLE 
(
 	DeviationID					DeviationID				NOT	NULL,	-- will have value while edit
	
	PhotoDateTime				DATETIME					NULL,	-- will have value while edit/utc time at controller level
	
	Remarks						ShortRemarks				NULL,	--nvarchar 100
	
	DeviationTypeResolutionID	DeviationTypeResolutionID	NULL,--Currently not in use

	PhotoSequence				TINYINT						NULL,
	
	Photo						FileID						NULL,
	FileName					NVARCHAR(100)				NULL,
	FileType					VARCHAR(10)					NULL,
	FileSize					BIGINT						NULL,
	FileRemarks					NVARCHAR(200)				NULL,
	
	PhotoSmall					FileID						NULL,	-- will have when image is change
	FileNameSmall				NVARCHAR(100)				NULL,
	FileTypeSmall				VARCHAR(10)					NULL,
	FileSizeSmall				BIGINT						NULL,
	FileRemarksSmall			NVARCHAR(200)				NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'InspectionDelete_TableType' AND is_table_type = 1)
	DROP TYPE InspectionDelete_TableType
GO

CREATE TYPE InspectionDelete_TableType AS TABLE 
(
 	InspectionID					InspectionID				NOT	NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'GeneralSchedulerCategory_TableType' AND is_table_type = 1)
	DROP TYPE GeneralSchedulerCategory_TableType
GO

CREATE TYPE GeneralSchedulerCategory_TableType AS TABLE 
(
 	CategoryID			CategoryID		NOT	NULL,
	CheckListID			CheckListID		NOT	NULL
)
GO


IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'DeviationTypeDepartment_TableType' AND is_table_type = 1)
	DROP TYPE DeviationTypeDepartment_TableType
GO

CREATE TYPE DeviationTypeDepartment_TableType AS TABLE 
(
 	DeviationTypeID		DeviationTypeID		NOT	NULL,
	DepartmentID		DepartmentID		NOT	NULL,
	IsDefault			BIT					NOT	NULL
)
GO
 
IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'CheckListTaskCopyPaste_TableType' AND is_table_type = 1)
DROP TYPE CheckListTaskCopyPaste_TableType
GO

CREATE TYPE CheckListTaskCopyPaste_TableType AS TABLE 
(
	CheckListTaskID			CheckListTaskID	NOT NULL,
	CheckListTaskName		HugeName		NOT NULL,
	IsMandatory				BIT				NOT NULL,
	ChecklistTaskGroupID	GroupID				NULL,
	TaskSequence			SMALLINT		NOT NULL
)
GO

