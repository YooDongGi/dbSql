테이블의 구조(컬럼명, 데이터타입) 확인하는 방법
1. DESC 테이블명 : DESCRIBE
2. 컬럼 이름만 알 수 있는 방법(데이터 타입은 유추)
    SELECT * 
    FROM 테이블명;
3. 툴에서 제공하는 메뉴 이용
    접속 정보 - 테이블 - 확인 하고자하는 테이블 클릭
    
SELECT 절 : 컬럼을 제한
WHERE 절 : 조건에 만족하는 행들만 조회되도록 제한**********************
    ex) sal 컬럼의 값이 1500보다 큰 사람들만 조회 ==> 7명
WHERE 절에 기술된 조건을 참(TRUE)으로 만족하는 행들만 조회가 된다.
    
조건 연산자
    동등 비교(equal)
        java : int a = 5;
                primitive type : ==  ex) a==5,
                object : "+".equals("-")
        sql : sal = 1500
    not equal
        java : !=
        sql : !=, <>
        
대입연산자
    java :     =
    pl/sql :   :=

SELECT userid, usernm, alias, reg_dt
FROM users
WHERE userid = 'brown';

SQL은 대소문자를 가리지 않는다 : 키워드, 테이블명, 컬럼명
데이터는 대소문자를 가린다
컬럼과 문자열 상수를 구분하여 사용 

emp테이블에서 부서번호가(deptno)가 30보다 크거나 같은 사원들만 조회(모든 컬럼)
SELECT*
FROM emp
WHERE deptno >=30;


SELECT *
FROM emp
WHERE sal >= 1500;


문자 리터럴 표기법 : '문자열'
숫자 리터럴 표기법 : 숫자
날짜 리터럴 표기법 : yy/mm/dd (항상 정해진 표기법이 다르므로 서버 설정마다 다르다.)
날짜 리터럴 : 문자열 형태로 표현 가능하지만 서버 설정마다 다르게 해석할 수 있어서 서버 설정과 관계없이 동일하게 해석할 수 있는 방법으로 사용
            TO_DATE('날짜문자열','날짜문자열형식') : 문자열 ==> 날짜 타입으로 변경
날짜 비교
1982년 01월 01일 이후에 입사한 사람들만 조회(이름, 입사일자)
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01','yyyy/mm/dd');

BETWEEN AND 연산자
WHERE 비교대상 BETWEEN 시작값 AND 종료값;
비교대상의 값이 시작값과 종료값 사이에 있을 때 참(TRUE)으로 인식(시작값과 종료값 포함)

emp테이블에서 sal 컬럼의 값이 1000이상 2000이하인 사원들의 모든 컬럼을 조회
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

SELECT *
FROM emp
WHERE sal >= 1000 AND sal <= 2000;

실습 where1 ]
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982,01,01','yyyy,mm,dd')
            AND TO_DATE('1983,01,01','yyyy,mm,dd');
        
실습 where2 ]
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('19820101','yyyymmdd')
        AND hiredate <= TO_DATE('19830101','yyyymmdd');
        

IN 연산자
특정 값이 집합(다중값)에 포함되어 있는지 여부를 확인
(OR연산자로 대체하는 것이 가능)
WHERE 비교대상 IN (값1,값2,,,,,,,)
==> 비교대상이 값1이거나(=) 값2이거나(=)
WHERE 비교대상 = 값1 OR 비교대상 = 값2

emp 테이블에서 사원이 10번부서 혹인 30번부서에 속한 사원들 정보를 조회(모든 컬럼)
SELECT * 
FROM emp
WHERE deptno IN (10,30);

SELECT * 
FROM emp
WHERE deptno = 10 OR deptno = 30;
조건1 AND 조건2 ==> 조건1과 2를 동시 만족
조건1 OR 조건2 ==> 조건1을 만족하거나, 조건2를 만족하거나, 동시 만족하거나

IN 실습 where3]
1]
SELECT userid "아이디" , usernm "이름", alias "별명"
FROM users
WHERE userid IN('brown', 'cony', 'sally');
2]
SELECT userid 아이디 , usernm 이름, alias 별명
FROM users
WHERE userid = 'brown' OR userid = 'cony' OR userid = 'sally';

LIKE 연산자 : 문자열 매칭
userid가 b로 시작하는 캐릭터만 조회
% : 문자가 없거나, 여러개의 문자열
_ : 하나의 임의의 문자

SELECT * 
FROM emp
WHERE ename LIKE 'W___';    ename이 W로 시작하고 이어서 3개의 글자가 있는 사원

실습 where4]
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

실습 where5]
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';