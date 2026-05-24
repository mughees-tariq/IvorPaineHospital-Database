--DB Project : IVOR PAINE MEMORIAL HOSPITAL
--DDL:

USE master;
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'IvorPaineHospital')
    DROP DATABASE IvorPaineHospital;
GO
CREATE DATABASE IvorPaineHospital;
GO
USE IvorPaineHospital;
GO

--Table Creation : DDL

--1 Specialty
CREATE TABLE Specialty (
    SpecialtyName VARCHAR(20) NOT NULL,
    Description   VARCHAR(50),
    CONSTRAINT PK_Specialty PRIMARY KEY (SpecialtyName)
);
GO

-- 2. WARD
CREATE TABLE Ward (
    WardName      VARCHAR(20) NOT NULL,
    Location      VARCHAR(20),
    SpecialtyName VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Ward PRIMARY KEY (WardName),
    CONSTRAINT FK_Ward_Specialty FOREIGN KEY (SpecialtyName)
        REFERENCES Specialty(SpecialtyName)
);
GO

-- 3. NURSE
CREATE TABLE Nurse (
    NurseID      INT NOT NULL,
    NurseName    VARCHAR(20),
    DateOfBirth  DATE,
    Address      VARCHAR(50),
    PositionCode INT,        -- FK to Position, added after Position table
    CONSTRAINT PK_Nurse PRIMARY KEY (NurseID)
);
GO

-- 4. POSITION
CREATE TABLE Position (
    PositionCode  INT         NOT NULL,
    Description   VARCHAR(50),
    PositionTitle VARCHAR(20),
    CONSTRAINT PK_Position PRIMARY KEY (PositionCode)
);
GO

-- FK from Nurse to Position
ALTER TABLE Nurse
    ADD CONSTRAINT FK_Nurse_Position FOREIGN KEY (PositionCode)
        REFERENCES Position(PositionCode);
GO

-- 5. NURSE PHONE (multi-valued)
CREATE TABLE NursePhone (
    NurseID     INT         NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    CONSTRAINT PK_NursePhone    PRIMARY KEY (NurseID, PhoneNumber),
    CONSTRAINT FK_NursePhone_Nurse FOREIGN KEY (NurseID)
        REFERENCES Nurse(NurseID)
);
GO

-- 6. NURSE QUALIFICATIONS (multi-valued)
CREATE TABLE NurseQualifications (
    NurseID       INT         NOT NULL,
    Qualification VARCHAR(50) NOT NULL,
    CONSTRAINT PK_NurseQual    PRIMARY KEY (NurseID, Qualification),
    CONSTRAINT FK_NurseQual_Nurse FOREIGN KEY (NurseID)
        REFERENCES Nurse(NurseID)
);
GO

-- 7. NIGHT SISTER (subtype)
CREATE TABLE NightSister (
    NurseID          INT     NOT NULL,
    WardName         VARCHAR(20) NOT NULL,
    IsSedationAllowed BIT,
    ShiftStart       TIME,
    CONSTRAINT PK_NightSister     PRIMARY KEY (NurseID),
    CONSTRAINT FK_NightSister_Nurse FOREIGN KEY (NurseID)
        REFERENCES Nurse(NurseID),
    CONSTRAINT FK_NightSister_Ward  FOREIGN KEY (WardName)
        REFERENCES Ward(WardName)
);
GO

-- 8. DAY SISTER (subtype)
CREATE TABLE DaySister (
    NurseID   INT         NOT NULL,
    WardName  VARCHAR(20) NOT NULL,
    ShiftStart TIME,
    CONSTRAINT PK_DaySister     PRIMARY KEY (NurseID),
    CONSTRAINT FK_DaySister_Nurse FOREIGN KEY (NurseID)
        REFERENCES Nurse(NurseID),
    CONSTRAINT FK_DaySister_Ward  FOREIGN KEY (WardName)
        REFERENCES Ward(WardName)
);
GO

-- 9. DAY SISTER WARD ROUND TIME (multi-valued)
CREATE TABLE DaySisterRound (
    NurseID       INT  NOT NULL,
    WardRoundTime TIME NOT NULL,
    CONSTRAINT PK_DaySisterRound      PRIMARY KEY (NurseID, WardRoundTime),
    CONSTRAINT FK_DaySisterRound_DS   FOREIGN KEY (NurseID)
        REFERENCES DaySister(NurseID)
);
GO

