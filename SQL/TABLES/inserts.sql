USE PP_DDBB;

--
GO
--STATUS no activo, activo y desactivado
INSERT INTO STATUS VALUES(0,'Pendiente'),(1,'Activo'),(2,'Bloqueado')

-- Insertar datos en la tabla USER_ERRORS
INSERT INTO USER_ERRORS (ERROR_CODE, ERROR_MESSAGE, ERROR_TIMESTAMP)
VALUES
    ('-1', 'Error indefinido', GETDATE()),
    ('0', 'Usuario desconectado y registrado en el historial correctamente.', GETDATE()),
    ('200', '¡El proceso sido un éxito!', GETDATE()),
    ('405', 'La conexión especificada no existe.', GETDATE()),
    ('408', 'El correo electrónico ya está registrado', GETDATE()),
    ('409', 'El usuario ya existe', GETDATE()),
    ('423', 'La cuenta del usuario está inactiva o bloqueada.', GETDATE()),
    ('450', 'El correo electrónico no cumple los requisitos', GETDATE()),
    ('451', 'La contraseña no cumple los requisitos', GETDATE()), 
    ('500', 'El usuario se esta desconectando.', GETDATE()),
    ('501', 'El nombre de usuario no existe.', GETDATE()),
    ('502', 'La contraseña es incorrecta.', GETDATE()),
    ('503', 'La contraseña debe contener más de 10 caracteres, incluyendo al menos una mayúscula, una minúscula, un número y un carácter especial.', GETDATE()),
    ('700', 'El usuario especificado no existe.', GETDATE()),
    ('701', 'La cuenta del usuario ya está activada.', GETDATE()), 
    ('702', 'El código de registro proporcionado no es válido.', GETDATE()), 
    ('703', 'No se pudo actualizar el estado del usuario.', GETDATE());