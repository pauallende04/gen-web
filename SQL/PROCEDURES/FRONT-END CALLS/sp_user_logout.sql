USE PP_DDBB;
GO

-- sp_user_logout
CREATE OR ALTER PROCEDURE sp_user_logout
    @CONNECTION_ID UNIQUEIDENTIFIER
AS
BEGIN
    DECLARE @ret INT;
    SET @ret = -1;

    DECLARE @USER_ID INT;
    DECLARE @USERNAME NVARCHAR(30);
    DECLARE @DATE_CONNECTED DATETIME;

    -- Comprueba si el connection_id existe en USER_CONNECTIONS
    IF EXISTS (
        SELECT 1 FROM USER_CONNECTIONS WHERE CONNECTION_ID = @CONNECTION_ID
    )
    BEGIN
        -- Obtén la información de la conexión
        SELECT 
            USER_ID, 
            USERNAME, 
            DATE_CONNECTED 
        INTO #TempConnectionInfo
        FROM USER_CONNECTIONS 
        WHERE CONNECTION_ID = @CONNECTION_ID;

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
        DELETE FROM USER_CONNECTIONS WHERE CONNECTION_ID = @CONNECTION_ID;

        IF @@ROWCOUNT = 1
        BEGIN
            SET @ret = 0;
            PRINT 'Usuario desconectado y registrado en el historial correctamente.';
        END

        -- Limpiar la tabla temporal
        DROP TABLE #TempConnectionInfo;
    END
    ELSE
    BEGIN
        SET @ret = 404;
        RAISERROR('La conexión especificada no existe.', 16, 1);
    END

    RETURN @ret;
END
GO

