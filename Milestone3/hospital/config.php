<?php

$serverName = "localhost\\SQLEXPRESS";
$databaseName = "IvorPaineHospital";

$connectionOptions = array(
    "Database" => $databaseName,
    "CharacterSet" => "UTF-8",
    "TrustServerCertificate" => true
);

function connectDB() {
    global $serverName, $connectionOptions;

    if (!function_exists('sqlsrv_connect')) {
        die("<div class='alert error'><strong>SQLSRV extension is not enabled.</strong><br>Install/enable Microsoft Drivers for PHP for SQL Server, then restart Apache/IIS.</div>");
    }

    $conn = sqlsrv_connect($serverName, $connectionOptions);

    if ($conn === false) {
        $errors = sqlsrv_errors();
        $msg = "Database connection failed.";
        if ($errors) {
            $parts = array();
            foreach ($errors as $error) {
                $parts[] = "SQLSTATE: " . $error['SQLSTATE'] . " | Code: " . $error['code'] . " | Message: " . $error['message'];
            }
            $msg .= "<br><pre>" . htmlspecialchars(implode("\n", $parts)) . "</pre>";
        }
        die("<div class='alert error'>" . $msg . "</div>");
    }

    return $conn;
}
?>
