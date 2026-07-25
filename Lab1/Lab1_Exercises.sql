-- QUESTION 1
-- Create 20 accounts
CREATE USER C##sinhvien01 IDENTIFIED BY password;
CREATE USER C##sinhvien02 IDENTIFIED BY password;
CREATE USER C##sinhvien03 IDENTIFIED BY password;
CREATE USER C##sinhvien04 IDENTIFIED BY password;
CREATE USER C##sinhvien05 IDENTIFIED BY password;
CREATE USER C##sinhvien06 IDENTIFIED BY password;
CREATE USER C##sinhvien07 IDENTIFIED BY password;
CREATE USER C##sinhvien08 IDENTIFIED BY password;
CREATE USER C##sinhvien09 IDENTIFIED BY password;
CREATE USER C##sinhvien10 IDENTIFIED BY password;
CREATE USER C##sinhvien11 IDENTIFIED BY password;
CREATE USER C##sinhvien12 IDENTIFIED BY password;
CREATE USER C##sinhvien13 IDENTIFIED BY password;
CREATE USER C##sinhvien14 IDENTIFIED BY password;
CREATE USER C##sinhvien15 IDENTIFIED BY password;
CREATE USER C##sinhvien16 IDENTIFIED BY password;
CREATE USER C##sinhvien17 IDENTIFIED BY password;
CREATE USER C##sinhvien18 IDENTIFIED BY password;
CREATE USER C##sinhvien19 IDENTIFIED BY password;
CREATE USER C##sinhvien20 IDENTIFIED BY password;

-- allowed to connect
GRANT CONNECT TO C##sinhvien01;
GRANT CONNECT TO C##sinhvien02;
GRANT CONNECT TO C##sinhvien03;
GRANT CONNECT TO C##sinhvien04;
GRANT CONNECT TO C##sinhvien05;
GRANT CONNECT TO C##sinhvien06;
GRANT CONNECT TO C##sinhvien07;
GRANT CONNECT TO C##sinhvien08;
GRANT CONNECT TO C##sinhvien09;
GRANT CONNECT TO C##sinhvien10;
GRANT CONNECT TO C##sinhvien11;
GRANT CONNECT TO C##sinhvien12;
GRANT CONNECT TO C##sinhvien13;
GRANT CONNECT TO C##sinhvien14;
GRANT CONNECT TO C##sinhvien15;
GRANT CONNECT TO C##sinhvien16;
GRANT CONNECT TO C##sinhvien17;
GRANT CONNECT TO C##sinhvien18;
GRANT CONNECT TO C##sinhvien19;
GRANT CONNECT TO C##sinhvien20;

-- QUESTION 2
CREATE ROLE C##Role_QUANTRI;
CREATE ROLE C##Role_NGUOIDUNG;

GRANT CONNECT, RESOURCE, OEM_MONITOR, DBA TO C##ROLE_QUANTRI;
GRANT CONNECT, RESOURCE, OEM_MONITOR TO C##Role_NGUOIDUNG;

-- QUESTION 3
-- Assign Role_QUANTRI to accounts sinhvien01 → sinhvien10
GRANT C##Role_QUANTRI TO C##sinhvien01;
GRANT C##Role_QUANTRI TO C##sinhvien02;
GRANT C##Role_QUANTRI TO C##sinhvien03;
GRANT C##Role_QUANTRI TO C##sinhvien04;
GRANT C##Role_QUANTRI TO C##sinhvien05;
GRANT C##Role_QUANTRI TO C##sinhvien06;
GRANT C##Role_QUANTRI TO C##sinhvien07;
GRANT C##Role_QUANTRI TO C##sinhvien08;
GRANT C##Role_QUANTRI TO C##sinhvien09;
GRANT C##Role_QUANTRI TO C##sinhvien10;

-- Assign Role_NGUOIDUNG to the remaining accounts
GRANT C##Role_NGUOIDUNG TO C##sinhvien11;
GRANT C##Role_NGUOIDUNG TO C##sinhvien12;
GRANT C##Role_NGUOIDUNG TO C##sinhvien13;
GRANT C##Role_NGUOIDUNG TO C##sinhvien14;
GRANT C##Role_NGUOIDUNG TO C##sinhvien15;
GRANT C##Role_NGUOIDUNG TO C##sinhvien16;
GRANT C##Role_NGUOIDUNG TO C##sinhvien17;
GRANT C##Role_NGUOIDUNG TO C##sinhvien18;
GRANT C##Role_NGUOIDUNG TO C##sinhvien19;
GRANT C##Role_NGUOIDUNG TO C##sinhvien20;

                -- CHECK -- 
-- check 20 students (question 1)
SELECT username 
FROM all_users
WHERE username LIKE 'C##SINHVIEN%';

-- check 2 role (QUANTRI, NGUOIDUNG) in database (question 2)
SELECT * 
FROM DBA_ROLES
WHERE ROLE ='C##ROLE_QUANTRI'
OR ROLE ='C##ROLE_NGUOIDUNG';

-- check privileges of roles (ROLE_QUANTRI, ROLE_NGUOIDUNG) (question 2)
SELECT * 
FROM DBA_ROLE_PRIVS
WHERE GRANTEE = 'C##ROLE_QUANTRI' 
   OR GRANTEE = 'C##ROLE_NGUOIDUNG';

-- check role assign for students (Role_QUANTR: sinhvien01 → sinhvien10, Role_NGUOIDUNG: remaining ) (questtion 3)
SELECT *
FROM DBA_ROLE_PRIVS
WHERE GRANTEE LIKE 'C##SINHVIEN%';