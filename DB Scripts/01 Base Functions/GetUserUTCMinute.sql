IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetTimeZone') AND TYPE IN (N'P'))
DROP PROCEDURE GetTimeZone 
GO

CREATE PROCEDURE GetTimeZone
(
	@p_LanguageCode CHAR(2) = 'EN'
)
----WITH ENCRYPTION
AS
BEGIN
 	
	SELECT	TimeZoneID,
			TimeZoneValue,
			Descriptions
	FROM	TimeZone
	ORDER BY TimeZoneValue,Descriptions
	
END
GO


IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetDataUTC'))
	DROP FUNCTION GetDataUTC
GO

CREATE FUNCTION GetDataUTC
(
	@pTimeZoneValue	int,
	@Date			DATETIME
)
RETURNS DATETIME
AS
BEGIN
	DECLARE @pTimeZoneValue2 float = 5.5;
	--set @pTimeZoneValue2 = Select * from TimeZone where TimeZoneValue  =  @pTimeZoneValue

	IF(@Date IS NOT NULL)
	BEGIN
		--DECLARE @minutes INT = 0;
		--SELECT	--b.hours,
		--		--b.minutes,
		--		@minutes = ( b.hours * 60 + (case when b.minutes is not null then b.minutes else 0 end) )-- as finalmin
		--FROM ( 
		--		SELECT 
		--		a.hours,
		--		--a.minutes as 'Min',
		--		case when Convert(float,a.minutes) > 0 
		--				  then substring(a.minutes,3,2) 
		--			when Convert(float,a.minutes) = 0 
		--						then null 
		--				  else
		--					'-'+substring(a.minutes,4,2) 
		--				  end as  minutes

		--		FROM (
		--				SELECT  Convert(float,5.3) as UTCOffset,
		--						Convert(int,@pTimeZoneValue2) hours,
		--						Convert(nvarchar(5), Convert(float, Convert(float,@pTimeZoneValue2) - Convert(int,convert(float,@pTimeZoneValue2))) ) minutes
		--		) as a
		--) as b

		RETURN DATEADD(minute,@pTimeZoneValue/*@minutes*/,@Date);
	END
	BEGIN
		RETURN @Date;
	END
END
GO


IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetUserUTCMinute'))
	DROP FUNCTION GetUserUTCMinute
GO

CREATE FUNCTION GetUserUTCMinute
(
	@p_EndUserID	UserID 
)
RETURNS INT
AS
BEGIN
	DECLARE @minutes INT = 0;

		SELECT  @minutes = TimeZoneValue
		FROM EndUser
		JOIN TimeZone
				ON Convert(int,UTCOffset) = TimeZoneID
		WHERE EndUser.EndUserID = @p_EndUserID

	 RETURN @minutes;
END
GO