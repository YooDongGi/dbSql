CONNECT BY LEVEL 계층 쿼리 : CROSS JOIN과 유사 -> 연결가능한 모든 행에 연결.

START WITH : 계층쿼리의 시작점(행), 여러개의 행을 조회하는 조건이 들어갈 수도 있다.
             START WITH절에 의해 선택된 행이 여러개이면, 순차적으로 진행한다.
             
CONNECT BY : 행과 행을 연결할 조건을 기술
PRIOR : 현재 읽은 행을 지칭
** PRIOR  키워드는 CONNECT BY 바로 다음에 나오지 않아도 된다.

** 연결조건이 두개 이상일 때
CONNECT BY PRIOR p = q AND PRIOR a = b;

실습 h_1 ]
SELECT deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd; 

SELECT * FROM dept_h;
실습 h_2 ]
SELECT LEVEL lv, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;


계층쿼리 - 상향식
디자인팀 (dept0_00_0)부터 시작하여 자신의 상위 부서로 연결하는 쿼리

상향식 실습 h_3 ] 
SELECT deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;

SELECT * FROM h_sum;

실습 h_4 ]
SELECT LPAD(' ' , (LEVEL-1)*3) || s_id s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;


pruning branch : 가지치기

SQL 구문 실행순서
FROM -> WHERE -> GROUP BY -> SELECT -> ORDER BY
SELECT 쿼리에 START WITH, CONNECT BY 절이 있을 경우
FROM -> START WITH, CONNECT BY -> WHERE ......

---------------------------------------------------------------------- 비교
SELECT deptcd, LPAD( ' ', (LEVEL-1) * 3 ) || deptnm deptnm , p_deptcd
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND deptcd != 'dept0_01';
현재 읽은 행의 deptcd 값이 앞으로 읽을 행의 p_deptcd 컬럼과 같고 
앞으로 읽을 행의 dept_cd 컬럼 값이 'dept0_01'이 아닐 때 연결한다.

==> XX회사 밑에는 디자인부, 정보기획부, 정보시스템부 3개의 부가 있는데
    그 중 정보기획부를 제외한 2개 부서에 대해서만 연결하겠다.

행 제한 조건을 WHERE 절에 기술 했을 경우
FROM -> START WITH -> WHERE 절 순으로 실행되기 때문에
1. 계층 탐색을 전부 완료한 후
2. WHERE 절에 해당하는 행만 데이터를 제외한다.
SELECT deptcd, LPAD( ' ', (LEVEL-1) * 3 ) || deptnm deptnm , p_deptcd
FROM dept_h
WHERE deptcd != 'dept0_01'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd ;
-----------------------------------------------------------------------------------

계층쿼리 특수함수
1. CONNECT_BY_ROOT(col) : 최상위 행의 컬럼 값 조회
2. SYS_CONNECT_BY_PATH(col, 구분자) : 계층 순회 경로를 표현***
3. CONNECT_BY_ISLEAF : 해당 행이 leaf node(자식이 없는 노드)인지 여부를 반환
                        (1 : leaf node, 0 : no leaf node)

SELECT deptcd, LPAD(' ' , (LEVEL-1)*3) || deptnm deptnm,
        CONNECT_BY_ROOT(deptnm) cbr,
        LTRIM(SYS_CONNECT_BY_PATH(deptnm, '-'),'-') scbp,
        CONNECT_BY_ISLEAF cbi
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;


실습 h6 ]
SELECT * FROM BOARD_TEST;

SELECT seq, LPAD(' ', (LEVEL-1)*3) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq;

실습 h7-8 ] 
SELECT seq, LPAD(' ', (LEVEL-1)*3) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC;

ORDER SIBLINGS BY : 계층 구조를 유지한 상태에서 정렬할 수 있다.

실습 h9 ]
--방법 1)
gn(NUMBER) 컬럼을 테이블에 추가
ALTER TABLE board_test ADD(gn NUMBER);

UPDATE board_test SET gn = 1 WHERE seq IN(1,9);
UPDATE board_test SET gn = 2 WHERE seq IN(2,3);
UPDATE board_test SET gn = 4 WHERE seq NOT IN (1,2,3,9);
COMMIT;

SELECT seq, LPAD(' ', (LEVEL-1)*3) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq ASC;

--방법 2)
CONNECT_BY_ROOT를 활용한 그룹번호 생성
SELECT * 
FROM
    (SELECT seq, LPAD(' ', (LEVEL-1)*3) || title title, CONNECT_BY_ROOT(seq) gn
    FROM board_test
    START WITH parent_seq IS NULL
    CONNECT BY PRIOR seq = parent_seq )
