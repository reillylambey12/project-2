CREATE TABLE Feeder (
  feeder_id INT PRIMARY KEY,
  school_name VARCHAR(100) NOT NULL,
  management TEXT NOT NULL,
  urban_rural TEXT NOT NULL,
  municipality TEXT ,
  funding VARCHAR(100)NOT NULL,
  district VARCHAR(100) NOT NULL
);

CREATE TABLE Programs(
  program_id  INT PRIMARY KEY,
  program_code VARCHAR(50) NOT NULL,
  program_name TEXT NOT NULL,
  degree_id TEXT NOT NULL,
  degree TEXT NOT NULL
);

CREATE TABLE Student_information(
  student_id INT  PRIMARY KEY,
  gender CHAR(1) NOT NULL,
  ethnicity TEXT NOT NULL,
  city TEXT ,
  district TEXT ,
  program_start VARCHAR(100) NOT NULL,
  program_status VARCHAR(100) NOT NULL,
  programEND DATE ,
  grade_date DATE ,
  feeder_id INT,
  FOREIGN KEY(feeder_id)
  REFERENCES Feeder(feeder_id)
); 

CREATE TABLE Courses (
  course_id INT PRIMARY KEY,
  course_code CHAR(50) NOT NULL,
  course_title TEXT NOT NULL,
  course_credits INT NOT NULL
);

CREATE TABLE Grades (
  grade_id INT PRIMARY KEY,
  Semester VARCHAR(50) NOT NULL,
  course_grade CHAR (2),
  course_points DECIMAL ,
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  FOREIGN KEY(student_id)
  REFERENCES Student_information(student_id),
  FOREIGN KEY (course_id)
    REFERENCES Courses (course_id)
);

CREATE TABLE Courses_Programs (
  co_pro INT PRIMARY KEY,
  program_id INT NOT NULL,
  course_id INT NOT NULL,
  FOREIGN KEY(program_id)
  REFERENCES Programs(program_id),
  FOREIGN KEY(course_id)
  REFERENCES Courses(course_id)
); 




  



COPY Feeder
FROM '/home/reilly117/Project-2/Feeder.csv'
DELIMITER ','
CSV HEADER;

COPY Programs
FROM '/home/reilly117/Project-2/Programs.csv'
DELIMITER ','
CSV HEADER;

COPY Student_information
FROM '/home/reilly117/Project-2/Student_information.csv'
DELIMITER ','
CSV HEADER; 


COPY Courses
FROM '/home/reilly117/Project-2/Courses.csv'
DELIMITER ','
CSV HEADER;

COPY Grades
FROM '/home/reilly117/Project-2/Grades.csv'
DELIMITER ','
CSV HEADER;

COPY Courses_Programs
FROM '/home/reilly117/Project-2/Courses_Programs.csv'
DELIMITER ','
CSV HEADER;

----Find the total number of students and average course points by feeder institutions.
 SELECT 
    Feeder.school_name AS feeder_institution, 
    COUNT(DISTINCT Student_information.student_id) AS total_students, 
    AVG(Grades.course_points) AS avg_course_points
FROM 
    Feeder
    JOIN Student_information ON Feeder.feeder_id = Student_information.feeder_id
    JOIN Grades ON Student_information.student_id = Grades.student_id
GROUP BY 
    Feeder.school_name;

-------Find the total number of students and average course points by gender.
SELECT 
    gender, 
    COUNT(DISTINCT Student_information.student_id) AS total_students, 
    AVG(course_points) AS avg_course_points
FROM 
    Student_information
    JOIN Grades ON Student_information.student_id = Grades.student_id
GROUP BY 
    gender;

    ---Find the total number of students and average course points by ethnicity.
SELECT 
    si.ethnicity,
    COUNT(DISTINCT si.student_id) AS total_students,
    AVG(g.course_points) AS avg_course_points
FROM 
    Student_information si
    JOIN Grades g ON si.student_id = g.student_id
GROUP BY 
    si.ethnicity;

    ---Find the total number of students and average course points by city.
SELECT 
    si.city, 
    COUNT(DISTINCT si.student_id) AS total_students, 
    AVG(g.course_points) AS avg_course_points
FROM 
    Student_information si
    INNER JOIN Grades g ON si.student_id = g.student_id
GROUP BY 
    si.city;
    
    ---Find the total number of students and average course points by district.
SELECT 
    f.district,
    COUNT(DISTINCT si.student_id) AS total_students,
    AVG(g.course_points) AS avg_course_points
FROM 
    Feeder f
    INNER JOIN Student_information si ON f.feeder_id = si.feeder_id
    INNER JOIN Grades g ON si.student_id = g.student_id
GROUP BY 
    f.district;

---Find the total number and percentage of students by program status.
SELECT 
  program_status, 
  COUNT(*) AS total_students, 
  (COUNT(*) / SUM(COUNT(*)) OVER()) * 100 AS percentage_of_students
FROM 
  Student_information
GROUP BY 
  program_status;

  -Find the letter grade breakdown (how many A, A-,B,B+,...)for each of the following courses:

--Fundamentals of Computing

--Principles of Programming I 

--Algebra 
SELECT g.course_grade, COUNT(g.course_grade) AS count 
FROM grades g
JOIN courses c ON g.course_id = c.course_id 
WHERE c.course_title = 'ALGEBRA' 
GROUP BY g.course_grade;
--Trigonometry 
SELECT g.course_grade, COUNT(g.course_grade) AS count 
FROM grades g
JOIN courses c ON g.course_id = c.course_id 
WHERE c.course_title = 'TRIGONOMETRY' 
GROUP BY g.course_grade;
--College English I 
SELECT g.course_grade, COUNT(g.course_grade) AS count 
FROM grades g
JOIN courses c ON g.course_id = c.course_id 
WHERE c.course_title = 'COLLEGE ENGLISH I' 
GROUP BY g.course_grade;