	DECLARE @Modules	varchar(50) = 'BS';  -- DEFAULT 'BS','SF','IN','DR','FR','WR','TR'
	DECLARE @IsNewDB	BIT = 1;  -- DEFAULT SET 1 for new DB

	--DELETE	UserRoleScreenAction;
	--DELETE	UserRoleScreen;
	--DELETE	UserRoleMenu;
	----DELETE	UserRole;
	--DELETE	ScreenTable;
	--DELETE	ScreenAction;
	--DELETE	Screen;
	--DELETE	Menu;

	--IF(@IsNewDB	= 1)
	--BEGIN
 
	--	DELETE	PublishedURL;
	--	DELETE	URLUsageType;
	--	DELETE	UserRole;
	--	--DBCC CHECKIDENT ('UserRole', RESEED, 0);
	--	INSERT INTO URLUsageType(URLUsageType) VALUES('Activation');
	--	INSERT INTO URLUsageType(URLUsageType) VALUES('Forgot Password');
	--END


Declare @userRoleID INT, @screenID SMALLINT;
-- Base Module start
--==========================================================================================================
INSERT INTO Screen (ScreenID, ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES (1,'Dashboard','BS', 1,NULL,0,0,1,0)

/*==========================================================================================================*/
--Sequence 2 to 5 reserve for other dashboard

--INSERT INTO Screen (ScreenID, ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES ('Dashboard 1',1,NULL,0,0,1,0)
--INSERT INTO Screen (ScreenID, ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES ('Dashboard 2',2,NULL,0,0,1,0)

--INSERT INTO Screen (ScreenID, ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES ('Dashboard 4',4,NULL,0,0,1,0)
--INSERT INTO Screen (ScreenID, ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES ('Dashboard 5',5,NULL,0,0,1,0)
/*=============================================================================================================*/

INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,UpdateAudit,DeleteAudit)
			VALUES (2,'Location','BS', 2,NULL,1,1,1,1,1,1)
	
	INSERT INTO ScreenTable  (ScreenID, TableName, IsSingleTuple) VALUES (2, 'Location',1);
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (2, 'AddCustomer', 'Add Customer',1,0,1);

INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport,UpdateAudit,DeleteAudit)
			VALUES (3,'Customer','BS', 3,NULL,1,1,1,1,1,1,1);
	
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple)				  VALUES (3, 'Customer',			1  );
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (3, 'CustomerLanguage',	0,1);
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (3, 'CustomerServiceLine',	0,1);
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (3, 'CustomerLocation',	0,1);
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (3, 'CustomerModule',		0,1);
	
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (3, 'CustDashbaord',	'Cust. Dashbaord',		1,0,1);
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (3, 'YearlySnapshot',	'Yearly Snapshot',		2,0,1);
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (3, 'MonthlySnapshot',	'Monthly Snapshot',		3,0,1);
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (3, 'Deviation',		'Deviation',			4,0,1);
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (3, 'LocationWiseCnt',	'Location Wise Count',	5,0,1);
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (3, 'ObjectData',		'Object Data',			6,1,1);
	INSERT INTO screenaction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (3, 'CustomerLocSort',	'Location Sorting',		7,0,1);
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (3, 'CustomerLoc',		'Location',				8,1,1);
 
	--for sp generate
	INSERT INTO Screen (ScreenID, ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,UpdateAudit,DeleteAudit) 
				VALUES (9,'Customer Address For SP','BS',4,NULL,1,1,1,1,1,1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (9, 'CustomerAddress',1)

	--for sp generate
	INSERT INTO Screen (ScreenID, ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,UpdateAudit,DeleteAudit) 
				VALUES (10,'Customer Contact For SP','BS',5,NULL,1,1,1,1,1,1)
		
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (10, 'CustomerContact',1)

	INSERT INTO Screen (ScreenID, ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) 
				VALUES (13,'WeeklyOff For SP','BS',6,NULL,1,1,1,1,1)
		
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple)				  VALUES (13, 'CustomerWeeklyOff',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (13, 'CustomerWeeklyOffName',0,1)

		--for sp generate
	INSERT INTO Screen (ScreenID, ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit)
				VALUES (12,'Holiday For SP','BS',7,NULL,1,1,1,1,1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple)			      VALUES (12, 'CustomerLocationHoliday',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (12, 'CustomerLocationHolidayName',0,1)
	
	--As additional screen under Customer

	INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport,UpdateAudit,DeleteAudit)
				VALUES (134,'Customer Dashboard','BS', 8,NULL,0,0,1,0,0,0,0);

	INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport,UpdateAudit,DeleteAudit)
				VALUES (97,'Customer Location','BS', 9,NULL,1,1,1,1,0,1,1);
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple)					VALUES (97, 'Location',1);
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched)	VALUES (97, 'LocationRiskLevel',0,1);
	

