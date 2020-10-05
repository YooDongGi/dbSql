PL/SQL : Procedual LANGUAGE / SQL
SQL은 집합적인 언어인데 여기에 절차적 요소를 더함
절차적 요소 ( 반복문, 조건 제어-분기처리 )
    --> 절차적으로 잘 못짜면 속도 느리다 (sql로 한번에 처리할 수 없는지 고민)

절차적인 처리가 필요한 부분 ==> 인사 시스템 급여, 연말정산

PL/SQL 사용 방법 : PL/SQL block을 통해서 실행

PL/SQL block 구조 --> java의 try catch와 유사
DECLARE
    선언부(생략가능) 
        - PL/SQL 블럭에서 사용할 변수, TYPE(Class), CURSOR(SQL-정보)등을 선언하는 절
            java랑은 다르게 변수선언을 블록 어디서나 할 수 없다.
BEGIN
    실행부(생략불가)
        로직 - (데이터를 조회해서 변수에 담기, 루프, 조건제어)
EXCEPTION
    예외부(생략가능)
        BEGIN 절에서 발생한 예외를 처리하는 부분
END;
/   --> PL/SQL 종료를 나타내는 것.

pl/sql 식별자 규칙 : 오라클 객체(table, index...) 생성시와 동일
                30글자 넘어가면 안된다(FK시 길어지게 되는 경우가 간혹 있다.)
                오라클 객체명은 내부적으로 대문자로 관리
pl/sql 연산자 : SQL과 동일
                프로그래밍 언어의 특성(변수, 반복문, 조건문)
                대입 연산자 주의 (SQL에 존재하지 않음)
                JAVA = 
                PL/SQL :=
 
 
ex] 10번 부서의 부서번호, 부서이름을 각 변수에 담아서 console에 출력    
-- 부서번호 : v_deptno, 부서이름 : v_dname
변수 선언 : java와 순서가 다름
    java : 타입 변수명
    pl/sql : 변수명 타입
console 출력
    java : System.out.println(...);
    pl/sql : DBMS_OUTPUT.PUT_LINE(...);
    ORACLE 결과출력을 위해 출력 기능을 활성화 해야함
     - SET SERVEROUTPUT ON (매번 실행할 필요는 없고, 접속 후 한번만 실행하면 됨)
     
SET SERVEROUTPUT ON;
DECLARE
    v_deptno NUMBER(2);
    v_dname VARCHAR2(14);
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno || ', v_dname : '|| v_dname);
END;
/
                
참조타입 : 변수 타입을 테이블의 컬럼 정보를 통해 선언
       - 변수명 테이블명.컬럼명%TYPE;
            ==> 특정 테이블 컬럼의 타입을 참조하여 선언.
                해당 컬럼의 타입이 변경이 되더라도 PL/SQL 코드는 수정할 필요가 없다.
                
DECLARE
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno || ', v_dname : '|| v_dname);
END;
/


PL/SQL PROCEDURE : 오라클 DBMS에 저장한 PL/SQL 블럭
                    함수와 다르게 리턴값이 없다.
생성방법
CREATE OR REPLACE PROCEDURE 프로시져명 [(입력값....)] IS 
    선언부
BEGIN
END;
/
실행방법
EXEC 프로시져명;

CREATE OR REPLACE PROCEDURE printdept IS
    v_deptno dept.deptno%TYPE; 
    v_dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = 10;
    DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno || ', v_dname : ' || v_dname);
END;
/

EXEC printdept;


printdept 프로시저는 begin절에 10번 부서의 정보를 조회하도록 hard coding 되어있음
프로시져가 인자를 받도록 수정


CREATE OR REPLACE PROCEDURE printdept ( p_deptno IN dept.deptno%TYPE) IS
    v_deptno dept.deptno%TYPE; 
    v_dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = p_deptno;
    DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno || ', v_dname : ' || v_dname);
END;
/
EXEC printdept(10);
EXEC printdept(20);
EXEC printdept(30);

실습 PRO_1 ]
CREATE OR REPLACE PROCEDURE printemp ( p_empno IN emp.empno%TYPE) IS
    v_ename emp.ename%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    SELECT ename, dname INTO v_ename, v_dname
    FROM emp, dept
    WHERE emp.deptno = dept.deptno AND empno = p_empno;
    DBMS_OUTPUT.PUT_LINE('v_ename : ' || v_ename || ', v_dname : ' || v_dname);
END;
/
EXEC printemp(7369);
EXEC printemp(7839);


SELECT * FROM emp;
SELECT * FROM dept;

실습 PRO_2 ] 
CREATE OR REPLACE PROCEDURE registdept_test (p_deptno IN dept_test.deptno%TYPE,
                                             p_dname IN dept_test.dname%TYPE,
                                             p_loc IN dept_test.loc%TYPE) IS
BEGIN
    INSERT INTO dept_test (deptno, dname, loc) VALUES (p_deptno, p_dname, p_loc);
    COMMIT;
END;
/

EXEC registdept_test (99, 'ddit', 'daejeon');     

SELECT * FROM dept_test;
DELETE dept_test WHERE deptno = 99;

실습 PRO_3 ]
CREATE OR REPLACE PROCEDURE UPDATEdept_test (p_deptno IN dept_test.deptno%TYPE,
                                             p_dname IN dept_test.dname%TYPE,
                                             p_loc IN dept_test.loc%TYPE) IS
BEGIN
    UPDATE dept_test SET deptno = p_deptno, dname = p_dname, loc = p_loc WHERE deptno = p_deptno;
    COMMIT;
END;
/

EXEC UPDATEdept_test (99,'ddit_m','daejeon');

