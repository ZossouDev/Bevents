<?php


class Artiste
{
    private PDO $pdo;


    private int $idArtiste = 0;

    private string $nomArtiste = "";

    private string $descriptionArtiste = "";
    
    private string $imageArtiste = "";
    
    public function __construct(PDO $pdo)
    {
          $this->pdo = $pdo;
    }

    public function get_all_artiste(int $idArtiste = 0): false|PDOStatement
    {
        $req = "SELECT * FROM artiste";
        
        if ($idArtiste != 0) {
            $this->idArtiste = $idArtiste;
            $req .= " WHERE idArtiste = :idArtiste";
        }

        $stmt = $this->pdo->prepare($req);
        
        if ($idArtiste != 0) {
            $stmt->bindParam(':idArtiste', $this->idArtiste);
        }
        
        $stmt->execute();

        return $stmt;
    }
    
    public function save_artiste(): bool
    {
        $req = "INSERT INTO artiste (nomArtiste, descriptionArtiste, imageArtiste) 
        VALUES (:nomArtiste, :descriptionArtiste, :imageArtiste)";
        
        $stmt = $this->pdo->prepare($req);
        
        $stmt->execute([
            ':nomArtiste' => $_POST["nomArtiste"],
            ':descriptionArtiste' => $_POST["descriptionArtiste"],
            ':imageArtiste' => $_POST["imageArtiste"]

        ]);
        
        return $stmt->rowCount() > 0;
    }

    
    public function update_artiste(): bool
    {
        $req = "UPDATE artiste SET nomArtiste = :nomArtiste, descriptionArtiste = :descriptionArtiste, imageArtiste = :imageArtiste
         WHERE idArtiste = :idArtiste";
        
        $stmt = $this->pdo->prepare($req);
        
        $stmt->execute([
            ':idArtiste' => $_POST["idArtiste"],
            ':nomArtiste' => $_POST["nomArtiste"],
            ':descriptionArtiste' => $_POST["descriptionArtiste"],
            ':imageArtiste' => $_POST["imageArtiste"]
        ]);
        
        return $stmt->rowCount() > 0;
    }



    public function delete_artiste(): bool
    {
        $req = "DELETE FROM artiste WHERE idArtiste = :idArtiste";
        
        $stmt = $this->pdo->prepare($req);
        
        $stmt->execute([
            ':idArtiste' => $_POST["idArtiste"]
        ]);
        
        return $stmt->rowCount() > 0;
    }

}
?>