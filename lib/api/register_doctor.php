<?php
include('db_connection.php'); // Include the correct MySQL connection file

// Check if POST request contains necessary data
if (isset($_POST['name']) && isset($_POST['specialty']) && isset($_POST['username']) && isset($_POST['password'])) {
    $name = mysqli_real_escape_string($conn, $_POST['name']);
    $specialty = mysqli_real_escape_string($conn, $_POST['specialty']);
    $username = mysqli_real_escape_string($conn, $_POST['username']);
    $password = mysqli_real_escape_string($conn, $_POST['password']);
    
    // Hash the password before storing
    $hashed_password = password_hash($password, PASSWORD_DEFAULT);
    
    // SQL query to insert doctor data into the database
    $sql = "INSERT INTO doctors (name, specialty, username, password) VALUES ('$name', '$specialty', '$username', '$hashed_password')";
    
    if ($conn->query($sql) === TRUE) {
        // Send success response
        echo json_encode(['status' => 'success', 'message' => 'Doctor registered successfully!']);
    } else {
        // Send error response
        echo json_encode(['status' => 'error', 'message' => 'Failed to register doctor: ' . $conn->error]);
    }
} else {
    // Send error response if required fields are missing
    echo json_encode(['status' => 'error', 'message' => 'Missing required fields']);
}

$conn->close();
?>
