USE PP_DDBB;
GO

-- sp_wdev_deletealldata
CREATE OR ALTER PROCEDURE sp_wdev_deletealldata
    @USERNAME NVARCHAR(25),
    @PASSWORD NVARCHAR(50)


AS
BEGIN
    DECLARE @ret INT;

    SET @ret= -1;

    
END