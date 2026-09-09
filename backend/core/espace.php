<?php

class Espace
{

    private const ERROR_SAVE = "Erreur lors de l'enregistrement de l'utilisateur.";
    private const ERROR_SAVE_DB = "Erreur de sauvegarde dans la base de données : ";

    private string $table = "espace";

    private PDO $pdo;

    private int $idEspace = 0;
    private string $nomEspace = "";
    private string $descriptionEspace = "";
    private int $capacite;
    private int $prixEspace;
    private string $disponibilite = "";
    private string $imageEspace = "";
    private string $adresseEspace = "";

    private string $val_data = "nomEspace = :nomEspace, descriptionEspace = :descriptionEspace, capacite = :capacite, prixEspace = :prixEspace, 
    disponibilite = :disponibilite, imageEspace = :imageEspace, adresseEspace = :adresseEspace";

    public function __construct(PDO $pdo)
    {
        $this->pdo = $pdo;
    }

    public function read(int $idEspace = 0): ?PDOStatement
    {
        try {
            $sql = "SELECT * FROM espace WHERE 1";

            if ($idEspace != 0) {
                $this->idEspace = $idEspace;
                $sql .= " AND idEspace = :idEspace";
            }

            $stmt = $this->pdo->prepare($sql);

            if ($idEspace != 0) {
                $stmt->bindParam(":idEspace", $this->idEspace);
            }
            $stmt->execute();

            return $stmt;
        } catch (PDOException $e) {
            throw new Exception("Erreur lors de la lecture des espaces : " . $e->getmessage());
        }
    }


    public function save(int $idEspace = 0): ?int
    {
        $image = $_FILES['image'] ?? null;
        $imagePath = $this->handleImageUpload($image);

        if ($imagePath) {
            $this->imageEspace = $imagePath;
        }

        $sql = $idEspace != 0 ? "UPDATE $this->table SET $this->val_data WHERE idEspace = :idEspace" : "INSERT INTO $this->table SET $this->val_data";

        $this->idEspace = $idEspace;

        $this->pdo->beginTransaction();
        $this->prepareEspaceData();

        $stmt = $this->pdo->prepare($sql);
        $this->bindEspaceData($stmt);

        if ($idEspace != 0) {
            $stmt->bindParam(':idEspace', $this->idEspace, PDO::PARAM_INT);
        }

        if ($stmt->execute()) {
            $lastId = $idEspace != 0 ? $idEspace : $this->pdo->lastInsertId();
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
            
            $result = add_images($image['name'], $image['tmp_name'], $image['size'], $image['error'], 'assets/imgEspace/', $this->imageEspace);

            if ($result['result']) {
                return $result['message'];
            } else {
                throw new Exception($result['message']);
            }
        }
        return null;
    }

    private function prepareEspaceData(): void
    {
        $this->nomEspace = filter_input(INPUT_POST, 'nomEspace', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
        $this->descriptionEspace = filter_input(INPUT_POST, 'descriptionEspace', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
        $this->capacite = filter_input(INPUT_POST, 'capacite', FILTER_VALIDATE_INT) ?: 0;
        $this->prixEspace = filter_input(INPUT_POST, 'prixEspace', FILTER_VALIDATE_INT) ?: 0;
        $this->disponibilite = filter_input(INPUT_POST, 'disponibilite', FILTER_SANITIZE_SPECIAL_CHARS) ?: "disponible";
        // $this->imageEspace = filter_input(INPUT_POST, 'imageEspace', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
        $this->adresseEspace = filter_input(INPUT_POST, 'adresseEspace', FILTER_SANITIZE_SPECIAL_CHARS) ?: "";
    }

    private function bindEspaceData(PDOStatement $stmt): void
    {
        $stmt->bindParam(':nomEspace', $this->nomEspace);
        $stmt->bindParam(':descriptionEspace', $this->descriptionEspace);
        $stmt->bindParam(':capacite', $this->capacite);
        $stmt->bindParam(':prixEspace', $this->prixEspace);
        $stmt->bindParam(':disponibilite', $this->disponibilite);
        $stmt->bindParam(':imageEspace', $this->imageEspace);
        $stmt->bindParam(':adresseEspace', $this->adresseEspace);
    }

    public function updateAttribute(int $idEspace, string $attribute, mixed $value): bool
    {
        $sql = "UPDATE $this->table SET $attribute = :value WHERE idEspace = :idEspace";
        $stmt = $this->pdo->prepare($sql);
        $stmt->bindParam(':value', $value);
        $stmt->bindParam(':idEspace', $id, PDO::PARAM_INT);
        if ($stmt->execute()) {
            return true;
        } else {
            throw new Exception("Erreur lors de la modification de l'attribut.");
        }
    }
    
    public function delete(int $idEspace = 0): bool
    {
        try {
            $sql = "DELETE FROM $this->table WHERE idEspace = :idEspace";

            $stmt = $this->pdo->prepare($sql);

            $stmt->bindParam(':idEspace', $idEspace, PDO::PARAM_INT);

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
