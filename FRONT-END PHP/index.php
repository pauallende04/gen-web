<?php


include 'clsBlock.php';
include 'clsBlockchain.php';
include 'clsTransaction.php';
include 'connectDB.php';
include 'clsDBCommand.php';


$connection = new DBConnection("172.17.0.3","prueba1","sa",'02122004Aa');


$action = isset($_GET['action']) ? $_GET['action'] :'';


$blockchain= new Blockchain($connection);


if (empty($action)){
   echo "Accion no especificada.";
}else{
   switch ($action){
       case"add":
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
       case "viewchain":
            $blockchain->printXML();
               break; 
       case "validate":
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

