SELECT * FROM student;
SELECT * FROM professor;
select * from department;
select * from salgrade;
select * from tab;
select * from emp;
select * from dept;

/* 날짜 함수 */
/* 101번 학과 교수들의 입사일을 일, 월, 년을 기준으로 반올림하여 출력 */
SELECT  TO_CHAR(hiredate, 'YY/MM/DD HH24:MI:SS') hiredate,
        TO_CHAR(ROUND(hiredate, 'dd'), 'YY/MM/DD') round_dd,
        TO_CHAR(ROUND(hiredate, 'mm'), 'YY/MM/DD') round_mm,
        TO_CHAR(ROUND(hiredate, 'yy'), 'YY/MM/DD') round_yy
FROM    professor
WHERE   deptno = 101;

/* 학생 테이블에서 전인하 학생의 학번과 생년월일 중에서 년월만 출력 */   
SELECT  TO_CHAR(studno, '9,999,999') studno, TO_CHAR(birthdate, 'YY-MM') birthdate
FROM    student
WHERE   name = '전인하';
    
/* 학생 테이블에서 102번 학과 학생의 이름, 학년, 생년월일을 출력 */
SELECT  name, grade, studno, TO_CHAR(birthdate, 'Day Month DD, YYYY') birthdate
FROM    student
WHERE   deptno = 102;
    
/* 교수 테이블에서 101번 학과 교수의 이름과 입사일 출력 */
SELECT  name, TO_CHAR(hiredate, 'MONTH DD, YYYY HH24:MI:SS PM') hiredate
FROM    professor
WHERE   deptno = 101;
    
/* 교수 테이블에서 101번 학과 교수의 이름, 직급, 입사일 출력 */
SELECT  name, position, TO_CHAR(hiredate, 'MON "the" DDTH "of", YYYY') hiredate
FROM    professor
WHERE   deptno = 101; 
    
/* 보직수당을 받는 교수들의 이름, 급여, 보직수당, 그리고 급여와 보직수당을 더한 값에 12를
곱한 결과를 연봉으로 출력 */
SELECT  name, sal, comm, TO_CHAR((sal+comm)*12, '9,999') anual_sal
FROM    professor
WHERE   comm IS NOT NULL;

/* TO_DATE - 교수 테이블에서 입사일이 'june 01,01'인 교수의 이름과 입사일 출력 */
SELECT  name, hiredate
FROM    professor
WHERE   hiredate = TO_DATE('6월 01, 01', 'MONTH DD, YY');

/* 출생한지 며칠째인지 출력, 열 레이블은 Lived day */
SELECT  TRUNC(SYSDATE - TO_DATE('19910520', 'YYYY-MM-DD')) "Lived day"
FROM    dual;
    
/* 출생일부터 현재일까지의 개월 수 출력, Lived month */    
SELECT  TRUNC(SYSDATE - TO_DATE('19960714', 'YYYY-MM-DD')) "Lived day",
        ROUND(MONTHS_BETWEEN(SYSDATE, TO_DATE('19960714', 'YYYY-MM-DD'))) "Lived month" 
FROM     dual;    
    

/* ---- 일반 함수 ---- */
/* NVL, NVL2*/
SELECT  name, position, sal, comm, sal+comm,
        sal+NVL(comm,0) s1, NVL(sal+comm, sal) s2
FROM    professor
WHERE   deptno = 201;

SELECT  ename, sal, comm
      , sal+comm
      , NVL2(comm, sal+comm, sal)
      , sal+NVL(comm, 0)
FROM    emp;

/* 영어 변환 */
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT  name, grade, TO_CHAR(birthdate, 'Day', 'NLS_DATE_LANGUAGE=KOREAN') ||''||
        TO_CHAR(birthdate, 'Month DD, YYYY' ) birthdate
FROM    student
WHERE   deptno = 102;

/* 사람의 이름과 보너스를 출력하는 질의 작성. 보너스를 받지 않는다면 "NO." 출력.
열 레이블은 COMM */
SELECT  ename, NVL(TO_CHAR(comm), 'NO.') comm
FROM    emp;
desc emp;

/* NULLIF */
/* 교수 테이블에서 이름의 바이트 수와 사용자 아이디의 바이트 수를 비교해서 같으면 NULL을 반환하고
같지 않으면 이름의 바이트 수를 반환 */
SELECT  name, userid, LENGTHB(name), LENGTHB(userid),
        NULLIF(LENGTHB(SUBSTR(name, 1, 2)), LENGTHB(userid)) nullif_result
FROM    professor;

/* COALESCE */
SELECT  name, comm, sal, COALESCE(comm, sal, 0) CO_RESULT
FROM    professor;

