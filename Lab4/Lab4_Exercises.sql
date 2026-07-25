                    -- câu 1
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE find_sname (
    i_student_id IN STUDENT.StudentID%TYPE,
    o_first_name OUT STUDENT.FirstName%TYPE,
    o_last_name OUT STUDENT.LastName%TYPE)
AS
BEGIN
    SELECT FirstName, LastName
    INTO o_first_name, o_last_name
    FROM STUDENT
    WHERE StudentID = i_student_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Student ID was not found');
    -- error number -20000 to -20999
END;
/
-- PL/SQL block
DECLARE
    v_student_id STUDENT.STUDENTID%TYPE;
    v_first_name STUDENT.FIRSTNAME%TYPE;
    v_last_name STUDENT.LASTNAME%TYPE;
BEGIN
    v_student_id := &studentid;
    find_sname(v_student_id, v_first_name, v_last_name);

    DBMS_OUTPUT.PUT_LINE('First name: ' || v_first_name || ' - Last name: ' || v_last_name);
END;
/


                    -- câu 2
CREATE OR REPLACE PROCEDURE print_student_name (i_student_id IN STUDENT.StudentID%TYPE)
AS
    v_first_name STUDENT.FirstName%TYPE;
    v_last_name  STUDENT.LastName%TYPE;
BEGIN
    SELECT FirstName, LastName
    INTO v_first_name, v_last_name
    FROM STUDENT
    WHERE StudentID = i_student_id;

    DBMS_OUTPUT.PUT_LINE('First name: ' || v_first_name || ' - Last name: ' || v_last_name);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Student ID was not found');
        -- xài từ câu 1
END;
/
-- PL/SQL block
SET SERVEROUTPUT ON;
DECLARE
    v_student_id STUDENT.StudentID%TYPE;

BEGIN
    v_student_id := &student_id;
    print_student_name(v_student_id);
END;
/


                    -- câu 3
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE Discount
AS
    v_description COURSE.Description%TYPE;
    v_courseno COURSE.CourseNo%TYPE;
    CURSOR C IS
        SELECT C.CourseNo, Description
        FROM COURSE C, CLASS CL, ENROLLMENT E
        WHERE C.CourseNo = CL.CourseNo AND CL.ClassID = E.ClassID
        GROUP BY C.CourseNo, Description
        HAVING COUNT(StudentID) > 15;
BEGIN
    OPEN C;
    LOOP
        FETCH C INTO v_courseno, v_description;
        EXIT WHEN C%NOTFOUND;
        UPDATE COURSE
        SET Cost = Cost * 0.95
        WHERE CourseNo = v_courseno;

        DBMS_OUTPUT.PUT_LINE('Course name: ' || v_description);
    END LOOP;
    CLOSE C;
END;
/
-- PL/SQL Block
BEGIN
    Discount;
END;
/
-- Check lại giá course sau khi giảm 5%
SELECT C.CourseNo, Description, C.Cost,  COUNT(StudentID)
FROM COURSE C, CLASS CL, ENROLLMENT E
WHERE C.CourseNo = CL.CourseNo AND CL.ClassID = E.ClassID
GROUP BY C.CourseNo, Description, C.Cost
HAVING COUNT(StudentID) > 15;


                    -- câu 4
SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION Total_cost_for_student (i_student_id IN STUDENT.STUDENTID%TYPE)

RETURN COURSE.Cost%TYPE
IS
    v_total_cost COURSE.Cost%TYPE;
BEGIN
    SELECT SUM(Cost) INTO v_total_cost
    FROM COURSE C, CLASS CL, ENROLLMENT E
    WHERE C.CourseNo = CL.CourseNo AND CL.ClassID = E.ClassID
    AND StudentID = i_student_id
    GROUP BY StudentID;
    
    IF v_total_cost IS NULL THEN
        RETURN 0;
    ELSE
        RETURN v_total_cost;
    END IF;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN NULL;
END;
/
-- PL/SQL block
DECLARE
    v_student_id STUDENT.StudentID%TYPE;
    v_total_cost COURSE.Cost%TYPE;
BEGIN
    v_student_id:= &studentid;
    v_total_cost:= Total_cost_for_student(v_student_id);
    
    IF v_total_cost IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Student ID was not found');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Total cost: ' || v_total_cost);
    END IF;
END;
/

                    -- câu 5 ko làm


                    -- câu 6
CREATE OR REPLACE TRIGGER CAU6

BEFORE INSERT OR UPDATE
ON ENROLLMENT
FOR EACH ROW
DECLARE
    v_number_of_courses NUMBER;
BEGIN
    SELECT COUNT(DISTINCT CL.CourseNo)
    INTO v_number_of_courses
    FROM CLASS CL, ENROLLMENT E
    WHERE CL.ClassID = E.ClassID
      AND E.StudentID = :NEW.StudentID;
      
    IF v_number_of_courses >= 4 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Each student must not register for more than 4 courses');
    END IF;
END;
/