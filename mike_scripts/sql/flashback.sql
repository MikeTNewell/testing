DECLARE
  CURSOR emp_cur IS
   SELECT * FROM   EMPLOYEE;
 v_rec emp_cur%rowtype;   
BEGIN
   -- DBMS_FLASHBACK.ENABLE_AT_SYSTEM_CHANGE_NUMBER (10280403339);
   DBMS_FLASHBACK.ENABLE_AT_TIME ('13-SEP-04 08:10:58');
   open emp_cur;
   DBMS_FLASHBACK.DISABLE;
   LOOP
   fetch emp_cur into v_rec; 
    EXIT WHEN emp_cur%NOTFOUND; 
  INSERT INTO EMPLOYEE_TEMP VALUES
   (v_rec.emp_id,
    v_rec.name, 
    v_rec.age ); 
 END LOOP; 
close emp_cur;
  COMMIT;
END;

FLASHBACK TABLE Employee TO 
           TIMESTAMP ('13-SEP-04 8:50:58','DD-MON-YY HH24: MI: SS');
           
FLASHBACK TABLE EMPLOYEE TO BEFORE DROP;

select OBJECT_NAME, ORIGINAL_NAME, TYPE from user_recyclebin;

