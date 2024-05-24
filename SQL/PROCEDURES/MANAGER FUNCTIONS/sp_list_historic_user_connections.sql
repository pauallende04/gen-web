USE PP_DDBB;
GO

-- Procedimiento para listar el historial de conexiones del usuario
CREATE OR ALTER PROCEDURE sp_list_historic_user_connections
    @USERNAME NVARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ret INT;
    SET @ret = -1;

    DECLARE @XMLFlag XML;

    --veifica estado usuaio
    if
        -- Verificar si hay conexiones para el usuario
        IF EXISTS (
            SELECT 1 
        )
        BEGIN
            -- Si hay conexiones, convertir el conjunto de resultados a XML
            SET @XMLFlag = (
                SELECT HISTORY_ID,USERNAME,DATE_CONNECTED,DATE_DISCONNECTED FROM USER_CONNECTIONS_HISTORY WHERE USERNAME = @USERNAME
                FOR XML PATH('UserConnection'), ROOT('UsersConnections'), TYPE
            );
            SET @ret = 0; -- Indicar que hubo resultados
        END
        ELSE
        BEGIN
            SET @ret = 507;
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

EXEC sp_list_historic_user_connections @USERNAME = 'PauAllendee';
