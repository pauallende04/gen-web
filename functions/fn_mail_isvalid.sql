USE PP_DDBB;
GO

-- Agregar la función de validación de correo electrónico
CREATE OR ALTER FUNCTION fn_mail_isvalid (@EMAIL NVARCHAR(30))
RETURNS BIT
AS
BEGIN
    DECLARE @ValidEmail BIT = 0;

    -- Verificar si el correo electrónico contiene '@' y al menos un caracter antes y después (CHATGPT)
    IF (@EMAIL LIKE '%@%[_a-z0-9]%[_a-z0-9]%')
    BEGIN
        -- Verificar si el correo electrónico contiene un punto después de '@' y al menos un caracter después del punto (CHATGPT)
        IF (CHARINDEX('.', REVERSE(LEFT(@EMAIL, CHARINDEX('@', @EMAIL) - 1))) >= 2)
        BEGIN
            SET @ValidEmail = 1;
        END;
    END;

    RETURN @ValidEmail;
END;
GO

-- -- Modificar la función original para utilizar la función de validación
-- CREATE OR ALTER FUNCTION fn_mail_isvalid (@EMAIL NVARCHAR(30))
-- RETURNS BIT
-- AS
-- BEGIN
--     DECLARE @ValidEmail BIT;

--     -- Validar el formato del correo electrónico
--     SET @ValidEmail = dbo.fn_mail_isvalid(@EMAIL);

--     -- Retornar el resultado de la validación
--     RETURN @ValidEmail;
-- END;
-- GO
