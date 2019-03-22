DECLARE @IsNewDB	BIT = 0;  -- DEFAULT SET 1 for new DB

DELETE	UserRoleScreenAction;
DELETE	UserRoleScreen;
DELETE	UserRoleMenu;
DELETE	ScreenTable;
DELETE	ScreenAction;
DELETE	Screen;
DELETE	Menu;

IF(@IsNewDB	= 1)
BEGIN
	DELETE	URLUsageType;
	DELETE	UserRole;
	DBCC CHECKIDENT ('UserRole', RESEED, 0);
	INSERT INTO URLUsageType(URLUsageType) VALUES('Activation');
	INSERT INTO URLUsageType(URLUsageType) VALUES('Forgot Password');
END

DBCC CHECKIDENT ('Screen', RESEED, 0);

Declare @userRoleID INT, @screenID SMALLINT;
-- Base Module start
--==========================================================================================================
INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES ('Dashboard','BS', 1,NULL,0,0,1,0)

/*==========================================================================================================*/
--Sequence 2 to 5 reserve for other dashboard

--INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES ('Dashboard 1',1,NULL,0,0,1,0)
--INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES ('Dashboard 2',2,NULL,0,0,1,0)
--SET @screenID = SCOPE_IDENTITY();
--INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES ('Dashboard 4',4,NULL,0,0,1,0)
--INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES ('Dashboard 5',5,NULL,0,0,1,0)
/*=============================================================================================================*/

INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,UpdateAudit,DeleteAudit) VALUES ('Location','BS', 6,Null,1,1,1,1,1,1)
	SET @screenID = SCOPE_IDENTITY();
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'Location',1);

    INSERT INTO screenaction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'LocationSort','Sorting',1,0,1)

INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport,UpdateAudit,DeleteAudit) VALUES ('Customer','BS',7,Null,1,1,1,1,1,1,1)
	SET @screenID = SCOPE_IDENTITY();
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'Customer',1)
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'CustomerLanguage',0,1)
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'CustomerServiceLine',0,1)
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'CustomerLocation',0,1)
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'CustomerModule',0,1)

	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'CustDashbaord', 'Cust. Dashbaord',1,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'YearlySnapshot', 'Yearly Snapshot',2,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'MonthlySnapshot', 'Monthly Snapshot',3,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'Deviation', 'Deviation',4,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'LocationWiseCnt', 'Location Wise Count',5,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'ObjectData', 'Object Data',6,1,1)
	INSERT INTO screenaction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'CustomerLocSort','Sorting',7,0,1)

INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES ('Customer Dashboard','BS', 38,NULL,0,0,1,0)
	SET @screenID = SCOPE_IDENTITY();
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'CustomerDetails', 'Customer Details',2,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'TopDeviations', 'Top 5 Deviations',3,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'PlansAndAssets', 'Plans and Assets',4,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'ActiveAssetsPlanners', 'Active Assets and Planners',5,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'YearlySnapshot', 'Inspection Yearly Snapshot',6,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'MonthlySnapshot', 'Inspection Monthly Snapshot',7,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'Deviations', 'Deviations',8,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'YearlyDeviations', 'Yearly Deviations',9,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'ContractCount','Contract Count',10,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'ActivePlans','Active Plans',11,0,1)


INSERT INTO Menu (MenuCode, MenuName, Sequence) VALUES('BasicSettings','Basic Settings',8)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, HasExport, UpdateAudit, DeleteAudit) VALUES ('UOM','BS',9,'BasicSettings',1,1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'UOM',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'UOMLanguage',0,1)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,UpdateAudit, DeleteAudit) VALUES ('Holiday Calendar','BS',10,'BasicSettings',1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'CountryHoliday',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'CountryHolidayName',0,1)

		
		
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, HasExport, UpdateAudit, DeleteAudit) VALUES ('ChecklistTaskGroup','BS',37,'BasicSettings',1,1,1,1,1,1,1);
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (113, 'CheckListTaskGroup',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (113, 'CheckListTaskGroupLanguage',0,1)
		INSERT INTO ScreenAction(ScreenID,ActionCode,ActionName,Sequence,IsAudited,IsRendered)values (113,'ChklstTGrpSort','Sorting',1,0,1)


INSERT INTO Menu (MenuCode, MenuName, Sequence) VALUES('UserSetting','User Settings',11);

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport,UpdateAudit,DeleteAudit) VALUES ('User Role','BS',12,'UserSetting',1,1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'UserRole',1)
		INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'Permission', 'Permission',1,1,1)
		INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'DocumentMapping', 'Document Mapping',2,1,1)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport,UpdateAudit,DeleteAudit) VALUES ('User','BS',13,'UserSetting',1,1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'EndUser',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'UserRoleUser',0,1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'EndUserModule',0,1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'UserLocation',0,1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'ControllerSpecialization',0,1)
		INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'UserLocation', 'User Location',1,1,1)



	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport,UpdateAudit,DeleteAudit) VALUES ('Controller','BS',14,'UserSetting',1,1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'ControllerSpecialization',1)


	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport)   VALUES ('Audit Log','BS',88,null,0,0,1,0,1)
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport)   VALUES ('KPI','BS',89,null,0,0,1,0,1)


