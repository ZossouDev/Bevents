<?php

/**
 * Renvoie la date et l'heure actuelles formatées pour le fuseau horaire spécifié.
 * Par défaut, le fuseau horaire est celui de l'Afrique/Porto-Novo.
 *
 * @param string $timezone Fuseau horaire à utiliser pour la date et l'heure actuelles.
 * @return string Date et heure actuelles au format 'Y-m-d H:i:s'.
 */
function getCurrentTime(string $timezone = 'Africa/Porto-Novo'): string
{
    return date_format(date_create('now', timezone_open($timezone)), 'Y-m-d H:i:s');
}

/**
 * Gère le téléchargement de fichiers image et vidéo, en vérifiant les extensions et les tailles de fichiers.
 * Retourne un tableau avec le résultat du téléchargement et un message associé.
 *
 * @param string $fileName Nom du fichier en cours de téléchargement.
 * @param string $tempPath Emplacement temporaire du fichier sur le serveur.
 * @param int $fileSize Taille du fichier en octets.
 * @param int $fileError Code d'erreur associé au téléchargement du fichier.
 * @param string $path Chemin du répertoire de destination du fichier.
 * @param string $old_path Chemin du fichier existant à remplacer (optionnel).
 * @return array Tableau contenant les clés 'result' (booléen) et 'message' (string).
 */
function add_images(string $fileName, string $tempPath, int $fileSize, int $fileError, string $path, string $old_path = ''): array
{
    if (!empty($fileName)) {
        $upload_path = $path;

        $fileExt = strtolower(pathinfo($fileName, PATHINFO_EXTENSION));

        $valid_image_extensions = ['jpeg', 'jpg', 'png', 'gif'];
        $valid_video_extensions = ['mp4', 'mov', 'avi', 'wmv'];

        if (in_array($fileExt, array_merge($valid_image_extensions, $valid_video_extensions))) {
            if (!empty($old_path) && file_exists($old_path)) {
                unlink($old_path);
            }
            if ($fileError === UPLOAD_ERR_OK) {
                if (in_array($fileExt, $valid_video_extensions) && $fileSize > 10485760) {
                    return [
                        'result' => false,
                        'message' => "La taille du fichier vidéo dépasse la limite autorisée de 10MB.",
                    ];
                }
                if (move_uploaded_file($tempPath, SITE_ROOT . $upload_path . DS . $fileName)) {

                    return [
                        'result' => true,
                        'message' => $upload_path . $fileName,
                    ];
                } else {
                    return [
                        'result' => false,
                        'message' => "Le fichier n'a pas pu être téléchargé.",
                    ];
                }
            } else {
                return [
                    'result' => false,
                    'message' => "Erreur de téléchargement : " . $fileError,
                ];
            }
        } else {
            return [
                'result' => false,
                'message' => "Seuls les fichiers MP4, MOV, AVI, WMV, JPG, JPEG, PNG, GIF sont autorisés.",
            ];
        }
    } else {
        return [
            'result' => false,
            'message' => "Veuillez sélectionner un fichier.",
        ];
    }
}
