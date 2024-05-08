USE PP_DDBB;
GO

-- Función para verificar la política de contraseñas
CREATE OR ALTER FUNCTION dbo.fn_pwd_checkpolicy
(
    @PASSWORD NVARCHAR(50)
)
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT;

    -- Verificar longitud mínima
    IF LEN(@PASSWORD) < 10
        SET @IsValid = 0;
    -- Verificar al menos una letra mayúscula
    ELSE IF @PASSWORD COLLATE Latin1_General_BIN <> @PASSWORD AND @PASSWORD COLLATE Latin1_General_CS_AS = @PASSWORD
        SET @IsValid = 0;
    -- Verificar al menos una letra minúscula
    ELSE IF @PASSWORD COLLATE Latin1_General_BIN = @PASSWORD AND @PASSWORD COLLATE Latin1_General_CS_AS <> @PASSWORD
        SET @IsValid = 0;
    -- Verificar al menos un número
    ELSE IF @PASSWORD NOT LIKE '%[0-9]%'
        SET @IsValid = 0;
    -- Verificar al menos un carácter especial
    ELSE IF @PASSWORD NOT LIKE '%[!@#$%^&*()-_=+{};:,<.>]/\?%' ESCAPE '\'
        SET @IsValid = 0;
    ELSE
        SET @IsValid = 1;

    RETURN @IsValid;
END;
GO
