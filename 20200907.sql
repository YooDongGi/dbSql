ROWNUM : 1부터 읽어야 된다.
        SELECT 절이 ORDER BY 절보다 먼저 실행된다.
         ==> ROWNUM을 이용하여 순서를 부여 하려면 정렬부터 해야한다.
            ==> 인라인뷰 ( ORDER BY - ROWNUM을 분리 )
            
실습 row_1]
SELECT ROWNUM "Rn", empno, ename
FROM emp
WHERE ROWNUM <= 10;

실습 row_2] 
SELECT *
FROM (SELECT ROWNUM RN, empno, ename
        FROM emp)
WHERE RN BETWEEN 11 AND 14;

실습 row_3]
SELECT *
FROM (SELECT ROWNUM RN, a.*
        FROM
        (SELECT empno, ename
         FROM emp
         ORDER BY ename)a)
WHERE RN BETWEEN 11 AND 14;


SELECT *
FROM dual;


ORALCE 함수 분류
1. SINGLE ROW FUNCTION : 단일 행을 작업의 기준, 결과도 한건 반환 *** 
2. MULTI ROW FUNCTION : 여러 행을 작업의 기준, 하나의 행을 결과로 반환

dual 테이블
    1. sys 계정에 존재하는 누구나 사용할 수 있는 테이블
    2. 테이블에는 하나의 컬럼, dummy 존재, 값은 X 
    3. 하나의 행만 존재
    
SELECT empno, ename, LENGTH(ename)
FROM emp;

SELECT LENGTH('Hello')
FROM dual;

SELECT ename, LOWER(ename)
FROM emp;

SELECT ename, LOWER(ename)
FROM emp
WHERE ename = UPPER('smith');

sql 칠거지악
1. 좌변을 가공하지 말아라 ( 테이블 컬럼에 함수를 사용하지 말것)
  - 함수 실행 횟수
  - 인덱스 사용관련(추후에)
  
문자열 관련함수

SELECT CONCAT('Hello', ',World') concat,
        SUBSTR('Hello, World',1, 3) substr, -- 1~3까지
        SUBSTR('Hello, World', 3) substr2,  -- 3~마지막까지
        LENGTH('Hello, World') length,      -- 문자열의 길이
        INSTR('Hello, World', 'o') instr,   -- 첫번째로 등장하는 문자 위치
        INSTR('Hello, World', 'o', INSTR('Hello, World', 'o') + 1) instr2,  -- 두번째로 등장하는 문자 위치
        LPAD('Hello, World', 15, '*') lpad,
        RPAD('Hello, World', 14, '*') rpad,
        REPLACE('Hello, World', 'Hello', 'Hell') replace,
        TRIM('     Hello, World     ') trim,
        TRIM('H' FROM 'Hello, World') trim2
FROM dual;   

숫자 관련 함수
ROUND : 반올림 함수
TRUNC : 버림함수
    ==> 몇번째 자리에서 반올림, 버림을 할지?
        ROUND(숫자, 반올림 결과 자리수)
MOD : 나머지를 구하는 함수
피제수 - 나눔을 당하는 수, 제수 - 나누는 수
a / b = c 
a : 피제수
b : 제수

SELECT ROUND(105.54, 1) round,    --소수점 둘째자리에서 반올림
        ROUND(105.55, 1) round2,
        ROUND(105.55, 0) round3,    --소수점 첫째자리에서 반올림
        ROUND(105.55, -1) round4   --정수 첫째자리에서 반올림
FROM dual;

SELECT TRUNC(105.54, 1) trunc,    --소수점 둘째자리에서 내림
        TRUNC(105.55, 1) trunc2,
        TRUNC(105.55, 0) trunc3,   --소수점 첫째자리에서 내림
        TRUNC(105.55, -1) trunc4   --정수 첫째자리에서 내림
FROM dual;

10을 3으로 나눴을 때의 나머지 구하기
SELECT mod(10,3)
FROM dual;

10을 3으로 나눴을 때의 몫을 구하기
SELECT TRUNC(10/3 , 0)
FROM dual;


날짜 관련함수
문자열 ==> 날짜 타입 TO_DATE
SYSDATE : 오라클 서버의 현재 날짜, 시간을 돌려주는 특수함수
            함수의 인자가 없다
            
SELECT SYSDATE
FROM dual;

날짜 연산 
날짜 타입 +/- 정수(일자) : 날짜에서 정수만큼 더한(뺀) 날짜
emp hiredate +5, -5
하루 = 24     1일 = 24h        1/24일 = 1h      1/24/60 = 1mm      1/24/60/60 = 1s

SELECT SYSDATE, SYSDATE+5, SYSDATE-5,
        SYSDATE + 1/24, SYSDATE + 1/24/60
FROM dual;

실습 fn]
SELECT TO_DATE('2019/12/31','YYYY/MM/DD') LASTDAY,      
    TO_DATE('2019/12/31','YYYY/MM/DD')-5 LASTDAY_BEFORE5,   
    SYSDATE NOW,
    SYSDATE - 3 NOW_BEFORE3
FROM dual;


