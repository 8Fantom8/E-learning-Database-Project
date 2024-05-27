/*
1.User Registration
When registering a new user, an ID, user's personal information, username (generated using first and last names), 
and the hash of the password are added as a new row to the User table. Here we took the Hashed password of NewPassword.1.
*/

CREATE OR REPLACE FUNCTION InsertUser(
    first_name VARCHAR,
    middle_name VARCHAR,
    last_name VARCHAR,
    dob DATE,
    "role" UserRole,
    username VARCHAR,
    password_hash TEXT,
    reg_date DATE DEFAULT CURRENT_DATE,
    last_access TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO "User" (
        FirstName, MiddleName, LastName, DOB, "Role", Username, PasswordHash, RegDate, LastAccess
    )
    VALUES (
        first_name, middle_name, last_name, dob, "role", username, password_hash, reg_date, last_access
    );
END;
$$ LANGUAGE plpgsql;

SELECT InsertUser(
    'John',
    'Anthony',
    'Doe',
    '1990-01-01',
    'student',
    'johndoe',
    'f11521b11a12defabdd737c7bd1d350ae998978330df31d4ed2831da8f9a4e12'
);

SELECT * FROM "User" ORDER BY "ID" DESC LIMIT 1;

/*
2.User Account Management
An administrator will manage user accounts by creating new users, assigning roles, and setting permissions. 
They can deactivate accounts, which triggers updates in the Users entity to reflect the change in status and 
propagates changes to related entities like Enrollments and Messages to maintain data consistency.
*/

-- 1. Assigning or Changing a User Role

CREATE OR REPLACE FUNCTION UpdateUserRole(student_id INT,
										  new_role UserRole)
RETURNS VOID AS $$
BEGIN
    UPDATE "User"
    SET "Role" = new_role
    WHERE "ID" = student_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM "User" WHERE "ID" = 16;

SELECT UpdateUserRole(16, 'administrator');

SELECT * FROM "User" WHERE "ID" = 16;

SELECT UpdateUserRole(16, 'student');

SELECT * FROM "User" WHERE "ID" = 16;

-- 2. Deactivate a User Account

CREATE OR REPLACE FUNCTION DeactivateUser(student_id INT)
RETURNS VOID AS $$
BEGIN
    UPDATE "User"
    SET Active = False
    WHERE "ID" = student_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM "User" WHERE "ID" = 16;

SELECT DeactivateUser(16);

SELECT * FROM "User" WHERE "ID" = 16;

-- 3. Activate a User Account

CREATE OR REPLACE FUNCTION ActivateUser(student_id INT)
RETURNS VOID AS $$
BEGIN
    UPDATE "User"
    SET Active = True
    WHERE "ID" = student_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM "User" WHERE "ID" = 16;

SELECT ActivateUser(16);

SELECT * FROM "User" WHERE "ID" = 16;

-- 4. Deleting a User Account

CREATE OR REPLACE FUNCTION DeleteUser(student_id INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM "User"
    WHERE "ID" = student_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM "User" WHERE "ID" = 101;

SELECT DeleteUser(101);

SELECT * FROM "User" WHERE "ID" = 101;


/*
3.Enrolled Courses
To obtain the list of courses a student is currently enrolled in, we need to use the users,
courses, and their connecting table. Filtering will be required to ensure courses from previous 
semesters are not included in the result.
*/

CREATE OR REPLACE FUNCTION GetEnrolledCourses(student_id INTEGER,
											  chosen_semester AcademicSemester DEFAULT NULL,
											  chosen_year INTEGER DEFAULT NULL)
RETURNS TABLE(
    UserID INTEGER,
    CourseID INTEGER,
    CourseCode VARCHAR,
    CourseSection VARCHAR,
    Semester AcademicSemester,
    CourseYear INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        u."ID" AS UserID,
        c."ID" AS CourseID,
        c.Code AS CourseCode,
        c."Section" AS CourseSection,
        c.Semester AS Semester,
        c."Year" AS CourseYear
    FROM "User" u
    JOIN Enrollment e
		ON u."ID" = e.UserID
    JOIN Course c
		ON e.CourseID = c."ID"
    WHERE u."ID" = student_id
		AND (chosen_semester IS NULL OR c.Semester = chosen_semester)
		AND (chosen_year IS NULL OR c."Year" = chosen_year);
END;
$$ LANGUAGE plpgsql;

SELECT * FROM GetEnrolledCourses(16);

SELECT * FROM GetEnrolledCourses(16, 'Fall');

SELECT * FROM GetEnrolledCourses(16, NULL, 2016);

SELECT * FROM GetEnrolledCourses(16, 'Fall', 2016);


/*
4.Student Timetable
For timetable generation, we need to get the courses a student is enrolled in (as described earlier) 
and then join it with the timeslots table through their connecting table. This method can also be implemented 
in the course registration process, in order to disallow registering for multiple courses that take place at the same time.
*/

CREATE OR REPLACE FUNCTION GetStudentTimetable(student_id INTEGER,
											  chosen_semester AcademicSemester,
											  chosen_year INTEGER)
RETURNS TABLE(
    UserID INTEGER,
    CourseID INTEGER,
    CourseCode VARCHAR,
    CourseSection VARCHAR,
    Semester AcademicSemester,
    CourseYear INTEGER,
    WeekDay INTEGER,
    StartTime TIME,
    EndTime TIME
) AS $$
BEGIN
    RETURN QUERY
    SELECT
		u."ID" AS UserID,
		c."ID" AS CourseID,
		c.Code AS CourseCode,
		c."Section",
		c.Semester,
		c."Year" AS CourseYear,
		t.weekdaynumber,
		t.StartTime,
		t.EndTime
	FROM "User" u
	JOIN Enrollment e
		ON u."ID" = e.UserID
	JOIN Course c
		ON e.CourseID = c."ID"
	JOIN CourseSchedule cs
		ON c."ID" = cs.CourseID
	JOIN TimeSlot t
		ON cs.TimeSlotID = t."ID"
	WHERE u."ID" = student_id
		AND (chosen_semester IS NULL OR c.Semester = chosen_semester)
		AND (chosen_year IS NULL OR c."Year" = chosen_year)
		ORDER BY t.WeekdayNumber, t.StartTime;
END;
$$ LANGUAGE plpgsql;
	
SELECT * FROM GetStudentTimetable(16, 'Fall', 2016);

SELECT * FROM GetStudentTimetable(16, 'Spring', 2016);

/*
Use in Course Registration:
For course registration, you can modify this query to check for potential conflicts
before a student registers for a new course. This involves comparing the new course's timeslot 
with the timeslots of courses the student is already enrolled in. Here's an example of how you might
check for a scheduling conflict:
*/

CREATE OR REPLACE FUNCTION CheckEnrollment(
    student_id INT, 
    timeslot_id INT, 
    chosen_year INT, 
    chosen_semester AcademicSemester
)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS(
        SELECT 1
        FROM Enrollment e
        JOIN Course c
			ON e.CourseID = c."ID"
        JOIN CourseSchedule cs
			ON c."ID" = cs.CourseID
        JOIN TimeSlot t
			ON cs.TimeSlotID = t."ID"
        WHERE e.UserID = student_id
            AND t."ID" = timeslot_id
            AND (chosen_semester IS NULL OR c.Semester = chosen_semester)
            AND (chosen_year IS NULL OR c."Year" = chosen_year)
    );
END;
$$ LANGUAGE plpgsql;

SELECT CheckEnrollment(16, 1, 2016, 'Spring');

SELECT CheckEnrollment(16, 30, 2016, 'Winter');

/*
This query will return TRUE if there is a scheduling conflict 
(i.e., the student is already enrolled in a course that takes place at the same
time as the new course), and FALSE otherwise. However, this does not account for
overlapping time slots.
*/


/*
5.Course Page
To construct the course page information, we’ll need to filter the sections 
belonging to a certain course and subsequently join with section items.e time.
*/

CREATE OR REPLACE FUNCTION GetCoursePageInfo(
    chosen_course_id INT,
    chosen_section VARCHAR,
    chosen_year INT,
    chosen_semester AcademicSemester
)
RETURNS TABLE(
    SectionID INT,
    SectionTitle VARCHAR,
    SectionDescription TEXT,
    SectionOrder INT,
    ItemID INT,
    ItemTitle VARCHAR,
    ItemOrder INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT
        ps."ID" AS SectionID,
        ps.Title AS SectionTitle,
        ps.Description AS SectionDescription,
        ps.OrderNumber AS SectionOrder,
        si."ID" AS ItemID,
        si.Title AS ItemTitle,
        si.OrderNumber AS ItemOrder
    FROM Course c
    JOIN PageSection ps
		ON c."ID" = ps.CourseID
    JOIN SectionItem si
		ON ps."ID" = si.PageSectionID
    WHERE c."ID" = chosen_course_id
      AND c."Section" = chosen_section
      AND c."Year" = chosen_year
      AND c.Semester = chosen_semester
    ORDER BY ps.OrderNumber, si.OrderNumber;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM GetCoursePageInfo(1, 'A', 2016, 'Winter');

SELECT * FROM GetCoursePageInfo(2, 'A', 2016, 'Spring');


/*
6.Assignment Submission 
To submit an assignment, a student must select a specific course they are enrolled in, 
choose the relevant assignment, and upload their submission file. The system will add 
a new row to the Submission table with a link to the SubmissionFile entity, and update 
the student's progress in the Progress entity.
*/


CREATE OR REPLACE FUNCTION submit_assignment(
    p_student_id INTEGER,
    p_assignment_id INTEGER,
    p_course_id INTEGER,
    p_file_path TEXT,
    p_submission_text TEXT,
    p_is_file BOOLEAN,
    p_is_text BOOLEAN,
    p_is_quiz BOOLEAN
) RETURNS BOOLEAN AS $$
DECLARE
    v_enrolled BOOLEAN;
BEGIN
    -- Validate Student Enrollment
    SELECT EXISTS (
        SELECT 1
        FROM Enrollment
        WHERE UserID = p_student_id AND CourseID = p_course_id
    ) INTO v_enrolled;

    -- If not enrolled, return false
    IF NOT v_enrolled THEN
        RETURN FALSE;
    END IF;

    -- Create a Submission Record
    INSERT INTO Submission (StudentID, AssignmentID, SubmittedAt)
    VALUES (p_student_id, p_assignment_id, CURRENT_TIMESTAMP);

    -- Handling different types of submissions
    IF p_is_file THEN
        -- Insert the file record
        INSERT INTO "File" (Filepath, DateAdded)
        VALUES (p_file_path, CURRENT_TIMESTAMP);
        
        -- Link the file to the submission
--         INSERT INTO FileUploadSubmission ("ID", FileID)
--         VALUES (currval('submission_ID_seq'), currval('file_id_seq'));
    ELSIF p_is_text THEN
        -- Insert the text submission
		UPDATE TextSubmission SET "Text" = p_submission_text WHERE studentid = p_student_id;
    ELSIF p_is_quiz THEN
        -- Quiz handling can be implemented here
        RAISE NOTICE 'Quiz submissions should be handled with detailed logic for questions and answers.';
    END IF;

    -- Optionally update student progress (not conditional in this implementation)
--     INSERT INTO StudentProgress (StudentID, SectionItemID)
--     VALUES (p_student_id, p_assignment_id)
--     ON CONFLICT (StudentID, SectionItemID) DO NOTHING;

    -- Return true on successful submission
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
---------------
--Test
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM Course WHERE Code = 'DB101' AND "Section" = 'A' AND Semester = 'Fall' AND "Year" = 2024) THEN
    INSERT INTO Course (Code, "Section", Semester, "Year", IsGraded)
    VALUES ('DB101', 'A', 'Fall', 2024, TRUE);
  END IF;
END $$;

Select * from course;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM PageSection WHERE CourseID = (SELECT "ID" FROM Course WHERE Code = 'DB101' AND "Section" = 'A' AND Semester = 'Fall' AND "Year" = 2024) AND Title = 'Module 1: Introduction') THEN
    INSERT INTO PageSection (CourseID, Title, Description, OrderNumber)
    VALUES ((SELECT "ID" FROM Course WHERE Code = 'DB101' AND "Section" = 'A' AND Semester = 'Fall' AND "Year" = 2024), 'Module 1: Introduction', 'Introduction to Database Systems.', 1);
  END IF;
END $$;

Select * from PageSection;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM SectionItem WHERE PageSectionID = (SELECT "ID" FROM PageSection WHERE Title = 'Module 1: Introduction') AND Title = 'Assignment 1: SQL Basics') THEN
    INSERT INTO SectionItem (PageSectionID, Title, OrderNumber)
    VALUES ((SELECT "ID" FROM PageSection WHERE Title = 'Module 1: Introduction'), 'Assignment 1: SQL Basics', 1);
  END IF;
END $$;

Select * from SectionItem ORDER BY "ID" DESC LIMIT 1;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM AssignmentGroup WHERE CourseID = (SELECT "ID" FROM Course WHERE Code = 'DB101' AND "Section" = 'A' AND Semester = 'Fall' AND "Year" = 2024) AND Title = 'SQL Assignments') THEN
    INSERT INTO AssignmentGroup (CourseID, Title, DropLowestN, PercentOfGrade)
    VALUES ((SELECT "ID" FROM Course WHERE Code = 'DB101' AND "Section" = 'A' AND Semester = 'Fall' AND "Year" = 2024), 'SQL Assignments', 0, 20.0);
  END IF;
