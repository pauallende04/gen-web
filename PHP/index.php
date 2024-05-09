<?php 

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
        
        case "":
    }
}
?>
