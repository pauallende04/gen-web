USE PP_DDBB;
GO

CREATE OR ALTER PROCEDURE sp_list_connections
AS
BEGIN
    DECLARE @ret INT;
    SET @ret = -1;

    IF EXISTS (
        SELECT 1 FROM USER_CONNECTIONS -- Verifica la tabla correcta
    )
    BEGIN
        -- Devolver el historial de conexiones activas
        SELECT * FROM USER_CONNECTIONS;        
        SET @ret = 0;
    END
    ELSE
    BEGIN
        -- No hay conexiones activas
        RAISERROR('No se encontraron conexiones activas.', 16, 1);
    END

    RETURN @ret;
END;
GO


EXEC sp_list_connections;