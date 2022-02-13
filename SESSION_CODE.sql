/*
	Scalar function for getting a unique string to represent the current database function.
	Result is a hexadecimal VARCHAR(15) based on the SESSION_ID, and the LOGIN_TIME of the current session.
	
	Example usage:
		SELECT dbo.SESSION_CODE() AS SessionCode
*/
CREATE OR ALTER FUNCTION SESSION_CODE()
RETURNS VARCHAR(15)
AS
BEGIN
	RETURN (SELECT FORMAT((DATEDIFF_BIG(SECOND, '2020-01-01', login_time)*10000)+@@SPID, 'x2') FROM sys.dm_exec_sessions WHERE session_id = @@SPID);
END;