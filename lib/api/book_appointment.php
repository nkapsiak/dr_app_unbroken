<?php
include('db_connection.php');
require_once 'vendor/autoload.php';  // Correct path to Twilio's autoload.php

use Twilio\Rest\Client;

// Twilio credentials
$sid = 'AC981137fbfc627a18620483026ba8a0f7';  // Your Twilio Account SID
$auth_token = '8be831168e8aafea5309923fd3215f66';  // Your Twilio Auth Token
$twilio_phone_number = '+18555128507';  // Your Twilio phone number

// Function to send SMS reminder
function sendAppointmentReminder($userPhone, $appointmentTime) {
    global $sid, $auth_token, $twilio_phone_number;

    $client = new Client($sid, $auth_token);
    $message = "Reminder: You have an appointment scheduled for $appointmentTime. Please remember to attend!";

    try {
        // Send the SMS
        $message = $client->messages->create(
            $userPhone, // User's phone number
            [
                'from' => $twilio_phone_number,
                'body' => $message,
            ]
        );
        // Log success
        error_log("Message sent to $userPhone: " . $message->sid);
    } catch (Exception $e) {
        // Log the error message if SMS fails
        error_log("Error sending SMS: " . $e->getMessage());
    }
}

// Enable error reporting (for debugging purposes)
ini_set('display_errors', 1);
error_reporting(E_ALL);

// Check if the required parameters are provided via POST request
if (isset($_POST['doctor_id'], $_POST['description'], $_POST['appointment_datetime'], $_POST['user_id'])) {
    $doctor_id = $_POST['doctor_id'];
    $description = $_POST['description'];
    $appointment_datetime = $_POST['appointment_datetime'];
    $user_id = $_POST['user_id'];

    // Get the user's phone number from the database
    $stmt = $conn->prepare("SELECT phone FROM users WHERE user_id = ?");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $stmt->bind_result($userPhone);
    $stmt->fetch();
    $stmt->close();

    // Ensure that a valid phone number was fetched
    if (empty($userPhone)) {
        echo json_encode(["status" => "error", "message" => "User phone number not found"]);
        exit;
    }

    // Insert the appointment details into the database
    $stmt = $conn->prepare("INSERT INTO appointments (doctor_id, description, appointment_datetime, user_id) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("issi", $doctor_id, $description, $appointment_datetime, $user_id);

    if ($stmt->execute()) {
        // Send the appointment reminder SMS to the user
        sendAppointmentReminder($userPhone, $appointment_datetime);
        echo json_encode(["status" => "success", "message" => "Appointment booked and reminder sent"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to book appointment"]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Missing required parameters"]);
}

// Close database connection
$conn->close();
?>
