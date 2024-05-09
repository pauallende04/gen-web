USE PP_DDBB;
GO

-- Procedimiento almacenado para listar usuarios
CREATE OR ALTER PROCEDURE sp_list_users
AS
BEGIN
DECLARE @ret INT;
    SET @ret = -1;

    IF EXISTS (
        SELECT 1 FROM USER_CONNECTIONS_HISTORY
    )
    BEGIN
        -- Devolver el historial de conexiones
        SELECT ID, USERNAME, NAME, LASTNAME, EMAIL, STATUS FROM USERS;
        SET @ret = 0;
    END
    ELSE
    BEGIN
        -- No hay conexiones, devolver una señal de que no hay datos
        RAISERROR('No se encontró usuarios.', 16, 1);
    END
    RETURN @ret;
END;
GO

EXEC sp_list_users;
