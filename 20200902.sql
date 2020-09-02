| : or 
{} : 여러개가 반복
[] : 옵션- 있을 수도 있고, 없을 수도 있다.

=====SELECT 쿼리 문법============
SELECT * | {column | expression [alias]}
FROM 테이블 이름;


SELECT *
FROM emp;

SELECT empno, ename 
FROM emp;

SELECT *
FROM dept;

select *
from DEPT;

Coding rule
수업시간에는 keyword는 대문자
그 외 (테이블명, 컬럼명) 소문자

SELECT empnom, ename
FROM emp;



실습 select1]
SELECT *
FROM lprod;

SELECT buyer_id, buyer_name
FROM buyer;

SELECT *
FROM cart;

SELECT mem_id, mem_pass, mem_name
FROM member;


SELECT 쿼리는 테이블의 데이터에 영향을 주지 않는다.
SELECT 쿼리를 잘못 작성해도 데이터가 망가지지 않는다.

연산 
SELECT ename, sal, sal + 100
FROM emp;

데이터 타입
DESC 테이블명 (테이블 구조를 확인)
DESC emp;

숫자 + 숫자 = 숫자
문자 + 문자 = 문자 ==> java에서는 문자열을 이은, 문자열 결합으로 처리
날짜 + 숫자 = 날짜 ==> 날짜에다가 숫자를 일 수로 생각하여 더하고 밴 일자가 결과로 된다. (오라클에서 정의한 개념)


별칭 : 컬럼, expression에 새로운 이름을 부여
      컬럼 | expression [AS] [컬럼명]
AS ==> 별칭을 뜻함
SELECT ename AS emp_name, hiredate, hiredate+365 after_1year, hiredate-365 before_1year
FROM emp;

별칭을 부여할 때 주의점
1.공백, 특수문자가 있는 경우 더블 쿼테이션으로 감싸야함 " "
2.별칭명은 기본적으로 대문자로 취급되지만 소문자로 지정하고 싶으면 더블쿼테이션을 적용 " " 

자바에서 문자열 : "Hello"
SQL에서 문자열 : 'Hello'


=====중요=====
NULL : 아직 모르는 값
숫자 타입: 0이랑 NULL은 다르다
문자 타입: ' '공백문자와 NULL은 다르다

NULL을 포함한 연산의 결과는 항상 NULL *********


emp 테이블 컬럼 정리
1. empno : 사원번호
2. ename : 사원이름
3. job : (담당)업무
4. mgr : 매니저 사번번호
5. hiredate : 입사일자
6. sal : 급여
7. comm : 성과금 
8. deptno : 부서번호

emp 테이블에서 NULL값을 확인
SELECT ename, sal, comm, sal+comm AS total_sal
FROM emp;

SELECT userid, usernm, reg_dt , reg_dt + 5
FROM users;

SELECT 실습 2 

SELECT prod_id AS id, prod_name AS name
FROM prod;

SELECT lprod_gu AS gu, lprod_nm AS nm
FROM lprod;

SELECT buyer_id AS 바이어아이디, buyer_name AS 이름
FROM buyer;

literal : 값 자체
literal 표기법 : 값을 표현하는 방법

숫자 10이라는 값 표현 
java : int a = 10;
sql : SELECT empno, 10
      FROM emp;
문자 Hello, World 라는 값 표현
java : String str = "Hello, World";
sql : SELECT empno, 'Hello, world'
      FROM emp;


문자열 연산
java 
    "Hello," + "World" ==> "Hello, World"
sql
    ||, CONCAT ==> 결합 연산

emp 테이블의 ename, job 컬럼을 연산
SELECT ename ||' '|| job
FROM emp;

CONCAT(문자열 1, 문자열 2) : 문자열 1,2를 합쳐서 결과값을 반환해준다.
SELECT CONCAT(ename, job)
FROM emp;

SELECT CONCAT(ename, CONCAT(' ',job ))
FROM emp;


USER_TABLES : 오라클에서 관리하는 테이블(뷰)
              접속한 사용자가 보유하고 있는 테이블 정보를 관리


sel_con1 실습
방법1
SELECT 'SELECT * FROM ' || table_name || ';'
FROM user_tables;

방법2
SELECT CONCAT('SELECT * FROM ' ,CONCAT(table_name,';'))
FROM user_tables;