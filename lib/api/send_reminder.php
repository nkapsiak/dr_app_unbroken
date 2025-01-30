<?php
include('db_connection.php');
require_once '/path/to/vendor/autoload.php'; // Include Twilio SDK

use Twilio\Rest\Client;

$sid = 'AC981137fbfc627a18620483026ba8a0f7';
$auth_token = '8be831168e8aafea5309923fd3215f66';
$twilio_phone_number = '+18555128507'; // Your Twilio phone number

// Function to send SMS reminder
function sendAppointmentReminder($userPhone, $appointmentTime) {
    global $sid, $auth_token, $twilio_phone_number;

    $client = new Client($sid, $auth_token);
    $message = "Reminder: You have an appointment scheduled for $appointmentTime. Please remember to attend!";
    
    $client->messages->create(
        $userPhone, // User's phone number
        [
            'from' => $twilio_phone_number,
            'body' => $message,
        ]
    );
}

// Assuming the POST request sends the necessary appointment details
if (isset($_POST['doctor_id'], $_POST['description'], $_POST['appointment_datetime'], $_POST['user_id'])) {
    $doctor_id = $_POST['doctor_id'];
    $description = $_POST['description'];
    $appointment_datetime = $_POST['appointment_datetime'];
    $user_id = $_POST['user_id'];

    // Get the user's phone number
    $stmt = $conn->prepare("SELECT phone FROM users WHERE id = ?");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $stmt->bind_result($userPhone);
    $stmt->fetch();
    $stmt->close();

    // Insert appointment into the database
    $stmt = $conn->prepare("INSERT INTO appointments (doctor_id, description, appointment_datetime, user_id) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("issi", $doctor_id, $description, $appointment_datetime, $user_id);

    if ($stmt->execute()) {
        // Send the appointment reminder
        sendAppointmentReminder($userPhone, $appointment_datetime);
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to book appointment"]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Missing required parameters"]);
}

$conn->close();
?>
