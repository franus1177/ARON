/* ==================================================================================
	Source File		:	Primitives.sql
	Author(s)		:	Jitendra Loyal
	Started On		:	May 12 2017
	==================================================================================
																		   Usage Notes
	----------------------------------------------------------------------------------
		Defines the following data-types:
			ResolutionDuration

		Defines the following generic domains:
			TinyInt		:	
			SmallInt	:	DisplayOrder
			Integer		: 
			Numeric-
				(12,5)	: 
			Strings-
					25		:	ShortName^
					50		:	GenericName^, Mobile, Telephone
					100		:	AddressLine^, LongName^, Email, ShortRemarks^
					200		:	HugeName^
					500		;	Remarks^
					1000	:	LongRemarks^
					4000	:	HugeRemarks^

		Defines the data-types for following identifiers:
			Strings-
					2*	:	LanguageCode, ModuleCode, ServiceLineCode, TimeUnitCode
					5	:	CountryCode
					10	:	AttributeType
					10	:	GenericCode -- CheckListTaskCode/DeviationTypeCode
					20	:	ConfigurationCode, InspectionType
					40	:	SourceReference
			TinyInts	:	RiskLevelID, ServiceLevelID, SeverityLevelID
			SmallInts	:	AttributeID, CategoryID, CheckListID, CustomerID, DeviationTypeID,
							NotInUseReasonID, ObjectID, RepairComponentID, UOMID
			Integers	:	CategoryAttributeID, CheckListTaskID, ContractID, CustomerIRemarksID, CustomerLocationID,
							DeviationPhotoID, DeviationTypeResolutionID, InspectionID, LocationID, ObjectInstanceID, UserID,
							CourseDocumentID
			BigInts		:	FileID, DeviationID, ObjectInstanceInspectionID, ObjectPhotoID

	* indicates that the string is of type CHAR instead of usual VARCHAR
	^ indicates that the string is of type NVARCHAR instead of usual VARCHAR
	==================================================================================
																	  Revision History
	----------------------------------------------------------------------------------
     JL : 12 to ??-Sep-2017
		*   Initial versions
	==================================================================================*/

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

--	=============================================================================
--	DataType	Resolution Durarion
--	=============================================================================
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'ResolutionDuration' AND type = 'R')
BEGIN
	EXEC	sp_unbindrule	'ResolutionDuration'
	IF EXISTS (SELECT * FROM systypes WHERE name = 'ResolutionDuration')
	    EXEC	sp_droptype		'ResolutionDuration'
	DROP	RULE	ResolutionDuration
END
GO

CREATE	RULE	ResolutionDuration	AS	@VALUE	>	0
				    OR	@VALUE	IS NULL
GO

EXEC	sp_addtype	'ResolutionDuration',		'TINYINT',				'NULL'
GO

EXEC	sp_bindrule	'ResolutionDuration',		'ResolutionDuration'
GO


-- =============================================================================
-- Domains : Integers
-- =============================================================================

-- =============================================================================
IF EXISTS (SELECT * FROM systypes WHERE name = 'DisplayOrder')
	EXEC	sp_droptype	'DisplayOrder'
GO
EXEC	sp_addtype	'DisplayOrder',				SMALLINT,				'NULL'
GO

-- =============================================================================
-- Domains : Strings
-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'ShortName')
	EXEC	sp_droptype	'ShortName'
GO

EXEC	sp_addtype	'ShortName',				'NVARCHAR (25)',		'NULL'
GO
-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'ZipCode')
	EXEC	sp_droptype	'ZipCode'
GO

EXEC	sp_addtype	'ZipCode',				'NVARCHAR (10)',		'NULL'
GO


-- =============================================================================
IF EXISTS (SELECT * FROM systypes WHERE name = 'GenericName')
	EXEC	sp_droptype	'GenericName'
GO

EXEC	sp_addtype	'GenericName',				'NVARCHAR (50)',		'NULL'
GO

-- =============================================================================
IF EXISTS (SELECT * FROM systypes WHERE name = 'Mobile')
	EXEC	sp_droptype	'Mobile'
GO

EXEC	sp_addtype	'Mobile',					'VARCHAR (50)',			'NULL'
GO

-- =============================================================================
IF EXISTS (SELECT * FROM systypes WHERE name = 'Telephone')
	EXEC	sp_droptype	'Telephone'
GO

EXEC	sp_addtype	'Telephone',				'VARCHAR (50)',			'NULL'
GO

