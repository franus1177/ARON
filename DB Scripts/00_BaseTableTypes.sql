IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'ScreenTable_TableType' AND is_table_type = 1)
DROP TYPE ScreenTable_TableType
GO

CREATE TYPE ScreenTable_TableType AS TABLE
(
	TableName			VARCHAR(50)		NULL,
	IsSingleTuple		BIT				NULL,
	IsDetailFetched		BIT				NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'ScreenAction_TableType' AND is_table_type = 1)
DROP TYPE ScreenAction_TableType
GO
-- also used to insert in UserRoleScreenAction table
CREATE TYPE ScreenAction_TableType  AS TABLE
(
	ActionCode			VARCHAR(15)		NOT NULL,
	ActionName			VARCHAR(50)		NOT NULL,
	Sequence			TINYINT			NOT NULL,
	IsAudited			BIT				NOT NULL,
	IsRendered			BIT				NOT NULL
)

GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'UserRoleScreen_TableType' AND is_table_type = 1)
DROP TYPE UserRoleScreen_TableType
GO

CREATE TYPE UserRoleScreen_TableType AS TABLE
(
	UserRoleID			  SMALLINT		NOT NULL,
	ScreenID			  SMALLINT		NOT NULL,
	HasInsert			  BIT			NOT NULL,
	HasUpdate			  BIT			NOT NULL,	
	HasDelete			  BIT			NOT NULL,
	HasSelect			  BIT			NOT NULL,
	HasImport			  BIT			NOT NULL,
	HasExport			  BIT			NOT NULL,
	UserRoleScreenActions VARCHAR(MAX)		NULL 
)

GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'UserRoleScreenAction_TableType' AND is_table_type = 1)
DROP TYPE UserRoleScreenAction_TableType
GO
-- also used to insert in UserRoleScreenAction table
CREATE TYPE UserRoleScreenAction_TableType  AS TABLE
(
	UserRoleID			SMALLINT		NOT NULL,
	ScreenID			SMALLINT		NOT NULL,
	ActionCode			VARCHAR(15)		NOT NULL
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

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'EndUserModule_TableType' AND is_table_type = 1)
DROP TYPE EndUserModule_TableType
GO

CREATE TYPE EndUserModule_TableType AS TABLE
(
	ModuleCode CHAR(2) NOT NULL
)
GO

/*use to upload inspection images & return relative path to upload at physical location*/
IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'FileUploadedReturn_TableType' AND is_table_type = 1)
DROP TYPE FileUploadedReturn_TableType
GO

CREATE TYPE FileUploadedReturn_TableType AS TABLE 
(
	Type				VARCHAR(50)		NOT NULL,
	DeviationID			DeviationID		NOT NULL,
	FileID				BIGINT			NOT NULL,
	FileName			NVARCHAR (100)	NOT NULL,
	FileType			VARCHAR (10)	NOT NULL,
	FileRelativePath	NVARCHAR(250)	NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'DocumentCategoryLanguage_TableType' AND is_table_type = 1)
	DROP TYPE DocumentCategoryLanguage_TableType
GO
CREATE TYPE DocumentCategoryLanguage_TableType AS TABLE 
(
	LanguageCode			LanguageCode	/*CHAR(2)*/		NOT NULL,
	DocumentCategoryName	GenericName	/*NVARCHAR(50)*/	NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'DocumentID_TableType' AND is_table_type = 1)
DROP TYPE DocumentID_TableType
GO

CREATE TYPE DocumentID_TableType AS TABLE 
(
	DocumentID	DocumentID	/*INT*/	NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'DepartmentLanguage_TableType' AND is_table_type = 1)
DROP TYPE DepartmentLanguage_TableType
GO

CREATE TYPE DepartmentLanguage_TableType AS TABLE(
	LanguageCode	LanguageCode	NOT NULL,
	DepartmentName	GenericName		NOT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'ChecklistTaskGroupLanguage_TableType' AND is_table_type = 1)
DROP TYPE ChecklistTaskGroupLanguage_TableType
GO

CREATE TYPE ChecklistTaskGroupLanguage_TableType AS TABLE 
(
	LanguageCode			LanguageCode	/*CHAR(2)*/			NOT NULL,
	ChecklistTaskGroupName	GenericName		/*NVARCHAR(50)*/	NOT NULL
)
GO

 
-- 520B48926D159FCCBD7574A8FFED53