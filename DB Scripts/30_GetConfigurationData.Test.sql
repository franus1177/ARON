IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'__GetConfigurationLanguage') AND TYPE IN (N'TF'))
	DROP FUNCTION __GetConfigurationLanguage
GO

CREATE FUNCTION __GetConfigurationLanguage
(
	@LangCode	CHAR(2)
)
RETURNS @Language	TABLE
		(
			LanguageCode	LanguageCode	NOT	NULL	PRIMARY KEY,
			LanguageName	ShortName		NOT	NULL	UNIQUE
		) --WITH ENCRYPTION
AS
BEGIN
		
	IF @LangCode	= 'EN' 
	BEGIN
		INSERT INTO	@Language	VALUES	(	'EN',	'English'	);
		--INSERT INTO	@Language	VALUES	(	'SV',	'Swedish'	);
	END
	
	RETURN;
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'__GetConfigurationModule') AND TYPE IN (N'TF'))
	DROP FUNCTION __GetConfigurationModule
GO

CREATE FUNCTION __GetConfigurationModule
(
	@LangCode	CHAR(2)
)
RETURNS @Module	TABLE
			(
				LanguageCode	LanguageCode		NOT	NULL,
				ModuleCode		ModuleCode			NOT NULL,
				ModuleName		GenericName			NOT	NULL,
				IsForEndUser	BIT					NOT NULL,
				SequenceNo		TINYINT				NOT NULL,

						PRIMARY KEY	CLUSTERED	(	LanguageCode, ModuleCode	),

						UNIQUE (	LanguageCode, ModuleName	)
			) --WITH ENCRYPTION
AS
BEGIN
		
		IF @LangCode	= 'EN' 
		BEGIN
			INSERT INTO	@Module	VALUES	(	@LangCode,	'BS',	'Base'				,	0,	1	);
			INSERT INTO	@Module	VALUES	(	@LangCode,	'SF',	'Safety'			,	1,	2	);
			INSERT INTO	@Module	VALUES	(	@LangCode,	'IN',	'Incident'			,	1,	3	);
			INSERT INTO	@Module	VALUES	(	@LangCode,	'DR',	'Drill'				,	1,	6	);
			INSERT INTO	@Module	VALUES	(	@LangCode,	'TR',	'Training'			,	1,	5	);
			INSERT INTO	@Module	VALUES	(	@LangCode,	'FR',	'FRAS'				,	1,	4	);
			INSERT INTO	@Module	VALUES	(	@LangCode,	'HR',	'HIRA'				,	1,	7	);
			INSERT INTO	@Module	VALUES	(	@LangCode,	'WO',	'Work Permit'		,	1,	8	);
			INSERT INTO	@Module	VALUES	(	@LangCode,	'FM',	'Fleet'				,	1,	9	);
			INSERT INTO	@Module	VALUES	(	@LangCode,	'CM',	'Complaince'		,	1,	10	);
			INSERT INTO	@Module	VALUES	(	@LangCode,	'AU',	'Audit'				,	1,	11	);
			INSERT INTO	@Module	VALUES	(	@LangCode,	'AM',	'Asset'				,	1,	12	);
		END
		ELSE IF @LangCode	= 'SV' 
		BEGIN
			INSERT INTO	@Module	VALUES	(	@LangCode,	'BS',	'Admin'				,	0,	1	);
			INSERT INTO	@Module	VALUES	(	@LangCode,	'SF',	'Safety'			,	1,	2	);
			INSERT INTO	@Module	VALUES	(	@LangCode,	'IN',	'Incident'			,	1,	3	);
			INSERT INTO	@Module	VALUES	(	@LangCode,	'DR',	'Drill'				,	1,	6	);
			INSERT INTO	@Module	VALUES	(	@LangCode,	'TR',	'Training'			,	1,	5	);
			INSERT INTO	@Module	VALUES	(	@LangCode,	'FR',	'FRAS'				,	1,	4	);
			INSERT INTO	@Module	VALUES	(	@LangCode,	'HR',	'HIRA'				,	1,	7	);
			INSERT INTO	@Module	VALUES	(	@LangCode,	'WO',	'Work Permit'		,	1,	8	);
			INSERT INTO	@Module	VALUES	(	@LangCode,	'FM',	'Fleet'				,	1,	9	);
			INSERT INTO	@Module	VALUES	(	@LangCode,	'CM',	'Complaince'		,	1,	10	);
			INSERT INTO	@Module	VALUES	(	@LangCode,	'AU',	'Audit'				,	1,	11	);
			INSERT INTO	@Module	VALUES	(	@LangCode,	'AM',	'Asset'				,	1,	12	);
		END
		
		RETURN;
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'__GetConfigurationCountry') AND TYPE IN (N'TF'))
	DROP FUNCTION __GetConfigurationCountry
GO

CREATE FUNCTION __GetConfigurationCountry
(
	@LangCode	CHAR(2)
)
RETURNS @Country	TABLE
		(
			LanguageCode	LanguageCode		NOT	NULL,
			CountryCode		CountryCode			NOT NULL,
			CountryName		GenericName			NOT	NULL,

					PRIMARY KEY	CLUSTERED	(	LanguageCode, CountryCode	),

					UNIQUE (	LanguageCode, CountryName	)
		) --WITH ENCRYPTION
AS
BEGIN
		
	IF @LangCode	= 'EN' 
	BEGIN
		  INSERT INTO	@Country	VALUES	(	@LangCode,	'IND',	'India'					);
	END
	ELSE IF @LangCode	= 'SV' 
	BEGIN
		  INSERT INTO	@Country	VALUES	(	@LangCode,	'SWD',	'Sweden'					);
	END
	
	RETURN;
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'__GetConfigurationTimeUnitData') AND TYPE IN (N'TF'))
	DROP FUNCTION __GetConfigurationTimeUnitData
