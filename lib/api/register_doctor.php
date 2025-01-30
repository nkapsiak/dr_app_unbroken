<?php
include('db_connection.php');
header('Content-Type: application/json');

$response = array();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Assuming you have already connected to your database

    $name = $_POST['name'];
    $specialty = $_POST['specialty'];
    $username = $_POST['username'];
    $password = $_POST['password'];
    $description = $_POST['description'];

    // Sanitize inputs to prevent SQL injection (optional but recommended)
    $name = mysqli_real_escape_string($conn, $name);
    $specialty = mysqli_real_escape_string($conn, $specialty);
    $username = mysqli_real_escape_string($conn, $username);
    $description = mysqli_real_escape_string($conn, $description);

    // Hash the password using bcrypt
    $hashedPassword = password_hash($password, PASSWORD_BCRYPT);

    // Insert into the database with the hashed password
    $query = "INSERT INTO doctors (name, specialty, username, password, description) 
              VALUES ('$name', '$specialty', '$username', '$hashedPassword', '$description')";

    if (mysqli_query($conn, $query)) {
        $response['status'] = 'success';
        $response['message'] = 'Doctor registered successfully!';
    } else {
        $response['status'] = 'error';
        $response['message'] = 'Failed to register doctor';
    }
} else {
    $response['status'] = 'error';
    $response['message'] = 'Invalid request method';
}

echo json_encode($response);
?>
