
IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'SendDBMail') AND TYPE IN (N'P'))
DROP PROCEDURE SendDBMail
GO

CREATE PROCEDURE SendDBMail
(
	@p_From					NVARCHAR(50),
	@p_RecipientMailList	VARCHAR(2000),
	@p_CCMailList			VARCHAR(2000),
	@p_BCCMailList			VARCHAR(2000),
	@p_Subject				NVARCHAR(200),
	@p_body					NVARCHAR(MAX),
	@Mailitemid				INT	OUTPUT
)
WITH ENCRYPTION
AS
BEGIN

		EXEC msdb.dbo.sp_send_dbmail
				@profile_name			=	'Naffco_Mail', 
				@recipients				=	@p_RecipientMailList, 
				@From_address			=	@p_From, 
				@copy_recipients        =	@p_CCMailList,
				@blind_copy_recipients  =	@p_BCCMailList,
				@body					=	@p_body, 
				@subject				=	@p_Subject, 
				@body_format			=	'HTML',
				@file_attachments		=	NULL,
				@importance				=	'High',
				@sensitivity			=	'Normal',--Normal,Personal,Private,Confidential
				@mailitem_id			=	@Mailitemid OUT

		---- select top 5 sent_status,* from msdb.[dbo].[sysmail_mailitems] order by send_request_date desc
		---- delete from MailLogSentTo
		---- delete from MailLog
		---- delete from msdb.dbo.sysmail_mailitems

		--===Below Commnet Code is Generate New Profile--and if want to update profile then drop first and recreate==========================================
			----For First Time only to server
			----use master 
			----go 
			----sp_configure 'show advanced options',1 
			----go 
			----reconfigure with override 
			----go 
			----sp_configure 'Database Mail XPs',1 
			----go 
			------sp_configure 'SQL Mail XPs',0 
			------go 
			----reconfigure 
			----go 

			--declare @profileName2 varchar(100) = 'Naffco_Mail'
			--declare @account_name2 varchar(100) = @profileName2 +'_Account'

			--declare @account_name            varchar(100) = @account_name2,
			--		@email_address           varchar(100) = 'info@newindiatech.in', 
			--		@display_name            varchar(100) = 'Naffco Alert', 
			--		@replyto_address         varchar(100) = '', 
			--		@description             varchar(100) = '', 
			--		@mailserver_name         varchar(100) = 'smtp.net4india.com', 
			--		@mailserver_type         varchar(100) = 'SMTP', 
			--		@port                    varchar(100) = '587', 
			--		@username                varchar(100) = 'info@newindiatech.in', 
			--		@password                varchar(100) = 'adminis',  
			--		@use_default_credentials bit =  0 , 
			--		@enable_ssl              bit =  0 ; 


			----==Drop Settings For eSafecNaffco_Mail Profile ==================================================================

			--IF EXISTS(SELECT * FROM msdb.dbo.sysmail_profileaccount pa INNER JOIN msdb.dbo.sysmail_profile p 
			--			ON pa.profile_id = p.profile_id  INNER JOIN msdb.dbo.sysmail_account a ON pa.account_id = a.account_id   
			--			WHERE p.name = 'Naffco_Mail'  AND a.name = 'Naffco_Mail_Account') 
			--BEGIN 
			--	EXECUTE msdb.dbo.sysmail_delete_profileaccount_sp @profile_name = @profileName2,@account_name = @account_name2 
			--END  
	
			--IF EXISTS(SELECT * FROM msdb.dbo.sysmail_account WHERE  name = @account_name2) 
			--BEGIN 
			--	EXECUTE msdb.dbo.sysmail_delete_account_sp @account_name = @account_name2 
			--END 
	
			--IF EXISTS(SELECT * FROM msdb.dbo.sysmail_profile WHERE  name = @profileName2)  
			--BEGIN 
			--	EXECUTE msdb.dbo.sysmail_delete_profile_sp @profile_name = @profileName2 
			--END 

			----==end Drop Settings For eSafecNaffco_Mail Profile ==================================================================
				

			----===========================================================================================================
			----== BEGIN Mail Settings eSafecNaffco_Mail 
			----=============================================================================================================
			--IF NOT EXISTS(SELECT * FROM msdb.dbo.sysmail_profile WHERE  name = @profileName2)  
			--BEGIN 
  
			----CREATE Profile [eSafecNaffco_Mail] 
			--EXECUTE msdb.dbo.sysmail_add_profile_sp  @profile_name = @profileName2, @description  = ''; 
  
			--END --IF EXISTS profile 
   
			--IF NOT EXISTS(SELECT * FROM msdb.dbo.sysmail_account WHERE  name = @account_name2) 
			--BEGIN 
			--	--CREATE Account [eSafecNaffco_MailAccount] 
			--	EXECUTE msdb.dbo.sysmail_add_account_sp 
			--			@account_name            = @account_name,
			--			@email_address           = @email_address,
			--			@display_name            = @display_name,         
			--			@replyto_address         = @replyto_address,
			--			@description             = @description,
			--			@mailserver_name         = @mailserver_name,
			--			@mailserver_type         = @mailserver_type,
			--			@port                    = @port,                
			--			@username                = @username,
			--			@password                = @password, 
			--			@use_default_credentials = @use_default_credentials,
			--			@enable_ssl              = @enable_ssl
			--	END --IF EXISTS  account 
   
			--	IF NOT EXISTS(SELECT * FROM msdb.dbo.sysmail_profileaccount pa 
			--							INNER JOIN msdb.dbo.sysmail_profile p ON pa.profile_id = p.profile_id 
			--							INNER JOIN msdb.dbo.sysmail_account a ON pa.account_id = a.account_id   
			--							WHERE p.name = @profileName2 
			--							AND a.name = @account_name2)  
			--	BEGIN 
			--			-- Associate Account [eSafecNaffco_MailAccount] to Profile [eSafecNaffco_Mail] 
			--			EXECUTE msdb.dbo.sysmail_add_profileaccount_sp 
			--				@profile_name = @profileName2, 
			--				@account_name = @account_name2, 
			--				@sequence_number = 1 ; 
			--	END  
		 
		--http://www.sqlservercentral.com/blogs/querying-microsoft-sql-server/2013/09/02/sending-mail-using-sql-server-express-edition/

		--	SELECT *	FROM msdb.dbo.sysmail_account
		--	SELECT *	FROM msdb.dbo.sysmail_configuration
		--	SELECT *	FROM msdb.dbo.sysmail_principalprofile
		--	SELECT *	FROM msdb.dbo.sysmail_profile
		--	SELECT *	FROM msdb.dbo.sysmail_profileaccount
		
		--	exec msdb.dbo.sp_send_dbmail @profile_name = 'Naffco_Mail', 
		--  @recipients = 'rajendra.more999@gmail.com', @subject = 'Mail Test', 
		--  @body = 'Mail Sent Successfully', @body_format = 'HTML'
		--	select top 5 sent_status,* from msdb.[dbo].[sysmail_mailitems] order by send_request_date desc
		
		--- Below link is to generate mail profile script from sql 
		--https://gallery.technet.microsoft.com/scriptcenter/Script-to-Scipt-out-14a19eda

