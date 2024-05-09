USE PP_DDBB;

-- fn_user_exists
go
CREATE OR ALTER FUNCTION fn_user_exists (@USERNAME NVARCHAR(25))
RETURNS BIT
AS
BEGIN
    DECLARE @Exists BIT;
    SET @Exists = (
        SELECT CASE WHEN EXISTS (SELECT 1 FROM USERS WHERE USERNAME = @USERNAME) THEN 1 ELSE 0 END
    );
    RETURN @Exists;
END;
GO

SELECT dbo.fn_user_exists('BlowFlow') AS user_exists;