GO

CREATE FUNCTION __GetConfigurationTimeUnitData
(
	@LangCode	CHAR(2)
)
RETURNS @TimeUnitData	TABLE
		(
			TimeUnitCode			TimeUnitCode		NOT	NULL,
			SequenceNo				TINYINT				NOT NULL,
			--ConvertedTimeUnitCode	TimeUnitCode		NOT	NULL,
			
			--RepeatsEvery			SMALLINT			NOT	NULL,
			TimeUnitName			ShortName			NOT	NULL,--#
			FrequencyName			ShortName			NOT	NULL,--#

			IsUsedForFrequency		BIT					NOT NULL,
			IsUsedForResolution		BIT					NOT NULL,

				PRIMARY KEY	(	TimeUnitCode, SequenceNo, TimeUnitName, FrequencyName, IsUsedForFrequency, IsUsedForResolution	)
		) --WITH ENCRYPTION
AS
BEGIN
	-- a.TimeUnitCode, b.TimeUnitName, b.FrequencyName, a.SequenceNo, a.IsUsedForFrequency, a.IsUsedForResolution
	DECLARE	@TimeUnit	TABLE
		(
			TimeUnitCode			TimeUnitCode		NOT	NULL,
			SequenceNo				TINYINT				NOT NULL,
			IsUsedForFrequency		BIT					NOT NULL,
			IsUsedForResolution		BIT					NOT NULL,

					PRIMARY KEY	(	TimeUnitCode	),
					UNIQUE 		(	SequenceNo		)
		)

	DECLARE	@TimeUnitName	TABLE
		(
			TimeUnitCode		TimeUnitCode		NOT	NULL,
			LanguageCode		LanguageCode		NOT	NULL,
			TimeUnitName		ShortName			NOT	NULL,
			TimeUnitPlural		ShortName			NOT	NULL,
			FrequencyName		ShortName			NOT	NULL,

					PRIMARY KEY	(	LanguageCode, TimeUnitCode	),
					UNIQUE (	LanguageCode, TimeUnitName	),
					UNIQUE (	LanguageCode, FrequencyName	)
		)
	
	INSERT INTO	@TimeUnit	VALUES	(	'SS',	 1,		 0,		0	);
	INSERT INTO	@TimeUnit	VALUES	(	'MM',	 2,		 0,		1	);
	INSERT INTO	@TimeUnit	VALUES	(	'HH',	 3,		 0,		1	);
	INSERT INTO	@TimeUnit	VALUES	(	'DY',	 4,		 1,		1	);
	INSERT INTO	@TimeUnit	VALUES	(	'WK',	 5,		 1,		0	);
	INSERT INTO	@TimeUnit	VALUES	(	'MT',	 6,		 1,		0	);
	INSERT INTO	@TimeUnit	VALUES	(	'QR',	 7,		 1,		0	);
	INSERT INTO	@TimeUnit	VALUES	(	'SA',	 8,		 1,		0	);
	INSERT INTO	@TimeUnit	VALUES	(	'YR',	 9,		 1,		0	);
	INSERT INTO	@TimeUnit	VALUES	(	'2Y',	 10,	 1,		0	);
	INSERT INTO	@TimeUnit	VALUES	(	'5Y',	 11,	 1,		0	);

	IF @LangCode	= 'EN' 
	BEGIN
		INSERT INTO	@TimeUnitName	VALUES	(	'SS',	@LangCode,	'Second',		'Seconds',		'Every Second'	);
		INSERT INTO	@TimeUnitName	VALUES	(	'MM',	@LangCode,	'Minute',		'Minutes',		'Every Minute'	);
		INSERT INTO	@TimeUnitName	VALUES	(	'HH',	@LangCode,	'Hour',			'Hours',		'Hourly'		);
		INSERT INTO	@TimeUnitName	VALUES	(	'DY',	@LangCode,	'Day',			'Days',			'Daily'			);
		INSERT INTO	@TimeUnitName	VALUES	(	'WK',	@LangCode,	'Week',			'Weeks',		'Weekly'		);
		INSERT INTO	@TimeUnitName	VALUES	(	'MT',	@LangCode,	'Month',		'Months',		'Monthly'		);
		INSERT INTO	@TimeUnitName	VALUES	(	'QR',	@LangCode,	'Quarter',		'Quarters',		'Quarterly'		);
		INSERT INTO	@TimeUnitName	VALUES	(	'SA',	@LangCode,	'Half-year',	'Half-years',	'Semi-annually'	);
		INSERT INTO	@TimeUnitName	VALUES	(	'YR',	@LangCode,	'Year',			'Years',		'Yearly'		);
		INSERT INTO	@TimeUnitName	VALUES	(	'2Y',	@LangCode,	'Two Year',		'2 Years',		'Two Yearly'	);
		INSERT INTO	@TimeUnitName	VALUES	(	'5Y',	@LangCode,	'Five Year',	'5 Years',		'Five Yearly'	);
	END
	ELSE IF @LangCode	= 'SV' 
	BEGIN
		INSERT INTO	@TimeUnitName	VALUES	(	'SS',	@LangCode,	'Second',		'Seconds',		'Every Second'	);
		INSERT INTO	@TimeUnitName	VALUES	(	'MM',	@LangCode,	'Minute',		'Minutes',		'Every Minute'	);
		INSERT INTO	@TimeUnitName	VALUES	(	'HH',	@LangCode,	'Hour',			'Hours',		'Hourly'		);
		INSERT INTO	@TimeUnitName	VALUES	(	'DY',	@LangCode,	'Day',			'Days',			'Daily'			);
		INSERT INTO	@TimeUnitName	VALUES	(	'WK',	@LangCode,	'Week',			'Weeks',		'Weekly'		);
		INSERT INTO	@TimeUnitName	VALUES	(	'MT',	@LangCode,	'Month',		'Months',		'Monthly'		);
		INSERT INTO	@TimeUnitName	VALUES	(	'QR',	@LangCode,	'Quarter',		'Quarters',		'Quarterly'		);
		INSERT INTO	@TimeUnitName	VALUES	(	'SA',	@LangCode,	'Half-year',	'Half-years',	'Semi-annually'	);
		INSERT INTO	@TimeUnitName	VALUES	(	'YR',	@LangCode,	'Year',			'Years',		'Yearly'		);
		INSERT INTO	@TimeUnitName	VALUES	(	'2Y',	@LangCode,	'Two Year',		'2 Years',		'Two Yearly'	);
		INSERT INTO	@TimeUnitName	VALUES	(	'5Y',	@LangCode,	'Five Year',	'5 Years',		'Five Yearly'	);
	END
	
	INSERT INTO @TimeUnitData(TimeUnitCode, TimeUnitName, FrequencyName, SequenceNo, IsUsedForFrequency, IsUsedForResolution)
	SELECT	a.TimeUnitCode, b.TimeUnitName, b.FrequencyName, a.SequenceNo, a.IsUsedForFrequency, a.IsUsedForResolution
	FROM	@TimeUnit	a
	JOIN	@TimeUnitName	b
				ON	(	a.TimeUnitCode	=	b.TimeUnitCode	)
	ORDER BY a.SequenceNo;

	RETURN;
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'__GetConfigurationTimeUnitConversion') AND TYPE IN (N'TF'))
	DROP FUNCTION __GetConfigurationTimeUnitConversion
