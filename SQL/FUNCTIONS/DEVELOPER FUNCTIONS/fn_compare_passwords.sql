USE PP_DDBB;

-- fn_compare_passwords
go
CREATE OR ALTER FUNCTION fn_compare_passwords
(
    @NEW_PASSWORD NVARCHAR(50),
    @USER_ID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @lastPassword NVARCHAR(50);

    -- Obtener la última contraseña del usuario
    SELECT TOP 1 @lastPassword = OLD_PASSWORD
    FROM PWD_HISTORY
    WHERE USER_ID = @USER_ID
    ORDER BY DATE_CHANGED DESC;

    -- Verificar si la nueva contraseña es igual a la última contraseña
    IF @NEW_PASSWORD <> @lastPassword
    BEGIN
        RETURN 0; -- La nueva contraseña es igual a la última contraseña
    END
    ELSE
    BEGIN
        RETURN 1; -- La nueva contraseña no es igual a la última contraseña
    END
END;
