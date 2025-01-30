<?php
include('db_connection.php');  // Include database connection file

$response = array();

// Check if the required POST data is received
if (isset($_POST['first_name']) && isset($_POST['last_name']) && isset($_POST['phone_number']) && isset($_POST['username']) && isset($_POST['password'])) {
    
    $first_name = $_POST['first_name'];
    $last_name = $_POST['last_name'];
    $phone_number = $_POST['phone_number'];
    $username = $_POST['username'];
    $password = $_POST['password'];

    // Step 1: Check if the name and phone number exist in the patients_info table
    $query = "SELECT * FROM patients_info WHERE first_name = ? AND last_name = ? AND phone_number = ?";
    $stmt = mysqli_prepare($conn, $query);
    mysqli_stmt_bind_param($stmt, "sss", $first_name, $last_name, $phone_number);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);

    // Step 2: If the patient info exists, proceed to register
    if (mysqli_num_rows($result) > 0) {
        // Name and phone number exist in patients_info, so proceed with registration

        // Hash the password before saving
        $password_hash = password_hash($password, PASSWORD_BCRYPT);

        // Insert the new patient record into the patients table
        $insert_query = "INSERT INTO patients (username, password_hash, first_name, last_name, phone_number) VALUES (?, ?, ?, ?, ?)";
        $insert_stmt = mysqli_prepare($conn, $insert_query);
        mysqli_stmt_bind_param($insert_stmt, "sssss", $username, $password_hash, $first_name, $last_name, $phone_number);

        if (mysqli_stmt_execute($insert_stmt)) {
            // Registration successful
            $response['status'] = 'success';
            $response['message'] = 'Patient registered successfully!';
        } else {
            // Registration failed
            $response['status'] = 'error';
            $response['message'] = 'Failed to register the patient. Please try again later.';
        }
    } else {
        // Name and phone number not found in patients_info table
        $response['status'] = 'error';
        $response['message'] = 'The name and phone number do not match any record in the system.';
    }
} else {
    // Missing required data
    $response['status'] = 'error';
    $response['message'] = 'Required data (first name, last name, phone number, username, password) missing.';
}

echo json_encode($response);  // Send the response as JSON
?>
