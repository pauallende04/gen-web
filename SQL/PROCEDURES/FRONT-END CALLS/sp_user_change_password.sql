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

    DECLARE @USER_ID INT;

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

    -- -- Verificar si la nueva contraseña es igual a alguna de las tres últimas contraseñas
    -- IF dbo.fn_compare_soundex(@NEW_PASSWORD, @USER_ID) = 1
    -- BEGIN
    --     SET @XMLFlag = (
    --         SELECT 402 AS 'StatusCode',
    --             'La nueva contraseña no puede ser igual a una de las tres últimas contraseñas.' AS 'Message'
    --         FOR XML PATH('Error'), ROOT('Errors'), TYPE
    --     );
    --     SELECT @XMLFlag;
    --     RETURN;
    -- END

    -- -- Verificar si la nueva contraseña es igual a la última contraseña
    -- IF dbo.fn_compare_passwords(@NEW_PASSWORD, @USER_ID) = 1
    -- BEGIN
    --     SET @XMLFlag = (
    --         SELECT 402 AS 'StatusCode',
    --             'La nueva contraseña no puede ser igual a la última contraseña.' AS 'Message'
    --         FOR XML PATH('Error'), ROOT('Errors'), TYPE
    --     );
    --     SELECT @XMLFlag;
    --     RETURN;
    -- END


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
    
    SET @ret = 200;

    ExitProc:
    DECLARE @ResponseXML XML;
    EXEC sp_xml_message @RETURN = @ret, @XmlResponse = @ResponseXML OUTPUT;
    SELECT @ResponseXML;

END
GO
