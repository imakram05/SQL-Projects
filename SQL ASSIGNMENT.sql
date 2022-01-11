use university
;

/* 1. For each department, find the maximum salary of instructors in that department. (use windows function)*/

select dept_name, name, max(salary) 
from instructor
group by dept_name
order by salary desc
;


/* 2. Find the IDs of all students who were taught by an instructor named Katz; make sure there are no duplicates in the result.*/
SELECT distinct student.ID
FROM (student join takes using(ID))
join (instructor join teaches using(ID))
using (course_id,sec_id,semester,year)
where instructor.name = 'Katz'
;


/*3. Find the ID and title of each course in Comp. Sci. 
that has had at least one section with afternoon hours (i.e., ends at or after 12:00). (You should eliminate duplicates if any.) */

select distinct c.course_id, c.title 
from 
((course c
 join section s on c.course_id = s.course_id)
join  time_slot t on s.time_slot_id = t.time_slot_id)
where dept_name = 'Comp. Sci.'
and
 end_hr >= 12
 ;
 

/*4. Find the IDs and titles of all the courses that are prerequisite to the Robotics course. */

select c.course_id, c.title
from course c join prereq p on c.course_id = p.course_id
where c.title = 'Robotics'
;

 
/*5. Find the IDs and names of all instructors earning the highest salary (there may be more than one with the same salary). */

SELECT ID,name
FROM instructor
WHERE salary = (select  max(salary) from instructor)
;



/*6. Find the enrollment (number of students) in each section that was offered in Spring 2017. 
The result columns should be course id, section id, students num. You do not need to output sections with 0 students. */

SELECT  course_id, sec_id, COUNT(ID) as 'students num'
FROM section natural join takes
WHERE semester = 'Spring'
AND year = 2017
group by  course_id, sec_id
;

/*7. Find the IDs and names of all instructors who have taught at least 3 different courses.*/

select instructor.ID, name
from instructor, teaches
where instructor.ID = teaches.ID
group by teaches.ID
having count(distinct course_id) >= 3
;


/*8. Find the ID and name of the student with the highest number of ’A’ grades (there may be more than one such student). */
select ID, name, grade
FROM student natural join takes 
where grade =  (select min(grade) from takes)
;

/*9. Find the ID and name of each History student who has not taken any Music courses. */
select ID, name
from student
where student.dept_name = 'History'
and ID 
not in 
( select ID
from takes, course
where takes.course_id = course.course_id
and course.dept_name = 'Music'
);



/*10. Find the ID and name of each instructor who has never given an A grade in any course she or he has taught.
 (Instructors who have never taught a course trivially satisfy this condition.) */

SELECT ID, name
FROM instructor
WHERE ID NOT IN
( SELECT teaches.ID
FROM teaches, takes
WHERE teaches.course_id = takes.course_id
AND teaches.sec_id = takes.sec_id
AND teaches.semester = takes.semester
AND teaches.year = takes.year
AND grade = 'A'
); 



 
 /*11. Rewrite the preceding query, but also ensure that you include only instructors 
 who have given at least one other non-null grade in some course.*/
 SELECT instructor.ID , name
 FROM instructor
 WHERE exists
 (
 SELECT teaches.ID 
 FROM teaches, takes
 WHERE teaches.ID = instructor.ID
 AND   teaches.course_id = takes.course_id
 AND   teaches.sec_id= takes.sec_id
 AND   teaches.semester = takes.semester
 AND   teaches.year = takes.year
 AND grade is not null
 )
 AND not exists
 (SELECT taeches.ID
 FROM teaches, takes
 WHERE teaches.ID = instructor.ID
 AND   teaches.course_id = takes.course_id
 AND   teaches.sec_id = takes.sec_id
 AND   teaches.semester = takes.semester
 AND   teaches.year = takes.year
 AND   grade = 'A'
 ) ;
 
 
 
 /*12. For each student who have retaken a course at least once 
 (i.e., the student has taken the course at least two times), show the student’s ID, name and the course ID. */
 
  
 SELECT student.ID , name , course_id
 FROM student, takes
 WHERE student.ID = takes.ID
 group by ID, course_id
 HAVING count(*)>= 2
 ;
 
 ----------- 2 SQL UPDATES ----------
 /*1. Create a new course ”CS-900” in the Comp. Sci. department, titled ”Weekly Seminar”, with 2 credits. */
 
 INSERT INTO course
 VALUES('CS-900', 'Weekly Seminar', 'Comp. Sci.' , 2)
 ;
 
 /*-2. Create a section of this course in Fall 2022, with sec id of 2, and with the location of this section not yet specified. ----*/
 
 INSERT INTO section
 VALUES('CS-900', 2, 'Fall', 2022, null, null, null)
 ;
 
 
 /*--3. Enroll every student in the Comp. Sci. department in the above section. */
 INSERT INTO takes
 SELECT ID, 'CS-900', 2, 'Fall', 2022, null
 FROM student
 WHERE dept_name = 'Comp. Sci.'
 ;
 
 /*--4. Delete enrollments in the above section where the student’s ID is 12345 */
  DELETE
  FROM takes
  WHERE ID = 12345
  AND  course_id= 'CS-900'
  AND  sec_id = 2
  AND  semester = 'Fall'
  AND  year = 2022
;