<?php
include('db_connection.php'); // Include your database connection

// Get the user inputs from POST request
$name = $_POST['name'];
$username = $_POST['username'];
$password = $_POST['password'];

if (!empty($name) && !empty($username) && !empty($password)) {
    // Hash the password for secure storage
    $hashed_password = password_hash($password, PASSWORD_BCRYPT);
    
    // SQL query to insert a new user
    $sql = "INSERT INTO users (name, username, password) VALUES (?, ?, ?)";
    
    // Prepare the SQL statement
    if ($stmt = $conn->prepare($sql)) {
        // Bind the parameters: s for string
        $stmt->bind_param('sss', $name, $username, $hashed_password);
        
        // Execute the statement
        if ($stmt->execute()) {
            // Get the last inserted user ID (auto-incremented)
            $user_id = $stmt->insert_id;
            
            // Return a JSON response with success status and the user ID
            echo json_encode([
                'status' => 'success',
                'message' => 'Registration successful!',
                'user_id' => $user_id  // Return the unique user ID
            ]);
        } else {
            echo json_encode([
                'status' => 'error',
                'message' => 'Failed to register user.'
            ]);
        }
        
        // Close the statement
        $stmt->close();
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Failed to prepare the SQL statement.'
        ]);
    }
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'All fields (name, username, password) are required.'
    ]);
}

// Close the database connection
$conn->close();
?>
