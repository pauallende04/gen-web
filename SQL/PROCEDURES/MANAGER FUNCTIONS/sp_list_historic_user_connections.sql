USE PP_DDBB;
GO

-- Procedimiento para listar el historial de conexiones del usuario
CREATE OR ALTER PROCEDURE sp_list_historic_user_connections
    @USERNAME NVARCHAR(30)
AS
BEGIN
DECLARE @ret INT;
    SET @ret = -1;

    -- Verificar si hay conexiones para el usuario
    IF EXISTS (
        SELECT 1 FROM USER_CONNECTIONS_HISTORY WHERE USERNAME = @USERNAME
    )
    BEGIN
        -- Devolver el historial de conexiones
        SELECT * FROM USER_CONNECTIONS_HISTORY WHERE USERNAME = @USERNAME;
        SET @ret = 0;
    END
    ELSE
    BEGIN
        -- No hay conexiones, devolver una señal de que no hay datos
        RAISERROR('No se encontró historial para el usuario.', 16, 1);
    END
    RETURN @ret;
END;
GO


EXEC sp_list_historic_user_connections
    @USERNAME = 'BlowFlow'