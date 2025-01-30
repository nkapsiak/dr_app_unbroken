<?php
include('db_connection.php');

// Check if reset code and new password are provided
if (isset($_POST['reset_code'], $_POST['new_password'])) {
    $resetCode = $_POST['reset_code'];
    $newPassword = $_POST['new_password'];

    // Validate the reset code
    $stmt = $conn->prepare("SELECT user_id, expiration_time FROM password_resets WHERE reset_code = ?");
    $stmt->bind_param("i", $resetCode);
    $stmt->execute();
    $stmt->bind_result($userId, $expirationTime);
    $stmt->fetch();
    $stmt->close();

    if (!$userId) {
        echo json_encode(["status" => "error", "message" => "Invalid reset code"]);
        exit;
    }

    // Check if the reset code has expired
    if (time() > $expirationTime) {
        echo json_encode(["status" => "error", "message" => "Reset code has expired"]);
        exit;
    }

    // Update the user's password
    $newPasswordHash = password_hash($newPassword, PASSWORD_BCRYPT);
    $stmt = $conn->prepare("UPDATE users SET password = ? WHERE user_id = ?");
    $stmt->bind_param("si", $newPasswordHash, $userId);

    if ($stmt->execute()) {
        // Delete the reset code from the database
        $stmt = $conn->prepare("DELETE FROM password_resets WHERE reset_code = ?");
        $stmt->bind_param("i", $resetCode);
        $stmt->execute();

        echo json_encode(["status" => "success", "message" => "Password reset successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to reset password"]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Reset code and new password are required"]);
}

$conn->close();
?>
