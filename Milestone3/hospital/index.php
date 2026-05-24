<?php
require_once __DIR__ . '/includes/database.php';
require_once __DIR__ . '/includes/header.php';

$error = '';
$counts = array('patients' => 0, 'doctors' => 0, 'wards' => 0, 'careUnits' => 0, 'treatments' => 0, 'complaints' => 0);
$recentTreatments = array();
$complaintSummary = array();
$wardOccupancy = array();

try {
    $counts = getDashboardCounts();
    $recentTreatments = getRecentTreatments();
    $complaintSummary = getComplaintSummary();
    $wardOccupancy = getWardOccupancy();
}
catch (Exception $ex) {
    $error = $ex->getMessage();
}
?>

<?php if ($error): ?>
    <div class="alert error"><strong>Database error:</strong><pre><?= e($error); ?></pre></div>
<?php endif; ?>

<section class="hero">
    <div class="hero-card">
        <div>
            <h1 class="page-title">Hospital <span>Admin Center</span></h1>
            <p class="subtitle">Welcome to the IVOR Paine Memorial Hospital database front end. Use the top menu to open manual forms, reports, and the 12 required SQL Server queries.</p>
        </div>
        <div class="doctor-illustration" aria-hidden="true"></div>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <span class="icon"></span>
            <small>Total Patients</small>
            <strong><?= e($counts['patients']); ?></strong>
        </div>
        <div class="stat-card">
            <span class="icon"></span>
            <small>Total Doctors</small>
            <strong><?= e($counts['doctors']); ?></strong>
        </div>
        <div class="stat-card">
            <span class="icon"></span>
            <small>Total Wards</small>
            <strong><?= e($counts['wards']); ?></strong>
        </div>
        <div class="stat-card">
            <span class="icon"></span>
            <small>Care Units</small>
            <strong><?= e($counts['careUnits']); ?></strong>
        </div>
        <div class="stat-card">
            <span class="icon"></span>
            <small>Treatment Records</small>
            <strong><?= e($counts['treatments']); ?></strong>
        </div>
        <div class="stat-card">
            <span class="icon"></span>
            <small>Complaints</small>
            <strong><?= e($counts['complaints']); ?></strong>
        </div>
    </div>
</section>

<section class="actions-grid">
    <a class="action-card" href="patientRecord.php"><span></span><strong>Open Patient Record</strong></a>
    <a class="action-card" href="wardRecord.php"><span></span><strong>Open Ward Report</strong></a>
    <a class="action-card" href="consultantTeam.php"><span></span><strong>Open Consultant Team</strong></a>
    <a class="action-card" href="queries.php"><span></span><strong>Run Queries</strong></a>
</section>

<section class="dashboard-grid dashboard-grid-main">
    <div class="panel">
        <div class="panel-title">
            <div>
                <h2>Recent Activities</h2>
                <p>Latest treatment records from the database.</p>
            </div>
            <span class="code-pill">Live SQL</span>
        </div>
        <?php renderTable($recentTreatments, 'No recent treatment records found.'); ?>
    </div>

    <div class="panel">
        <div class="panel-title">
            <div>
                <h3>Diseases Summary</h3>
                <p>Complaint count based on treatment records.</p>
            </div>
        </div>
        <?php
        if (empty($complaintSummary)) {
            echo "<div class='empty-state'>No complaint summary available.</div>";
        }
        else {
            $max = max(array_map(function ($r)
            {
                return (int)$r['TotalCases'];
            }, $complaintSummary));

            echo "<div class='chart-list'>";
            foreach ($complaintSummary as $row) {
                if ($max > 0) {
                    $percent = round(((int)$row['TotalCases'] / $max) * 100);
                }
                else {
                    $percent = 0;
                }
                echo "<div class='chart-row'><span>" . e($row['Complaint']) . "</span><div class='bar'><span style='width:" . e($percent) . "%'></span></div><strong>" . e($row['TotalCases']) . "</strong></div>";
            }
            echo "</div>";
        }
        ?>
    </div>

    <div class="panel">
        <div class="panel-title">
            <div>
                <h3>Ward Occupancy</h3>
                <p>Currently admitted patients by ward.</p>
            </div>
        </div>
        <?php renderTable($wardOccupancy, 'No ward data found.'); ?>
    </div>
</section>

<?php require_once __DIR__ . '/includes/footer.php'; ?>