<?php


include '.php';
include '.php';
include '.php';
include 'connectDB.php';
include 'DBCommand.php';


$connection = new DBConnection("172.17.0.3","PP_DDBB","sa",'02122004Aa'); /*contraseña y algun dato posible cambio*/
$action = isset($_GET['action']) ? $_GET['action'] :'';


$blockchain= new Blockchain($connection);


if (empty($action)){
   echo "Accion no especificada.";
}else{
   switch ($action){
       case"register":
        $from = isset($_GET['from']) ? $_GET['from'] :'';
        $to = isset($_GET['to']) ? $_GET['to'] :'';
        $amount = isset($_GET['amount']) ? $_GET['amount'] :'';
        if (empty($from)||empty($to)|| empty($amount)){
            echo "Faltan datos";
        } else {
            $blockchain->addBlock(new Block([new Transaction($from, $to, $amount)]));
            //$blockchain->printBlockchain();
            echo 'producto añadido';
        }
           break;
       case "login":
            $blockchain->printXML();
               break; 
       case "logout":
            echo "<br>";
            echo "<br> Validating--------------- <br>";
            if ($blockchain->isValid()) {
                echo "Blockchain is valid.\n <br>";
            } else {
                echo "Blockchain is not valid!\n <br>" ;
            }
        
               break;
   }
}


?>

