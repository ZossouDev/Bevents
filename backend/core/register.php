<?php
class Register
{
    private PDO $pdo;

    private int $idOrga = 0;

    private string $nomOrga = "";

    private string $prenomOrga = "";

    private string $emailOrga = "";

    private string $passwordOrga = "";

    private string $telephoneOrga = "";

    private string $adresseOrga = "";

    private string $imageOrga = "";

    public function __construct(PDO $pdo)
    {
        $this->pdo = $pdo;
    }

    public function getOrganisateur(int $idOrga = 0): false|PDOStatement
    {
        $req = "SELECT * FROM organisateur";
        
        if ($idOrga != 0) {
            $this->idOrga = $idOrga;
            $req .= " WHERE idOrga = :idOrga";
        }

        $stmt = $this->pdo->prepare($req);
        
        if ($idOrga != 0) {
            $stmt->bindParam(':idOrga', $this->idOrga);
        }
        
        $stmt->execute();

        return $stmt;
    }

    public function registerOrganisateur($nomOrga, $prenomOrga, $emailOrga, $passwordOrga)
    {
        $req = "INSERT INTO organisateur (nomOrga, prenomOrga, emailOrga, passwordOrga) VALUES (:nomOrga, :prenomOrga, :emailOrga, :passwordOrga)";
        
        $stmt = $this->pdo->prepare($req);
        
        $stmt->execute([
            ':nomOrga' => $nomOrga,
            ':prenomOrga' => $prenomOrga,
            ':emailOrga' => $emailOrga,
            ':passwordOrga' => $passwordOrga,
        ]);
        
        return $stmt->rowCount() > 0;
    }

    public function loginOrganisateur($email, $password)
    {
        // Requête pour l'administrateur
        $req_admin = "SELECT * FROM administrateur WHERE emailAdmin = :emailAdmin AND passwordAdmin = :passwordAdmin";
        
        // Préparation de la requête pour l'administrateur
        $stmt_admin = $this->pdo->prepare($req_admin);
        
        // Exécution de la requête pour l'administrateur
        $stmt_admin->execute([
            ':emailAdmin' => $email,
            ':passwordAdmin' => $password
        ]);
        
        // Vérification si l'administrateur existe
        $admin = $stmt_admin->fetch(PDO::FETCH_ASSOC);
        if ($admin) {
            // L'administrateur a été trouvé, retournez ses informations
            return $admin;
        }

        // Requête pour l'organisateur
        $req_orga = "SELECT * FROM organisateur WHERE emailOrga = :emailOrga AND passwordOrga = :passwordOrga";
        
        // Préparation de la requête pour l'organisateur
        $stmt_orga = $this->pdo->prepare($req_orga);
        
        // Exécution de la requête pour l'organisateur
        $stmt_orga->execute([
            ':emailOrga' => $email,
            ':passwordOrga' => $password
        ]);
        
        // Récupération des informations de l'organisateur
        $organisateur = $stmt_orga->fetch(PDO::FETCH_ASSOC);
        
        // Retourner les informations de l'organisateur s'il existe, sinon retourner null
        return $organisateur;
    }

    /*public function loginOrganisateur($emailOrga, $passwordOrga)
    {
        $req = "SELECT * FROM organisateur WHERE emailOrga = :emailOrga AND passwordOrga = :passwordOrga";
        
        $stmt = $this->pdo->prepare($req);
        
        $stmt->execute([
            ':emailOrga' => $emailOrga,
            ':passwordOrga' => $passwordOrga
        ]);
        
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }*/
}
?>
