USE PP_DDBB;
GO

CREATE OR ALTER FUNCTION fn_compare_passwords
(
    @NEW_PASSWORD NVARCHAR(50),
    @USERNAME NVARCHAR(50)
)
RETURNS INT
AS
BEGIN
    DECLARE @pwd NVARCHAR(50);

    IF EXISTS (SELECT 1 FROM USERS WHERE USERNAME = @USERNAME)
    BEGIN
        SELECT @pwd = PASSWORD
        FROM USERS
        WHERE USERNAME = @USERNAME;

        -- Usando CASE para la comparación
        RETURN (
            SELECT CASE
                WHEN @NEW_PASSWORD IS NOT NULL AND @NEW_PASSWORD = @pwd THEN 1
                ELSE 0
            END
        );
    END
    ELSE
    BEGIN
        RETURN 0; -- El usuario no existe, así que asumimos que la contraseña no es igual
    END

    -- Este return es redundante, pero se deja como salvaguarda
    RETURN -1;
END;
GO
