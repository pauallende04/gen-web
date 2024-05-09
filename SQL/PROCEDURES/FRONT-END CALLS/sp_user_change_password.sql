USE PP_DDBB;
GO

-- sp_user_change_password
CREATE OR ALTER PROCEDURE sp_user_change_password
    @USERNAME NVARCHAR(50), 
    @CURRENT_PASSWORD NVARCHAR(50), 
    @NEW_PASSWORD NVARCHAR(50)

AS
BEGIN
    DECLARE @ret INT;
    DECLARE @USER_ID INT;
    DECLARE @OLD_PASSWORD NVARCHAR(50);

    SET @ret = -1;

    -- Verifica que la contraseña actual sea válida
    IF (dbo.fn_pwd_isvalid(@CURRENT_PASSWORD, @USERNAME) = 0)
    BEGIN
        SET @ret = 423;
        RAISERROR('La contraseña es incorrecta.', 16, 1);
        RETURN;
    END

    -- SET @OLD_PASSWORD= @CURRENT_PASSWORD;

    -- Verifica que la nueva contraseña cumpla con la política
    IF dbo.fn_pwd_checkpolicy(@NEW_PASSWORD) = 0
    BEGIN
        SET @ret = 450;
        RAISERROR('La contraseña debe contener más de 10 caracteres, incluyendo al menos una mayúscula, una minúscula, un número y un carácter especial.', 16, 1);
        RETURN;
    END

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
    PRINT 'Contraseña actualizada y registrada en el historial.';

    RETURN @ret;
END
GO