INSERT INTO Menu (MenuCode, MenuName, Sequence) VALUES('DocSettings','Document Settings',10);
	INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, HasExport, UpdateAudit, DeleteAudit) 
				VALUES(70,'Document','BS',1,'DocSettings',1,1,1,1,1,1,1);
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple)				  VALUES (70, 'Document',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (70, 'DocumentLanguage',0,1)
	
	INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, HasExport, UpdateAudit,DeleteAudit) 
			VALUES (69,'Document Category','BS',2,'DocSettings', 1,1,1,1,0,1,1);
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple)				  VALUES (69, 'DocumentCategory',1);
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (69, 'DocumentCategoryLanguage',0,1);
	
INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasImport,HasExport,UpdateAudit,DeleteAudit) 
			VALUES (210,'ImportData','BS', 11,NULL,1,0,1,0,1,0,0,0);

INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport)
			VALUES (73,'Audit Log','BS',12,NULL,0,0,1,0,1);


INSERT INTO Menu (MenuCode, MenuName, Sequence) VALUES('UserSetting','User Settings',13);

	INSERT INTO Screen (ScreenID, ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport,UpdateAudit,DeleteAudit) 
				VALUES (7, 'User','BS',1,'UserSetting',1,1,1,1,1,1,1);
		
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple)								 VALUES (7, 'EndUser',1);
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched)				 VALUES (7, 'UserRoleUser',0,1);
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched)				 VALUES (7, 'EndUserModule',0,1);
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched)				 VALUES (7, 'UserLocation',0,1);
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched)				 VALUES (7, 'ControllerSpecialization',0,1);
		INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (7, 'UserLocation', 'User Location',1,1,1);

		INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport,UpdateAudit,DeleteAudit)
					VALUES (101,'User Location','BS',2,'UserSetting',1,0,1,0,0,0,0);
			INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (101, 'UserLocation',0,1);

	INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport,UpdateAudit,DeleteAudit) 
				VALUES (6,'User Role','BS',3,'UserSetting',1,1,1,1,1,1,1);
		
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (6, 'UserRole',1)
		INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (6, 'Permission',      'Permission',1,1,1)
		INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (6, 'DocumentMapping', 'Document', 2,1,1)

		INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasSelect, HasImport,UpdateAudit,DeleteAudit) 
					VALUES (98,'Access permission','BS', 4,NULL,1,1,1,0,0);
			INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (98, 'UserRoleMenu',0,1);
			INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (98, 'UserRoleScreen',0,1);
			INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (98, 'UserRoleScreenAction',0,1);
			


		INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport,UpdateAudit,DeleteAudit)
					VALUES (99,'User Role Document','BS',5,'UserSetting',1,1,1,0,0,1,0);
			INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (99, 'DocumentMapping',0,1);


	INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport,UpdateAudit,DeleteAudit) 
				VALUES (8,'Controller','BS',6,'UserSetting',1,1,1,1,1,1,1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (8, 'ControllerSpecialization',1)



INSERT INTO Menu (MenuCode, MenuName, Sequence) VALUES('HRSettings','HR Settings',14);
	INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport,UpdateAudit,DeleteAudit) 
				VALUES (48,'Employee','BS',1,'HRSettings',1,1,1,1,1,1,1);
		
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (48, 'Employee',1)
			
	INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, HasExport, UpdateAudit, DeleteAudit) 
				VALUES (49,'Designation','BS',2,'HRSettings',1,1,1,1,1,1,1);
		
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple)				  VALUES (49, 'Designation',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (49, 'DesignationLanguage',0,1)

	INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, HasExport, UpdateAudit, DeleteAudit) 
				VALUES (50,'Department','BS',3,'HRSettings',1,1,1,1,1,1,1)
		
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple)					VALUES (50, 'Department',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched)	VALUES (50, 'DepartmentLanguage',0,1)

	INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, HasExport, UpdateAudit, DeleteAudit) 
				VALUES (51,'Working Shift','BS',4,'HRSettings',1,1,1,1,1,1,1)
		
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (51, 'WorkingShift',1)

	INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, HasExport, UpdateAudit, DeleteAudit) 
	VALUES (224,'Squad','BS',5,'HRSettings',1,1,1,1,1,1,1)
		
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (224, 'Squad',1)