GO

CREATE FUNCTION __GetConfigurationTimeUnitConversion
(
	@LangCode	CHAR(2)
)
RETURNS @TimeUnitConversion	TABLE
		(
			TimeUnitCode			TimeUnitCode		NOT	NULL,
			ConvertedTimeUnitCode	TimeUnitCode		NOT	NULL,
			RepeatsEvery			SMALLINT			NOT	NULL,

				PRIMARY KEY	(	TimeUnitCode, ConvertedTimeUnitCode	)
		) --WITH ENCRYPTION
AS
BEGIN

	INSERT INTO	@TimeUnitConversion	VALUES	(	'MM',	'SS',	60	);
	INSERT INTO	@TimeUnitConversion	VALUES	(	'HH',	'MM',	60	);
	INSERT INTO	@TimeUnitConversion	VALUES	(	'DY',	'HH',	24	);
	INSERT INTO	@TimeUnitConversion	VALUES	(	'WK',	'DY',	7 	);
	INSERT INTO	@TimeUnitConversion	VALUES	(	'MT',	'DY',	28	);
	INSERT INTO	@TimeUnitConversion	VALUES	(	'MT',	'WK',	4	);
	INSERT INTO	@TimeUnitConversion	VALUES	(	'QR',	'MT',	3	);
	INSERT INTO	@TimeUnitConversion	VALUES	(	'SA',	'MT',	6	);
	INSERT INTO	@TimeUnitConversion	VALUES	(	'YR',	'MT',	12	);
	INSERT INTO	@TimeUnitConversion	VALUES	(	'2Y',	'YR',	2	);
	INSERT INTO	@TimeUnitConversion	VALUES	(	'2Y',	'MT',	24	);
	INSERT INTO	@TimeUnitConversion	VALUES	(	'5Y',	'YR',	5	);
	INSERT INTO	@TimeUnitConversion	VALUES	(	'5Y',	'MT',	60	);
	
	RETURN;
END
GO

--=========================================================================================================
-- Safety Module
--=========================================================================================================


IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'__GetConfigurationServiceLine') AND TYPE IN (N'TF'))
	DROP FUNCTION __GetConfigurationServiceLine
GO

CREATE FUNCTION __GetConfigurationServiceLine
(
	@LangCode	CHAR(2)
)
RETURNS @ServiceLine	TABLE
		(
			LanguageCode		LanguageCode		NOT	NULL,
			ServiceLineCode		ServiceLineCode		NOT NULL,
			ServiceLineName		GenericName			NOT	NULL,

				PRIMARY KEY	CLUSTERED	(	LanguageCode, ServiceLineCode	),
				UNIQUE (	LanguageCode, ServiceLineName	)

		) --WITH ENCRYPTION
AS
BEGIN
		
	IF @LangCode	= 'EN' 
	BEGIN
		INSERT INTO	@ServiceLine	VALUES	(	@LangCode,	'FR',	'Fire Services'		);
	END
	ELSE IF @LangCode	= 'SV' 
	BEGIN
		INSERT INTO	@ServiceLine	VALUES	(	@LangCode,	'FR',	'Fire Services'		);
	END
	
	RETURN;
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'__GetConfigurationRiskLevel') AND TYPE IN (N'TF'))
	DROP FUNCTION __GetConfigurationRiskLevel
GO

CREATE FUNCTION __GetConfigurationRiskLevel
(
	@LangCode	CHAR(2)
)
RETURNS @RiskLevel	TABLE
			(	RiskLevelID			RiskLevelID		NOT NULL,
				LanguageCode		LanguageCode	NOT	NULL,
				RiskLevelName		ShortName		NOT	NULL,
				ColorCode			ShortName			NULL,

						PRIMARY KEY	(	RiskLevelID, LanguageCode	),
						UNIQUE 		(	LanguageCode, RiskLevelName	)
			) --WITH ENCRYPTION
