/***********Delete User Data *************/
	UPDATE EndUser 
		SET		ActivationURLID = NULL

	DELETE FROM PublishedURL
	DELETE FROM EndUserModule
	DELETE FROM UserRoleUser
	DELETE FROM EndUser

	DBCC CHECKIDENT ('EndUser', RESEED, 0)
/******************************************/

Declare @AdminUserRoleID INT, @EndUserID INT, @LoginID NVARCHAR(50);

SELECT	@AdminUserRoleID	=	UserRoleID
FROM	UserRole
WHERE	UserRoleName	=	'Administrator';

IF (@@ROWCOUNT = 0)
BEGIN
	RAISERROR ('Administrator User Role not found', 16, -1);
	RETURN;
END

SET @LoginID = 'admin'
DECLARE @defaultModule char(2) = 'BS';

INSERT INTO EndUser (LoginID, FirstName, LastName, DefaultModuleCode, LanguageCode, UTCOffset, Gender, EmailID) VALUES(@LoginID,'Admin','User',@defaultModule,'EN',4.5,'Male','admin.user@gmail.com')

SET @EndUserID = SCOPE_IDENTITY();

INSERT INTO UserRoleUser(UserRoleID, EndUserID) VALUES(@AdminUserRoleID, @EndUserID);

INSERT INTO EndUserModule(EndUserID, ModuleCode) VALUES(@EndUserID, @defaultModule);

INSERT INTO PublishedURL(URL,URLUsageType,URLExpiryDTM) VALUES('http://localhost:80/','Activation',(GETDATE()+1));

DECLARE @URLID INT = SCOPE_IDENTITY();
	
UPDATE EndUser 
	SET		ActivationURLID = @URLID
WHERE	EndUserID = @EndUserID

UPDATE EndUser
	SET	UserIdentity = HASHBYTES('MD5',N'admin123'), ---< Default password
		ActivatedDTM = GetDate()
WHERE EndUserID = @EndUserID