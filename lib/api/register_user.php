<?php
include('db_connection.php');  // Include database connection file

$response = array();

ini_set('display_errors', 1);
error_reporting(E_ALL);


if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Ensure all the required fields are sent
    if (isset($_POST['first_name']) && isset($_POST['last_name']) && isset($_POST['phone_number']) && isset($_POST['username']) && isset($_POST['password'])) {

        // Get data from POST request
        $first_name = $_POST['first_name'];
        $last_name = $_POST['last_name'];
        $phone_number = $_POST['phone_number'];
        $username = $_POST['username'];
        $password = $_POST['password'];

        // Step 1: Check if the patient exists in the patients_info table
        $check_query = "SELECT * FROM patients_info WHERE phone_number = ? AND first_name = ? AND last_name = ?";
        $stmt = mysqli_prepare($conn, $check_query);
        mysqli_stmt_bind_param($stmt, "sss", $phone_number, $first_name, $last_name);
        mysqli_stmt_execute($stmt);
        $result = mysqli_stmt_get_result($stmt);

        if (mysqli_num_rows($result) > 0) {
            // Patient is registered, proceed with user registration
            
            // Hash the password before storing it
            $hashed_password = password_hash($password, PASSWORD_DEFAULT);
            
            // Insert into users table
            $insert_query = "INSERT INTO users (username, password, first_name, last_name, phone_number) VALUES (?, ?, ?, ?, ?)";
            $insert_stmt = mysqli_prepare($conn, $insert_query);
            mysqli_stmt_bind_param($insert_stmt, "sssss", $username, $hashed_password, $first_name, $last_name, $phone_number);
            
            if (mysqli_stmt_execute($insert_stmt)) {
                $response['status'] = 'success';
                $response['message'] = 'User registered successfully!';
            } else {
                $response['status'] = 'error';
                $response['message'] = 'Failed to register user. Please try again later.';
            }
        } else {
            // Patient not found in the patients_info table
            $response['status'] = 'error';
            $response['message'] = 'This patient is not registered in our system. Please check the provided details.';
        }
    } else {
        $response['status'] = 'error';
        $response['message'] = 'Missing required fields.';
    }
} else {
    $response['status'] = 'error';
    $response['message'] = 'Invalid request method.';
}

echo json_encode($response);  // Return the response as JSON
?>