----------------------------------------Other Customer Table -------------------------------

--for sp generate
INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,UpdateAudit,DeleteAudit) VALUES ('Customer Address For SP','BS',15,Null,1,1,1,1,1,1)
	SET @screenID = SCOPE_IDENTITY();
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'CustomerAddress',1)

--for sp generate
INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,UpdateAudit,DeleteAudit) VALUES ('Customer Contact For SP','BS',16,Null,1,1,1,1,1,1)
	SET @screenID = SCOPE_IDENTITY();
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'CustomerContact',1)

--for sp generate
INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, UpdateAudit) VALUES ('Settings For SP','BS',17,Null,1,1,1,0, 1)
	SET @screenID = SCOPE_IDENTITY();
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'CustomerServiceLineConfiguration',1)

--for sp generate
INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Holiday For SP','BS',18,NULL,1,1,1,1,1)
	SET @screenID = SCOPE_IDENTITY();
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'CustomerLocationHoliday',1)
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'CustomerLocationHolidayName',0,1)

--for sp generate
INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('WeeklyOff For SP','BS',19,NULL,1,1,1,1,1)
	SET @screenID = SCOPE_IDENTITY();
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'CustomerWeeklyOff',1)
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'CustomerWeeklyOffName',0,1)


--Base Module (Incident('IN'),Training('TR'),Drill('DR')) Start- 31============================================================================================================

--==Base Module (Training('TR')) Start Sequence no- 31============================================================================================================

INSERT INTO Menu (MenuCode, MenuName, Sequence) VALUES('HRSettings','HR Settings',31)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport,UpdateAudit,DeleteAudit) 
	VALUES ('Employee','BS',32,'HRSettings',1,1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'Employee',1)
			
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, HasExport, UpdateAudit, DeleteAudit) 
	VALUES ('Designation','BS',33,'HRSettings',1,1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'Designation',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'DesignationLanguage',0,1)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, HasExport, UpdateAudit, DeleteAudit) 
	VALUES ('Department','BS',34,'HRSettings',1,1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'Department',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'DepartmentLanguage',0,1)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, HasExport, UpdateAudit, DeleteAudit) 
	VALUES ('Working Shift','BS',35,'HRSettings',1,1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'WorkingShift',1)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasImport,HasExport,UpdateAudit,DeleteAudit) VALUES ('ImportData','BS', 36,Null,1,Null,1,Null,1,Null,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'Squad',1)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, HasExport, UpdateAudit, DeleteAudit) 
	VALUES ('Squad','BS',37,'HRSettings',1,1,1,1,1,1,1)


--==Base Module (Training('TR')) End Sequence no 40===============================================================================================================

--Base Module (Incident('IN'),Training('TR'),Drill('DR')) End 40===============================================================================================================

INSERT INTO Menu (MenuCode, MenuName, Sequence) VALUES('DocSettings','Document Settings',21)
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport,UpdateAudit,DeleteAudit) 
			VALUES ('Document Category','BS',21,'DocSettings', 1,1,1,1,0,1,1)
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, HasExport, UpdateAudit, DeleteAudit) 
			Values('Document','BS',22,'DocSettings',1,1,1,1,1,1,1)

--== Base Module end================================================================================================================



