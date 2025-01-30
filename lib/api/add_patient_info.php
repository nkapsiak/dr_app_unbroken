<?php
include('db_connection.php');  // Include database connection file

$response = array();

// Check if the required POST data is received
if (isset($_POST['first_name']) && isset($_POST['last_name']) && isset($_POST['phone_number'])) {
    
    $first_name = $_POST['first_name'];
    $last_name = $_POST['last_name'];
    $phone_number = $_POST['phone_number'];

    // Step 1: Check if the phone number already exists
    $check_query = "SELECT * FROM patients_info WHERE phone_number = ?";
    $stmt = mysqli_prepare($conn, $check_query);
    mysqli_stmt_bind_param($stmt, "s", $phone_number);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);

    if (mysqli_num_rows($result) > 0) {
        // Phone number already exists
        $response['status'] = 'error';
        $response['message'] = 'This phone number is already registered.';
    } else {
        // Step 2: Insert the new patient information into the patients_info table
        $insert_query = "INSERT INTO patients_info (first_name, last_name, phone_number) VALUES (?, ?, ?)";
        $insert_stmt = mysqli_prepare($conn, $insert_query);
        mysqli_stmt_bind_param($insert_stmt, "sss", $first_name, $last_name, $phone_number);

        if (mysqli_stmt_execute($insert_stmt)) {
            // Insertion successful
            $response['status'] = 'success';
            $response['message'] = 'Patient information added successfully!';
        } else {
            // Insertion failed
            $response['status'] = 'error';
            $response['message'] = 'Failed to add patient information. Please try again later.';
        }
    }
} else {
    // Missing required data
    $response['status'] = 'error';
    $response['message'] = 'Required data (first name, last name, phone number) missing.';
}

echo json_encode($response);  // Send the response as JSON
?>
