1.
SELECT ename , hiredate
FROM emp
WHERE hiredate >= TO_DATE('19820101','YYYYMMDD')
    AND hiredate <= TO_DATE('19830101','YYYYMMDD');
    
2.
SELECT * FROM emp
WHERE job = 'SALESMAN' AND hiredate >= TO_DATE('19810601','YYYYMMDD');

3.
SELECT * FROM emp
WHERE deptno NOT IN(10) AND hiredate >= TO_DATE('19810601','YYYYMMDD');

4.
SELECT ROWNUM, a.*
FROM (SELECT empno, ename FROM emp ORDER BY empno)a;

5.
SELECT * FROM emp
WHERE deptno IN(10,30) AND sal > 1500
ORDER BY ename DESC;

6.
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal
FROM emp
GROUP BY deptno;

7.
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
    AND sal > 2500 AND empno > 7600 AND dname = 'RESEARCH';
    
8.
SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
    AND emp.deptno IN(10,30);
    
9.
SELECT e.ename, NVL(m.ename,'NULL') mgr     --NVL 사용하지 않아도 (null)로 출력
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

10.
SELECT TO_CHAR(hiredate , 'YYYYMM')hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate , 'YYYYMM');

11.
SELECT * FROM emp
WHERE deptno IN(SELECT deptno FROM emp WHERE ename IN('SMITH','WARD'));

12.
SELECT * FROM emp
WHERE sal > (SELECT AVG(sal) FROM emp);

13.
INSERT INTO dept VALUES (99, 'ddit','대전');

14.
UPDATE dept SET dname = 'ddit_modi', loc = '대전_modi' WHERE deptno = 99;

15.
DELETE dept WHERE deptno = 99;

16.
-- emp 생성
CREATE TABLE emp (
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    job VARCHAR2(9),
    mgr NUMBER(4),
    hiredate DATE,
    sal NUMBER(7,2),
    comm NUMBER(7,2),
    deptno NUMBER(2)) ;
--dept 생성
CREATE TABLE dept (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13));
-- emp 테이블의 deptno가 dept테이블의 deptno를 참조하는 FOREIGN KEY 생성
ALTER TABLE emp ADD CONSTRAINT FK_emp_dept FOREIGN KEY (deptno) REFERENCES dept (deptno);

17.
SELECT deptno,SUM(sal) sal
FROM emp
GROUP BY ROLLUP (deptno, sal)
HAVING GROUPING(sal) = 1;

18.
SELECT ename, sal, deptno, hiredate,
        RANK()OVER (PARTITION BY deptno ORDER BY sal DESC,hiredate) dept_sal_rank  
FROM emp;

19.
SELECT empno, ename, hiredate, sal,
    LEAD(sal) OVER(ORDER BY sal DESC, hiredate) lead_sal
FROM emp;

20.
SELECT empno, ename, deptno, sal,
    SUM(sal) OVER (ORDER BY sal) c_sum
FROM emp;
