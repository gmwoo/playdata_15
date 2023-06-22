SELECT * FROM student;
SELECT * FROM professor;
select * from department;
select * from salgrade;
select * from tab;
select * from emp;
select * from dept;

/* ��¥ �Լ� */
/* 101�� �а� �������� �Ի����� ��, ��, ���� �������� �ݿø��Ͽ� ��� */
SELECT  TO_CHAR(hiredate, 'YY/MM/DD HH24:MI:SS') hiredate,
        TO_CHAR(ROUND(hiredate, 'dd'), 'YY/MM/DD') round_dd,
        TO_CHAR(ROUND(hiredate, 'mm'), 'YY/MM/DD') round_mm,
        TO_CHAR(ROUND(hiredate, 'yy'), 'YY/MM/DD') round_yy
FROM    professor
WHERE   deptno = 101;

/* �л� ���̺��� ������ �л��� �й��� ������� �߿��� ����� ��� */   
SELECT  TO_CHAR(studno, '9,999,999') studno, TO_CHAR(birthdate, 'YY-MM') birthdate
FROM    student
WHERE   name = '������';
    
/* �л� ���̺��� 102�� �а� �л��� �̸�, �г�, ��������� ��� */
SELECT  name, grade, studno, TO_CHAR(birthdate, 'Day Month DD, YYYY') birthdate
FROM    student
WHERE   deptno = 102;
    
/* ���� ���̺��� 101�� �а� ������ �̸��� �Ի��� ��� */
SELECT  name, TO_CHAR(hiredate, 'MONTH DD, YYYY HH24:MI:SS PM') hiredate
FROM    professor
WHERE   deptno = 101;
    
/* ���� ���̺��� 101�� �а� ������ �̸�, ����, �Ի��� ��� */
SELECT  name, position, TO_CHAR(hiredate, 'MON "the" DDTH "of", YYYY') hiredate
FROM    professor
WHERE   deptno = 101; 
    
/* ���������� �޴� �������� �̸�, �޿�, ��������, �׸��� �޿��� ���������� ���� ���� 12��
���� ����� �������� ��� */
SELECT  name, sal, comm, TO_CHAR((sal+comm)*12, '9,999') anual_sal
FROM    professor
WHERE   comm IS NOT NULL;

/* TO_DATE - ���� ���̺��� �Ի����� 'june 01,01'�� ������ �̸��� �Ի��� ��� */
SELECT  name, hiredate
FROM    professor
WHERE   hiredate = TO_DATE('6�� 01, 01', 'MONTH DD, YY');

/* ������� ��ĥ°���� ���, �� ���̺��� Lived day */
SELECT  TRUNC(SYSDATE - TO_DATE('19910520', 'YYYY-MM-DD')) "Lived day"
FROM    dual;
    
/* ����Ϻ��� �����ϱ����� ���� �� ���, Lived month */    
SELECT  TRUNC(SYSDATE - TO_DATE('19960714', 'YYYY-MM-DD')) "Lived day",
        ROUND(MONTHS_BETWEEN(SYSDATE, TO_DATE('19960714', 'YYYY-MM-DD'))) "Lived month" 
FROM     dual;    
    

/* ---- �Ϲ� �Լ� ---- */
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

/* ���� ��ȯ */
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT  name, grade, TO_CHAR(birthdate, 'Day', 'NLS_DATE_LANGUAGE=KOREAN') ||''||
        TO_CHAR(birthdate, 'Month DD, YYYY' ) birthdate
FROM    student
WHERE   deptno = 102;

/* ����� �̸��� ���ʽ��� ����ϴ� ���� �ۼ�. ���ʽ��� ���� �ʴ´ٸ� "NO." ���.
�� ���̺��� COMM */
SELECT  ename, NVL(TO_CHAR(comm), 'NO.') comm
FROM    emp;
desc emp;

/* NULLIF */
/* ���� ���̺��� �̸��� ����Ʈ ���� ����� ���̵��� ����Ʈ ���� ���ؼ� ������ NULL�� ��ȯ�ϰ�
���� ������ �̸��� ����Ʈ ���� ��ȯ */
SELECT  name, userid, LENGTHB(name), LENGTHB(userid),
        NULLIF(LENGTHB(SUBSTR(name, 1, 2)), LENGTHB(userid)) nullif_result
FROM    professor;

