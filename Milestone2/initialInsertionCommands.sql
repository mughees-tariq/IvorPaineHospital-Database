--DB Project : IVOR PAINE MEMORIAL HOSPITAL
--INITIAL INSERTION OF ENTRIES : DML

USE IvorPaineHospital;
GO

-- 1. SPECIALTY 
INSERT INTO Specialty (SpecialtyName, Description) VALUES
('Orthopedics',   'Bone and joint disorders'),
('Geriatrics',    'Elderly patient care'),
('Cardiology',    'Heart and vascular diseases'),
('Neurology',     'Brain and nervous system'),
('Pediatrics',    'Children medical care'),
('Oncology',      'Cancer treatment'),
('Dermatology',   'Skin conditions'),
('Psychiatry',    'Mental health disorders'),
('Pulmonology',   'Respiratory diseases'),
('Gastroenterol', 'Digestive system care');
GO


-- 2. WARD 
INSERT INTO Ward (WardName, Location, SpecialtyName) VALUES
('Ward A',   'Block 1 Floor 1',  'Orthopedics'),
('Ward B',   'Block 1 Floor 2',  'Geriatrics'),
('Ward C',   'Block 2 Floor 1',  'Cardiology'),
('Ward D',   'Block 2 Floor 2',  'Neurology'),
('Ward E',   'Block 3 Floor 1',  'Pediatrics'),
('Ward F',   'Block 3 Floor 2',  'Oncology'),
('Ward G',   'Block 4 Floor 1',  'Dermatology'),
('Ward H',   'Block 4 Floor 2',  'Psychiatry'),
('Ward I',   'Block 5 Floor 1',  'Pulmonology'),
('Ward J',   'Block 5 Floor 2',  'Gastroenterol'),
('Ward K',   'Block 6 Floor 1',  'Orthopedics'),
('Ward L',   'Block 6 Floor 2',  'Cardiology');
GO

-- 3. POSITION 
INSERT INTO Position (PositionCode, Description, PositionTitle) VALUES
(1, 'Medical student',         'Student'),
(2, 'Junior houseman',         'JH'),
(3, 'Senior houseman',         'SH'),
(4, 'Assistant registrar',     'AR'),
(5, 'Registrar',               'Registrar'),
(6, 'Consultant specialist',   'Consultant');
GO

-- 4. NURSE 
INSERT INTO Nurse (NurseID, NurseName, DateOfBirth, Address, PositionCode) VALUES
(101, 'Sara Khan',      '1985-03-12', '12 Green St, Islamabad',  NULL),
(102, 'Amna Ali',       '1990-07-22', '45 Blue Ave, Rawalpindi', NULL),
(103, 'Hira Malik',     '1988-11-05', '7 Red Rd, Islamabad',     NULL),
(104, 'Zara Ahmed',     '1992-04-18', '23 Main Blvd, Lahore',    NULL),
(105, 'Nida Hassan',    '1987-09-30', '56 Park Lane, Islamabad', NULL),
(106, 'Rabia Siddiq',   '1993-02-14', '89 Hill Rd, Rawalpindi',  NULL),
(107, 'Saba Qureshi',   '1986-06-25', '34 Oak St, Islamabad',    NULL),
(108, 'Uzma Farooq',    '1991-12-08', '67 Pine Ave, Lahore',     NULL),
(109, 'Maryam Raza',    '1989-08-17', '12 Elm Rd, Islamabad',    NULL),
(110, 'Farah Baig',     '1994-01-29', '90 Maple Blvd, Karachi',  NULL),
(111, 'Ayesha Noor',    '1988-05-11', '15 Cedar Ln, Islamabad',  NULL),
(112, 'Sana Tariq',     '1990-10-03', '28 Birch St, Lahore',     NULL),
(113, 'Iqra Waheed',    '1987-03-22', '42 Willow Ave, Islamabad',NULL),
(114, 'Mishal Javed',   '1992-07-14', '63 Ash Rd, Rawalpindi',   NULL),
(115, 'Tooba Shah',     '1985-11-27', '71 Poplar Blvd, Karachi', NULL);
GO