-- 10. CARE UNIT (weak entity, depends on Ward)
CREATE TABLE CareUnit (
    CareUnitNo    INT         NOT NULL,
    CareUnitName  VARCHAR(20),
    Capacity      INT,
    WardName      VARCHAR(20) NOT NULL,
    NurseInChargeID INT,      -- FK to StaffNurse, added later
    CONSTRAINT PK_CareUnit    PRIMARY KEY (CareUnitNo, WardName),
    CONSTRAINT UQ_CareUnit_CareUnitNo UNIQUE (CareUnitNo),--unique to be referenced singularly by staffnurse
    CONSTRAINT FK_CareUnit_Ward FOREIGN KEY (WardName)
        REFERENCES Ward(WardName)
);
GO

-- 11. STAFF NURSE (subtype)
CREATE TABLE StaffNurse (
    NurseID        INT NOT NULL,
    CareUnitNo     INT NOT NULL,
    SupervisorRating INT,
    CONSTRAINT PK_StaffNurse       PRIMARY KEY (NurseID),
    CONSTRAINT FK_StaffNurse_Nurse  FOREIGN KEY (NurseID)
        REFERENCES Nurse(NurseID),
    CONSTRAINT FK_StaffNurse_CU    FOREIGN KEY (CareUnitNo)
        REFERENCES CareUnit(CareUnitNo)
);
GO

-- adding NurseInChargeID FK to CareUnit
ALTER TABLE CareUnit
    ADD CONSTRAINT FK_CareUnit_StaffNurse FOREIGN KEY (NurseInChargeID)
        REFERENCES StaffNurse(NurseID);
GO

-- 12. NON-REGISTERED NURSE (subtype)
CREATE TABLE NonRegisteredNurse (
    NurseID       INT NOT NULL,
    CareUnitNo    INT NOT NULL,
    TrainingStatus BIT,
    CONSTRAINT PK_NRNurse       PRIMARY KEY (NurseID),
    CONSTRAINT FK_NRNurse_Nurse  FOREIGN KEY (NurseID)
        REFERENCES Nurse(NurseID),
    CONSTRAINT FK_NRNurse_CU    FOREIGN KEY (CareUnitNo)
        REFERENCES CareUnit(CareUnitNo)
);
GO

-- 13. BED (weak entity, depends on Ward via CareUnit)
CREATE TABLE Bed (
    BedNo      INT         NOT NULL,
    BedType    VARCHAR(20),
    IsOccupied BIT,
    WardName   VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Bed       PRIMARY KEY (BedNo),
    CONSTRAINT FK_Bed_Ward  FOREIGN KEY (WardName)
        REFERENCES Ward(WardName)
);
GO

-- 14. DOCTOR
CREATE TABLE Doctor (
    DoctorNo    INT         NOT NULL,
    DoctorName  VARCHAR(20),
    Address     VARCHAR(50),
    DateOfBirth DATE,
    CONSTRAINT PK_Doctor PRIMARY KEY (DoctorNo)
);
GO

-- 15. DOCTOR PHONE (multi-valued)
CREATE TABLE DoctorPhone (
    DoctorNo    INT         NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    CONSTRAINT PK_DoctorPhone      PRIMARY KEY (DoctorNo, PhoneNumber),
    CONSTRAINT FK_DoctorPhone_Doc  FOREIGN KEY (DoctorNo)
        REFERENCES Doctor(DoctorNo)
);
GO

-- 16. DOCTOR QUALIFICATIONS (multi-valued)
CREATE TABLE DoctorQualifications (
    DoctorNo      INT         NOT NULL,
    Qualification VARCHAR(50) NOT NULL,
    CONSTRAINT PK_DoctorQual     PRIMARY KEY (DoctorNo, Qualification),
    CONSTRAINT FK_DoctorQual_Doc FOREIGN KEY (DoctorNo)
        REFERENCES Doctor(DoctorNo)
);
GO

-- 17. CONSULTANT (subtype of Doctor)
CREATE TABLE Consultant (
    DoctorNo      INT         NOT NULL,
    SpecialtyName VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Consultant        PRIMARY KEY (DoctorNo),
    CONSTRAINT FK_Consultant_Doc    FOREIGN KEY (DoctorNo)
        REFERENCES Doctor(DoctorNo),
    CONSTRAINT FK_Consultant_Spec   FOREIGN KEY (SpecialtyName)
        REFERENCES Specialty(SpecialtyName)
);
GO

-- 18. DOCTOR TEAM RECORD
CREATE TABLE DoctorTeamRecord (
    DoctorNo      INT         NOT NULL,
    DateJoined    DATE        NOT NULL,
    EndDate       DATE,
    PositionCode  INT         NOT NULL,
    ConsultantNo  INT         NOT NULL,
    CONSTRAINT PK_DoctorTeamRecord        PRIMARY KEY (DoctorNo, DateJoined),
    CONSTRAINT FK_DTR_Doctor              FOREIGN KEY (DoctorNo)
        REFERENCES Doctor(DoctorNo),
    CONSTRAINT FK_DTR_Position            FOREIGN KEY (PositionCode)
        REFERENCES Position(PositionCode),
    CONSTRAINT FK_DTR_Consultant          FOREIGN KEY (ConsultantNo)
        REFERENCES Consultant(DoctorNo)
);
GO

