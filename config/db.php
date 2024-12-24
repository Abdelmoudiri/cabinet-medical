<?php
$db = new mysqli(DB_HOST, DB_USERNAME, DB_PASSWORD, DB_NAME);

        if ($this->connection->connect_error) {
            die("<h1>Erreur : Échec de connexion à la base de données. " . $db->connect_error . "</h1>");
        }

        echo "<h1>Connexion réussie à la base de données</h1>";
?>