-- 5. NIGHT SISTER 
INSERT INTO NightSister (NurseID, WardName, IsSedationAllowed, ShiftStart) VALUES
(101, 'Ward A', 1, '20:00'),
(102, 'Ward B', 0, '20:00'),
(103, 'Ward C', 1, '21:00'),
(104, 'Ward D', 0, '20:30');
GO

-- 6. DAY SISTER 
INSERT INTO DaySister (NurseID, WardName, ShiftStart) VALUES
(105, 'Ward A', '07:00'),
(106, 'Ward B', '07:00'),
(107, 'Ward C', '07:30'),
(108, 'Ward D', '07:00');
GO

-- 7. DAY SISTER ROUND TIMES
INSERT INTO DaySisterRound (NurseID, WardRoundTime) VALUES
(105, '09:00'), (105, '14:00'),
(106, '09:30'), (106, '14:30'),
(107, '10:00'), (107, '15:00'),
(108, '09:00'), (108, '16:00');
GO

-- 8. CARE UNIT 
INSERT INTO CareUnit (CareUnitNo, CareUnitName, Capacity, WardName, NurseInChargeID) VALUES
(1,  'CU-Alpha',   8,  'Ward A', NULL),
(2,  'CU-Beta',    6,  'Ward A', NULL),
(3,  'CU-Gamma',   7,  'Ward B', NULL),
(4,  'CU-Delta',   6,  'Ward B', NULL),
(5,  'CU-Epsilon', 8,  'Ward C', NULL),
(6,  'CU-Zeta',    7,  'Ward C', NULL),
(7,  'CU-Eta',     6,  'Ward D', NULL),
(8,  'CU-Theta',   8,  'Ward D', NULL),
(9,  'CU-Iota',    7,  'Ward E', NULL),
(10, 'CU-Kappa',   6,  'Ward E', NULL),
(11, 'CU-Lambda',  8,  'Ward F', NULL),
(12, 'CU-Mu',      7,  'Ward F', NULL),
(13, 'CU-Nu',      6,  'Ward G', NULL),
(14, 'CU-Xi',      8,  'Ward H', NULL),
(15, 'CU-Omicron', 7,  'Ward I', NULL);
GO

-- 9. STAFF NURSE 
INSERT INTO StaffNurse (NurseID, CareUnitNo, SupervisorRating) VALUES
(109, 1,   4),
(110, 3,   5),
(111, 5,   4),
(112, 7,   3);
GO

-- 10. Update CareUnit NurseInChargeID
UPDATE CareUnit SET NurseInChargeID = 109 WHERE CareUnitNo = 1;
UPDATE CareUnit SET NurseInChargeID = 110 WHERE CareUnitNo = 3;
UPDATE CareUnit SET NurseInChargeID = 111 WHERE CareUnitNo = 5;
UPDATE CareUnit SET NurseInChargeID = 112 WHERE CareUnitNo = 7;
GO

-- 11. NON-REGISTERED NURSE 
INSERT INTO NonRegisteredNurse (NurseID, CareUnitNo, TrainingStatus) VALUES
(113, 2, 1),
(114, 4, 0),
(115, 6, 1);
GO

-- 12. NURSE PHONE
INSERT INTO NursePhone (NurseID, PhoneNumber) VALUES
(101, '0300-1234567'), (102, '0301-2345678'), (103, '0302-3456789'),
(104, '0303-4567890'), (105, '0304-5678901'), (106, '0305-6789012'),
(107, '0306-7890123'), (108, '0307-8901234'), (109, '0308-9012345'),
(110, '0309-0123456'), (111, '0310-1234567'), (112, '0311-2345678'),
(113, '0312-3456789'), (114, '0313-4567890'), (115, '0314-5678901');
GO

-- 13. NURSE QUALIFICATIONS
INSERT INTO NurseQualifications (NurseID, Qualification) VALUES
(101, 'BSc Nursing'), (101, 'ICU Cert'),
(102, 'BSc Nursing'), (103, 'MSc Nursing'),
(104, 'BSc Nursing'), (104, 'Pediatric Cert'),
(105, 'BSc Nursing'), (106, 'BSc Nursing'),
(107, 'MSc Nursing'), (108, 'BSc Nursing'),
(109, 'BSc Nursing'), (109, 'Emergency Cert'),
(110, 'BSc Nursing'), (111, 'MSc Nursing'),
(112, 'BSc Nursing'), (113, 'Diploma Nursing'),
(114, 'Diploma Nursing'), (115, 'Diploma Nursing');
GO