--== Safety Module start Screen Id starts from = 51=================================================================================
INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES ('Safety Dashboard','SF', 51,NULL,0,0,1,0)
	SET @screenID = SCOPE_IDENTITY();
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'ActAssContDRisk', 'Act Ass. C. Dev. Risk',2,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'PlanAndAssets', 'Plan And Assets',3,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'MonthlySnapshot', 'Monthly Snapshot',4,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'YearlySnapshot', 'Yearly Snapshot',5,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'Deviation', 'Deviation',6,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'LocationWiseCnt', 'Location Wise Count',7,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'EmerInspection', 'Emer Inspection',8,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'TopDeviation', 'Top Deviation',9,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'InspTypeStatus', 'Insp. Type Status',10,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'InspWeeklySnap', 'Inspection Weekly Snapshot',11,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'InspMonthlySnap', 'Inspection Monthly Snapshot',12,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'LocRisklevel', 'Location Risk level',13,0,1)

--== Deviation Analytics =================================================================================

INSERT INTO Screen (ScreenID, ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES (16, 'Deviation Analytics','SF', 2,NULL,0,0,1,0)
	
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (16, 'DevByAssetType', 'Deviation By Asset Type',1,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (16, 'DevByMake', 'Deviation By Make',2,0,1)

--== Vehicle Dashboard =================================================================================

INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES ('Vehicle Dashboard','SF', 3,NULL,0,0,1,0)
	SET @screenID = SCOPE_IDENTITY();
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'ActAssContDRisk', 'Act Ass. C. Dev. Risk',2,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'PlanAndAssets', 'Plan And Assets',3,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'MonthlySnapshot', 'Monthly Snapshot',4,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'YearlySnapshot', 'Yearly Snapshot',5,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'Deviation', 'Deviation',6,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'LocationWiseCnt', 'Location Wise Count',7,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'EmerInspection', 'Emer Inspection',8,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'TopDeviation', 'Top Deviation',9,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'InspTypeStatus', 'Insp. Type Status',10,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'InspWeeklySnap', 'Inspection Weekly Snapshot',11,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'InspMonthlySnap', 'Inspection Monthly Snapshot',12,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'LocRisklevel', 'Location Risk level',13,0,1)

INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,UpdateAudit,DeleteAudit) VALUES ('Inspection','SF',52,Null,1,1,1,1,1,1)
	SET @screenID = SCOPE_IDENTITY();
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'ObjectInstanceInspection',1)
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'ObjectInstanceTask',0,1)
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'ObjectInstancePhotoElement',0,1)
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'Deviation',0,1)
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'ObjectDeviationPhoto',0,1)
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'ObjectDeviationPhotoElement',0,1)

--INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'ControllerTagging',1)
--INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'ControllerTaggingLocation',0,1)

INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Inspection Snapshot','SF',53,NULL,0,0,1,0,0)
	SET @screenID = SCOPE_IDENTITY();
INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Yearly Snapshot','SF',57,NULL,0,0,1,0,0)
	SET @screenID = SCOPE_IDENTITY();
INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport,UpdateAudit,DeleteAudit) VALUES ('Emergency Inspection','SF',54,NULL,1,1,1,1,1,1,1)
	SET @screenID = SCOPE_IDENTITY();


INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Resolution Deviation','SF',55,NULL,1,1,1,0,0)
	SET @screenID = SCOPE_IDENTITY();
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'Deviation',1)
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'DeviationDeviationTypeResolution',1)
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'DeviationRepairComponent',1)
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'DeviationResolutionRemarksPhoto',0,1)
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'DeviationResolutionRemarksPhotoElement',0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID/*18*/,  'ResolutionMulti', 'Resolution Deviation Multiple',1,1,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID/*18*/, 'ReportDevLMail', 'Report Deviation Mail',2,1,1)

	 
INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,UpdateAudit, DeleteAudit) VALUES ('Location Deviation','SF',56,NULL,1,1,1,0,1,1)
	SET @screenID = SCOPE_IDENTITY();

	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'Deviation',1)
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'DeviationDeviationTypeResolution',1)
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'DeviationResolutionRemarksPhoto',1)
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'DeviationResolutionRemarksPhotoElement',1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID/*128*/, 'ReportDevMail', 'Report Deviation Mail',1,1,1)

INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport,UpdateAudit,DeleteAudit) VALUES ('Controller Tagging','BS',56,NULL,1,1,1,1,1,1,1)
	SET @screenID = SCOPE_IDENTITY();
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'ControllerTagging',0,1);
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'ControllerTaggingLocation',0,1);


