변수선언
java : 변수타입 변수이름;
pl/sql : 변수이름 변수타입;

복합변수
1. %ROWTYPE 행 정보(컬럼이 복수)를 담을 수 있는 변수(rowtype)
    ==> java로 비유를 하면 vo(filed가 여러개)
    컬럼 타입 : 테이블명.컬럼명%TYPE
    ROW 타입 : 테이블명%ROWTYPE
2. 행 정보, 개발자가 컬럼을 선택하여 타입 생성
3. table type : 행이 여러개인 값을 저장할 수 있는 변수

%ROWTYPE : 테이블의 행 정보를 담을 수 있는 변수

SET SERVEROUTPUT ON;

emp테이블에서 7369번 사번의 모든 컬럼 정보를 ROWTYPE 변수에 저장
DBMS_OUTPUT.PUT_LINE 함수를 통해 콘솔에 출력

DECLARE
    v_emp_row emp%ROWTYPE; /*v_emp_row.empno, v_emp_row.ename */
BEGIN
    SELECT * INTO v_emp_row
    FROM emp
    WHERE empno = 7369;
    
    DBMS_OUTPUT.PUT_LINE( 'v_emp_row.empno : ' || v_emp_row.empno || ', v_emp_row.ename : ' || v_emp_row.ename);
END;
/

RECORD TYPE : 행의 컬럼 정보를 개발자가 직접 구성한 (커스텀) 타입
    => 지금까지는 타입을 가져다 사용한 것, 지금은 타입을 생성(CLASS를 생성)
방법 
TYPE 타입이름 IS RECORD (
    컬럼명 1 컬럼타입1,
    컬럼명 2 컬럼타입2,
    컬럼명 3 컬럼타입3,
);
변수명 타입이름;

사원테이블에서 empno, ename, deptno 3개의 컬럼을 저장할 수 있는 ROWTYPE 타입을 정의하고
해당 타입의 변수를 선언하여 사번으 7369번인 사원의 위 3가지 컬럼 정보를 담아본다.
DECLARE 
    TYPE t_emp_row IS RECORD(
        empno emp.empno%TYPE,
        ename emp.ename%TYPE,
        deptno emp.deptno%TYPE
    );
    v_emp_row t_emp_row;
BEGIN
    SELECT empno, ename, deptno INTO v_emp_row
    FROM emp
    WHERE empno = 7369;
    DBMS_OUTPUT.PUT_LINE('v_emp_row.empno : ' || v_emp_row.empno || ', v_emp_row.ename : ' || v_emp_row.ename);
END;
/

TABLE 타입 : 여러개의 행을 담을 수 있는 타입
    자바로 비유를 하면 List<Vo>

자바 배열과 pl/sql table 타입의 차이점
java
    int[] intArr = new int[10];
    배열의 첫번째 값을 접근 : intArr[0] -- index 번호 ==> 숫자로 고정
pl/sql
    intArr["userName"] --> 숫자가 아닌 다른 문자로도 가능

테이블 타입선언
TYPE 테이블_타입이름 IS TABLE OF 행에_대한타입 INDEX BY BINARY_INTEGER;
테이블_타입_변수명 테이블_타입이름;

기존 : SELECT 쿼리의 결과가 한 행이어야만 정상적으로 통과
변경 : SELECT 쿼리의 결과가 복수 행이어도 상관없다.


dept테이블의 모든행을 조회해서 테이블 타입변수에 담고 테이블 타입변수를 루프(반복문)를 통해 값을 확인

DECLARE
    TYPE t_dept IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dept t_dept;
BEGIN
    -- pl/sql 테이블 타입 : v_dept(0).컬럼명
    
    SELECT * BULK COLLECT INTO v_dept
    FROM dept;
    -- pl/sql 반복문
    FOR i IN 1..v_dept.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('v_dept(i).deptno : ' || v_dept(i).deptno
                            ||', v_dept(i).dname : ' || v_dept(i).dname);
    END LOOP;
END;
/

조건제어
    IF
    CASE - 2가지
