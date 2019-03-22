
IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetMenuAndScreenData') AND TYPE IN (N'P'))
	DROP PROCEDURE GetMenuAndScreenData
GO
--	GetMenuAndScreenData 1,NULL
CREATE	PROCEDURE	GetMenuAndScreenData
(
	@pUserRoleID	SMALLINT,
	@pModuleCode	CHAR(2) = NULL
)
----WITH ENCRYPTION
AS
BEGIN
	DECLARE
		@Iterate	BIT	=	0

	DECLARE	@tbl	TABLE
		(
			ObjectName		VARCHAR (50)	NOT	NULL,
			IsObjectMenu	BIT				NOT	NULL,		-- If set(1), ObjectName contains name of Menu, else (when not set (0)), it contains name of Screen
			Sequence		SMALLINT		NOT NULL,		-- Order in which the screens and menus are laid out
			MenuCode		VARCHAR (15)		NULL,

			ModuleCode		VARCHAR (2)			NULL,
			ParentMenuCode	VARCHAR (15)		NULL,
			IsTraversed		BIT				NOT NULL,
			ScreenID		SMALLINT			NULL,
			HasInsert		BIT					NULL,
			HasUpdate		BIT					NULL,
			HasDelete		BIT					NULL,
			HasSelect		BIT					NULL,
			HasImport		BIT					NULL,
			HasExport		BIT					NULL
		);

	INSERT	INTO	@tbl
		SELECT	s.ScreenName, 0, s.Sequence, NULL,s.ModuleCode, NULL, 1, s.ScreenID, 
				us.HasInsert, us.HasUpdate, us.HasDelete, us.HasSelect, us.HasImport, us.HasExport
		FROM	Screen	s
			JOIN	UserRoleScreen	us
				ON	(	s.ScreenID = us.ScreenID
					AND	us.UserRoleId	=	@pUserRoleID
					)
		WHERE	MenuCode	IS NULL
		AND		(	s.ModuleCode = @pModuleCode 
				OR @pModuleCode	IS NULL
				)
		AND	s.ScreenName NOT LIKE '% For SP%'
		AND	us.HasSelect = 1
		AND	 s.HasSelect = 1;

	INSERT	INTO	@tbl
			(	ObjectName, MenuCode, IsObjectMenu, Sequence, IsTraversed, ModuleCode	)
		SELECT	m.MenuName, m.MenuCode, 1, Sequence, 0,
				(SELECT TOP 1 ModuleCode from screen  where screen.MenuCode = m.MenuCode  ) as ModuleCode
		FROM	Menu	m
			JOIN	UserRoleMenu	um
				ON	(	m.MenuCode		=	um.MenuCode
					AND	um.UserRoleID	=	@pUserRoleID
					)
		WHERE	ParentMenuCode	IS	NULL
		and		um.MenuCode in (	select distinct  s.MenuCode 
									from	UserRoleScreen us
									join	Screen s
												on us.ScreenID = s.ScreenID
								AND	us.UserRoleID	= @pUserRoleID
								AND	 s.HasSelect	= 1 
								AND	 us.HasSelect	= 1 
							  )

	IF (@@ROWCOUNT > 0)
		SET @Iterate = 1

	WHILE (@Iterate = 1)
	BEGIN
		SET @Iterate = 0
		INSERT	INTO	@tbl
			SELECT	s.ScreenName, 0, s.Sequence, s.MenuCode,s.ModuleCode, NULL, 1, s.ScreenID,
					us.HasInsert, us.HasUpdate, us.HasDelete, us.HasSelect, us.HasImport, us.HasExport
			FROM	Screen	s
				JOIN	@tbl	t
					ON	(	t.MenuCode		=	s.MenuCode
						AND	t.IsObjectMenu	=	1
						AND	t.IsTraversed	=	0
						)
				JOIN	UserRoleScreen	us
					ON	(	s.ScreenID		=	us.ScreenID
						AND	us.UserRoleID	=	@pUserRoleID
						)
			AND	us.HasSelect = 1
			AND	 s.HasSelect = 1;

		INSERT	INTO	@tbl
				( ModuleCode,	ObjectName, IsObjectMenu, Sequence, MenuCode, ParentMenuCode, IsTraversed	)
			SELECT	t.ModuleCode, MenuName, 1, m.Sequence, m.MenuCode, m.ParentMenuCode, 0
			FROM	Menu	m
			JOIN	@tbl	t
					ON	(	t.MenuCode	=	m.ParentMenuCode
						AND	t.IsObjectMenu	=	1
						AND	t.IsTraversed	=	0
						)
			JOIN	UserRoleMenu	um
					ON	(	m.ParentMenuCode	=	um.MenuCode
						AND	um.userroleid		=	@pUserRoleID
						)
			where  m.MenuCode in (	select distinct  s.MenuCode 
									from	UserRoleScreen us
									join	Screen s
												on us.ScreenID = s.ScreenID
									AND	us.UserRoleID	= @pUserRoleID
									AND	 s.HasSelect	= 1 
									AND	 us.HasSelect	= 1 
							    )


		IF (@@ROWCOUNT > 0)
			SET @Iterate = 1
		UPDATE	t
			SET	IsTraversed	=	1
		FROM	@tbl	t
		JOIN	@tbl	p
			ON	(	(	t.MenuCode	=	p.ParentMenuCode
					OR	t.ParentMenuCode	IS	NULL
					)
				AND	t.IsObjectMenu	=	1
				AND	t.isTraversed	=	0
				)
	END

	SELECT ModuleCode,	ObjectName, IsObjectMenu, Sequence, MenuCode, ScreenID,
			HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport
	FROM	@tbl
	ORDER BY ModuleCode, MenuCode,Sequence

	SELECT	u.ScreenID, u.ActionCode, a.ActionName, a.Sequence, a.IsAudited, a.IsRendered
	FROM	UserRoleScreenAction	u
		JOIN	ScreenAction	a
			ON	(	u.ScreenID		=	a.ScreenID
				AND	u.ActionCode	=	a.ActionCode
				)
	WHERE	u.UserRoleID	=	@pUserRoleID
END
GO


