USE PP_DDBB;
GO
CREATE OR ALTER PROCEDURE sp_user_get_accountdata
    @USERNAME NVARCHAR(25)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ret INT;
    DECLARE @XMLFlag XML;

    SET @ret = -1;

    -- Llamar al procedimiento para verificar la existencia de datos
    EXEC sp_wdev_user_check_existence @USERNAME, @ret OUTPUT, @XMLFlag OUTPUT;

    IF @ret <> -1
    BEGIN
        DECLARE @ResponseXML XML;
        EXEC sp_xml_error_message @RETURN = @ret, @XmlResponse = @ResponseXML OUTPUT;
        SELECT @ResponseXML;
    END
    ELSE
        SELECT @XMLFlag;
END;
GO