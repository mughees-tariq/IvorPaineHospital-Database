<?php
require_once __DIR__ . '/database.php';

function getPatientRecord($patientNo) {
    $header = fetchOne(
        "SELECT
            p.PatientNo,
            p.PatientName,
            p.DateOfBirth,
            p.Address,
            p.DateAdmitted,
            p.DischargeDate,
            p.DoctorInChargeNo AS DoctorNo,
            doc.DoctorName AS DoctorName,
            cons.DoctorNo AS ConsultantNo,
            consDoc.DoctorName AS ConsultantName,
            sp.SpecialtyName,
            cu.CareUnitNo,
            cu.CareUnitName,
            cu.WardName,
            b.BedNo,
            b.BedType
         FROM Patient p
         JOIN Doctor doc ON doc.DoctorNo = p.DoctorInChargeNo
         JOIN Consultant cons ON cons.DoctorNo = p.ConsultantNo
         JOIN Doctor consDoc ON consDoc.DoctorNo = cons.DoctorNo
         JOIN Specialty sp ON sp.SpecialtyName = cons.SpecialtyName
         JOIN CareUnit cu ON cu.CareUnitNo = p.CareUnitNo
         JOIN Bed b ON b.BedNo = p.BedNo
         WHERE p.PatientNo = ?",
        array($patientNo)
    );

    $history = fetchAll(
        "SELECT
            c.ComplaintCode,
            c.Description AS Complaint,
            c.Severity,
            t.TreatmentCode,
            t.Description AS Treatment,
            t.TreatmentType,
            d.DoctorNo,
            d.DoctorName AS TreatingDoctor,
            tr.DateStarted,
            tr.DateEnded,
            tr.Notes
         FROM TreatmentRecord tr
         JOIN Complaint c ON c.ComplaintCode = tr.ComplaintCode
         JOIN Treatment t ON t.TreatmentCode = tr.TreatmentCode
         JOIN Doctor d ON d.DoctorNo = tr.DoctorNo
         WHERE tr.PatientNo = ?
         ORDER BY tr.DateStarted, c.ComplaintCode, t.TreatmentCode",
        array($patientNo)
    );

    return array('header' => $header, 'history' => $history);
}

function getWardRecord($wardName) {
    $header = fetchOne(
        "SELECT
            w.WardName,
            w.Location,
            w.SpecialtyName,
            dayNurse.NurseName AS DaySister,
            nightNurse.NurseName AS NightSister
         FROM Ward w
         LEFT JOIN DaySister ds ON ds.WardName = w.WardName
         LEFT JOIN Nurse dayNurse ON dayNurse.NurseID = ds.NurseID
         LEFT JOIN NightSister ns ON ns.WardName = w.WardName
         LEFT JOIN Nurse nightNurse ON nightNurse.NurseID = ns.NurseID
         WHERE w.WardName = ?",
        array($wardName)
    );

    $staffNurses = fetchAll(
        "SELECT cu.CareUnitNo, cu.CareUnitName, n.NurseID, n.NurseName, sn.SupervisorRating
         FROM CareUnit cu
         JOIN StaffNurse sn ON sn.CareUnitNo = cu.CareUnitNo
         JOIN Nurse n ON n.NurseID = sn.NurseID
         WHERE cu.WardName = ?
         ORDER BY cu.CareUnitNo, n.NurseName",
        array($wardName)
    );

    $nonRegistered = fetchAll(
        "SELECT cu.CareUnitNo, cu.CareUnitName, n.NurseID, n.NurseName,
                CASE WHEN nr.TrainingStatus = 1 THEN 'Training Completed' ELSE 'Training Pending' END AS TrainingStatus
         FROM CareUnit cu
         JOIN NonRegisteredNurse nr ON nr.CareUnitNo = cu.CareUnitNo
         JOIN Nurse n ON n.NurseID = nr.NurseID
         WHERE cu.WardName = ?
         ORDER BY cu.CareUnitNo, n.NurseName",
        array($wardName)
    );

    $careUnits = fetchAll(
        "SELECT cu.CareUnitNo, cu.CareUnitName, cu.Capacity,
                COALESCE(n.NurseName, 'N/A') AS StaffNurseInCharge
         FROM CareUnit cu
         LEFT JOIN Nurse n ON n.NurseID = cu.NurseInChargeID
         WHERE cu.WardName = ?
         ORDER BY cu.CareUnitNo",
        array($wardName)
    );

    $patients = fetchAll(
        "SELECT
            p.PatientNo,
            p.PatientName,
            p.CareUnitNo,
            p.BedNo,
            consDoc.DoctorName AS Consultant,
            doc.DoctorName AS DoctorInCharge,
            p.DateAdmitted,
            p.DischargeDate
         FROM Patient p
         JOIN CareUnit cu ON cu.CareUnitNo = p.CareUnitNo
         JOIN Doctor doc ON doc.DoctorNo = p.DoctorInChargeNo
         JOIN Doctor consDoc ON consDoc.DoctorNo = p.ConsultantNo
         WHERE cu.WardName = ?
         ORDER BY p.DischargeDate, p.PatientNo",
        array($wardName)
    );

    return array(
        'header' => $header,
        'staffNurses' => $staffNurses,
        'nonRegistered' => $nonRegistered,
        'careUnits' => $careUnits,
        'patients' => $patients
    );
}

