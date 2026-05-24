use IvorPaineHospital
GO

-- Q1: List of consultants and doctors in their team
SELECT
    c.DoctorNo   AS ConsultantNo,
    dc.DoctorName  AS ConsultantName,
    sp.SpecialtyName,
    dtr.DoctorNo   AS TeamDoctorNo,
    dt.DoctorName   AS TeamDoctorName,
    pos.PositionTitle  AS DoctorPosition,
    dtr.DateJoined,
    dtr.EndDate
FROM Consultant c
JOIN Doctor      dc ON c.DoctorNo    = dc.DoctorNo
JOIN Specialty   sp  ON c.SpecialtyName = sp.SpecialtyName
JOIN DoctorTeamRecord dtr ON dtr.ConsultantNo = c.DoctorNo
JOIN Doctor      dt ON dtr.DoctorNo   = dt.DoctorNo
JOIN Position    pos ON dtr.PositionCode = pos.PositionCode
ORDER BY ConsultantName, TeamDoctorName;
GO

-- Q2: Wards with sisters, care units and staff nurse in charge
SELECT
    w.WardName,
    ds_nurse.NurseName  AS DaySister,
    ns_nurse.NurseName  AS NightSister,
    cu.CareUnitNo,
    cu.CareUnitName,
    sn_nurse.NurseName  AS StaffNurseInCharge
FROM Ward w
LEFT JOIN DaySister   ds  ON ds.WardName  = w.WardName
LEFT JOIN Nurse    ds_nurse ON ds.NurseID  = ds_nurse.NurseID
LEFT JOIN NightSister ns  ON ns.WardName  = w.WardName
LEFT JOIN Nurse    ns_nurse ON ns.NurseID  = ns_nurse.NurseID
LEFT JOIN CareUnit    cu  ON cu.WardName  = w.WardName
LEFT JOIN StaffNurse  sn  ON sn.NurseID   = cu.NurseInChargeID
LEFT JOIN Nurse    sn_nurse ON sn.NurseID  = sn_nurse.NurseID
ORDER BY w.WardName, cu.CareUnitNo;
GO

-- Q3: Patients with complaints, treatments and dates
SELECT
    p.PatientNo,
    p.PatientName,
    c.ComplaintCode,
    c.Description       AS Complaint,
    t.TreatmentCode,
    t.Description       AS Treatment,
    tr.DateStarted,
    tr.DateEnded,
    d.DoctorName        AS TreatingDoctor
FROM Patient         p
JOIN TreatmentRecord tr ON tr.PatientNo     = p.PatientNo
JOIN Complaint       c  ON tr.ComplaintCode = c.ComplaintCode
JOIN Treatment       t  ON tr.TreatmentCode = t.TreatmentCode
JOIN Doctor          d  ON tr.DoctorNo      = d.DoctorNo
ORDER BY p.PatientName, c.ComplaintCode, tr.DateStarted;
GO


-- Q4: Junior housemen, their patients and the staff nurse of patient's care unit
SELECT
    d.DoctorNo,
    d.DoctorName            AS JuniorHouseman,
    pos.PositionTitle,
    p.PatientNo,
    p.PatientName,
    p.CareUnitNo,
    cu.WardName,
    sn_nurse.NurseName      AS StaffNurseInCharge
FROM DoctorTeamRecord dtr
JOIN Position  pos      ON dtr.PositionCode  = pos.PositionCode AND pos.PositionTitle = 'JH'
JOIN Doctor    d        ON dtr.DoctorNo      = d.DoctorNo
JOIN Patient   p        ON p.DoctorInChargeNo = d.DoctorNo
JOIN CareUnit  cu       ON cu.CareUnitNo     = p.CareUnitNo 
LEFT JOIN StaffNurse sn ON sn.NurseID        = cu.NurseInChargeID
LEFT JOIN Nurse sn_nurse ON sn.NurseID       = sn_nurse.NurseID
ORDER BY d.DoctorName, p.PatientName;
GO

-- Q5: Consultants with a unique specialty (specialty assigned to exactly one consultant)
SELECT
    c.DoctorNo,
    d.DoctorName    AS ConsultantName,
    c.SpecialtyName
FROM Consultant c
JOIN Doctor d ON c.DoctorNo = d.DoctorNo
WHERE c.SpecialtyName IN (
    SELECT SpecialtyName
    FROM Consultant
    GROUP BY SpecialtyName
    HAVING COUNT(*) = 1
)
ORDER BY c.SpecialtyName;
GO

-- Q6: Complaints, treatments given, and experience history of the treating doctor
SELECT
    c.ComplaintCode,
    c.Description       AS Complaint,
    t.Description       AS Treatment,
    d.DoctorNo,
    d.DoctorName,
    pe.FromDate,
    pe.ToDate,
    pos.PositionTitle   AS PreviousPosition,
    pe.Establishment
