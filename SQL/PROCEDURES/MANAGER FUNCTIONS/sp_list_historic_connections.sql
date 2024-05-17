USE PP_DDBB;
GO

CREATE OR ALTER PROCEDURE sp_list_historic_connections
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ret INT;
    SET @ret = -1;

    DECLARE @XMLFlag XML;

    -- Verificar si hay datos en el historial de conexiones
    IF EXISTS (SELECT 1 FROM USER_CONNECTIONS_HISTORY)
    BEGIN
        -- Si hay datos, convertir el conjunto de resultados a XML
        SET @XMLFlag = (
            SELECT HISTORY_ID,USERNAME,DATE_CONNECTED,DATE_DISCONNECTED FROM USER_CONNECTIONS_HISTORY
            FOR XML PATH('HistoricConnections'), ROOT('HistoricConnections'), TYPE
        );
        SET @ret = 0; -- Indicar que hubo resultados
    END
    ELSE
    BEGIN
        SET @ret = 505; -- Indicar que hubo resultados
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

exec sp_list_historic_connections

