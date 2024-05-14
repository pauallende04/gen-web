USE PP_DDBB;
GO

CREATE OR ALTER PROCEDURE sp_xml_error_message
    @RETURN INT,
    @XmlResponse XML OUTPUT
AS
BEGIN
    DECLARE @ERROR_CODE INT;
    SET @ERROR_CODE = @RETURN;

    DECLARE @ERROR_MESSAGE NVARCHAR(200);

    IF @ERROR_CODE = 0
    BEGIN
        -- Cuando @ERROR_CODE no es 200, se recupera el mensaje de error correspondiente
        SELECT @ERROR_MESSAGE = ERROR_MESSAGE FROM USER_ERRORS WHERE ERROR_CODE = @ERROR_CODE;
        
        SET @XmlResponse = (
            SELECT @ERROR_CODE AS 'StatusCode',
                @ERROR_MESSAGE AS 'Message'
            FOR XML PATH('Success'), ROOT('Successes'), TYPE
        );
    END
    ELSE
    BEGIN
        -- Cuando @ERROR_CODE no es 200, se recupera el mensaje de error correspondiente
        SELECT @ERROR_MESSAGE = ERROR_MESSAGE FROM USER_ERRORS WHERE ERROR_CODE = @ERROR_CODE;
        
        SET @XmlResponse = (
            SELECT @ERROR_CODE AS 'StatusCode',
                @ERROR_MESSAGE AS 'Message'
            FOR XML PATH('Error'), ROOT('Errors'), TYPE
        );
    END

END
