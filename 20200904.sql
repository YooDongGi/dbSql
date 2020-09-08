별칭 기술 : 텍스트, "텍스트" 
SELECT empno "번호"
FROM emp;

WHERE 절

비교연산 <, >, = , != , <> , <= , >=
        BETWEEN AND : 비교대상 BETWEEN 시작값 AND 종료값
        IN : 비교대상 IN(값1,값2,.,,,,.,.)
        LIKE : 비교대상 LIKE '매칭문자열 % '
        
NULL 비교
NULL값은 =, != 등의 비교연산으로 비교가 불가능
EX : emp 테이블에는 comm컬럼의 값이 NULL인 데이터가 존재
comm이 NULL인 데이터를 조회하기 위해 다음과 같이 실행할 경우 정상적으로 동작하지 않음
SELECT * FROM emp WHERE comm = NULL;
SELECT * FROM emp WHERE comm IS NULL;
SELECT * FROM emp WHERE comm IS NOT NULL; -- NULL이 아닌 데이터 조회

사원 중 소속 부서가 10번이 아닌 사원 조회
SELECT * FROM emp WHERE deptno NOT IN (10);

사원 중 자신의 상급자가 존재하지 않는 사원들만 조회(모든 컬럼)
SELECT * 
FROM emp 
WHERE mgr IS NULL;

논리 연산 : AND, OR, NOT
AND, OR : 조건을 결합
    AND :    조건1  AND  조건2 : 조건1과, 조건2를 동시에 만족하는 행만 조회가 되도록 제한
    OR  :    조건1  OR   조건2 : 조건1 혹은 조건2를 만족하는 행만 조회 되도록 제한

WHERE 절에 AND 조건을 사용 ==> 보통은 행이 줄어든다.
WHERE 절에 OR  조건을 사용 ==> 보통은 행이 늘어난다.

NOT : 부정연산
다른 연산자와 함께 사용되며 부정형 표현으로 사용됨
NOT IN(값1, 값2.....)
IS NOT NULL

mgr가 7648사번이고 급여가 1000보다 큰 사원들을 조회
SELECT *
FROM emp
WHERE mgr = 7698 AND sal > 1000;

emp 테이블의 사원 중 mgr이 7698이 아니면서 7839도 아닌 사원
방법1 
SELECT *
FROM emp
WHERE mgr != 7698 AND mgr != 7839;
방법2
SELECT * FROM emp WHERE mgr NOT IN(7698, 7839);

IN 연산자 사용시 NULL 데이터 유의점
요구사항 : mgr가 7698, 7839, NULL인 사원만 조회
SELECT * FROM emp WHERE mgr IN(7698,7839,NULL); 
==> mgr = 7698 OR mgr = 7839 OR mgr = NULL
SELECT * FROM emp WHERE mgr NOT IN(7698,7839,NULL); 
==> mgr = 7698 AND mgr = 7839 AND mgr != NULL 

실습 WHERE 7]
SELECT * FROM emp
WHERE job = 'SALESMAN'
AND hiredate >= TO_DATE('19810601','yyyymmdd');

실습 WHERE 8]
SELECT * FROM emp
WHERE deptno != 10 
    AND hiredate >= TO_DATE('19810601','yyyymmdd');

실습 WHERE 9]
SELECT * FROM emp
WHERE deptno NOT IN(10)
    AND hiredate >= TO_DATE('19810601','yyyymmdd');

실습 WHERE 10 ]
SELECT * FROM emp
WHERE deptno IN(20, 30)
    AND hiredate >= TO_DATE('19810601','yyyymmdd');
    

RDBMS는 집합에서 많은 부분을 차용
집합의 특징 : 1. 순서가 없다(다음날 동일한 sql을 실행해도 오늘과 같은 순서가 보장되지 않는다.)
            2. 중복을 허용하지 않는다.
{1,5,10} == {5,1, 10} (집합에 순서는 없다)

* 데이터는 보편적으로 데이터를 입력한 순서대로 나온다(보장할 순 없다.)
* table에는 순서가 없다.
    
ORDER BY 구문 (SELECT 결과 행의 순서를 조정할 수 있다.)

문법
SELECT * FROM 테이블명
[WHERE] [ORDER BY 컬럼1, 컬럼2]; ==> (컬럼1로 정렬 후 같은 부분은 컬럼2로 정렬)

SELECT * FROM emp ORDER BY job, empno;
    
