<?php

global $db;
header('Access-Control-Allow-Origin: *');
header( 'Content-Type: application/json; charset=UTF8');
header( 'Access-Control-Allow-Methods: POST, GET');
header( 'Access-Control-Allow-Headers: Access-Control-Allow-Headers, Content=Type, Access-Control-Allow-Methods, Authorization, X-Requested-With');

include_once('../core/initialize.php');


$artiste = new artiste($db);

$api = $_SERVER["REQUEST_METHOD"];

$response = array();

switch ($api) {
  case 'GET':
    if (isset($_GET["idArtiste"]) && $_GET["idArtiste"] ==! "") {
        $result = $artiste->get_all_artiste($_GET["idArtiste"]);
    } else {
        $result = $artiste->get_all_artiste();
    }
    
    if ($result) {
        while ($row = $result->fetch(PDO::FETCH_ASSOC)) {
            $response["artiste"][] = $row;
        }
        if ($result->rowCount() > 0) {
            $response["codeResponse"] = "100";
        } else {
            $response["codeResponse"] = "101";
        }
    } else {
        $response["codeResponse"] = "0";
    }
    
    echo json_encode($response);
    break;
    
    case 'POST':
        if (isset($_POST["idArtiste"]) && $_POST["idArtiste"] ==! "") {
            
        $result = $artiste->update_artiste();
    } else {
        $result = $artiste->save_artiste();
    }
        
        if ($result) {
            echo "Bien enregistrer";
        } else {
            echo "Mal enregistrer";
        }
        
        break;
  default:
    echo "Méthode non autorisé";
}
?>