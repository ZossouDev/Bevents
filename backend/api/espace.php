<?php
global $pdo;

const ACTION_SAVE = 'SAVE';
const ACTION_DELETE = 'DELETE';


include_once('../core/initialize.php');

use MyNamespace\ResponseCodes\ResponseCodes;

$espace = new Espace($pdo);

header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json; charset=UTF-8');
header('Access-Control-Allow-Methods: GET, POST');
header('Access-Control-Allow-Headers: Access-Control-Allow-Headers,Content-Type,Access-Control-Allow-Methods,Authorization,X-Requested-With');  // Définit les en-têtes autorisés


function get_espace(Espace $espace): array
{
    $response = [
        "data" => []
    ];

    try {
        if (isset($_GET["idEspace"]) && $_GET["idEspace"] == !"") {
            $result = $espace->read($_GET["idEspace"]);
        } else {
            $result = $espace->read();
        }

        if ($result) {
            while ($row = $result->fetch(PDO::FETCH_ASSOC)) {
                $response["espace"][] = $row;
            }
            $response["nbr_elements"] = count($response["espace"]);
            $response["code"] = ResponseCodes::RESPONSE_SUCCESS;
            $response["codeResponse"] = "100";
            $response["message"] = "espaces récupérés avec succès";
        } else {
            $response["nbr_elements"] = 0;
            $response["code"] = ResponseCodes::RESPONSE_NO_DATA;
            $response["codeResponse"] = "101";
            $response["message"] = "Aucune donnée trouvée";
        }
    } catch (Exception $e) {
        $response["code"] = ResponseCodes::RESPONSE_SERVER_ERROR;
        $response["codeResponse"] = "0";
        $response["message"] = "Erreur serveur: " . $e->getMessage();
    }

    return $response;
}


function manage_espace(Espace $espace, PDO $pdo): array
{
    $response = [];

    switch ($_POST["action"]) {
        case ACTION_SAVE:
            $idEspace = filter_input(INPUT_GET, "idEspace", FILTER_VALIDATE_INT) ?: 0;
            try {
                $result = $espace->save($idEspace);

                $lastInsertId = $result;
                $response["inserted_id"] = $lastInsertId;
                $response["code"] = $result ? ResponseCodes::RESPONSE_SUCCESS : ResponseCodes::RESPONSE_ERROR;  // Définition du code de réponse basé sur le résultat
                $response["message"] = $result ? "espace créé avec succès" : "Échec de la création de l'utilisateur";  // Définition du message de réponse basé sur le résultat
            } catch (Exception $e) {
                $response["code"] = ResponseCodes::RESPONSE_SERVER_ERROR;
                $response["message"] = "Erreur serveur: " . $e->getMessage();
            }
            break;
        case ACTION_DELETE:
            try {
                $delete = $espace->delete(filter_input(INPUT_GET, "idEspace", FILTER_VALIDATE_INT) ?: 0);

                $lastInsertId = $delete ? $pdo->lastInsertId() : 0;
                $response["inserted_id"] = $lastInsertId;
                $response["code"] = $delete ? ResponseCodes::RESPONSE_SUCCESS : ResponseCodes::RESPONSE_ERROR;
                $response["message"] = $delete ? "espace supprimé avec succès" : "Échec de la suppression de l'utilisateur";
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
            $response = get_espace($espace);
            break;
        case 'POST':
            $response = manage_espace($espace, $pdo);
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
