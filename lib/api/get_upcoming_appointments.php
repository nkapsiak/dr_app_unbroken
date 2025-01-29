<?php
include('db_connection.php');

// Check if the user_id is provided
if (isset($_GET['user_id'])) {
    $user_id = $_GET['user_id'];

    // Query to fetch upcoming appointments for the user
    $query = "SELECT appointments.id, doctor_id, description, appointment_datetime, users.name AS doctor_name 
              FROM appointments
              JOIN users ON appointments.doctor_id = users.id
              WHERE appointments.user_id = ? AND appointment_datetime > NOW()
              ORDER BY appointment_datetime ASC";

    // Prepare statement to prevent SQL injection
    $stmt = $conn->prepare($query);
    $stmt->bind_param("i", $user_id);

    // Execute query
    $stmt->execute();

    // Get the result
    $result = $stmt->get_result();

    // Check if appointments exist
    if ($result->num_rows > 0) {
        $appointments = [];

        // Fetch appointments as an associative array
        while ($row = $result->fetch_assoc()) {
            $appointments[] = $row;
        }

        // Return the results as JSON
        echo json_encode(["status" => "success", "appointments" => $appointments]);
    } else {
        echo json_encode(["status" => "error", "message" => "No upcoming appointments found"]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Missing user_id"]);
}

$conn->close();
?>
