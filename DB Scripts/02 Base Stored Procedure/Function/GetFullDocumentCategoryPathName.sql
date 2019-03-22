
IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'GetFullDocumentCategoryPathName') AND TYPE IN (N'FN'))
	DROP FUNCTION GetFullDocumentCategoryPathName
GO
-- SELECT DBO.GetFullCategoryPathName(3,'EN')

CREATE FUNCTION GetFullDocumentCategoryPathName
(
	@DocumentCategoryID		INT,
	@LanguageCode			CHAR(2)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN	 
		
		DECLARE	@CategoryName NVARCHAR(500) = ''
		
		SET @CategoryName = (SELECT DocumentCategoryName 
								FROM DocumentCategory dc
								JOIN	DocumentCategoryLanguage dcl
									ON	(	dc.DocumentCategoryID	=	dcl.DocumentCategoryID
										AND dcl.LanguageCode		=	@LanguageCode
										)
								WHERE dc.DocumentCategoryID = @DocumentCategoryID)

		SET @DocumentCategoryID = (SELECT ParentDocumentCategoryID 
									FROM DocumentCategory 
									WHERE DocumentCategoryID = @DocumentCategoryID)


	WHILE (@DocumentCategoryID IS NOT NULL)
	BEGIN
		SET @CategoryName =  @CategoryName + '$' + (	SELECT DocumentCategoryName 
								FROM DocumentCategory dc
								JOIN	DocumentCategoryLanguage dcl
									ON	(	dc.DocumentCategoryID	=	dcl.DocumentCategoryID
										AND dcl.LanguageCode		=	@LanguageCode
										) 
								WHERE dc.DocumentCategoryID = @DocumentCategoryID)  
	
		SET @DocumentCategoryID = (	SELECT ParentDocumentCategoryID 
							FROM DocumentCategory 
							WHERE DocumentCategoryID = @DocumentCategoryID)
	END

	RETURN @CategoryName				-- Return category Hierarchy Name

END
