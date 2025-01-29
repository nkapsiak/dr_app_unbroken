<?php
include('db_connection.php');

// Get data from the POST request
$username = $_POST['username'];
$password = $_POST['password'];

// Query the database to check if the username and password match
$sql = "SELECT * FROM users WHERE username = '$username' AND password = '$password'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // User found, login success
    $user = $result->fetch_assoc();
    echo json_encode([
        'status' => 'success',
        'message' => 'Login successful',
        'user' => $user,
    ]);
} else {
    // No matching user found
    echo json_encode([
        'status' => 'error',
        'message' => 'Invalid username or password',
    ]);
}

$conn->close();
?>
