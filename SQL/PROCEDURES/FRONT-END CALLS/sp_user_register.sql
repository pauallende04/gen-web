USE PP_DDBB;

-- sp_user_register
go
CREATE OR ALTER PROCEDURE sp_user_register
@USERNAME NVARCHAR(25),
@NAME NVARCHAR(25),
@LASTNAME NVARCHAR(50),
@PASSWORD NVARCHAR(50),
@EMAIL NVARCHAR(30)
AS
BEGIN
DECLARE @ret INT;
    SET @ret = -1;
    IF dbo.fn_user_exists(@USERNAME) = 1
    BEGIN
        SET @ret = 409;
        RAISERROR('El nombre de usuario ya está en uso.', 16, 1);
        RETURN;
    END

    --Mail
    IF dbo.fn_mail_exists(@EMAIL) = 1
    BEGIN
        SET @ret = 409;
        RAISERROR('El email ya está en uso.', 16, 1);
        RETURN;
    END

     --Contraseña
    IF dbo.fn_pwd_checkpolicy(@PASSWORD) = -1
    BEGIN
        SET @ret = 450;
        RAISERROR('La contraseña debe contener mas de 10 carácteres, donde deberás usar una mayúscula, una minúscula, un número y un carácter especial', 16, 1);
        RETURN;
    END
    
    EXEC sp_wdev_user_insert @USERNAME, @NAME, @LASTNAME, @PASSWORD, @EMAIL;
    
    IF @@ROWCOUNT > 0
    BEGIN
        PRINT 'Usuario registrado exitosamente.';
        SET @ret = 200;
    END
    ELSE
    BEGIN
        SET @ret = 200;
        RETURN;
    END

    RETURN @ret;
END;

GO
EXEC sp_user_register 
    @USERNAME = 'BlowFlow',
    @NAME = 'Pau',
    @LASTNAME = 'Allende',
    @PASSWORD = 'Contraseña2004',
    @EMAIL = 'BlowFlow@example.com'

SELECT * FROM USERS;

-- DELETE FROM USERS WHERE id=1;
DELETE FROM USERS;