오름차순 , ASC : 값이 작은 데이터부터 큰 데이터 순으로 나열
내림차순 , DESC : 값이 큰 데이터부터 작은 데이터 순으로 나열

ORALCE에서는 기본적으로 오름차순이 기본 값으로 적용됨.
내림차순으로 정렬을 원하면 정렬 기준 컬럼 뒤에 DESC를 붙인다.

job컬럼으로 오름차순 정렬 후, 같은 job을 갖는 행은 empno로 내림차순 정렬
SELECT *
FROM emp
ORDER BY job, empno DESC;

tip)
1. ORDER BY 절에 별칭 사용 가능
SELECT empno eno, ename enm
FROM emp
ORDER BY enm;

2. ORDER BY 절에 SELECT 절의 컬럼 순서번호를 기술 하여 정렬 가능
SELECT empno, ename FROM emp
ORDER BY 2; 
==> ORDER BY ename

3. expression도 가능
SELECT empno, ename, sal + 500
FROM emp
ORDER BY sal + 500;


실습 ORDER BY 1]
1)
SELECT * FROM dept
ORDER BY dname;
2)
SELECT * FROM dept
ORDER BY loc DESC;

실습 ORDER BY 2]
방법1)
SELECT * FROM emp
WHERE comm IS NOT NULL AND comm NOT IN(0)
ORDER BY comm DESC, empno DESC;
방법2)
SELECT * FROM emp
WHERE comm != 0
ORDER BY comm DESC, empno DESC;

실습 ORDER BY 3]
SELECT * FROM emp
WHERE mgr IS NOT NULL
ORDER BY job , empno DESC;

실습 ORDER BY 4]
SELECT * FROM emp
WHERE deptno IN(10,30) AND sal > 1500
ORDER BY ENAME DESC;

****실무에서 많이 사용****
ROWNUM : 행의 번호를 부여해주는 가상 컬럼
        **조회된 순서대로 번호를 부여

    ROWNUM은 1번부터 순차적으로 데이터를 읽어올 때만 사용 가능
1. WHERE 절에 사용하는 것이 가능
    * WHERE ROWNUM = 1 ( = 동등 비교 연산의 경우 1만 가능)
      WHERE ROWNUM <= 15
      WHERE ROWNUM BETWEEN 1 AND 15
        
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM = 1;

2. ORDER BY 절은 SELECT 이후에 실행된다.
    ** SELECT절에 ROWNUM을 사용하고 ORDER BY 절을 적용하게되면 원하는 결과를 얻지 못한다.
    ==> 정렬을 먼저 한 후 정렬된 결과에 ROWNUM을 적용
        INLINE-VIEW (SELECT 결과를 하나의 테이블처럼 만들어준다.)
        
사원 정보를 페이징 처리
1페이지 5명씩 조회
1페이지 : 1~5,     (page-1)*pageSize + 1 ~ page * pageSize
2페이지 : 6~10,    
3페이지 : 11~15

page = 1, pageSize = 5

SELECT *
FROM (SELECT ROWNUM rn, a.*
        FROM
         (SELECT empno, ename 
          FROM emp
          ORDER BY ename) a)
WHERE rn BETWEEN (:page - 1) * :pageSize + 1 AND :page * :pageSize;
          
SELECT 절에 *사용했는데 , 를 통해 다른 특수 컬럼이나 EXPRESSION을 사용할 경우는 
        *앞에 해당 데이터가 어떤 테이블에서 왔는지 명시를 해줘야 한다.(한정자)
SELECT ROWNUM, * 
FROM emp;

별칭은 테이블에도 적용 가능, 단 컬럼이랑 AS 옵션은 없다

SELECT ROWNUM, e.*
FROM emp e;

실습 WHERE 11]
SELECT * FROM emp
WHERE job = 'SALESMAN' OR hiredate >= TO_DATE('19810601','yyyymmdd');

실습 WHERE 12]
SELECT * FROM emp
WHERE job = 'SALESMAN' OR empno LIKE'78%';

실습 WHERE 13]
SELECT * FROM emp
WHERE job = 'SALESMAN' 
    OR (empno BETWEEN 78 AND 78
    OR empno BETWEEN 780 AND 789
    OR empno BETWEEN 7800 AND 7899);

실습 WHERE 14]
SELECT * FROM emp
WHERE job = 'SALESMAN' OR empno LIKE'78%'
    AND hiredate >= TO_DATE('19810601','yyyymmdd');

