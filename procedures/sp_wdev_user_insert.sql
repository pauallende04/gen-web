USE PP_DDBB;

-- sp_wdev_user_insert
go
CREATE OR ALTER PROCEDURE sp_wdev_user_insert
@USERNAME NVARCHAR(25),
@NAME NVARCHAR(25),
@LASTNAME NVARCHAR(50),
@PASSWORD NVARCHAR(50),
@EMAIL NVARCHAR(30)
AS
BEGIN
DECLARE @REGISTER_CODE INT;

    -- Generar código de 5 dígitos aleatorio
    SET @REGISTER_CODE = CAST((RAND() * 90000) + 10000 AS INT);

    -- Insertar datos en la tabla USERS
    INSERT INTO USERS (USERNAME, NAME, LASTNAME, PASSWORD, EMAIL, STATUS, REGISTER_CODE)
    VALUES (@USERNAME, @NAME, @LASTNAME, @PASSWORD, @EMAIL, 0, @REGISTER_CODE);

    -- Devolver el código generado
    RETURN @REGISTER_CODE;

END;

EXEC sp_wdev_user_insert 
    @USERNAME = 'TOR',
    @NAME = 'Pau',
    @LASTNAME = 'Allende',
    @PASSWORD = 'contraseña',
    @EMAIL = 'correoTOR@example.com'

go

SELECT * FROM USERS;