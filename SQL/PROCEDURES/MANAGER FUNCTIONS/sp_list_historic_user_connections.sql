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

    -- Verificar si hay conexiones para el usuario
    IF EXISTS (
        SELECT 1 
    )
    BEGIN
        -- Si hay conexiones, convertir el conjunto de resultados a XML
        SET @XMLFlag = (
            SELECT HISTORY_ID,USERNAME,DATE_CONNECTED,DATE_DISCONNECTED FROM USER_CONNECTIONS_HISTORY WHERE USERNAME = @USERNAME
            FOR XML PATH('UsersConnection'), ROOT('UserConnections'), TYPE
        );
        SET @ret = 0; -- Indicar que hubo resultados
    END
    ELSE
    BEGIN
        -- Si no hay conexiones, generar un mensaje claro
        DECLARE @ErrorMessage NVARCHAR(100);
        SET @ErrorMessage = 'No se encontró historial para el usuario.';
        SET @XMLFlag = (
            SELECT @ErrorMessage AS ErrorMessage
            FOR XML PATH('Error'), ROOT('UserConnections'), TYPE
        );
    END

    -- Devolver el resultado XML
    SELECT @XMLFlag;

    RETURN @ret; -- Devolver el valor de retorno
END;
GO

EXEC sp_list_historic_user_connections @USERNAME = 'pauallende04';
