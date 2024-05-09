USE PP_DDBB;
GO

-- Función para verificar la política de contraseñas
CREATE OR ALTER FUNCTION fn_pwd_checkpolicy(@PASSWORD NVARCHAR(100))
RETURNS INT
AS
BEGIN
    DECLARE @errorPass BIT;
    SET @errorPass = 1;

    IF len(@PASSWORD) < 10
    BEGIN
        SET @errorPass = 0;
    END

    -- Verifica la existencia de un número en la contraseña
    ELSE IF PATINDEX('%[0-9]%', @PASSWORD) = 0
    BEGIN
        SET @errorPass = 0;
    END

    -- Verifica la existencia de una letra en la contraseña
    ELSE IF PATINDEX('%[a-zA-Z]%', @PASSWORD) = 0
    BEGIN
        SET @errorPass = 0;
    END
    -- Verifica la existencia de un carácter especial en la contraseña
    ELSE IF PATINDEX('%[^a-zA-Z0-9]%', @PASSWORD) = 0
    BEGIN
        SET @errorPass = 0;
    END

    RETURN @errorPass;
END