USE PP_DDBB;
GO

CREATE OR ALTER PROCEDURE sp_list_errors
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ret INT;
    SET @ret = -1;

    DECLARE @XMLFlag XML;

    -- Verificar si hay errores
    IF EXISTS (SELECT 1 FROM USER_ERRORS)
    BEGIN
        -- Si hay errores, convertir el conjunto de resultados a XML
        SET @XMLFlag = (
            SELECT * FROM USER_ERRORS
            FOR XML PATH('Errors'), ROOT('Errors'), TYPE
        );
        SET @ret = 0; -- Indicar que hubo resultados
    END
    ELSE
    BEGIN
        -- Si no hay errores, generar un mensaje claro
        DECLARE @ErrorMessage NVARCHAR(100);
        SET @ErrorMessage = 'No se encontraron errores.';
        SET @XMLFlag = (
            SELECT @ErrorMessage AS ErrorMessage
            FOR XML PATH('Error'), ROOT('Errors'), TYPE
        );
    END

    -- Devolver el resultado XML
    SELECT @XMLFlag;

    RETURN @ret; -- Devolver el valor de retorno
END;
GO

EXEC sp_list_errors;
