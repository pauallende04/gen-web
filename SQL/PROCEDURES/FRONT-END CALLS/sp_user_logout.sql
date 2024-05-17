USE PP_DDBB;
GO

CREATE OR ALTER PROCEDURE sp_user_logout
    @USERNAME NVARCHAR(25) 
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ret INT;
    DECLARE @USER_ID INT;
    DECLARE @DATE_CONNECTED DATETIME;
    DECLARE @DATE_DISCONNECTED DATETIME;

    SET @DATE_DISCONNECTED = GETDATE();

    -- Comprueba si el usuario está conectado
    EXEC sp_wdev_check_user_connection @USERNAME, @USER_ID OUTPUT, @DATE_CONNECTED OUTPUT, @ret OUTPUT;

    IF @ret = 100
    BEGIN
        -- Insertar en USER_CONNECTIONS_HISTORY antes de eliminar
        EXEC sp_wdev_insert_user_connection_history 
            @USER_ID, 
            @USERNAME, 
            @DATE_CONNECTED, 
            @DATE_DISCONNECTED -- fecha de desconexión


        -- Eliminar de USER_CONNECTIONS
        DELETE FROM USER_CONNECTIONS WHERE USERNAME = @USERNAME;

        IF @@ROWCOUNT = 1
        BEGIN
            -- Actualizar estado de conexión en USERS
            EXEC sp_wdev_update_user_login_status_0 @USERNAME;

            SET @ret = 0; -- Éxito
        END
    END

    DECLARE @ResponseXML XML;
    EXEC sp_xml_error_message @RETURN = @ret, @XmlResponse = @ResponseXML OUTPUT;
    SELECT @ResponseXML;
END
GO
