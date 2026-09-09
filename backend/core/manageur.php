<?php


class Manageur
{
    private PDO $pdo;


    private int $idManageur = 0;

    private string $nomManageur = "";

    private string $emailManageur = "";
    
    private string $telManageur = "";

    private int $idArtiste;
    
    public function __construct(PDO $pdo)
    {
          $this->pdo = $pdo;
    }

    public function get_all_manageur(int $idManageur = 0): false|PDOStatement
    {
        $req = "SELECT * FROM manageur";
        
        if ($idManageur != 0) {
            $this->idManageur = $idManageur;
            $req .= " WHERE idManageur = :idManageur";
        }

        $stmt = $this->pdo->prepare($req);
        
        if ($idManageur != 0) {
            $stmt->bindParam(':idManageur', $this->idManageur);
        }
        
        $stmt->execute();

        return $stmt;
    }
    
    public function save_manageur(): bool
    {
        $req = "INSERT INTO manageur (nomManageur, emailManageur, telManageur, idArtiste) 
        VALUES (:nomManageur, :emailManageur, :telManageur, :idArtiste)";
        
        $stmt = $this->pdo->prepare($req);
        
        $stmt->execute([
            ':nomManageur' => $_POST["nomManageur"],
            ':emailManageur' => $_POST["emailManageur"],
            ':telManageur' => $_POST["telManageur"], 
            ':idArtiste' => $_POST["idArtiste"]

        ]);
        
        return $stmt->rowCount() > 0;
    }

    
    public function update_manageur(): bool
    {
        $req = "UPDATE manageur SET nomManageur = :nomManageur, emailManageur = :emailManageur, telManageur = :telManageur, idArtiste = :idArtiste
         WHERE idManageur = :idManageur";
        
        $stmt = $this->pdo->prepare($req);
        
        $stmt->execute([
            ':idManageur' => $_POST["idManageur"],
            ':nomManageur' => $_POST["nomManageur"],
            ':emailManageur' => $_POST["emailManageur"],
            ':telManageur' => $_POST["telManageur"],
            ':idArtiste' => $_POST["idArtiste"]
        ]);
        
        return $stmt->rowCount() > 0;
    }



    public function delete_manageur(): bool
    {
        $req = "DELETE FROM manageur WHERE idManageur = :idManageur";
        
        $stmt = $this->pdo->prepare($req);
        
        $stmt->execute([
            ':idManageur' => $_POST["idManageur"]
        ]);
        
        return $stmt->rowCount() > 0;
    }

}
?>