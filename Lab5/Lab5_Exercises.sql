-- A
-- câu 1
SET SERVEROUTPUT ON;

DECLARE
    v_emp_id s_emp.id%TYPE := &emp_id;
    v_name varchar2(100);
    v_salary s_emp.salary%TYPE;
    v_hra number;
    v_da number;
    v_pf number;
    v_net_salary number;

BEGIN
    SELECT first_name || ' ' || last_name, salary
    INTO v_name, v_salary
    FROM s_emp
    WHERE id = v_emp_id;

    v_hra := v_salary * 0.31;
    v_da  := v_salary * 0.15;

    if v_salary < 1000 then
        v_pf := v_salary * 0.05;

    elsif v_salary between 1000 AND 1500 then
        v_pf := v_salary * 0.07;

    else
        v_pf := v_salary * 0.08;
    end if;

    v_net_salary := v_salary + v_hra + v_da - v_pf;

    DBMS_OUTPUT.PUT_LINE('Employee name : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Basic salary : ' || v_salary);
    DBMS_OUTPUT.PUT_LINE('PF : ' || v_pf);
    DBMS_OUTPUT.PUT_LINE('Net salary : ' || v_net_salary);

EXCEPTION
    when NO_DATA_FOUND then
        DBMS_OUTPUT.PUT_LINE('Employee not found.');

    when others then
        DBMS_OUTPUT.PUT_LINE('Error');
END;

-- câu 2
SET SERVEROUTPUT ON;

DECLARE
    v_id s_emp.id%TYPE := &emp_id;
    v_name varchar2(100);
    v_comm s_emp.commission_pct%TYPE;
    v_bonus number;

BEGIN
    SELECT first_name || ' ' || last_name, commission_pct
    INTO v_name, v_comm
    FROM s_emp
    WHERE id = v_id;

    if v_comm is NULL or v_comm = 0 then
        DBMS_OUTPUT.PUT_LINE(v_name || ' does not earn any commission.');
    else
        v_bonus := v_comm * 0.15;

        DBMS_OUTPUT.PUT_LINE('Employee : ' || v_name);
        DBMS_OUTPUT.PUT_LINE('Commission : ' || v_comm);
        DBMS_OUTPUT.PUT_LINE('Bonus : ' || v_bonus);
    end if;

EXCEPTION
    when NO_DATA_FOUND then
        DBMS_OUTPUT.PUT_LINE('Employee not found');

    when others then
        DBMS_OUTPUT.PUT_LINE('Error');
END;

-- câu 3
set serveroutput on;

DECLARE
    cursor dept_cur is
        select id, name
        from s_dept
        where id between 10 and 40;

    v_dept_id s_dept.id%TYPE;
    v_dept_name s_dept.name%TYPE;
    v_total_emp number;
    v_avg_salary number;

BEGIN
    open dept_cur;

    LOOP
        fetch dept_cur into v_dept_id, v_dept_name;
        exit when dept_cur%notfound;

        select count(*), avg(salary)
        into v_total_emp, v_avg_salary
        from s_emp
        where dept_id = v_dept_id;

        if v_total_emp = 0 then
            dbms_output.put_line('No employees are working in department ' || v_dept_name);

        else
            dbms_output.put_line('Department : ' || v_dept_name);
            dbms_output.put_line('Total employees : ' || v_total_emp);
            dbms_output.put_line('Average salary : ' || round(v_avg_salary,2));
        end if;

    END LOOP;

    close dept_cur;

EXCEPTION
    when others then
        dbms_output.put_line('Error');

END;

-- câu 4
set serveroutput on;

DECLARE
    v_emp_id s_emp.id%TYPE := &emp_id;
    v_salary s_emp.salary%TYPE;
    v_dept_id s_emp.dept_id%TYPE;
    v_avg_salary number;

BEGIN
    select salary, dept_id
    into v_salary, v_dept_id
    from s_emp
    where id = v_emp_id;

    select avg(salary)
    into v_avg_salary
    from s_emp
    where dept_id = v_dept_id;

    if v_salary > v_avg_salary then
        dbms_output.put_line('employee salary is more than average salary');

    else
        dbms_output.put_line('employee salary is less than average salary');
    end if;

EXCEPTION
    when no_data_found then
        dbms_output.put_line('Employee not found');

    when others then
        dbms_output.put_line('Error');

END;

-- câu 5
set serveroutput on;

DECLARE
    v_count number;

BEGIN
    update s_emp
    set salary = salary + (salary * 0.15)
    where dept_id = 10;

    v_count := sql%rowcount;

    dbms_output.put_line(v_count || ' employees were awarded the increase');
    commit;

EXCEPTION
    when others then
        dbms_output.put_line('Error');

END;

-- câu 6
-- tạo bảng
create table old_dept as
select *
from s_dept
where 1 = 2;

-- lệnh
set serveroutput on;

DECLARE
    v_count number;

BEGIN
    insert into old_dept
    select *
    from s_dept;

    v_count := sql%rowcount;

    dbms_output.put_line(v_count || ' rows were copied');

    commit;

EXCEPTION
    when others then
        dbms_output.put_line('Error');

