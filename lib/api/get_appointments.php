<?php
require_once 'db_connection.php';

if (isset($_GET['user_id'])) {
    $user_id = $_GET['user_id'];

    $query = "SELECT appointment_id, doctor_id, description, appointment_datetime FROM appointments WHERE user_id = $user_id";
    $result = mysqli_query($conn, $query);

    if (mysqli_num_rows($result) > 0) {
        $appointments = [];
        while ($row = mysqli_fetch_assoc($result)) {
            $appointments[] = [
                'appointment_id' => $row['appointment_id'],
                'doctor_id' => $row['doctor_id'],
                'description' => $row['description'],
                'appointment_datetime' => $row['appointment_datetime'],
            ];
        }
        echo json_encode(['status' => 'success', 'appointments' => $appointments]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'No appointments found']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'User ID not provided']);
}

mysqli_close($conn);
?>
