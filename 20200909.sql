날짜 관련된 함수
TO_CHAR 날짜 ==> 문자
TO_DATE 문자 ==> 날짜

NULL 관련 함수
총 4가지 존재
1. NVL(expr1, expr2)
    ==> expr1이 NULL이면 expr2 출력, expr1이 NULL이 아니면 expr1 출력
    
2. NVL2(expr1, expr2, expr3)
    if(expr1 != null)
        System.out.println(expr2);
    else
        System.out.println(expr3);
    ==> expr1이 NULL이 아니면 expr2 출력, 그렇지 않으면 expr3 출력
    
3. NULLIF(expr1, expr2)
    if(expr1 == expr2)
        System.out.println(NULL);
    else
        System.out.println(expr1);
    ==> expr1과 expr2가 같으면 NULL 출력, 그렇지 않으면 expr1 출력
    
함수의 인자 개수가 정해지지않고 유동적으로 변경이 가능한 인자 : 가변인자
4. coalesce(expr1, expr2, expr3 .....)
    if(expr1 != NULL)
        System.out.println(expr1)
    else
        coalesce(expr2, expr3 .....)
    ==> coalesce의 인자중 가장 처음으로 등장하는 NULL이 아닌 인자를 반환
    
coalesce(null, null, 5, 4)
    => coalesce(null, 5, 4)
        => coalesce(5,4)
            => System.out.println(5);
    
comm 컬럼이 NULL일 때 0으로 변경하여 sal 컬럼과 합계를 구한다.
SELECT empno, ename, sal, comm,
    sal + NVL(comm, 0) nvl_sum,         -- nvl 사용
    sal + NVL2(comm, comm, 0) nvl2_sum,  -- nvl2 사용
    NVL2(comm, sal+comm, sal) nvl2_sum2,  -- nvl2 응용
    NULLIF(sal, 5000) nullif_sal,          -- nullif 사용
    sal + COALESCE(comm, 0) coalesce_sum,   -- coalesce 사용
    COALESCE(sal + comm, sal) coalesce_sum2  -- coalesce 응용
FROM emp;


실습 fn4]
SELECT empno, ename, mgr,
    NVL(mgr, 9999) mgr_n,
    NVL2(mgr, mgr, 9999) mgr_n_1,
    COALESCE(mgr, 9999) mgr_n_2
FROM emp;

실습 fn5]
SELECT userid, usernm, reg_dt,
    NVL(reg_dt, SYSDATE) n_reg_dt
FROM users
WHERE usernm != '브라운';


조건 : condition 
java 조건 체크 : if, switch 

SQL : CASE 절
CASE
    WHEN 조건 THEN 반환할 문장
    WHEN 조건2 THEN 반환할 문장
    ELSE 반환할 문장
END

emp 테이블에서 job 컬럼의 값이 
 'SALESMAN'이면 sal 값에 5%를 인상한 급여를 반환 ( sal * 1.05)
 'MANAGER'이면 sal 값에 10%를 인상한 급여를 반환 ( sal * 1.10)
 'PRESIDENT'이면 sal 값에 20%를 인상한 급여를 반환 ( sal * 1.20)
 그 밖의 직군 ('CLERK', 'ANALYST')은 sal 값 그대로 반환
 
SELECT ename, job, sal,
    CASE
        WHEN job = 'SALESMAN' THEN sal*1.05
        WHEN job = 'MANAGER' THEN sal * 1.10
        WHEN job = 'PRESIDENT' THEN sal * 1.20
        ELSE sal
    END sal_b
FROM emp;

가변인자 : 
DECODE(col | expr1,
                search1, return1,
                search2, return2,
                search3, return3,
                [default])
                
=> 첫번째 컬럼이 두번째 컬럼(search1)과 같으면 세번째 컬럼(return1)을 리턴
    첫번째 컬럼이 네번째 컬럼(search2)과 같으면 다섯번째 컬럼(return2)을 리턴
    첫번째 컬럼이 여섯번째 컬럼(search3)과 같으면 세번째 컬럼(return3)을 리턴
    일치하는 값이 없을 때는 default 리턴

SELECT ename, job, sal,
    CASE
        WHEN job = 'SALESMAN' THEN sal*1.05
        WHEN job = 'MANAGER' THEN sal * 1.10
        WHEN job = 'PRESIDENT' THEN sal * 1.20
        ELSE sal
    END sal_b,
    DECODE(job ,
                'SALESMAN',sal * 1.05,
                'MANAGER', sal * 1.10,
                'PRESIDENT', sal * 1.20,
                sal) sal_decode
FROM emp;

CASE, DECODE 둘다 조건 비교시 사용
차이점 : DECODE의 경우 값 비교가 =(EQUAL)에 대해서만 가능
            복수조건은 DECODE를 중첩하여 표현
        CASE는 부등호 사용가능, 여러개의 조건을 사용할 수 있다
 
 
실습 cond1]
SELECT empno, ename, 
    CASE
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
        WHEN deptno = 40 THEN 'OPERATIONS'
        ELSE 'DDIT'
    END CNAME,
    DECODE(deptno,
            10, 'ACCOUNTING', 20, 'RESEARCH',
            30, 'SALES', 40, 'OPERATIONS', 'DDIT') DNAME
FROM emp;

/*TO_CHAR(SYSDATE, 'YY')
mod(10,3) --나머지 구하는 함수
TO_CHAR(hiredate, 'YY')*/

실습 cond2] emp테이블을 이용해 올해 건강검진 대상자인지 조회하는 쿼리를 작성 (hiredate를 기준으로 한다)
SELECT empno, ename, hiredate, 
    CASE
        WHEN mod(TO_CHAR(hiredate, 'YY'),2) = mod(TO_CHAR(SYSDATE, 'YY'),2) THEN '건강검진 대상자'
        ELSE '건강검진 비대상자'
    END contact_to_doctor
FROM emp;

실습 cond3] 
SELECT userid, usernm, reg_dt,
    CASE
        WHEN mod(TO_CHAR(reg_dt, 'YY'),2) = mod(TO_CHAR(SYSDATE, 'YY'),2) THEN '건강검진 대상자'
        ELSE '건강검진 비대상자'
    END contacttodoctor,
    DECODE(mod(TO_CHAR(reg_dt, 'YY'),2), mod(TO_CHAR(SYSDATE, 'YY'),2), '건강검진 대상자', '건강검진 비대상자') contacttodoctor2
FROM users
WHERE reg_dt IS NOT NULL;






