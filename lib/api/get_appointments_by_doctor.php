<?php
require_once 'db_connection.php';

if (isset($_GET['doctor_id'])) {
    $doctor_id = $_GET['doctor_id'];

    // SQL query to get appointments for the doctor
    $query = "SELECT a.appointment_id, a.user_id, u.username AS user_name, a.description, a.appointment_datetime
              FROM appointments a
              JOIN users u ON a.user_id = u.user_id
              WHERE a.doctor_id = $doctor_id";

    $result = mysqli_query($conn, $query);

    if (mysqli_num_rows($result) > 0) {
        $appointments = [];
        while ($row = mysqli_fetch_assoc($result)) {
            $appointments[] = [
                'appointment_id' => $row['appointment_id'],
                'user_name' => $row['user_name'],
                'description' => $row['description'],
                'appointment_datetime' => $row['appointment_datetime'],
            ];
        }
        echo json_encode(['status' => 'success', 'appointments' => $appointments]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'No appointments found']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Doctor ID not provided']);
}

mysqli_close($conn);
?>
