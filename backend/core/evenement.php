<?php

class Evenement
{

    private const ERROR_SAVE = "Erreur lors de l'enregistrement de l'utilisateur.";
    private const ERROR_SAVE_DB = "Erreur de sauvegarde dans la base de données : ";

    private string $table = "evenement";

    private PDO $pdo;

    private int $idEvent = 0;
    private string $nomEvent = "";
    private string $typeEvent = "";
    private string $categorie = "";
    private string $lieu = "";
    private string $horaireDebut = "";
    private string $imageEvent = "";
    private string $descriptionEvent = "";
    private int $nbrePlaces;
    private string $prix = "";
    private string $statut = "";
    private int $idOrga;
   

    private string $val_data = "nomEvent = :nomEvent, typeEvent = :typeEvent, categorie = :categorie, lieu = :lieu, 
    horaireDebut = :horaireDebut, imageEvent = :imageEvent, descriptionEvent = :descriptionEvent, nbrePlaces = :nbrePlaces, 
    prix = :prix, statut = :statut, idOrga = :idOrga";

    public function __construct(PDO $pdo)
    {
        $this->pdo = $pdo; 
    }

    public function read(int $idEvent = 0, int $idOrga = 0): ?PDOStatement
    {
        try {
            $sql = "SELECT * FROM evenement WHERE 1"; 

            if ($idEvent != 0) { 
                $this->idEvent = $idEvent;
                $sql .= " AND idEvent = :idEvent";
            }

            if ($idOrga != 0) { 
                $this->idOrga = $idOrga;
                $sql .= " AND idOrga = :idOrga";
            }
            
            $stmt = $this->pdo->prepare($sql);

            if ($idEvent != 0) { 
                $stmt->bindParam(":idEvent", $this->idEvent);
            }

            if ($idOrga != 0) { 
                $stmt->bindParam(":idOrga", $this->idOrga);
            }

            $stmt->execute(); 
            
            return $stmt; 
        } catch (PDOException $e) {
            throw new Exception("Erreur lors de la lecture des evenements : " . $e->getmessage()); 
        }
    }

//     public function save(int $idEvent = 0): ?int
//     {
//         try {


//             if ($idEvent != 0) { 
//                 $sql = "UPDATE $this->table SET $this->val_data WHERE idEvent = :idEvent";
//                 $this->idEvent = $idEvent;
//             } else {
//                     $sql = "INSERT INTO $this->table SET $this->val_data"; 
//                 }
            

//             $this->pdo->beginTransaction(); 

//             $this->prepareEvenementData(); 

//             if (isset($_FILES['imageEvent']) && $_FILES['imageEvent']['error'] === UPLOAD_ERR_OK) { 
//                 $imageResult = $this->processImage('imageEvent', 'assets/imgEvent/', $this->imageEvent);
//                 $this->imageEvent = $imageResult['success'] ? $imageResult['imagePath'] : "";
//             } else {
//                 $this->imageEvent = filter_input(INPUT_POST, 'imageEvent', FILTER_SANITIZE_SPECIAL_CHARS) ?: ""; 
//             }

//             $stmt = $this->pdo->prepare($sql); 
//             if ($idEvent != 0) { 
//                 $stmt->bindParam(':idEvent', $this->idEvent, PDO::PARAM_INT);
//             }

//             if ($this->bindEvenementData($stmt)) { 
//                 if ($idEvent != 0) {
//                     $this->pdo->commit(); 
//                     return $idEvent; 
//                 } else {
//                     $lastidEvent = $this->pdo->lastInsertId(); 
//                     $this->pdo->commit(); 
//                     return $lastidEvent; 
//                 }
//             } else {
//                 throw new Exception(self::ERROR_SAVE); 
//             }
           
//         }  catch (PDOException $e) {
//             $this->pdo->rollBack(); 
//             throw new Exception(self::ERROR_SAVE_DB . $e->getmessage());
//     }
// }


    public function save(int $idEvent = 0): ?int
    {
        $image = $_FILES['image'] ?? null;
        $imagePath = $this->handleImageUpload($image);

        if ($imagePath) {
            $this->imageEvent = $imagePath;
        }

        $sql = $idEvent != 0 ? "UPDATE $this->table SET $this->val_data WHERE idEvent = :idEvent" : "INSERT INTO $this->table SET $this->val_data";

        $this->idEvent = $idEvent;

        $this->pdo->beginTransaction();
        $this->prepareEvenementData();

        $stmt = $this->pdo->prepare($sql);
        $this->bindEvenementData($stmt);

        if ($idEvent != 0) {
            $stmt->bindParam(':idEvent', $this->idEvent, PDO::PARAM_INT);
        }

        if ($stmt->execute()) {
            $lastId = $idEvent != 0 ? $idEvent : $this->pdo->lastInsertId();
            $this->pdo->commit();
            return $lastId;
        } else {
            $this->pdo->rollBack();
            throw new Exception(self::ERROR_SAVE);
        }
    }
    private function handleImageUpload($image): ?string
    {
        
        if ($image ) {
            
            $result = add_images($image['name'], $image['tmp_name'], $image['size'], $image['error'], 'assets/imgEvent/', $this->imageEvent);

            if ($result['result']) {
                return $result['message'];
            } else {
                throw new Exception($result['message']);
            }
        }
        return null;
    }

