USE PP_DDBB;
GO

CREATE OR ALTER PROCEDURE sp_wdev_user_check_existence
    @USERNAME NVARCHAR(25),
    @ret INT OUTPUT,
    @XMLFlag XML OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
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
END;
GO