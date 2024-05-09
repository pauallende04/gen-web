USE PP_DDBB;
GO

CREATE OR ALTER PROCEDURE sp_list_historic_connections
AS
BEGIN
DECLARE @ret INT;
    SET @ret = -1;

    -- Verificar si hay datos en el historial de conexiones
    IF EXISTS (SELECT 1 FROM USER_CONNECTIONS_HISTORY)
    BEGIN
        -- Si hay datos, devolver el conjunto de resultados
        SELECT * FROM USER_CONNECTIONS_HISTORY;
        SET @ret = 0; -- Indicar que hubo resultados
    END
    ELSE
    BEGIN
        -- Si no hay datos, generar un mensaje claro
        RAISERROR('No se encontró historial de conexiones.', 10, 1); -- Mensaje informativo
    END

    RETURN @ret; -- Devolver el valor de retorno
END;
GO

EXEC sp_list_historic_connections;
