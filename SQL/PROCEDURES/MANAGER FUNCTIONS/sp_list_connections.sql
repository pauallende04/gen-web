USE PP_DDBB;
GO

CREATE OR ALTER PROCEDURE sp_list_connections
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ret INT;
    SET @ret = -1;

    DECLARE @XMLFlag XML;

    IF EXISTS (
        SELECT 1 FROM USER_CONNECTIONS -- Verifica la tabla correcta
    )
    BEGIN
        SET @XMLFlag = (
            SELECT * FROM USER_CONNECTIONS
            FOR XML PATH('Connection'), ROOT('Connections'), TYPE
        );
        SET @ret = 0;
    END
    ELSE
    BEGIN
        UPDATE USERS SET LOGIN_STATUS = 0;
        SET @ret = 504;
    END

    IF @ret <> 0
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

exec sp_list_connections