/* DECODE */
SELECT  name, deptno,
        DECODE(deptno, 101, ' 컴퓨터공학과', 102, ' 멀티미디어학과',
                201, '전자공학과', '기계공학과') DNAME
FROM    professor;
    
/* 학생 테이블에서 학과번호와 이름, 학과명을 출력하되 101번 학과 학생만 
'Computer Science'로 출력하고 101번이 아닌 학생들은 학과명을 "ETC"로 출력
학과 번호가 없는 학생은 제외 */
SELECT  deptno, name, 
        DECODE(deptno, 101, 'Computer Science', 'ETC') "학과명"
FROM    student
WHERE   name NOT IN ('황보_정호');

/* CASE -> DECODE 보다 더 좋음 */
SELECT  name, deptno, sal,
    CASE WHEN deptno = 101 THEN sal*0.1
         WHEN deptno = 102 THEN sal*0.2
         WHEN deptno = 201 THEN sal*0.3
         ELSE 0
    END bonus
FROM professor;

/* 학생 테이블에서 생년월일에서 월을 추출하여 태어난 분기 출력 */
SELECT  name, SUBSTR(birthdate, 4, 2) MONTH,
    concat(TO_CHAR(birthdate, 'Q'), '/4') 분기
FROM student;
desc student;

/* ---- GROUP 함수 ---- */
SELECT  AVG(weight), SUM(weight)
FROM    student
WHERE   deptno = 101;

/* 모든 사원의 최대 급여, 최저 급여, 합계 그리고 평균 급여 출력 */
SELECT  MAX(sal) "Maximum", MIN(sal) "Minium",
        SUM(sal) "Sum", ROUND(AVG(sal)) "Average"
FROM    emp;
    
/* STDDEV, VARIANCE 표준편차, 분산 */
SELECT  ROUND(STDDEV(sal), 6), ROUND(VARIANCE(sal), 4)
FROM    professor;
    
/* ---- 데이터 그룹 ---- */
/* GROUP BY */
SELECT  deptno, COUNT(*), COUNT(comm)
FROM    professor
GROUP BY deptno;
   
/* 학과별로 소속 교수들의 평균 급여, 최소급여, 최대급여를 출력 */ 
SELECT  deptno, AVG(sal), MIN(sal), MAX(sal)
FROM    professor
GROUP BY deptno;

SELECT  deptno, profno, sal
FROM    professor
ORDER BY deptno;

/* 전체 학생을 소속 학과별로 나누고, 같은 학과 학생은 다시 학년별로 그룹핑하여, 학과와 학년별
이눤수, 평균 몸무게를 출력. 단, 평균 몸무게는 소수점 이하 첫번째 자리에서 반올림 */
SELECT  deptno, grade, COUNT(*), ROUND(AVG(weight))
FROM    student
GROUP BY deptno, grade
ORDER BY count(*);

/* ROLLUP, CUBE 소계, 합계 */
/* 소속 학과별로 교수 급여 합계와 모든 학과 교수들의 급여 합계 출력 */
SELECT  deptno, SUM(sal)
FROM    professor
GROUP BY ROLLUP(deptno);
    
/* ROLLUP 연산자를 이용하여 학과 및 직급별 교수 수, 학과별 교수 수, 전체 교수 수 출력 */    
SELECT  deptno, position, COUNT(*)
FROM    professor
GROUP BY ROLLUP(deptno, position);
    
/* CUBE 연산자 */
SELECT  deptno, position, COUNT(*)
FROM    professor
GROUP BY CUBE(deptno, position);
  
/* GROUPING 함수 */  
 /* 전체 학생을 학과 학년별로 그룹화한 후, 학과와 학년별 그룹 인원수, 각 그룹 조합에서 학과와
 학년 칼럼이 사용되었는지 여부 출력 */
SELECT deptno, grade, COUNT(*),
        GROUPING(deptno)    grp_dno,
        GROUPING(grade)     grp_grade
FROM    student
GROUP BY ROLLUP(deptno, grade);

/* GROUPING SETS 함수 - GROUP BY UNION ALL 결과와 동일 */
SELECT  deptno, grade, NULL, COUNT(*)
FROM    student
GROUP BY deptno, grade
UNION ALL
SELECT  deptno, NULL, TO_CHAR(birthdate, 'YYYY'), COUNT(*)
FROM    student
GROUP BY deptno, TO_CHAR(birthdate, 'YYYY');
/*  ↓↓↓↓ 같은 결과 */
SELECT  deptno, grade, TO_CHAR(birthdate, 'YYYY'), COUNT(*)
FROM    student
GROUP BY GROUPING SETS((deptno, grade), (deptno, TO_CHAR(birthdate, 'YYYY')));
    
/* ---- HAVING 절 ---- */
SELECT  grade, COUNT(*), ROUND(AVG(height)) avg_height,
        ROUND(AVG(weight)) avg_weight
