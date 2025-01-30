<?php
include('db_connection.php');
header('Content-Type: application/json');

$response = array();

// Check for doctor_id in request
if (isset($_GET['doctor_id'])) {
    $doctor_id = $_GET['doctor_id'];

    // Query to fetch appointments and user full name
    $query = "
    SELECT 
        a.appointment_id, 
        a.appointment_datetime, 
        a.description, 
        CONCAT(u.first_name, ' ', u.last_name) AS user_name 
    FROM 
        appointments a 
    JOIN 
        users u ON a.user_id = u.user_id 
    WHERE 
        a.doctor_id = '$doctor_id'";

    // Execute the query
    $result = mysqli_query($conn, $query);

    if ($result) {
        $appointments = array();
        while ($row = mysqli_fetch_assoc($result)) {
            $appointments[] = $row;
        }

        $response['status'] = 'success';
        $response['appointments'] = $appointments;
    } else {
        $response['status'] = 'error';
        $response['message'] = 'Failed to fetch appointments';
    }
} else {
    $response['status'] = 'error';
    $response['message'] = 'Doctor ID not provided';
}

echo json_encode($response);
?>