INSERT INTO Menu (MenuCode, MenuName, Sequence) VALUES('BasicSettings','Basic Settings',15);

	INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, HasExport, UpdateAudit, DeleteAudit)
				 VALUES (4,'UOM','BS',1,'BasicSettings',1,1,1,1,1,1,1)
		
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple)					VALUES (4, 'UOM',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched)	VALUES (4, 'UOMLanguage',0,1)

	INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,UpdateAudit, DeleteAudit)
				VALUES (5,'Holiday Calendar','BS',2,'BasicSettings',1,1,1,1,1,1)
		
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple)					VALUES (5, 'CountryHoliday',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched)	VALUES (5, 'CountryHolidayName',0,1)

	INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, HasExport, UpdateAudit, DeleteAudit) 
				VALUES (211,'ChecklistTaskGroup','BS',3,'BasicSettings',1,1,1,1,1,1,1);
		
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple)							VALUES (211, 'CheckListTaskGroup',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched)			VALUES (211, 'CheckListTaskGroupLanguage',0,1)
		INSERT INTO ScreenAction(ScreenID,ActionCode,ActionName,Sequence,IsAudited,IsRendered)	VALUES (211, 'ChklstTGrpSort','Sorting',1,0,1)
	
 
 ---------------------------------------------------------------------------------------------


 INSERT INTO Screen (ScreenID, ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport, UpdateAudit, DeleteAudit) VALUES(500,'Part','BasicSettings',	'BS',3,1,1,1,1,0,1,1,1)
 		
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple)VALUES (500, 'Part',1)
 
 INSERT INTO Screen (ScreenID, ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport, UpdateAudit, DeleteAudit) VALUES(501,'Fixture','BasicSettings',	'BS',2,1,1,1,1,0,1,1,1)
		
			INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple)VALUES (501, 'Fixture',1)
			INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple,IsDetailFetched)VALUES (501, 'FixturePart',0,1)


 INSERT INTO Screen (ScreenID, ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport, UpdateAudit, DeleteAudit) 
				VALUES(503,'Fixture Purchase Order','BasicSettings','BS',4,1,1,1,1,0,1,1,1)
			INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple)VALUES (503, 'PurchaseOrder',1)
			INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (503, 'POItem',0,1)
			INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (503, 'POPart',0,1)

			INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (503, 'POFixture',0,1)

----------------------------------------------------------------------------------------------------------------------------------------
	IF(@IsNewDB	= 1)
	BEGIN
		if EXISTS(select TOP 1 1 from UserRole where UserRoleName = 'System Administrator')
		BEGIN
			SET @userRoleID = (select TOP 1 UserRoleid from UserRole where UserRoleName = 'System Administrator')
		END
		ELSE
		BEGIN
			INSERT INTO UserRole (UserRoleName) VALUES('System Administrator'); SELECT * FROM USERROLE
			SET @userRoleID = SCOPE_IDENTITY();
		END
	END
	ELSE
	BEGIN
		SET @userRoleID = 1;
	END

	INSERT INTO UserRoleMenu
		SELECT	3, MenuCode
		FROM	Menu
		WHERE	MenuCode	IN  (	SELECT DISTINCT	MenuCode
									FROM	Screen
									WHERE	MenuCode IS NOT NULL
									AND		ModuleCode = 'BS'
								)
	GO

	INSERT INTO UserRoleScreen
		SELECT	3, ScreenId, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport
		FROM	Screen
		WHERE	ModuleCode = 'BS'
		and screenid not in (select screenid from userrolescreen)
	GO

	INSERT INTO UserRoleScreenAction
		SELECT	3, A.ScreenId, ActionCode
		FROM	ScreenAction A
		JOIN	Screen B
					ON	A.ScreenId	= B.ScreenId
		WHERE	ModuleCode = 'BS'
		and B.screenid not in (select screenid from userrolescreen)
	GO
		
--==For default Controller============================================================================================--

--INSERT INTO UserRole (UserRoleName) VALUES('Controller')
--SET @userRoleID = SCOPE_IDENTITY();
--INSERT INTO UserRoleMenu
--	SELECT	@userRoleID, MenuCode
--	FROM	Menu

--INSERT INTO UserRoleScreen
--	SELECT	@userRoleID, ScreenId, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport
--	FROM	Screen where screenid = 1 -- default dashbaord access
	
--INSERT INTO UserRoleScreenAction
--	SELECT	@userRoleID, ScreenId, ActionCode
--	FROM	ScreenAction where screenid = 1

--==For default Customer user============================================================================================--

--==For default Customer User============================================================================================--

--INSERT INTO UserRole (UserRoleName) VALUES('Customer')/*will use to Customer login*/
--SET @userRoleID = SCOPE_IDENTITY();
--INSERT INTO UserRoleMenu
--	SELECT	@userRoleID, MenuCode
--	FROM	Menu

--INSERT INTO UserRoleScreen
--	SELECT	@userRoleID, ScreenId, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport
--	FROM	Screen where screenid = 1 -- default dashbaord access
	
--INSERT INTO UserRoleScreenAction
--	SELECT	@userRoleID, ScreenId, ActionCode
--	FROM	ScreenAction where screenid = 1

--==For default Customer user============================================================================================--

--=======================================================================================================================--


	INSERT INTO EndUser
			(	LoginID,FirstName,MiddleName,LastName,LanguageCode,UTCOffset,DefaultModuleCode,Gender,EmailID,UserIdentity,ActivatedDTM,
			LastAccessPoint,LastLoginDTM,SecretQuestion,SecretAnswer,ActivationURLID,ResetPasswordURLID, DesignationID, DepartmentID )
		VALUES
			(	'InventoryAdmin','I Admin',null,'admin','EN',57,'BS','M','InventoryAdmin@gmail.com',
			CONVERT(VARBINARY(16), HASHBYTES ('MD5', 'admin123')),null,
			'0.0.0',getdate(),null,null,null,null, null, null	);


			
	INSERT INTO EndUserModule
				(	EndUserID,ModuleCode	)
			SELECT	3,'BS'

		INSERT INTO UserRoleUser
				(	UserRoleID,EndUserID	)
			SELECT	3,3