-- 19. PREVIOUS EXPERIENCE
CREATE TABLE PreviousExperience (
    DoctorNo      INT         NOT NULL,
    FromDate      DATE        NOT NULL,
    ToDate        DATE,
    Establishment VARCHAR(20),
    PositionCode  INT         NOT NULL,
    CONSTRAINT PK_PrevExp        PRIMARY KEY (DoctorNo, FromDate, PositionCode),
    CONSTRAINT FK_PrevExp_Doctor  FOREIGN KEY (DoctorNo)
        REFERENCES Doctor(DoctorNo),
    CONSTRAINT FK_PrevExp_Pos    FOREIGN KEY (PositionCode)
        REFERENCES Position(PositionCode)
);
GO

-- 20. PERFORMANCE HISTORY
CREATE TABLE PerformanceHistory (
    DoctorNo         INT         NOT NULL,
    GradeDate        DATE        NOT NULL,
    PerformanceGrade VARCHAR(20) NOT NULL,
    CONSTRAINT PK_PerfHist        PRIMARY KEY (DoctorNo, GradeDate),
    CONSTRAINT FK_PerfHist_Doctor  FOREIGN KEY (DoctorNo)
        REFERENCES Doctor(DoctorNo)
);
GO

-- 21. PATIENT
CREATE TABLE Patient (
    PatientNo        INT         NOT NULL,
    PatientName      VARCHAR(20),
    DateOfBirth      DATE,
    Address          VARCHAR(50),
    CareUnitNo       INT         NOT NULL,
    DischargeDate    DATE,
    DateAdmitted     DATE,
    BedNo            INT         NOT NULL,
    ConsultantNo     INT         NOT NULL,
    DoctorInChargeNo INT         NOT NULL,
    CONSTRAINT PK_Patient              PRIMARY KEY (PatientNo),
    CONSTRAINT FK_Patient_CareUnit     FOREIGN KEY (CareUnitNo)
        REFERENCES CareUnit(CareUnitNo),
    CONSTRAINT FK_Patient_Bed          FOREIGN KEY (BedNo)
        REFERENCES Bed(BedNo),
    CONSTRAINT FK_Patient_Consultant   FOREIGN KEY (ConsultantNo)
        REFERENCES Consultant(DoctorNo),
    CONSTRAINT FK_Patient_DocInCharge  FOREIGN KEY (DoctorInChargeNo)
        REFERENCES Doctor(DoctorNo)
);
GO

-- 22. PATIENT PHONE (multi-valued)
CREATE TABLE PatientPhoneNumber (
    PatientNo   INT         NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    CONSTRAINT PK_PatientPhone      PRIMARY KEY (PatientNo, PhoneNumber),
    CONSTRAINT FK_PatientPhone_Pat  FOREIGN KEY (PatientNo)
        REFERENCES Patient(PatientNo)
);
GO

-- 23. COMPLAINT
CREATE TABLE Complaint (
    ComplaintCode INT         NOT NULL,
    Description   VARCHAR(100),
    Severity      VARCHAR(10),
    CONSTRAINT PK_Complaint PRIMARY KEY (ComplaintCode)
);
GO

--24. TREATMENT
CREATE TABLE Treatment (
    TreatmentCode INT         NOT NULL,
    Description   VARCHAR(100),
    TreatmentType VARCHAR(30),
    Duration      VARCHAR(20),
    CONSTRAINT PK_Treatment PRIMARY KEY (TreatmentCode)
);
GO

-- 25. TREATMENT RECORD (weak entity)
CREATE TABLE TreatmentRecord (
    PatientNo     INT  NOT NULL,
    ComplaintCode INT  NOT NULL,
    TreatmentCode INT  NOT NULL,
    DateStarted   DATE NOT NULL,
    DateEnded     DATE,
    Notes         VARCHAR(500),
    DoctorNo      INT  NOT NULL,
    CONSTRAINT PK_TreatmentRecord         PRIMARY KEY (PatientNo, ComplaintCode, TreatmentCode, DateStarted),
    CONSTRAINT FK_TR_Patient              FOREIGN KEY (PatientNo)
        REFERENCES Patient(PatientNo),
    CONSTRAINT FK_TR_Complaint            FOREIGN KEY (ComplaintCode)
        REFERENCES Complaint(ComplaintCode),
    CONSTRAINT FK_TR_Treatment            FOREIGN KEY (TreatmentCode)
        REFERENCES Treatment(TreatmentCode),
    CONSTRAINT FK_TR_Doctor               FOREIGN KEY (DoctorNo)
        REFERENCES Doctor(DoctorNo)
);
GO

