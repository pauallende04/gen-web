USE PP_DDBB;
GO

-- sp_user_login
CREATE OR ALTER PROCEDURE sp_user_login
    @USERNAME NVARCHAR(25),
    @PASSWORD NVARCHAR(50)
AS
BEGIN
    DECLARE @ret INT;
    DECLARE @LOGIN_STATUS BIT;

    SET @ret = -1;

    SELECT @LOGIN_STATUS = LOGIN_STATUS
    FROM USERS
    WHERE USERNAME = @USERNAME;

    IF @LOGIN_STATUS = 1
    BEGIN
        SET @ret = 500; -- Código de error personalizado
        EXEC sp_user_logout 
        RAISERROR('El usuario se esta desconectando.', 10, 1);
        RETURN;
    END
    ELSE
    IF (dbo.fn_user_exists(@USERNAME) = 0)
    BEGIN
        SET @ret = 409;
        -- Usuario no encontrado
        RAISERROR('El nombre de usuario no existe.', 16, 1);
        RETURN;
    END
    ELSE
    BEGIN
        IF (dbo.fn_user_state(@USERNAME) = 0)
        BEGIN
            SET @ret = 423;
            -- Cuenta inactiva o bloqueada
            RAISERROR('La cuenta del usuario está inactiva o bloqueada.', 16, 1);
            RETURN;
        END
        ELSE
        BEGIN
            IF (dbo.fn_pwd_isvalid(@PASSWORD, @USERNAME) = 0)
            BEGIN
                SET @ret = 423;
                -- Contraseña incorrecta
                RAISERROR('La contraseña es incorrecta.', 16, 1);
                RETURN;
            END
            ELSE
            BEGIN
                DECLARE @CONNECTION_ID UNIQUEIDENTIFIER;
                SET @CONNECTION_ID = dbo.fn_generate_ssid();

                INSERT INTO USER_CONNECTIONS
                    (CONNECTION_ID, USER_ID, USERNAME, DATE_CONNECTED)
                VALUES
                    (@CONNECTION_ID, (SELECT ID
                        FROM USERS
                        WHERE USERNAME = @USERNAME),@USERNAME, GETDATE());

                UPDATE USERS SET LOGIN_STATUS = 1 WHERE USERNAME = @USERNAME;

                IF @@ROWCOUNT = 1
                BEGIN
                    SET @ret = 0;
                    -- Éxito
                    PRINT 'Usuario loggeado correctamente. El connection_id es: ' + CONVERT(VARCHAR(50), @CONNECTION_ID);
                END
            END
        END
    END

    RETURN @ret;
END
GO
