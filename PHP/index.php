<?php 
session_start();

include 'connectDB.php';
include 'DBCommand.php';

$connection = new DBConnection('172.17.0.2,1433', 'PP_DDBB', 'sa', ' Informatica55_'); /*contraseña y algun dato posible cambio*/
$action = isset($_GET['action']) ? $_GET['action'] :'';

if (empty($action)){
    echo "Accion no especificada.";
} else {
    switch ($action){
        case "register": 
            $username = isset($_GET['username']) ? $_GET['username'] :'';
            $name = isset($_GET['name']) ? $_GET['name'] :'';
            $lastname = isset($_GET['lastname']) ? $_GET['lastname'] :'';
            $password = isset($_GET['password']) ? $_GET['password'] :'';
            $email = isset($_GET['email']) ? $_GET['email'] : '';
            
            if (empty($username) || empty($name) || empty($lastname) || empty($password) || empty($email)){
                echo "Todos los campos son obligatorios.";
            } else {
                // Obtener el objeto PDO de la conexión
                $pdoObject = $connection->getPDOObject();

                // Crear un objeto DBCommand
                $dbCommand = new DBCommand($pdoObject);

                // Preparar el procedimiento almacenado
                $dbCommand->prepare("sp_user_register", array($username, $name, $lastname, $password, $email));

                // Ejecutar el procedimiento almacenado
                $result = $dbCommand->execute();

                

                if ($result == 200) {
                    echo "Usuario registrado exitosamente.";
                } elseif ($result == 409) {
                    echo "El nombre de usuario ya está en uso.";
                } elseif ($result == 450) {
                    echo "La contraseña no cumple con los requisitos de seguridad.";
                } else {
                    echo $result;
                }
                // echo "Error desconocido al registrar usuario." ;
            }
            break;
        
            case "login":
                $username = isset($_GET['username']) ? $_GET['username'] : '';
                $password = isset($_GET['password']) ? $_GET['password'] : '';
    
                if (empty($username) || empty($password)) {
                    echo "Nombre de usuario o contraseña vacíos.";
                } else {
                    $pdoObject = $connection->getPDOObject();
                    $dbCommand = new DBCommand($pdoObject);
    
                    $dbCommand->prepare("sp_user_login", array($username, $password));
                    $result = $dbCommand->execute();
    
                    if ($result == 0) { // Éxito
                        $_SESSION['username'] = $username; // Almacena el nombre de usuario en la sesión
                        echo "Inicio de sesión exitoso.";
                    } elseif ($result == 409) {
                        echo "Nombre de usuario no existe.";
                    } elseif ($result == 423) {
                        echo "Contraseña incorrecta o cuenta inactiva/bloqueada.";
                    } elseif ($result == 500) {
                        echo "Usuario ya está conectado. Intentando desconectarlo.";
                    } else {
                        echo "Error desconocido durante el inicio de sesión.";
                    }
                }
                break;
    
            case "logout":
                if (isset($_SESSION['username'])) { // Verifica si hay una sesión activa
                    $username = $_SESSION['username']; // Obtén el nombre de usuario desde la sesión
    
                    $pdoObject = $connection->getPDOObject();
                    $dbCommand = new DBCommand($pdoObject);
    
                    // Ejecuta el procedimiento almacenado para cerrar la conexión
                    $dbCommand->prepare("sp_user_logout", array($username));
                    $result = $dbCommand->execute();
    
                    // Destruir la sesión para cerrar la sesión del usuario
                    session_unset(); // Limpiar todas las variables de sesión
                    session_destroy(); // Destruir la sesión
    
                    if ($result == 0) {
                        echo "Sesión cerrada con éxito.";
                    } elseif ($result == 404) {
                        echo "Usuario no estaba conectado o conexión no encontrada.";
                    } else {
                        echo "Error desconocido durante el cierre de sesión.";
                    }
                } else {
                    echo "No se encontró una sesión activa para cerrar.";
                }
                break;

        case "changepass":
            $username = isset($_GET['username']) ? $_GET['username'] :'';
            $password = isset($_GET['password']) ? $_GET['password'] :'';
            $newpassword = isset($_GET['newpassword']) ? $_GET['newpassword'] :'';

            break;
    }
}
//http://localhost:40080/gen-web/gen-web/PHP/index.php?action=register&username=sample_user&name=John&lastname=Doe&password=Contrase%C3%B1a_123&email=johndoe@example.com
//http://localhost:40080/gen-web/gen-web/PHP/index.php?action=login&username=pol888&password=Contrase%C3%B1a#123
?>
