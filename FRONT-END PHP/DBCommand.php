<?php
class DBCommand{

    private $pdoObject;
    private $procedure;
    private $obj;
    private $xml;
    public function __construct($pdoObject) {
        $this->obj = $pdoObject;
    }

    public function prepare($procedure, $datos = array()){
        //Creamos una variable que contiene el string de placeholders
        $place = implode(', ', array_fill(0, count($datos), '?'));
        //Creamos una variable que contiene la sentencia
        $sql = "EXEC $procedure $place";
        //Preparamos la sentencia
        $this->procedure = $this->obj->prepare($sql);

        //Recorremos la array de datos
        foreach ($datos as $index => $value){
            //Asignamos los valores a la sentencia
            $this->procedure->bindValue($index + 1, $value, PDO::PARAM_STR);
        }
    }


    public function execute(){
        $this->procedure->execute();
        if ($this->procedure->columnCount()>0){
            return $this->procedure->fetchAll(PDO::FETCH_ASSOC);
        }
        
            
}
}

?>