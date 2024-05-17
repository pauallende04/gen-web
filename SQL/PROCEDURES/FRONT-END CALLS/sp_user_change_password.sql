USE PP_DDBB;
GO

-- sp_user_change_password
CREATE OR ALTER PROCEDURE sp_user_change_password
    @USERNAME NVARCHAR(50), 
    @CURRENT_PASSWORD NVARCHAR(50), 
    @NEW_PASSWORD NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ret INT;
    SET @ret = -1;

    DECLARE @XMLFlag XML;

    -- Verifica que la contraseña actual sea válida
    IF (dbo.fn_pwd_isvalid(@CURRENT_PASSWORD, @USERNAME) = 0)
    BEGIN
        SET @ret = 502;
        GOTO ExitProc;
    END

    -- Verifica que la nueva contraseña cumpla con la política
    IF dbo.fn_pwd_checkpolicy(@NEW_PASSWORD) = 0
    BEGIN
        SET @ret = 503;
        GOTO ExitProc;
    END

    -- Verificar si la nueva contraseña es igual a alguna de las tres últimas contraseñas
    IF dbo.fn_compare_soundex(@USERNAME, @NEW_PASSWORD) = 0
    BEGIN
        SET @ret = 402;
        GOTO ExitProc;
    END

    -- Verificar si la nueva contraseña es igual a la última contraseña
    IF dbo.fn_compare_passwords(@NEW_PASSWORD, @USERNAME) = 1
    BEGIN
        SET @ret = 402;
        GOTO ExitProc;
    END

    -- Llamar a la procedure para actualizar la información de contraseña del usuario
    EXEC sp_wdev_user_update_password_info @USERNAME, @CURRENT_PASSWORD, @NEW_PASSWORD, @ret OUTPUT;

    ExitProc:
    DECLARE @ResponseXML XML;
    EXEC sp_xml_error_message @RETURN = @ret, @XmlResponse = @ResponseXML OUTPUT;
    SELECT @ResponseXML;
END;
GO
