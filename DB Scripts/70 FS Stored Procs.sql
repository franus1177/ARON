/* ==================================================================================
    Source File		:	procs_core.sql
    Author(s)		:	Jitendra Loyal
    Started On		:	Mon Jun 02 20:10 IST 2014
    Module ID		:	FLS
    Language		:	TRANSACT-SQL
    Last updated	:	26-Aug-2014
    ==================================================================================
																		   Usage Notes
    ----------------------------------------------------------------------------------
		It contains the following core procedures:
			AddFile				ObjectType, ObjectInstanceID, FileName, FileType, FileSize, Remarks, FileID OUT, FileRelativePath OUT
						Sequence is 1. BEGIN TRAN 2. EXEC AddFile 2. Create Physical File (if fails ROLLBACK) 4. COMMIT
			RemoveFile			FileID		--- Hard Delete
						Sequence is 1. BEGIN TRAN 2. EXEC RemoveFile 2. Delete Physical File (if fails ROLLBACK) 4. COMMIT
			DeleteFile			FileID, TxnTimestamp		--- Soft delete
			UnDeleteFile		FileID, TxnTimestamp
			UpdateFileInfo		FileID, Remarks, TxnTimestamp
			GetFileInfo			FileID, FileRelativePath OUT, FileName OUT, FileType OUT, FileSize OUT, Remarks OUT, CreationDateTime OUT, LastAccessDateTime OUT, AccessCount OUT, TxnTimestamp OUT
			GetFilesInfo		FileID_TableType
					RETUNRS a RECORD-SET of
								FileID, FileRelativePath, FileName, FileType, FileSize, Remarks, CreationDateTime, LastAccessDateTime, AccessCount, TxnTimestamp
			GetDeletedFilesInfo	FileName, FileType, Remarks
					RETUNRS a RECORD-SET of
								FileID, FileName, FileType, FileSize, Remarks, CreationDateTime, DeletedDateTime, TxnTimestamp
    ==================================================================================
								   									  Revision History
    ----------------------------------------------------------------------------------
			Initial Versions
    ==================================================================================*/

-- =============================================================================
--	Function	_GetFileNameForStorage
-- =============================================================================
IF EXISTS	(	SELECT  TOP 1 1
				FROM    information_schema.routines
				WHERE   routine_type	=	'Function'
				AND     specific_name	=	'_GetFileNameForStorage'
			)
	BEGIN
		DROP FUNCTION  _GetFileNameForStorage
	END
GO

CREATE FUNCTION _GetFileNameForStorage
(	
	@pFileID	BIGINT
)
RETURNS
	VARCHAR (20)
--WITH ENCRYPTION
AS
BEGIN
	DECLARE
		@FilePath	VARCHAR (20),
		@Len		TINYINT,
		@Mid		TINYINT,
		@i			TINYINT
	
	SET @FilePath = CONVERT (VARCHAR, @pFileID);
	SET @Len = LEN (@FilePath);
	SET @Mid = @Len / 2;
	SET @i = 0;
	WHILE (@i < @Mid)
	BEGIN
		SET @FilePath = SUBSTRING (@FilePath, 1, @i)
						+ SUBSTRING (@FilePath, @Len - @i * 2 +@i, 1)
						+ SUBSTRING (@FilePath, @i + 2, @Len - @i * 2 - 2)
						+ SUBSTRING (@FilePath, @i+1, 1)
						+ SUBSTRING (@FilePath, @Len - @i+1, @i)
		SET @i = @i + 1;
	END

	RETURN @FilePath;
END
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE Name = 'GetFileinfo_View')
DROP VIEW GetFileinfo_View
GO