function getConsultantTeamRecord($doctorNo) {
    $doctor = fetchOne(
        "SELECT d.DoctorNo, d.DoctorName, d.DateOfBirth, d.Address
         FROM Doctor d
         WHERE d.DoctorNo = ?",
        array($doctorNo)
    );

    $teamRows = fetchAll(
        "SELECT
            dtr.DateJoined,
            dtr.EndDate,
            pos.PositionTitle AS Position,
            pos.Description AS PositionDescription,
            dtr.ConsultantNo,
            consDoc.DoctorName AS ConsultantName,
            sp.SpecialtyName AS ConsultantSpecialty
         FROM DoctorTeamRecord dtr
         JOIN Position pos ON pos.PositionCode = dtr.PositionCode
         JOIN Consultant cons ON cons.DoctorNo = dtr.ConsultantNo
         JOIN Doctor consDoc ON consDoc.DoctorNo = cons.DoctorNo
         JOIN Specialty sp ON sp.SpecialtyName = cons.SpecialtyName
         WHERE dtr.DoctorNo = ?
         ORDER BY CASE WHEN dtr.EndDate IS NULL THEN 0 ELSE 1 END, dtr.DateJoined DESC",
        array($doctorNo)
    );

    $previousExperience = fetchAll(
        "SELECT
            pe.FromDate,
            pe.ToDate,
            pos.PositionTitle AS Position,
            pe.Establishment
         FROM PreviousExperience pe
         JOIN Position pos ON pos.PositionCode = pe.PositionCode
         WHERE pe.DoctorNo = ?
         ORDER BY pe.FromDate",
        array($doctorNo)
    );

    $progress = fetchAll(
        "SELECT GradeDate, PerformanceGrade
         FROM PerformanceHistory
         WHERE DoctorNo = ?
         ORDER BY GradeDate",
        array($doctorNo)
    );

    return array(
        'doctor' => $doctor,
        'teamRows' => $teamRows,
        'previousExperience' => $previousExperience,
        'progress' => $progress
    );
}

function getQueryMeta() {
    return array(
        1 => 'Consultants and doctors in their team',
        2 => 'Wards with sisters, care units and staff nurse in charge',
        3 => 'Patients with complaints, treatments and dates',
        4 => 'Junior housemen, their patients and staff nurse for care unit',
        5 => 'Consultants with a unique speciality',
        6 => 'Complaints, treatments and treating doctor experience history',
        7 => 'Patients with more than one complaint and their treatments',
        8 => 'Patients grouped by treatment within complaint',
        9 => 'Performance history for a particular doctor',
        10 => 'Full medical details for a particular patient',
        11 => 'Treatments for a complaint between two dates ordered by treatment',
        12 => 'Different staff positions and count of staff in each position'
    );
}

