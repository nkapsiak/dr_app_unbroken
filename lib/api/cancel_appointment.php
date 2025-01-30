<?php
include('db_connection.php');

// Check if the required parameters are provided via POST request
if (isset($_POST['user_id'], $_POST['appointment_id'])) {
    $user_id = $_POST['user_id'];
    $appointment_id = $_POST['appointment_id'];

    // Sanitize the inputs
    $user_id = intval($user_id);  // Convert to integer
    $appointment_id = intval($appointment_id);  // Convert to integer

    // Prepare the SQL query to cancel the appointment
    $stmt = $conn->prepare("DELETE FROM appointments WHERE appointment_id = ? AND user_id = ?");
    if ($stmt === false) {
        echo json_encode(["status" => "error", "message" => "Failed to prepare SQL query"]);
        exit;
    }

    // Bind parameters and execute the query
    $stmt->bind_param("ii", $appointment_id, $user_id);
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Appointment cancelled successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to cancel appointment: " . $stmt->error]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Missing required parameters"]);
}

$conn->close();
?>