/* COALESCE */
SELECT  name, comm, sal, COALESCE(comm, sal, 0) CO_RESULT
FROM    professor;

/* DECODE */
SELECT  name, deptno,
        DECODE(deptno, 101, ' ��ǻ�Ͱ��а�', 102, ' ��Ƽ�̵���а�',
                201, '���ڰ��а�', '�����а�') DNAME
FROM    professor;
    
/* �л� ���̺��� �а���ȣ�� �̸�, �а����� ����ϵ� 101�� �а� �л��� 
'Computer Science'�� ����ϰ� 101���� �ƴ� �л����� �а����� "ETC"�� ���
�а� ��ȣ�� ���� �л��� ���� */
SELECT  deptno, name, 
        DECODE(deptno, 101, 'Computer Science', 'ETC') "�а���"
FROM    student
WHERE   name NOT IN ('Ȳ��_��ȣ');

/* CASE -> DECODE ���� �� ���� */
SELECT  name, deptno, sal,
    CASE WHEN deptno = 101 THEN sal*0.1
         WHEN deptno = 102 THEN sal*0.2
         WHEN deptno = 201 THEN sal*0.3
         ELSE 0
    END bonus
FROM professor;

/* �л� ���̺��� ������Ͽ��� ���� �����Ͽ� �¾ �б� ��� */
SELECT  name, SUBSTR(birthdate, 4, 2) MONTH,
    concat(TO_CHAR(birthdate, 'Q'), '/4') �б�
FROM student;
desc student;

/* ---- GROUP �Լ� ---- */
SELECT  AVG(weight), SUM(weight)
FROM    student
WHERE   deptno = 101;

/* ��� ����� �ִ� �޿�, ���� �޿�, �հ� �׸��� ��� �޿� ��� */
SELECT  MAX(sal) "Maximum", MIN(sal) "Minium",
        SUM(sal) "Sum", ROUND(AVG(sal)) "Average"
FROM    emp;
    
/* STDDEV, VARIANCE ǥ������, �л� */
SELECT  ROUND(STDDEV(sal), 6), ROUND(VARIANCE(sal), 4)
FROM    professor;
    
/* ---- ������ �׷� ---- */
/* GROUP BY */
SELECT  deptno, COUNT(*), COUNT(comm)
FROM    professor
GROUP BY deptno;
   
/* �а����� �Ҽ� �������� ��� �޿�, �ּұ޿�, �ִ�޿��� ��� */ 
SELECT  deptno, AVG(sal), MIN(sal), MAX(sal)
FROM    professor
GROUP BY deptno;

SELECT  deptno, profno, sal
FROM    professor
ORDER BY deptno;

/* ��ü �л��� �Ҽ� �а����� ������, ���� �а� �л��� �ٽ� �г⺰�� �׷����Ͽ�, �а��� �г⺰
�̇���, ��� �����Ը� ���. ��, ��� �����Դ� �Ҽ��� ���� ù��° �ڸ����� �ݿø� */
SELECT  deptno, grade, COUNT(*), ROUND(AVG(weight))
FROM    student
GROUP BY deptno, grade
ORDER BY count(*);

/* ROLLUP, CUBE �Ұ�, �հ� */
/* �Ҽ� �а����� ���� �޿� �հ�� ��� �а� �������� �޿� �հ� ��� */
SELECT  deptno, SUM(sal)
FROM    professor
GROUP BY ROLLUP(deptno);
    
/* ROLLUP �����ڸ� �̿��Ͽ� �а� �� ���޺� ���� ��, �а��� ���� ��, ��ü ���� �� ��� */    
SELECT  deptno, position, COUNT(*)
FROM    professor
GROUP BY ROLLUP(deptno, position);
    
/* CUBE ������ */
SELECT  deptno, position, COUNT(*)
FROM    professor
GROUP BY CUBE(deptno, position);
  
/* GROUPING �Լ� */  
 /* ��ü �л��� �а� �г⺰�� �׷�ȭ�� ��, �а��� �г⺰ �׷� �ο���, �� �׷� ���տ��� �а���
 �г� Į���� ���Ǿ����� ���� ��� */
SELECT deptno, grade, COUNT(*),
        GROUPING(deptno)    grp_dno,
        GROUPING(grade)     grp_grade
FROM    student
GROUP BY ROLLUP(deptno, grade);

