USE PP_DDBB;

--
GO
--STATUS no activo, activo y desactivado
INSERT INTO STATUS VALUES(0,'Pendiente'),(1,'Activo'),(2,'Bloqueado')

-- Insertar datos en la tabla USER_ERRORS
INSERT INTO USER_ERRORS (ERROR_CODE, ERROR_MESSAGE)
VALUES
    ('-1', 'Error indefinido'),
    ('0', '¡El proceso a sido un éxito!'),
    ('100', 'Usuario desconectado y registrado en el historial correctamente.'),
    ('402', 'La nueva contraseña no puede ser igual a la última contraseña.'),
    ('403', 'La nueva contraseña no puede sonar igual a las 3 últimas contraseñas.'),
    ('405', 'La conexión especificada no existe.'),
    ('408', 'El correo electrónico ya está registrado'),
    ('409', 'El usuario ya existe'),
    ('423', 'La cuenta del usuario está inactiva o bloqueada.'),
    ('450', 'El correo electrónico no cumple los requisitos'),
    ('451', 'La contraseña no cumple los requisitos'), 
    ('500', 'El usuario se esta desconectando.'),
    ('501', 'El nombre de usuario no existe.'),
    ('502', 'La contraseña es incorrecta.'),
    ('503', 'La contraseña debe contener más de 10 caracteres, incluyendo al menos una mayúscula, una minúscula, un número y un carácter especial.'),
    ('504', 'No se encontraron conexiones activas.'),
    ('505', 'No se encontró historial de conexiones.'),
    ('506', 'No se encontraron usuarios con estado definido.'),
    ('507', 'No se encontró historial de conexiones para el usuario.'),
    ('508', 'No se encontraron errores.'),
    ('700', 'El usuario especificado no existe.'),
    ('701', 'La cuenta del usuario ya está activada.'), 
    ('702', 'El código de registro proporcionado no es válido.'), 
    ('703', 'No se pudo actualizar el estado del usuario.'),
    ('800', 'No tienes permisos de administrador.');
