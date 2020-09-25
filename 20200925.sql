REPORT GROUP FUNCTION
GROUP BY 의 확장 : SUBGROUP을 자동으로 생성하여 하나의 결과로 합쳐준다.
1. ROLLUP (col1, col2...)
    - 기술된 컬럼을 오른쪽에서부터 지워나가며 서브그룹을 생성
2. GROUPING SETS ( (col1, col2) , col3) 
    -  , 단위로 기술된 서브그룹을 생성
3. CUBE(col1, col2...)
    - 컬럼의 순서는 지키며 가능한 모든 조합을 생성한다.


GROUP BY ROLLUP(job, deptno) ==> 3개
GROUP BY CUBE(job, deptno)  ==> 4개
job     deptno
 O        O     ==> GROUP BY job, deptno
 O        X     ==> GROUP BY job
 X        O     ==> GROUP BY deptno  (ROLLUP에는 없던 서브그룹)
 X        X     ==> GROUP BY 전체
 

SELECT job, deptno, SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY CUBE(job, deptno);

CUBE의 경우 가능한 모든 조합으로 서브그룹을 생성하기 때문에
2의 기술한 컬럼개수 승 만큼의 서브그룹이 생성된다.   (거의 사용하지 않는다.)
CUBE(col1, col2) : 4
CUBE(col1, col2, col3) : 8
CUBE(col1, col2, col3, col4) : 16


REPORT GROUP FUNCTION 조합
GROUP BY job, ROLLUP(deptno), CUBE(mgr)
                deptno          mgr
                  전체           전체
                  
           job    deptno, mgr    -> job, deptno,mgr
           job    deptno, 전체    -> job, deptno
           job    전체 mgr        -> job, mgr
           job    전체            -> job, 전체

SELECT job, deptno, mgr, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY job, ROLLUP(deptno), CUBE(mgr);

상호 연관 서브쿼리를 이용한 업데이트
1. EMP_TEST 테이블 삭제
2. EMP 테이블을 사용하여 EMP_TEST 테이블 생성(모든컬럼, 모든데이터)
3. EMP_TEST 테이블에는 DNAME 컬럼을 추가(VARCHAR2(14))
4. 상호 연관 서브쿼리를 이용하여 EMP_TEST 테이블의 DNAME 컬럼을 DEPT를 이용하여 UPDATE

DROP TABLE emp_test;
CREATE TABLE emp_test AS
SELECT * FROM emp;

ALTER TABLE emp_test ADD(dname VARCHAR2(14));

SELECT *
FROM emp_test;

UPDATE emp_test SET dname = (SELECT dname FROM dept WHERE deptno = emp_test.deptno)

COMMIT;


실습 sub_a1 ]
DROP TABLE dept_test;
1.dept테이블을 이용하여 dept_test 테이블 생성
CREATE TABLE dept_test AS
SELECT * FROM dept;
2. dept_test 테이블에 empcnt(NUMBER) 컬럼 추가
ALTER TABLE dept_test ADD(empcnt NUMBER);
3. 서브쿼리를 이용하여 dept_test 테이블의 empcnt컬럼에 해당 부서원 수를 update
-- 방법 1)
UPDATE dept_test SET empcnt = (SELECT COUNT(*) FROM emp 
                                GROUP BY deptno HAVING deptno = dept_test.deptno); 
-- 방법 2)                                
UPDATE dept_test SET empcnt = (SELECT COUNT(*) FROM emp
                                WHERE deptno = dept_test.deptno);

SELECT COUNT(*) FROM emp WHERE deptno = 10; 
SELECT COUNT(*) FROM emp GROUP BY deptno HAVING deptno = 10;

SELECT * FROM dept_test;
SELECT * FROM emp;

---------------------------------------------------------
COMMIT;

실습 sub_a2 ]
dept_test 테이블에 신규 데이터 2건 추가
INSERT INTO dept_test (deptno, dname, loc) VALUES (99,'it1','daejeon');
INSERT INTO dept_test (deptno, dname, loc) VALUES (98,'it2','daejeon');

emp 테이블의 직원들이 속하지 않은 부서 정보 삭제하는 쿼리를 작성하세요.
ALTER TABLE dept_test DROP COLUMN empcnt;
-- 방법 1
DELETE dept_test WHERE 0 = (SELECT COUNT(*) FROM emp WHERE deptno = dept_test.deptno);
-- 방법 2
DELETE dept_test WHERE NOT EXISTS (SELECT 'X' FROM emp WHERE deptno = dept_test.deptno);

SELECT * FROM dept_test;

실습 sub_a3 ] ------------------------------------------------과제 pt.47
DROP TABLE emp_test;
-- emp테이블을 이용하여 emp_test 테이블 생성
CREATE TABLE emp_test AS
SELECT * FROM emp;

-- emp_test 테이블에서 본인이 속한 부서의 평균 급여보다 급여가 작은 직원의 급여를 +200 UPDATE
UPDATE emp_test SET sal = sal + 200
WHERE sal < (SELECT AVG(sal)FROM emp WHERE deptno = emp_test.deptno);


SELECT * FROM emp_test;

--------------------------------------------------------------



------------------------------------달력만들기 pt------------------------------------------
달력만들기 : 행을 열로 만들기-레포트 쿼리에서 자주 사용하는 형태
주어진 것 : 년월 ( 수업시간에는 '202009' 문자열을 사용 )

SELECT MIN(DECODE(d, 1, day))sun,
       MIN(DECODE(d, 2, day)) mon,MIN(DECODE(d, 3, day)) tue,
       MIN(DECODE(d, 4, day))wed ,MIN(DECODE(d, 5, day)) thu,
       MIN(DECODE(d, 6, day))fri, MIN(DECODE(d, 7, day)) sat 
FROM
    (SELECT TO_DATE(:yyyymm,'yyyymm')+ LEVEL - 1 day,
        TO_CHAR(TO_DATE(:yyyymm,'yyyymm')+ LEVEL - 1 , 'D')d,
        TO_CHAR(TO_DATE(:yyyymm,'yyyymm')+ LEVEL - 1 , 'iw')iw
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm , 'yyyymm')),'dd'))
GROUP BY DECODE(d,1,iw+1,iw) ORDER BY DECODE(d,1,iw+1,iw);


실습 calendar1 ]
SELECT * FROM sales;

SELECT NVL(MIN(DECODE(a, 1, b)),0) JAN, NVL( MIN(DECODE(a, 2, b)),0)FEB,
       NVL( MIN(DECODE(a, 3, b)),0) MAR, NVL( MIN(DECODE(a, 4, b)),0)APR,
       NVL( MIN(DECODE(a, 5, b)),0) MAY, NVL( MIN(DECODE(a, 6, b)),0)JUN
FROM
    (SELECT TO_CHAR(dt, 'mm')a, SUM(sales)b
    FROM sales 
    GROUP BY TO_CHAR(dt, 'mm'))hh;

----------------------------------------------------------------------------------

SELECT deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;  



