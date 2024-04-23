CREATE FUNCTION [dbo].[TRANSLATE] (
    @String NVARCHAR(500),
    @SearchFor NVARCHAR(100),
    @ReplaceBy NVARCHAR(100)
    )
RETURNS NVARCHAR(500)
AS
BEGIN
    DECLARE @charnum AS INT
    DECLARE @strout AS VARCHAR(500)
    DECLARE @strtemp AS VARCHAR(500)
    DECLARE @replaceChar AS VARCHAR(1)
    DECLARE @replaceindex AS INT
    SET @replaceindex = 1
    IF @String IS NULL
        RETURN (NULL)
    IF @SearchFor IS NULL
        AND @ReplaceBy IS NULL
    BEGIN
        SET @SearchFor = 'áâãäæèïéìëíîçÇåñòóôöõàøúüûùýÁÂÃÄÆÈÏÉÌËÍÎÅÑÒÓÔÖÕÀØÚÜÛÙÝ'
        SET @ReplaceBy = 'aaaaeeieieiicCanoooooaouuuuyAAAAAEIEIEIIANOOOOOAOUUUUY'
    END
    ELSE
    BEGIN
        IF @ReplaceBy IS NULL
            RETURN (NULL)
        IF @SearchFor IS NULL
            RETURN (NULL)
    END
    SET @strout = @String
    WHILE @replaceindex <= len(@SearchFor)
    BEGIN
        IF @replaceindex > len(@ReplaceBy)
            SET @replaceChar = ''
        ELSE
            SET @replaceChar = SUBSTRING(@ReplaceBy, @replaceindex, 1)
        SET @strout = replace(@strout COLLATE Latin1_General_BIN, SUBSTRING(@SearchFor, @replaceindex, 1), SUBSTRING(@ReplaceBy, @replaceindex, 1))
        SET @replaceindex += 1
    END
    SET @String = @strout
    SET @strout = ''
    SET @charnum = 1
    WHILE @charnum <= len(@String)
    BEGIN
        SET @strtemp = SUBSTRING(@String, @charnum, 1)
        IF @strtemp COLLATE Latin1_General_BIN LIKE '[^a-zA-Z0-9 ,.-/]'
        BEGIN
            IF @strtemp = CHAR(10)
                SET @strout = @strout + ' '
            ELSE
                SET @strout = @strout + ''
        END
        ELSE
        BEGIN
            SET @strout = @strout + @strtemp
        END
        SET @charnum += 1
    END
    RETURN @strout
END
GO