END $$;

Select * from AssignmentGroup;

-- Insert an Assignment making sure to include all necessary inherited fields
INSERT INTO "Assignment" ("ID", AssignmentGroupID, CreatedAt, OpenedAt, DueAt, LateSubmissionAllowed, Body, Title, OrderNumber, PageSectionID)
SELECT si."ID", ag."ID", CURRENT_TIMESTAMP, '2024-05-01 08:00:00', '2024-05-15 23:59:00', TRUE, 'Create and manipulate database entries using SQL.', si.Title, si.OrderNumber, si.PageSectionID
FROM SectionItem si
JOIN AssignmentGroup ag ON ag.CourseID = (SELECT "ID" FROM Course WHERE Code = 'DB101')
WHERE si.Title = 'Assignment 1: SQL Basics' AND ag.Title = 'SQL Assignments';
Select * from "Assignment" where pagesectionid = 90;



INSERT INTO "Assignment" ("ID", AssignmentGroupID, CreatedAt, OpenedAt, DueAt, LateSubmissionAllowed, Body)
VALUES ((SELECT "ID" FROM SectionItem WHERE Title = 'Assignment 1: SQL Basics'),(SELECT "ID" FROM AssignmentGroup WHERE courseid = 51), CURRENT_TIMESTAMP, '2024-05-01 08:00:00', '2024-05-15 23:59:00', TRUE, 'Create and manipulate database entries using SQL.');
(SELECT courseid FROM pagesection WHERE "ID" = 90),(SELECT title FROM pagesection WHERE "ID" = 90),(SELECT description FROM pagesection WHERE "ID" = 90),
Select * from "Assignment" where pagesectionid = 90;