ORDER BY gn DESC,seq ASC ;



사원 중 가장 많은 급여를 받는 사람의 정보 조회(empno, ename, sal)
SELECT empno, ename, sal
FROM emp
WHERE sal = (SELECT MAX(sal)FROM emp);

SQL의 단점 : 행간 연산이 부족 ==> 해당 부분을 보완 해주는 것이 분석함수 (윈도우 함수)

실습 ana0 ] 부서별 급여 랭크
SELECT ename, sal, deptno,
        RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank    --부서번호가 같은 직원을 하나의 파티션으로 구분
FROM emp;
분석함수를 사용하지 않고 위와 동일한 결과를 만들어 내는 것이 가능
(*** 분석함수가 모든 DBMS에서 제공을 하지는 않음)
----------------------------------------------------------
SELECT *
FROM 
(SELECT ename, sal, deptno, ROWNUM rn
    FROM
    (SELECT ename, sal, deptno
     FROM emp
     ORDER BY deptno, sal DESC) ) a,
(SELECT deptno, lv, ROWNUM rn
FROM 
    (SELECT a.deptno, b.lv
    FROM 
    (SELECT deptno, COUNT(*) cnt
     FROM emp
     GROUP BY deptno) a, 
    (SELECT LEVEL lv
     FROM dual
     CONNECT BY LEVEL <= (SELECT COUNT(*) FROM emp) ) b
    WHERE a.cnt >= b.lv
    ORDER BY a.deptno, b.lv )) b
WHERE a.rn = b.rn;
-----------------------------------------------------------

분석함수 / 윈도우 함수 문법
SELECT 윈도함수이름( [인자] ) OVER 
        ( [PARTITION BY columns] [ORDER BY columns] [WINDOWING] )
        
PARTITION BY : 영역설정
ORDER BY : 영역내에서 순서 설정 ( RANK, ROW_NUMBER )
WINDOWING : 파티션 내에서 범위설정

--사원의 부서별 급여 순위 
SELECT ename, sal, deptno,
        RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank,
        DENSE_RANK () OVER (PARTITION BY deptno ORDER BY sal DESC) sal_dense_rank,
        ROW_NUMBER () OVER (PARTITION BY deptno ORDER BY sal DESC) sal_row_number
FROM emp;
PARTITION BY deptno : 같은 부서 코드를 갖는 row를 그룹으로 묶는다
ORDER BY sal : 그룹내에서 sal로 row의 순서를 정한다
RANK() : 파티션 단위 안에서 정렬 순서대로 순위를 부여한다

순서관련 분석함수 - 동일 값에 대한 순위처리에 따라 3가지 함수를 제공
RANK : 동일값에 대해 동일 순위 부여 
        후순위 : 1등이 2명이면 그 다음 순위가 3위 ( 1 1 3 )
DENSE_RANK : 동일 값에 대해서는 동일 순위를 부여
        후순위 : 1등이 2명이면 그 다음 순위가 2위 ( 1 1 2 )
ROW_NUMBER : 동일 값이라도 별도의 순위를 부여 ( 1 2 3 )


실습 ana1 ]
SELECT empno, ename, sal , deptno,
        RANK() OVER (ORDER BY sal DESC , empno) sal_rank,
        DENSE_RANK() OVER (ORDER BY sal DESC, empno) dense_rank,
        ROW_NUMBER() OVER (ORDER BY sal DESC, empno) row_number
FROM emp;


집계관련 분석함수 
SUM(col), MIN(col), MAX(col), COUNT(col|*), AVG(col)

사원번호, 사원이름, 소속부서번호, 소속된 부서의 사원 수
SELECT empno, ename, deptno, 
        COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

실습 ana2 ]
SELECT empno, ename, sal, deptno,
    ROUND(AVG(sal) OVER (PARTITION BY deptno),2) avg_sal
FROM emp;

분석함수를 사용하지 않고 구하기
SELECT empno, ename, sal, emp.deptno, a.avg_sal
FROM emp,
    (SELECT deptno, ROUND(AVG(sal),2) avg_sal
    FROM emp
    GROUP BY deptno) a
WHERE emp.deptno = a.deptno;


실습 ana3 ]
SELECT empno, ename, sal, deptno, 
    MAX(sal) OVER(PARTITION BY deptno) max_sal
FROM emp;

실습 ana4 ]
SELECT empno, ename, sal, deptno,
    MIN(sal) OVER(PARTITION BY deptno) min_sal
FROM emp;