AS
BEGIN
		
	IF @LangCode	= 'EN' 
	BEGIN
		INSERT INTO @RiskLevel	VALUES	(	1,	@LangCode,	'High',  '#ff0000'	);
		INSERT INTO @RiskLevel	VALUES	(	2,	@LangCode,	'Medium','#fcc100'	);
		INSERT INTO @RiskLevel	VALUES	(	3,	@LangCode,	'Low',   '#84b761'	);
		INSERT INTO @RiskLevel	VALUES	(	4,	@LangCode,	'None',  NULL	);
	END
	ELSE IF @LangCode	= 'SV' 
	BEGIN
		INSERT INTO @RiskLevel	VALUES	(	3,	@LangCode,	'High',  '#ff0000'	);
		INSERT INTO @RiskLevel	VALUES	(	2,	@LangCode,	'Medium','#fcc100'	);
		INSERT INTO @RiskLevel	VALUES	(	1,	@LangCode,	'Low',   '#84b761'	);
		INSERT INTO @RiskLevel	VALUES	(	4,	@LangCode,	'None',  NULL	);
	END

	RETURN;
END
GO


IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'__GetConfigurationSeverityLevel') AND TYPE IN (N'TF'))
	DROP FUNCTION __GetConfigurationSeverityLevel
GO

CREATE FUNCTION __GetConfigurationSeverityLevel
(
	@LangCode	CHAR(2)
)
RETURNS @SeverityLevel	TABLE
		(	SeverityLevelID		SeverityLevelID	NOT NULL,
			LanguageCode		LanguageCode	NOT	NULL,
			SeverityLevelName	ShortName		NOT	NULL,

					PRIMARY KEY	(	SeverityLevelID, LanguageCode	),
					UNIQUE 		(	LanguageCode, SeverityLevelName	)
		) --WITH ENCRYPTION
AS
BEGIN
		
	IF @LangCode	= 'EN' 
	BEGIN
		INSERT INTO @SeverityLevel	VALUES	(	1,	@LangCode,	'Critical'	);
		INSERT INTO @SeverityLevel	VALUES	(	2,	@LangCode,	'High'		);
		INSERT INTO @SeverityLevel	VALUES	(	3,	@LangCode,	'Medium'	);
		INSERT INTO @SeverityLevel	VALUES	(	4,	@LangCode,	'Low'		);
	END
	ELSE IF @LangCode	= 'SV' 
	BEGIN
		INSERT INTO @SeverityLevel	VALUES	(	1,	@LangCode,	'Critical'	);
		INSERT INTO @SeverityLevel	VALUES	(	2,	@LangCode,	'High'		);
		INSERT INTO @SeverityLevel	VALUES	(	3,	@LangCode,	'Medium'	);
		INSERT INTO @SeverityLevel	VALUES	(	4,	@LangCode,	'Low'		);
	END

	RETURN;
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'__GetConfigurationPriorityLevel') AND TYPE IN (N'TF'))
	DROP FUNCTION __GetConfigurationPriorityLevel
GO

CREATE FUNCTION __GetConfigurationPriorityLevel
(
	@LangCode	CHAR(2)
)
RETURNS @PriorityLevel	TABLE
		(	PriorityLevelID		PriorityID	NOT NULL,
			LanguageCode		LanguageCode	NOT	NULL,
			PriorityLevelName	ShortName		NOT	NULL,

					PRIMARY KEY	(	PriorityLevelID, LanguageCode	),
					UNIQUE 		(	LanguageCode, PriorityLevelName	)
		) --WITH ENCRYPTION
AS
BEGIN
		
	IF @LangCode	= 'EN' 
	BEGIN
		INSERT INTO @PriorityLevel	VALUES	(	1,	@LangCode,	'Critical'	);
		INSERT INTO @PriorityLevel	VALUES	(	2,	@LangCode,	'High'		);
		INSERT INTO @PriorityLevel	VALUES	(	3,	@LangCode,	'Medium'	);
		INSERT INTO @PriorityLevel	VALUES	(	4,	@LangCode,	'Low'		);
	END
	ELSE IF @LangCode	= 'SV' 
	BEGIN
		INSERT INTO @PriorityLevel	VALUES	(	1,	@LangCode,	'Critical'	);
		INSERT INTO @PriorityLevel	VALUES	(	2,	@LangCode,	'High'		);
		INSERT INTO @PriorityLevel	VALUES	(	3,	@LangCode,	'Medium'	);
		INSERT INTO @PriorityLevel	VALUES	(	4,	@LangCode,	'Low'		);
	END

	RETURN;
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'__GetConfigurationInspectionType') AND TYPE IN (N'TF'))
	DROP FUNCTION __GetConfigurationInspectionType
GO

CREATE FUNCTION __GetConfigurationInspectionType
(
	@LangCode	CHAR(2)
)
RETURNS @InspectionType	TABLE
		(	LanguageCode		LanguageCode		NOT	NULL,
			InspectionType		InspectionType		NOT	NULL,
			InspectionTypeName	LongName			NOT	NULL,

					PRIMARY KEY	(	LanguageCode, InspectionType	)
		) --WITH ENCRYPTION