FROM TreatmentRecord tr
JOIN Complaint         c   ON tr.ComplaintCode  = c.ComplaintCode
JOIN Treatment         t   ON tr.TreatmentCode  = t.TreatmentCode
JOIN Doctor            d   ON tr.DoctorNo       = d.DoctorNo
LEFT JOIN PreviousExperience pe ON pe.DoctorNo  = d.DoctorNo
LEFT JOIN Position         pos  ON pe.PositionCode = pos.PositionCode
ORDER BY c.ComplaintCode, d.DoctorName, pe.FromDate;
GO

-- Q7 Patients with more than one complaint and their treatments
SELECT
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
JOIN Complaint       c  ON tr.ComplaintCode = c.ComplaintCode
JOIN Treatment       t  ON tr.TreatmentCode = t.TreatmentCode
WHERE p.PatientNo IN (
    SELECT PatientNo
    FROM TreatmentRecord
    GROUP BY PatientNo
    HAVING COUNT(DISTINCT ComplaintCode) > 1
)
ORDER BY p.PatientName, c.ComplaintCode, tr.DateStarted;
GO

-- Q8: Patients grouped by treatment within complaint
SELECT
    c.ComplaintCode,
    c.Description   AS Complaint,
    t.TreatmentCode,
    t.Description   AS Treatment,
    p.PatientNo,
    p.PatientName,
    tr.DateStarted,
    tr.DateEnded
FROM TreatmentRecord tr
JOIN Complaint   c ON tr.ComplaintCode = c.ComplaintCode
JOIN Treatment   t ON tr.TreatmentCode = t.TreatmentCode
JOIN Patient     p ON tr.PatientNo     = p.PatientNo
ORDER BY c.ComplaintCode, t.TreatmentCode, p.PatientName;
GO


-- Q9: Performance history for a particular doctor (parameterized - replace @DocNo)
DECLARE @DoctNo INT = 201;  -- Change to desired doctor number
SELECT
    d.DoctorNo,
    d.DoctorName,
    ph.GradeDate,
    ph.PerformanceGrade
FROM Doctor d
JOIN PerformanceHistory ph ON ph.DoctorNo = d.DoctorNo
WHERE d.DoctorNo = @DoctNo
ORDER BY ph.GradeDate;
GO

-- Q10: Full medical details for a particular patient 
DECLARE @PatientNo INT = 302;  -- Change to desired patient number
SELECT
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
    d_ic.DoctorName     AS DoctorInCharge,
    cons_d.DoctorName   AS Consultant,
    sp.SpecialtyName,
    c.ComplaintCode,
    c.Description       AS Complaint,
    c.Severity,
    t.Description       AS Treatment,
    t.TreatmentType,
    tr.DateStarted,
    tr.DateEnded,
    tr.Notes,
    tr_doc.DoctorName   AS TreatingDoctor
FROM Patient         p
JOIN CareUnit        cu     ON cu.CareUnitNo    = p.CareUnitNo 
JOIN Bed             b      ON b.BedNo          = p.BedNo
JOIN Doctor          d_ic   ON d_ic.DoctorNo    = p.DoctorInChargeNo
JOIN Consultant      cons   ON cons.DoctorNo    = p.ConsultantNo
JOIN Doctor          cons_d ON cons_d.DoctorNo  = cons.DoctorNo
JOIN Specialty       sp     ON sp.SpecialtyName = cons.SpecialtyName
LEFT JOIN TreatmentRecord tr     ON tr.PatientNo     = p.PatientNo
LEFT JOIN Complaint       c      ON c.ComplaintCode  = tr.ComplaintCode
LEFT JOIN Treatment       t      ON t.TreatmentCode  = tr.TreatmentCode
LEFT JOIN Doctor          tr_doc ON tr_doc.DoctorNo  = tr.DoctorNo
WHERE p.PatientNo = @PatientNo
ORDER BY tr.DateStarted;
GO

-- Q11: Treatments given for a particular complaint between two dates, ordered by treatment
DECLARE @ComplaintCode INT = 402;        -- Change to desired complaint code
DECLARE @StartDate DATE = '2025-01-01';  -- Change to start date
DECLARE @EndDate   DATE = '2025-03-31';  -- Change to end date

SELECT
    c.ComplaintCode,
    c.Description       AS Complaint,
    t.TreatmentCode,
    t.Description       AS Treatment,
    t.TreatmentType,
    p.PatientNo,
    p.PatientName,
    tr.DateStarted,
    tr.DateEnded,
    d.DoctorNo,
    d.DoctorName        AS TreatingDoctor
FROM TreatmentRecord tr
JOIN Complaint c ON tr.ComplaintCode = c.ComplaintCode
JOIN Treatment t ON tr.TreatmentCode = t.TreatmentCode
JOIN Patient   p ON tr.PatientNo     = p.PatientNo
JOIN Doctor    d ON tr.DoctorNo      = d.DoctorNo
WHERE tr.ComplaintCode = @ComplaintCode
  AND tr.DateStarted BETWEEN @StartDate AND @EndDate
ORDER BY t.Description, tr.DateStarted, p.PatientName;
GO


-- Q12: Different positions held by staff and count of staff in each position
SELECT PositionTitle, StaffCount FROM (
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
ORDER BY PositionTitle
GO