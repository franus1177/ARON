/* ==================================================================================
	Source File		:	schemaFileService.sql
	Author(s)		:	Jitendra Loyal
	Started On		:	Mon Jul 10 15:06 2017
	==================================================================================
																		   Usage Notes
	----------------------------------------------------------------------------------
		Common suffixes used:
			id	Identifier		--- used for System generated identifiers
			nm	Name

		* Integrity checks that should be performed
			+ Files in database exist physically. (DB & FS)
			+ Physical Files have an entry in database. (DB & FS)
	==================================================================================
																	  Revision History
	----------------------------------------------------------------------------------
		10-Jul-2017 : JL
			Initial Versions
	==================================================================================*/

-- =============================================================================

CREATE	TABLE	Folder
(
	FolderID			INTEGER				NOT NULL	IDENTITY (1, 1)
														CONSTRAINT	Folder_PK_FolderID
															PRIMARY KEY	CLUSTERED,

		--- The folder path is always preceded by a backward slash (\).
	FolderPath			VARCHAR (250)		NOT NULL	CONSTRAINT	Folder_UK_FolderPath
															UNIQUE	NONCLUSTERED
)
GO


CREATE	TABLE	FolderFile
(
 		--- Physical file is created by reversing the digits in fileID. This is to facilitate better indexing for
		--- performance by changing the most significant digits (instead of least significant digits without reversing).
	FileID				BIGINT				NOT NULL	IDENTITY (1, 1)
														CONSTRAINT	FolderFile_PK_FileID
															PRIMARY KEY	NONCLUSTERED,
		
		--	A folder contains files of a maximum of 1000 files.
		---	
	FolderID			INTEGER					NULL	CONSTRAINT	FolderFile_FK_FolderID
															REFERENCES	Folder,

		--- The following two columns represent the entity and its instance where the File ID is used.
	ObjectType			VARCHAR (20)		NOT	NULL,

		--- This column stores the Instance ID (Primary Key) of the Object where File is used like Property ID or Satsang Place ID.
	ObjectInstanceID	INTEGER				NOT NULL,

		--- File name as is provided by the user. It should NOT contain any slash (forward or backward).
	FileName			NVARCHAR (100)		NOT NULL,

		-- Only alphabets and digits are allowed. This signifies the application that needs to be invoked to render the file.
	FileType			VARCHAR (10)		NOT	NULL,

	FileSize			BIGINT				NOT NULL,

		--- This specifies information about the file
	FileRemarks			NVARCHAR (200)			NULL,

	CreatedDateTime		DATETIME			NOT	NULL,
	LastAccessDateTime	DATETIME				NULL,
	DeletedDateTime		DATETIME				NULL,

	AccessCount			INTEGER				NOT NULL,

	TxnTimestamp		ROWVERSION			NOT NULL
)
GO

-- =============================================================================

IF EXISTS(SELECT 1 FROM sys.types WHERE name = 'FileID_TableType' AND is_table_type = 1)
DROP TYPE FileID_TableType
GO

CREATE TYPE FileID_TableType AS TABLE	
(
	FileID			BIGINT		NOT	NULL	PRIMARY	KEY	
)
GO

-- =============================================================================

-- vim:ts=4 sw=4 ht=4