-- =============================================================================
IF EXISTS (SELECT * FROM systypes WHERE name = 'AddressLine')
	EXEC	sp_droptype	'AddressLine'
GO

EXEC	sp_addtype	'AddressLine',				'NVARCHAR (100)',		'NULL'
GO

-- =============================================================================
IF EXISTS (SELECT * FROM systypes WHERE name = 'LongName')
	EXEC	sp_droptype	'LongName'
GO

EXEC	sp_addtype	'LongName',					'NVARCHAR (100)',		'NULL'
GO

-- =============================================================================
IF EXISTS (SELECT * FROM systypes WHERE name = 'HugeName')
	EXEC	sp_droptype	'HugeName'
GO

EXEC	sp_addtype	'HugeName',					'NVARCHAR (200)',		'NULL'
GO

-- =============================================================================
IF EXISTS (SELECT * FROM systypes WHERE name = 'Email')
	EXEC	sp_droptype	'Email'
GO

EXEC	sp_addtype	'Email',					'VARCHAR (100)',		'NULL'
GO

-- =============================================================================
IF EXISTS (SELECT * FROM systypes WHERE name = 'ShortRemarks')
	EXEC	sp_droptype	'ShortRemarks'
GO

EXEC	sp_addtype	'ShortRemarks',				'NVARCHAR (100)',		'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'Remarks')
	EXEC	sp_droptype	'Remarks'
GO

EXEC	sp_addtype	'Remarks',					'NVARCHAR (500)',		'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'LongRemarks')
	EXEC	sp_droptype	'LongRemarks'
GO

EXEC	sp_addtype	'LongRemarks',				'NVARCHAR (1000)',		'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'HugeRemarks')
	EXEC	sp_droptype	'HugeRemarks'
GO

EXEC	sp_addtype	'HugeRemarks',				'NVARCHAR (4000)',		'NULL'
GO

-- =============================================================================
--	Identifiers	: Strings
-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'LanguageCode')
	EXEC	sp_droptype	'LanguageCode'
GO

EXEC	sp_addtype	'LanguageCode',				'CHAR (2)',				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'ModuleCode')
	EXEC	sp_droptype	'ModuleCode'
GO

EXEC	sp_addtype	'ModuleCode',				'CHAR (2)',				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'ServiceLineCode')
	EXEC	sp_droptype	'ServiceLineCode'
GO

EXEC	sp_addtype	'ServiceLineCode',			'CHAR (2)',				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'TimeUnitCode')
	EXEC	sp_droptype	'TimeUnitCode'
GO

EXEC	sp_addtype	'TimeUnitCode',				'CHAR (2)',				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'CountryCode')
	EXEC	sp_droptype	'CountryCode'
GO

EXEC	sp_addtype	'CountryCode',				'VARCHAR (5)',			'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'AttributeType')
	EXEC	sp_droptype	'AttributeType'
GO

EXEC	sp_addtype	'AttributeType',			'VARCHAR (10)',			'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'GenericCode')
	EXEC	sp_droptype	'GenericCode'
GO

EXEC	sp_addtype	'GenericCode',			'NVARCHAR (10)',			'NULL'
GO
-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'ConfigurationCode')
	EXEC	sp_droptype	'ConfigurationCode'
GO

EXEC	sp_addtype	'ConfigurationCode',		'VARCHAR (20)',			'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'InspectionType')
	EXEC	sp_droptype	'InspectionType'
GO

EXEC	sp_addtype	'InspectionType',			'NVARCHAR (20)',		'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'SourceReference')
	EXEC	sp_droptype	'SourceReference'
GO

EXEC	sp_addtype	'SourceReference',			'NVARCHAR (40)',		'NULL'
GO

-- =============================================================================

-- =============================================================================
--	Identifiers	: Numbers - TinyInt
-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'RiskLevelID')
	EXEC	sp_droptype	'RiskLevelID'
GO

EXEC	sp_addtype	'RiskLevelID',				'TINYINT',				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'ServiceLevelID')
	EXEC	sp_droptype	'ServiceLevelID'
GO

EXEC	sp_addtype	'ServiceLevelID',			'TINYINT',				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'SeverityLevelID')
	EXEC	sp_droptype	'SeverityLevelID'
GO

EXEC	sp_addtype	'SeverityLevelID',			'TINYINT',				'NULL'
GO


-- =============================================================================

-- =============================================================================
--	Identifiers	: Numbers - SmallInt
-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'AttributeID')
	EXEC	sp_droptype	'AttributeID'
GO
EXEC	sp_addtype	'AttributeID',				SMALLINT,				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'CategoryID')
	EXEC	sp_droptype	'CategoryID'
