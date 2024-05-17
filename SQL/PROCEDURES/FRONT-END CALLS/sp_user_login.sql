USE PP_DDBB;
GO

CREATE OR ALTER PROCEDURE sp_user_login
    @USERNAME NVARCHAR(25),
    @PASSWORD NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @XML_RESPONSE XML;
    DECLARE @LOGIN_STATUS BIT;
    DECLARE @ret INT;
    SET @ret = -1;

    -- Verificar si el usuario está actualmente conectado
    EXEC sp_wdev_user_get_login_status @USERNAME, @LOGIN_STATUS OUTPUT, @ret OUTPUT;

    -- Verificar si el usuario existe
    IF (dbo.fn_user_exists(@USERNAME) = 0)
    BEGIN
        SET @ret = 501;
        GOTO ExitProc;
    END
    ELSE
    BEGIN
        -- Verificar el estado del usuario
        IF (dbo.fn_user_state(@USERNAME) = 0)
        BEGIN
            SET @ret = 423;
            GOTO ExitProc;
        END
        ELSE
        BEGIN
            -- Verificar la validez de la contraseña
            IF (dbo.fn_pwd_isvalid(@PASSWORD, @USERNAME) = 0)
            BEGIN
                SET @ret = 502;
                GOTO ExitProc;
            END
            ELSE
            BEGIN
                DECLARE @CONNECTION_ID UNIQUEIDENTIFIER;
                SET @CONNECTION_ID = dbo.fn_generate_ssid();

                -- Crear una nueva conexión para el usuario
                EXEC sp_wdev_user_create_user_connection @USERNAME, @CONNECTION_ID, @ret OUTPUT;
            END
        END
    END

    ExitProc:
    DECLARE @ResponseXML XML;
    EXEC sp_xml_error_message @RETURN = @ret, @XmlResponse = @ResponseXML OUTPUT;
    SELECT @ResponseXML;
END;
GO
