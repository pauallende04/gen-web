USE PP_DDBB;
GO

CREATE OR ALTER PROCEDURE sp_wdev_user_update_password_info
    @USERNAME NVARCHAR(50),
    @CURRENT_PASSWORD NVARCHAR(50),
    @NEW_PASSWORD NVARCHAR(50),
    @ret INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @USER_ID INT;

    -- Obtener la información del usuario
    SELECT 
        @USER_ID = ID
    FROM USERS 
    WHERE USERNAME = @USERNAME;

    -- Guardar la contraseña anterior en PWD_HISTORY
    INSERT INTO PWD_HISTORY(
        USER_ID,
        USERNAME,
        OLD_PASSWORD, 
        DATE_CHANGED
    ) 
    VALUES (
        @USER_ID,
        @USERNAME, 
        @CURRENT_PASSWORD, 
        GETDATE() -- fecha de cambio de contraseña
    );

    -- Actualizar la contraseña del usuario
    UPDATE USERS 
    SET PASSWORD = @NEW_PASSWORD 
    WHERE USERNAME = @USERNAME;
    
    SET @ret = 0;
END;
GO