-- 14. BED
INSERT INTO Bed (BedNo, BedType, IsOccupied, WardName) VALUES
(1,  'Standard',    1, 'Ward A'), (2,  'Standard',    1, 'Ward A'),
(3,  'ICU',         1, 'Ward A'), (4,  'Standard',    0, 'Ward A'),
(5,  'Standard',    1, 'Ward B'), (6,  'Isolation',   0, 'Ward B'),
(7,  'Standard',    1, 'Ward B'), (8,  'Standard',    1, 'Ward B'),
(9,  'Cardiac',     1, 'Ward C'), (10, 'Standard',    1, 'Ward C'),
(11, 'Standard',    0, 'Ward C'), (12, 'ICU',         1, 'Ward C'),
(13, 'Standard',    1, 'Ward D'), (14, 'Standard',    1, 'Ward D'),
(15, 'Neuro-ICU',   1, 'Ward D'), (16, 'Standard',    0, 'Ward D'),
(17, 'Pediatric',   1, 'Ward E'), (18, 'Pediatric',   1, 'Ward E'),
(19, 'Standard',    1, 'Ward E'), (20, 'Incubator',   0, 'Ward E'),
(21, 'Oncology',    1, 'Ward F'), (22, 'Oncology',    1, 'Ward F'),
(23, 'Standard',    1, 'Ward F'), (24, 'Standard',    0, 'Ward F'),
(25, 'Standard',    1, 'Ward G'), (26, 'Standard',    1, 'Ward H'),
(27, 'Standard',    1, 'Ward I'), (28, 'Standard',    1, 'Ward J'),
(29, 'Standard',    1, 'Ward K'), (30, 'Standard',    1, 'Ward L');
GO

-- 15. DOCTOR 
INSERT INTO Doctor (DoctorNo, DoctorName, Address, DateOfBirth) VALUES
(201, 'Dr. Asad Mir',      '5 University Rd, Islamabad',  '1970-04-15'),
(202, 'Dr. Bilal Rao',     '12 Jinnah Ave, Rawalpindi',   '1975-08-22'),
(203, 'Dr. Chand Iqbal',   '34 Allama Iqbal Rd, Lahore',  '1968-02-10'),
(204, 'Dr. Daud Sheikh',   '78 Constitution Ave, Islamabad','1980-11-05'),
(205, 'Dr. Ehsan Butt',    '23 Mall Rd, Lahore',          '1972-06-30'),
(206, 'Dr. Faraz Gill',    '56 GT Rd, Rawalpindi',        '1978-09-18'),
(207, 'Dr. Ghalib Kazi',   '90 Model Town, Lahore',       '1965-12-25'),
(208, 'Dr. Hamza Lone',    '14 F-7, Islamabad',           '1983-03-07'),
(209, 'Dr. Imran Yusuf',   '67 G-10, Islamabad',          '1977-07-14'),
(210, 'Dr. Javed Chaudhry','89 Gulberg, Lahore',          '1971-01-19');
GO

-- 16. DOCTOR PHONE
INSERT INTO DoctorPhone (DoctorNo, PhoneNumber) VALUES
(201, '0321-1000001'), (202, '0322-2000002'), (203, '0323-3000003'),
(204, '0324-4000004'), (205, '0325-5000005'), (206, '0326-6000006'),
(207, '0327-7000007'), (208, '0328-8000008'), (209, '0329-9000009'),
(210, '0330-1000010');
GO

