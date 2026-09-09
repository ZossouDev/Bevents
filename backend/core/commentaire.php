<?php


class Commentaire
{
    private PDO $pdo;


    private int $idCommentaire = 0;

    private string $contenu= "";

    private string $dateCommentaire = "";
    
    private int $idEvent;

    private int $idVisiteur;
    
    public function __construct(PDO $pdo)
    {
          $this->pdo = $pdo;
    }

    public function get_all_commentaire(int $idCommentaire = 0): false|PDOStatement
    {
        $req = "SELECT * FROM commentaire";
        
        if ($idCommentaire != 0) {
            $this->idCommentaire = $idCommentaire;
            $req .= " WHERE idCommentaire = :idCommentaire";
        }

        $stmt = $this->pdo->prepare($req);
        
        if ($idCommentaire != 0) {
            $stmt->bindParam(':idCommentaire', $this->idCommentaire);
        }
        
        $stmt->execute();

        return $stmt;
    }
    
    public function save_commentaire(): bool
    {
        $req = "INSERT INTO commentaire(contenu, datteCommentaire, idEvent, idVisiteur) 
        VALUES (:contenu, :datteCommentaire, :idEvent, :idVisiteur)";
        
        $stmt = $this->pdo->prepare($req);
        
        $stmt->execute([
            ':contenu' => $_POST["contenu"],
            ':datteCommentaire' => $_POST["datteCommentaire"],
            ':idEvent' => $_POST["idEvent"],
            ':idVisiteur' => $_POST["idVisiteur"]

        ]);
        
        return $stmt->rowCount() > 0;
    }

    
    public function update_commentaire(): bool
    {
        $req = "UPDATE commentaire SET contenu= :contenu, datteCommentaire = :datteCommentaire, idEvent = :idEvent, idVisiteur = :idVisiteur
         WHERE idCommentaire = :idCommentaire";
        
        $stmt = $this->pdo->prepare($req);
        
        $stmt->execute([
            ':idCommentaire' => $_POST["idCommentaire"],
            ':contenu' => $_POST["contenu"],
            ':datteCommentaire' => $_POST["datteCommentaire"],
            ':idEvent' => $_POST["idEvent"]
        ]);
        
        return $stmt->rowCount() > 0;
    }



    public function delete_commentaire(): bool
    {
        $req = "DELETE FROM commentaire WHERE idCommentaire = :idCommentaire";
        
        $stmt = $this->pdo->prepare($req);
        
        $stmt->execute([
            ':idCommentaire' => $_POST["idCommentaire"]
        ]);
        
        return $stmt->rowCount() > 0;
    }

}
?>