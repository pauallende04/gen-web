USE PP_DDBB;

-- sp_user_login
go

CREATE OR ALTER PROCEDURE sp_user_login
@USERNAME INT,
@PASSWORD NVARCHAR(50)
AS
BEGIN
DECLARE @ret INT;
    SET @ret = -1;
    IF (dbo.fn_user_exists(@USERNAME) = 0)
    BEGIN
        SET @ret = 409; -- poner bien el error
        RAISERROR('El nombre de usuario no existe.', 16, 1);
        RETURN;
    END
    ELSE IF (dbo.fn_user_exists(@USERNAME) = 1)
    BEGIN
        if (dbo.fn_user_state(@USERNAME) = 1)
            BEGIN
            if (dbo.fn_pwd_check(@PASSWORD, @USERNAME) = 1)
            BEGIN
            DECLARE @CONNECTION_ID UNIQUEIDENTIFIER;
                SET @CONNECTION_ID = dbo.fn_generate_connect_id;
                INSERT INTO USER_CONNECTIONS(CONNECTION_ID, USER_ID);
                IF @@ROWCOUNT = 1 SET @ret=0
                print 'Usuario loggeado correctamente. El connection_id es: '+CONVERT(VARCHAR(50), @CONNECTION_ID);
            END
            ELSE
            BEGIN
                SET @ret = 423; -- poner bien los errores
                RAISERROR('La contraseña es incorrecta.', 16,  1);
            END
        END
        ELSE
        BEGIN
            SET @ret = 423; -- poner bien los códigos de error
            RAISERROR ('La cuenta del usuario está inactiva o bloqueada.', 16, 1);
        END
    END
RETURN @ret;
END
GO

EXEC sp_user_login
@USERNAME='SA',
@PASSWORD 'ASDA2'



