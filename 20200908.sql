TO_CHAR(날짜타입, '변경할 문자열 포맷')
TO_DATE('날짜문자열', '첫번째 인자의 날짜 포맷')
TO_CHAR, TO_DATE 첫번째 인자 값을 넣을 때 문자열인지, 날짜인지 구분

SELECT SYSDATE, TO_CHAR(SYSDATE, 'DD-MM-YYYY')
FROM dual;

SELECT ename , hiredate, TO_CHAR(hiredate, 'YYYY/mm/dd hh24:mi:ss') h1, 
        TO_CHAR(hiredate + 1, 'YYYY/mm/dd hh24:mi:ss') h2,
        TO_CHAR(hiredate + 1/24, 'YYYY/mm/dd hh24:mi:ss') h3,
        TO_CHAR(TO_DATE('20200908','YYYYMMDD'), 'YYYY-MM-DD') h4
FROM emp;

실습 fn2]
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') dt_dash,
        TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24-MI-SS') dt_dash_with_time,
        TO_CHAR(SYSDATE, 'DD-MM-YYYY') dt_dd_mm_yyyy
FROM dual;

날짜 조작 함수
MONTHS_BETWEEN(date1, date2) : 두 날짜 사이의 개월 수를 반환    
        ==> 두 날짜의 일정보가 틀리면 소수점이 나오기 때문에 잘 사용하지는 않는다.
ADD_MONTHS(DATE, NUMBER) : 주어진 날짜에 개월 수를 더하거나 뺀 날짜를 반환 (음수를 사용시 과거 날짜)***
ex) ADD_MONTHS(SYSDATE, 5) : 오늘 날짜로부터 5개월 뒤의 날짜
NEXT_DAY(DATE, NUMBER(주간요일: 1-7)) : DATE이후에 등장하는 첫번째 주간요일을 갖는 날짜**
ex) NEXT_DAY(SYSDATE, 6) : SYSDATE(20/09/08)이 후에 등장하는 첫번째 금요일에 해당하는 날짜
LAST_DAY(DATE) : 주어진 날짜가 속한 월의 마지막 일자를 날짜로 반환*****
ex) LAST_DAY(SYSDATE) : SYSDATE(2020/09/08)가 속한 9월의 마지막 날짜 : 2020/09/30

SELECT MONTHS_BETWEEN(TO_DATE('20200915','YYYYMMDD'),TO_DATE('20200808','YYYYMMDD')),
        ADD_MONTHS(SYSDATE, 5),
        NEXT_DAY(SYSDATE, 6),
        LAST_DAY(SYSDATE),
        TO_DATE(CONCAT(TO_CHAR(SYSDATE, 'YYYYMM'),'01'),'YYYYMMDD'), -- 해당 월의 첫 날짜
        ADD_MONTHS(LAST_DAY(SYSDATE), -1)+1 ,                        -- 해당 월의 첫 날짜
        SYSDATE - TO_CHAR(SYSDATE, 'DD') +1                          -- 해당 월의 첫 날짜
FROM dual;

종합 실습 fn3]
SELECT :yyyymm PARAM,
        TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')),'DD') DT
FROM dual;


형변환
명시적 형변환
    TO_CHAR, TO_DATE, TO_NUMBER
묵시적 형변환
    ....ORACLE DBMS가 상황에 맞게 알아서 해주는 것
    
    두가지 방법
    1. empno(숫자)를 문자로 묵시적 형변환
    2. '7369'(문자)를 숫자로 묵시적 형변환
    
실행계획 : 오라클에서 요청받은 SQL을 처리하기 위한 절차를 수립한 것
실행계획 보는 방법
1. EXPLAIN PLAN FOR
    실행계획을 분석할 SQL;
2. SELECT *
    FROM TABLE(dbms_xplan.display);

실행계획의 operation을 해석하는 방법
1. 위에서 아래로
2. 단, 자식노드(들여쓰기가 된 노드)가 있을 경우 자식부터 실행 후 본인 노드를 실행

    
EXPLAIN PLAN FOR
SELECT*
FROM emp
WHERE empno = '7369';

EXPLAIN PLAN FOR
SELECT*
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM TABLE(dbms_xplan.display);


TABLE 함수 : PL / SQL의 테이블 타입 자료형을 테이블로 변환
SELECT * 
FROM TABLE(dbms_xplan.display);

숫자를 문자로 포맷 : DB보다는 국제화(il8n)에서 더 많이 활용
                        Internationalization

SELECT empno, ename, sal, TO_CHAR(sal, '009,999L')
FROM emp;

NULL과 관련된 함수
1. NVL( 컬럼 || 익스프레션 , 컬럼 || 익스프레션)
   NVL(expr1, expr2)
    ==> 의미하는 것 
        if(expr1 == null)
            System.out.println(expr2);
        else
            System.out.println(expr1);

SELECT empno, comm, NVL(comm, 0)    -- comm이 NULL이면 0을 출력
FROM emp;