-- Insert enrollment record only if the student is not already enrolled
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Enrollment
        WHERE UserID = 100 AND CourseID = 51
    ) THEN
        INSERT INTO Enrollment (UserID, CourseID, EnrolledAt)
        VALUES (100, 51, CURRENT_TIMESTAMP);
    END IF;
END $$;
select * from Enrollment


/*
Steps for Assignment Submission:
1.Validate Student Enrollment: Confirm that the student is enrolled in the course for which they 
are trying to submit an assignment.
2.Create a Submission Record: Insert a record into the Submission table to record the fact that
the student has submitted the assignment.
3.If assignment Fileupload 
       --Link Submission to File: Store the submitted file and create a record in the File table, then
link this file to the submission using the SubmissionFile table.
If assignment Text
       --insert the submission into text submission 
If quiz 
       --insert the answers from the quiz type of assignments to the quiz answer and quiz submission tables
4.Update Student Progress: Optionally, update or create a record in the StudentProgress table
to reflect that the student has completed this part of the course.
*/

-- Example parameters: student_id = 101, assignment_id = 267, course_id = 51, txt = '/files/example.pdf', submission_text = 'My essay', is_file = TRUE, is_text = FALSE, is_quiz = FALSE
SELECT submit_assignment(101, 267, 51, 'files/example.pdf', 'My essay', FAlSE, TRUE, FALSE);
-- Example parameters: student_id = 101, assignment_id = 267, course_id = 51, file_path = 'Desktop/Databases/DS 205C Project - Phase One.pdf', submission_text = 'My essay', is_file = TRUE, is_text = FALSE, is_quiz = FALSE
SELECT submit_assignment(101, 267, 51, 'Desktop/Databases/DS 205C Project - Phase One.pdf', 'Project requirments, Phase one', TRUE, FALSE, FALSE);


