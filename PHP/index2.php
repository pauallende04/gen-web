<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Usuarios</title>
</head>
<body>
    <h2>Registro de Usuario</h2>
    <form action="register.php" method="post">
        <input type="text" name="username" placeholder="Nombre de usuario" required>
        <br>
        <input type="text" name="name" placeholder="Nombre" required>
        <br>
        <input type="text" name="lastname" placeholder="Apellido" required>
        <br>
        <input type="password" name="password" placeholder="Contraseña" required>
        <br>
        <input type="email" name="email" placeholder="Correo electrónico" required>
        <br>
        <input type="submit" value="Registrar">
    </form>
</body>
</html>
