<?php
require_once __DIR__ . '/includes/hospitalQueries.php';
require_once __DIR__ . '/includes/header.php';

$error = '';
$queryMeta = getQueryMeta();

if (isset($_GET['query_no'])) {
    $selectedQuery = (int)$_GET['query_no'];
}
else {
    $selectedQuery = 1;
}

$rows = array();
$patients = array();
$doctors = array();
$complaints = array();

if (isset($_GET['doctor_no'])) {
    $filterDoctorNo = (int)$_GET['doctor_no'];
}
else {
    $filterDoctorNo = 201;
}

if (isset($_GET['patient_no'])) {
    $filterPatientNo = (int)$_GET['patient_no'];
}
else {
    $filterPatientNo = 302;
}

if (isset($_GET['complaint_code'])) {
    $filterComplaintCode = (int)$_GET['complaint_code'];
}
else {
    $filterComplaintCode = 402;
}

if (isset($_GET['start_date'])) {
    $filterStartDate = $_GET['start_date'];
}
else {
    $filterStartDate = '2025-01-01';
}

if (isset($_GET['end_date'])) {
    $filterEndDate = $_GET['end_date'];
}
else {
    $filterEndDate = '2025-03-31';
}

$filters = array(
    'doctor_no'      => $filterDoctorNo,
    'patient_no'     => $filterPatientNo,
    'complaint_code' => $filterComplaintCode,
    'start_date'     => $filterStartDate,
    'end_date'       => $filterEndDate
);

try {
    $patients = getPatientsList();
    $doctors = getDoctorsList();
    $complaints = getComplaintsList();

    if (isset($_GET['run_query'])) {
        $rows = runHospitalQuery($selectedQuery, $filters);
    }
}
catch (Exception $ex) {
    $error = $ex->getMessage();
}
?>

<section class="panel">
    <div class="panel-title">
        <div>
            <h2>SQL Server Queries Page</h2>
            <p>Select a report from the dropdown. Extra filters appear only where needed.</p>
        </div>
        <span class="code-pill">Queries</span>
    </div>

    <?php if ($error): ?>
        <div class="alert error"><strong>Database error:</strong><pre><?= e($error); ?></pre></div>
    <?php endif; ?>

    <form class="form-card" method="get" action="queries.php">
        <div class="form-grid">
            <div class="field">
                <label for="query_no">Query to Run</label>
                <select id="query_no" name="query_no" required>
                    <?php foreach ($queryMeta as $no => $title): ?>
                        <?php
                        $selectedAttr = '';
                        if ($selectedQuery === (int)$no) {
                            $selectedAttr = 'selected';
                        }
                        ?>
                        <option value="<?= e($no); ?>" <?= $selectedAttr; ?>>
                            <?= e($title); ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>

            <div class="field query-filter" data-query-filter="9">
                <label for="doctor_no">Doctor No</label>
                <select id="doctor_no" name="doctor_no">
                    <?php foreach ($doctors as $doctor): ?>
                        <?php
                        $selectedAttr = '';
                        if ($filters['doctor_no'] == $doctor['DoctorNo']) {
                            $selectedAttr = 'selected';
                        }
                        ?>
                        <option value="<?= e($doctor['DoctorNo']); ?>" <?= $selectedAttr; ?>>
                            <?= e($doctor['DoctorName']); ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>

            <div class="field query-filter" data-query-filter="10">
                <label for="patient_no">Patient No</label>
                <select id="patient_no" name="patient_no">
                    <?php foreach ($patients as $patient): ?>
                        <?php
                        $selectedAttr = '';
                        if ($filters['patient_no'] == $patient['PatientNo']) {
                            $selectedAttr = 'selected';
                        }
                        ?>
                        <option value="<?= e($patient['PatientNo']); ?>" <?= $selectedAttr; ?>>
                            <?= e($patient['PatientName']); ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>

            <div class="field query-filter" data-query-filter="11">
                <label for="complaint_code">Complaint Code</label>
                <select id="complaint_code" name="complaint_code">
                    <?php foreach ($complaints as $complaint): ?>
                        <?php
                        $selectedAttr = '';
                        if ($filters['complaint_code'] == $complaint['ComplaintCode']) {
                            $selectedAttr = 'selected';
                        }
                        ?>
                        <option value="<?= e($complaint['ComplaintCode']); ?>" <?= $selectedAttr; ?>>
                            <?= e($complaint['Description']); ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>

            <div class="field query-filter" data-query-filter="11">
                <label for="start_date">Start Date</label>
                <input id="start_date" name="start_date" type="date" value="<?= e($filters['start_date']); ?>">
            </div>

            <div class="field query-filter" data-query-filter="11">
                <label for="end_date">End Date</label>
                <input id="end_date" name="end_date" type="date" value="<?= e($filters['end_date']); ?>">
            </div>

            <button class="btn" type="submit" name="run_query" value="1">Run Selected Query</button>
            <a class="btn secondary" href="queries.php">Reset</a>
        </div>
        <div id="query-help" class="query-help"></div>
    </form>

    <div class="panel-title">
        <div>
            <?php
            $queryTitle = '';
            if (isset($queryMeta[$selectedQuery])) {
                $queryTitle = $queryMeta[$selectedQuery];
            }
            ?>
            <h3><?= e('Query ' . $selectedQuery . ': ' . $queryTitle); ?></h3>
            <?php
            if (isset($_GET['run_query'])) {
                echo '<p>Result generated from SQL Server.</p>';
            }
            else {
                echo '<p>Choose a query and click Run Selected Query.</p>';
            }
            ?>
        </div>
    </div>

    <?php
    if (isset($_GET['run_query'])) {
        renderTable($rows, 'No records returned for this query/filter.');
    }
    else {
        echo "<div class='empty-state'>No query has been run yet.</div>";
    }
    ?>
</section>

<section class="panel">
    <div class="panel-title">
        <div>
            <h3>Query List</h3>
            <p>These are the 12 reports required in the project statement.</p>
        </div>
    </div>
    <div class="table-wrap">
        <table class="data-table">
            <thead><tr><th>Query No</th><th>Report Required</th><th>Input Needed</th></tr></thead>
            <tbody>
            <?php foreach ($queryMeta as $no => $title): ?>
                <tr>
                    <td><?= e($no); ?></td>
                    <td><?= e($title); ?></td>
                    <td>
                        <?php
                        if ($no == 9) {
                            echo 'Doctor No';
                        }
                        elseif ($no == 10) {
                            echo 'Patient No';
                        }
                        elseif ($no == 11) {
                            echo 'Complaint Code, Start Date, End Date';
                        }
                        else {
                            echo 'None';
                        }
                        ?>
                    </td>
                </tr>
            <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</section>

<?php require_once __DIR__ . '/includes/footer.php'; ?>