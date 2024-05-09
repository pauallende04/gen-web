USE PP_DDBB;
GO

CREATE OR ALTER PROCEDURE sp_user_accountvalidate
    @USERNAME NVARCHAR(25),
    @REGISTER_CODE INT
AS
BEGIN
    DECLARE @UserID INT;
    DECLARE @UserStatus INT;
    DECLARE @UserRegisterCode INT;

    -- Verificar si el usuario existe
    IF NOT EXISTS (SELECT 1 FROM USERS WHERE USERNAME = @USERNAME)
    BEGIN
        -- Usuario no encontrado
        RAISERROR('El usuario especificado no existe.', 16, 1);
        RETURN;
    END

    -- Obtener el ID, estado y register code del usuario
    SELECT @UserID = ID, @UserStatus = STATUS, @UserRegisterCode = REGISTER_CODE
    FROM USERS WHERE USERNAME = @USERNAME;

    -- Verificar si el usuario ya está activo
    IF @UserStatus = 1
    BEGIN
        -- La cuenta ya está activada
        RAISERROR('La cuenta del usuario ya está activada.', 16, 1);
        RETURN;
    END

    -- Verificar si el código de registro coincide
    IF @REGISTER_CODE <> @UserRegisterCode
    BEGIN
        -- Código de registro incorrecto
        RAISERROR('El código de registro proporcionado no es válido.', 16, 1);
        RETURN;
    END

    -- Actualizar el estado del usuario a activo (1)
    UPDATE USERS SET STATUS = 1 WHERE ID = @UserID;

    -- Verificar si se actualizó correctamente
    IF @@ROWCOUNT = 0
    BEGIN
        -- No se actualizó ningún registro, probablemente debido a un problema de concurrencia
        RAISERROR('No se pudo actualizar el estado del usuario.', 16, 1);
        RETURN;
    END

    -- Éxito
    PRINT 'El usuario ' + @USERNAME + ' ha sido activado correctamente.';
END;
GO

EXEC sp_user_accountvalidate
    @USERNAME = 'BlowFlow',
    @REGISTER_CODE = 10133;

SELECT * FROM USERS;