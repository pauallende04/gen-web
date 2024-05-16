USE PP_DDBB;
GO

CREATE OR ALTER PROCEDURE sp_user_accountvalidate
    @USERNAME NVARCHAR(25),
    @REGISTER_CODE INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ret INT = -1;
    DECLARE @UserID INT;
    DECLARE @UserStatus INT;
    DECLARE @UserRegisterCode INT;

    -- Verificar si el usuario existe
    IF dbo.fn_user_exists(@USERNAME) = 0
    BEGIN
        SET @ret = 501;
        GOTO ExitProc;
    END;

    -- Obtener el ID, estado y register code del usuario
    SELECT @UserID = ID, @UserStatus = STATUS, @UserRegisterCode = REGISTER_CODE
    FROM USERS
    WHERE USERNAME = @USERNAME;

    -- Verificar si el usuario ya está activo
    IF @UserStatus = 1
    BEGIN
        SET @ret = 701;
        GOTO ExitProc;
    END;

    -- Verificar si el código de registro coincide
    IF @REGISTER_CODE <> @UserRegisterCode
    BEGIN
        SET @ret = 702;
        GOTO ExitProc;
    END;

    -- Actualizar el estado del usuario a activo (1)
    UPDATE USERS SET STATUS = 1 WHERE ID = @UserID;

    -- Verificar si se actualizó correctamente
    IF @@ROWCOUNT = 0
    BEGIN
        SET @ret = 703;
        GOTO ExitProc;
    END
    ELSE
    BEGIN
        SET @ret = 0;
        GOTO ExitProc;
    END;

ExitProc:
    DECLARE @ResponseXML XML;
    EXEC sp_xml_error_message @RETURN = @ret, @XmlResponse = @ResponseXML OUTPUT;
    SELECT @ResponseXML;
END;
GO
