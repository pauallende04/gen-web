USE PP_DDBB;

--
GO
--STATUS no activo, activo y desactivado
INSERT INTO STATUS VALUES(0,'Pendiente'),(1,'Activo'),(2,'Bloqueado')

-- Insertar datos en la tabla USER_ERRORS
INSERT INTO USER_ERRORS (ERROR_CODE, ERROR_MESSAGE, ERROR_TIMESTAMP)
VALUES
    ('-1', 'Error indefinido', GETDATE()), 
    ('450', 'No cumple los requisitos', GETDATE());
