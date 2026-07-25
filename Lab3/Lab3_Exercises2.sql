
-- câu 1
-- a: tạo bảng như bình thường
CREATE TABLE Caul(
    ID NUMBER,
    NAME VARCHAR2(20)
);
--

-- b: nhập dữ liệu thì ID sẽ tự động tăng 5
CREATE SEQUENCE CaulSeq
    START WITH 1
    INCREMENT BY 5;
--
    
SET SERVEROUTPUT ON
DECLARE
-- c:
    v_name STUDENT.LastName%TYPE;
    v_ID   STUDENT.StudentID%TYPE;

-- d: student nhiều course nhất
    CURSOR D IS 
        SELECT LastName
        FROM STUDENT S, ENROLLMENT E
        WHERE S.StudentID = E.StudentID
        GROUP BY E.StudentID, LastName
        HAVING COUNT(*) >= ALL (
            SELECT COUNT(*)
            FROM ENROLLMENT
            GROUP BY StudentID
        );

-- e: student ít course nhất
    CURSOR E IS 
        SELECT LastName
        FROM STUDENT S, ENROLLMENT EN
        WHERE S.StudentID = EN.StudentID
        GROUP BY EN.StudentID, LastName
        HAVING COUNT(*) <= ALL (
            SELECT COUNT(*)
            FROM ENROLLMENT
            GROUP BY StudentID
        );

-- f: instructor dạy nhiều class nhất
    CURSOR F IS
        SELECT I.LastName
        FROM INSTRUCTOR I, CLASS C
        WHERE I.InstructorID = C.InstructorID
        GROUP BY I.InstructorID, I.LastName
        HAVING COUNT(*) >= ALL (
            SELECT COUNT(*)
            FROM CLASS
            GROUP BY InstructorID
        );

BEGIN
-- d:
    OPEN D;
    LOOP
        FETCH D INTO v_name;
        EXIT WHEN D%NOTFOUND;

        INSERT INTO Caul VALUES (CaulSeq.NEXTVAL, v_name);
        DBMS_OUTPUT.PUT_LINE('d: student added');
    END LOOP;
    CLOSE D;

    SAVEPOINT A;

-- e:
    OPEN E;
    LOOP
        FETCH E INTO v_name;
        EXIT WHEN E%NOTFOUND;

        INSERT INTO Caul VALUES (CaulSeq.NEXTVAL, v_name);
        DBMS_OUTPUT.PUT_LINE('e: student added');
    END LOOP;
    CLOSE E;

    SAVEPOINT B;

-- f:
    OPEN F;
    LOOP
        FETCH F INTO v_name;
        EXIT WHEN F%NOTFOUND;

        INSERT INTO Caul VALUES (CaulSeq.NEXTVAL, v_name);
        DBMS_OUTPUT.PUT_LINE('f: instructor added');
    END LOOP;
    CLOSE F;

    SAVEPOINT C;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error!');
END;

-- câu 2: nhập student đó, nếu có rồi thì in ra thông tin, nếu chưa thì user tự nhập student đó
SET SERVEROUTPUT ON
DECLARE 
    v_StudentID Student.StudentID%TYPE;
    v_LastName Student.LastName%TYPE;
    v_FirstName Student.FirstName%TYPE;
BEGIN
    v_StudentID := &Student_ID; -- input từ bàn phím
    
    SELECT LastName, FirstName INTO v_LastName, v_FirstName
    FROM Student
    WHERE StudentID = v_StudentID; -- kt ID người nhập có trùng vs ID student có trong bảng ko
    
    DBMS_OUTPUT.PUT_LINE('Student infomation: ' || v_LastName || ', ' || v_FirstName); -- TH tìm đc sv có ID trong bảng
EXCEPTION
-- TH ko tìm đc ID => phải tự nhập in4 mới của student
    WHEN No_Data_Found THEN
        DBMS_OUTPUT.PUT_LINE('Student ID was not found');
        INSERT INTO Student (StudentID, LastName, FirstName) VALUES (v_StudentID, '&LastName', '&FirstName');
        DBMS_OUTPUT.PUT_LINE('This student has been added to table');
END;

-- câu 3: nhập studentID và tính số course có sv đó
SET SERVEROUTPUT ON
DECLARE
    v_StudentID Student.StudentID%TYPE;
    v_NoClass Number;
BEGIN
    v_StudentID := &StudentID;
    SELECT Count(ClassID) INTO v_NoClass
    FROM ENROLLMENT
    WHERE StudentID = v_StudentID
    GROUP BY StudentID;
    
    DBMS_OUTPUT.PUT_LINE('Number of classes: ' || v_NoClass);
EXCEPTION
    WHEN No_Data_Found THEN
        DBMS_OUTPUT.PUT_LINE('Student ID was not found');
END;

-- câu 4
SET SERVEROUTPUT ON
DECLARE
    v_InstructorID INSTRUCTOR.InstructorID%TYPE;
    v_LastName INSTRUCTOR.LastName%TYPE;
    v_NoClass NUMBER;
BEGIN
    v_InstructorID := &InstructorID;

    SELECT I.LastName, COUNT(C.ClassID)
    INTO v_LastName, v_NoClass
    FROM INSTRUCTOR I
    LEFT JOIN CLASS C ON I.InstructorID = C.InstructorID
    WHERE I.InstructorID = v_InstructorID
    GROUP BY I.LastName;

    IF v_NoClass >= 10 THEN
        DBMS_OUTPUT.PUT_LINE('Instructor ' || v_LastName || 
                             ' teaches ' || v_NoClass || 
                             ' sections. This teacher should take a rest!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Instructor ' || v_LastName || 
                             ' teaches ' || v_NoClass || ' sections.');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Instructor not found');
END;

-- câu 5: 
DECLARE
    v_NoStudent NUMBER;
BEGIN
    FOR i IN (SELECT ClassID, ClassNo, StartDateTime, Location, InstructorID, Capacity FROM Class)
    LOOP
        SELECT Count(StudentID) INTO v_NoStudent
        FROM ENROLLMENT 
        WHERE ClassID = i.ClassID;
        DBMS_OUTPUT.PUT_LINE(
        i.ClassID || ', ' || i.ClassNo || ', ' || i.StartDateTime || ', ' || i.Location || ', ' || i.InstructorID 
                || ', ' || i.Capacity || ', ' || v_NoStudent );
    END LOOP;
END;