INSERT INTO Menu (MenuCode, MenuName, Sequence) VALUES('Reports','Reports',57)	
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport) VALUES ('QR Report','SF',58,'Reports',0,0,1,0,1)
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport) VALUES ('Status Report','SF',59,'Reports',0,0,1,0,1)
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport) VALUES ('Deviation Report','SF',60,'Reports',0,0,1,0,1)
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport) VALUES ('Inventory Report','SF',61,'Reports',0,0,1,0,1)
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport) VALUES ('InspectionImage Report','SF',62,'Reports',0,0,1,0,1)
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport) VALUES ('Replacement Report','SF',63,'Reports',0,0,1,0,1)
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport) VALUES ('Location QR Report','SF',64,'Reports',0,0,1,0,1)
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport) VALUES ('Contract Report','SF',65,'Reports',0,0,1,0,1)
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport) VALUES ('Controller Report','SF',66,'Reports',0,0,1,0,1)
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport) VALUES ('Contract Status Report','SF',67,'Reports',0,0,1,0,1)
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport) VALUES ('Work Completion Report','SF',68,'Reports',0,0,1,0,1)
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport) VALUES ('Inspection Status Report','SF',69,'Reports',0,0,1,0,1)
	--INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport) VALUES ('Audit Log Report','SF',88,'Reports',0,0,1,0,1)
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport) VALUES ('Object Data Report','SF',71,'Reports',0,0,1,0,1)
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport) VALUES ('Repair Component Report','SF',72,'Reports',0,0,1,0,1)
	/*for only naffco*/
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport) VALUES ('Service Report','SF',73,'Reports',0,0,1,0,1)--for only naffco
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport) VALUES ('Contract Schedule Report','SF',74,'Reports',0,0,1,0,1)
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport) VALUES ('Contract Expiry Report','SF',75,'Reports',0,0,1,0,1)
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport) VALUES ('Inspection Status Snapshot Report','SF',96,'Reports',0,0,1,0,1)
	INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport) VALUES (16,'Deviation Analytics','SF',97,'Reports',0,0,1,0,1)

	select * from screen order by ScreenID
	
-- Reserve some Sequence for reports

INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport)   VALUES ('Deviation List','SF',90,null,0,0,1,0,1)

INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('General Scheduler','SF',70,NULL,1,1,1,1,1);

INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES (71,'General Schedule View','SF',95,NULL,1,1,1,1,1);

	SET @screenID = SCOPE_IDENTITY();

INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Contract','SF',71,NULL,1,1,1,1,1);
	SET @screenID = SCOPE_IDENTITY();
	--for sp generate
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'Contract',1);
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'ContractCategory',0,1);
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'ContractLocation',0,1);
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'Scheduler', 'Scheduler',1,1,1)

INSERT INTO Menu (MenuCode, MenuName, Sequence) VALUES('Object','Object Setting',72)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, UpdateAudit,DeleteAudit) VALUES ('Category','SF',73,'Object',1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'Category',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'CategoryLanguage',0,1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'CategoryAttribute',0,1)


	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, UpdateAudit,DeleteAudit) VALUES ('Object','SF',74,'Object',1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'Object',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'ObjectLanguage',0,1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'ObjectAttribute',0,1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'ObjectRepairComponent',0,1)


	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,UpdateAudit,DeleteAudit) VALUES ('ObjectInstance','SF',75,'Object',1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'ObjectInstance',1)
		INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'ObjInstanceSort', 'Sorting',1,0,1);


INSERT INTO Menu (MenuCode, MenuName, Sequence) VALUES('Checklist','CheckList Settings',76)	

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,UpdateAudit,DeleteAudit) VALUES ('CheckList','SF',77,'Checklist',1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'CheckList',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'AdditionalFrequencyCheckList',0,1)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,UpdateAudit,DeleteAudit) VALUES ('CheckList Task','SF',78,'Checklist',1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'CheckListTask',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'CheckListTaskLanguage',0,1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'CheckListTaskDeviationType',0,1)
		INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'ChkListTaskSort', 'Sorting',1,0,1);


INSERT INTO Menu (MenuCode, MenuName, Sequence) VALUES('Deviation','Deviation',79)	

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,UpdateAudit,DeleteAudit) VALUES ('Deviation Type','SF',80,'Deviation',1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'DeviationType',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'DeviationTypeLanguage',0,1)
		INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'DevTypeSort', 'Sorting',1,0,1);


	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,UpdateAudit,DeleteAudit) VALUES ('Deviation Type Resolution','SF',81,'Deviation',1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'DeviationTypeResolution',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'DeviationTypeResolutionLanguage',0,1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'DeviationTypeResolutionRepairComponent',0,1)

