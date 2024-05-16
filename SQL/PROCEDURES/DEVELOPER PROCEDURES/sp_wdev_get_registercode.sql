USE PP_DDBB;
GO

CREATE OR ALTER PROCEDURE sp_wdev_get_registercode
    @USERNAME NVARCHAR(25),
    @REGISTER_CODE INT OUTPUT -- Parámetro de salida para el código de registro
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ret INT;
    SET @ret = -1;

    -- Buscar el código de registro para el usuario dado
    SELECT @REGISTER_CODE = REGISTER_CODE
    FROM USERS
    WHERE USERNAME = @USERNAME;

    -- Verificar si se encontró el código de registro
    IF @REGISTER_CODE IS NOT NULL
    BEGIN
        -- Si se encontró, establecer el código de retorno en 0 (éxito)
        SET @ret = 0;
    END
    ELSE
    BEGIN
        -- Si no se encontró, establecer el código de retorno en 404 (no encontrado)
        SET @ret = 404;
    END

    -- Obtener el objeto XML de respuesta para el código de error
    DECLARE @ResponseXML XML;
    EXEC sp_xml_error_message @RETURN = @ret, @XmlResponse = @ResponseXML OUTPUT;

    -- Verificar si se encontró el código de registro
    IF @ret = 0
    BEGIN
        -- Si todo está bien, incluir el código de registro en el XML de respuesta
        SELECT @REGISTER_CODE;
    END

    -- Devolver el objeto XML de respuesta
    -- SELECT @ResponseXML;
END;




-- EXEC sp_get_registercode @USERNAME="pauallende04",@REGISTER_CODE=0