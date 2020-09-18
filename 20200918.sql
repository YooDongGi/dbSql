DML : Data Manipulate Language
 1. SELECT ***
 2. INSERT
 3. UPDATE
 4. DELETE

DDL : Data Defination Language
      데이터와 관련된 객체를 생성, 수정, 삭제하는 명령

오라클 객체 생성, 삭제 명령
CREATE 객체타입 객체이름(개발자가 부여){
}.....

DROP 객체타입 객체이름;

****
테이블을 생성하는 문법
CREATE TABLE [오라클사용자명].테이블명 (
    컬럼명 컬럼의 데이터타입, 
    컬럼명2 컬럼의 데이터타입2,.......
);

테이블 생성
테이블명 - ranger
컬럼 ranger_no NUMBER
     ranger_nm VARCHAR2(50),
     reg_dt DATE

CREATE TABLE ranger (
    ranger_no NUMBER,
    ranger_nm VARCHAR2(50),
    reg_dt DATE);
    
INSERT INTO ranger(ranger_no,ranger_nm, reg_dt) VALUES (1,'brown',SYSDATE);

SELECT * FROM ranger;
테이블 삭제
DROP TABLE ranger;

테이블 타입
1. 숫자 : NUMBER(p , s)    p : 전체자리수, s : 소수점 자리수           
        ==> NUMBER -> 숫자가 표현할 수 있는 최대 범위로 표현
2. 문자 : VARCHAR2(사이즈-byte), CHAR(x)
         VARCHAR2의 최대 사이즈 4000byte
         VARCHAR2(2000) : 최대 2000byte를 담을 수 있는 문자 타입
         java - 2byte, oracle xe 11g - 3byte
         
         CHAR(1~2000 byte), 고정길이 문자열
         CHAR(5) 'test' 
            => test는 4byte이고 char(5)는 5byte이기 때문에 남은 데이터 공간에 공백 문자를 삽입함.
3. 날짜 : DATE - 7byte 고정
            일자, 시간(시,분,초) 정보 저장
        varchar2 날짜관리 : YYYYMMDD ==> '20200918' ==> 8byte
        시스템에서 문자 형식으로 많이 사용한다면 문자 타입으로 사용도 고려
4. Large OBJECT
    4.1 CLOB : 문자열을 저장할 수 있는 타입, 사이즈 : 4GB
    4.2 BLOB : 바이너리 데이터, 사이즈 : 4GB
                                                                                                           
제약조건 : 데이터에 이상한 값이 들어가지 않도록 강제하는 설정
    EX) emp 테이블에 empno컬럼에 값이 없는 상태로 들어가는 것을 방지
        emp 테이블에 deptno컬럼의 값이 dept 테이블에 존재하지 않는 데이터를 입력하는 것을 방지
        emp 테이블에 empno(사번)컬럼의 값이 중복되지 않도록 방지
        
제약조건은 4가지가 존재, 그 중에 한가지의 일부를 별도의 키워드로 제공
        ORACLE 에서 만들 수 있는 제약조건은 5가지
        
1. NOT NULL : 컬럼에 반드시 값이 들어가게 하는 제약조건
2. UNIQUE : 해당 컬럼에 중복된 값이 들어오는 것을 방지하는 제약조건
3. PRIMARY KEY : UNIQUE + NOT NULL 값이 중복이 되도 안되고 NULL 값이 들어와도 안된다.
4. FOREIGN KEY : 해당 컬럼이 참조하는 다른 테이블의 컬럼에 값이 존재해야하는 제약조건 
                emp.deptno ==> dept.deptno
5. CHECK : 컬럼에 들어갈 수 있는 값을 제한하는 제약조건
            ex) 성별이라는 컬럼이 있다고 가정 => 들어갈 수 있는 값이 : 남 M, 여 F ==> T값은 들어갈 수 없다.
            
제약조건을 생성하는 방법 3가지
1. 테이블을 생성하면서 컬럼 레벨에 제약조건을 생성
        => 제약조건을 결합 컬럼(여러개의 컬럼을 합쳐서)에는 적용 불가
2. 테이블을 생성하면서 테이블 레벨에 제약조건을 생성 ( 주로 사용 )
3. 이미 생성된 테이블에 제약조건을 추가하여 생성

