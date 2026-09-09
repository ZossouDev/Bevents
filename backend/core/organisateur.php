<?php

class Organisateur
{

    private const ERROR_SAVE = "Erreur lors de l'enregistrement de l'utilisateur.";
    private const ERROR_SAVE_DB = "Erreur de sauvegarde dans la base de données : ";
    
    private string $table = "organisateur";
    
    private PDO $pdo;
    
    private int $idOrga = 0;

    private string $nomOrga = "";

    private string $prenomOrga = "";

    private string $emailOrga = "";

    private string $passwordOrga = "";

    private string $telephoneOrga = "";

    private string $adresseOrga = "";

    private string $imageOrga = "";
    
    private string $val_data = "nomOrga = :nomOrga, prenomOrga = :prenomOrga, emailOrga = :emailOrga, 
    passwordOrga = :passwordOrga, telephoneOrga = :telephoneOrga, adresseOrga = :adresseOrga, imageOrga = :imageOrga";

    public function __construct(PDO $pdo)
    {
        $this->pdo = $pdo; 
    }

    public function read(int $idOrga = 0): ?PDOStatement
    {
        try {
            $sql = "SELECT * FROM $this->table WHERE 1"; 

            if ($idOrga != 0) { 
                $this->idOrga = $idOrga;
                $sql .= " AND idOrga = :idOrga";
            }
            $stmt = $this->pdo->prepare($sql);
            if ($idOrga != 0) { 
                $stmt->bindParam(":idOrga", $this->idOrga);
            }

            $stmt->execute(); 

            return $stmt; 
        } catch (PDOException $e) {
            throw new Exception("Erreur lors de la lecture de l'organisateur : " . $e->getMessage()); 
        }
    }

    public function getOrgaByEmailAndPassword(string $emailOrga, string $passwordOrga): ?array
    {
        try {
            $sql = "SELECT * FROM $this->table WHERE emailOrga = :emailOrga"; 
            $stmt = $this->pdo->prepare($sql); 
            $stmt->bindParam(':emailOrga', $emailOrga); 
            $stmt->execute(); 

            $organisateur = $stmt->fetch(PDO::FETCH_ASSOC); 

            if ($organisateur && password_verify($passwordOrga, $organisateur['passwordOrga'])) { 
                return $organisateur; 
            } else {
                return null; 
            }
        } catch (PDOException $e) {
            throw new Exception("Erreur lors de la récupération de l'utilisateur : " . $e->getMessage()); 
        }
    }

    public function save(int $idOrga = 0): ?int
    {
        try {

            if ($idOrga != 0) { 
                $sql = "UPDATE $this->table SET $this->val_data WHERE idOrga = :idOrga";
                $this->idOrga = $idOrga;
            } else {
                    $sql = "INSERT INTO $this->table SET $this->val_data"; 
            }

            $this->pdo->beginTransaction(); 

            $this->prepareOrganisateurData(); 

            if (isset($_FILES['imageOrga']) && $_FILES['imageOrga']['error'] === UPLOAD_ERR_OK) { 
                $imageResult = $this->processImage('imageOrga', 'assets/imgOrga/', $this->imageOrga);
                $this->imageOrga = $imageResult['success'] ? $imageResult['imagePath'] : "";
            } else {
                $this->imageOrga = filter_input(INPUT_POST, 'imageOrga', FILTER_SANITIZE_SPECIAL_CHARS) ?: ""; 
            }

            $stmt = $this->pdo->prepare($sql); 

            if ($idOrga != 0) { 
                $stmt->bindParam(':idOrga', $this->idOrga, PDO::PARAM_INT);
            }

            if ($this->bindOrganisateurData($stmt)) { 
                if ($idOrga != 0) {
                    $this->pdo->commit(); 
                    return $idOrga; 
                } else {
                    $lastId = $this->pdo->lastInsertId(); 
                    $this->pdo->commit(); 
                    return $lastId; 
                }
            } else {
                throw new Exception(self::ERROR_SAVE); 
            }
        } catch (PDOException $e) {
            $this->pdo->rollBack(); 
            throw new Exception(self::ERROR_SAVE_DB . $e->getMessage()); 
        }
    }

