USE PP_DDBB;

-- fn_user_state
go
CREATE OR ALTER FUNCTION fn_user_state (@STATUS NVARCHAR(25))
RETURNS BIT
AS
BEGIN
    DECLARE @Exists BIT;
    SET @Exists = (
        SELECT CASE WHEN EXISTS (SELECT 1 FROM USERS WHERE STATUS = @STATUS) THEN 1 ELSE 0 END
    );
    RETURN @Exists;
END;
GO
