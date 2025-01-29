<?php
// Enable error reporting to catch any issues
ini_set('display_errors', 1);
error_reporting(E_ALL);

// Include the MySQL connection file
include('db_connection.php');

// Set the correct content type header
header('Content-Type: application/json');

// Clean any output buffers to avoid accidental HTML output
ob_clean();
flush();

// Check if POST request contains necessary data
if (isset($_POST['username']) && isset($_POST['password'])) {
    $username = mysqli_real_escape_string($conn, $_POST['username']);
    $password = mysqli_real_escape_string($conn, $_POST['password']);
    
    // SQL query to check if the doctor exists in the database
    $sql = "SELECT * FROM doctors WHERE username='$username'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        // Doctor found, check the password
        $row = $result->fetch_assoc();
        
        // Check if the password matches
        if (password_verify($password, $row['password'])) {
            // Login successful, return doctor details
            $doctor_id = $row['doctor_id'];  // Fetch doctor_id from the result

            // Ensure doctor_id is returned properly
            if ($doctor_id !== null) {
                echo json_encode([
                    'status' => 'success',
                    'message' => 'Doctor logged in successfully!',
                    'doctor_id' => $doctor_id  // Include doctor_id in the response
                ]);
            } else {
                // Handle case where doctor_id is null
                echo json_encode([
                    'status' => 'error',
                    'message' => 'Doctor ID is missing or invalid'
                ]);
            }
        } else {
            // Password is incorrect
            echo json_encode([
                'status' => 'error',
                'message' => 'Invalid username or password'
            ]);
        }
    } else {
        // Doctor not found
        echo json_encode([
            'status' => 'error',
            'message' => 'Invalid username or password'
        ]);
    }
} else {
    // Send error response if required fields are missing
    echo json_encode([
        'status' => 'error',
        'message' => 'Missing required fields'
    ]);
}

$conn->close();
?>
