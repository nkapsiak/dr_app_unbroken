<?php
include('db_connection.php');

// Ensure the required parameters are provided
if (isset($_GET['date']) && isset($_GET['doctor_id'])) {
    $date = $_GET['date']; // The date in the format 'Y-m-d'
    $doctor_id = $_GET['doctor_id'];

    // Query to get all booked appointment times for the specified date and doctor
    $query = "SELECT appointment_datetime FROM appointments WHERE doctor_id = ? AND DATE(appointment_datetime) = ?";
    
    // Prepare the SQL statement
    if ($stmt = $conn->prepare($query)) {
        // Bind parameters to prevent SQL injection
        $stmt->bind_param("is", $doctor_id, $date);

        // Execute the query
        $stmt->execute();

        // Get the result
        $result = $stmt->get_result();

        // Prepare an array to store the booked times
        $booked_times = [];

        // Fetch all booked appointment times
        while ($row = $result->fetch_assoc()) {
            // Get the time portion from the appointment datetime
            $appointment_time = date("h:i A", strtotime($row['appointment_datetime']));
            $booked_times[] = $appointment_time;
        }

        // Return the booked times in JSON format
        echo json_encode([
            'status' => 'success',
            'booked_times' => $booked_times
        ]);
    } else {
        // If the query failed, return an error
        echo json_encode([
            'status' => 'error',
            'message' => 'Database query failed'
        ]);
    }

    // Close the database connection
    $conn->close();
} else {
    // Return error if required parameters are missing
    echo json_encode([
        'status' => 'error',
        'message' => 'Missing required parameters'
    ]);
}
?>
