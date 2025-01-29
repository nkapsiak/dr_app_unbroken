<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['username']) && isset($_POST['password'])) {
        $username = $_POST['username'];
        $password = $_POST['password'];

        $mysqli = new mysqli("localhost", "root", "", "doctor_appointment");

        if ($mysqli->connect_error) {
            echo json_encode(['status' => 'error', 'message' => 'Database connection failed']);
            exit;
        }

        // Query to get user data
        $query = "SELECT user_id, username, password FROM users WHERE username = ?";
        $stmt = $mysqli->prepare($query);
        $stmt->bind_param("s", $username);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            $user = $result->fetch_assoc();

            // Check if password matches (use password_verify for hashed passwords)
            if (password_verify($password, $user['password'])) {
                echo json_encode([
                    'status' => 'success',
                    'message' => 'Login successful',
                    'user_id' => $user['user_id'],
                    'username' => $user['username']
                ]);
            } else {
                echo json_encode(['status' => 'error', 'message' => 'Invalid login credentials']);
            }
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Invalid login credentials']);
        }

        $mysqli->close();
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Missing parameters']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}
?>