/* GROUPING SETS �Լ� - GROUP BY UNION ALL ����� ���� */
SELECT  deptno, grade, NULL, COUNT(*)
FROM    student
GROUP BY deptno, grade
UNION ALL
SELECT  deptno, NULL, TO_CHAR(birthdate, 'YYYY'), COUNT(*)
FROM    student
GROUP BY deptno, TO_CHAR(birthdate, 'YYYY');
/*  ����� ���� ��� */
SELECT  deptno, grade, TO_CHAR(birthdate, 'YYYY'), COUNT(*)
FROM    student
GROUP BY GROUPING SETS((deptno, grade), (deptno, TO_CHAR(birthdate, 'YYYY')));
    
/* ---- HAVING �� ---- */
SELECT  grade, COUNT(*), ROUND(AVG(height)) avg_height,
        ROUND(AVG(weight)) avg_weight
FROM    student
GROUP BY grade
HAVING  COUNT(*) > 4
ORDER BY avg_height DESC;
    
/* �Լ��� ��ø */
SELECT  deptno, AVG(weight)
FROM    student
GROUP BY deptno;

SELECT  MAX(AVG(weight)) max_weight
FROM    student
GROUP BY deptno;

/* ��� ���̺�(emp)���� �޿��� 1500 �̻� �޴� ����� �߿��� ��� �޿��� 2000�̻���
�μ� ��ȣ, ��� �޿� ��� */
SELECT  deptno �μ���ȣ, ROUND(AVG(sal)) �޿�
FROM    emp
WHERE   sal >=1500
GROUP BY deptno
HAVING AVG(sal) >= 2000
ORDER BY deptno;

/* �а��� �л� ���� �ִ� �Ǵ� �ּ��� �а��� �л� ���� ��� */
SELECT  MAX(COUNT(studno)) max_cnt, MIN(COUNT(studno)) min_cnt
FROM    student
GROUP BY deptno;

/* ---- ����(join) ---- */
SELECT  studno, name,
        student.deptno, department.dname, department.loc
FROM    student, department
WHERE   student.deptno = department.deptno;

/* table ���� - ���� �ο��� ���� ���� ��� �� */
SELECT  s.studno, s.name,
        s.deptno, d.dname, d.loc
FROM    student s, department d
WHERE   s.deptno = d.deptno;

SELECT  s.studno, s.name, d.dname, d.loc
FROM    student s, department d
WHERE   s.deptno = d.deptno
AND     s.name = '������';


/* ��� ���̺��� DALLAS�� �ٹ��ϴ� ���, �̸�, �μ���ȣ, �μ��̸�, �μ� ��ġ ��� */
SELECT  e.empno, e.ename, e.DEPTNO, d.dname, d.loc
FROM    emp e, dept d
WHERE   e.deptno = d.deptno
AND     d.loc = 'DALLAS';

/* �޿��� 400�̻��� ���� �̸�, �޿�, �а� ��ȣ, �а� �̸� ��� */
SELECT  p.name, p.sal, p.deptno, d.dname
FROM    professor p, department d
WHERE   p.deptno = d.deptno
AND     p.sal >= 400;
    
/* ��ǻ�Ͱ��а� �л����� �й�, �̸�, �а���ȣ, �а��̸�, �а���ġ, �������� �̸�, �޿� ���*/
SELECT  s.studno �й�, s.name �л��̸�, s.deptno �а���ȣ, d.dname �а��̸�, 
        d.loc �а���ġ, p.profno ����������ȣ, p.name ���������̸�, p.sal �޿�
FROM    student s, professor p, department d
WHERE   s.profno = p.profno
AND     p.deptno = d.deptno
AND     d.dname = '��ǻ�Ͱ��а�';

/* �����԰� 80kg �̻��� �л��� �й�, �̸�, ü��, �а��̸�, �а� ��ġ�� ��� */
SELECT  s.studno, s.name, d.dname, d.loc
FROM    student s, department d
WHERE   s.deptno = d.deptno
AND     s.weight >= 80;

/* ������ ���� */
/* īƼ�� */
SELECT  studno, name, s.deptno,
        d.deptno, d.dname
FROM    student s, department d; /* ������� ��� 140���� ��� */

SELECT  name, student.deptno, dname
FROM    student CROSS JOIN department;

SELECT  s.studno, s.name, s.deptno, d.dname, d.loc
FROM    student s, department d
WHERE   s.deptno = d.deptno;


/* ---- ���� ---- */
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
        








    