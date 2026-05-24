<?php
require_once __DIR__ . '/includes/hospitalQueries.php';
require_once __DIR__ . '/includes/header.php';

$error = '';
$patients = array();

if (isset($_GET['patient_no'])) {
    $selectedPatientNo = (int)$_GET['patient_no'];
}
else {
    $selectedPatientNo = 0;
}

$record = array('header' => null, 'history' => array());

try {
    $patients = getPatientsList();
    if ($selectedPatientNo > 0) {
        $record = getPatientRecord($selectedPatientNo);
    }
}
catch (Exception $ex) {
    $error = $ex->getMessage();
}
?>

<section class="panel">
    <div class="panel-title">
        <div>
            <h2>Patient Record Form</h2>
            <p>Input Patient No to show the hospital patient record and complete medical history.</p>
        </div>
        <span class="code-pill">Form: Patient No</span>
    </div>

    <?php if ($error): ?>
        <div class="alert error"><strong>Database error:</strong><pre><?= e($error); ?></pre></div>
    <?php endif; ?>

    <form class="form-card" method="get" action="patientRecord.php">
        <div class="form-grid">
            <div class="field">
                <label for="patient_no">Patient No</label>
                <select id="patient_no" name="patient_no" required>
                    <option value="">Select patient</option>
                    <?php foreach ($patients as $patient): ?>
                        <?php
                        $selectedAttr = '';
                        if ($selectedPatientNo == $patient['PatientNo']) {
                            $selectedAttr = 'selected';
                        }
                        ?>
                        <option value="<?= e($patient['PatientNo']); ?>" <?= $selectedAttr; ?>>
                            <?= e($patient['PatientName']); ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>
            <button class="btn" type="submit">Show Patient Record</button>
            <a class="btn secondary" href="patientRecord.php">Clear</a>
        </div>
    </form>

    <?php if ($selectedPatientNo > 0 && !$record['header']): ?>
        <div class="empty-state">No patient found for Patient No <?= e($selectedPatientNo); ?>.</div>
    <?php endif; ?>

    <?php if ($record['header']): ?>
        <?php $h = $record['header']; ?>
        <div class="record-heading">
            <div class="record-title">
                <div>
                    <h2>IVOR PAINE MEMORIAL HOSPITAL</h2>
                    <p class="subtitle">Patient Record</p>
                </div>
                <span class="badge">Patient No: <?= e($h['PatientNo']); ?></span>
            </div>

            <div class="info-grid">
                <div class="info-box"><small>Patient Name</small><strong><?= e($h['PatientName']); ?></strong></div>
                <div class="info-box"><small>Date of Birth</small><strong><?= e($h['DateOfBirth']); ?></strong></div>
                <div class="info-box"><small>Doctor No</small><strong><?= e($h['DoctorNo']); ?></strong></div>
                <div class="info-box"><small>Doctor Name</small><strong><?= e($h['DoctorName']); ?></strong></div>
                <div class="info-box"><small>Consultant</small><strong><?= e($h['ConsultantName']); ?></strong></div>
                <div class="info-box"><small>Specialty</small><strong><?= e($h['SpecialtyName']); ?></strong></div>
                <div class="info-box"><small>Ward / Care Unit</small><strong><?= e($h['WardName'] . ' / ' . $h['CareUnitName']); ?></strong></div>
                <div class="info-box"><small>Bed</small><strong><?= e($h['BedNo'] . ' - ' . $h['BedType']); ?></strong></div>
                <div class="info-box"><small>Date Admitted</small><strong><?= e($h['DateAdmitted']); ?></strong></div>
                <div class="info-box"><small>Discharge Date</small><strong><?= e($h['DischargeDate']); ?></strong></div>
                <div class="info-box"><small>Address</small><strong><?= e($h['Address']); ?></strong></div>
            </div>
        </div>

        <div class="panel-title">
            <div>
                <h3>Medical History</h3>
                <p>Complaint, treatment, treating doctor, and treatment dates.</p>
            </div>
        </div>
        <?php renderTable($record['history'], 'No medical history found for this patient.'); ?>
    <?php endif; ?>
</section>

<?php require_once __DIR__ . '/includes/footer.php'; ?>