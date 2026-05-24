<?php
$currentPage = basename($_SERVER['PHP_SELF']);

function navActive($file) {
    global $currentPage;
    if ($currentPage === $file) {
        return 'active';
    }
    else {
        return '';
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IVOR Paine Memorial Hospital</title>
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
    <div class="app-shell">
        <header class="topbar">
            <a class="brand" href="index.php">
                <span class="brand-icon"></span>
                <span>
                    <strong>IVOR Hospital</strong>
                    <small>Admin Center</small>
                </span>
            </a>
            <button class="menu-toggle" type="button" aria-label="Open menu"></button>
            <nav class="main-nav">
                <a class="<?= navActive('index.php'); ?>" href="index.php">Dashboard</a>
                <a class="<?= navActive('patientRecord.php'); ?>" href="patientRecord.php">Patient Record</a>
                <a class="<?= navActive('wardRecord.php'); ?>" href="wardRecord.php">Ward Record</a>
                <a class="<?= navActive('consultantTeam.php'); ?>" href="consultantTeam.php">Consultant Team</a>
                <a class="<?= navActive('queries.php'); ?>" href="queries.php">Queries</a>
            </nav>
        </header>
        <main class="content">