    public function emailExists(string $emailOrga): bool
    {
        try {
            $sql = "SELECT COUNT(*) FROM $this->table WHERE emailOrga = :emailOrga"; 
            $stmt = $this->pdo->prepare($sql); 
            $stmt->bindParam(':emailOrga', $emailOrga); 
            $stmt->execute(); 

            $count = $stmt->fetchColumn(); 

            return $count > 0; 
        } catch (PDOException $e) {
            throw new Exception("Erreur lors de la vérification de l'existence de l'email : " . $e->getMessage()); 
        }
    }

    public function phoneExists(string $phone): bool
    {
        try {
            $sql = "SELECT COUNT(*) FROM $this->table WHERE telephoneOrga = :telephoneOrga"; 
            $stmt = $this->pdo->prepare($sql); 
            $stmt->bindParam(':telephoneOrga', $phone); 
            $stmt->execute(); 

            $count = $stmt->fetchColumn(); 

            return $count > 0; 
        } catch (PDOException $e) {
            throw new Exception("Erreur lors de la vérification de l'existence du téléphone : " . $e->getMessage()); 
        }
    }

    private function prepareOrganisateurData(): void
    {
        
        $this->nomOrga = filter_input(INPUT_POST, 'nomOrga', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
        $this->prenomOrga = filter_input(INPUT_POST, 'prenomOrga', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
        $this->emailOrga = filter_input(INPUT_POST, 'emailOrga', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
        $this->passwordOrga = filter_input(INPUT_POST, 'passwordOrga', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
        $this->telephoneOrga = filter_input(INPUT_POST, 'telephoneOrga', FILTER_VALIDATE_INT) ?: 0;
        $this->adresseOrga = filter_input(INPUT_POST, 'adresseOrga', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
        $this->imageOrga = filter_input(INPUT_POST, 'imageOrga', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
    }

    public function processImage(string $imageInputName, string $destinationPath, string $oldImagePath = ""): array
    {
        $fileName = $_FILES[$imageInputName]['imageOrga']; 
        $tempPath = $_FILES[$imageInputName]['tmp_name']; 
        $fileSize = $_FILES[$imageInputName]['size']; 
        $fileError = $_FILES[$imageInputName]['error']; 

        $result = add_images($fileName, $tempPath, $fileSize, $fileError, $destinationPath, $oldImagePath); 

        if ($result['result']) { 
            $imagePath = $result['message']; 
            return array(
                'success' => true,
                'message' => 'Image téléchargée et traitée avec succès',
                'imagePath' => $imagePath
            );
        } else {
            return array(
                'success' => false,
                'message' => $result['message'] 
            );
        }
    }

    private function bindOrganisateurData(PDOStatement $stmt): bool
    {
        
        $stmt->bindParam(':nomOrga', $this->nomOrga);
        $stmt->bindParam(':prenomOrga', $this->prenomOrga);
        $stmt->bindParam(':emailOrga', $this->emailOrga);
        $stmt->bindParam(':passwordOrga', $this->passwordOrga);
        $stmt->bindParam(':telephoneOrga', $this->telephoneOrga);
        $stmt->bindParam(':adresseOrga', $this->adresseOrga);
        $stmt->bindParam(':imageOrga', $this->imageOrga);

        if ($stmt->execute()) { 
            return true; 
        }
        return false; 
    }

    public function updateAttribute(int $idOrga, string $attribute, mixed $value): bool
    {
        try {
            $sql = "UPDATE $this->table SET $attribute = :value WHERE idOrga = :idOrga"; 
            $stmt = $this->pdo->prepare($sql); 
            $stmt->bindParam(':value', $value); 
            $stmt->bindParam(':idOrga', $idOrga, PDO::PARAM_INT); 
            if ($stmt->execute()) { 
                return true; 
            } else {
                throw new Exception("Erreur lors de la modification de l'attribut."); 
            }
        } catch (PDOException $e) {
            throw new Exception("Erreur lors de la modification de l'attribut : " . $e->getMessage()); 
        }
    }

    public function delete(int $idOrga = 0): bool
    {
        try {
            $sql = "DELETE FROM $this->table WHERE idOrga = :idOrga"; 

            $stmt = $this->pdo->prepare($sql); 

            $stmt->bindParam(':idOrga', $idOrga, PDO::PARAM_INT); 

            if ($stmt->execute()) { 
                return true; 
            } else {
                throw new Exception("Erreur lors de la suppression de l'utilisateur."); 
            }
        } catch (PDOException $e) {
            throw new Exception("Erreur lors de la suppression de l'utilisateur : " . $e->getMessage()); 
        }
    }
}