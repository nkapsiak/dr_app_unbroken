<?php
include('db_connection.php');

// Check if the user_id is provided
if (isset($_GET['user_id'])) {
    $user_id = $_GET['user_id'];

    // Prepare the SQL query to fetch user details
    $stmt = $conn->prepare("SELECT first_name, last_name FROM users WHERE user_id = ?");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $stmt->bind_result($first_name, $last_name);
    
    if ($stmt->fetch()) {
        echo json_encode([
            "status" => "success",
            "first_name" => $first_name,
            "last_name" => $last_name
        ]);
    } else {
        echo json_encode(["status" => "error", "message" => "User not found"]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "User ID not provided"]);
}

$conn->close();
?>