function runHospitalQuery($queryNo, $filters = array()) {
    switch ((int)$queryNo) {
        case 1:
            return fetchAll(
                "SELECT
                    c.DoctorNo AS ConsultantNo,
                    dc.DoctorName AS ConsultantName,
                    sp.SpecialtyName,
                    dtr.DoctorNo AS TeamDoctorNo,
                    dt.DoctorName AS TeamDoctorName,
                    pos.PositionTitle AS DoctorPosition,
                    dtr.DateJoined,
                    dtr.EndDate
                 FROM Consultant c
                 JOIN Doctor dc ON c.DoctorNo = dc.DoctorNo
                 JOIN Specialty sp ON c.SpecialtyName = sp.SpecialtyName
                 JOIN DoctorTeamRecord dtr ON dtr.ConsultantNo = c.DoctorNo
                 JOIN Doctor dt ON dtr.DoctorNo = dt.DoctorNo
                 JOIN Position pos ON dtr.PositionCode = pos.PositionCode
                 ORDER BY ConsultantName, TeamDoctorName, dtr.DateJoined"
            );
        case 2:
            return fetchAll(
                "SELECT
                    w.WardName,
                    w.SpecialtyName,
                    ds_nurse.NurseName AS DaySister,
                    ns_nurse.NurseName AS NightSister,
                    cu.CareUnitNo,
                    cu.CareUnitName,
                    sn_nurse.NurseName AS StaffNurseInCharge
                 FROM Ward w
                 LEFT JOIN DaySister ds ON ds.WardName = w.WardName
                 LEFT JOIN Nurse ds_nurse ON ds.NurseID = ds_nurse.NurseID
                 LEFT JOIN NightSister ns ON ns.WardName = w.WardName
                 LEFT JOIN Nurse ns_nurse ON ns.NurseID = ns_nurse.NurseID
                 LEFT JOIN CareUnit cu ON cu.WardName = w.WardName
                 LEFT JOIN StaffNurse sn ON sn.NurseID = cu.NurseInChargeID
                 LEFT JOIN Nurse sn_nurse ON sn.NurseID = sn_nurse.NurseID
                 ORDER BY w.WardName, cu.CareUnitNo"
            );
        case 3:
            return fetchAll(
                "SELECT
                    p.PatientNo,
                    p.PatientName,
                    c.ComplaintCode,
                    c.Description AS Complaint,
                    t.TreatmentCode,
                    t.Description AS Treatment,
                    tr.DateStarted,
                    tr.DateEnded,
                    d.DoctorName AS TreatingDoctor
                 FROM Patient p
                 JOIN TreatmentRecord tr ON tr.PatientNo = p.PatientNo
                 JOIN Complaint c ON tr.ComplaintCode = c.ComplaintCode
                 JOIN Treatment t ON tr.TreatmentCode = t.TreatmentCode
                 JOIN Doctor d ON tr.DoctorNo = d.DoctorNo
                 ORDER BY p.PatientName, c.ComplaintCode, tr.DateStarted"
            );
        case 4:
            return fetchAll(
                "SELECT DISTINCT
                    d.DoctorNo,
                    d.DoctorName AS JuniorHouseman,
                    pos.PositionTitle,
                    p.PatientNo,
                    p.PatientName,
                    p.CareUnitNo,
                    cu.WardName,
                    sn_nurse.NurseName AS StaffNurseInCharge
                 FROM DoctorTeamRecord dtr
                 JOIN Position pos ON dtr.PositionCode = pos.PositionCode AND pos.PositionTitle = 'JH'
                 JOIN Doctor d ON dtr.DoctorNo = d.DoctorNo
                 JOIN Patient p ON p.DoctorInChargeNo = d.DoctorNo
                 JOIN CareUnit cu ON cu.CareUnitNo = p.CareUnitNo
                 LEFT JOIN StaffNurse sn ON sn.NurseID = cu.NurseInChargeID
                 LEFT JOIN Nurse sn_nurse ON sn.NurseID = sn_nurse.NurseID
                 ORDER BY d.DoctorName, p.PatientName"
            );
        case 5:
            return fetchAll(
                "SELECT
                    c.DoctorNo,
                    d.DoctorName AS ConsultantName,
                    c.SpecialtyName
                 FROM Consultant c
                 JOIN Doctor d ON c.DoctorNo = d.DoctorNo
                 WHERE c.SpecialtyName IN (
                     SELECT SpecialtyName
                     FROM Consultant
                     GROUP BY SpecialtyName
                     HAVING COUNT(*) = 1
                 )
                 ORDER BY c.SpecialtyName"
            );
        case 6:
            return fetchAll(
                "SELECT DISTINCT
                    c.ComplaintCode,
                    c.Description AS Complaint,
                    t.Description AS Treatment,
                    d.DoctorNo,
                    d.DoctorName,
                    pe.FromDate,
                    pe.ToDate,
                    pos.PositionTitle AS PreviousPosition,
                    pe.Establishment
                 FROM TreatmentRecord tr
                 JOIN Complaint c ON tr.ComplaintCode = c.ComplaintCode
                 JOIN Treatment t ON tr.TreatmentCode = t.TreatmentCode
                 JOIN Doctor d ON tr.DoctorNo = d.DoctorNo
                 LEFT JOIN PreviousExperience pe ON pe.DoctorNo = d.DoctorNo
                 LEFT JOIN Position pos ON pe.PositionCode = pos.PositionCode
                 ORDER BY c.ComplaintCode, d.DoctorName, pe.FromDate"
            );
        case 7:
            return fetchAll(
                "SELECT
                    p.PatientNo,
                    p.PatientName,
                    c.ComplaintCode,
                    c.Description AS Complaint,
                    t.TreatmentCode,
                    t.Description AS Treatment,
                    tr.DateStarted,
                    tr.DateEnded
                 FROM Patient p
                 JOIN TreatmentRecord tr ON tr.PatientNo = p.PatientNo
                 JOIN Complaint c ON tr.ComplaintCode = c.ComplaintCode
                 JOIN Treatment t ON tr.TreatmentCode = t.TreatmentCode
                 WHERE p.PatientNo IN (
                     SELECT PatientNo
                     FROM TreatmentRecord
                     GROUP BY PatientNo
                     HAVING COUNT(DISTINCT ComplaintCode) > 1
                 )
                 ORDER BY p.PatientName, c.ComplaintCode, tr.DateStarted"
            );
        case 8:
            return fetchAll(
                "SELECT
                    c.ComplaintCode,
                    c.Description AS Complaint,
                    t.TreatmentCode,
                    t.Description AS Treatment,
                    p.PatientNo,
                    p.PatientName,
                    tr.DateStarted,
                    tr.DateEnded
                 FROM TreatmentRecord tr
                 JOIN Complaint c ON tr.ComplaintCode = c.ComplaintCode
                 JOIN Treatment t ON tr.TreatmentCode = t.TreatmentCode
                 JOIN Patient p ON tr.PatientNo = p.PatientNo
                 ORDER BY c.ComplaintCode, t.TreatmentCode, p.PatientName"
            );
        case 9:
            if (isset($filters['doctor_no']))
            {
                $doctorNo = (int)$filters['doctor_no'];
            }
            else
            {
                $doctorNo = 0;
            }
            return fetchAll(
                "SELECT
                    d.DoctorNo,
                    d.DoctorName,
                    ph.GradeDate,
                    ph.PerformanceGrade
                 FROM Doctor d
                 JOIN PerformanceHistory ph ON ph.DoctorNo = d.DoctorNo
                 WHERE d.DoctorNo = ?
                 ORDER BY ph.GradeDate",
                array($doctorNo)
            );
        case 10:
            if (isset($filters['patient_no']))
            {
                $patientNo = (int)$filters['patient_no'];
            }
            else
            {
                $patientNo = 0;
            }
            return fetchAll(
                "SELECT
                    p.PatientNo,
                    p.PatientName,
                    p.DateOfBirth,
                    p.Address,
                    p.DateAdmitted,
                    p.DischargeDate,
                    cu.WardName,
                    cu.CareUnitName,
                    b.BedNo,
                    b.BedType,
                    d_ic.DoctorName AS DoctorInCharge,
                    cons_d.DoctorName AS Consultant,
                    sp.SpecialtyName,
                    c.ComplaintCode,
                    c.Description AS Complaint,
                    c.Severity,
                    t.Description AS Treatment,
                    t.TreatmentType,
                    tr.DateStarted,
                    tr.DateEnded,
                    tr.Notes,
                    tr_doc.DoctorName AS TreatingDoctor
                 FROM Patient p
                 JOIN CareUnit cu ON cu.CareUnitNo = p.CareUnitNo
                 JOIN Bed b ON b.BedNo = p.BedNo
                 JOIN Doctor d_ic ON d_ic.DoctorNo = p.DoctorInChargeNo
                 JOIN Consultant cons ON cons.DoctorNo = p.ConsultantNo
                 JOIN Doctor cons_d ON cons_d.DoctorNo = cons.DoctorNo
                 JOIN Specialty sp ON sp.SpecialtyName = cons.SpecialtyName
                 LEFT JOIN TreatmentRecord tr ON tr.PatientNo = p.PatientNo
                 LEFT JOIN Complaint c ON c.ComplaintCode = tr.ComplaintCode
                 LEFT JOIN Treatment t ON t.TreatmentCode = tr.TreatmentCode
                 LEFT JOIN Doctor tr_doc ON tr_doc.DoctorNo = tr.DoctorNo
                 WHERE p.PatientNo = ?
                 ORDER BY tr.DateStarted",
                array($patientNo)
            );
        case 11:
            if (isset($filters['complaint_code']))
            {
                $complaintCode = (int)$filters['complaint_code'];
            }
            else
            {
                $complaintCode = 0;
            }
            if (isset($filters['start_date']))
            {
                $startDate = $filters['start_date'];
            }
            else
            {
                $startDate = null;
            }
            if (isset($filters['end_date']))
            {
                $endDate = $filters['end_date'];
            }
            else
            {
                $endDate = null;
            }
            return fetchAll(
                "SELECT
                    c.ComplaintCode,
                    c.Description AS Complaint,
                    t.TreatmentCode,
                    t.Description AS Treatment,
                    t.TreatmentType,
                    p.PatientNo,
                    p.PatientName,
                    tr.DateStarted,
                    tr.DateEnded,
                    d.DoctorNo,
                    d.DoctorName AS TreatingDoctor
                 FROM TreatmentRecord tr
                 JOIN Complaint c ON tr.ComplaintCode = c.ComplaintCode
                 JOIN Treatment t ON tr.TreatmentCode = t.TreatmentCode
                 JOIN Patient p ON tr.PatientNo = p.PatientNo
                 JOIN Doctor d ON tr.DoctorNo = d.DoctorNo
                 WHERE tr.ComplaintCode = ?
                   AND tr.DateStarted BETWEEN ? AND ?
                 ORDER BY t.Description, tr.DateStarted, p.PatientName",
                array($complaintCode, $startDate, $endDate)
            );
        case 12:
            return fetchAll(
                "SELECT PositionTitle, StaffCount FROM (
                    SELECT 'Consultant' AS PositionTitle, CAST(COUNT(*) AS INT) AS StaffCount FROM Consultant
                    UNION ALL
                    SELECT 'Night Sister', COUNT(*) FROM NightSister
                    UNION ALL
                    SELECT 'Day Sister', COUNT(*) FROM DaySister
                    UNION ALL
                    SELECT 'Staff Nurse', COUNT(*) FROM StaffNurse
                    UNION ALL
                    SELECT 'Non-Registered Nurse', COUNT(*) FROM NonRegisteredNurse
                    UNION ALL
                    SELECT pos.PositionTitle, COUNT(DISTINCT dtr.DoctorNo)
                    FROM DoctorTeamRecord dtr
                    JOIN Position pos ON pos.PositionCode = dtr.PositionCode
                    WHERE dtr.EndDate IS NULL
                    GROUP BY pos.PositionTitle
                ) AS combined
                WHERE StaffCount > 0
                ORDER BY PositionTitle"
            );
        default:
            throw new Exception('Invalid query number selected.');
    }
}
?>