AS
BEGIN
		
	IF @LangCode	= 'EN' 
	BEGIN
		INSERT INTO @InspectionType	VALUES	(	@LangCode, 'Routine',	  'Routine Inspection'	);
		INSERT INTO @InspectionType	VALUES	(	@LangCode, 'Maintenance', 'Maintenance'	);
		INSERT INTO @InspectionType	VALUES	(	@LangCode, 'Vehicle', 'Vehicle Inspection'	);
		INSERT INTO @InspectionType	VALUES	(	@LangCode, 'Hospital', 'Hospital Inspection'	);

	END
	ELSE IF @LangCode	= 'SV' 
	BEGIN
		INSERT INTO @InspectionType	VALUES	(	@LangCode, 'Routine',     'Routine Inspection'	);
		INSERT INTO @InspectionType	VALUES	(	@LangCode, 'Maintenance', 'Underhåll'	);
		INSERT INTO @InspectionType	VALUES	(	@LangCode, 'Vehicle', 'Vehicle Inspection'	);
		INSERT INTO @InspectionType	VALUES	(	@LangCode, 'Hospital', 'Hospital Inspection'	);


	END

	RETURN;
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'__GetConfigurationFRASInspectionType') AND TYPE IN (N'TF'))
	DROP FUNCTION __GetConfigurationFRASInspectionType
GO

CREATE FUNCTION __GetConfigurationFRASInspectionType
(
	@LangCode	CHAR(2)
)
RETURNS @InspectionType	TABLE
		(	LanguageCode		LanguageCode		NOT	NULL,
			InspectionType		InspectionType		NOT	NULL,
			InspectionTypeName	LongName			NOT	NULL,

					PRIMARY KEY	(	LanguageCode, InspectionType	)
		) --WITH ENCRYPTION
AS
BEGIN
	
	IF @LangCode	= 'EN' 
	BEGIN
		INSERT INTO @InspectionType	VALUES	(	@LangCode, 'RISK', 'Risk Assessment Full'	);
		INSERT INTO @InspectionType	VALUES	(	@LangCode, 'RISKBURN', 'Risk Assessment - Burn'	);
		INSERT INTO @InspectionType	VALUES	(	@LangCode, 'RISKESCAPE', 'Risk Assessment - Escape'	);
		INSERT INTO @InspectionType VALUES	(	@LangCode, 'RISKControl', 'Risk Assessment - MgtControl' );
		INSERT INTO @InspectionType VALUES	(	@LangCode, 'RISKMainControl', 'Risk Assessment - Main Control' );
		INSERT INTO @InspectionType VALUES	(	@LangCode, 'HAZ', 'Hazards' );

	END
	ELSE IF @LangCode	= 'SV' 
	BEGIN
		INSERT INTO @InspectionType	VALUES	(	@LangCode, 'RISK', 'Risk Assessment Full'	);
		INSERT INTO @InspectionType	VALUES	(	@LangCode, 'RISKBURN', 'Risk Assessment - Burn'	);
		INSERT INTO @InspectionType	VALUES	(	@LangCode, 'RISKESCAPE', 'Risk Assessment - Escape'	);
		INSERT INTO @InspectionType VALUES	(	@LangCode, 'RISKControl', 'Risk Assessment - MgtControl' );
		INSERT INTO @InspectionType VALUES	(	@LangCode, 'RISKMainControl', 'Risk Assessment - Main Control' );
		INSERT INTO @InspectionType VALUES	(	@LangCode, 'HAZ', 'Hazards' );
	END

	RETURN;
END
GO


IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'__GetConfigurationServiceLevel') AND TYPE IN (N'TF'))
	DROP FUNCTION __GetConfigurationServiceLevel
GO

CREATE FUNCTION __GetConfigurationServiceLevel
(
	@LangCode	CHAR(2)
)
RETURNS @ServiceLevel	TABLE
		(	ServiceLevelID		ServiceLevelID	NOT NULL,
			LanguageCode		LanguageCode	NOT	NULL,
			ServiceLevelName	ShortName		NOT	NULL,

				PRIMARY KEY	(	ServiceLevelID, LanguageCode	),
				UNIQUE 		(	LanguageCode, ServiceLevelName	)
		) --WITH ENCRYPTION
AS
BEGIN
		
	IF @LangCode = 'EN' 
	BEGIN
		INSERT INTO @ServiceLevel	VALUES	(	1,	@LangCode,	'IS'/*'Indian Standard'*/	);
	END
	ELSE IF @LangCode = 'SV' 
	BEGIN
		INSERT INTO @ServiceLevel	VALUES	(	1,	@LangCode,	'IS'/*'Indian Standard'*/	);
	END

	RETURN;
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'__GetConfigurationAttributeType') AND TYPE IN (N'TF'))
	DROP FUNCTION __GetConfigurationAttributeType
GO

CREATE FUNCTION __GetConfigurationAttributeType
(
	@LangCode	CHAR(2)
)
RETURNS @AttributeTypeData	TABLE
		(
			AttributeType		AttributeType		NOT	NULL,
			AttributeTypeName	ShortName			NOT	NULL,
			BaseDataType		ShortName			NOT NULL,
			MaxTextLength		SMALLINT				NULL,
			IsUsedForObjects	BIT					NOT NULL,
			IsUsedForCheckLists	BIT					NOT NULL,

					PRIMARY KEY	(	AttributeType,AttributeTypeName	)
		)
		--WITH ENCRYPTION