INSERT INTO Menu (MenuCode, MenuName, Sequence) VALUES('SFBasicSettings','Safety Basic Settings',82)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, HasExport,UpdateAudit,DeleteAudit) VALUES ('Repair Component', 'SF', 83,'SFBasicSettings',1,1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'RepairComponent',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'RepairComponentLanguage',0,1)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, UpdateAudit,DeleteAudit) VALUES ('Not In Use Reason','SF',84,'SFBasicSettings',1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'NotInUseReason',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'NotInUseReasonLanguage',0,1)


	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport, UpdateAudit,DeleteAudit) VALUES ('Make','SF',93,'SFBasicSettings',1,1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'ObjectInstanceMake',1)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport, UpdateAudit,DeleteAudit) VALUES ('CustomerLocation','SF',94,'SFBasicSettings',1,1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'CustomerLocation',1)

INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete ) VALUES ('Controller Dashboard','SF',91,NULL,0,0,1,0);
INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES ('Safety Scheduler','SF',92,NULL,0,0,1,0);


--------------- OTHER EXITRACK-------------------------

--for sp generate
INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,UpdateAudit, DeleteAudit) VALUES ('Deviation For SP','SF',86,NULL,1,1,1,1,1,1)
	SET @screenID = SCOPE_IDENTITY();
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'Deviation',1)
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'DeviationLocationPhotoInstance',0,1)
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'DeviationLocationPhoto',0,1)

--INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, UpdateAudit, DeleteAudit) VALUES ('Incident','SF',87,NULL,1,1,1,1,1,1)

--==START Training Module========================================================================================================

INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Dashboard Training','TR',101,NULL,0,0,1,0,0)

--== Training Module start Sequence No. = 101=================================================================================

	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (268, 'YearlySnapshot', 'Yearly Snapshot',1,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (268, 'MonthlySnapshot', 'Monthly Snapshot',2,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (268, 'TrainingAndEmp', 'Training And Employee',3,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (268, 'CertAndCourse', 'Certification And Courses',4,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (268, 'EmpTrAndAtt', 'Employees Training And Attendees',5,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (268, 'TrSchedule', 'ARFF Training Schedule',6,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (268, 'EmpScoreTr', 'Employee Training Score',7,0,1)

	-- Menu Basic Settings ----------------
INSERT INTO Menu (MenuCode, MenuName, Sequence) VALUES('TRBasicSettings','Training Basic Settings',109)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport,UpdateAudit,DeleteAudit)VALUES ('Feedback Parameter','TR',109,'TRBasicSettings',1,1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (197, 'FeedbackParameter',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple,IsDetailFetched) VALUES (197, 'FeedbackParamaterLanguage',0,1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple,IsDetailFetched) VALUES (197, 'FeedbackParameterValue',0,1)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport,UpdateAudit,DeleteAudit)VALUES ('Assessment Parameter','TR',105,'TRBasicSettings',1,1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (201, 'AssessmentParameter',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple,IsDetailFetched) VALUES (201, 'AssessmentParameterLanguage',0,1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple,IsDetailFetched) VALUES (201, 'CourseAssessmentParameter',0,1)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, HasExport, UpdateAudit, DeleteAudit)VALUES ('Course Type','TR',110,'TRBasicSettings',1,1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'CourseType',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'CourseTypeLanguage',0,1)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, HasExport, UpdateAudit, DeleteAudit)VALUES ('Certification','TR',111,'TRBasicSettings',1,1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		--INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (55, 'Certification',1)
		--INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (55, 'CertificationLanguage',0,1)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, HasExport, UpdateAudit, DeleteAudit)VALUES ('Course','TR',112,'TRBasicSettings',1,1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (56, 'Course',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (56, 'CourseLanguage',0,1)

	--- Other Scrren-----------------------
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport,UpdateAudit,DeleteAudit)VALUES ('Course Mapping','TR',108,NULL,1,1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport,UpdateAudit,DeleteAudit)VALUES ('Training','TR',107,NULL,1,1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'Training',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'TrainingTrainer',0,1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'Employee',0,1)
		--INSERT INTO ScreenAction values(@screenID,'EnrollmentAll','Enrollment For All',1,1,1)


	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'RepeatTraining', 'Repeat Training',1,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'TrainerName', 'Trainer Name',2,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'Enrolment', 'Enrolment',3,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'Attendance', 'Attendance',4,0,1)
	INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'TrainAssessment', 'Training Assessment',5,0,1)



	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,UpdateAudit,DeleteAudit) VALUES ('Training Enrolment For SP','TR',109,Null,1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'TrainingEnrolment',1)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,UpdateAudit,DeleteAudit)VALUES ('Training Feedback','TR', 113,NULL,1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (56, 'TrainingFeedback',1)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete,HasExport,UpdateAudit,DeleteAudit)VALUES ('Training Calendar','TR',106,NULL,1,1,1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();

INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete)VALUES ('Monthly Snapshot','TR', 114,NULL,0,0,1,0);
INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete)VALUES ('Training Material','TR', 115,NULL,0,0,1,0);

	-- Menu Training Reports ----------------