1. 테이블 생성시 컬럼 레벨로 제약조건 생성
CREATE TABLE 테이블명 (
    컬럼1이름 컬럼1타입 [컬럼제약조건] ,
    컬럼2이름 컬럼2타입 [컬럼제약조건] ....
);

dept_test 테이블 생성 -> 컬럼 : dept 테이블과 동일 -> 제약조건 : deptno 컬럼을 PRIMARY KEY 제약조건으로 생성

DESC dept;

CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    LOC VARCHAR2(13)
);

INSERT INTO dept_test VALUES (NULL, 'ddit', 'daejeon');
    ==> PRIMARY KEY 제약에 의해 deptno 컬럼에는 NULL 값이 들어갈 수 없다. (오류 발생)
INSERT INTO dept_test VALUES (90, 'ddit', 'daejeon');
    ==> 90번 부서는 존재하지 않고 NULL 값이 아니므로 정상적으로 등록 (오류 x)
INSERT INTO dept_test VALUES (90, 'ddi', 'daejeon');
    ==> PRIMARY KEY 제약에 의해 deptno 컬럼에는 중복된 값이 들어갈 수 없다. ( 2번째 줄 오류 발생)

비교
dept 테이블에는 deptno컬럼에 PRIMARY KEY 제약이 없는 상태 => 중복된 값이 들어갈 수 있다.
INSERT INTO dept VALUES (90, 'ddit', 'daejeon');
INSERT INTO dept VALUES (90, 'ddi', 'daejeon');
SELECT * FROM dept WHERE deptno = 90;


제약조건 생성시 이름을 부여할 수 있다.
DROP TABLE dept_test;
CREATE TABLE dept_test (
    deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY,
    dname VARCHAR2(14),
    LOC VARCHAR2(13)
);
 ==> ORA-00001: unique constraint (YDG.PK_DEPT_TEST) violated
     제약조건을 어긴 오류발생시 문제점을 찾기 수월해진다.

2. 테이블 생성시 테이블 레벨로 제약조건 생성
CREATE TABLE 테이블명 (
    컬럼1 컬럼1의 데이터타입,
    컬럼2 컬럼2의 데이터타입,
    [TABLE LEVEL 제약조건]
);

DROP TABLE dept_test;

CREATE TABLE dept_test (
    deptno NUMBER(2),
    dname VARCHAR2(14),
    LOC VARCHAR2(13),
    CONSTRAINT PK_dept_test PRIMARY KEY (deptno, dname)
);

deptno 컬럼의 값은 90으로 같지만 dname 컬럼의 값이 다르므로 
PRIMARY KEY (deptno, dname) 설정에 따라 데이터가 입력될 수 있다.
INSERT INTO dept_test VALUES(90, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(90, 'ddit2', 'daejeon');
SELECT * FROM dept_test;

복합컬럼에 대한 제약조건은 컬럼 레벨에서는 설정이 불가하고 테이블 레벨, 혹은 테이블 생성 후
제약조건을 추가하는 형태에서만 가능하다.

CREATE TABLE dept_test (
    deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY ,
    dname VARCHAR2(14) NOT NULL,
    LOC VARCHAR2(13)
);

INSERT INTO dept_test VALUES(90, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(91, NULL , '대전');


UNIQUE 제약조건 : 값의 중복이 없도록 방지하는 제약조건, 단 NULL은 허용

CREATE TABLE dept_test (
    deptno NUMBER(2),
    dname VARCHAR2(14),
    LOC VARCHAR2(13),
    CONSTRAINT U_dept_test_dname UNIQUE (dname)
);


FOREIGN KEY 제약조건 : 참조하는 테이블에 데이터만 입력가능하도록 제어
다른 제약조건과 다르게 두개의 테이블 간의 제약조건 설정
1. dept_test (부모) 테이블 생성
2. emp_test (자식) 테이블 생성
 2.1 참조 제약 조건을 같이 생성

1.
CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    LOC VARCHAR2(13)
);
INSERT INTO dept_test VALUES (90, 'ddit', 'daejeon');

2. emp_test(empno, ename, deptno)

CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test (deptno) 
);
참조 무결성 제약조건에 의해 emp_test 테이블의 deptno 컬럼의 값은
 dept_test 테이블의 deptno 컬럼에 존재하는 값만 입력이 가능하다.

