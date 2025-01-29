<?php
include('db_connection.php');

// Log the incoming request for debugging
error_log("Received parameters: " . json_encode($_POST));

// Check if all required parameters are provided
if (isset($_POST['doctor_id'], $_POST['description'], $_POST['appointment_datetime'], $_POST['user_id'])) {
    $doctor_id = $_POST['doctor_id'];
    $description = $_POST['description'];
    $appointment_datetime = $_POST['appointment_datetime'];
    $user_id = $_POST['user_id']; // Ensure user_id is received

    // Validate datetime format (expected format: Y-m-d H:i:s)
    $datetime = DateTime::createFromFormat('Y-m-d\TH:i:s.u', $appointment_datetime); // Adjusted format to match the incoming datetime string
    if (!$datetime) {
        echo json_encode(["status" => "error", "message" => "Invalid datetime format. Expected format: 'Y-m-d H:i:s'"]);
        exit;
    }

     // Check if user_id exists in the users table (to maintain foreign key constraint)
     $user_check_query = $conn->prepare("SELECT user_id FROM users WHERE user_id = ?");
     $user_check_query->bind_param("i", $user_id);
     $user_check_query->execute();
     $user_check_query->store_result();
 
     if ($user_check_query->num_rows === 0) {
         echo json_encode(["status" => "error", "message" => "Invalid user_id"]);
         exit;
     }
 
     // Prepare SQL query to prevent SQL injection
     $stmt = $conn->prepare("INSERT INTO appointments (doctor_id, description, appointment_datetime, user_id) VALUES (?, ?, ?, ?)");
     $stmt->bind_param("issi", $doctor_id, $description, $appointment_datetime, $user_id);
 
     if ($stmt->execute()) {
         echo json_encode(["status" => "success"]);
     } else {
         // Log the error for debugging purposes
         error_log("Database error: " . $stmt->error);
         echo json_encode(["status" => "error", "message" => "Failed to book appointment"]);
     }
 
     $stmt->close();
 } else {
     echo json_encode(["status" => "error", "message" => "Missing required parameters"]);
 }
 
 $conn->close();
 ?>