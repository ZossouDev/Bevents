<?php
global $pdo;  

const ACTION_SAVE = 'SAVE'; 
const ACTION_DELETE = 'DELETE';  


include_once('../core/initialize.php');  

use MyNamespace\ResponseCodes\ResponseCodes; 

$organisateur = new Organisateur($pdo); 

header('Access-Control-Allow-Origin: *'); 
header('Content-Type: application/json; charset=UTF-8'); 
header('Access-Control-Allow-Methods: GET, POST'); 
header('Access-Control-Allow-Headers: Access-Control-Allow-Headers,Content-Type,Access-Control-Allow-Methods,Authorization,X-Requested-With');  // Définit les en-têtes autorisés


function get_organisateur(Organisateur $organisateur): array
{
    $response = [
        "data" => []  
    ];

    try {
        $userId = filter_input(INPUT_GET, "idOrga", FILTER_VALIDATE_INT) ?: 0;  
        
        $result =($userId ? $organisateur->read($userId) : $organisateur->read());

        if ($result) {
            while ($row = $result->fetch(PDO::FETCH_ASSOC)) {
                $response["organisateur"][] = $row;              
            }
            $response["nbr_elements"] = count($response["organisateur"]);  
            $response["code"] = ResponseCodes::RESPONSE_SUCCESS;  
            $response["message"] = "Organisateurs récupérés avec succès";  
        } else {
            $response["nbr_elements"] = 0;  
            $response["code"] = ResponseCodes::RESPONSE_NO_DATA;  
            $response["message"] = "Aucune donnée trouvée";  
        }
    } catch (Exception $e) {
        $response["code"] = ResponseCodes::RESPONSE_SERVER_ERROR;  
        $response["message"] = "Erreur serveur: " . $e->getMessage(); 
    }

    return $response;  
}


function manage_organisateur(Organisateur $organisateur, PDO $pdo): array
{
    $response = [];  

    switch ($_POST["action"]) { 
        case ACTION_SAVE: 
            $idOrga =
                filter_input(INPUT_POST, "idOrga", FILTER_VALIDATE_INT) ?: 0; 
            try {
                $result = $organisateur->save($idOrga); 

                $lastInsertId = $result;
                $response["inserted_id"] = $lastInsertId; 
                $response["code"] = $result ? ResponseCodes::RESPONSE_SUCCESS : ResponseCodes::RESPONSE_ERROR;  // Définition du code de réponse basé sur le résultat
                $response["message"] = $result ? "organisateur créé avec succès" : "Échec de la création de l'utilisateur";  // Définition du message de réponse basé sur le résultat
            } catch (Exception $e) {
                $response["code"] = ResponseCodes::RESPONSE_SERVER_ERROR;  
                $response["message"] = "Erreur serveur: " . $e->getMessage();  
            }
            break;
        case ACTION_DELETE: 
            try {
                $delete = $organisateur->delete(filter_input(INPUT_POST, "idOrga", FILTER_VALIDATE_INT) ?: 0);  

                $lastInsertId = $delete ? $pdo->lastInsertId() : 0;
                $response["inserted_id"] = $lastInsertId;  
                $response["code"] = $delete ? ResponseCodes::RESPONSE_SUCCESS : ResponseCodes::RESPONSE_ERROR;  
                $response["message"] = $delete ? "organisateur supprimé avec succès" : "Échec de la suppression de l'utilisateur";      
            } catch (Exception $e) {
                $response["code"] = ResponseCodes::RESPONSE_SERVER_ERROR;  // Définition du code de réponse pour erreur serveur
                $response["message"] = "Erreur serveur: " . $e->getMessage();  // Définition du message de réponse pour erreur serveur
            }
             break;
            default:
            $response["code"] = ResponseCodes::RESPONSE_BAD_REQUEST;  
            $response["message"] = "Action non valide";  
            break;
            }

    return $response; 
}


try {
    $requestMethod = $_SERVER['REQUEST_METHOD'];  

    switch ($requestMethod) {  
        case 'GET': 
            $response = get_organisateur($organisateur);  
            break;
        case 'POST': 
            $response = manage_organisateur($organisateur, $pdo);  
            break;
        default:
            $response["code"] = ResponseCodes::RESPONSE_METHOD_NOT_ALLOWED;  
            $response["message"] = "Méthode non autorisée";  
            break;
    }
} catch (Exception $e) {
    $response["code"] = ResponseCodes::RESPONSE_SERVER_ERROR;  
    $response["message"] = "Erreur serveur: " . $e->getMessage(); 
}

echo json_encode($response);  