END
Go

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'AddMailLog') AND TYPE IN (N'P'))
DROP PROCEDURE AddMailLog
GO

CREATE PROCEDURE AddMailLog
(
	@p_MailType				VARCHAR(30),
	@p_CreatedDate			DATETIME,
	@p_IsMailFromFrontEnd	BIT,

	@p_FromMailID			VARCHAR(50),
	@p_RecipientMailList	VARCHAR(2000),
	@p_CCMailList			VARCHAR(2000)	= NULL,
	@p_BCCMailList			VARCHAR(2000)	= NULL,
	
	@p_MailSubject			VARCHAR(200),
	@p_Body					VARCHAR(MAX),
	--@p_EmployeeID			VARCHAR(8000)	= NULL,

	@p_MailID				BIGINT OUTPUT
)
WITH ENCRYPTION
AS
BEGIN

	DECLARE @Mailitemid			BIGINT
	DECLARE @ToMail				VARCHAR(50) = ''

	INSERT INTO MailLog
			(	MailType,CreatedDate,IsMailFromFrontEnd,FromMailID,RecipientMailList,CCMailList,BCCMailList,MailSubject,Body	)
		VALUES
			(	@p_MailType, @p_CreatedDate, @p_IsMailFromFrontEnd, @p_FromMailID, @p_RecipientMailList, @p_CCMailList, @p_BCCMailList, @p_MailSubject, @p_Body	);

	SET @p_MailID = SCOPE_IDENTITY();

	IF(@p_MailID > 0)
	BEGIN

		-- Sending Mail function
		EXEC SendDBMail @p_FromMailID, @p_RecipientMailList, @p_CCMailList, @p_BCCMailList, @p_MailSubject, @p_Body, @Mailitemid OUT
						
		UPDATE MailLog SET MailItemID = @Mailitemid WHERE MailID = @p_MailID
		
	END	
END
GO

