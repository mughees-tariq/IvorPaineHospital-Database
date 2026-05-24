<?php
require_once __DIR__ . '/../config.php';

function normalizeValue($value) {
    if ($value instanceof DateTime) {
        return $value->format('Y-m-d');
    }

    if ($value === null || $value === '') {
        return 'N/A';
    }

    if (is_bool($value)) {
        if ($value) {
            return 'Yes';
        }
        else {
            return 'No';
        }
    }
    return $value;
}

function normalizeRow($row) {
    foreach ($row as $key => $value) {
        $row[$key] = normalizeValue($value);
    }
    return $row;
}

function fetchAll($sql, $params = array()) {
    $conn = connectDB();
    $stmt = sqlsrv_query($conn, $sql, $params);

    if ($stmt === false) {
        $errors = sqlsrv_errors();
        sqlsrv_close($conn);
        throw new Exception(formatSqlsrvErrors($errors));
    }

    $rows = array();
    while ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
        $rows[] = normalizeRow($row);
    }

    sqlsrv_free_stmt($stmt);
    sqlsrv_close($conn);
    return $rows;
}

function fetchOne($sql, $params = array()) {
    $rows = fetchAll($sql, $params);
    if (count($rows) > 0) {
        return $rows[0];
    }
    else {
        return null;
    }
}

function formatSqlsrvErrors($errors) {
    if (!$errors) {
        return 'Unknown SQL Server error.';
    }
    $messages = array();
    foreach ($errors as $error) {
        $messages[] = 'SQLSTATE ' . $error['SQLSTATE'] . ' | Code ' . $error['code'] . ' | ' . $error['message'];
    }
    return implode("\n", $messages);
}

function e($value) {
    return htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
}

function renderTable($rows, $emptyMessage = 'No records found.') {
    if (empty($rows)) {
        echo "<div class='empty-state'>" . e($emptyMessage) . "</div>";
        return;
    }

    echo "<div class='table-wrap'><table class='data-table'><thead><tr>";
    foreach (array_keys($rows[0]) as $heading) {
        echo "<th>" . e(preg_replace('/(?<!^)([A-Z])/', ' $1', $heading)) . "</th>";
    }
    echo "</tr></thead><tbody>";

    foreach ($rows as $row) {
        echo "<tr>";
        foreach ($row as $value) {
            echo "<td>" . e($value) . "</td>";
        }
        echo "</tr>";
    }

    echo "</tbody></table></div>";
}

function getDashboardCounts() {
    $patientsRow = fetchOne("SELECT COUNT(*) AS Total FROM Patient");
    if ($patientsRow !== null) {
        $patientsTotal = $patientsRow['Total'];
    }
    else {
        $patientsTotal = 0;
    }

    $doctorsRow = fetchOne("SELECT COUNT(*) AS Total FROM Doctor");
    if ($doctorsRow !== null) {
        $doctorsTotal = $doctorsRow['Total'];
    }
    else {
        $doctorsTotal = 0;
    }

    $wardsRow = fetchOne("SELECT COUNT(*) AS Total FROM Ward");
    if ($wardsRow !== null) {
        $wardsTotal = $wardsRow['Total'];
    }
    else {
        $wardsTotal = 0;
    }

    $careUnitsRow = fetchOne("SELECT COUNT(*) AS Total FROM CareUnit");
    if ($careUnitsRow !== null) {
        $careUnitsTotal = $careUnitsRow['Total'];
    }
    else {
        $careUnitsTotal = 0;
    }

    $treatmentsRow = fetchOne("SELECT COUNT(*) AS Total FROM TreatmentRecord");
    if ($treatmentsRow !== null) {
        $treatmentsTotal = $treatmentsRow['Total'];
    }
    else {
        $treatmentsTotal = 0;
    }

    $complaintsRow = fetchOne("SELECT COUNT(*) AS Total FROM Complaint");
    if ($complaintsRow !== null) {
        $complaintsTotal = $complaintsRow['Total'];
    }
    else {
        $complaintsTotal = 0;
    }

    return array(
        'patients'   => $patientsTotal,
        'doctors'    => $doctorsTotal,
        'wards'      => $wardsTotal,
        'careUnits'  => $careUnitsTotal,
        'treatments' => $treatmentsTotal,
        'complaints' => $complaintsTotal
    );
}

function getPatientsList() {
    return fetchAll("SELECT PatientNo, PatientName FROM Patient ORDER BY PatientNo");
}

function getDoctorsList() {
    return fetchAll("SELECT DoctorNo, DoctorName FROM Doctor ORDER BY DoctorNo");
}

function getWardsList() {
    return fetchAll("SELECT WardName FROM Ward ORDER BY WardName");
}

function getComplaintsList() {
    return fetchAll("SELECT ComplaintCode, Description FROM Complaint ORDER BY ComplaintCode");
}

function getRecentTreatments() {
    return fetchAll("SELECT TOP 8 p.PatientName, c.Description AS Complaint, t.Description AS Treatment, tr.DateStarted
                     FROM TreatmentRecord tr
                     JOIN Patient p ON p.PatientNo = tr.PatientNo
                     JOIN Complaint c ON c.ComplaintCode = tr.ComplaintCode
                     JOIN Treatment t ON t.TreatmentCode = tr.TreatmentCode
                     ORDER BY tr.DateStarted DESC, p.PatientName");
}

function getComplaintSummary() {
    return fetchAll("SELECT TOP 8 c.Description AS Complaint, COUNT(*) AS TotalCases
                     FROM TreatmentRecord tr
                     JOIN Complaint c ON c.ComplaintCode = tr.ComplaintCode
                     GROUP BY c.Description
                     ORDER BY TotalCases DESC, c.Description");
}

function getWardOccupancy() {
    return fetchAll("SELECT w.WardName, COUNT(p.PatientNo) AS AdmittedPatients
                     FROM Ward w
                     LEFT JOIN CareUnit cu ON cu.WardName = w.WardName
                     LEFT JOIN Patient p ON p.CareUnitNo = cu.CareUnitNo AND p.DischargeDate IS NULL
                     GROUP BY w.WardName
                     ORDER BY w.WardName");
}
?>