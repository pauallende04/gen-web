USE PP_DDBB;
GO

CREATE OR ALTER FUNCTION fn_compare_soundex (
    @USERNAME NVARCHAR(25),
    @NEW_PASSWORD NVARCHAR(50)
)
RETURNS BIT
AS
BEGIN
    DECLARE @USER_ID INT;
    DECLARE @RESULT BIT = 1; -- 1 significa que no suena igual a las 3 últimas contraseñas
    
    -- Obtener el ID del usuario
    SELECT @USER_ID = ID
    FROM USERS
    WHERE USERNAME = @USERNAME;

    -- Si el usuario no existe, retornar 1
    IF @USER_ID IS NULL
    BEGIN
        RETURN @RESULT;
    END

    -- Verificar las últimas 3 contraseñas
    IF EXISTS (
        SELECT 1
        FROM (
            SELECT TOP 3 OLD_PASSWORD
            FROM PWD_HISTORY
            WHERE USER_ID = @USER_ID
            ORDER BY DATE_CHANGED DESC
        ) AS LastPasswords
        WHERE SOUNDEX(OLD_PASSWORD) = SOUNDEX(@NEW_PASSWORD)
    )
    BEGIN
        SET @RESULT = 0; -- 0 significa que suena igual a una de las 3 últimas contraseñas
    END

    RETURN @RESULT;
END;
GO
