<?php
// Include database connection file
include('db_connection.php');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Check if reset code and new password are provided
    if (isset($_POST['reset_code']) && isset($_POST['new_password'])) {
        $reset_code = $_POST['reset_code'];
        $new_password = $_POST['new_password'];

        // Check if the reset code exists in the database
        $stmt = $conn->prepare("SELECT * FROM password_resets WHERE reset_code = ?");
        $stmt->bind_param("s", $reset_code);
        $stmt->execute();
        $result = $stmt->get_result();

        // If reset code is found
        if ($result->num_rows > 0) {
            // Reset code is valid, now proceed to update password
            $user = $result->fetch_assoc();
            $user_id = $user['user_id'];

            // Hash the new password
            $hashed_password = password_hash($new_password, PASSWORD_DEFAULT);

            // Update user's password in the users table
            $update_stmt = $conn->prepare("UPDATE users SET password = ? WHERE user_id = ?");
            $update_stmt->bind_param("si", $hashed_password, $user_id);

            if ($update_stmt->execute()) {
                // Password updated successfully
                echo json_encode(['status' => 'success', 'message' => 'Password reset successful']);
            } else {
                // Error updating password
                echo json_encode(['status' => 'error', 'message' => 'Error resetting password']);
            }
        } else {
            // Reset code not found in the database
            echo json_encode(['status' => 'error', 'message' => 'Invalid reset code']);
        }

        // Close the statement
        $stmt->close();
    } else {
        // Missing reset code or new password
        echo json_encode(['status' => 'error', 'message' => 'Missing reset code or new password']);
    }
} else {
    // Invalid request method
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}

// Close the database connection
$conn->close();
?>