-- 17. DOCTOR QUALIFICATIONS
INSERT INTO DoctorQualifications (DoctorNo, Qualification) VALUES
(201, 'MBBS'), (201, 'FCPS Orthopedics'),
(202, 'MBBS'), (202, 'MRCP Cardiology'),
(203, 'MBBS'), (203, 'FCPS Neurology'),
(204, 'MBBS'), (204, 'MRCP Geriatrics'),
(205, 'MBBS'), (205, 'FCPS Pediatrics'),
(206, 'MBBS'), (206, 'MRCP Oncology'),
(207, 'MBBS'), (207, 'FCPS Psychiatry'),
(208, 'MBBS'), (208, 'FCPS Pulmonology'),
(209, 'MBBS'), (209, 'MRCP Gastro'),
(210, 'MBBS'), (210, 'FCPS Dermatology');
GO

-- 18. CONSULTANT 
INSERT INTO Consultant (DoctorNo, SpecialtyName) VALUES
(201, 'Orthopedics'),
(202, 'Cardiology'),
(203, 'Neurology'),
(204, 'Geriatrics'),
(205, 'Pediatrics'),
(206, 'Oncology'),
(207, 'Psychiatry'),
(208, 'Pulmonology'),
(209, 'Gastroenterol'),
(210, 'Dermatology');
GO

-- 19. DOCTOR TEAM RECORD (20 records — doctors in consultant teams)
INSERT INTO DoctorTeamRecord (DoctorNo, DateJoined, EndDate, PositionCode, ConsultantNo) VALUES
-- Team of Dr. Asad Mir (201)
(202, '2022-01-01', NULL,         3, 201),
(203, '2021-06-15', NULL,         4, 201),
-- Team of Dr. Bilal Rao (202)
(204, '2020-03-01', '2023-12-31', 2, 202),
(205, '2023-01-01', NULL,         3, 202),
-- Team of Dr. Chand Iqbal (203)
(206, '2019-07-01', NULL,         5, 203),
(207, '2021-09-01', NULL,         2, 203),
-- Team of Dr. Daud Sheikh (204)
(208, '2022-05-01', NULL,         3, 204),
(209, '2020-11-01', NULL,         4, 204),
-- Team of Dr. Ehsan Butt (205)
(210, '2023-02-01', NULL,         2, 205),
(201, '2018-08-01', '2021-12-31', 5, 205),
-- Additional junior housemen (new doctor IDs not consultants — using existing)
(202, '2023-03-01', NULL,         2, 206),
(203, '2022-07-01', NULL,         3, 207),
(204, '2021-04-01', NULL,         4, 208),
(205, '2020-09-01', NULL,         2, 209),
(206, '2023-06-01', NULL,         3, 210),
(207, '2022-01-15', NULL,         2, 201),
(208, '2021-11-01', NULL,         3, 202),
(209, '2023-08-01', NULL,         2, 203),
(210, '2022-04-01', NULL,         4, 204),
(201, '2023-10-01', NULL,         3, 205);
GO

-- 20. PREVIOUS EXPERIENCE
INSERT INTO PreviousExperience (DoctorNo, FromDate, ToDate, Establishment, PositionCode) VALUES
(201, '2010-01-01', '2015-12-31', 'PIMS Hospital',    2),
(201, '2016-01-01', '2019-12-31', 'Shifa Hospital',   3),
(202, '2012-06-01', '2018-05-31', 'Holy Family Hosp', 2),
(203, '2008-03-01', '2014-02-28', 'Services Hosp',    2),
(203, '2014-03-01', '2018-12-31', 'Jinnah Hospital',  3),
(204, '2015-07-01', '2020-06-30', 'CMH Rawalpindi',   2),
(205, '2011-09-01', '2017-08-31', 'Childrens Hosp',   2),
(206, '2013-04-01', '2019-03-31', 'Mayo Hospital',    3),
(207, '2009-02-01', '2016-01-31', 'Fountain House',   2),
(208, '2014-10-01', '2020-09-30', 'Gulab Devi Hosp',  2),
(209, '2010-05-01', '2018-04-30', 'Sheikh Zayed Hosp',3),
(210, '2012-11-01', '2019-10-31', 'Skin Care Clinic', 2);
GO

