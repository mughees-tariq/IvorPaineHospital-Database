<?php
require_once __DIR__ . '/includes/hospitalQueries.php';
require_once __DIR__ . '/includes/header.php';

$error = '';
$wards = array();

if (isset($_GET['wardName'])) {
    $selectedWardName = trim($_GET['wardName']);
}
else {
    $selectedWardName = '';
}

$record = array('header' => null, 'staffNurses' => array(), 'nonRegistered' => array(), 'careUnits' => array(), 'patients' => array());

try {
    $wards = getWardsList();
    if ($selectedWardName !== '') {
        $record = getWardRecord($selectedWardName);
    }
}
catch (Exception $ex) {
    $error = $ex->getMessage();
}
?>

<section class="panel">
    <div class="panel-title">
        <div>
            <h2>Ward Record Form & Report</h2>
            <p>Input Ward Name from the list to show sisters, nurses, care units, and admitted patients.</p>
        </div>
        <span class="code-pill">Form & Report: Ward Name</span>
    </div>

    <?php if ($error): ?>
        <div class="alert error"><strong>Database error:</strong><pre><?= e($error); ?></pre></div>
    <?php endif; ?>

    <form class="form-card" method="get" action="wardRecord.php">
        <div class="form-grid">
            <div class="field">
                <label for="wardName">Ward Name</label>
                <select id="wardName" name="wardName" required>
                    <option value="">Select ward</option>
                    <?php foreach ($wards as $ward): ?>
                        <?php
                        $selectedAttr = '';
                        if ($selectedWardName === $ward['WardName']) {
                            $selectedAttr = 'selected';
                        }
                        ?>
                        <option value="<?= e($ward['WardName']); ?>" <?= $selectedAttr; ?>>
                            <?= e($ward['WardName']); ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>
            <button class="btn" type="submit">Show Ward Record</button>
            <a class="btn secondary" href="wardRecord.php">Clear</a>
        </div>
    </form>

    <?php if ($selectedWardName !== '' && !$record['header']): ?>
        <div class="empty-state">No ward found for <?= e($selectedWardName); ?>.</div>
    <?php endif; ?>

    <?php if ($record['header']): ?>
        <?php $h = $record['header']; ?>
        <div class="record-heading">
            <div class="record-title">
                <div>
                    <h2>IVOR PAINE MEMORIAL HOSPITAL</h2>
                    <p class="subtitle">Ward Record</p>
                </div>
                <span class="badge"><?= e($h['WardName']); ?></span>
            </div>
            <div class="info-grid">
                <div class="info-box"><small>Ward Name</small><strong><?= e($h['WardName']); ?></strong></div>
                <div class="info-box"><small>Specialty</small><strong><?= e($h['SpecialtyName']); ?></strong></div>
                <div class="info-box"><small>Location</small><strong><?= e($h['Location']); ?></strong></div>
                <div class="info-box"><small>Day Sister</small><strong><?= e($h['DaySister']); ?></strong></div>
                <div class="info-box"><small>Night Sister</small><strong><?= e($h['NightSister']); ?></strong></div>
            </div>
        </div>

        <div class="panel">
            <div class="panel-title"><h3>Care Units</h3></div>
            <?php renderTable($record['careUnits'], 'No care units found for this ward.'); ?>
        </div>

        <div class="panel">
            <div class="panel-title"><h3>Staff Nurses</h3></div>
            <?php renderTable($record['staffNurses'], 'No staff nurses found for this ward.'); ?>
        </div>

        <div class="panel">
            <div class="panel-title"><h3>Non-registered Nurses</h3></div>
            <?php renderTable($record['nonRegistered'], 'No non-registered nurses found for this ward.'); ?>
        </div>

        <div class="panel">
            <div class="panel-title">
                <div>
                    <h3>Patient Information</h3>
                    <p>Patient No, name, care unit, bed, consultant, and date admitted.</p>
                </div>
            </div>
            <?php renderTable($record['patients'], 'No patients found for this ward.'); ?>
        </div>
    <?php endif; ?>
</section>

<?php require_once __DIR__ . '/includes/footer.php'; ?>