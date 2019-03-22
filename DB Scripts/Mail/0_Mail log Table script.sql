
CREATE	TABLE	MailType
(
	MailType			VARCHAR(30)	NOT	NULL	CONSTRAINT	MailType_PK_MailType  -- Task Created , CIL Created, CIL Updated From CallLog, CIL DealComp....
													PRIMARY KEY		CLUSTERED,
	StoredProcedureName	VARCHAR(50)		NULL
)
GO

INSERT [dbo].[MailType] ([MailType], [StoredProcedureName]) VALUES (N'Subscription Mail', 'SendSubscriptionMail')
GO

--CREATE TABLE ClientConfiguration
--(
--	 ID				BIGINT NOT NULL IDENTITY (1, 1) 
--								CONSTRAINT ClientConfiguration_PK_ID
--									PRIMARY KEY  NONCLUSTERED,
--	 FromMailID		VARCHAR(50)			NULL,
--	 GroupMailID	VARCHAR(100)		NULL
--)
--GO

--INSERT INTO ClientConfiguration VALUES('crm@equirus.com','ibk@equirus.com')
--GO

CREATE TABLE MailLog
(
	 MailID				BIGINT			NOT NULL IDENTITY (1, 1) 
													CONSTRAINT MailLog_PK_MailID
														PRIMARY KEY  NONCLUSTERED,

	 MailType			VARCHAR(30)		NOT NULL CONSTRAINT MailLog_FK_MailType
													REFERENCES MailType,

	 CreatedDate		DateTime		NOT NULL DEFAULT(GETDATE()),
 
	 -- Sends from DB/From .Net Code and stored in DB as Log  0 = db, 1 = .net 
	 IsMailFromFrontEnd	BIT				NOT NULL,
 
	 FromMailID			VARCHAR (50)	NOT NULL,
	 RecipientMailList	VARCHAR (2000)	NOT NULL,
	 CCMailList			VARCHAR (2000)		NULL,
	 BCCMailList		VARCHAR (2000)		NULL,
	 MailSubject		VARCHAR (200)	NOT NULL,
	 Body				VARCHAR (8000)	NOT NULL,

	 --Sql Server inbuild mail send table dbo.sysmail_mailitems column name is 'mailitem_id'
	 MailiItemID		BIGINT			 NULL 
)
GO

--CREATE TABLE MailLogSentTo
--(
--	 MailID			BIGINT		 NOT NULL CONSTRAINT MailLogSentTo_FK_MailID
--											REFERENCES MailLog,

--	 EndUserID		INT			 NOT NULL CONSTRAINT MailLogSentTo_FK_EndUserID
--											REFERENCES EndUser
	
--	CONSTRAINT MailLogSentTo_PK_MailID_EndUserID
--			PRIMARY KEY (MailID,EndUserID)
--)
--GO



----select dbo.GetAmountToWords(101.11)
--CREATE FUNCTION [dbo].[GetAmountToWords]( @Amount BIGINT )
--RETURNS NVARCHAR(1000)
--AS
--BEGIN
 
-- declare @Ones table (Id int, Name nvarchar(50))
-- declare @Decades table (Id int, Name nvarchar(50))

-- insert into  @Ones(Id,Name) values(0,''),(1,'One'),
-- (2,'Two'),(3,'Three'),(4,'Four'),(5,'Five'),
-- (6,'Six'),(7,'Seven'),(8,'Eight'),(9,'Nine'),
-- (10,'Ten'),(11,'Eleven'),(12,'Twelve'),(13,'Thirteen'),
-- (14,'Forteen'),(15,'Fifteen'),(16,'Sixteen'),
-- (17,'Seventeen'),(18,'Eighteen'),(19,'Nineteen')

-- insert into  @Decades(Id,Name) values(20,'Twenty'),(30,'Thirty'),
-- (40,'Forty'),(50,'Fifty'),(60,'Sixty'),
-- (70,'Seventy'),(80,'Eighty'),(90,'Ninety')

-- declare @str nvarchar(max)
-- set @str=''

-- if(@Amount >= 1 AND @Amount <20)
--  set @str = @str + (select Name from @Ones where Id = @Amount)

-- if(@Amount >= 20 AND @Amount <=99)
--  set @str = @str + (select Name From @Decades where Id = (@Amount- @Amount%10))+' ' +(select Name From @Ones where Id=(@Amount%10)) +' '

-- if(@Amount >= 100 AND @Amount <=999)
--  set @str = @str + dbo.GetAmountToWords(@Amount/100) +' Hundred '+dbo.GetAmountToWords(@Amount%100)

-- if(@Amount >= 1000 AND @Amount <=99999)
--  set @str=@str+ dbo.GetAmountToWords(@Amount/1000) +' Thousand '+dbo.GetAmountToWords(@Amount%1000)
 
-- if(@Amount >= 100000 AND @Amount <= 9999999)
--  set @str=@str+ dbo.GetAmountToWords(@Amount/100000) +' Lac '+dbo.GetAmountToWords(@Amount%100000)
 
-- if(@Amount >= 10000000)
--  set @str=@str+ dbo.GetAmountToWords(@Amount/10000000) +' Crore '+dbo.GetAmountToWords(@Amount%10000000)

--return @str
--END