-- 21. PERFORMANCE HISTORY 
INSERT INTO PerformanceHistory (DoctorNo, GradeDate, PerformanceGrade) VALUES
(201, '2022-06-30', 'Excellent'),
(201, '2022-12-31', 'Excellent'),
(201, '2023-06-30', 'Outstanding'),
(202, '2022-06-30', 'Good'),
(202, '2022-12-31', 'Excellent'),
(202, '2023-06-30', 'Excellent'),
(203, '2022-06-30', 'Good'),
(203, '2022-12-31', 'Good'),
(203, '2023-06-30', 'Excellent'),
(204, '2022-06-30', 'Satisfactory'),
(204, '2022-12-31', 'Good'),
(204, '2023-06-30', 'Good'),
(205, '2022-06-30', 'Excellent'),
(205, '2023-06-30', 'Outstanding'),
(206, '2022-06-30', 'Good'),
(206, '2023-06-30', 'Excellent'),
(207, '2022-12-31', 'Good'),
(207, '2023-06-30', 'Satisfactory'),
(208, '2022-06-30', 'Excellent'),
(209, '2023-06-30', 'Good'),
(210, '2022-12-31', 'Good'),
(210, '2023-06-30', 'Excellent');
GO

-- 22. PATIENT 
INSERT INTO Patient (PatientNo, PatientName, DateOfBirth, Address, CareUnitNo, DischargeDate, DateAdmitted, BedNo, ConsultantNo, DoctorInChargeNo) VALUES
(301, 'Ali Hassan',      '1980-05-12', '12 F-7, Islamabad',      1,  NULL,         '2025-01-10', 1,  201, 201),
(302, 'Bilal Ahmed',     '1955-09-22', '45 G-9, Islamabad',      3,  NULL,         '2025-01-15', 5,  204, 204),
(303, 'Chand Begum',     '1990-03-08', '7 I-8, Islamabad',       5,  NULL,         '2025-01-20', 9,  202, 202),
(304, 'Dania Malik',     '1975-11-30', '23 G-6, Islamabad',      7,  NULL,         '2025-01-25', 13, 203, 203),
(305, 'Ehsan Ullah',     '2010-07-14', '56 F-8, Islamabad',      9,  NULL,         '2025-02-01', 17, 205, 205),
(306, 'Fatima Noor',     '1968-02-28', '89 I-9, Islamabad',      11, NULL,         '2025-02-05', 21, 206, 206),
(307, 'Gulnaz Perveen',  '1995-08-19', '34 G-11, Islamabad',     13, NULL,         '2025-02-10', 25, 210, 210),
(308, 'Hamid Raza',      '1972-04-03', '67 F-6, Islamabad',      14, NULL,         '2025-02-12', 26, 207, 207),
(309, 'Iqra Bibi',       '1988-12-25', '12 I-10, Islamabad',     15, NULL,         '2025-02-15', 27, 208, 208),
(310, 'Javed Khan',      '1965-06-17', '90 G-7, Islamabad',      1,  '2025-03-01', '2025-01-05', 2,  201, 201),
(311, 'Kiran Shahid',    '1992-10-09', '15 F-10, Islamabad',     3,  NULL,         '2025-02-20', 6,  204, 204),
(312, 'Layla Iqbal',     '1983-01-31', '28 G-8, Islamabad',      5,  NULL,         '2025-02-22', 10, 202, 202),
(313, 'Mohsin Ali',      '1978-07-23', '42 I-7, Islamabad',      7,  NULL,         '2025-02-25', 14, 203, 203),
(314, 'Naila Farhat',    '2008-03-15', '63 F-9, Islamabad',      9,  NULL,         '2025-03-01', 18, 205, 205),
(315, 'Omar Saeed',      '1960-09-07', '71 G-10, Islamabad',     11, NULL,         '2025-03-03', 22, 206, 206),
(316, 'Parveen Akhtar',  '1985-05-20', '5 I-6, Islamabad',       13, NULL,         '2025-03-05', 25, 210, 210),
(317, 'Qasim Mir',       '1970-11-12', '22 F-7, Islamabad',      14, NULL,         '2025-03-08', 26, 207, 207),
(318, 'Razia Begum',     '1950-04-04', '37 G-9, Islamabad',      15, NULL,         '2025-03-10', 27, 208, 208),
(319, 'Shahid Mehmood',  '1988-08-28', '48 I-8, Islamabad',      1,  NULL,         '2025-03-12', 3,  201, 202),
(320, 'Tahira Iqbal',    '1973-02-16', '59 G-6, Islamabad',      3,  NULL,         '2025-03-14', 7,  204, 203),
(321, 'Usman Ghani',     '2015-06-11', '70 F-8, Islamabad',      9,  NULL,         '2025-03-15', 19, 205, 205),
(322, 'Veena Siddiq',    '1963-12-03', '81 G-11, Islamabad',     5,  NULL,         '2025-03-17', 12, 202, 206),
(323, 'Waqas Niazi',     '1995-03-27', '92 I-9, Islamabad',      11, NULL,         '2025-03-19', 23, 206, 201),
(324, 'Xenia Baig',      '1980-09-19', '14 F-6, Islamabad',      7,  NULL,         '2025-03-20', 15, 203, 204),
(325, 'Yousaf Ranjha',   '1958-05-05', '25 G-7, Islamabad',      1,  NULL,         '2025-03-22', 1,  201, 201),
(326, 'Zainab Toor',     '1991-01-14', '36 I-10, Islamabad',     3,  NULL,         '2025-03-24', 8,  204, 208),
(327, 'Arif Sultan',     '1976-07-07', '47 F-10, Islamabad',     5,  NULL,         '2025-03-26', 10, 202, 202),
(328, 'Bashir Ahmad',    '1967-03-21', '58 G-8, Islamabad',      7,  NULL,         '2025-03-28', 13, 203, 209),
(329, 'Cyrus Khan',      '2012-11-09', '69 I-7, Islamabad',      9,  NULL,         '2025-03-30', 17, 205, 205),
(330, 'Diana Gul',       '1982-08-31', '80 F-9, Islamabad',      11, NULL,         '2025-04-01', 21, 206, 210);
GO

