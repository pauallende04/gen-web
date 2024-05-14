USE PP_DDBB;

-- fn_compare_passwords
go
CREATE OR ALTER FUNCTION fn_compare_passwords
(
    @newPassword NVARCHAR(50),
    @userId INT
)
RETURNS INT
AS
BEGIN
    DECLARE @lastPassword NVARCHAR(50);

    -- Obtener la última contraseña del usuario
    SELECT TOP 1 @lastPassword = OLD_PASSWORD
    FROM PWD_HISTORY
    WHERE USER_ID = @userId
    ORDER BY DATE_CHANGED DESC;

    -- Verificar si la nueva contraseña es igual a la última contraseña
    IF @newPassword = @lastPassword
    BEGIN
        RETURN 1; -- La nueva contraseña es igual a la última contraseña
    END
    ELSE
    BEGIN
        RETURN 0; -- La nueva contraseña no es igual a la última contraseña
    END
    RETURN -1;
END;
