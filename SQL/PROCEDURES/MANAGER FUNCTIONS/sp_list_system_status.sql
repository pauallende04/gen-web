USE PP_DDBB;
GO

-- Procedimiento almacenado para listar el estado de cada usuario
CREATE OR ALTER PROCEDURE sp_list_system_status
AS
BEGIN
    SELECT u.ID AS UserID, u.USERNAME, s.STATUS
    FROM USERS u
    INNER JOIN STATUS s ON u.STATUS = s.STATUS;
END;
GO

EXEC sp_list_system_status;
