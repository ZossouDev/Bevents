<?php

class Organisateurs
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

    public function countOrganisateurs(): int {
        try {
            $sql = "SELECT COUNT(*) AS total FROM $this->table";
            $stmt = $this->pdo->query($sql);
            $result = $stmt->fetch(PDO::FETCH_ASSOC);
            return (int) $result['total'];
        } catch (PDOException $e) {
            throw new Exception("Erreur lors du comptage des organisateurs : " . $e->getMessage());
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

  
}