INSERT INTO Menu (MenuCode, MenuName, Sequence) VALUES('TRReports','Training Reports',108)

	INSERT Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport)VALUES ( N'Certificate Report', N'TRReports', N'TR', 109, 0, 0, 0, 1, 0, 1)
	INSERT Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport)VALUES ( N'Employee Training Report', N'TRReports', N'TR', 110, 0, 0, 0, 1, 0, 1)
	INSERT Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport)VALUES ( N'Yearly Training Report', N'TRReports', N'TR', 111, 0, 0, 0, 1, 0, 1)
	INSERT Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport)VALUES ( N'Employee Wise Training Report', N'TRReports', N'TR', 112, 0, 0, 0, 1, 0, 1)
	
--====== END Training Module ===================================================================================================================================================================================

--================================= Incident Module ======================================================================================
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Dashboard Incident'  ,'IN',151,NULL,0,0,1,0,0)
	INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES (240,'Dashboard Incident 2','IN',240,NULL,0,0,1,0,0);

	INSERT Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport, UpdateAudit, DeleteAudit) 
		VALUES ( N'Incident', NULL, N'IN', 152, 1, 1, 1, 1, 0, 0, 0, 1);

INSERT Menu (MenuCode, MenuName, Sequence, ParentMenuCode) VALUES (N'INBasicSettings', N'Incident Basic Settings', 153, NULL);

	INSERT Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport, UpdateAudit, DeleteAudit) 
		VALUES ( N'IncidentType', N'INBasicSettings', N'IN', 154, 1, 1, 1, 1, 0, 1, 1, 1);

	INSERT Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport, UpdateAudit, DeleteAudit) 
		VALUES (N'Incident Status', N'INBasicSettings', N'IN', 155, 1, 1, 1, 1, 0, 1, 1, 1);

	INSERT Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport, UpdateAudit, DeleteAudit) 
		VALUES ( N'Category', N'INBasicSettings', N'IN', 156, 1, 1, 1, 1, 0, 1, 1, 1);

	INSERT Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport, UpdateAudit, DeleteAudit) 
		VALUES ( N'Incident Impact Type', N'INBasicSettings', N'IN', 158, 1, 1, 1, 1, 0, 1, 1, 1);

	INSERT Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport, UpdateAudit, DeleteAudit) 
		VALUES ( N'Incident Cause Type', N'INBasicSettings', N'IN', 162, 1, 1, 1, 1, 0, 1, 1, 1);


	
INSERT Menu (MenuCode, MenuName, Sequence, ParentMenuCode) VALUES (N'INCheckList', N'Incident Check List', 159, NULL)

	INSERT Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport, UpdateAudit, DeleteAudit) 
		VALUES ( N'IncidentCheckList', N'INCheckList', N'IN', 160, 1, 1, 1, 1, 0, 1, 1, 1)

	INSERT Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport, UpdateAudit, DeleteAudit) 
		VALUES (N'IncidentCheckListTask', N'INCheckList', N'IN', 161, 1, 1, 1, 1, 0, 1, 1, 1)
	INSERT INTO screenaction(ScreenID,ActionCode,ActionName,Sequence,IsAudited,IsRendered)
		VALUES (@screenID,'INChklstTskSort','Sorting',1,0,1)

