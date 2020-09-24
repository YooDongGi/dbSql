uncoditional insert : 여러 테이블에 insert
conditional all insert : 조건을 만족하는 모든 테이블에 insert
conditional first insert : 조건을 만족하는 첫번째 테이블에 insert

--첫번째 조건을 만족하면 두번째 조건을 만족해도 첫번재 테이블에만 insert
INSERT FIRST
    WHEN eno >= 9500 THEN
        INTO emp_test VALUES (eno , enm)
    WHEN eno >= 9000 THEN
        INTO emp_test2 VALUES (eno, enm)
SELECT 9000 eno, 'brwon' enm FROM dual UNION ALL
SELECT 9500 ,'sally' FROM dual;

SELECT * FROM emp_test;
SELECT * FROM emp_test2;

동일한 구조(컬럼)의 테이블을 여러개 생성했을 확률이 높다.
행을 잘라서 서로 다른 테이블에 분산 : 테이블의 건수가 줄어들어 table full access 속도가 빨라진다.

실적 테이블 : 20190101~20191231 실적데이터 ==> SALES_2019테이블에 저장 
            20200101~20201231 실적데이터 ==> SALES_2020테이블에 저장 
개별년도 계산은 상관없으나 19,20년도 데이터를 동시에 보기 위해서는 UNION ALL 혹은 쿼리를 두번 사용해야한다.

오라클 파티션 기능 (오라클 공식 버전에서만 지원, XE에서는 지원x)
테이블을 생성하고, 입력되는 값에 따라 오라클 내부적으로 별도의 영역에 저장


MERGE
특정 테이블에 입력하려고 하는 데이터가 없으면 입력하고, 있으면 업데이트를 한다.
--문법
MERGE INTO 변경/신규입력할 테이블 
    USING 테이블 | 뷰 | 인라인뷰
    ON ( INTO 절과 USING 절에 기술한 테이블의 연결 조건 )
WHEN MATCHED THEN 
    UPDATE SET 컬럼 = 값,[.....]
WHEN NOT MATCHED THEN
    INSERT [(컬럼1, 컬럼2....)] VALUES (값1,값2.....);

9000, 'brown' 데이터를 emp_test에 넣으려고 하는데 emp_test 테이블에 9000번 사번을 갖고 있는
사원이 있으면 이름을 업데이트하고 사원이 없으면 신규로 입력

merge 구문을 사용하지 않으면 적어도 2개의 sql을 실행해야함
1. SELECT 'X'
    FROM emp_test
    WHERE empno=9000;

2-1. 1번에서 조회된 데이터가 없을 경우
    INSERT INTO emp_test VALUES(9000,'brown');
2-2. 1번에서 조회된 데이터가 있을 경우
    UPDATE emp_test SET eame = 'brown' WHERE empno = 9000;

merge 구문을 사용하면 한번의 sql로 실행 가능
------방법 1
MERGE INTO emp_test
    USING (SELECT 9000 eno, 'brown' enm
            FROM dual)a
        ON( emp_test.empno = a.eno)
    WHEN MATCHED THEN
        UPDATE SET ename = a.enm
    WHEN NOT MATCHED THEN
        INSERT VALUES (a.eno, a.enm);
-----방법 2
MERGE INTO emp_test
    USING dual a
        ON( emp_test.empno = 9000)
    WHEN MATCHED THEN
        UPDATE SET ename = a.enm
    WHEN NOT MATCHED THEN
        INSERT VALUES (9000, 'brown');


SELECT *
FROM emp_test, (SELECT 9000 eno, 'brown' enm
    FROM dual) a
WHERE emp_test.empno = a.eno;

SELECT * FROM emp_test;



emp == > emp_test 데이터 2건 복사
INSERT INTO emp_test
SELECT empno, ename
FROM emp
WHERE empno IN(7369,7499);


emp 테이블을 이용하여 emp 테이블 존재하고 emp_test에는 없는 사원에 대해서는 emp_test에 신규로 입력

emp, emp_test 양쪽에 존재하는 사원은 이름을 이름 || '_M'이라고 업데이트

MERGE INTO emp_test
    USING emp
    ON ( emp.empno = emp_test.empno )
WHEN MATCHED THEN
    UPDATE SET ename = emp_test.ename || '_M'    
WHEN NOT MATCHED THEN
    INSERT VALUES (emp.empno, emp.ename);
    
    
SELECT * 
FROM emp_test, emp
WHERE emp.empno = emp_test.empno;


실습 GROUP_AD1 ]
SELECT deptno ,SUM(sal) FROM emp
GROUP BY deptno
UNION ALL
SELECT NULL, SUM(sal)
FROM emp;

위의 쿼리를 레포트 그룹 함수를 적용하면
SELECT deptno, SUM(sal)
FROM emp
GROUP BY ROLLUP(deptno);
==> GROUP BY deptno
    UNION ALL
    GROUP BY 전체 

ROLLUP : GROUP BY를 확장한 구문
        -> 서브 그룹을 자동적으로 생성
        GROUP BY ROLLUP(컬럼1,2,3,4,5...)
        **** ROLLUP 절에 기술한 컬럼을 오른쪽에서부터 하나씩 제거하며 
            서브그룹을 생성한다. 생성된 서브그룹을 하나의 결과로 합쳐준다.
