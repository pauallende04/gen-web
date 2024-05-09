USE PP_DDBB;
GO

CREATE OR ALTER PROCEDURE sp_list_system_status
AS
BEGIN
DECLARE @ret INT;
    SET @ret = -1;

    -- Verificar si hay usuarios con estado definido
    IF EXISTS (
        SELECT 1 FROM USERS u
        INNER JOIN STATUS s ON u.STATUS = s.STATUS
    )
    BEGIN
        -- Si hay usuarios con estado, devolver el conjunto de resultados
        SELECT u.ID AS UserID, u.USERNAME, s.STATUS
        FROM USERS u
        INNER JOIN STATUS s ON u.STATUS = s.STATUS;
        SET @ret = 0; -- Indicar que hubo resultados
    END
    ELSE
    BEGIN
        -- Si no hay datos, generar un mensaje informativo
        RAISERROR('No se encontraron usuarios con estado definido.', 10, 1);
        SET @ret = 1; -- Indicar que no hubo resultados
    END

    RETURN @ret; -- Devolver el valor de retorno
END;
GO


EXEC sp_list_system_status;