AS
BEGIN

	DECLARE	@AttributeType	TABLE
		(
			AttributeType		AttributeType		NOT	NULL,
			BaseDataType		ShortName			NOT NULL,
			MaxTextLength		SMALLINT				NULL,
			IsUsedForObjects	BIT					NOT NULL,
			IsUsedForCheckLists	BIT					NOT NULL,

					PRIMARY KEY	(	AttributeType	)
		)

	DECLARE	@AttributeTypeName	TABLE
		(
			AttributeType		AttributeType		NOT	NULL,
			LanguageCode		LanguageCode		NOT	NULL,
			AttributeTypeName	ShortName			NOT	NULL,

					PRIMARY KEY	(	LanguageCode, AttributeType	),
					UNIQUE (	LanguageCode, AttributeTypeName	)
		)
	
	INSERT INTO	@AttributeType	VALUES	(	'STRING',	 'NVARCHAR (50)',		 50,	1,		1	);
	INSERT INTO	@AttributeType	VALUES	(	'TEXT',		 'NVARCHAR (500)',		 500,	0,		1	);
	INSERT INTO	@AttributeType	VALUES	(	'PARA',		 'NVARCHAR (4000)',		 4000,	0,		1	);
	INSERT INTO	@AttributeType	VALUES	(	'FLOAT',	 'FLOAT',				 NULL,	1,		1	);
	INSERT INTO	@AttributeType	VALUES	(	'BOOL',		 'BIT',					 NULL,	1,		1	);
	INSERT INTO	@AttributeType	VALUES	(	'DATE',		 'DATE',				 NULL,	1,		1	);
	INSERT INTO	@AttributeType	VALUES	(	'DATETIME',	 'DATETIME',			 NULL,	1,		1	);
	INSERT INTO	@AttributeType	VALUES	(	'TIME',		 'DATETIME',			 NULL,	1,		1	);
	INSERT INTO	@AttributeType	VALUES	(	'IMAGE',	 'BIGINT',				 NULL,	1,		1	);

	IF @LangCode	= 'EN' 
	BEGIN
		INSERT INTO	@AttributeTypeName	VALUES	(	'STRING',	@LangCode,	'String'	);
		INSERT INTO	@AttributeTypeName	VALUES	(	'TEXT',		@LangCode,	'Text'		);
		INSERT INTO	@AttributeTypeName	VALUES	(	'PARA',		@LangCode,	'Para'		);
		INSERT INTO	@AttributeTypeName	VALUES	(	'FLOAT',	@LangCode,	'Number'	);
		INSERT INTO	@AttributeTypeName	VALUES	(	'BOOL',		@LangCode,	'Flag'		);
		INSERT INTO	@AttributeTypeName	VALUES	(	'DATE',		@LangCode,	'Date'		);
		INSERT INTO	@AttributeTypeName	VALUES	(	'DATETIME',	@LangCode,	'Date Time'	);
		INSERT INTO	@AttributeTypeName	VALUES	(	'TIME',		@LangCode,	'Time'		);
		INSERT INTO	@AttributeTypeName	VALUES	(	'IMAGE',	@LangCode,	'Photo'		);
	END

	INSERT INTO @AttributeTypeData
	SELECT	a.AttributeType, b.AttributeTypeName, a.BaseDataType, a.MaxTextLength, a.IsUsedForObjects, a.IsUsedForCheckLists
	FROM	@AttributeType	a
		JOIN	@AttributeTypeName	b
			ON	(	a.AttributeType	=	b.AttributeType	)

	RETURN;
END
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'__GetConfigurationYearlyMonth') AND TYPE IN (N'TF'))
	DROP FUNCTION __GetConfigurationYearlyMonth
GO

CREATE FUNCTION __GetConfigurationYearlyMonth
(
	@LangCode	CHAR(2)
)
RETURNS @YearlyMonth	TABLE
		(	MonthNo				TINYINT			NOT NULL,
			MonthName			ShortName		NOT	NULL,
			MonthNameShort		ShortName		NOT	NULL,
			FinacialSequence	TINYINT			NOT	NULL		
					PRIMARY KEY	(	MonthNo, MonthName, MonthNameShort	),
					UNIQUE 		(	MonthNo, MonthName, MonthNameShort, FinacialSequence	)
		) --WITH ENCRYPTION
AS
BEGIN
		
	IF @LangCode	= 'EN' 
	BEGIN
		INSERT INTO @YearlyMonth	VALUES	(	1,	'January'		,'Jan',1);
		INSERT INTO @YearlyMonth	VALUES	(	2,	'February '		,'Feb',2);
		INSERT INTO @YearlyMonth	VALUES	(	3,	'March '		,'Mar',3);
		INSERT INTO @YearlyMonth	VALUES	(	4,	'April'			,'Apr',4);
		INSERT INTO @YearlyMonth	VALUES	(	5,	'May'			,'May',5);
		INSERT INTO @YearlyMonth	VALUES	(	6,	'June'			,'Jun',6);
		INSERT INTO @YearlyMonth	VALUES	(	7,	'July'			,'Jul',7);
		INSERT INTO @YearlyMonth	VALUES	(	8,	'August '		,'Aug',8);
		INSERT INTO @YearlyMonth	VALUES	(	9,	'September'		,'Sep',9);
		INSERT INTO @YearlyMonth	VALUES	(	10,	'October'		,'Oct',10);
		INSERT INTO @YearlyMonth	VALUES	(	11,	'November'		,'Nov',11);
		INSERT INTO @YearlyMonth	VALUES	(	12,	'December'		,'Dec',12);
	END
	ELSE IF @LangCode	= 'SV' 
	BEGIN
		INSERT INTO @YearlyMonth	VALUES	(	1,	'januari'		,'jan',1);
		INSERT INTO @YearlyMonth	VALUES	(	2,	'februari '		,'feb',2);
		INSERT INTO @YearlyMonth	VALUES	(	3,	'mars '			,'mar',3);
		INSERT INTO @YearlyMonth	VALUES	(	4,	'april'			,'apr',4);
		INSERT INTO @YearlyMonth	VALUES	(	5,	'maj'			,'maj',5);
		INSERT INTO @YearlyMonth	VALUES	(	6,	'June'			,'jun',6);
		INSERT INTO @YearlyMonth	VALUES	(	7,	'juli'			,'jul',7);
		INSERT INTO @YearlyMonth	VALUES	(	8,	'augusti '		,'aug',8);
		INSERT INTO @YearlyMonth	VALUES	(	9,	'september '	,'sep',9);
		INSERT INTO @YearlyMonth	VALUES	(	10,	'oktober'		,'okt',10);
		INSERT INTO @YearlyMonth	VALUES	(	11,	'november '		,'nov',11);
		INSERT INTO @YearlyMonth	VALUES	(	12,	'december'		,'dec',12);
	END

	RETURN;