-- 23. PATIENT PHONE
INSERT INTO PatientPhoneNumber (PatientNo, PhoneNumber) VALUES
(301,'0311-1000001'),(302,'0311-1000002'),(303,'0311-1000003'),
(304,'0311-1000004'),(305,'0311-1000005'),(306,'0311-1000006'),
(307,'0311-1000007'),(308,'0311-1000008'),(309,'0311-1000009'),
(310,'0311-1000010'),(311,'0311-1000011'),(312,'0311-1000012'),
(313,'0311-1000013'),(314,'0311-1000014'),(315,'0311-1000015'),
(316,'0311-1000016'),(317,'0311-1000017'),(318,'0311-1000018'),
(319,'0311-1000019'),(320,'0311-1000020'),(321,'0311-1000021'),
(322,'0311-1000022'),(323,'0311-1000023'),(324,'0311-1000024'),
(325,'0311-1000025'),(326,'0311-1000026'),(327,'0311-1000027'),
(328,'0311-1000028'),(329,'0311-1000029'),(330,'0311-1000030');
GO

-- 24. COMPLAINT 
INSERT INTO Complaint (ComplaintCode, Description, Severity) VALUES
(401, 'Fractured Femur',       'High'),
(402, 'Hypertension',          'Medium'),
(403, 'Chest Pain',            'High'),
(404, 'Migraine',              'Low'),
(405, 'Asthma Attack',         'High'),
(406, 'Lung Cancer',           'Critical'),
(407, 'Eczema',                'Low'),
(408, 'Depression',            'Medium'),
(409, 'Pneumonia',             'High'),
(410, 'Gastric Ulcer',         'Medium'),
(411, 'Knee Arthritis',        'Medium'),
(412, 'Atrial Fibrillation',   'High'),
(413, 'Epilepsy',              'High'),
(414, 'Type 2 Diabetes',       'Medium'),
(415, 'Colorectal Cancer',     'Critical');
GO

