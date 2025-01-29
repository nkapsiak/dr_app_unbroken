<?php
include('db_connection.php');

// Get data from the POST request
$username = $_POST['username'];
$password = $_POST['password'];
$name = $_POST['name'];
$specialty = isset($_POST['specialty']) ? $_POST['specialty'] : null; // Specialty is only for doctors
$user_type = $_POST['user_type'];

// Check if the username already exists
$sql_check = "SELECT * FROM users WHERE username = '$username'";
$result_check = $conn->query($sql_check);

if ($result_check->num_rows > 0) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Username already exists',
    ]);
    exit();
}

// Insert into users table for both user and doctor
if ($user_type == 'doctor') {
    // Register as a doctor
    $sql = "INSERT INTO doctors (name, specialty) VALUES ('$name', '$specialty')";
    $conn->query($sql);

    $sql_user = "INSERT INTO users (username, password, user_type) VALUES ('$username', '$password', 'doctor')";
    $conn->query($sql_user);

} else {
    // Register as a regular user
    $sql_user = "INSERT INTO users (username, password, user_type) VALUES ('$username', '$password', 'user')";
    $conn->query($sql_user);
}

if ($conn->affected_rows > 0) {
    echo json_encode([
        'status' => 'success',
        'message' => 'Registration successful',
    ]);
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Registration failed. Please try again later.',
    ]);
}

$conn->close();
?>
