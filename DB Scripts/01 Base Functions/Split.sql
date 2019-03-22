
IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'Split') AND TYPE IN (N'TF'))
	DROP FUNCTION Split
GO

CREATE function dbo.Split(@String varchar(8000), @Delimiter char(1))
returns @temptable TABLE (items varchar(8000))     
as     
begin     
 declare @idx int     
 declare @slice varchar(8000)     
    
 select @idx = 1     
  if len(@String)<1 or @String is null  return     
    
 while @idx!= 0     
 begin     
  set @idx = charindex(@Delimiter,@String)     
  if @idx!=0     
   set @slice = left(@String,@idx - 1)     
  else     
   set @slice = @String     
  
  if(len(@slice)>0)
   insert into @temptable(Items) values(@slice)     

  set @String = right(@String,len(@String) - @idx)     
  if len(@String) = 0 break     
 end 
return     
end
GO

IF  EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'CapitalizeFirstLetter') )
	DROP FUNCTION CapitalizeFirstLetter
GO

CREATE FUNCTION CapitalizeFirstLetter
(
	--string need to format
	@string VARCHAR(200)--increase the variable size depending on your needs.
)
RETURNS VARCHAR(200)
AS
BEGIN
	--Declare Variables
	DECLARE @Index INT,
	@ResultString VARCHAR(200)--result string size should equal to the @string variable size
	--Initialize the variables
	SET @Index = 1
	SET @ResultString = ''
	--Run the Loop until END of the string

	WHILE (@Index <LEN(@string)+1)
	BEGIN
	IF (@Index = 1)--first letter of the string
	BEGIN
	--make the first letter capital
	SET @ResultString =
	@ResultString + UPPER(SUBSTRING(@string, @Index, 1))
	SET @Index = @Index+ 1--increase the index
	END

	-- IF the previous character is space or '-' or next character is '-'

	ELSE IF ((SUBSTRING(@string, @Index-1, 1) =' 'or SUBSTRING(@string, @Index-1, 1) ='-' or SUBSTRING(@string, @Index+1, 1) ='-') and @Index+1 <> LEN(@string))
	BEGIN
	--make the letter capital
	SET
	@ResultString = @ResultString + UPPER(SUBSTRING(@string,@Index, 1))
	SET
	@Index = @Index +1--increase the index
	END
	ELSE-- all others
	BEGIN
	-- make the letter simple
	SET
	@ResultString = @ResultString + LOWER(SUBSTRING(@string,@Index, 1))
	SET
	@Index = @Index +1--incerase the index
	END
	END--END of the loop

	IF (@@ERROR
	<> 0)-- any error occur return the sEND string
	BEGIN
	SET
	@ResultString = @string
	END
	-- IF no error found return the new string
	RETURN @ResultString
END

----update employee
----set FirstName = dbo.CapitalizeFirstLetter(FirstName),
---- MiddleName = (case when dbo.CapitalizeFirstLetter(MiddleName) = '' then null  else dbo.CapitalizeFirstLetter(MiddleName) end),
----LastName= dbo.CapitalizeFirstLetter(LastName) 
 