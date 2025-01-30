<?php
// Include the database connection file
include('db_connection.php');

// Get the incoming SMS reply from Twilio
$Body = $_POST['Body'];  // User's reply (YES or NO)
$From = $_POST['From'];  // User's phone number

// Check the reply and process accordingly
if (strtoupper(trim($Body)) == 'YES') {
    // Find the user's appointment based on phone number
    $stmt = $conn->prepare("SELECT appointment_id FROM appointments WHERE user_id = (SELECT user_id FROM users WHERE phone = ?)");
    $stmt->bind_param("s", $From);
    $stmt->execute();
    $stmt->bind_result($appointment_id);

    // If the appointment exists, cancel it
    if ($stmt->fetch()) {
        // Update the appointment status to "cancelled"
        $cancel_stmt = $conn->prepare("UPDATE appointments SET status = 'cancelled' WHERE appointment_id = ?");
        $cancel_stmt->bind_param("i", $appointment_id);
        $cancel_stmt->execute();

        // Respond to Twilio with a confirmation message
        echo "Your appointment has been cancelled.";
    } else {
        echo "No appointment found for this phone number.";
    }
    
    $stmt->close();
} else {
    // If the reply is not "YES", leave the appointment unchanged
    echo "Your appointment remains scheduled.";
}

$conn->close();
?>
