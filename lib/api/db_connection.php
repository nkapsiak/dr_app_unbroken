<?php
$servername = "localhost"; // If using localhost, it should be 'localhost'
$username = "root";        // Default MySQL username for XAMPP or WAMP
$password = "";            // Default password for root (empty)
$dbname = "doctor_appointment"; // Database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
