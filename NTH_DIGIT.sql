/*
	Scalar function for getting a single digit of a BIGINT.
	Supply the value, and the index to retrieve (right to left).
	For example, the second digit of 654321, is 2.
	
	Example usage:
		SELECT dbo.NTH_DIGIT(12345,2) -- returns 4
*/
CREATE OR ALTER FUNCTION NTH_DIGIT(@value BIGINT, @index INT)
RETURNS TINYINT
AS
BEGIN
	RETURN  (@value / POWER(10, @index-1)) % 10;
END;

GO