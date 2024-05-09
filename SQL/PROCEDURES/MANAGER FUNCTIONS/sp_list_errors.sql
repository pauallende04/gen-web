USE PP_DDBB;
GO

CREATE OR ALTER PROCEDURE sp_list_errors
AS
BEGIN
DECLARE @ret INT;
    SET @ret = -1;

    -- Verificar si hay errores
    IF EXISTS (SELECT 1 FROM USER_ERRORS)
    BEGIN
        -- Si hay errores, devolver el conjunto de resultados
        SELECT * FROM USER_ERRORS;
        SET @ret = 0; -- Indicar que hubo resultados
    END
    ELSE
    BEGIN
        -- Si no hay errores, generar un mensaje claro
        RAISERROR('No se encontraron errores.', 10, 1); -- El nivel 10 es para mensajes informativos
    END

    RETURN @ret; -- Devolver el valor de retorno
END;
GO


EXEC sp_list_errors;
