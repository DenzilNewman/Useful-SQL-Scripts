/*
	Scalar function for detecting if a value is a valid integer.

	Example use:
		SELECT dbo.ISINTEGER('0.5') As StringFail, dbo.ISINTEGER('1') As StringPass, dbo.ISINTEGER(2) As NumericPass
		
*/
CREATE OR ALTER FUNCTION ISINTEGER
(
	@value sql_variant  
)
RETURNS BIT
AS
BEGIN	
	DECLARE @retVAL BIT = 0;
	IF (TRY_CAST(TRY_CAST(@value AS NVARCHAR(MAX)) AS INTEGER) IS NOT NULL)
		SET @retVAL = 1;

		RETURN @retVAL;
END;
GO