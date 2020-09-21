------------------------------------------------문제
CREATE 생성하는 것
FOREIGN KET 생성하는것
------------------------------------------------
PRIMARY KEY : PK_테이블명
FOREIGN KEY : FK_소스테이블명_참조테이블명

제약조건 삭제
ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;

1. 부서 테이블에 PRIMARY KEY 제약조건 추가
2. 사원 테이블에 PRIMARY KEY 제약조건 추가
3. 사원 테이블 - 부서 테이블 간 FOREIGN KEY 제약조건 추가

제약조건 삭제시는 데이터 입력과 반대로 자식부터 먼저 삭제
3 -> ( 1 , 2)

-- emp_test, dept_test 제약조건 조회
SELECT * FROM user_constraints
WHERE table_name IN ('EMP_TEST', 'DEPT_TEST');

-- 제약조건 삭제
ALTER TABLE emp_test DROP CONSTRAINT FK_emp_test_dept_test;
ALTER TABLE dept_test DROP CONSTRAINT PK_dept_test;
ALTER TABLE emp_test DROP CONSTRAINT PK_emp_test;

-- 제약조건 생성
1. dept_test 테이블의 deptno 컬럼에 PRIMARY KEY 제약조건 추가
ALTER TABLE dept_test ADD CONSTRAINT pk_dept_test PRIMARY KEY (deptno);
2. emp_test 테이블의 empno 컬럼에 PRIMARY KEY 제약조건 추가
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);
3. emp_test 테이블의 deptno 컬럼이 dept_test 컬럼의 deptno 컬럼을 참조하는 FOREIGN KEY 제약조건 추가
ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno);

-- 제약조건 활성화 / 비활성화 테스트
테스트 데이터 준비 : 부모 - 자식 관계가 있는 테이블에서는 부모 테이블에 데이터를 먼저 입력
dept_test ==> emp_test
INSERT INTO dept_test VALUES (10, 'ddit');

INSERT INTO emp_test VALUES (9999, 'brown', 10);
INSERT INTO emp_test VALUES (9998, 'sally', 20);    ==> dept_test에 부서번호 20이 없기 때문에 FK에 의해 오류 발생

FK를 비활성화 하기
ALTER TABLE emp_test DISABLE CONSTRAINT FK_emp_test_dept_test;

FK 제약조건 재활성화    --이미 규칙에 어긋난 것이 있으면 활성화가 되지 않는다.
ALTER TABLE emp_test ENABLE CONSTRAINT FK_emp_test_dept_test;


테이블, 컬럼 주석(comments)을 생성가능
--테이블 주석 정보확인
SELECT * FROM user_tab_comments;

--테이블 주석 작성 방법
COMMENT ON TABLE 테이블명 IS '주석';

COMMENT ON TABLE emp IS '사원';

--컬럼 주석 확인
SELECT * FROM user_col_comments
WHERE TABLE_NAME ='EMP';

-- 컬럼 주석 작성 방법
COMMENT ON COLUMN 테이블명.컬럼명 IS '주석';

COMMENT ON COLUMN emp.EMPNO IS '사번';
COMMENT ON COLUMN emp.ENAME IS '사원이름';
COMMENT ON COLUMN emp.JOB IS '담당역활';
COMMENT ON COLUMN emp.MGR IS '매니저 사번';
COMMENT ON COLUMN emp.HIREDATE IS '입사일자';
COMMENT ON COLUMN emp.SAL IS '급여';
COMMENT ON COLUMN emp.COMM IS '성과급';
COMMENT ON COLUMN emp.DEPTNO IS '소속부서번호';

SELECT * FROM user_tab_comments;

SELECT * FROM user_col_comments;

실습 comment1 ]
SELECT tab.*, col.column_name, col.comments
FROM user_col_comments col, user_tab_comments tab
WHERE col.table_name = tab.table_name AND
    col.table_name IN('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY');


SELECT * FROm user_constraints WHERE table_name IN('EMP', 'DEPT');

DELETE dept WHERE dname = 'ddit';
SELECT * FROM dept;
ALTER TABLE dept ADD CONSTRAINT PK_dept PRIMARY KEY (deptno); 
ALTER TABLE emp ADD CONSTRAINT PK_emp PRIMARY KEY (empno); 
ALTER TABLE emp ADD CONSTRAINT FK_emp_dept FOREIGN KEY (deptno) REFERENCES dept (deptno);
ALTER TABLE emp ADD CONSTRAINT FK_emp_emp FOREIGN KEY (mgr) REFERENCES emp (empno);

VIEW : VIEW는 쿼리이다
    - 물리적인 데이터를 갖고 있지 않고, 논리적인 데이터 정의 집합니다(SELECT 쿼리)
    - VIEW가 사용하고 있는 테이블의 데이터가 바뀌면 VIEW 조회 결과도 같이 바뀐다.
문법
CREATE OR REPLACE VIEW 뷰이름 AS SELECT쿼리;

-- emp 테이블에서 sal, comm 컬럼 두개를 제외한 나머지 6개의 컬럼으로 v_emp 이름으로 view 생성
CREATE OR REPLACE VIEW v_emp AS 
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

SELECT * FROM v_emp;


ROLLBACK;


YDG 계정에 있는 V_EMP 뷰를 HR 계정에게 조회할 수 있도록 권한 부여
GRANT SELECT ON v_emp TO HR;