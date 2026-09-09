<?php
global $pdo;
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json; charset=UTF8');
header('Access-Control-Allow-Methods: POST, GET');
header('Access-Control-Allow-Headers: Access-Control-Allow-Headers, Content=Type, Access-Control-Allow-Methods, Authorization, X-Requested-With');

include_once('../core/initialize.php');

$register = new register($pdo);

$api = $_SERVER["REQUEST_METHOD"];

$response = array();

switch ($api) {
    case 'GET':
        if (isset($_GET["idOrga"]) && $_GET["idOrga"] ==! "") {
            $result = $register->getOrganisateur($_GET["idOrga"]);
        } else {
            $result = $register->getOrganisateur();
        }
        
        
        if ($result) {
            while ($row = $result->fetch(PDO::FETCH_ASSOC)) {
                $response["organisateur"][] = $row;
            }
            if ($result->rowCount() > 0) {
                $response["codeReponse"] = "100";
            } else {
                $response["codeReponse"] = "101";
            }
        }else {
            $response["codeReponse"] = "0";
        }
        
        echo json_encode($response);
        break;
    
    case 'POST':
        // Gérer l'inscription ou la connexion d'un organisateur
        if (isset($_POST["action"])) {
            $action = $_POST["action"];
            switch ($action) {
                case 'register':
                    $nomOrga = $_POST["nomOrga"];
                    $prenomOrga = $_POST["prenomOrga"];
                    $emailOrga = $_POST["emailOrga"];
                    $passwordOrga = $_POST["passwordOrga"];
                    $result = $register->registerOrganisateur($nomOrga, $prenomOrga, $emailOrga, $passwordOrga);
                    if ($result) {
                        $response["codeResponse"] = "100";
                        $response["message"] = "Inscription réussie";
                        $response["id"]= $pdo->lastInsertId();
                    } else {
                        $response["codeResponse"] = "0";
                        $response["message"] = "Erreur lors de l'inscription";

                    }
                    break;
                
                    case 'login':
                        $email = $_POST["email"];
                        $password = $_POST["password"];
                        
                        // Appel à la méthode loginOrganisateur pour vérifier les informations de connexion
                        $result = $register->loginOrganisateur($email, $password);
                        
                        if ($result) {
                            // Si les informations de connexion sont valides, vérifiez si c'est un administrateur ou un organisateur
                            if (isset($result['role']) && $result['role'] == 'administrateur') {
                                // Si c'est un administrateur, retournez un code de réussite avec un message et les informations de l'administrateur
                                $response["codeResponse"] = "100";
                                $response["message"] = "Connexion réussie en tant qu'administrateur";
                                $response["administrateur"] = $result;
                                $response["id"]= $pdo->lastInsertId();
                            } else {
                                // Sinon, c'est un organisateur, retournez un code de réussite avec un message et les informations de l'organisateur
                                $response["codeResponse"] = "100";
                                $response["message"] = "Connexion réussie en tant qu'organisateur";
                                $response["organisateur"] = $result;
                                $response["id"]= $pdo->lastInsertId();
                            }
                        } else {
                            // Si les informations de connexion sont incorrectes, retournez un code d'erreur
                            $response["codeResponse"] = "101";
                            $response["message"] = "Identifiants incorrects";
                        }
                        break;
                
                default:
                    $response["codeResponse"] = "0";
                    $response["message"] = "Action non reconnue";
                    break;
            }
        } else {
            $response["codeResponse"] = "0";
            $response["message"] = "Action non spécifiée";
        }
        echo json_encode($response);
        break;

    default:
        echo "Méthode non autorisée";
}
?>
