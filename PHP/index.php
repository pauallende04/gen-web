<?php
session_start();

require_once 'connectDB.php';
require_once 'DBCommand.php';
require_once 'mail_sender.php';

$connection = new DBConnection('172.17.0.2,1433', 'PP_DDBB', 'sa', ' Informatica55_');

$action = isset($_GET['action']) ? $_GET['action'] : '';

if (empty($action)){
    echo "Accion no especificada.";
} else {
    switch ($action){
        case "register": 
            $username = isset($_GET['username']) ? $_GET['username'] : '';
            $name = isset($_GET['name']) ? $_GET['name'] : '';
            $lastname = isset($_GET['lastname']) ? $_GET['lastname'] : '';
            $password = isset($_GET['password']) ? $_GET['password'] : '';
            $email = isset($_GET['email']) ? $_GET['email'] : '';
            
            if (empty($username) || empty($name) || empty($lastname) || empty($password) || empty($email)){
                echo "Todos los campos son obligatorios.";
            } else {
                try {
                    $pdoObject = $connection->getPDOObject();
                    $dbCommand = new DBCommand($pdoObject);
                    $result = $dbCommand->execute('sp_user_register', array($username, $name, $lastname, $password, $email));

                    $register_code = $dbCommand->execute('sp_wdev_get_registercode', array($username, 0));

                    // URL del Web App desplegado en Google Apps Script
                    $url = 'https://script.google.com/macros/s/AKfycbzs-WaweIA_cKNVVgqqPmianx7dn4wPI7AflDvM78iUcP8pUoYNh5u5Dg7nBlkofdKu/exec';

                    // Parámetros del correo electrónico
                    $destinatario = $email;
                    $asunto = 'Código de registro.';
                    $cuerpo = $name .', su código de verificación es '. $register_code;
                    $adjunto = null; // Puedes manejar los adjuntos según sea necesario

                    // Llamada a la función para enviar el correo
                    $resultado = enviarCorreo($url, $destinatario, $asunto, $cuerpo, $adjunto);

                    
                    // Establecer el encabezado para XML
                    header('Content-Type: text/xml');

                    // Mostrar la respuesta XML
                    echo $result;
                    
                } catch (PDOException $e) {
                    echo 'Error: ' . $e->getMessage();
                }
            }
            break;
            
            case "login": 
                $username = isset($_GET['username']) ? $_GET['username'] : '';
                $password = isset($_GET['password']) ? $_GET['password'] : '';

                if (empty($username) || empty($password)){
                    echo "Todos los campos son obligatorios.";
                } else {
                    try {
                        $pdoObject = $connection->getPDOObject();
                        $dbCommand = new DBCommand($pdoObject);
                        $result = $dbCommand->execute('sp_user_login', array($username, $password));

                        $_SESSION['username'] = $username;
    
                        // Establecer el encabezado para XML
                        header('Content-Type: text/xml');
    
                        // Mostrar la respuesta XML
                        echo $result;
                        
                    } catch (PDOException $e) {
                        echo 'Error: ' . $e->getMessage();
                    }
                }
                break;

            case "logout": 
                try {
                    if (isset($_SESSION['username'])) { // Verifica si hay una sesión activa
                        $username = $_SESSION['username'];
                        $pdoObject = $connection->getPDOObject();
                        $dbCommand = new DBCommand($pdoObject);
                        $result = $dbCommand->execute('sp_user_logout', array($username));
    
                        // Establecer el encabezado para XML
                        header('Content-Type: text/xml');
    
                        // Mostrar la respuesta XML
                        echo $result;
                    }
                    
                } catch (PDOException $e) {
                    echo 'Error: ' . $e->getMessage();
                }
                break;

            case "changepass": 
                $username = isset($_GET['username']) ? $_GET['username'] : '';
                $password = isset($_GET['password']) ? $_GET['password'] : '';
                $newpassword = isset($_GET['newpassword']) ? $_GET['newpassword'] : '';

                if (empty($username) || empty($password)){
                    echo "Todos los campos son obligatorios.";
                } else {
                    try {
                        $pdoObject = $connection->getPDOObject();
                        $dbCommand = new DBCommand($pdoObject);
                        $result = $dbCommand->execute('sp_user_change_password', array($username, $password, $newpassword));
    
                        // Establecer el encabezado para XML
                        header('Content-Type: text/xml');
    
                        // Mostrar la respuesta XML
                        echo $result;
                        
                    } catch (PDOException $e) {
                        echo 'Error: ' . $e->getMessage();
                    }
                }
                break;

            case "viewcon": 
                try {
                    $pdoObject = $connection->getPDOObject();
                    $dbCommand = new DBCommand($pdoObject);
                    $result = $dbCommand->execute('sp_list_connections');

                    // Establecer el encabezado para XML
                    header('Content-Type: text/xml');

                    // Mostrar la respuesta XML
                    echo $result;
                    
                } catch (PDOException $e) {
                    echo 'Error: ' . $e->getMessage();
                }
                break;

            case "viewconhist": 
                try {
                    $pdoObject = $connection->getPDOObject();
                    $dbCommand = new DBCommand($pdoObject);
                    $result = $dbCommand->execute('sp_list_historic_connections');

                    // Establecer el encabezado para XML
                    header('Content-Type: text/xml');

                    // Mostrar la respuesta XML
                    echo $result;
                    
                } catch (PDOException $e) {
                    echo 'Error: ' . $e->getMessage();
                }
                break;

            case "userlist": 
                try {
                    $pdoObject = $connection->getPDOObject();
                    $dbCommand = new DBCommand($pdoObject);
                    $result = $dbCommand->execute('sp_list_users');

                    // Establecer el encabezado para XML
                    header('Content-Type: text/xml');

                    // Mostrar la respuesta XML
                    echo $result;
                    
                } catch (PDOException $e) {
                    echo 'Error: ' . $e->getMessage();
                }
                break;

            case "accvalidate":
                $username = isset($_GET['username']) ? $_GET['username'] : '';
                $code = isset($_GET['code']) ? $_GET['code'] : '';

                if (empty($username) || empty($code)){
                    echo "Todos los campos son obligatorios.";
                } else {
                    try {
                        $pdoObject = $connection->getPDOObject();
                        $dbCommand = new DBCommand($pdoObject);
                        $result = $dbCommand->execute('sp_user_accountvalidate', array($username, $code));

                        // Establecer el encabezado para XML
                        header('Content-Type: text/xml');

                        // Mostrar la respuesta XML
                        echo $result;
                        
                    } catch (PDOException $e) {
                        echo 'Error: ' . $e->getMessage();
                    }
                }
                break;
        // Resto de los casos
    }
}

// Register:
//localhost:40080/gen-web/gen-web/PHP/index.php?action=register&username=pauallende04&name=Pau&lastname=Allende&password=Test12345!!&email=pauallendeherraiz@gmail.com

// Login: 
//localhost:40080/gen-web/gen-web/PHP/index.php?action=login&username=pauallende04&password=Test12345!!

// Logout: 
//localhost:40080/gen-web/gen-web/PHP/index.php?action=logout

// Change Password: 
//localhost:40080/gen-web/gen-web/PHP/index.php?action=changepass&username=pauallende04&password=Test12345!!&newpassword=NewPassword12345!!

// View Active Connections: 
//localhost:40080/gen-web/gen-web/PHP/index.php?action=viewcon

// View Historical Connections: 
//localhost:40080/gen-web/gen-web/PHP/index.php?action=viewconhist



?>
