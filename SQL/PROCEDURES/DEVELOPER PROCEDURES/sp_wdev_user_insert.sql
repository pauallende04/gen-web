-- USE PP_DDBB;
-- GO

-- CREATE OR ALTER PROCEDURE sp_wdev_user_insert
-- @USERNAME NVARCHAR(25),
-- @NAME NVARCHAR(25),
-- @LASTNAME NVARCHAR(50),
-- @PASSWORD NVARCHAR(50),
-- @EMAIL NVARCHAR(30),
-- @REGISTER_CODE INT OUTPUT -- Agregar un parámetro de salida para el código de registro
-- AS
-- BEGIN
--     -- Insertar datos en la tabla USERS
--     INSERT INTO USERS (USERNAME, NAME, LASTNAME, PASSWORD, EMAIL, STATUS, REGISTER_CODE, LOGIN_STATUS)
--     VALUES (@USERNAME, @NAME, @LASTNAME, @PASSWORD, @EMAIL, 0, @REGISTER_CODE, 0);

--     -- Devolver el código generado
--     SET @REGISTER_CODE = SCOPE_IDENTITY(); -- Suponiendo que REGISTER_CODE es una columna de identidad o se genera automáticamente

--     -- Se puede omitir este RETURN si el procedimiento está configurado para devolver el código a través del parámetro OUTPUT
--     RETURN @REGISTER_CODE;
-- END;


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
    INSERT INTO USERS (USERNAME, NAME, LASTNAME, PASSWORD, EMAIL, STATUS, REGISTER_CODE, LOGIN_STATUS)
    VALUES (@USERNAME, @NAME, @LASTNAME, @PASSWORD, @EMAIL, 0, @REGISTER_CODE, 0);

    -- Devolver el código generado
    RETURN @REGISTER_CODE;

END;