<?php

class Blockchain{

    public $blocks=array();
    public $hashA=0;

    public $conexion;

    public function __construct($conexion){
        $this->conexion=$conexion;
        $almacenar=$this->consulta('selectBlock');
        if (count($almacenar)>0){
            foreach ($almacenar as $guardar){
                $almacenarTR=$this->consulta('selectTransaction', [$guardar['id_trans']]);
                $almacenarTR=$almacenarTR[0];
                $block = new Block ([new Transaction($almacenarTR['emisor'], $almacenarTR['receptor'], $almacenarTR['amount'])]);
                $block->index = $guardar['id'];
                $block->date = $guardar['fecha'];
                $block->hash = $guardar['hash'];
                $block->Lasthash = $guardar['hashanterior'];
                $this->blocks[]=$block;
                $this->hashA = $guardar['hash'];
            }
    }}

    public function BlockInicial(){
        $block=new Block (0, date("Y-m-d"), [new Transaction ('Aure', 'Mario', 1)]);
        $block->Hash($this->hashA);
        $block->guardar();
        $this->hashA = $block->Hash($this->hashA);
        return $block;
    }

    public function BlockUltimo() {
        return end($this->blocks);
    }

    public function addBlock2($NuevoBloque){ //Agregamos los del XML
        $NuevoBloque->Hash($this->hashA);
        $this->hashA=$NuevoBloque->Hash($this->hashA);
        array_push($this->blocks, $NuevoBloque);
    }

    public function addBlock($NuevoBloque){ //Agregamos por primera vez
        $NuevoBloque->Hash($this->hashA);
        array_push($this->blocks, $NuevoBloque);
        $NuevoBloque->guardar($this->conexion);
    }

    public function printBlockchain() {
        foreach ($this->blocks as $block){
            echo "Block:" . $block->index . "<br>";
            echo "Timestap: " . $block->date . "<br>";
            echo "Previous Hash: " . $block->Lasthash . "<br>";
            echo "Hash: " . $block->hash . "<br>";
            $trans=$block->transaction[0];
            echo "Transaction: " . "{From: " . $trans->origen . " To: " . $trans->destino . " amount: " . $trans->cantidad . "}" . "<br>";
            echo "----------------------------------". "<br>";
        }
    }
 

    public function isValid() {
        for ($i = 1; $i < count($this->blocks); $i++) {
            $currentBlock = $this->blocks[$i];
            $check=0;
            if ($check==1){
                $previousBlock = $this->blocks[$i - 1];
            }
 
            if ($currentBlock->hash !== $currentBlock->getHash()) {
                return false;
            }
            if ($check==1){
                if ($currentBlock->hashAnterior !== $previousBlock->hash) {
                    return false;
                }
            }
            $check=1;
        }
        return true;
    }

    public function getFirstBlock() {
        return $this->blocks[0];
    }

    public function printXML(){
        $xml=new SimpleXMLElement(file_get_contents('blockchain.xml'));
        header('Content-Type: application/xml');
        echo $xml->asXML();
    }

    public function consulta($procedure, $array=array()){
        $command = new DBCommand($this->conexion->getPDOObject());
        $command->Prepare($procedure,$array);
        return $command->Execute();
    }

}



?>