INSERT Menu (MenuCode, MenuName, Sequence, ParentMenuCode) VALUES (N'INReports', N'Incident Reports', 162, NULL)

	INSERT Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport) 
		VALUES ( N'Incident Register Report', N'INReports', N'IN', 163, 0, 0, 0, 1, 0, 1)

	INSERT Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport) 
		VALUES ( N'Incident Action Report', N'INReports', N'IN', 164, 0, 0, 0, 1, 0, 1)

	INSERT Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport) 
		VALUES ( N'Incident Yearly Report', N'INReports', N'IN', 165, 0, 0, 0, 1, 0, 1)

	INSERT Screen (ScreenID,ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport) 
		VALUES (241, N'Incident MIS Reports', N'INReports', N'IN', 166, 0, 0, 0, 1, 0, 1)
	
	--INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Dashboard Training','TR',127,NULL,0,0,1,0,0)
	--INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Dashboard Training','TR',128,NULL,0,0,1,0,0)
	--INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Dashboard Training','TR',129,NULL,0,0,1,0,0)
	--INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Dashboard Training','TR',130,NULL,0,0,1,0,0)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Dashboard Drill','DR',201,NULL,0,0,1,0,0)
	--INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Dashboard Training','TR',203,NULL,0,0,1,0,0)
	--INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Dashboard Training','TR',204,NULL,0,0,1,0,0)
	--INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Dashboard Training','TR',205,NULL,0,0,1,0,0)
	--INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Dashboard Training','TR',206,NULL,0,0,1,0,0)
		INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'UpcomingDrill', 'Upcoming Drill',1,1,1);
		INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'Observation', 'Observation',1,1,1);
		INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'ObserStatus', 'Observation Status',1,1,1);


	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Drill','DR',207,NULL,1,1,1,1,1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'Drill',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'DrillSetup',0,1)
		INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'DrillData', 'Drill Data',1,1,1)
		INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'DrillObAction', 'Drill Obser./Action',2,1,1)
		INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'DrillFollowup', 'Drill Followup',3,1,1)


	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Drill Data For SP','DR',208,NULL,1,1,1,1,1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'Drill',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'DrillData',0,1)

INSERT Menu (MenuCode, MenuName, Sequence, ParentMenuCode) VALUES (N'DRChklist', N'Drill Checklist Setting', 211, NULL)
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Drill Checklist','DR',212,'DRChklist',1,1,1,1,1)
	SET @screenID = SCOPE_IDENTITY();
	INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'DrillCheckList',1)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Drill Checklist Task','DR',213,'DRChklist',1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'DrillCheckListTask',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'DrillCheckListTaskLanguage',0,1)
		INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'DRChklstTskSort', 'Sorting',1,0,1);


INSERT Menu (MenuCode, MenuName, Sequence, ParentMenuCode) VALUES (N'DRBasicSettings', N'Drill Basic Settings', 214, NULL)
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Drill Type', 'DR',215,'DRBasicSettings',1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'DrillType',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'DrillTypeLanguage',0,1)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Drill Action Type','DR',216,'DRBasicSettings',1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'DrillActionType',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'DrillActionTypeLanguage',0,1)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, DeleteAudit) VALUES ('Drill Stakeholder','DR',217,'DRBasicSettings',1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'DrillStakeholder',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'DrillStakeholderLanguage',0,1)


INSERT Menu (MenuCode, MenuName, Sequence, ParentMenuCode) 
	VALUES (N'DRReports', N'Drill Reports', 218, NULL)

	INSERT INTO  Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport, UpdateAudit, DeleteAudit) 
		VALUES ( N'Drill Register Report', N'DRReports', N'DR', 219, 0, 0, 0, 1, 0, 1, 0, 0)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete)VALUES ('Monthly Calendar','DR', 202,NULL,0,0,1,0)

	INSERT INTO Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport) 
		VALUES ( N'Drill Action Report', N'DRReports', N'DR', 220, 0, 0, 0, 1, 0, 1)
	INSERT INTO Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport) 
		VALUES ( N'Drill Frequency Report', N'DRReports', N'DR', 221, 0, 0, 0, 1, 0, 1)
	INSERT INTO Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport) 
	 VALUES ( N'Drill Status Report', N'DRReports', N'DR', 222, 0, 0, 0, 1, 0, 1)

	INSERT INTO Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport) 
		VALUES ( N'Drill Status Report', N'DRReports', N'DR', 222, 0, 0, 0, 1, 0, 1)

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete)VALUES ('Monthly Calendar','DR', 202,NULL,0,0,1,0)

