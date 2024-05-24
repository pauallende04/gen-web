<?php

require_once 'DBCommand.php'; 

class UserManager {
    private $dbCommand;

    public function __construct($dbCommand) {
        $this->dbCommand = $dbCommand;
    }

    public function register($username, $name, $lastname, $password, $email) {
        if (empty($username) || empty($name) || empty($lastname) || empty($password) || empty($email)) {
            echo "Todos los campos son obligatorios.";
        } else {
            try {
                $result = $this->dbCommand->execute('sp_user_register', array($username, $name, $lastname, $password, $email));

                $register_code = $this->dbCommand->execute('sp_wdev_get_registercode', array($username, 0));

                // URL del Web App desplegado en Google Apps Script
                //url pau
                // $url = 'https://script.google.com/macros/s/AKfycbzs-WaweIA_cKNVVgqqPmianx7dn4wPI7AflDvM78iUcP8pUoYNh5u5Dg7nBlkofdKu/exec';
                
                //url Pol
                $url = 'https://script.google.com/macros/s/AKfycbyot1qJnOEJk6AWjOFKg9aW2IFoocmMFPXwfRUAzPwFgbnmgBIRWKboFUUwlyKQvVc/exec';
                
                // Parámetros del correo electrónico
                $destinatario = $email;
                $asunto = 'Código de registro.';
                $cuerpo = $name . ', su código de verificación es ' . $register_code;
                $adjunto = null; 
                
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
    }

    public function login($username, $password) {
        if (empty($username) || empty($password)) {
            echo "Todos los campos son obligatorios.";
        } else {
            try {
                $result = $this->dbCommand->execute('sp_user_login', array($username, $password));

                $_SESSION['username'] = $username;

                // Establecer el encabezado para XML
                header('Content-Type: text/xml');

                // Mostrar la respuesta XML
                echo $result;
            } catch (PDOException $e) {
                echo 'Error: ' . $e->getMessage();
            }
        }
    }

    public function logout() {
        try {
            if (isset($_SESSION['username'])) { 
                $username = $_SESSION['username'];
                $result = $this->dbCommand->execute('sp_user_logout', array($username));

                // Establecer el encabezado para XML
                header('Content-Type: text/xml');

                // Mostrar la respuesta XML
                echo $result;
            }
        } catch (PDOException $e) {
            echo 'Error: ' . $e->getMessage();
        }
    }

    public function changePassword($username, $password, $newpassword) {
        if (empty($username) || empty($password)) {
            echo "Todos los campos son obligatorios.";
        } else {
            try {
                $result = $this->dbCommand->execute('sp_user_change_password', array($username, $password, $newpassword));

                // Establecer el encabezado para XML
                header('Content-Type: text/xml');

                // Mostrar la respuesta XML
                echo $result;
            } catch (PDOException $e) {
                echo 'Error: ' . $e->getMessage();
            }
        }
    }

    public function accountValidate($username, $code){
        if (empty($username) || empty($code)){
            echo "Todos los campos son obligatorios.";
        } else {
            try {
                $result = $this->dbCommand->execute('sp_user_accountvalidate', array($username, $code));

                // Establecer el encabezado para XML
                header('Content-Type: text/xml');

                // Mostrar la respuesta XML
                echo $result;
                
            } catch (PDOException $e) {
                echo 'Error: ' . $e->getMessage();
            }
        }
    }

    public function listusers($ssid){
        if (empty($ssid)){
            echo "Todos los campos son obligatorios.";
        } else {
            try {
                $result = $this->dbCommand->execute('sp_list_users2', array($ssid));

                // Establecer el encabezado para XML
                header('Content-Type: text/xml');

                // Mostrar la respuesta XML
                echo $result;
                
            } catch (PDOException $e) {
                echo 'Error: ' . $e->getMessage();
            }
        }
    }
}

?>
