<?php

global $db;
header('Access-Control-Allow-Origin: *');
header( 'Content-Type: application/json; charset=UTF8');
header( 'Access-Control-Allow-Methods: GET');
header( 'Access-Control-Allow-Headers: Access-Control-Allow-Headers, Content=Type, Access-Control-Allow-Methods, Authorization, X-Requested-With');

include_once('../core/initialize.php');


$visiteur = new visiteur($db);

$api = $_SERVER["REQUEST_METHOD"];

$response = array();

switch ($api) {
  case 'GET':
    if (isset($_GET["idVisiteur"]) && $_GET["idVisiteur"] ==! "") {
        $result = $visiteur->get_all_visiteur($_GET["idVisiteur"]);
    } else {
        $result = $visiteur->get_all_visiteur();
    }
    
    // if ($result->rowCount() > 0) {
    //     $response["codeReponse"] = "100";
    // } else {
    //     $response["codeReponse"] = "0";
    // }
    
    if ($result) {
        while ($row = $result->fetch(PDO::FETCH_ASSOC)) {
            $response["visiteur"][] = $row;
        }
        if ($result->rowCount() > 0) {
            $response["codeReponse"] = "100";
        } else {
            $response["codeReponse"] = "101";
        }
    } else {
        $response["codeReponse"] = "0";
    }
    
    echo json_encode($response);
    break;
    
    case 'POST':
        if (isset($_POST["idVisiteur"]) && $_POST["idVisiteur"] ==! "") {
            
        $result = $visiteur->update_visiteur();
    } else {
        $result = $visiteur->save_visiteur();
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