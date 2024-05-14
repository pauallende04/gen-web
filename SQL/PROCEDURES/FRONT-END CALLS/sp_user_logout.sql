USE PP_DDBB;
GO

-- sp_user_logout
CREATE OR ALTER PROCEDURE sp_user_logout
    @USERNAME NVARCHAR(25)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ret INT;
    SET @ret = -1;

    DECLARE @USER_ID INT;
    DECLARE @DATE_CONNECTED DATETIME;

    -- Comprueba si el usuario está conectado
    IF EXISTS (
        SELECT 1 FROM USER_CONNECTIONS WHERE USERNAME = @USERNAME
    )
    BEGIN
        -- Obtén la información de la conexión
        SELECT 
            USER_ID, 
            USERNAME, 
            DATE_CONNECTED 
        INTO #TempConnectionInfo
        FROM USER_CONNECTIONS 
        WHERE USERNAME = @USERNAME;

        -- Insertar en USER_CONNECTIONS_HISTORY antes de eliminar
        INSERT INTO USER_CONNECTIONS_HISTORY(
            USER_ID, 
            USERNAME, 
            DATE_CONNECTED, 
            DATE_DISCONNECTED
        )
        SELECT 
            USER_ID, 
            USERNAME, 
            DATE_CONNECTED, 
            GETDATE() -- fecha de desconexión
        FROM #TempConnectionInfo;

        -- Eliminar de USER_CONNECTIONS
        DELETE FROM USER_CONNECTIONS WHERE USERNAME = @USERNAME;

        IF @@ROWCOUNT = 1
        BEGIN
            -- Limpiar la tabla temporal
            DROP TABLE #TempConnectionInfo;

            --establece valor conexion a 0
            UPDATE USERS SET LOGIN_STATUS = 0 WHERE USERNAME = @USERNAME;

            SET @ret = 0;
            GOTO ExitProc;
        END

    END
    ELSE
    BEGIN
        SET @ret = 405;
        GOTO ExitProc;
        -- RAISERROR('La conexión especificada no existe.', 16, 1);
    END

    ExitProc:
    DECLARE @ResponseXML XML;
    EXEC sp_xml_message @RETURN = @ret, @XmlResponse = @ResponseXML OUTPUT;
    SELECT @ResponseXML;
END
GO