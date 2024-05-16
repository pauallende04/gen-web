<?php

session_start();

require_once 'connectDB.php';
require_once 'DBCommand.php';
require_once 'mail_sender.php';
require_once 'UserManager.php';
require_once 'DBManager.php';

// Crear una instancia de DBCommand
$connection = new DBConnection('172.17.0.2,1433', 'PP_DDBB', 'sa', ' Informatica55_');

$pdoObject = $connection->getPDOObject();

// Crear una instancia de DBCommand pasando el objeto PDO
$dbCommand = new DBCommand($pdoObject);

// $dbCommand = new DBCommand($pdoObject);

// Crear instancias de los gestores de usuario y base de datos
$userManager = new UserManager($dbCommand);
$dbManager = new DBManager($dbCommand);

$action = isset($_GET['action']) ? $_GET['action'] : '';

if (empty($action)) {
    echo "Accion no especificada.";
} else {
    switch ($action) {
        case "register":
            // Llama a la función de registro en UserManager
            // Utiliza $_GET['username'], $_GET['name'], etc. para obtener los datos del usuario
            $userManager->register($_GET['username'], $_GET['name'], $_GET['lastname'], $_GET['password'], $_GET['email']);
            break;
        case "login":
            // Llama a la función de inicio de sesión en UserManager
            // Utiliza $_GET['username'] y $_GET['password'] para obtener los datos de inicio de sesión
            $userManager->login($_GET['username'], $_GET['password']);
            break;
        case "logout":
            // Llama a la función de cierre de sesión en UserManager
            // No necesitas pasar ningún parámetro aquí
            $userManager->logout();
            break;
        case "changepass":
            // Llama a la función de cambio de contraseña en UserManager
            // Utiliza $_GET['username'], $_GET['password'], $_GET['newpassword'] para obtener los datos necesarios
            $userManager->changePassword($_GET['username'], $_GET['password'], $_GET['newpassword']);
            break;
        case "viewcon":
            // Llama a la función para ver conexiones en DBManager
            // No necesitas pasar ningún parámetro aquí
            $dbManager->viewConnections();
            break;
        case "viewconhist":
            // Llama a la función para ver conexiones históricas en DBManager
            // No necesitas pasar ningún parámetro aquí
            $dbManager->viewHistoricConnections();
            break;
        case "accvalidate":
            $userManager->accountValidate($_GET['username'],$_GET['code']);

            break;

        default:
            echo "Acción no válida.";
            break;
    }
}


// / URL del Web App desplegado en Google Apps Script
// $url = 'https://script.google.com/macros/s/AKfycbzs-WaweIA_cKNVVgqqPmianx7dn4wPI7AflDvM78iUcP8pUoYNh5u5Dg7nBlkofdKu/exec';

// // Parámetros del correo electrónico
// $destinatario = 'pauallendeherraiz@gmail.com';
// $asunto = 'Asunto del correo';
// $cuerpo = 'Cuerpo del correo';
// $adjunto = null; // Puedes manejar los adjuntos según sea necesario

// // Llamada a la función para enviar el correo
// $resultado = enviarCorreo($url, $destinatario, $asunto, $cuerpo, $adjunto);

// if ($resultado) {
//     echo 'Correo enviado con éxito';
// } else {
//     echo 'Error al enviar el correo';
// }
// ?
?>