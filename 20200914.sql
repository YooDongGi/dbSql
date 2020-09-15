cstomer : 고객
cid : cstomer id : 고객 번호
cnm : cstomer name : 고객 이름
SELECT *
FROM customer;

product : 제품
pid : product id : 제품 번호
prm : product name : 제품 이름
SELECT * 
FROM product;

cycle : 고객애음주기
cid : 고객 id
pid : 제품 id
day : 1-7(일-토)
cnt : 수량
SELECT *
FROM cycle;

실습 join 4 ]
Oracle 문법
SELECT cr.cid, cr.cnm, ce.pid, ce.day, ce.cnt
FROM customer cr , cycle ce
WHERE cr.cid = ce.cid
    AND cr.cnm IN('brown', 'sally');
ANSI-sql 문법
SELECT cr.cid, cr.cnm, ce.pid, ce.day, ce.cnt
FROM customer cr JOIN cycle ce ON(cr.cid = ce.cid)
    WHERE cr.cnm IN('brown', 'sally');


실습 join 5 ]
customer, cycle, product 테이블 조인 -> 고객별 애음 제품, 애음 요일, 개수 제품명 -> (brown, sally)만 조회

--EXPLAIN PLAN FOR
SELECT cr.cid, cr.cnm, ce.pid, p.pnm, ce.day, ce.cnt
FROM customer cr , cycle ce, product p
WHERE cr.cid = ce.cid AND ce.pid = p.pid
    AND cr.cnm IN('brown', 'sally');

--SELECT * 
--FROM TABLE(dbms_xplan.display);

SQL : 실행에 대한 순서가 없다.
     조회할 테이블에 대해서 FROM절에 기술한 순서대로 테이블을 읽지 않는다.
    FROM customer, cycle, product == > 오라클에서는 product 테이블부터 읽을 수도 있다.

JOIN 구분
1. 문법에 따른 구분 : ANSI-SQL, ORACLE
2. join의 형태에 따른 구분 : SELF-JOIN, NONEQUT-JOIN, CROSS-JOIN
3. join 성공여부에 따라 데이터 표시여부
    => INNER JOIN - 조인이 성공했을 때 데이터를 표시
    => OUTER JOIN - 조인이 실패해도 기준으로 정한 테이블의 컬럼 정보는 표시 ( 자주 쓰이지는 않지만 중요 )

사번 , 사원의 이름, 관리자 사번, 관리자 이름

KING의 경우 mgr 컬럼의 값이 NULL이기 때문에 조인에 실패 ===> 13건 조회
SELECT e.empno, e.ename, e.mgr, m.ename -- oracle 문법
FROM emp e, emp m
WHERE e.mgr = m.empno;

SELECT e.empno, e.ename, e.mgr, m.ename     -- ANSI 문법
FROM emp e JOIN emp m ON (e.mgr = m.empno);

OUTER JOIN을 사용해서 조인이 실패해도 왼쪽에 있는 테이블의 정보가 표시되기 때문에 KING도 조회된다.
SELECT e.empno, e.ename, e.mgr, m.ename     -- ANSI 문법
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

SELECT e.empno, e.ename, e.mgr, m.ename     -- ANSI 문법
FROM emp m RIGHT OUTER JOIN emp e ON (e.mgr = m.empno);

ORACLE-SQL : 데이터가 없는 쪽의 컬럼에 (+) 기호를 붙인다
                ANSI-SQL 기준 테이블 반대편 테이블의 컬럼에 (+)을 붙인다.
                WHERE절 연결 조건에 적용
SELECT e.empno, e.ename, e.mgr, m.ename     --ORACLE-SQL 문법
FROM emp e, emp m 
WHERE e.mgr = m.empno(+);
        
행에 대한 제한 조건 기술시 WHERE절에 기술 했을 때와 ON 절에 기술 했을 때 결과가 다르다.

사원의 부서가 10번인 사람들만 조회되도록 부서 번호 조건을 추가
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno AND e.deptno = 10);

조건을 WHERE 절에 기술한 경우 == > OUTER JOIN이 아닌 INNER 조인 결과가 나온다.
SELECT e.empno, e.ename, e.deptno, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
WHERE e.deptno = 10;



SELECT  e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
UNION               -- 합집합
SELECT e.ename, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno)
MINUS               -- 차집합
SELECT e.ename, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

SELECT  e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
UNION
SELECT e.ename, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno)
INTERSECT           -- 교집합
SELECT e.ename, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);


실습 outerjoin1 ]
--oracle 문법
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b , prod p
WHERE b.buy_prod(+) = p.prod_id
    AND b.buy_date(+)= TO_DATE('20050125','YYYYMMDD');
--ansi 문법
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p ON (b.buy_prod = p.prod_id AND b.buy_date = TO_DATE('20050125','YYYYMMDD'));



-------------------------------------join 6~13 과제

실습 join6 ]
SELECT cr.cid, cr.cnm, ce.pid, p.pnm, SUM(ce.cnt)
FROM customer cr, cycle ce, product p
WHERE cr.cid = ce.cid AND ce.pid = p.pid
GROUP BY cr.cid, cr.cnm, ce.pid, p.pnm, ce.cnt;

실습 join7 ] 
SELECT p.pid, p.pnm, SUM(c.cnt)
FROM cycle c , product p
WHERE c.pid = p.pid
GROUP BY p.pid, p.pnm;

실습 join8 ]
SELECT r.region_id, r.region_name, c.country_name
FROM countries c JOIN regions r ON(r.region_id = c.region_id AND r.region_name = 'Europe');

실습 join9 ]
SELECT r.region_id, r.region_name, c.country_name, l.city
FROM countries c, regions r, locations l
WHERE r.region_id = c.region_id AND c.country_id = l.country_id
    AND r.region_name = 'Europe';
실습 join10 ]
SELECT r.region_id, r.region_name, c.country_name, l.city, d.department_name
FROM countries c, regions r, locations l, departments d
WHERE r.region_id = c.region_id AND c.country_id = l.country_id AND l.location_id = d.location_id
    AND r.region_name = 'Europe';
실습 join11 ]
SELECT r.region_id, r.region_name, c.country_name, l.city, d.department_name, CONCAT(e.first_name,e.last_name) name
FROM countries c, regions r, locations l, departments d, employees e
WHERE r.region_id = c.region_id AND c.country_id = l.country_id AND l.location_id = d.location_id
    AND d.department_id = e.department_id
    AND r.region_name = 'Europe';
실습 join12 ] 
SELECT e.employee_id, CONCAT(e.first_name,e.last_name) name, j.job_id, j.job_title
FROM employees e, jobs j
WHERE e.job_id = j.job_id;

실습 join13 ]
SELECT e.employee_id mgr_id, CONCAT(e.first_name, e.last_name) mgr_name, m.employee_id, CONCAT(m.first_name, m.last_name) name, j.job_id, j.job_title
FROM employees e, jobs j, employees m
WHERE m.job_id = j.job_id AND e.employee_id = m.manager_id;

          