현재는 dept_test 테이블에는 90번 부서만 존재, 그렇기 때문에 emp_test에는 90번 이외의 값이 들어갈 수 없다.
INSERT INTO emp_test VALUES (9000, 'brown', 90);
INSERT INTO emp_test VALUES (9000, 'sally', 10);    -- 에러발생

테이블 레벨 참조 무결성 제약조건 생성
DROP TABLE emp_test;
CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY(deptno) 
    REFERENCES dept_test (deptno) 
);

INSERT INTO emp_test VALUES (9000, 'brown', 90);
INSERT INTO emp_test VALUES (9000, 'sally', 10);    -- 에러발생


dept_test : 90번 부서가 존재
emp_test : 90번 부서를 참조하는 9000번 brown이 존재

만약 dept_test테이블에서 10번 부서를 삭제하게 된다면? -> 오류 발생( 삭제되지 않음 )

DELETE dept_test
WHERE deptno = 90;

참조 무결성 조건 옵션
1. default : 자식이 있는 부모 데이터를 삭제할 수 없다.
2. 참조 무결성 생성시 OPTION - ON DELETE SET NULL
                    삭제시 참조하고 있는 자식테이블의 컬럼을 NULL로 만든다.
DROP TABLE emp_test;
CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY(deptno) 
    REFERENCES dept_test (deptno) ON DELETE SET NULL
);
INSERT INTO emp_test VALUES (9000, 'brown', 90);
DELETE dept_test WHERE deptno = 90;                    
SELECT * FROM emp_test;
=> 90번 부서에 속한 9000번 사원의 deptno 컬럼의 값이 NULL로 설정됨

3. 참조 무결성 생성시 OPTION - ON DELETE CASCADE
                    삭제시 참조하고 있는 자식테이블의 데이터도 같이 삭제
                    
DROP TABLE emp_test;
CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY(deptno) 
    REFERENCES dept_test (deptno) ON DELETE CASCADE
);
INSERT INTO dept_test VALUES(90,'ddit', 'daejeon');
INSERT INTO emp_test VALUES (9000, 'brown', 90);
DELETE dept_test WHERE deptno = 90;                    
SELECT * FROM emp_test;
=> 90번 부서에 속한 9000번 사원의 데이터도 같이 삭제가 된다.


체크 제약 조건 : 컬럼의 값을 확인하여 입력을 허용

DROP TABLE emp_test;
CREATE TABLE emp_test (
    emp NUMBER(4),
    ename VARCHAR2(14),
    sal NUMBER(7) CHECK(sal > 0),
    gender VARCHAR2(1) CHECK(gender IN('M', 'F'))
);

INSERT INTO emp_test VALUES ( 9000, 'brown' , -5, 'M');     --sal 체크 
INSERT INTO emp_test VALUES ( 9000, 'brown' , 100, 'T');    --성별 체크
INSERT INTO emp_test VALUES ( 9000, 'brown' , 100, 'M');    --체크 통과


-- 제약조건 이름 붙여주기
DROP TABLE emp_test;
CREATE TABLE emp_test (
    emp NUMBER(4),
    ename VARCHAR2(14),
    sal NUMBER(7) CONSTRAINT c_sal CHECK(sal > 0),
    gender VARCHAR2(1) CONSTRAINT c_gender CHECK(gender IN('M', 'F'))
);

INSERT INTO emp_test VALUES ( 9000, 'brown' , -5, 'M');     --sal 체크 
INSERT INTO emp_test VALUES ( 9000, 'brown' , 100, 'T');    --성별 체크
INSERT INTO emp_test VALUES ( 9000, 'brown' , 100, 'M');    --체크 통과



DROP TABLE emp_test;
CREATE TABLE emp_test (
    emp NUMBER(4),
    ename VARCHAR2(14),
    sal NUMBER(7),
    gender VARCHAR2(1),
    CONSTRAINT c_sal CHECK(sal > 0),
    CONSTRAINT c_gender CHECK(gender IN('M', 'F'))
);
INSERT INTO emp_test VALUES ( 9000, 'brown' , -5, 'M');     --sal 체크 
INSERT INTO emp_test VALUES ( 9000, 'brown' , 100, 'T');    --성별 체크
INSERT INTO emp_test VALUES ( 9000, 'brown' , 100, 'M');    --체크 통과


