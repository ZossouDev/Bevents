<?php

include_once('../core/initialize.php');

use MyNamespace\ResponseCodes\ResponseCodes;

$organisateur = new Organisateurs($pdo);

header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json; charset=UTF-8');
header('Access-Control-Allow-Methods: GET');
header('Access-Control-Allow-Headers: Access-Control-Allow-Headers,Content-Type,Access-Control-Allow-Methods,Authorization,X-Requested-With');

$response = array();

try {
    $totalOrganisateurs = $organisateur->countOrganisateurs();

    $response['status'] = true;
    $response['message'] = 'Nombre total d\'organisateurs récupéré avec succès';
    $response['total'] = $totalOrganisateurs;
} catch (Exception $e) {
    $response['status'] = false;
    $response['message'] = 'Erreur : ' . $e->getMessage();
}

echo json_encode($response);
