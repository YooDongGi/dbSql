달력 만들기
1. 행을 인위적으로 만들기
    CONNECT BY LEVEL
 
2. 그룹 함수
    여러행을 하나의 행으로 만드는 방법
    
3. expression
    테이블에 존재하지 않지만, 수식, 함수를 이용하여 새로운 컬럼을 만드는 방법

4. 부수적인 것들
    date 관련 함수
        - 월의 마지막 일자 구하기(LAST_DAY)
        
        
1. 인위적으로 여러개의 행을 만들기
    계층쿼리 : 행과 행을 연결
            CONNECT BY LEVEL ==> CROSS JOIN 과 비슷 (연결 가능한 모든 행을 연결)
    조인 : 테이블의 행과, 다른 테이블의 행을 연결 - 컬럼이 확장
    SELECT LEVEL, dummy, LTRIM(SYS_CONNECT_BY_PATH(dummy, '-'), '-') 헿
    FROM dual 
    CONNECT BY LEVEL <= 10;
    
    년월 문자열이 주어졋을 때 해당 월의 일 수 구하기
    EX : '202010' ==> 31
    

SELECT LEVEL, dummy
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')),'dd');

--2020년 10월 1일의 날짜 타입을 구함
TO_DATE('202010', 'YYYYMM')

SELECT  MIN(DECODE(d, 1, day)) SUN, MIN(DECODE(d, 2, day)) MON, MIN(DECODE(d, 3, day)) TUE,
        MIN(DECODE(d, 4, day)) WED, MIN(DECODE(d, 5, day)) THU,
        MIN(DECODE(d, 6, day)) FRI, MIN(DECODE(d, 7, day)) SAT
FROM
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + LEVEL-1 day,
            TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + LEVEL-1 ,'D')d,
            TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + LEVEL-1 ,'IW')iw
     FROM dual
     CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')),'dd'))
GROUP BY DECODE(d, 1,iw+1, iw) ORDER BY DECODE(d, 1,iw+1, iw);