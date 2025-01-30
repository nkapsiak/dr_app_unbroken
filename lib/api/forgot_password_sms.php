<?php
include('db_connection.php');
require_once 'vendor/autoload.php'; // Twilio SDK

use Twilio\Rest\Client;

// Twilio credentials
$sid = 'AC981137fbfc627a18620483026ba8a0f7';
$auth_token = '8be831168e8aafea5309923fd3215f66';
$twilio_phone_number = '+18555128507';

function sendPasswordResetCode($userPhone, $resetCode) {
    global $sid, $auth_token, $twilio_phone_number;

    $client = new Client($sid, $auth_token);
    $message = "Your password reset code is: $resetCode";

    $client->messages->create(
        $userPhone, // User's phone number
        [
            'from' => $twilio_phone_number,
            'body' => $message,
        ]
    );
}

// Check if phone number is provided
if (isset($_POST['phone'])) {
    $userPhone = $_POST['phone'];

    // Check if the phone number exists in the database
    $stmt = $conn->prepare("SELECT user_id FROM users WHERE phone = ?");
    $stmt->bind_param("s", $userPhone);
    $stmt->execute();
    $stmt->bind_result($userId);
    $stmt->fetch();
    $stmt->close();

    if (!$userId) {
        echo json_encode(["status" => "error", "message" => "Phone number not found"]);
        exit;
    }

    // Generate a random 6-digit reset code
    $resetCode = rand(100000, 999999);

    // Store the reset code in the database (along with expiration time)
    $expirationTime = time() + 300; // Code expires in 5 minutes
    $stmt = $conn->prepare("INSERT INTO password_resets (user_id, reset_code, expiration_time) VALUES (?, ?, ?)");
    $stmt->bind_param("isi", $userId, $resetCode, $expirationTime);

    if ($stmt->execute()) {
        // Send the reset code to the user's phone
        sendPasswordResetCode($userPhone, $resetCode);
        echo json_encode(["status" => "success", "message" => "Password reset code sent"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to generate reset code"]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Phone number is required"]);
}

$conn->close();
?>