GO
EXEC	sp_addtype	'CategoryID',				SMALLINT,				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'CheckListID')
	EXEC	sp_droptype	'CheckListID'
GO
EXEC	sp_addtype	'CheckListID',				SMALLINT,				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'CustomerID')
	EXEC	sp_droptype	'CustomerID'
GO
EXEC	sp_addtype	'CustomerID',				SMALLINT,				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'DeviationTypeID')
	EXEC	sp_droptype	'DeviationTypeID'
GO
EXEC	sp_addtype	'DeviationTypeID',			SMALLINT,				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'NotInUseReasonID')
	EXEC	sp_droptype	'NotInUseReasonID'
GO
EXEC	sp_addtype	'NotInUseReasonID',			SMALLINT,				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'ObjectID')
	EXEC	sp_droptype	'ObjectID'
GO
EXEC	sp_addtype	'ObjectID',					SMALLINT,				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'RepairComponentID')
	EXEC	sp_droptype	'RepairComponentID'
GO
EXEC	sp_addtype	'RepairComponentID',		SMALLINT,				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'UOMID')
	EXEC	sp_droptype	'UOMID'
GO
EXEC	sp_addtype	'UOMID',					SMALLINT,				'NULL'
GO

-- =============================================================================
--	Identifiers	: Numbers - Integer
-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'CategoryAttributeID')
	EXEC	sp_droptype	'CategoryAttributeID'
GO
EXEC	sp_addtype	'CategoryAttributeID',		INTEGER,				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'CheckListTaskID')
	EXEC	sp_droptype	'CheckListTaskID'
GO
EXEC	sp_addtype	'CheckListTaskID',			INTEGER,				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'ContractID')
	EXEC	sp_droptype	'ContractID'
GO
EXEC	sp_addtype	'ContractID',				INTEGER,				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'CustomerLocationID')
	EXEC	sp_droptype	'CustomerLocationID'
GO
EXEC	sp_addtype	'CustomerLocationID',		INTEGER,				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'CustomerIRemarksID')
	EXEC	sp_droptype	'CustomerIRemarksID'
GO
EXEC	sp_addtype	'CustomerIRemarksID',		INTEGER,				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'DeviationPhotoID')
	EXEC	sp_droptype	'DeviationPhotoID'
GO
EXEC	sp_addtype	'DeviationPhotoID',			INTEGER,				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'DeviationTypeResolutionID')
	EXEC	sp_droptype	'DeviationTypeResolutionID'
GO
EXEC	sp_addtype	'DeviationTypeResolutionID',INTEGER,				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'InspectionID')
	EXEC	sp_droptype	'InspectionID'
GO
EXEC	sp_addtype	'InspectionID',				INTEGER,				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'LocationID')
	EXEC	sp_droptype	'LocationID'
GO
EXEC	sp_addtype	'LocationID',				INTEGER,				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'ObjectInstanceID')
	EXEC	sp_droptype	'ObjectInstanceID'
GO
EXEC	sp_addtype	'ObjectInstanceID',			INTEGER,				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'UserID')
	EXEC	sp_droptype	'UserID'
GO
EXEC	sp_addtype	'UserID',					INTEGER,				'NULL'
GO

-- =============================================================================

-- =============================================================================
--	Identifiers	: Numbers - BIGINT
-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'DeviationID')
	EXEC	sp_droptype	'DeviationID'
GO
EXEC	sp_addtype	'DeviationID',					BIGINT,				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'FileID')
	EXEC	sp_droptype	'FileID'
GO
EXEC	sp_addtype	'FileID',						BIGINT,				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'ObjectInstanceInspectionID')
	EXEC	sp_droptype	'ObjectInstanceInspectionID'
GO
EXEC	sp_addtype	'ObjectInstanceInspectionID',	BIGINT,				'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'ObjectPhotoID')
	EXEC	sp_droptype	'ObjectPhotoID'
GO
EXEC	sp_addtype	'ObjectPhotoID',				BIGINT,				'NULL'
GO

-- =============================================================================


-- New Added Training base module
-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'EmployeeID')
 EXEC sp_droptype 'EmployeeID'
GO
EXEC sp_addtype 'EmployeeID',     INTEGER,    'NULL'
GO
--VD Feb 2018

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'DepartmentID')
 EXEC sp_droptype 'DepartmentID'
GO
EXEC sp_addtype 'DepartmentID',     SMALLINT,    'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'DesignationID')
 EXEC sp_droptype 'DesignationID'