FROM    student
GROUP BY grade
HAVING  COUNT(*) > 4
ORDER BY avg_height DESC;
    
/* 함수의 중첩 */
SELECT  deptno, AVG(weight)
FROM    student
GROUP BY deptno;

SELECT  MAX(AVG(weight)) max_weight
FROM    student
GROUP BY deptno;

/* 사원 테이블(emp)에서 급여를 1500 이상 받는 사원들 중에서 평균 급여가 2000이상인
부서 번호, 평균 급여 출력 */
SELECT  deptno 부서번호, ROUND(AVG(sal)) 급여
FROM    emp
WHERE   sal >=1500
GROUP BY deptno
HAVING AVG(sal) >= 2000
ORDER BY deptno;

/* 학과별 학생 수가 최대 또는 최소인 학과의 학생 수를 출력 */
SELECT  MAX(COUNT(studno)) max_cnt, MIN(COUNT(studno)) min_cnt
FROM    student
GROUP BY deptno;

/* ---- 조인(join) ---- */
SELECT  studno, name,
        student.deptno, department.dname, department.loc
FROM    student, department
WHERE   student.deptno = department.deptno;

/* table 별명 - 별명 부여한 이후 별명만 써야 됨 */
SELECT  s.studno, s.name,
        s.deptno, d.dname, d.loc
FROM    student s, department d
WHERE   s.deptno = d.deptno;

SELECT  s.studno, s.name, d.dname, d.loc
FROM    student s, department d
WHERE   s.deptno = d.deptno
AND     s.name = '전인하';


/* 사원 테이블에서 DALLAS에 근무하는 사번, 이름, 부서번호, 부서이름, 부서 위치 출력 */
SELECT  e.empno, e.ename, e.DEPTNO, d.dname, d.loc
FROM    emp e, dept d
WHERE   e.deptno = d.deptno
AND     d.loc = 'DALLAS';

/* 급여가 400이상인 교수 이름, 급여, 학과 번호, 학과 이름 출력 */
SELECT  p.name, p.sal, p.deptno, d.dname
FROM    professor p, department d
WHERE   p.deptno = d.deptno
AND     p.sal >= 400;
    
/* 컴퓨터공학과 학생들의 학번, 이름, 학과번호, 학과이름, 학과위치, 지도교수 이름, 급여 출력*/
SELECT  s.studno 학번, s.name 학생이름, s.deptno 학과번호, d.dname 학과이름, 
        d.loc 학과위치, p.profno 지도교수번호, p.name 지도교수이름, p.sal 급여
FROM    student s, professor p, department d
WHERE   s.profno = p.profno
AND     p.deptno = d.deptno
AND     d.dname = '컴퓨터공학과';

/* 몸무게가 80kg 이상인 학생의 학번, 이름, 체중, 학과이름, 학과 위치를 출력 */
SELECT  s.studno, s.name, d.dname, d.loc
FROM    student s, department d
WHERE   s.deptno = d.deptno
AND     s.weight >= 80;

/* 조인의 종류 */
/* 카티션 */
SELECT  studno, name, s.deptno,
        d.deptno, d.dname
FROM    student s, department d; /* 연결고리가 없어서 140행이 출력 */

SELECT  name, student.deptno, dname
FROM    student CROSS JOIN department;

SELECT  s.studno, s.name, s.deptno, d.dname, d.loc
FROM    student s, department d
WHERE   s.deptno = d.deptno;


/* ---- 문제 ---- */
SELECT  ename, COALESCE(comm, comm, 200) bonus
FROM    emp;
desc emp;

SELECT  job, SUM(sal) PAYROLL
FROM    emp 
GROUP BY job
HAVING  SUM(sal) >= 5000
and     job <> ('PRESIDENT')
ORDER BY SUM(SAL);

SELECT  e.ename, e.job, e.deptno, d.dname
FROM    emp e, dept d
WHERE   e.deptno = d.deptno
and     d.loc = 'CHICAGO';

SELECT  ename, TO_CHAR(hiredate, 'YY/MM/DD'), TO_CHAR(hiredate, 'day', 'NLS_DATE_LANGUAGE=KOREAN') DAY
FROM    emp
ORDER BY TO_CHAR(hiredate-1, 'D');

SELECT  COUNT(*) TOTAL, 
        COUNT(DECODE(SUBSTR(hiredate,1,2), 80, hiredate)) "1980",
        COUNT(DECODE(SUBSTR(hiredate,1,2), 81, hiredate)) "1981",
        COUNT(DECODE(SUBSTR(hiredate,1,2), 82, hiredate)) "1982",
        COUNT(DECODE(SUBSTR(hiredate,1,2), 87, hiredate)) "1987"
FROM    emp;
        








    