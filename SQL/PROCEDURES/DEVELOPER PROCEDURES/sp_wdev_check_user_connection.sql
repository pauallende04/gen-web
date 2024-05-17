USE PP_DDBB;
go
CREATE OR ALTER PROCEDURE sp_wdev_check_user_connection
    @USERNAME NVARCHAR(25),
    @USER_ID INT OUTPUT,
    @DATE_CONNECTED DATETIME OUTPUT,
    @ret INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SET @ret = -1;

    -- Comprueba si el usuario está conectado
    IF EXISTS (
        SELECT 1 FROM USER_CONNECTIONS WHERE USERNAME = @USERNAME
    )
    BEGIN
        -- Obtén la información de la conexión
        SELECT 
            @USER_ID = USER_ID, 
            @DATE_CONNECTED = DATE_CONNECTED 
        FROM USER_CONNECTIONS 
        WHERE USERNAME = @USERNAME;

        SET @ret = 100; -- Éxito
    END
    ELSE
    BEGIN
        SET @ret = 405; -- Conexión no encontrada
    END
END
GO
