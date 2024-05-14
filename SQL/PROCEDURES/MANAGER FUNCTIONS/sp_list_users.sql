USE PP_DDBB;
GO

-- Procedimiento almacenado para listar usuarios
CREATE OR ALTER PROCEDURE sp_list_users
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ret INT;
    SET @ret = -1;

    DECLARE @XMLFlag XML;

    -- Verificar si hay datos en el historial de conexiones
    IF EXISTS (SELECT 1 FROM USERS)
    BEGIN
        -- Si hay datos, convertir el conjunto de resultados a XML
        SET @XMLFlag = (
            SELECT USERNAME FROM USERS
            FOR XML PATH('Usuarios'), ROOT('Usuarios'), TYPE
        );
    END
    ELSE
    BEGIN
        SET @ret = 505; -- Indicar que hubo resultados
    END
    
    IF @ret <> -1
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

EXEC sp_list_users