GO
EXEC sp_addtype 'DesignationID',     SMALLINT,    'NULL'
GO

-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'DocumentTypeID')
	EXEC	sp_droptype	'DocumentTypeID'
GO

EXEC	sp_addtype	'DocumentTypeID',			'TINYINT',				'NULL'
GO
-- =============================================================================

IF EXISTS (SELECT * FROM systypes WHERE name = 'DocumentID')
 EXEC sp_droptype 'DocumentID'
GO
EXEC sp_addtype 'DocumentID',     INT,    'NULL'
GO



-- vim:ts=4 ht=8 sw=4

/************************ Primitives for Incident module *****************/

IF EXISTS (SELECT * FROM systypes WHERE name = 'IncidentCategoryID')
 EXEC sp_droptype 'IncidentCategoryID'
GO
EXEC sp_addtype 'IncidentCategoryID',     SMALLINT,    'NULL'
GO

IF EXISTS (SELECT * FROM systypes WHERE name = 'IncidentTypeID')
 EXEC sp_droptype 'IncidentTypeID'
GO
EXEC sp_addtype 'IncidentTypeID',     TINYINT,    'NULL'
GO


IF EXISTS (SELECT * FROM systypes WHERE name = 'PriorityID')
 EXEC sp_droptype 'PriorityID'
GO
EXEC sp_addtype 'PriorityID',     TINYINT,    'NULL'
GO

IF EXISTS (SELECT * FROM systypes WHERE name = 'IncidentStatusID')
 EXEC sp_droptype 'IncidentStatusID'
GO
EXEC sp_addtype 'IncidentStatusID',     TINYINT,    'NULL'
GO

IF EXISTS (SELECT * FROM systypes WHERE name = 'IncidentImpactTypeID')
 EXEC sp_droptype 'IncidentImpactTypeID'
GO
EXEC sp_addtype 'IncidentImpactTypeID',     TINYINT,    'NULL'
GO

IF EXISTS (SELECT * FROM systypes WHERE name = 'IncidentCauseTypeID')
 EXEC sp_droptype 'IncidentCauseTypeID'
GO
EXEC sp_addtype 'IncidentCauseTypeID',     TINYINT,    'NULL'
GO


IF EXISTS (SELECT * FROM systypes WHERE name = 'IncidentID')
 EXEC sp_droptype 'IncidentID'
GO
EXEC sp_addtype 'IncidentID',     INT,    'NULL'
GO

IF EXISTS (SELECT * FROM systypes WHERE name = 'GroupID')
 EXEC sp_droptype 'GroupID'
GO
EXEC sp_addtype 'GroupID',     SMALLINT,    'NULL'
GO

IF EXISTS (SELECT * FROM systypes WHERE name = 'IncidentInspectionTaskID')
 EXEC sp_droptype 'IncidentInspectionTaskID'
GO
EXEC sp_addtype 'IncidentInspectionTaskID',     INT,    'NULL'
GO


/************************ Primitives for Drill module *****************/

IF EXISTS (SELECT * FROM systypes WHERE name = 'DrillTypeID')
 EXEC sp_droptype 'DrillTypeID'
GO
EXEC sp_addtype 'DrillTypeID',     TINYINT,    'NULL'
GO

IF EXISTS (SELECT * FROM systypes WHERE name = 'DrillActionTypeID')
 EXEC sp_droptype 'DrillActionTypeID'
GO
EXEC sp_addtype 'DrillActionTypeID',     TINYINT,    'NULL'
GO

IF EXISTS (SELECT * FROM systypes WHERE name = 'StakeHolderID')
 EXEC sp_droptype 'StakeHolderID'
GO
EXEC sp_addtype 'StakeHolderID',     SMALLINT,    'NULL'
GO

IF EXISTS (SELECT * FROM systypes WHERE name = 'DepartmentID')
 EXEC sp_droptype 'DepartmentID'
GO
EXEC sp_addtype 'DepartmentID',     SMALLINT,    'NULL'
GO 

IF EXISTS (SELECT * FROM systypes WHERE name = 'DrillID')
 EXEC sp_droptype 'DrillID'
GO
EXEC sp_addtype 'DrillID',     INT,    'NULL'
GO 

IF EXISTS (SELECT * FROM systypes WHERE name = 'DrillSetupID')
 EXEC sp_droptype 'DrillSetupID'
GO
EXEC sp_addtype 'DrillSetupID',     INT,    'NULL'
GO 

IF EXISTS (SELECT * FROM systypes WHERE name = 'DrillDataID')
 EXEC sp_droptype 'DrillDataID'
