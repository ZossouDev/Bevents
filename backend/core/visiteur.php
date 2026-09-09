<?php


class Visiteur
{
    private PDO $pdo;


    private int $idVisiteur = 0;

    private string $nomVisiteur = "";

    private string $prenomVisiteur = "";

    private string $emailVisiteur = "";

    private string $passwordVisiteur = "";

    private string $telephoneVisiteur = "";
    
    private string $adresseVisiteur = "";
    
    public function __construct(PDO $pdo)
    {
          $this->pdo = $pdo;
    }

    public function get_all_visiteur(int $idVisiteur = 0): false|PDOStatement
    {
        $req = "SELECT * FROM visiteur";
        
        if ($idVisiteur != 0) {
            $this->idVisiteur = $idVisiteur;
            $req .= " WHERE idVisiteur = :idVisiteur";
        }

        $stmt = $this->pdo->prepare($req);
        
        if ($idVisiteur != 0) {
            $stmt->bindParam(':idVisiteur', $this->idVisiteur);
        }
        
        $stmt->execute();

        return $stmt;
    }
    
    // public function get_user_by_id(int $id = 0): false|PDOStatement
    // {
    //     // $id = $_GET["id"];
        
    //     $this->id = $id;
        
    //     $req = "SELECT * FROM users WHERE id = :id";

    //     $stmt = $this->pdo->prepare($req);
        
    //     $stmt->bindParam(':id', $this->id);
        
    //     $stmt->execute();

    //     return $stmt;
    // }
    
    public function save_visiteur(): bool
    {
        $req = "INSERT INTO visiteur (nomVisiteur, prenomVisiteur, emailVisiteur, passwordVisiteur, telephoneVisiteur, adresseVisiteur 
        VALUES (:nomVisiteur, :prenomVisiteur, :emailVisiteur, :passwordVisiteur, :telephoneVisiteur, :adresseVisiteur)";
        
        $stmt = $this->pdo->prepare($req);
        
        $stmt->execute([
            ':nomVisiteur' => $_POST["nomVisiteur"],
            ':prenomVisiteur' => $_POST["prenomVisiteur"],
            ':emailVisiteur' => $_POST["emailVisiteur"],
            ':passwordVisiteur' => $_POST["passwordVisiteur"],
            ':telephoneVisiteur' => $_POST["telephoneVisiteur"],
            ':adresseVisiteur' => $_POST["adresseVisiteur"]

        ]);
        
        return $stmt->rowCount() > 0;
    }

    
    public function update_visiteur(): bool
    {
        $req = "UPDATE visiteur SET nomVisiteur = :nomVisiteur, prenomVisiteur = :prenomVisiteur, emailVisiteur = :emailVisiteur, passwordVisiteur = :passwordVisiteur, telephoneVisiteur = :telephoneVisiteur, adresseVisiteur = :adresseVisiteur
         WHERE idVisiteur = :idVisiteur";
        
        $stmt = $this->pdo->prepare($req);
        
        $stmt->execute([
            ':idVisiteur' => $_POST["idVisiteur"],
            ':nomVisiteur' => $_POST["nomVisiteur"],
            ':prenomVisiteur' => $_POST["prenomVisiteur"],
            ':emailVisiteur' => $_POST["emailVisiteur"],
            ':passwordVisiteur' => $_POST["passwordVisiteur"],
            ':telephoneVisiteur' => $_POST["telephoneVisiteur"],
            ':adresseVisiteur' => $_POST["adresseVisiteur"]
        ]);
        
        return $stmt->rowCount() > 0;
    }



    public function delete_visiteur(): bool
    {
        $req = "DELETE FROM visiteur WHERE idVisiteur = :idVisiteur";
        
        $stmt = $this->pdo->prepare($req);
        
        $stmt->execute([
            ':idVisiteur' => $_POST["idVisiteur"]
        ]);
        
        return $stmt->rowCount() > 0;
    }

}
?>