END
GO

--=======================================================================================================================================

--=======================================================================================================================================

IF EXISTS (	SELECT 1 FROM sysobjects WHERE name = '__GetSFConfigurationData' AND xtype = 'P')
	DROP PROCEDURE __GetSFConfigurationData
GO

CREATE PROCEDURE __GetSFConfigurationData
(
	@L	CHAR (2)
)
--WITH ENCRYPTION
AS
BEGIN
	DECLARE
		@EnglishLangCode	CHAR (2)	=	'EN';
	
	-- ======================================================================
	---------------------- 6 Service Line -------------------------------------
	-- ======================================================================

		SELECT	ServiceLineCode, ServiceLineName
		FROM	dbo.__GetConfigurationServiceLine(@L)

	-- ======================================================================
	---------------------- 7 Configurable Codes -------------------------------
	-- ======================================================================

	DECLARE	@Configuration	TABLE
		(	ConfigurationCode		ConfigurationCode	NOT NULL	PRIMARY KEY,
			ConfigurationValue		INTEGER					NULL,
			CanBeSetForCustomer		BIT					NOT NULL
		);

	INSERT	INTO	@Configuration	VALUES	(	'CtgryLvl',					2,		0);			--- Maximum Number of Levels allowed for Categories across Business Lines
	INSERT INTO		@Configuration  VALUES  (	'LocLvl',					6,		0);			--- Maximum Number of Levels allowed for Locations across Business Lines
	INSERT INTO		@Configuration  VALUES  (	'IsGroupRequired',			0,		0);			--- Maximum Number of Levels allowed for Locations across Business Lines
	INSERT INTO		@Configuration  VALUES  (	'IsDevRespRequired',		0,		0);			--- Maximum Number of Levels allowed for Locations across Business Lines

	--INSERT	INTO	@Configuration	VALUES	(	'PrvDaysData',		30,		1);			--- Number of days in past for which data should be loaded on a device
	--INSERT	INTO	@Configuration	VALUES	(	'NxtDaysData',		7,		1);			--- Number of days in future for which data should be loaded on a device
	--INSERT	INTO	@Configuration	VALUES	(	'MxChkItms',		2,		1);			--- Maximum Number of CheckList Items in 1000s for all checklists in an Year considering Frequency and Inspection Types across Business Lines
	--INSERT	INTO	@Configuration	VALUES	(	'MxRprCmps',		2,		1);			--- Maximum Number of Repair Components in 100s that can reside on a device

	DECLARE	@ConfigurationName	TABLE
		(	ConfigurationCode	ConfigurationCode	NOT NULL,
			LanguageCode		LanguageCode		NOT	NULL,
			ConfigurationName	GenericName			NOT	NULL,

					PRIMARY KEY	(	LanguageCode, ConfigurationCode	),
					UNIQUE 		(	LanguageCode, ConfigurationName	)
		);

	--INSERT	INTO	@ConfigurationName	VALUES	(	'CallObjctAs',		@EnglishLangCode, 'Asset'			);
	--INSERT	INTO	@ConfigurationName	VALUES	(	'CallCntrllrAs',	@EnglishLangCode, 'Technician'		);
	INSERT INTO			@ConfigurationName	VALUES	( 'CtgryLvl', @EnglishLangCode, 'Category Level' );
	INSERT INTO			@ConfigurationName	VALUES	( 'LocLvl',	  @EnglishLangCode, 'Location Level' );
	INSERT INTO			@ConfigurationName	VALUES	( 'IsGroupRequired',	  @EnglishLangCode, 'Show Groups' );
	INSERT INTO			@ConfigurationName	VALUES	( 'IsDevRespRequired',	  @EnglishLangCode, 'Deviation Responsible' );

	SELECT	a.ConfigurationCode, b.ConfigurationName, a.ConfigurationValue
	FROM	@Configuration	a
		LEFT JOIN	@ConfigurationName	b
			ON	(	a.ConfigurationCode	=	b.ConfigurationCode	
				AND	b.LanguageCode		=	@L
				);
	
	-- ======================================================================
	---------------------- 8 Risk Levels ----- 1 through 4 -------------------- 
	--- Lower Sequence Number signifies higher Risk Level and vice versa
	-- ======================================================================

		SELECT	a.RiskLevelID, a.RiskLevelName, a.ColorCode
		FROM	dbo.__GetConfigurationRiskLevel(@L) as a
		ORDER BY 1;

	-- ======================================================================
	---------------------- 9 Severity Levels ----- 1 through 4 -------------------- 
	--- Lower Sequence Number signifies higher Severity Level and vice versa
	-- ======================================================================

		SELECT	a.SeverityLevelID, a.SeverityLevelName
		FROM	dbo.__GetConfigurationSeverityLevel(@L) as a
		ORDER BY 1;

	-- ======================================================================
	---------------------- 10 Inspection Types --------------------------------- 
	-- ======================================================================

		SELECT	InspectionType,InspectionTypeName
		FROM	dbo.__GetConfigurationInspectionType(@L) as a
		ORDER BY 1 DESC;
			
	-- ======================================================================
	---------------------- 11 Service Levels ----------------------------------- 
	-- ======================================================================

	
		SELECT	ServiceLevelID, ServiceLevelName
		FROM	dbo.__GetConfigurationServiceLevel(@L)
		ORDER BY 1;

	-- ======================================================================
	----------------------12 Types of Attributes ------------------------------
	-- ======================================================================
	
		SELECT	a.AttributeType, a.AttributeTypeName, a.BaseDataType, a.MaxTextLength, a.IsUsedForObjects, a.IsUsedForCheckLists
		FROM	dbo.__GetConfigurationAttributeType(@L)	a
		ORDER BY 2

	-- ======================================================================
	---------------------- 13 PriorityLevel --------------------------------- 
	-- ======================================================================

		SELECT	a.PriorityLevelID, a.PriorityLevelName
		FROM	dbo.__GetConfigurationPriorityLevel('EN') as a
		ORDER BY 1;

	-- ======================================================================
	---------------------- 14 Inspection Types --------------------------------- 
	-- ======================================================================

		SELECT	InspectionType,InspectionTypeName
		FROM	dbo.__GetConfigurationFRASInspectionType(@L) as a
		ORDER BY 1 DESC;

	RETURN 0;
