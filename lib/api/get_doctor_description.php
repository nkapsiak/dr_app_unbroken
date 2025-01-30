<?php
include('db_connection.php');
header('Content-Type: application/json');

$response = array();

if (isset($_GET['doctor_id'])) {
    $doctor_id = $_GET['doctor_id'];

    // Sanitize the input to prevent SQL injection
    $doctor_id = mysqli_real_escape_string($conn, $doctor_id);

    // Query to fetch the doctor's description
    $query = "SELECT description FROM doctors WHERE doctor_id = '$doctor_id'";
    $result = mysqli_query($conn, $query);

    if ($result) {
        $row = mysqli_fetch_assoc($result);
        if ($row) {
            $response['status'] = 'success';
            $response['description'] = $row['description'];
        } else {
            $response['status'] = 'error';
            $response['message'] = 'Doctor not found';
        }
    } else {
        $response['status'] = 'error';
        $response['message'] = 'Error fetching doctor description';
    }
} else {
    $response['status'] = 'error';
    $response['message'] = 'Doctor ID not provided';
}

echo json_encode($response);
?>
