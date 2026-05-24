<?php
require_once __DIR__ . '/includes/hospitalQueries.php';
require_once __DIR__ . '/includes/header.php';

$error = '';
$doctors = array();

if (isset($_GET['doctor_no'])) {
    $selectedDoctorNo = (int)$_GET['doctor_no'];
}
else {
    $selectedDoctorNo = 0;
}

$record = array('doctor' => null, 'teamRows' => array(), 'previousExperience' => array(), 'progress' => array());

try {
    $doctors = getDoctorsList();
    if ($selectedDoctorNo > 0) {
        $record = getConsultantTeamRecord($selectedDoctorNo);
    }
}
catch (Exception $ex) {
    $error = $ex->getMessage();
}
?>

<section class="panel">
    <div class="panel-title">
        <div>
            <h2>Consultant Team Record Form</h2>
            <p>Input Staff No to show the team record, previous experience, and progress/performance grades.</p>
        </div>
        <span class="code-pill">Form: Staff No</span>
    </div>

    <?php if ($error): ?>
        <div class="alert error"><strong>Database error:</strong><pre><?= e($error); ?></pre></div>
    <?php endif; ?>

    <form class="form-card" method="get" action="consultantTeam.php">
        <div class="form-grid">
            <div class="field">
                <label for="doctor_no">Staff / Doctor No</label>
                <select id="doctor_no" name="doctor_no" required>
                    <option value="">Select staff doctor</option>
                    <?php foreach ($doctors as $doctor): ?>
                        <?php
                        $selectedAttr = '';
                        if ($selectedDoctorNo == $doctor['DoctorNo']) {
                            $selectedAttr = 'selected';
                        }
                        ?>
                        <option value="<?= e($doctor['DoctorNo']); ?>" <?= $selectedAttr; ?>>
                            <?= e($doctor['DoctorName']); ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>
            <button class="btn" type="submit">Show Team Record</button>
            <a class="btn secondary" href="consultantTeam.php">Clear</a>
        </div>
    </form>

    <?php if ($selectedDoctorNo > 0 && !$record['doctor']): ?>
        <div class="empty-state">No doctor found for Staff No <?= e($selectedDoctorNo); ?>.</div>
    <?php endif; ?>

    <?php if ($record['doctor']): ?>
        <?php
        $d = $record['doctor'];

        $latest = null;
        if (count($record['teamRows']) > 0) {
            $latest = $record['teamRows'][0];
        }

        $positionVal = 'N/A';
        if ($latest) {
            $positionVal = e($latest['Position']);
        }

        $dateJoinedVal = 'N/A';
        if ($latest) {
            $dateJoinedVal = e($latest['DateJoined']);
        }

        $consultantNameVal = 'N/A';
        if ($latest) {
            $consultantNameVal = e($latest['ConsultantName']);
        }
        ?>
        <div class="record-heading">
            <div class="record-title">
                <div>
                    <h2>IVOR PAINE MEMORIAL HOSPITAL</h2>
                    <p class="subtitle">Consultant Team Record</p>
                </div>
                <span class="badge">Staff No: <?= e($d['DoctorNo']); ?></span>
            </div>
            <div class="info-grid">
                <div class="info-box"><small>Name</small><strong><?= e($d['DoctorName']); ?></strong></div>
                <div class="info-box"><small>Position</small><strong><?= $positionVal; ?></strong></div>
                <div class="info-box"><small>Date Joined Team</small><strong><?= $dateJoinedVal; ?></strong></div>
                <div class="info-box"><small>Consultant</small><strong><?= $consultantNameVal; ?></strong></div>
                <div class="info-box"><small>Date of Birth</small><strong><?= e($d['DateOfBirth']); ?></strong></div>
                <div class="info-box"><small>Address</small><strong><?= e($d['Address']); ?></strong></div>
            </div>
        </div>

        <div class="panel">
            <div class="panel-title"><h3>Team Membership History</h3></div>
            <?php renderTable($record['teamRows'], 'No team membership rows found for this staff member.'); ?>
        </div>

        <div class="panel">
            <div class="panel-title"><h3>Previous Experience</h3></div>
            <?php renderTable($record['previousExperience'], 'No previous experience found for this staff member.'); ?>
        </div>

        <div class="panel">
            <div class="panel-title"><h3>Progress</h3></div>
            <?php renderTable($record['progress'], 'No performance history found for this staff member.'); ?>
        </div>
    <?php endif; ?>
</section>

<?php require_once __DIR__ . '/includes/footer.php'; ?>