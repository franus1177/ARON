
IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'AddUserRole') AND TYPE IN (N'P'))
DROP PROCEDURE AddUserRole
GO

CREATE PROCEDURE AddUserRole
(
	@p_UserRoleName VARCHAR(50),
	@p_UserID INT,
	@p_ScreenID SMALLINT,
	@p_AccessPoint VARCHAR(25),
	@p_UserRoleID SMALLINT OUTPUT
)
----WITH ENCRYPTION
AS
BEGIN

	INSERT INTO UserRole
			(	UserRoleName	)
		VALUES
			(	@p_UserRoleName	);

	SET @p_UserRoleID = SCOPE_IDENTITY();

	DECLARE @AuditLogID		BIGINT,
			@IsDetailAudit	BIT,
			@ObjectID		VARCHAR(50)			-- PK/UK column(s separated by |)

	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_UserRoleID)
	EXEC InsertAuditLog @p_UserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'I', @p_AccessPoint , @AuditLogID OUT, @IsDetailAudit OUT;

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'UpdateUserRole') AND TYPE IN (N'P'))
DROP PROCEDURE UpdateUserRole
GO

CREATE PROCEDURE UpdateUserRole
(
	@p_UserRoleID	SMALLINT,
	@p_UserRoleName	VARCHAR(50),
	@p_UserID INT,
	@p_ScreenID SMALLINT,
	@p_AccessPoint VARCHAR(25)
)
----WITH ENCRYPTION
AS
BEGIN

	DECLARE @AuditLogID		BIGINT,
			@IsDetailAudit	BIT,
			@ObjectID		VARCHAR(50),			-- PK/UK column(s separated by |)
			@PreImage		XML

	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_UserRoleID)
	EXEC InsertAuditLog @p_UserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'U', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

	IF(@IsDetailAudit = 1)
	BEGIN
		SET @PreImage = (	SELECT	UserRoleName
							FROM	UserRole
							WHERE	UserRoleID	= @p_UserRoleID
							FOR XML AUTO
						);

		INSERT INTO  AuditPreImage
					(    AuditLogID,TableName, PreImage    )
				VALUES
					(    @AuditLogID,'UserRole', @PreImage     )

	END

	UPDATE	UserRole
		 SET	UserRoleName	= @p_UserRoleName
	WHERE	UserRoleID	= @p_UserRoleID

	IF(@@ROWCOUNT = 0)
		 RAISERROR('No Record found for User Role',16,1)
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'DeleteUserRole') AND TYPE IN (N'P'))
DROP PROCEDURE DeleteUserRole
GO

CREATE PROCEDURE DeleteUserRole
(
	@p_UserRoleID SMALLINT,
	@p_UserID INT,
	@p_ScreenID SMALLINT,
	@p_AccessPoint VARCHAR(25)
)
----WITH ENCRYPTION
AS
BEGIN

	DECLARE @AuditLogID		BIGINT,
			@IsDetailAudit	BIT,
			@ObjectID		VARCHAR(50),			-- PK/UK column(s separated by |)
			@PreImage		XML

	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_UserRoleID)
	EXEC InsertAuditLog @p_UserID, @p_UserRoleID, @p_ScreenID, @ObjectID, 'D', @p_AccessPoint, @AuditLogID OUT, @IsDetailAudit OUT;

	IF(@IsDetailAudit = 1)
	BEGIN
		SET @PreImage = (	SELECT	UserRoleName
							FROM	UserRole
							WHERE	UserRoleID	= @p_UserRoleID
							FOR XML AUTO
						);

		INSERT INTO  AuditPreImage
					(    AuditLogID,TableName, PreImage    )
				VALUES
					(    @AuditLogID,'UserRole', @PreImage     )
	END

	DELETE
	FROM	UserRole
	WHERE	UserRoleID	= @p_UserRoleID

	IF(@@ROWCOUNT = 0)
		 RAISERROR('No Record found for User Role',16,1)
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetUserRole') AND TYPE IN (N'P'))
DROP PROCEDURE GetUserRole
GO

CREATE PROCEDURE GetUserRole
(
	@p_UserRoleID	SMALLINT,
	@p_UserRoleName VARCHAR(50)
)
----WITH ENCRYPTION
AS
BEGIN
	SELECT	UserRoleID,
			UserRoleName
	 FROM	UserRole
	WHERE	(	UserRoleID	=	@p_UserRoleID			
			OR	@p_UserRoleID	IS NULL
			)
	AND		UserRoleName LIKE  '%' + COALESCE(@p_UserRoleName, '') +  '%'