/*
7.Retrieve Students per Class

To obtain a list of students enrolled in a specific course and section, we'll perform several inner joins.
*/

CREATE OR REPLACE FUNCTION GetStudentsPerClass(course_id INT,
											   chosen_section VARCHAR)
RETURNS TABLE (
    StudentID INT,
    FirstName VARCHAR(50),
    MiddleName VARCHAR(50),
    LastName VARCHAR(50)
) AS $$
BEGIN
    RETURN QUERY
    SELECT
		u."ID" AS StudentID,
		u.FirstName,
		u.MiddleName,
		u.LastName
    FROM "User" u
    JOIN Enrollment e
		ON u."ID" = e.UserID
    JOIN Course c
		ON e.CourseID = c."ID"
    WHERE c."ID" = course_id
      AND c."Section" = chosen_section;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM GetStudentsPerClass(1, 'A');


/*
8.Submission Comments
When a user posts a new comment to a submission, the system will insert a new row into the Comments table, linking
the comment to the specific submission through the appropriate relational entity. The system should record the timestamp
and the ID of the user posting the comment.
*/

CREATE OR REPLACE FUNCTION PostComment(
    user_id INTEGER,
    submission_id INTEGER,
    comment_text TEXT
)
RETURNS VOID AS $$
DECLARE
    user_role VARCHAR;
    submission_course_id INTEGER;
    submission_user_id INTEGER;
