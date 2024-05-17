USE PP_DDBB;
GO

CREATE OR ALTER PROCEDURE sp_list_system_status
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ret INT;
    SET @ret = -1;

    DECLARE @XMLFlag XML;

    -- Verificar si hay usuarios con estado definido
    IF EXISTS (
        SELECT 1 FROM USERS u
        INNER JOIN STATUS s ON u.STATUS = s.STATUS
    )
    BEGIN
        -- Si hay usuarios con estado, convertir el conjunto de resultados a XML
        SET @XMLFlag = (
            SELECT u.ID AS UserID, u.USERNAME, s.STATUS
            FROM USERS u
            INNER JOIN STATUS s ON u.STATUS = s.STATUS
            FOR XML PATH(''), ROOT('SystemStatus'), TYPE
        );
        SET @ret = 0; -- Indicar que hubo resultados
    END
    ELSE
    BEGIN
        SET @ret = 506;
    END

    IF @ret <> 0
    BEGIN
        ExitProc:
        DECLARE @ResponseXML XML;
        EXEC sp_xml_error_message @RETURN = @ret, @XmlResponse = @ResponseXML OUTPUT;
        SELECT @ResponseXML;
    END
    ELSE
        SELECT @XMLFlag;
END;
GO

exec sp_list_system_status