CREATE	VIEW	GetFileinfo_View
AS
	SELECT	FileID,
			COALESCE (FolderPath, '\') + (CASE  WHEN FolderPath IS NULL THEN '' ELSE '\' END) + dbo._GetFileNameForStorage (f.FileID) FilePath,
			FileName,
			FileType,
			FileRemarks,
			CreatedDateTime,
			LastAccessDateTime,
			AccessCount,
			TxnTimestamp,
			DeletedDateTime
	FROM	FolderFile	f
		LEFT	JOIN	Folder	d
			ON	(	f.FolderID	=	d.FolderID)
GO


-- =============================================================================
--	Procedure	_GetFolder
-- =============================================================================
IF EXISTS	(	SELECT  TOP 1 1
				FROM    information_schema.routines
				WHERE   routine_type	=	'Procedure'
				AND     specific_name	=	'_GetFolder'
			)
	BEGIN
		DROP PROCEDURE  _GetFolder
	END
GO

CREATE PROCEDURE _GetFolder
(
	@pFileID		BIGINT,
	@pFolderID		INTEGER			OUTPUT,
	@pFolderPath	VARCHAR (250)	OUTPUT
)

--WITH ENCRYPTION
AS
BEGIN
	DECLARE
		@i					BIGINT,
		@j					BIGINT,
		@ascii_backslash	INT,
		@FolderID			INT;

	SET @ascii_backslash	=	92;		-- ASCII value of backslash \

	SET @i = @pFileID / 1000;
	SET @pFolderPath = '';

	WHILE (@i > 0)
	BEGIN
		SET @j = @i % 1000;
		SET @pFolderPath = @pFolderPath		+ CHAR (@ascii_backslash) + CONVERT (VARCHAR, @j) + 'd';
		SET @i = @i / 1000;
	END
	/*
	IF (@pFolderPath = '')
		SET @pFolderPath = CHAR (@ascii_backslash) + '0' + 'd';
		*/

	IF (@pFolderPath = '')
	BEGIN
		SET	@pFolderID	=	NULL;
	END
	ELSE
	BEGIN
		SELECT	@pFolderID	=	FolderID
		FROM	Folder
		WHERE	FolderPath	=	@pFolderPath;
		If (@@ROWCOUNT = 0)
		BEGIN
			INSERT	INTO	Folder	(	FolderPath	)	VALUES	(	@pFolderPath	);
			SET @pFolderID =  SCOPE_IDENTITY ();
		END
	END
	SET @pFolderPath = @pFolderPath	+ CHAR (@ascii_backslash);
END
GO

-- =============================================================================
--	Procedure	AddFile
-- =============================================================================
IF EXISTS	(	SELECT  TOP 1 1
				FROM    information_schema.routines
				WHERE   routine_type	=	'Procedure'
				AND     specific_name	=	'AddFile'
			)
	BEGIN
		DROP PROCEDURE  AddFile
	END
GO

CREATE PROCEDURE AddFile
(
	@pObjectType		VARCHAR (20),
	@pObjectInstanceID	INTEGER,
	@pFileName			NVARCHAR (100),
	@pFileType			VARCHAR (10),
	@pFileSize			BIGINT,
	@pFileRemarks		NVARCHAR (200),
	@pFileID			BIGINT			OUT,
	@pFileRelativePath	NVARCHAR (250)	OUT
)

--WITH ENCRYPTION
AS
BEGIN
	DECLARE
		@i					INTEGER,
		@j					INTEGER,
		@ch					CHAR,
		@ascii_backslash	INTEGER,
		@FolderID			INTEGER,
		@retval				INTEGER;

	SET @ascii_backslash	=	92;		-- ASCII value of backslash \  

	IF (@pFileName IS NULL OR @pFileName = N'')
	BEGIN
		RAISERROR ('File Name must be provided', 16, 1);
		RETURN -1;
	END

	IF (@pFileType IS NULL OR @pFileType = '')
	BEGIN
		RAISERROR ('File Type must be provided', 16, 1);
		RETURN -2;
	END

	IF (@pFileSize IS NULL OR @pFileSize <= 0)
	BEGIN
		RAISERROR ('File Size must be provided', 16, 1);
		RETURN -3;
	END

	--- Check that the file name does not contain slash character (forward or backward)
	-----------------------------------------------------------------------------------
	SET @i = CHARINDEX ('/', @pFileName)
	IF (@i > 0)
	BEGIN
		RAISERROR ('File name cannot have a Forward Slash (/)', 16, 1);
		RETURN -4;
	END

	SET @i = CHARINDEX (CHAR (@ascii_backslash), @pFileName)
	IF (@i > 0)
	BEGIN
		RAISERROR ('File name cannot have a Backward Slash (\)', 16, 1);
		RETURN -5;
	END

	--- Only alphabets and digits are allowed in file_format
	-----------------------------------------------------------------------------------
	SET @j = LEN (@pFileType);
	SET @i = 0;
	WHILE (@i < @j)
	BEGIN
		SET @i = @i + 1;
		SET @ch = SUBSTRING (@pFileType, @i, 1);
		IF (@ch NOT BETWEEN 'A' AND 'Z' AND @ch NOT BETWEEN '0' AND '9')
		BEGIN
			RAISERROR ('File Type cannot have characters other Alphabets and Digits/Numbers', 16, 1);
			RETURN -6;
		END
	END

	IF (@pObjectType IS NULL OR @pObjectType = '')
	BEGIN
		RAISERROR ('Object Type must be provided', 16, 1);
		RETURN -7;
	END

	IF (@pObjectInstanceID IS NULL OR @pObjectInstanceID <= 0)
	BEGIN
		RAISERROR ('Object Instance ID must be provided', 16, 1);
		RETURN -8;
	END

	--- We are done with checks; the task begins now.
	-----------------------------------------------------------------------------------

	INSERT	INTO	FolderFile
			(	ObjectType, ObjectInstanceID, FileName, FileType, FileSize, FileRemarks, CreatedDateTime, AccessCount	)
		VALUES
			(	@pObjectType, @pObjectInstanceID, @pFileName, @pFileType, @pFileSize, @pFileRemarks, GetDate(), 0	)
	SET @pFileID =  SCOPE_IDENTITY ();

	EXEC @retval = _GetFolder @pFileID, @FolderID OUTPUT, @pFileRelativePath OUTPUT
	UPDATE	FolderFile
		SET FolderID	=	@FolderID
	WHERE	FileID	=	@pFileID;

	SET @pFileRelativePath = @pFileRelativePath + dbo._GetFileNameForStorage (@pFileID);
END
GO

-- =============================================================================
--	Procedure	RemoveFile
-- =============================================================================
IF EXISTS	(	SELECT  TOP 1 1
				FROM    information_schema.routines
				WHERE   routine_type	=	'Procedure'
				AND     specific_name	=	'RemoveFile'
			)
	BEGIN
		DROP PROCEDURE  RemoveFile
	END
GO

CREATE PROCEDURE RemoveFile
(
	@pFileID		BIGINT,
	@pTxnTimestamp	ROWVERSION
)

--WITH ENCRYPTION
AS
BEGIN
	DELETE
	FROM	FolderFile
	WHERE	FileID			=	@pFileID
	AND		TxnTimestamp	=	@pTxnTimestamp;
	IF (@@ROWCOUNT = 0)
	BEGIN
		RAISERROR ('File could not be removed or File information has changed', 16, 1);
		RETURN -1;
	END
END
GO


-- =============================================================================
--	Procedure	DeleteFile
-- =============================================================================
IF EXISTS	(	SELECT  TOP 1 1
				FROM    information_schema.routines
				WHERE   routine_type	=	'Procedure'
				AND     specific_name	=	'DeleteFile'
			)
	BEGIN
		DROP PROCEDURE  DeleteFile
	END
GO

CREATE PROCEDURE DeleteFile
(
	@pFileID		BIGINT,
	@pTxnTimestamp	ROWVERSION
)

--WITH ENCRYPTION
AS
BEGIN
	UPDATE	FolderFile
		SET	DeletedDateTime	=	GetDate()
	WHERE	FileID			=	@pFileID
	AND		DeletedDateTime	IS	NULL
	AND		TxnTimestamp	=	@pTxnTimestamp;
	IF (@@ROWCOUNT = 0)
	BEGIN
		RAISERROR ('File could not be located or is already deleted or File information has changed', 16, 1);
		RETURN -1;
	END
END
GO


-- =============================================================================
--	Procedure	UnDeleteFile
-- =============================================================================
IF EXISTS	(	SELECT  TOP 1 1
				FROM    information_schema.routines
				WHERE   routine_type	=	'Procedure'
				AND     specific_name	=	'UnDeleteFile'
			)
	BEGIN
		DROP PROCEDURE  UnDeleteFile
	END
GO

CREATE PROCEDURE UnDeleteFile
(
	@pFileID		BIGINT,
	@pTxnTimestamp	ROWVERSION
)

--WITH ENCRYPTION
AS
BEGIN
	UPDATE	FolderFile
		SET	DeletedDateTime	=	NULL
	WHERE	FileID			=	@pFileID
	AND		DeletedDateTime	IS	NOT NULL
	AND		TxnTimestamp	=	@pTxnTimestamp;
	IF (@@ROWCOUNT = 0)
	BEGIN
		RAISERROR ('File could not be located or is already un-deleted or File information has changed', 16, 1);
		RETURN -1;
	END
END
GO


-- =============================================================================
--	Procedure	UpdateFileInfo		FileID, Remarks
-- =============================================================================
IF EXISTS	(	SELECT  TOP 1 1
				FROM    information_schema.routines
				WHERE   routine_type	=	'Procedure'
				AND     specific_name	=	'UpdateFileInfo'
			)
	BEGIN
		DROP PROCEDURE  UpdateFileInfo
	END
GO

CREATE PROCEDURE UpdateFileInfo
(
	@pFileID			BIGINT,
	@pFileRemarks		NVARCHAR (200),
	@pTxnTimestamp		ROWVERSION		OUTPUT
)

--WITH ENCRYPTION
AS
BEGIN
	UPDATE	FolderFile	
		SET	FileRemarks		=	@pFileRemarks
	WHERE	FileID			=	@pFileID
	AND		TxnTimestamp	=	@pTxnTimestamp;

	IF (@@ROWCOUNT = 0)
	BEGIN
		RAISERROR ('File could not be located or File information has changed', 16, 1);
		RETURN -1;
	END

	SELECT	@pTxnTimestamp	=	TxnTimestamp
	FROM	FolderFile
	WHERE	FileID	=	@pFileID;
END
GO

-- =============================================================================
--	Procedure	GetFileInfo
-- =============================================================================
IF EXISTS	(	SELECT  TOP 1 1 FROM    information_schema.routines WHERE   routine_type =	'Procedure' AND specific_name	=	'GetFileInfo'	)
	DROP PROCEDURE  GetFileInfo
GO

CREATE PROCEDURE GetFileInfo
(   @pFileID				BIGINT,
	@pFileRelativePath		NVARCHAR (250)	OUT,
	@pFileName				NVARCHAR (100)	OUT,
	@pFileType				VARCHAR (10)	OUT,
	@pFileRemarks			NVARCHAR (200)	OUT,
	@pCreatedDateTime		DATETIME		OUT,
	@pLastAccessDateTime	DATETIME		OUT,
	@pAccessCount			INTEGER			OUT,
	@pTxnTimestamp			ROWVERSION		OUT
)
--WITH ENCRYPTION
AS
BEGIN
	SELECT	--@pFileRelativePath		=	COALESCE (FolderPath, '\') + dbo._GetFileNameForStorage (@pFileID),			---- '
			@pFileRelativePath      =   COALESCE (FolderPath, '\') + (CASE  WHEN FolderPath IS NULL THEN '' ELSE '\' END) + dbo._GetFileNameForStorage (@pFileID),
			@pFileName				=	FileName,
			@pFileType				=	FileType,
			@pFileRemarks			=	FileRemarks,
			@pCreatedDateTime		=	CreatedDateTime,
			@pLastAccessDateTime	=	LastAccessDateTime,
			@pAccessCount			=	AccessCount,
			@pTxnTimestamp			=	TxnTimestamp
	FROM	FolderFile	f
		LEFT	JOIN	Folder	d
			ON	(	f.FolderID	=	d.FolderID)
	WHERE	f.FileID			=	@pFileID
	AND		f.DeletedDateTime	IS	NULL;

	--IF (@@ROWCOUNT = 1)
	--	UPDATE	FolderFile
	--		SET	LastAccessDateTime	=	GetDate(),
	--			AccessCount			=	AccessCount + 1
	--	WHERE	FileID				=	@pFileID
	--	AND		DeletedDateTime		IS	NULL;
END
GO

-- =============================================================================
--	Procedure	GetFilesInfo
-- =============================================================================
IF EXISTS	(	SELECT  TOP 1 1
				FROM    information_schema.routines
				WHERE   routine_type	=	'Procedure'
				AND     specific_name	=	'GetFilesInfo'
			)
	BEGIN
		DROP PROCEDURE  GetFilesInfo
	END
GO

CREATE PROCEDURE GetFilesInfo
(
	@pFileTable		FileID_TableType	READONLY
)

--WITH ENCRYPTION
AS
BEGIN
	SELECT	t.FileID,
			--COALESCE (d.FolderPath, '\') + dbo._GetFileNameForStorage (f.FileID)		AS	FileRelativePath,		---- '
			COALESCE (d.FolderPath, '\') + (CASE  WHEN d.FolderPath IS NULL THEN '' ELSE '\' END) + dbo._GetFileNameForStorage (f.FileID) FileRelativePath,
			f.FileName,
			f.FileType,
			f.FileRemarks,
			f.CreatedDateTime,
			f.LastAccessDateTime,
			f.AccessCount,
			f.TxnTimestamp
	FROM	@pFileTable	t
		LEFT	JOIN	FolderFile	f
			ON	(	t.FileID			=	f.FileID
				AND	f.DeletedDateTime	IS	NULL
				)
		LEFT	JOIN	Folder	d
			ON	(	f.FolderID	=	d.FolderID)

	UPDATE	f
		SET	LastAccessDateTime	=	GetDate(),
			AccessCount			=	AccessCount + 1
	FROM	@pFileTable	t
		JOIN	FolderFile	f
			ON	(	t.FileId	=	f.FileID
				AND	f.DeletedDateTime	IS	NULL
				);
END
GO

-- =============================================================================
--	Procedure	GetDeletedFilesInfo
-- =============================================================================
IF EXISTS	(	SELECT  TOP 1 1
				FROM    information_schema.routines
				WHERE   routine_type	=	'Procedure'
				AND     specific_name	=	'GetDeletedFilesInfo'
			)
	BEGIN
		DROP PROCEDURE  GetDeletedFilesInfo
	END
GO

CREATE PROCEDURE GetDeletedFilesInfo
(
	@pFileName		NVARCHAR (100),
	@pFileType		VARCHAR (10),
	@pFileRemarks	NVARCHAR (200)
)

--WITH ENCRYPTION
AS
BEGIN
	SELECT	FileID,
			FileName,
			FileType,
			FileSize,
			FileRemarks,
			CreatedDateTime,
			DeletedDateTime,
			TxnTimestamp
	FROM	FolderFile
	WHERE	DeletedDateTime	IS	NOT	NULL
	AND		FileName	LIKE	N'%' + COALESCE (@pFileName, '') + N'%'
	AND		FileType	LIKE	'%' + COALESCE (@pFileType, '') + '%'
	AND	(	FileRemarks	LIKE	N'%' + COALESCE (@pFileRemarks, '') + N'%'
		OR	@pFileRemarks	IS	NULL
		);
END
GO

-- =============================================================================

-- vim:ts=4 sw=4 ht=4
