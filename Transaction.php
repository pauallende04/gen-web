<?php

class Transaction{
    
    public $origin;
    public $destiny;
    public $quantity;

    public function __construct($origin, $destiny, $quantity){
        $this->origin=$origin;
        $this->destiny=$destiny;
        $this->quantity=$quantity;
    }
    

}



?>