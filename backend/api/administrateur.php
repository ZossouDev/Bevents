<?php
global $pdo;  


const ACTION_SAVE = 'SAVE';  
const ACTION_DELETE = 'DELETE';  


include_once('../core/initialize.php');  


use MyNamespace\ResponseCodes\ResponseCodes;  


$administrateur = new Administrateur($pdo);  


header('Access-Control-Allow-Origin: *');  
header('Content-Type: application/json; charset=UTF-8');  
header('Access-Control-Allow-Methods: GET, POST');  
header('Access-Control-Allow-Headers: Access-Control-Allow-Headers,Content-Type,Access-Control-Allow-Methods,Authorization,X-Requested-With');  


function get_admin(Administrateur $administrateur, PDO $pdo): array
{
    $response = [
        "data" => []  
    ];

    try {
        $idAdmin = filter_input(INPUT_GET, "idAdmin", FILTER_VALIDATE_INT) ?: 0;  
        $emailAdmin = filter_input(INPUT_GET, "emailAdmin", FILTER_SANITIZE_EMAIL) ?: "";  
        $passwordAdmin = filter_input(INPUT_GET, "passwordAdmin", FILTER_SANITIZE_SPECIAL_CHARS) ?: "";  
        
        $result = $emailAdmin && $passwordAdmin ? $administrateur->getAdminByEmailAndpasswordAdmin($emailAdmin, $passwordAdmin) : ($idAdmin ? $administrateur->read($idAdmin) : $administrateur->read());

        if ($result) {
            while ($row = $result->fetch(PDO::FETCH_ASSOC)) {
                $response["administrateur"][] = $row;              
            }
            $response["nbr_elements"] = count($response["administrateur"]);  
            $response["code"] = ResponseCodes::RESPONSE_SUCCESS;  
            $response["message"] = "Utilisateurs récupérés avec succès";  
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


function manage_admin(Administrateur $administrateur, PDO $pdo): array
{
    $response = [];  

    switch ($_POST["action"]) {  
        case ACTION_SAVE:  
            $idAdmin =
                filter_input(INPUT_GET, "idAdmin", FILTER_VALIDATE_INT) ?: 0;  
            try {
                $result = $administrateur->save($idAdmin);  

                $lastInsertId = $result;
                $response["inserted_id"] = $lastInsertId;  
                $response["code"] = $result ? ResponseCodes::RESPONSE_SUCCESS : ResponseCodes::RESPONSE_ERROR;  
                $response["message"] = $result ? "Utilisateur créé avec succès" : "Échec de la création de l'utilisateur";  
            } catch (Exception $e) {
                $response["code"] = ResponseCodes::RESPONSE_SERVER_ERROR;  
                $response["message"] = "Erreur serveur: " . $e->getMessage();  
            }
            break;
        case ACTION_DELETE:  
            try {
                $delete = $administrateur->delete(filter_input(INPUT_GET, "idAdmin", FILTER_VALIDATE_INT) ?: 0);  

                $lastInsertId = $delete ? $pdo->lastInsertId() : 0;
                $response["inserted_id"] = $lastInsertId;  
                $response["code"] = $delete ? ResponseCodes::RESPONSE_SUCCESS : ResponseCodes::RESPONSE_ERROR;  
                $response["message"] = $delete ? "Utilisateur supprimé avec succès" : "Échec de la suppression de l'utilisateur";  
            } catch (Exception $e) {
                $response["code"] = ResponseCodes::RESPONSE_SERVER_ERROR;  
                $response["message"] = "Erreur serveur: " . $e->getMessage();  
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
            $response = get_admin($administrateur, $pdo);  
            break;
        case 'POST':  
            $response = manage_admin($administrateur, $pdo);  
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