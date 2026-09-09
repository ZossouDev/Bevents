<?php


class Ticket
{
    private PDO $pdo;


    private int $idTicket = 0;

    private int $nbreTicket;

    private string $dateAchat = "";
    
    private int $montant;
    
    public function __construct(PDO $pdo)
    {
          $this->pdo = $pdo;
    }

    public function get_all_ticket(int $idTicket = 0): false|PDOStatement
    {
        $req = "SELECT * FROM ticket";
        
        if ($idTicket != 0) {
            $this->idTicket = $idTicket;
            $req .= " WHERE idTicket = :idTicket";
        }

        $stmt = $this->pdo->prepare($req);
        
        if ($idTicket != 0) {
            $stmt->bindParam(':idTicket', $this->idTicket);
        }
        
        $stmt->execute();

        return $stmt;
    }
    
    public function save_ticket(): bool
    {
        $req = "INSERT INTO ticket (nbreTicket, dateAchat, montant) 
        VALUES (:nbreTicket, :dateAchat, :montant)";
        
        $stmt = $this->pdo->prepare($req);
        
        $stmt->execute([
            ':nbreTicket' => $_POST["nbreTicket"],
            ':dateAchat' => $_POST["dateAchat"],
            ':montant' => $_POST["montant"]

        ]);
        
        return $stmt->rowCount() > 0;
    }

    
    public function update_ticket(): bool
    {
        $req = "UPDATE ticket SET nbreTicket= :nbreTicket, dateAchat = :dateAchat, montant = :montant
         WHERE idTicket = :idTicket";
        
        $stmt = $this->pdo->prepare($req);
        
        $stmt->execute([
            ':idTicket' => $_POST["idTicket"],
            ':nbreTicket' => $_POST["nbreTicket"],
            ':dateAchat' => $_POST["dateAchat"],
            ':montant' => $_POST["montant"]
        ]);
        
        return $stmt->rowCount() > 0;
    }



    public function delete_ticket(): bool
    {
        $req = "DELETE FROM ticket WHERE idTicket = :idTicket";
        
        $stmt = $this->pdo->prepare($req);
        
        $stmt->execute([
            ':idTicket' => $_POST["idTicket"]
        ]);
        
        return $stmt->rowCount() > 0;
    }

}
?>