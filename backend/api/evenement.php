<?php
global $pdo;

const ACTION_SAVE = 'SAVE';
const ACTION_DELETE = 'DELETE';

include_once('../core/initialize.php');

use MyNamespace\ResponseCodes\ResponseCodes;

$evenement = new Evenement($pdo);

header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json; charset=UTF-8');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Access-Control-Allow-Headers,Content-Type,Access-Control-Allow-Methods,Authorization,X-Requested-With');

function get_evenement(Evenement $evenement): array {
    $response = ["evenement" => []];

    try {
        if (isset($_GET["idEvent"]) && $_GET["idEvent"] !== "") {
            $result = $evenement->read($_GET["idEvent"]);
        } else if (isset($_GET["idOrga"]) && $_GET["idOrga"] !== "") {
            $result = $evenement->read(idOrga: $_GET["idOrga"]);
        } else {
            $result = $evenement->read();
        }

        if ($result) {
            while ($row = $result->fetch(PDO::FETCH_ASSOC)) {
                $response["evenement"][] = $row;
            }
            $response["nbr_elements"] = count($response["evenement"]);
            $response["code"] = ResponseCodes::RESPONSE_SUCCESS;
            $response["codeResponse"] = "100";
            $response["message"] = "Evenements récupérés avec succès";
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

function manage_evenement(Evenement $evenement, PDO $pdo): array {
    $response = [];

    switch ($_POST["action"]) {
        case ACTION_SAVE:
            $idEvent = filter_input(INPUT_POST, "idEvent", FILTER_VALIDATE_INT) ?: 0;
            try {
                $result = $evenement->save($idEvent);

                $lastInsertId = $result;
                $response["inserted_id"] = $lastInsertId;
                $response["code"] = $result ? ResponseCodes::RESPONSE_SUCCESS : ResponseCodes::RESPONSE_ERROR;
                $response["message"] = $result ? "Evenement créé avec succès" : "Échec de la création de l'événement";
            } catch (Exception $e) {
                $response["code"] = ResponseCodes::RESPONSE_SERVER_ERROR;
                $response["message"] = "Erreur serveur: " . $e->getMessage();
            }
            break;
        case ACTION_DELETE:
            try {
                $delete = $evenement->delete(filter_input(INPUT_POST, "idEvent", FILTER_VALIDATE_INT) ?: 0);

                $lastInsertId = $delete ? $pdo->lastInsertId() : 0;
                $response["inserted_id"] = $lastInsertId;
                $response["code"] = $delete ? ResponseCodes::RESPONSE_SUCCESS : ResponseCodes::RESPONSE_ERROR;
                $response["message"] = $delete ? "Evenement supprimé avec succès" : "Échec de la suppression de l'événement";
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

function update_evenement_status(Evenement $evenement, int $idEvent, string $statut): array {
    $response = [];
    echo $idEvent, $statut;

    try {
        $updated = $evenement->updateAttribute($idEvent, 'statut', $statut);
        $response["code"] = $updated ? ResponseCodes::RESPONSE_SUCCESS : ResponseCodes::RESPONSE_ERROR;
        $response["message"] = $updated ? "Statut mis à jour avec succès" : "Échec de la mise à jour du statut";
    } catch (Exception $e) {
        $response["code"] = ResponseCodes::RESPONSE_SERVER_ERROR;
        $response["message"] = "Erreur serveur: " . $e->getMessage();
    }

    return $response;
}

try {
    $requestMethod = $_SERVER['REQUEST_METHOD'];

    switch ($requestMethod) {
        case 'GET':
            $response = get_evenement($evenement);
            break;
        case 'POST':
            $response = manage_evenement($evenement, $pdo);
            break;
        case 'PUT':
            parse_str(file_get_contents("php://input"), $_PUT);
            $idEvent = filter_var($_PUT['idEvent'], FILTER_VALIDATE_INT);
            $statut = filter_var($_PUT['statut'], FILTER_SANITIZE_SPECIAL_CHARS);
            $response = update_evenement_status($evenement, $idEvent, $statut);
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
