USE PP_DDBB;
GO

CREATE OR ALTER PROCEDURE sp_list_system_status
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ret INT;
    SET @ret = -1;

    DECLARE @XMLFlag XML;

    -- Verificar si hay usuarios con estado definido
    IF EXISTS (
        SELECT 1 FROM USERS u
        INNER JOIN STATUS s ON u.STATUS = s.STATUS
    )
    BEGIN
        -- Si hay usuarios con estado, convertir el conjunto de resultados a XML
        SET @XMLFlag = (
            SELECT u.ID AS UserID, u.USERNAME, s.STATUS
            FROM USERS u
            INNER JOIN STATUS s ON u.STATUS = s.STATUS
            FOR XML PATH(''), ROOT('SystemStatus'), TYPE
        );
        SET @ret = 0; -- Indicar que hubo resultados
    END
    ELSE
    BEGIN
        -- Si no hay datos, generar un mensaje claro
        DECLARE @ErrorMessage NVARCHAR(100);
        SET @ErrorMessage = 'No se encontraron usuarios con estado definido.';
        SET @XMLFlag = (
            SELECT @ErrorMessage AS ErrorMessage
            FOR XML PATH('Error'), ROOT('SystemStatus'), TYPE
        );
    END

    -- Devolver el resultado XML
    SELECT @XMLFlag;

    RETURN @ret; -- Devolver el valor de retorno
END;
GO

EXEC sp_list_system_status;
