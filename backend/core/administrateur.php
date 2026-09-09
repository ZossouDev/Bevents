<?php


class Administrateur
{
    
    private const ERROR_SAVE = "Erreur lors de l'enregistrement de l'utilisateur.";
    private const ERROR_SAVE_DB = "Erreur de sauvegarde dans la base de données : ";
    
    private string $table = "administrateur";
    
    private PDO $pdo;

    private int $idAdmin = 0;

    private string $nomAdmin = "";

    private string $prenomAdmin = "";

    private string $emailAdmin = "";

    private string $passwordAdmin = "";

    private string $telephoneAdmin = "";

    private string $adresseAdmin = "";

    private string $imageAdmin = "";

    private string $role = "";


    
    private string $val_data = "nomAdmin = :nomAdmin, prenomAdmin = :prenomAdmin, emailAdmin = :emailAdmin, 
    passwordAdmin = :passwordAdmin, telephoneAdmin = :telephoneAdmin, adresseAdmin = :adresseAdmin, imageAdmin = :imageAdmin, 
    role = :role";

   
    public function __construct(PDO $pDO)
    {
        $this->pdo = $pDO; 
    }

    
    public function read(int $idAdmin = 0): ?PDOStatement
    {
        try {
            $sql = "SELECT * FROM $this->table WHERE 1"; 

            if ($idAdmin != 0) { 
                $this->idAdmin = $idAdmin;
                $sql .= " AND idAdmin = :idAdmin";
            }

            $stmt = $this->pdo->prepare($sql); 

            if ($idAdmin != 0) { 
                $stmt->bindParam(":idAdmin", $this->idAdmin);
            }

            

            $stmt->execute(); 

            return $stmt; 
        } catch (PDOException $e) {
            throw new Exception("Erreur lors de la lecture de l'administrateur : " . $e->getMessage()); 
        }
    }

    
    public function getAdminByEmailAndPassword(string $emailAdmin, string $passwordAdmin): ?array
    {
        try {
            $sql = "SELECT * FROM $this->table WHERE emailAdmin = :emailAdmin"; 
            $stmt = $this->pdo->prepare($sql); 
            $stmt->bindParam(':emailAdmin', $emailAdmin); 
            $stmt->execute(); 

            $administrateur = $stmt->fetch(PDO::FETCH_ASSOC); 

            if ($administrateur && password_verify($passwordAdmin, $administrateur['passwordAdmin'])) { 
                return $administrateur; 
            } else {
                return null; 
            }
        } catch (PDOException $e) {
            throw new Exception("Erreur lors de la récupération de l'utilisateur : " . $e->getMessage()); 
        }
    }

    
    public function save(int $idAdmin = 0): ?int
    {
        try {
            $emailAdmin = filter_input(INPUT_POST, 'emailAdmin', FILTER_SANITIZE_EMAIL) ?: ""; 
            $telephoneAdmin = filter_input(INPUT_POST, 'telephoneAdmin', FILTER_SANITIZE_SPECIAL_CHARS) ?: ""; 

            $emailExists = $this->emailExists($emailAdmin); 
            $phoneExists = $this->phoneExists($telephoneAdmin); 

            if ($idAdmin != 0) { 
                $sql = "UPDATE $this->table SET $this->val_data WHERE idAdmin = :idAdmin";
                $this->idAdmin = $idAdmin;
            } else {
                if ($emailExists) { 
                    throw new Exception(self::ERROR_EMAIL_EXIST);
                } elseif ($phoneExists) { 
                    throw new Exception(self::ERROR_PHONE_EXIST);
                } else {
                    $sql = "INSERT INTO $this->table SET $this->val_data"; 
                }
            }

            $this->pdo->beginTransaction(); 

            $this->prepareAdminData(); 

            if (isset($_FILES['imageAdmin']) && $_FILES['imageAdmin']['error'] === UPLOAD_ERR_OK) { 
                $imageResult = $this->processImage('imageAdmin', 'assets/imgAdmin', $this->imageAdmin);
                $this->imageAdmin = $imageResult['success'] ? $imageResult['imagePath'] : "";
            } else {
                $this->imageAdmin = filter_input(INPUT_POST, 'imageAdmin', FILTER_SANITIZE_SPECIAL_CHARS) ?: ""; 
            }

            $stmt = $this->pdo->prepare($sql); 

            if ($idAdmin != 0) { 
                $stmt->bindParam(':idAdmin', $this->idAdmin, PDO::PARAM_INT);
            }

            if ($this->bindAdminData($stmt)) { 
                if ($idAdmin != 0) {
                    $this->pdo->commit(); 
                    return $idAdmin; 
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

   
    public function emailExists(string $emailAdmin): bool
    {
        try {
            $sql = "SELECT COUNT(*) FROM $this->table WHERE emailAdmin = :emailAdmin"; 
            $stmt = $this->pdo->prepare($sql); 
            $stmt->bindParam(':emailAdmin', $emailAdmin); 
            $stmt->execute(); 

            $count = $stmt->fetchColumn(); 

            return $count > 0; 
        } catch (PDOException $e) {
            throw new Exception("Erreur lors de la vérification de l'existence de l'email : " . $e->getMessage()); 
        }
    }

    /**
     * Vérifie si un numéro de téléphone est déjà utilisé dans la base de données.
     *
     * @param string $phone Numéro de téléphone à vérifier.
     * @return bool True si le numéro de téléphone existe, false sinon.
     * @throws Exception Si une erreur de base de données se produit.
     */
    public function phoneExists(string $telephoneAdmin): bool
    {
        try {
            $sql = "SELECT COUNT(*) FROM $this->table WHERE telephoneAdmin = :telephoneAdmin"; 
            $stmt = $this->pdo->prepare($sql); 
            $stmt->bindParam(':telephoneAdmin', $telephoneAdmin); 
            $stmt->execute(); 

            $count = $stmt->fetchColumn(); 

            return $count > 0; 
        } catch (PDOException $e) {
            throw new Exception("Erreur lors de la vérification de l'existence du téléphone : " . $e->getMessage()); 
        }
    }

    
    private function prepareAdminData(): void
    {
        
        $this->nomAdmin = filter_input(INPUT_POST, 'nomAdmin', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
        $this->prenomAdmin = filter_input(INPUT_POST, 'prenomAdmin', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
        $this->emailAdmin = filter_input(INPUT_POST, 'emailAdmin', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
        $this->passwordAdmin = filter_input(INPUT_POST, 'passwordAdmin', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
        $this->telephoneAdmin = filter_input(INPUT_POST, 'telephoneAdmin', FILTER_VALIDATE_INT) ?: 0;
        $this->adresseAdmin = filter_input(INPUT_POST, 'adresseAdmin', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
        $this->imageAdmin = filter_input(INPUT_POST, 'imageAdmin', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
        $this->role = filter_input(INPUT_POST, 'role', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
    }

    
    public function processImage(string $imageInputName, string $destinationPath, string $oldImagePath = ""): array
    {
        $fileName = $_FILES[$imageInputName]['imageAdmin']; 
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

    /**
     * Lie les données à un objet PDOStatement pour l'insertion ou la mise à jour dans la base de données.
     *
     * @param PDOStatement $stmt Objet PDOStatement préparé pour l'exécution.
     * @return bool True si les données sont correctement liées et la requête exécutée, false sinon.
     */
    private function bindAdminData(PDOStatement $stmt): bool
    {
        
        $stmt->bindParam(':nomAdmin', $this->nomAdmin);
        $stmt->bindParam(':prenomAdmin', $this->prenomAdmin);
        $stmt->bindParam(':emailAdmin', $this->emailAdmin);
        $stmt->bindParam(':passwordAdmin', $this->passwordAdmin);
        $stmt->bindParam(':telephoneAdmin', $this->telephoneAdmin);
        $stmt->bindParam(':adresseAdmin', $this->adresseAdmin);
        $stmt->bindParam(':imageAdmin', $this->imageAdmin);
        $stmt->bindParam(':role', $this->role);

        if ($stmt->execute()) { 
            return true; 
        }
        return false; 
    }

    /**
     * Modifie un attribut spécifique pour un utilisateur donné.
     *
     * @param int $id ID de l'utilisateur.
     * @param string $attribute Attribut à modifier.
     * @param mixed $value Nouvelle valeur pour l'attribut.
     * @return bool True si la modification est réussie, false sinon.
     * @throws Exception Si une erreur de base de données se produit.
     */
    public function updateAttribute(int $idAdmin, string $attribute, mixed $value): bool
    {
        try {
            $sql = "UPDATE $this->table SET $attribute = :value WHERE idAdmin = :idAdmin"; 
            $stmt = $this->pdo->prepare($sql); 
            $stmt->bindParam(':value', $value); 
            $stmt->bindParam(':idAdmin', $idAdmin, PDO::PARAM_INT); 
            if ($stmt->execute()) { 
                return true; 
            } else {
                throw new Exception("Erreur lors de la modification de l'attribut."); 
            }
        } catch (PDOException $e) {
            throw new Exception("Erreur lors de la modification de l'attribut : " . $e->getMessage()); 
        }
    }

    
    public function delete(int $idAdmin = 0): bool
    {
        try {
            $sql = "DELETE FROM $this->table WHERE idAdmin = :idAdmin"; 

            $stmt = $this->pdo->prepare($sql); 

            $stmt->bindParam(':idAdmin', $idAdmin, PDO::PARAM_INT); 

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

?>