    private function prepareEvenementData(): void
    {
        $this->nomEvent = filter_input(INPUT_POST, 'nomEvent', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
        $this->typeEvent = filter_input(INPUT_POST, 'typeEvent', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
        $this->categorie = filter_input(INPUT_POST, 'categorie', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
        $this->lieu = filter_input(INPUT_POST, 'lieu', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
        $this->horaireDebut = filter_input(INPUT_POST, 'horaireDebut', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
        //$this->imageEvent = filter_input(INPUT_POST, 'imageEvent', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
        $this->descriptionEvent = filter_input(INPUT_POST, 'descriptionEvent', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
        $this->nbrePlaces = filter_input(INPUT_POST, 'nbrePlaces', FILTER_VALIDATE_INT) ?: 0;
        $this->prix = filter_input(INPUT_POST, 'prix', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
        $this->statut = filter_input(INPUT_POST, 'statut', FILTER_SANITIZE_SPECIAL_CHARS) ?: "En attente";
        $this->idOrga = filter_input(INPUT_POST, 'idOrga', FILTER_VALIDATE_INT) ?: 0;
    }

    // public function processImage(string $imageInputName, string $destinationPath, string $oldImagePath = ""): array
    // {
    //     $fileName = $_FILES[$imageInputName]['imageEvent']; 
    //     $tempPath = $_FILES[$imageInputName]['tmp_name']; 
    //     $fileSize = $_FILES[$imageInputName]['size']; 
    //     $fileError = $_FILES[$imageInputName]['error'];

    //     $result = add_images($fileName, $tempPath, $fileSize, $fileError, $destinationPath, $oldImagePath); 

    //     if ($result['result']) { 
    //         $imagePath = $result['message']; 
    //         return array(
    //             'success' => true,
    //             'message' => 'Image téléchargée et traitée avec succès',
    //             'imagePath' => $imagePath
    //         );
    //     } else {
    //         return array(
    //             'success' => false,
    //             'message' => $result['message'] 
    //         );
    //     }
    // }

    private function bindEvenementData(PDOStatement $stmt): void
    {
        
        $stmt->bindParam(':nomEvent', $this->nomEvent);
        $stmt->bindParam(':typeEvent', $this->typeEvent);
        $stmt->bindParam(':categorie', $this->categorie);
        $stmt->bindParam(':lieu', $this->lieu);
        $stmt->bindParam(':horaireDebut', $this->horaireDebut);
        $stmt->bindParam(':imageEvent', $this->imageEvent);
        $stmt->bindParam(':descriptionEvent', $this->descriptionEvent);
        $stmt->bindParam(':nbrePlaces', $this->nbrePlaces);
        $stmt->bindParam(':prix', $this->prix);
        $stmt->bindParam(':statut', $this->statut);
        $stmt->bindParam(':idOrga', $this->idOrga);
        
    }

    public function updateAttribute(int $idEvent, string $attribute, mixed $value): bool
    {
        try {
            $sql = "UPDATE $this->table SET $attribute = :value WHERE idEvent = :idEvent";
            $stmt = $this->pdo->prepare($sql);
            $stmt->bindParam(':value', $value);
            $stmt->bindParam(':idEvent', $id, PDO::PARAM_INT);
            if ($stmt->execute()) { 
                return true;
            } else {
                throw new Exception("Erreur lors de la modification de l'attribut."); 
            }
        } catch (PDOException $e) {
            throw new Exception("Erreur lors de la modification de l'attribut : " . $e->getmessage()); 
        }
    }

    public function delete(int $idEvent = 0): bool
    {
        try {
            $sql = "DELETE FROM $this->table WHERE idEvent = :idEvent"; 

            $stmt = $this->pdo->prepare($sql); 

            $stmt->bindParam(':idEvent', $idEvent, PDO::PARAM_INT); 

            if ($stmt->execute()) { 
                return true; 
            } else {
                throw new Exception("Erreur lors de la suppression de l'utilisateur."); 
        } 
    } catch (PDOException $e) {
            throw new Exception("Erreur lors de la suppression de l'utilisateur : " . $e->getmessage());
        }
    
}

}