GO
EXEC sp_addtype 'DrillDataID',     INT,    'NULL'
GO 

/**************** Training Module **********************/

IF EXISTS (SELECT * FROM systypes WHERE name = 'CourseTypeID')
 EXEC sp_droptype 'CourseTypeID'
GO
EXEC sp_addtype 'CourseTypeID',     SMALLINT,    'NULL'
GO 

IF EXISTS (SELECT * FROM systypes WHERE name = 'CourseID')
 EXEC sp_droptype 'CourseID'
GO
EXEC sp_addtype 'CourseID',     SMALLINT,    'NULL'
GO 

IF EXISTS (SELECT * FROM systypes WHERE name = 'CourseCode')
 EXEC sp_droptype 'CourseCode'
GO
EXEC sp_addtype 'CourseCode',     'NVARCHAR (10)',    'NULL'
GO 


IF EXISTS (SELECT * FROM systypes WHERE name = 'CertificationID')
 EXEC sp_droptype 'CertificationID'
GO
EXEC sp_addtype 'CertificationID',     SMALLINT,    'NULL'
GO 

IF EXISTS (SELECT * FROM systypes WHERE name = 'ShortCode')
	EXEC	sp_droptype	'ShortCode'
GO

EXEC	sp_addtype	'ShortCode',				'VARCHAR (10)',			'NULL'
GO 

IF EXISTS (SELECT * FROM systypes WHERE name = 'CertificationCode')
	EXEC	sp_droptype	'CertificationCode'
GO

EXEC	sp_addtype	'CertificationCode',				'VARCHAR (10)',			'NULL'
GO 


IF EXISTS (SELECT * FROM systypes WHERE name = 'TrainingID')
 EXEC sp_droptype 'TrainingID'
GO
EXEC sp_addtype 'TrainingID',     INT,    'NULL'
GO 

IF EXISTS (SELECT * FROM systypes WHERE name = 'FeedbackParameterID')
 EXEC sp_droptype 'FeedbackParameterID'
GO
EXEC sp_addtype 'FeedbackParameterID',     SMALLINT,    'NULL'
GO 


IF EXISTS (SELECT * FROM systypes WHERE name = 'FeedbackParameterValueID')
 EXEC sp_droptype 'FeedbackParameterValueID'
GO
EXEC sp_addtype 'FeedbackParameterValueID',     SMALLINT,    'NULL'
GO 

IF EXISTS (SELECT * FROM systypes WHERE name = 'TrainingEnrolmentID')
 EXEC sp_droptype 'TrainingEnrolmentID'
GO
EXEC sp_addtype 'TrainingEnrolmentID',     SMALLINT,    'NULL'
GO 

IF EXISTS (SELECT * FROM systypes WHERE name = 'AssessmentParameterID')
 EXEC sp_droptype 'AssessmentParameterID'
GO
EXEC sp_addtype 'AssessmentParameterID',     INT,    'NULL'
GO 

IF EXISTS (SELECT * FROM systypes WHERE name = 'TrainingAssessmentID')
 EXEC sp_droptype 'TrainingAssessmentID'
GO
EXEC sp_addtype 'TrainingAssessmentID',     INT,    'NULL'
GO 

IF EXISTS (SELECT * FROM systypes WHERE name = 'CourseDocumentID')
 EXEC sp_droptype 'CourseDocumentID'
GO
EXEC sp_addtype 'CourseDocumentID',     INTEGER,    'NULL'
GO

IF EXISTS (SELECT * FROM systypes WHERE name = 'SquadCode')
 EXEC sp_droptype 'SquadCode'
GO
EXEC sp_addtype 'SquadCode',     'VARCHAR(5)',    'NULL'
GO

IF EXISTS (SELECT * FROM systypes WHERE name = 'ShiftCode')
 EXEC sp_droptype 'ShiftCode'
GO
EXEC sp_addtype 'ShiftCode',     'VARCHAR(5)',    'NULL'
GO



IF EXISTS (SELECT * FROM systypes WHERE name = 'WorkPermitTypeID')
 EXEC sp_droptype 'WorkPermitTypeID'
GO
EXEC sp_addtype 'WorkPermitTypeID',     SMALLINT,    'NULL'
GO 


IF EXISTS (SELECT * FROM systypes WHERE name = 'WorkPermitID')
 EXEC sp_droptype 'WorkPermitID'
GO
EXEC sp_addtype 'WorkPermitID',     SMALLINT,    'NULL'
GO 

