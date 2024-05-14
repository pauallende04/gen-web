USE PP_DDBB;

-- fn_compare_passwords
go
CREATE OR ALTER FUNCTION fn_compare_soundex
(
    @newPassword NVARCHAR(50),
    @userId INT
)
RETURNS INT
AS
BEGIN
    -- Obtener la última contraseña del usuario
    SELECT TOP 3 OLD_PASSWORD
    FROM PWD_HISTORY
    WHERE USER_ID = @userId
    ORDER BY DATE_CHANGED DESC;

     -- Verificar si el Soundex de la nueva contraseña coincide con el de alguna de las últimas tres contraseñas
    IF EXISTS (
        SELECT 1 
        FROM @lastThreePasswords 
        WHERE SOUNDEX(Password) = @newPasswordSoundex
    )
    BEGIN
        RETURN 1; -- La nueva contraseña tiene un Soundex similar al de una de las últimas tres contraseñas
    END
    ELSE
    BEGIN
        RETURN 0; -- La nueva contraseña no tiene un Soundex similar al de ninguna de las últimas tres contraseñas
    END
    RETURN -1;
END;