<?php

namespace MyNamespace\ResponseCodes;

/**
 * Classe définissant les codes de réponse HTTP standardisés utilisés à travers notre application.
 * Ces codes facilitent la gestion uniforme des réponses aux requêtes dans les différentes parties de l'application.
 */
class ResponseCodes
{
    /** @var string Code de réponse indiquant que l'opération a été exécutée avec succès */
    const RESPONSE_SUCCESS = '100'; // Code 100 pour une opération réussie

    /** @var string Code de réponse utilisé pour signaler une erreur générique non spécifiée */
    const RESPONSE_ERROR = '101'; // Code 101 pour une erreur générique

    /** @var string Code de réponse indiquant qu'une erreur interne du serveur s'est produite */
    const RESPONSE_SERVER_ERROR = '500'; // Code 500 pour une erreur interne du serveur

    /** @var string Code de réponse utilisé lorsque la requête ne retourne aucune donnée */
    const RESPONSE_NO_DATA = '0'; // Code 0 quand aucune donnée n'est retournée

    /** @var string Code de réponse pour une requête qui a été mal formulée */
    const RESPONSE_BAD_REQUEST = '400'; // Code 400 pour une requête mal formulée

    /** @var string Code de réponse indiquant que la méthode HTTP utilisée n'est pas autorisée */
    const RESPONSE_METHOD_NOT_ALLOWED = '405'; // Code 405 pour une méthode HTTP non autorisée
}