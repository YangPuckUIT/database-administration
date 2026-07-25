-- câu 6
SET SERVEROUTPUT ON;

DECLARE
    v_studentID   NUMBER := &StudentID;
    v_classID     NUMBER := &ClassID;
    v_grade       NUMBER;
    v_letter      CHAR(1);

    ex_not_found EXCEPTION;

BEGIN
    -- Lấy điểm
    SELECT Grade
    INTO v_grade
    FROM GRADE
    WHERE StudentID = v_studentID
      AND ClassID = v_classID;

    -- Convert sang chữ
    IF v_grade >= 90 THEN
        v_letter := 'A';
    ELSIF v_grade >= 80 THEN
        v_letter := 'B';
    ELSIF v_grade >= 70 THEN
        v_letter := 'C';
    ELSIF v_grade >= 50 THEN
        v_letter := 'D';
    ELSE
        v_letter := 'F';
    END IF;

    DBMS_OUTPUT.PUT_LINE('Student ' || v_studentID || 
                         ' in class ' || v_classID ||
                         ' has grade: ' || v_letter);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('error, not found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error');
END;

-- câu 7
SET SERVEROUTPUT ON;

DECLARE
    -- Cursor ngoài: lấy course
    CURSOR c_course IS
        SELECT CourseNo, Description
        FROM COURSE;

    -- Cursor trong: lấy class + số lượng student
    CURSOR c_class(p_courseNo NUMBER) IS
        SELECT c.ClassNo,
               COUNT(e.StudentID) AS total_students
        FROM CLASS c
        LEFT JOIN ENROLLMENT e 
            ON c.ClassID = e.ClassID
        WHERE c.CourseNo = p_courseNo
        GROUP BY c.ClassNo;

BEGIN
    -- Loop course
    FOR r_course IN c_course LOOP
        
        DBMS_OUTPUT.PUT_LINE(
            'CourseNo ' || r_course.CourseNo || 
            ' (Description: ' || r_course.Description || ')'
        );

        -- Loop class theo course
        FOR r_class IN c_class(r_course.CourseNo) LOOP
            DBMS_OUTPUT.PUT_LINE(
                '    Class''s number ' || r_class.ClassNo ||
                ' has the number of student enrolled is : ' ||
                r_class.total_students
            );
        END LOOP;

    END LOOP;
END;