END
GO


IF EXISTS (	SELECT 1 FROM sysobjects WHERE name = '__GetINConfigurationData' AND xtype = 'P')
	DROP PROCEDURE __GetINConfigurationData
GO

CREATE PROCEDURE __GetINConfigurationData
(
	@L	CHAR (2)
)
--WITH ENCRYPTION
AS
BEGIN
		SELECT 1
END
GO

IF EXISTS (	SELECT 1 FROM sysobjects WHERE name = '__GetDRConfigurationData' AND xtype = 'P')
	DROP PROCEDURE __GetDRConfigurationData
GO

CREATE PROCEDURE __GetDRConfigurationData
(
	@L	CHAR (2)
)
--WITH ENCRYPTION
AS
BEGIN
		SELECT 1
END
GO


IF EXISTS (	SELECT 1 FROM sysobjects WHERE name = '__GetCMConfigurationData' AND xtype = 'P')
	DROP PROCEDURE __GetCMConfigurationData
GO

CREATE PROCEDURE __GetCMConfigurationData
(
	@L	CHAR (2)
)
--WITH ENCRYPTION
AS
BEGIN
		SELECT 1
END
GO

IF EXISTS (	SELECT 1 FROM sysobjects WHERE name = '__GetRKConfigurationData' AND xtype = 'P')
	DROP PROCEDURE __GetRKConfigurationData
GO

CREATE PROCEDURE __GetRKConfigurationData
(
	@L	CHAR (2)
)
--WITH ENCRYPTION
AS
BEGIN
		SELECT 1
END
GO


IF EXISTS (	SELECT 1 FROM sysobjects WHERE name = '__GetConfigurationData' AND xtype = 'P')
	DROP PROCEDURE __GetConfigurationData
GO

CREATE PROCEDURE __GetConfigurationData
(
	@M	VARCHAR (5),
	@L	CHAR (2)
)
--WITH ENCRYPTION
AS
BEGIN
			-- ==============================
			---- 1 Setup Language -------
			-- ==============================

	DECLARE
		@EnglishLangCode	CHAR (2)	=	'EN',
		@SwedishLangCode	CHAR (2)	=	'SV';

	SELECT	*
	FROM	dbo.__GetConfigurationLanguage(@L);

	IF NOT EXISTS	(	SELECT	1
						FROM	dbo.__GetConfigurationLanguage(@L) as a
						WHERE	a.LanguageCode	=	@L
					)
	BEGIN
		RAISERROR ('Invalid Language parameter - not supported', 16, 1);
		RETURN -1;
	END

	-- ======================================================================
	---------------------- 2 Module -------------------------------------
	-- ======================================================================

	SELECT	a.*
	FROM	dbo.__GetConfigurationModule(@L) as a
	ORDER BY	a.SequenceNo;

	-- ======================================================================
	---------------------- 3 Country -------------------------------------
	-- ======================================================================

 	SELECT	*
	FROM	dbo.__GetConfigurationCountry(@L);

	-- ======================================================================
	---------------------- 4 Units of Time ------------------------------------
	-- ======================================================================

	SELECT	a.* 
	FROM dbo.__GetConfigurationTimeUnitData(@L) AS a;

	-- ======================================================================
	---------------------- 5 Units of TimeUnitConversion --------------------
	-- ======================================================================
	SELECT	a.*
	FROM	dbo.__GetConfigurationTimeUnitConversion(@L) as a

	-- ======================================================================
	----------------- Get the Service Line Specific Data --------------------
	-- ======================================================================

	IF (@M = 'SF')
		EXEC __GetSFConfigurationData @L;
	ELSE IF (@M = 'IN')
		EXEC __GetINConfigurationData @L;
	ELSE IF (@M = 'DR')
		EXEC __GetDRConfigurationData @L;
	ELSE IF (@M = 'CM')
		EXEC __GetCMConfigurationData @L;
	ELSE IF (@M = 'RK')
		EXEC __GetRKConfigurationData @L;
	ELSE
	BEGIN
		RAISERROR ('Invalid M parameter - not supported', 16, 1);
		RETURN -2;
	END
	RETURN 0;
END
GO
