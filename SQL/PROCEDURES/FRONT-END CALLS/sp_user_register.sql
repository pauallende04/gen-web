USE PP_DDBB;
GO


CREATE OR ALTER PROCEDURE sp_user_register
    @USERNAME NVARCHAR(25),
    @NAME NVARCHAR(25),
    @LASTNAME NVARCHAR(50),
    @PASSWORD NVARCHAR(50),
    @EMAIL NVARCHAR(30)
AS 
BEGIN
    SET NOCOUNT ON;

    DECLARE @ret INT;
    SET @ret = -1;

    -- Verificar si el usuario ya existe
    IF dbo.fn_user_exists(@USERNAME) = 1
    BEGIN
        SET @ret = 409;
        GOTO ExitProc;
    END
    ELSE
    BEGIN
        -- Verificar si el correo electrónico ya está registrado
        IF dbo.fn_mail_exists(@EMAIL) = 1
        BEGIN
            SET @ret = 408;
            GOTO ExitProc;
        END
        ELSE
        BEGIN
            -- Verificar si el correo electrónico es válido
            IF dbo.fn_mail_isvalid(@EMAIL) = 0
            BEGIN
                SET @ret = 450;
                GOTO ExitProc;
            END
            ELSE
            BEGIN
                -- Verificar la política de contraseña
                IF dbo.fn_pwd_checkpolicy(@PASSWORD) = 0
                BEGIN
                    SET @ret = 451;
                    GOTO ExitProc;
                END
                ELSE
                BEGIN
                    -- Insertar el nuevo usuario si todas las validaciones son exitosas
                    EXEC @ret = sp_wdev_user_insert @USERNAME, @NAME, @LASTNAME, @PASSWORD, @EMAIL;

                    IF @@ROWCOUNT > 0
                    BEGIN
                        SET @ret = 0  
                        GOTO ExitProc;
                    END
                    ELSE
                    BEGIN
                        SET @ret = -1  
                        GOTO ExitProc;
                    END  
                END
            END
        END
    END

    ExitProc:
    DECLARE @ResponseXML XML;
    EXEC sp_xml_error_message @RETURN = @ret, @XmlResponse = @ResponseXML OUTPUT;
    SELECT @ResponseXML;
END;
