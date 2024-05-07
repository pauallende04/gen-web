<?php

class Block{

    public $index;
    public $date;
    public $hashAnterior;
    public $hash;
    public $transaction;
    public $Lasthash;

    public function __construct($transaction){
        $this->transaction=$transaction;
    }


    public function Hash($var){
        $this->Lasthash=$var;
        $trans=$this->transaction[0];
        $this->hash=md5($this->index . $this->date . $trans->origen . $trans->destino . $trans->cantidad . $this->Lasthash);
        return md5($this->index . $this->date . $trans->origen . $trans->destino . $trans->cantidad . $this->Lasthash);
    }

    public function getHash(){
        $trans=$this->transaction[0];
        return md5($this->index . $this->date . $trans->origen . $trans->destino . $trans->cantidad . $this->Lasthash);
    }


    public function print(){
        echo "Block:" . $this->index . "<br>";
        echo "Timestap: " . $this->date . "<br>";
        echo "Previous Hash: " . $this->Lasthash . "<br>";
        echo "Hash: " . $this->hash . "<br>";
        $trans=$this->transaction[0];
            echo "Transaction: " . "{From: " . $trans->origen . " To: " . $trans->destino . " amount: " . $trans->cantidad . "}" . "<br>";
            echo "----------------------------------". "<br>";
    }


    public function guardar($conexion){
        $command = new DBCommand($conexion->getPDOObject());
        $command->Prepare("insertBlock",[$this->transaction[0]->origen, $this->transaction[0]->destino,$this->transaction[0]->cantidad,$this->hash,$this->Lasthash]);
        $command->Execute();
    }
}



?>