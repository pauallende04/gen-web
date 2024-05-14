<?php
class DBCommand {
    private $pdo;

    public function __construct($pdo) {
        $this->pdo = $pdo;
    }

    public function execute($procedureName, $params = array()) {
        // Construir la cadena de marcadores de posición para los parámetros
        $placeholders = implode(',', array_fill(0, count($params), '?'));
    
        // Construir la llamada al procedimiento almacenado con los marcadores de posición
        $sql = "EXEC $procedureName $placeholders";
    
        $stmt = $this->pdo->prepare($sql);
    
        // Asignar los valores de los parámetros a los marcadores de posición
        foreach ($params as $index => $value) {
            $stmt->bindValue($index + 1, $value);
        }
    
        $stmt->execute();
    
        // Fetch the result as a string (XML)
        $result = $stmt->fetchColumn();

    
        // No es necesario verificar si es XML aquí
        return $result;
    }

    private function isXML($string) {
        // Verificar si el resultado es un arreglo
        if (is_array($string)) {
            // Convertir el arreglo a una cadena
            $string = implode("", $string);
        }
    
        // Check if the string contains XML tags
        return preg_match('/<\?xml/', $string) === 1;
    }
    

    private function parseXML($xmlString) {
        // Parse the XML string
        $xml = simplexml_load_string($xmlString);
        return $xml;
    }
}

?>