ex) 
GROUP BY ROLLUP (deptno, job)
= > GROUP BY deptno, job
    UNION ALL
    GROUP BY deptno
    UNION ALL
    GROUP BY 전체

ex)
SELECT job, deptno, SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP(job, deptno);
= > GROUP BY job, deptno
    GROUP BY job
    GROUP BY 전체
    
--위의 쿼리를 풀어쓰면 ↓
SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp GROUP BY job, deptno 
UNION ALL
SELECT job, NULL, SUM(sal+ NVL(comm, 0)) sal
FROM emp GROUP BY job 
UNION ALL
SELECT NULL, NULL, SUM(sal + NVL(comm, 0)) sal
FROM emp;



GROUPING(col) 함수 : rollup, cube절을 사용한 sql에서만 사용이 가능한 함수
                    인자 col은 GROUP BY 절에 기술된 컬럼만 사용 가능
                    1, 0을 반환
                    1 : 해당 컬럼이 소계 계산에 사용된 경우
                    0 : 해당 컬럼이 소계 계산에 사용되지 않은 경우


SELECT job, deptno, GROUPING(job), GROUPING(deptno),
SUM(sal + NVL(comm, 0 )) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

실습 GROUP_AD2 ] pt.25
SELECT DECODE(GROUPING(job),1, '총계', job) job,
deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

위에서 null값이 아닌 GROUPING 함수를 통해 레이블을 달아준 이유
NULL 값이 실제 데이터의 NULL 인지 GROUP BY에 의해 NULL이 표현된 것 인지는 
GROUPING 함수를 통해서만 알 수 있다.


SELECT DECODE(GROUPING(job), 1, '총', job) job, 
DECODE(GROUPING(deptno), 1, '소계', deptno)deptno, 
SUM(sal + NVL(comm, 0 )) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

실습 GROUP_AD2-1 ]
--방법 1
SELECT DECODE(GROUPING(job), 1, '총', job) job, 
DECODE(GROUPING(job), 1, '계',DECODE(GROUPING(deptno), 1, '소계', deptno))deptno, 
SUM(sal + NVL(comm, 0 )) sal
FROM emp
GROUP BY ROLLUP(job, deptno);
--방법 2
SELECT DECODE(GROUPING(job), 1, '총', job) job, 
DECODE(GROUPING(job) + GROUPING(deptno) ,2 , '계'
                                        ,1 , '소계'
                                        ,TO_CHAR(deptno))deptno, 
SUM(sal + NVL(comm, 0 )) sal
FROM emp
GROUP BY ROLLUP(job, deptno);
--방법 3
SELECT
    CASE
        WHEN GROUPING(job) = 1 THEN '총'
        ELSE job
    END job,
    CASE
        WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '계'
        WHEN GROUPING(deptno) = 1 THEN '소계'
        ELSE TO_CHAR(deptno)
    END deptno,
SUM(sal + NVL(comm, 0 )) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

실습 GROUP_AD3 ] 
SELECT deptno, job, SUM(sal + NVL(comm, 0 )) sal
FROM emp
GROUP BY ROLLUP(deptno, job);

실습 GROUP_AD4 ]
SELECT d.dname, job, SUM(sal + NVL(comm, 0 )) sal
FROM emp e, dept d
WHERE e.deptno = d.deptno
GROUP BY ROLLUP(d.dname, job)
ORDER BY d.dname;

실습 GROUP_AD5 ]
SELECT DECODE(GROUPING(d.dname),1 ,'총합', d.dname) dname, job, SUM(sal + NVL(comm, 0 )) sal --, GROUPING(d.dname), GROUPING(job)
FROM emp e, dept d
WHERE e.deptno = d.deptno
GROUP BY ROLLUP(d.dname, job)
ORDER BY d.dname;

GROUPING SETS
ROLLUP의 단점 : 서브그룹을 기술된 오른쪽에서부터 삭제해가며 결과를 만들기때문에
                개발자가 중간에 필요없는 서브그룹을 제거할 수 없다.
                ROLLUP 절에 컬럼을 N개 기술하면 서브그룹은 N+1개가 나온다.
GROUPING SETS 는 개발자가 필요로 하는 서브그룹을 직접 나열하는 형태로 사용할 수 있다.

GROUP BY ROLLUP (col1, col2)
== > GROUP BY col1, col2
     GROUP BY col1
     GROUP BY 전체
     
GROUP BY GROUPING SETS (col1, col2)
== > GROUP BY col1
     GROUP BY col2
     
GROUP BY GROUPING SETS ((col1, col2), col1)

SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY GROUPING SETS (job, deptno);


GROUP BY GROUPING SETS (col1, col2)
GROUP BY GROUPING SETS (col2, col1)
==> 결과는 같다. 
ROLLUP절과 다르게 컬럼의 순서가 데이터 집합 셋에 영향을 주지 않는다 ( 행의 정렬 순서는 다를 수 있다)

GROUP BY GROUPING SETS ('' | NULL)
=>  GROUP BY 전체