-- 25. TREATMENT 
INSERT INTO Treatment (TreatmentCode, Description, TreatmentType, Duration) VALUES
(501, 'Femur Fixation Surgery', 'Surgical',      '3 hours'),
(502, 'Antihypertensives',      'Medication',    '6 months'),
(503, 'Angioplasty',            'Surgical',      '2 hours'),
(504, 'Triptan Therapy',        'Medication',    '2 weeks'),
(505, 'Bronchodilator',         'Medication',    '1 week'),
(506, 'Chemotherapy',           'Oncology',      '6 months'),
(507, 'Topical Corticosteroid', 'Medication',    '4 weeks'),
(508, 'Cognitive Therapy',      'Psychotherapy', '3 months'),
(509, 'IV Antibiotics',         'Medication',    '2 weeks'),
(510, 'Proton Pump Inhibitors', 'Medication',    '8 weeks'),
(511, 'Physiotherapy',          'Rehabilitation','3 months'),
(512, 'Cardioversion',          'Procedure',     '1 session'),
(513, 'Anticonvulsants',        'Medication',    'Ongoing'),
(514, 'Metformin Therapy',      'Medication',    'Ongoing'),
(515, 'Bowel Resection',        'Surgical',      '4 hours');
GO

-- 26. TREATMENT RECORD 
INSERT INTO TreatmentRecord (PatientNo, ComplaintCode, TreatmentCode, DateStarted, DateEnded, Notes, DoctorNo) VALUES
-- Patient 301: Fractured Femur + Knee Arthritis
(301, 401, 501, '2025-01-11', '2025-01-11', 'Surgery successful',           201),
(301, 411, 511, '2025-01-15', NULL,          'Physio started post-op',       201),
-- Patient 302: Hypertension + Diabetes
(302, 402, 502, '2025-01-16', NULL,          'BP monitoring ongoing',        204),
(302, 414, 514, '2025-01-20', NULL,          'HbA1c check monthly',          204),
-- Patient 303: Chest Pain + AF
(303, 403, 503, '2025-01-21', '2025-02-05', 'Angioplasty completed',        202),
(303, 412, 512, '2025-01-25', '2025-01-25', 'Cardioversion successful',     202),
-- Patient 304: Migraine
(304, 404, 504, '2025-01-26', '2025-02-09', 'Patient improved',             203),
-- Patient 305: Asthma
(305, 405, 505, '2025-02-02', NULL,          'Inhaler prescribed',           205),
-- Patient 306: Lung Cancer
(306, 406, 506, '2025-02-06', NULL,          'First chemo cycle started',    206),
-- Patient 307: Eczema
(307, 407, 507, '2025-02-11', '2025-03-11', 'Cream applied twice daily',    210),
-- Patient 308: Depression
(308, 408, 508, '2025-02-13', NULL,          'Weekly sessions scheduled',    207),
-- Patient 309: Pneumonia
(309, 409, 509, '2025-02-16', '2025-03-02', 'IV course completed',          208),
-- Patient 310: Gastric Ulcer (discharged)
(310, 410, 510, '2025-01-06', '2025-02-28', 'Fully recovered',              201),
-- Patient 311: Hypertension
(311, 402, 502, '2025-02-21', NULL,          'Lifestyle advice given',       204),
-- Patient 312: AF + Chest Pain
(312, 412, 512, '2025-02-23', '2025-02-23', 'Rhythm restored',              202),
(312, 403, 503, '2025-02-25', NULL,          'Monitoring post angioplasty',  202),
-- Patient 313: Epilepsy
(313, 413, 513, '2025-02-26', NULL,          'Dose adjusted',                203),
-- Patient 314: Asthma
(314, 405, 505, '2025-03-02', NULL,          'Nebulizer therapy started',    205),
-- Patient 315: Colorectal Cancer
(315, 415, 515, '2025-03-04', '2025-03-04', 'Resection completed',          206),
(315, 415, 506, '2025-03-10', NULL,          'Adjuvant chemo started',       206),
-- Patient 316: Eczema
(316, 407, 507, '2025-03-06', NULL,          'Improvement noted',            210),
-- Patient 317: Depression
(317, 408, 508, '2025-03-09', NULL,          'Medication added',             207),
-- Patient 318: Pneumonia
(318, 409, 509, '2025-03-11', NULL,          'Elderly patient — close obs',  208),
-- Patient 319: Fractured Femur
(319, 401, 501, '2025-03-13', '2025-03-13', 'Open reduction done',          202),
(319, 401, 511, '2025-03-18', NULL,          'Rehab initiated',              201),
-- Patient 320: Hypertension + Migraine
(320, 402, 502, '2025-03-15', NULL,          'BP borderline',                203),
(320, 404, 504, '2025-03-16', NULL,          'Triptans prescribed',          204),
-- Patient 321: Asthma (pediatric)
(321, 405, 505, '2025-03-16', NULL,          'Pediatric dose',               205),
-- Patient 322: Chest Pain
(322, 403, 503, '2025-03-18', NULL,          'Stent placement done',         206),
-- Patient 323: Lung Cancer
(323, 406, 506, '2025-03-20', NULL,          'Cycle 2 in progress',          201),
-- Patient 324: Epilepsy + Migraine
(324, 413, 513, '2025-03-21', NULL,          'Valproate started',            204),
(324, 404, 504, '2025-03-22', NULL,          'Separate treatment plan',      203),
-- Patient 325: Knee Arthritis
(325, 411, 511, '2025-03-23', NULL,          'Walking aids provided',        201),
-- Patient 326: Hypertension
(326, 402, 502, '2025-03-25', NULL,          'ACE inhibitor prescribed',     208),
-- Patient 327: Gastric Ulcer + Diabetes
(327, 410, 510, '2025-03-27', NULL,          'Endoscopy done',               202),
(327, 414, 514, '2025-03-28', NULL,          'Insulin considered',           202),
-- Patient 328: Migraine
(328, 404, 504, '2025-03-29', NULL,          'Preventive therapy started',   209),
-- Patient 329: Asthma (pediatric)
(329, 405, 505, '2025-03-31', NULL,          'Salbutamol inhaler',           205),
-- Patient 330: Colorectal Cancer
(330, 415, 515, '2025-04-02', NULL,          'Surgery scheduled',            210),
(330, 415, 506, '2025-04-05', NULL,          'Pre-op chemo started',         206);
GO