BEGIN
    -- Get the role of the user
    SELECT "Role" INTO user_role FROM "User" WHERE "ID" = user_id;

    -- Get the course ID of the submission
    SELECT DISTINCT CourseID, StudentID
	INTO submission_course_id, submission_user_id
	FROM Submission s
	JOIN "Assignment" a
		ON s.assignmentid = a."ID"
	JOIN PageSection ps
		ON a.pagesectionid = ps."ID"
	WHERE s."ID" = submission_id;
	

    -- Check if the user is an instructor for the course or the student who submitted the submission
    IF user_role = 'instructor' AND user_id IN (SELECT DISTINCT UserID FROM CourseInstructors WHERE CourseID = submission_course_id) THEN
        -- Allow instructors to post comments
        INSERT INTO "Comment" (SubmissionID, SentBy, SentAt, "Text")
        VALUES (submission_id, user_id, NOW(), comment_text);
    ELSIF user_role = 'student' AND submission_user_id = user_id THEN
        -- Allow the student who submitted the submission to post comments
        INSERT INTO "Comment" (SubmissionID, SentBy, SentAt, "Text")
        VALUES (submission_id, user_id, NOW(), comment_text);
    ELSE
        -- Throw an exception for unauthorized users
        RAISE EXCEPTION 'Unauthorized: Only instructors or the submitting student can post comments';
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT PostComment(87, 1, 'This is a great point and really adds to our understanding of the topic.');

