USE PP_DDBB;
GO

-- Función para verificar la contraseña del usuario
CREATE OR ALTER FUNCTION dbo.fn_pwd_isvalid
(
    @PASSWORD NVARCHAR(50),
    @USERNAME NVARCHAR(25)
)
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT;

    -- Verificar si la contraseña proporcionada coincide con la almacenada en la base de datos
    SET @IsValid = (
        SELECT CASE WHEN EXISTS (SELECT 1 FROM USERS WHERE USERNAME = @USERNAME AND PASSWORD = @PASSWORD) THEN 1 ELSE 0 END
    );

    RETURN @IsValid;
END;
GO
