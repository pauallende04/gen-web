USE PP_DDBB;
GO

CREATE OR ALTER PROCEDURE sp_user_get_accountdata
    @USERNAME NVARCHAR(25)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ret INT;
    DECLARE @XMLFlag XML;

    SET @ret = -1;

    -- Verificar si hay datos en el historial de conexiones
    IF EXISTS (SELECT 1 FROM USERS WHERE USERNAME=@USERNAME)
    BEGIN
        -- Si hay datos, convertir el conjunto de resultados a XML
        SET @XMLFlag = (
            SELECT USERNAME, NAME, LASTNAME, EMAIL, GENDER FROM USERS WHERE USERNAME = @USERNAME
            FOR XML PATH('User'), ROOT('Users'), TYPE
        );

        SET @ret=0
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

    


exec sp_user_get_accountdata @USERNAME=pauallende04
-- SELECT *
--     FROM USERS
--     WHERE USERNAME = @USERNAME;

--     SELECT * FROM USERS WHERE USERNAME = @USERNAME;