SELECT * FROM "Comment" ORDER BY "ID" DESC LIMIT 1;

SELECT PostComment(5, 1, 'This is a great point and really adds to our understanding of the topic.');


/*
9.Quiz Questions
When a user wants to take a quiz, the quiz questions should be loaded. When grading a quiz, the answers should be loaded.
*/

CREATE OR REPLACE FUNCTION GetQuizQuestions(
    quiz_id INTEGER,
	retrurn_correct_answer BOOL
)
RETURNS TABLE (
    QuestionID INT,
    Question TEXT,
    AnswerID INT,
    Answer TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
    qq."ID", qq.Question, qa."ID", qa.Answer
    FROM QuizAnswer qa
    JOIN QuizQuestion qq
        ON qa.QuestionID = qq."ID"
	WHERE qa.QuizID = quizid
    ORDER BY qq."ID", qa."ID";
END;
$$ LANGUAGE plpgsql;

SELECT * FROM GetQuizQuestions(8);

/*
To check the quizzes, we'll also need to know which answer options are correct.
*/

CREATE OR REPLACE FUNCTION GetQuizQuestionsAndCorrectAnswers(
    quiz_id INTEGER,
	retrurn_correct_answer BOOL
)
RETURNS TABLE (
    QuestionID INT,
    Question TEXT,
    AnswerID INT,
    Answer TEXT,
	IsCorrect BOOL
) AS $$
BEGIN
    RETURN QUERY
    SELECT
    qq."ID", qq.Question, qa."ID", qa.Answer, qa.IsCorrect
    FROM QuizAnswer qa
    JOIN QuizQuestion qq
        ON qa.QuestionID = qq."ID"
	WHERE qa.QuizID = quizid
    ORDER BY qq."ID", qa."ID";
END;
$$ LANGUAGE plpgsql;

SELECT * FROM GetQuizQuestionsAndCorrectAnswers(3);

/*
To calculate the quiz score of a student, we need to compare their answers to the correct answers.
*/

CREATE OR REPLACE FUNCTION CalculateCorrectAnswers(
    submission_id INTEGER
)
RETURNS INTEGER AS $$
DECLARE
    correct_count INTEGER := 0;
BEGIN
    SELECT COUNT(*)
    INTO correct_count
    FROM QuizSubmission qs
    JOIN QuizAnswer qa
        ON qs.QuestionID = qa.QuestionID
        AND qs.AnswerID = qa."ID"
    WHERE qs."ID" = submission_id
    AND qa.IsCorrect = TRUE;

    RETURN correct_count;
END;
$$ LANGUAGE plpgsql;

/*
10.Student Progress Checker
All the section items marked done for a specific semester are returned.
*/

CREATE OR REPLACE FUNCTION GetCompletedSectionItems(
    student_id INTEGER,
    chosen_semester AcademicSemester,
    chosen_year INTEGER
)
RETURNS TABLE (
    SectionItemID INTEGER,
    SectionItemName VARCHAR(100)
) AS $$
BEGIN
    RETURN QUERY
    SELECT sp.SectionItemID, si.Title
    FROM StudentProgress sp
    JOIN SectionItem si ON sp.SectionItemID = si."ID"
    JOIN PageSection ps ON si.PageSectionID = ps."ID"
    JOIN Course c ON ps.CourseID = c."ID"
    WHERE sp.StudentID = student_id
    AND c.Semester = chosen_semester
    AND c."Year" = chosen_year;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM GetCompletedSectionItems(1, 'Spring', 2016);

