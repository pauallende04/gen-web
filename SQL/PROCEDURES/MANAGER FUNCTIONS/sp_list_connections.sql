USE PP_DDBB;
GO

CREATE OR ALTER PROCEDURE sp_list_connections
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @XMLFlag XML;

    IF EXISTS (
        SELECT 1 FROM USER_CONNECTIONS -- Verifica la tabla correcta
    )
    BEGIN
        SET @XMLFlag = (
            SELECT * FROM USER_CONNECTIONS
            FOR XML PATH('Connection'), ROOT('Connections'), TYPE
        );
    END
    ELSE
    BEGIN
        UPDATE USERS SET LOGIN_STATUS = 0;
        SET @XMLFlag = (
            SELECT 500 AS 'StatusCode',
                   'No se encontraron conexiones activas.' AS 'Message'
            FOR XML PATH('Error'), ROOT('Errors'), TYPE
        );
    END

    SELECT @XMLFlag;
END;
GO