반복문
    FOR LOOP        --일반적으로 가장 많이 사용
    LOOP
    WHILE


IF 문법

IF 조건문 THEN
    실행문장;
ELSIF 조건문 THEN
    실행문장;
ELSE
    실행문장;
END IF;

ex]
DECLARE
    p NUMBER := 5;  --임의의 변수 p에 5를 넣는다.
BEGIN
    IF p = 1 THEN
        DBMS_OUTPUT.PUT_LINE('p=1');
    ELSIF p = 2 THEN
        DBMS_OUTPUT.PUT_LINE('p=2');
    ELSIF p = 5 THEN
        DBMS_OUTPUT.PUT_LINE('p=5');
    ELSE
        DBMS_OUTPUT.PUT_LINE('DEFAULT');
    END IF;
END;
/

일반 CASE (java의 switch와 유사) 
CASE expression(컬럼이나, 변수, 수식)
    WHEN value THEN
        실행할문장;
    WHEN value2 THEN
        실행할문장2;
    ELSE
        기본실행문장;
END CASE;

DECLARE
    p NUMBER := 5;  --임의의 변수 p에 5를 넣는다.
BEGIN
    CASE p
        WHEN 1 THEN
            DBMS_OUTPUT.PUT_LINE('p=1');
        WHEN 2 THEN
            DBMS_OUTPUT.PUT_LINE('p=2');
        WHEN 5 THEN
            DBMS_OUTPUT.PUT_LINE('p=5');
        ELSE
            DBMS_OUTPUT.PUT_LINE('DEFAULT');
    END CASE;
END;
/

검색 CASE (java의 if와 유사) 
CASE 
    WHEN expression(수식) THEN
        실행할문장;
    WHEN expression(수식) THEN
        실행할문장2;
    ELSE
        기본실행문장;
END CASE;

DECLARE
    p NUMBER := 5;  --임의의 변수 p에 5를 넣는다.
BEGIN
    CASE 
        WHEN p = 1 THEN
            DBMS_OUTPUT.PUT_LINE('p=1');
        WHEN p = 2 THEN
            DBMS_OUTPUT.PUT_LINE('p=2');
        WHEN p = 5 THEN
            DBMS_OUTPUT.PUT_LINE('p=5');
        ELSE
            DBMS_OUTPUT.PUT_LINE('DEFAULT');
    END CASE;
END;
/

case 표현식 : SQL에서 사용한 CASE

변수 :=  CASE
            WHEN 조건문1 THEN 반환할 값1
            WHEN 조건문2 THEN 반환할 값2
            ELSE 기본 반환값
        END; 
    
ex)
emp테이블에서 7369번 사원의 sal 정보를 조회하여
sal 값이 1000보다 크면 sal*1.2 값을 sal 값이 900보다 크면 sal*1.3 값을
sal 값이 800보다 크면 sal*1.4 값을 위 세가지 조건을 만족하지 못할 때는 sal*1.6값을 
v_sal 변수에 담아 emp 테이블의 sal 컬럼에 업데이트(단, case표현식을 사용)

1. 7369번 사번의 sal 정보를 조회하여 변수에 담는다.
2. 1번에서 담은 변수값을 case 표현식을 이용하여 새로운 sal 값을 구하고 v_sal 변수에 할당
3. 7369번 사원의 sal 컬럼을 v_sal 값으로 업데이트
-------------------------------------------------------과제
DECLARE
    v_sal NUMBER := 0;
    e_sal NUMBER;
BEGIN
    SELECT sal INTO e_sal
    FROM emp WHERE empno = 7369;
    
    v_sal := CASE
                WHEN e_sal > 1000 THEN e_sal*1.2
                WHEN e_sal > 900 THEN e_sal*1.3
                WHEN e_sal > 800 THEN e_sal*1.4
                ELSE e_sal*1.6
            END;     
     UPDATE emp SET sal = v_sal WHERE empno = 7369;
     COMMIT;
END;
/

SELECT sal FROM emp WHERE empno=7369;



