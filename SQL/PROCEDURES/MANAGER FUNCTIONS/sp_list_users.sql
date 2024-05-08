USE PP_DDBB;
GO

-- Procedimiento almacenado para listar usuarios
CREATE OR ALTER PROCEDURE sp_list_users
AS
BEGIN
    SELECT ID, USERNAME, NAME, LASTNAME, EMAIL, STATUS
    FROM USERS;
END;
GO

EXEC sp_list_users;
