<?php
// Verifica si se ha enviado el formulario de registro
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Recibe los datos del formulario
    $username = $_POST['username'];
    $name = $_POST['name'];
    $lastname = $_POST['lastname'];
    $password = $_POST['password'];
    $email = $_POST['email'];

    // Realiza la validación de los datos recibidos si es necesario

    // Conecta a la base de datos
    include 'connectDB.php';
    include 'DBCommand.php';
    $connection = new DBConnection("172.17.0.3","PP_DDBB","sa",' Informatica55_');
    $pdoObject = $connection->getPDOObject();

    // Prepara y ejecuta el procedimiento almacenado para registrar al usuario
    $dbCommand = new DBCommand($pdoObject);
    $dbCommand->prepare("sp_user_register", array($username, $name, $lastname, $password, $email));
    $result = $dbCommand->execute();

    // Procesa el resultado del registro
    if ($result == 200) {
        echo "Usuario registrado exitosamente.";
    } elseif ($result == 409) {
        echo "El nombre de usuario ya está en uso.";
    } elseif ($result == 450) {
        echo "La contraseña no cumple con los requisitos de seguridad.";
    } else {
        echo "Error desconocido al registrar usuario.";
    }
}
?>
