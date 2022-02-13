/*
	Table function for obtaining a resultset of database objects, from a string list.

	Example use:
		SELECT * FROM DATABASE_OBJECT('"addressdata", dbo.customer') WHERE type = 'U';
*/
SET NOCOUNT ON;
GO
CREATE OR ALTER FUNCTION DATABASE_OBJECT( @EntityList NVARCHAR(MAX) )
    RETURNS @result TABLE (
		schema_name sysname,
		object_name sysname,
		object_ref nvarchar(260),
		object_id int,
		type char(2),
		type_desc nvarchar(60)
    )
AS
BEGIN
	DECLARE @NameList TABLE (EntityName NVARCHAR(MAX));
	DECLARE @i INT, @elLen INT = LEN(@EntityList);
	DECLARE @qLevel INT, @curChar NVARCHAR(1);
	DECLARE @curEntity NVARCHAR(MAX);


	SET @i = 0;
	SET @qLevel = 0;
	WHILE (@i < LEN(@EntityList))
	BEGIN
		SET @i = @i + 1;
		SET @curChar = SUBSTRING(@EntityList, @i, 1);

		IF ((@qLevel = 0) AND (@curChar IN (',', ';', ' ', '	', CHAR(13), CHAR(10))))
		BEGIN
			SET @curEntity = SUBSTRING(@EntityList, 1, @i-1);
			SET @EntityList = SUBSTRING(@EntityList, @i+1, LEN(@EntityList));
			SET @i = 0;
			IF (@curEntity<>'')
			BEGIN
				INSERT INTO @NameList(EntityName) VALUES (@curEntity);
			END;
		END
		ELSE IF (@curChar IN ('"') AND @qLevel IN (0,-1))
		BEGIN
			SET @qLevel = IIF(@qLevel = 0, -1, 0)
		END
		ELSE IF (@curChar = '[' AND @qLevel >= 0)
		BEGIN
			SET @qLevel = @qLevel + 1;
		END
		ELSE IF (@curChar = ']' AND @qLevel > 0)
		BEGIN
			SET @qLevel = @qLevel - 1;
		END;
	END;
	INSERT INTO @NameList(EntityName) VALUES (@EntityList);

	INSERT INTO @result (
		schema_name, object_name, object_ref, object_id, type, type_desc
	)
	SELECT DISTINCT
		OBJECT_SCHEMA_NAME(o.object_id) AS schema_name,
		ISNULL(o.name, NL.EntityName) AS object_name,
		QUOTENAME(OBJECT_SCHEMA_NAME(o.object_id))+'.'+QUOTENAME(o.name),
		o.object_id,
		o.type,
		o.type_desc
	FROM	
		@NameList AS NL
		JOIN sys.all_objects AS o
			ON o.object_id = OBJECT_ID(NL.EntityName)
	ORDER BY
		schema_name, object_name;

	RETURN;
END;

GO