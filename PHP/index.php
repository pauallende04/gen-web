<?php

session_start();

require_once 'connectDB.php';
require_once 'DBCommand.php';
require_once 'mail_sender.php';
require_once 'UserManager.php';
require_once 'DBManager.php';

// Crear una instancia de DBCommand
$connection = new DBConnection('172.17.0.3,1433', 'PP_DDBB', 'sa', ' Informatica55_');

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
            $userManager->register($_GET['username'], $_GET['name'], $_GET['lastname'], $_GET['password'], $_GET['email']);
            break;
        case "login":
            $userManager->login($_GET['username'], $_GET['password']);
            break;
        case "logout":
            $userManager->logout();
            break;
        case "changepass":
            $userManager->changePassword($_GET['username'], $_GET['password'], $_GET['newpassword']);
            break;
        case "viewcon":
            $dbManager->viewConnections();
            break;
        case "viewconhist":
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