USE IvorPaineHospital;
GO

-- 1. Specialty
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Specialty')
    PRINT 'Specialty table exists.';
ELSE
    PRINT 'Specialty table does NOT exist.';
GO

-- 2. Ward
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Ward')
    PRINT 'Ward table exists.';
ELSE
    PRINT 'Ward table does NOT exist.';
GO

-- 3. Nurse
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Nurse')
    PRINT 'Nurse table exists.';
ELSE
    PRINT 'Nurse table does NOT exist.';
GO

-- 4. Position
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Position')
    PRINT 'Position table exists.';
ELSE
    PRINT 'Position table does NOT exist.';
GO

-- 5. NursePhone
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'NursePhone')
    PRINT 'NursePhone table exists.';
ELSE
    PRINT 'NursePhone table does NOT exist.';
GO

-- 6. NurseQualifications
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'NurseQualifications')
    PRINT 'NurseQualifications table exists.';
ELSE
    PRINT 'NurseQualifications table does NOT exist.';
GO

-- 7. NightSister
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'NightSister')
    PRINT 'NightSister table exists.';
ELSE
    PRINT 'NightSister table does NOT exist.';
GO

-- 8. DaySister
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DaySister')
    PRINT 'DaySister table exists.';
ELSE
    PRINT 'DaySister table does NOT exist.';
GO

-- 9. DaySisterRound
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DaySisterRound')
    PRINT 'DaySisterRound table exists.';
ELSE
    PRINT 'DaySisterRound table does NOT exist.';
GO

-- 10. CareUnit
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CareUnit')
    PRINT 'CareUnit table exists.';
ELSE
    PRINT 'CareUnit table does NOT exist.';
GO

-- 11. StaffNurse
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'StaffNurse')
    PRINT 'StaffNurse table exists.';
ELSE
    PRINT 'StaffNurse table does NOT exist.';
GO

-- 12. NonRegisteredNurse
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'NonRegisteredNurse')
    PRINT 'NonRegisteredNurse table exists.';
ELSE
    PRINT 'NonRegisteredNurse table does NOT exist.';
GO

-- 13. Bed
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Bed')
    PRINT 'Bed table exists.';
ELSE
    PRINT 'Bed table does NOT exist.';
GO

-- 14. Doctor
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Doctor')
    PRINT 'Doctor table exists.';
ELSE
    PRINT 'Doctor table does NOT exist.';
GO

-- 15. DoctorPhone
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DoctorPhone')
    PRINT 'DoctorPhone table exists.';
ELSE
    PRINT 'DoctorPhone table does NOT exist.';
GO

-- 16. DoctorQualifications
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DoctorQualifications')
    PRINT 'DoctorQualifications table exists.';
ELSE
    PRINT 'DoctorQualifications table does NOT exist.';
GO

-- 17. Consultant
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Consultant')
    PRINT 'Consultant table exists.';
ELSE
    PRINT 'Consultant table does NOT exist.';
GO

-- 18. DoctorTeamRecord
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DoctorTeamRecord')
    PRINT 'DoctorTeamRecord table exists.';
ELSE
    PRINT 'DoctorTeamRecord table does NOT exist.';
GO

-- 19. PreviousExperience
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PreviousExperience')
    PRINT 'PreviousExperience table exists.';
ELSE
    PRINT 'PreviousExperience table does NOT exist.';
GO

-- 20. PerformanceHistory
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PerformanceHistory')
    PRINT 'PerformanceHistory table exists.';
ELSE
    PRINT 'PerformanceHistory table does NOT exist.';
GO

-- 21. Patient
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Patient')
    PRINT 'Patient table exists.';
ELSE
    PRINT 'Patient table does NOT exist.';
GO

-- 22. PatientPhoneNumber
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PatientPhoneNumber')
    PRINT 'PatientPhoneNumber table exists.';
ELSE
    PRINT 'PatientPhoneNumber table does NOT exist.';
GO

-- 23. Complaint
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Complaint')
    PRINT 'Complaint table exists.';
ELSE
    PRINT 'Complaint table does NOT exist.';
GO

-- 24. Treatment
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Treatment')
    PRINT 'Treatment table exists.';
ELSE
    PRINT 'Treatment table does NOT exist.';
GO

-- 25. TreatmentRecord
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TreatmentRecord')
    PRINT 'TreatmentRecord table exists.';
ELSE
    PRINT 'TreatmentRecord table does NOT exist.';
GO