-- VERIFICATION COUNTS
SELECT 'Specialty' AS TableName,        COUNT(*) AS RecordCount FROM Specialty
UNION ALL SELECT 'Ward',                COUNT(*) FROM Ward
UNION ALL SELECT 'Nurse',               COUNT(*) FROM Nurse
UNION ALL SELECT 'NursePhone',          COUNT(*) FROM NursePhone
UNION ALL SELECT 'NurseQualifications', COUNT(*) FROM NurseQualifications
UNION ALL SELECT 'NightSister',         COUNT(*) FROM NightSister
UNION ALL SELECT 'DaySister',           COUNT(*) FROM DaySister
UNION ALL SELECT 'DaySisterRound',      COUNT(*) FROM DaySisterRound
UNION ALL SELECT 'Position',            COUNT(*) FROM Position
UNION ALL SELECT 'CareUnit',            COUNT(*) FROM CareUnit
UNION ALL SELECT 'StaffNurse',          COUNT(*) FROM StaffNurse
UNION ALL SELECT 'NonRegNurse',         COUNT(*) FROM NonRegisteredNurse
UNION ALL SELECT 'Bed',                 COUNT(*) FROM Bed
UNION ALL SELECT 'Doctor',              COUNT(*) FROM Doctor
UNION ALL SELECT 'DoctorPhone',         COUNT(*) FROM DoctorPhone
UNION ALL SELECT 'DoctorQualifications',COUNT(*) FROM DoctorQualifications
UNION ALL SELECT 'Consultant',          COUNT(*) FROM Consultant
UNION ALL SELECT 'DoctorTeamRecord',    COUNT(*) FROM DoctorTeamRecord
UNION ALL SELECT 'PrevExperience',      COUNT(*) FROM PreviousExperience
UNION ALL SELECT 'PerfHistory',         COUNT(*) FROM PerformanceHistory
UNION ALL SELECT 'Patient',             COUNT(*) FROM Patient
UNION ALL SELECT 'PatientPhoneNumber',  COUNT(*) FROM PatientPhoneNumber
UNION ALL SELECT 'Complaint',           COUNT(*) FROM Complaint
UNION ALL SELECT 'Treatment',           COUNT(*) FROM Treatment
UNION ALL SELECT 'TreatmentRecord',     COUNT(*) FROM TreatmentRecord

ORDER BY TableName;
GO

USE master;
GO