--== FRAS Module start Sequence No. = 231=================================================================================

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES ('Dashboard FRAS','FR',231,NULL,0,0,1,0)
	--INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES ('Dashboard FRAS','FR',232,NULL,0,0,1,0)
	--INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES ('Dashboard FRAS','FR',233,NULL,0,0,1,0)
	--INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES ('Dashboard FRAS','FR',234,NULL,0,0,1,0)
	--INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES ('Dashboard FRAS','FR',235,NULL,0,0,1,0)

	INSERT Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport, UpdateAudit, DeleteAudit) 
		VALUES ( N'FRAS Inspection', null, N'FR', 236, 1, 1, 1, 1, 0, 1, 1, 0)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'FRASInspection',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'FRASInspectionTeam',0,1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'FRASInspectionTask',0,1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (@screenID, 'FRASInspectionPhoto',0,1)

INSERT Menu (MenuCode, MenuName, Sequence, ParentMenuCode) VALUES (N'FRASCheckList', N'FRAS Check List', 240, NULL);

	INSERT Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport, UpdateAudit, DeleteAudit) 
		VALUES ( N'FRASCheckList', N'FRASCheckList', N'FR', 241, 1, 1, 1, 1, 0, 1, 1, 1);

	INSERT Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport, UpdateAudit, DeleteAudit) 
		VALUES (N'FRASCheckListTask', N'FRASCheckList', N'FR', 242, 1, 1, 1, 1, 0, 1, 1, 1);
		INSERT INTO ScreenAction (ScreenID, ActionCode, ActionName, Sequence, IsAudited, IsRendered) VALUES (@screenID, 'FRChklstTskSort', 'Sorting',1,0,1);


INSERT Menu (MenuCode, MenuName, Sequence, ParentMenuCode) VALUES (N'FRASReports', N'FRAS Reports', 243, NULL)

INSERT Screen (ScreenName, MenuCode, ModuleCode, Sequence, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport, UpdateAudit, DeleteAudit) 
		VALUES ( N'FRAS Register Report', N'FRASReports', N'FR', 244, 0, 0, 0, 1, 0, 1, 0, 0)

--== FRAS Module End Sequence No. = 150=====================================================================

--==========================================================================================================
--WORK
--==========================================================================================================

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES ('Dashboard Work','WO',251,NULL,0,0,1,0);
	INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES (232,'Daily Work Status','WO',252,NULL,0,0,1,0);

	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete) VALUES ('Work Permit','WO',253,NULL,0,0,1,0);
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (@screenID, 'WorkPermit',1);
 

INSERT INTO Menu (MenuCode, MenuName, Sequence) VALUES('WBasicSettings','Work Basic Settings',255)
 
	INSERT INTO Screen (ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, HasExport) VALUES (209,'Work Type', 'WO', 254,'WBasicSettings',1,1,1,1,1)
		SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (209, 'WorkType',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (209, 'WorkTypeLanguage',0,1)

	INSERT INTO Screen (ScreenID,ScreenName, ModuleCode, Sequence, MenuCode, HasInsert, HasUpdate, HasSelect, HasDelete, HasExport) VALUES (239,'Work Permit Type', 'WO', 2,'WBasicSettings',1,1,1,1,1)
		--SET @screenID = SCOPE_IDENTITY();
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple) VALUES (239, 'WorkPermitType',1)
		INSERT INTO ScreenTable (ScreenID, TableName, IsSingleTuple, IsDetailFetched) VALUES (239, 'WorkPermitTypeLanguage',0,1)

--
IF(@IsNewDB	= 1)
BEGIN
	INSERT INTO UserRole (UserRoleName) VALUES('Administrator')
	SET @userRoleID = SCOPE_IDENTITY();
END
ELSE
BEGIN
	SET @userRoleID = 1;
END

INSERT INTO UserRoleMenu
	SELECT	@userRoleID, MenuCode
	FROM	Menu

INSERT INTO UserRoleScreen
	SELECT	@userRoleID, ScreenId, HasInsert, HasUpdate, HasDelete, HasSelect, HasImport, HasExport
	FROM	Screen
	
INSERT INTO UserRoleScreenAction
	SELECT	1, ScreenId, ActionCode
	FROM	ScreenAction

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

--INSERT INTO UserRole (UserRoleName) VALUES('Customer')/*will use to Customer login*/

--=======================================================================================================================--
