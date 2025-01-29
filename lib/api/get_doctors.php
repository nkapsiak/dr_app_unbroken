<?php
include('db_connection.php');

$sql = "SELECT * FROM doctors";
$result = $conn->query($sql);

$doctors = array();
while ($row = $result->fetch_assoc()) {
    $doctors[] = $row;
}

echo json_encode($doctors); // Return as JSON
$conn->close();
?>