END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetScreenAccess') AND TYPE IN (N'P'))
DROP PROCEDURE GetScreenAccess
GO
-- GetScreenAccess NULL,1,NULL
CREATE PROCEDURE GetScreenAccess
(
	@p_MenuCode		VARCHAR(15),
	@p_UserRoleID	SMALLINT,
	@p_ModuleCode	VARCHAR(2) = NULL
)
----WITH ENCRYPTION
AS
BEGIN

	--===UserRoleMenu===============================================================================================================================
	CREATE TABLE #UserRoleScreen_TableType  (	UserRoleID INT NULL, ScreenID  INT NULL, 
												HasInsert  BIT NULL, HasUpdate BIT NULL,
												HasDelete  BIT NULL, HasSelect BIT NULL,
												HasImport  BIT NULL, HasExport BIT NULL
											);

	INSERT INTO #UserRoleScreen_TableType(UserRoleID,ScreenID,HasInsert,HasUpdate,HasDelete,HasSelect,HasImport,HasExport)
	SELECT	UserRoleScreen.UserRoleID,ScreenID,HasInsert,HasUpdate,HasDelete,HasSelect,HasImport,HasExport
	FROM	UserRoleMenu 
	RIGHT JOIN	UserRoleScreen ON UserRoleScreen.UserRoleID = UserRoleMenu.UserRoleID
	WHERE	UserRoleScreen.UserRoleID = @p_UserRoleID

	--===END UserRoleMenu===========================================================================================================================

	SELECT		Screen.ScreenID,		 
				Screen.ScreenName,		 
				Screen.MenuCode,		  
				Screen.Sequence,		  
				Screen.HasInsert,		  
				Screen.HasUpdate,		 
				Screen.HasDelete,
				Screen.HasSelect,
				Screen.UpdateAudit,
				Screen.DeleteAudit,
				Screen.HasImport,
				Screen.HasExport,

				(SELECT TOP 1 URT.HasInsert FROM  #UserRoleScreen_TableType URT WHERE URT.ScreenID = Screen.ScreenID) as HasInsertUserRole,
				(SELECT TOP 1 URT.HasUpdate FROM  #UserRoleScreen_TableType URT WHERE URT.ScreenID = Screen.ScreenID) as HasUpdateUserRole,
				(SELECT TOP 1 URT.HasDelete FROM  #UserRoleScreen_TableType URT WHERE URT.ScreenID = Screen.ScreenID) as HasDeleteUserRole,
				(SELECT TOP 1 URT.HasSelect FROM  #UserRoleScreen_TableType URT WHERE URT.ScreenID = Screen.ScreenID) as HasSelectUserRole,
				(SELECT TOP 1 URT.HasImport FROM  #UserRoleScreen_TableType URT WHERE URT.ScreenID = Screen.ScreenID) as HasImportUserRole,
				(SELECT TOP 1 URT.HasExport FROM  #UserRoleScreen_TableType URT WHERE URT.ScreenID = Screen.ScreenID) as HasExportUserRole,
				(SELECT dbo.GetAdditionalScreenAction(Screen.ScreenID,@p_UserRoleID)) AS AdditionalAccess --[{ScreenID:"2",ActionCode:"Create",ActionName:"A",Sequence:"1",IsAudited:"1",IsRendered:"1"},{ScreenID:"2",ActionCode:"Create",ActionName:"A",Sequence:"1",IsAudited:"1",IsRendered:"1"}]

	FROM		Screen
	WHERE	(	Screen.MenuCode		=	@p_MenuCode
			OR	(	Screen.MenuCode IS NULL AND @p_MenuCode IS NULL	)
			)
	AND	Screen.ScreenName NOT LIKE '% For SP%'
	AND	(	Screen.ModuleCode =	@p_ModuleCode
		OR	@p_ModuleCode	IS NULL
		)

	ORDER BY Screen.Sequence
 
	drop table #UserRoleScreen_TableType
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'AddUserRoleScreen') AND TYPE IN (N'P'))
	DROP PROCEDURE AddUserRoleScreen
GO

CREATE PROCEDURE AddUserRoleScreen
(
	@p_ModuleCode						CHAR(2)	= NULL,
	@p_MenuCode							VARCHAR(50),
	@p_UserRoleID						INT,	-- for 
	@p_UserRoleScreen_TableType			UserRoleScreen_TableType		 READONLY,
	@p_UserRoleScreenAction_TableType	UserRoleScreenAction_TableType	 READONLY,
	
	@p_UserID				INT,
	@p_CurrentUserRoleID	INT,
	@p_AccessPoint			VARCHAR(25),
	@p_ScreenID				SMALLINT
)
----WITH ENCRYPTION
AS
BEGIN
	-- Delete child table first
	DELETE sa
	FROM UserRoleScreenAction sa
	JOIN Screen s
			ON 	(	s.ScreenID		= sa.ScreenID	)
	WHERE	sa.UserRoleID	= @p_UserRoleID
	AND	(	s.MenuCode		= @p_MenuCode 
		OR (	s.MenuCode IS NULL 
			AND @p_MenuCode IS NULL
		   )
		)
	AND (	s.ModuleCode	= @p_ModuleCode
		OR	@p_ModuleCode	IS NULL
		)
	
	-- Delete child table first
	DELETE	urs
	FROM	UserRoleScreen urs
	JOIN	Screen s
				ON s.ScreenID		=	urs.ScreenID
	WHERE	urs.UserRoleID		=	@p_UserRoleID
	AND	(	s.MenuCode			=	@p_MenuCode 
		OR (s.MenuCode IS NULL AND @p_MenuCode IS NULL)
		)
	AND (	s.ModuleCode	= @p_ModuleCode
		OR	@p_ModuleCode	IS NULL
		)
	
	-- Insert New Updated Access
	INSERT INTO UserRoleScreen (UserRoleID ,ScreenID ,HasInsert ,HasUpdate ,HasDelete ,HasSelect ,HasImport ,HasExport)
		SELECT DISTINCT 	US.UserRoleID, US.ScreenID, 
				(CASE WHEN S.HasInsert = 1 THEN US.HasInsert ELSE 0 END) AS HasInsert, 
				(CASE WHEN S.HasUpdate = 1 THEN US.HasUpdate ELSE 0 END) AS HasUpdate, 
				(CASE WHEN S.HasDelete = 1 THEN US.HasDelete ELSE 0 END) AS HasDelete, 
				(CASE WHEN S.HasSelect = 1 THEN US.HasSelect ELSE 0 END) AS HasSelect, 
				(CASE WHEN S.HasImport = 1 THEN US.HasImport ELSE 0 END) AS HasImport, 
				(CASE WHEN S.HasExport = 1 THEN US.HasExport ELSE 0 END) AS HasExport
		FROM	@p_UserRoleScreen_TableType AS US
			JOIN	Screen S
				ON 	(	US.ScreenID = S.ScreenID	)
		WHERE	(	(	US.HasInsert	=	1	)
				OR	(	US.HasUpdate	=	1	)
				OR	(	US.HasDelete	=	1	)
				OR	(	US.HasSelect	=	1	)
				OR  (	US.HasImport	=	1	)
				OR  (	US.HasExport	=	1	)
				)
		AND (	S.ModuleCode	= @p_ModuleCode
			OR	@p_ModuleCode	IS NULL
			)

	INSERT INTO UserRoleScreenAction (UserRoleID, ScreenID, ActionCode)
		SELECT DISTINCT	USA.UserRoleID, USA.ScreenID, USA.ActionCode 
		FROM	@p_UserRoleScreenAction_TableType USA
			JOIN	ScreenAction SA
				ON	(	SA.ScreenID = USA.ScreenID
					AND	SA.ActionCode = USA.ActionCode
					)

	--===UserRoleMenu============================================================================================================
		
	DELETE
	FROM	UserRoleMenu 
	WHERE	UserRoleID	= @p_UserRoleID 
	AND		MenuCode	= @p_MenuCode
	 
	IF (@p_MenuCode IS NOT NULL)
		INSERT INTO UserRoleMenu
			(	UserRoleID, MenuCode	)
			SELECT	DISTINCT	u.UserRoleID, s.MenuCode
			FROM	Screen	s
				JOIN UserRoleScreen	u
					ON	(	s.ScreenID = u.ScreenID		)
			WHERE	u.UserRoleID	=	@p_UserRoleID 
			AND		MenuCode		= @p_MenuCode
			AND		s.MenuCode	IS NOT NULL
			AND (	s.ModuleCode	= @p_ModuleCode
				OR	@p_ModuleCode	IS NULL
				);

	--===END UserRoleMenu=========================================================================================================

	DECLARE @AuditLogID		BIGINT,
			@IsDetailAudit	BIT,
			@ObjectID		VARCHAR(50)			-- PK/UK column(s separated by |)
		
	SET  @ObjectID = CONVERT(VARCHAR(MAX),@p_UserRoleID)
	EXEC InsertAuditLog @p_UserID, @p_CurrentUserRoleID, @p_ScreenID, @ObjectID, 'I', @p_AccessPoint , @AuditLogID OUT, @IsDetailAudit OUT;

END