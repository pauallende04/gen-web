USE PP_DDBB;

-- sp_user_accountvalidate
GO
CREATE OR ALTER PROCEDURE sp_user_accountvalidate
@USERNAME NVARCHAR(25),
@REGISTER_CODE INT
AS 
BEGIN
	DECLARE @ACTUAL_CODE INT;

    select @ACTUAL_CODE = REGISTER_CODE
    FROM USERS
    WHERE ID = @ID

    DECLARE @ret INT;
    SET @ret = -1;
    if (dbo.fn_user_exists(@USERNAME) = 0)
    BEGIN
        SET @ret = 21; -- Código de error 21: Usuario no existe en la base de datos.
        print 'El usuario indicado para activar no existe';
    END
    ELSE IF (dbo.fn_user_exists(@USERNAME) = 1) -- Si existe el usuario, continua con la ejecución de la procedure
    BEGIN
        if (dbo.fn_user_state(@USERNAME) = 1)
        BEGIN
            print 'El usuario ya esta activo.';
            set @ret = 50 -- Código de error 50: Usuario ya activo.
        END
        ELSE IF (dbo.fn_user_state(@USERNAME) = 2)
        BEGIN
            IF @actual_code = @REGISTER_CODE
            BEGIN
                UPDATE users SET state = 2 WHERE USERNAME = @USERNAME;
                print 'Usuario activado. '
                set @ret = 0;
            END
            ELSE
            BEGIN
                print 'Codigo de verificación incorrecto.'
                set @ret = 90;
            END
        END
    END
END
    





-- USE PP_DDBB;

-- -- sp_user_accountvalidate
-- GO
-- CREATE OR ALTER PROCEDURE sp_user_accountvalidate
-- @USERNAME NVARCHAR(25),
-- @PASSWORD NVARCHAR(50)
-- AS 
-- BEGIN
-- 	DECLARE @UserID INT;
--     FROM USERS
--     WHERE USERNAME = @USERNAME AND PASSWORD = 