END;

--B
-- câu 1
create or replace procedure print_emp_by_title(p_title varchar2)

IS
    cursor emp_cur is
        select id, first_name, last_name, salary
        from s_emp
        where title = p_title;

    v_count number := 0;

BEGIN
    for emp_rec in emp_cur loop

        dbms_output.put_line('ID: ' || emp_rec.id || ' Name: ' || emp_rec.first_name || ' ' || emp_rec.last_name || ' Salary: ' || emp_rec.salary);

        v_count := v_count + 1;

    END LOOP;

    dbms_output.put_line('Total employees: ' || v_count);

END;

-- hàm main gọi procedure
set serveroutput on;

BEGIN
    print_emp_by_title('President');
END;

-- câu 2
create or replace procedure print_emp_by_title(p_title in varchar2, p_count out number)

IS
BEGIN
    p_count := 0;

    for emp_rec in(
        select id, first_name, last_name, salary
        from s_emp
        where title = p_title)

    loop
        dbms_output.put_line('ID: ' || emp_rec.id || ' Name: ' || emp_rec.first_name || ' ' || emp_rec.last_name || ' Salary: ' || emp_rec.salary);

        p_count := p_count + 1;
    END LOOP;

END;

-- gọi procedure
set serveroutput on;

DECLARE
    v_total number;

BEGIN
    print_emp_by_title('President', v_total);

    dbms_output.put_line
    ('Total employees printed: ' || v_total);

END;

-- câu 3
create or replace function count_emp_by_title(p_title varchar2)

return number

IS
    v_count number := 0;

BEGIN
    for emp_rec in(
        select id, first_name, last_name, salary
        from s_emp
        where title = p_title)

    loop
        dbms_output.put_line('ID: ' || emp_rec.id || ' Name: ' || emp_rec.first_name || ' ' || emp_rec.last_name || ' Salary: ' || emp_rec.salary);

        v_count := v_count + 1;
    END LOOP;

    return v_count;

END;
-- gọi
set serveroutput on;

DECLARE
    v_total number;

BEGIN
    v_total := count_emp_by_title('President');
    dbms_output.put_line('Total employees: ' || v_total);

END;

-- câu 4
create table accounts(
    account_id number primary key,
    account_name varchar2(50),
    amount_balance number
);

-- 4a
create or replace procedure withdraw_money(p_account_id number, p_amount number)

IS
    v_balance number;

BEGIN
    select amount_balance
    into v_balance
    from accounts
    where account_id = p_account_id;

    if v_balance >= p_amount then

        update accounts
        set amount_balance = amount_balance - p_amount
        where account_id = p_account_id;

        dbms_output.put_line('Withdrawal successful');

    else
        dbms_output.put_line('Insufficient funds');
    end if;

    commit;

EXCEPTION
    when others then
        dbms_output.put_line('Error');

END;

--4b
create or replace procedure deposit_money(p_account_id number, p_amount number)

IS
BEGIN
    update accounts
    set amount_balance = amount_balance + p_amount
    where account_id = p_account_id;

    dbms_output.put_line('Deposit successful');

    commit;

EXCEPTION
    when others then
        dbms_output.put_line('Error');

END;

-- 4c
create or replace procedure transfer_money(p_from_account number, p_to_account number, p_amount number)

IS
    v_balance number;

BEGIN
    select amount_balance
    into v_balance
    from accounts
    where account_id = p_from_account;

    if v_balance >= p_amount then

        update accounts
        set amount_balance = amount_balance - p_amount
        where account_id = p_from_account;

        update accounts
        set amount_balance = amount_balance + p_amount
        where account_id = p_to_account;

        dbms_output.put_line('Transfer successful');

    else
        dbms_output.put_line('Insufficient funds');
    end if;

    commit;

EXCEPTION
    when others then
        dbms_output.put_line('Error');

END;

-- C
-- câu 1
SET SERVEROUTPUT ON;


-- sửa thông tin trc
select salary from s_emp where id = 1;
update s_emp set salary = 2000 where id = 1;
-- trigger
CREATE OR REPLACE TRIGGER UPDATE_SALARY
BEFORE UPDATE ON s_emp
FOR EACH ROW
DECLARE
    v_new_salary s_emp.salary%type;
    v_old_salary s_emp.salary%type;
BEGIN
    v_new_salary := :NEW.salary;
    v_old_salary := :OLD.salary;
    
    IF (v_new_salary < v_old_salary) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: update fail');
    END IF;
END;

-- câu 2
-- data thử
insert into s_emp (id, last_name, first_name, userid, dept_id)
values (1001, 'a', 'b', 'us12', 41);
-- trigger
CREATE OR REPLACE TRIGGER Number_of_employee
BEFORE INSERT OR UPDATE ON s_emp
FOR EACH ROW
DECLARE
    v_number_of_employee NUMBER;
BEGIN
    select count(id) into v_number_of_employee
    from s_emp
    where dept_id = :NEW.dept_id
    group by dept_id;
    
    IF (v_number_of_employee >= 4) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Each department cannot have more than 4 employees');
    END IF;
END;