DDL 주의점
1. DDL 은 ROLLBACK이 안된다.!!!!
    DROP TABLE emp_test;
    CREATE TABLE emp_test (
        empno NUMBER(4),
        ename VARCHAR2(14)
    );
    ROLLBACK;
    SELECT * FROM emp_test;
    
2. DDL은 AUTO COMMIT


SELECT 결과를 이용하여 테이블 생성하기

CREATE TABLE 테이블명 [(컬럼, 컬럼2)] AS SELECT 쿼리;

CREATE TABLE AS ==> CTAS
1. NOT NULL을 제외한 나머지 제약조건을 복사하진 않는다. 
2. 개발시
    테스트 데이터를 만들어 놓고 실험을 해보고 싶을 때
    개발자 수준의 데이터 백업


CREATE TABLE dept_test (dno, dnm, location) AS
SELECT * FROM dept;

데이터 없이 테이블 구조만 복사하고 싶을 때
DROP TABLE dept_test;
CREATE TABLE dept_test AS
SELECT * FROM dept WHERE 1 != 1;

SELECT * FROM dept_test;

------------------------------------------------------
TABLE 변경 
1. 새로운 컬럼을 추가
2. 기존에 존재하는 컬럼의 변경 ( 이름 , 데이터 타입)
    **데이터 타입의 경우는 이미 데이터가 존재하면 수정이 불가능하다고 보면 됨.
     동일한 데이터 타입으로 사이즈를 늘리는 경우는 상관 없음
     ==> 설계시 충분히 고려하자.
3. 테이블이 이미 생성된 시점에서 제약조건을 추가 

테이블 변경으로 못하는 사항
1. 컬럼 순서는 못바꾼다.
2. 새로운 컬럼을 추가하더라도 마지막 컬럼 뒤에 순서가 부여된다.


컬럼추가
DROP TABLE emp_test;
CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(14)
);
DESC emp_test;

emp_test 테이블에 hp컬럼을 VARCHAR2(15)로 추가
ALTER TABLE emp_test ADD (hp VARCHAR2(15));

hp 컬럼의 문자열 사이즈를 30으로 변경
ALTER TABLE emp_test MODIFY (hp VARCHAR2(30));
hp 컬럼의 문자열 타입을 NUMBER 로 변경
ALTER TABLE emp_test MODIFY (hp NUMBER(10));
*** 데이터 타입을 바꾸는 것은 데이터가 없을 때는 상관없지만,
    데이터가 있을 경우는 사이즈를 늘리는 것을 제외하고는 불가능.
hp 컬럼을 phone으로 컬럼명을 변경
-- 이름 변경은 데이터가 있어도 가능
ALTER TABLE emp_test RENAME COLUMN hp TO phone;

컬럼 삭제
emp_test 테이블의 phone 컬럼을 삭제
ALTER TABLE emp_test DROP (phone);

테이블이 생성된 시점에서 제약조건을 추가, 삭제하기
문법
ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 제약조건 타입;    --추가
ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;              --삭제

DROP TABLE emp_test;
DROP TABLE dept_test;

CREATE TABLE dept_test (
    deptno NUMBER(2),
    dname VARCHAR2(14)
);
CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2)
);

1. dept_test 테이블의 deptno컬럼에 PRIMARY KEY 제약 조건 추가
ALTER TABLE dept_test ADD CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno);

2. emp_test 테이블의 empno컬럼에 PRIMARY KEY 제약 조건 추가
ALTER TABLE emp_test ADD CONSTRAINT PK_EMP_TEST PRIMARY KEY (empno);

3. emp_test 테이블의 deptno컬럼에 dept_test 컬럼의 deptno 컬럼을 참조하는 FOREIGN KEY 제약 조건 추가
ALTER TABLE emp_test ADD CONSTRAINT FK_EMP_TEST_DEPT_TEST
    FOREIGN KEY (deptno) REFERENCES dept_test (deptno);
