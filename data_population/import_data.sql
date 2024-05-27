-- Copy data for Users
COPY "User" (FirstName, MiddleName, LastName, DOB, "Role", Username, PasswordHash, RegDate, LastAccess)
FROM '/data/users.csv'
WITH (FORMAT csv, HEADER true);

-- Copy data for Courses
COPY Course (Code, "Section", Semester, "Year", IsGraded)
FROM '/data/courses.csv'
WITH (FORMAT csv, HEADER true);

-- Copy data for Time Slots
COPY TimeSlot (WeekdayNumber, StartTime, EndTime)
FROM '/data/time_slots.csv'
WITH (FORMAT csv, HEADER true);

COPY CourseSchedule (CourseID, TimeSlotID)
FROM '/data/course_schedules.csv'
WITH (FORMAT csv, HEADER true);

COPY Enrollment (UserID, CourseID, EnrolledAt)
FROM '/data/enrollments.csv'
WITH (FORMAT csv, HEADER true);

COPY CourseInstructors (UserID, CourseID, "InstructorRole")
FROM '/data/course_instructors.csv'
WITH (FORMAT csv, HEADER true);

-- Load Page Sections data
COPY PageSection (CourseID, Title, Description, OrderNumber)
FROM '/data/page_sections.csv'
WITH (FORMAT csv, HEADER true);

-- Load Assignment Groups data
COPY AssignmentGroup (CourseID, Title, DropLowestN, PercentOfGrade)
FROM '/data/assignment_groups.csv'
WITH (FORMAT csv, HEADER true);

COPY "File" (Filepath, DateAdded)
FROM '/data/files.csv'
WITH (FORMAT csv, HEADER true);

-- Load Section Items data
COPY SectionItem (PageSectionID, Title, OrderNumber)
FROM '/data/section_items.csv'
WITH (FORMAT csv, HEADER true);

COPY "Assignment" ("ID", PageSectionID, Title, OrderNumber, AssignmentGroupID, CreatedAt, OpenedAt, DueAt, LateSubmissionAllowed, Body)
FROM '/data/assignments.csv'
WITH (FORMAT csv, HEADER true);

COPY AssignmentQuiz ("ID", PageSectionID, Title, OrderNumber, AssignmentGroupID, CreatedAt, OpenedAt, DueAt, LateSubmissionAllowed, Body, 
    NumberOfQuestions, ShuffleAnswers, ShuffleQuestions, TimeLimit)
FROM '/data/assignment_quizzes.csv'
WITH (FORMAT csv, HEADER true);

COPY AssignmentFileUpload ("ID", PageSectionID, Title, OrderNumber, AssignmentGroupID, CreatedAt, OpenedAt, DueAt, LateSubmissionAllowed, Body, MaxFilesAllowed)
FROM '/data/assignment_file_uploads.csv'
WITH (FORMAT csv, HEADER true);

COPY AssignmentText ("ID", PageSectionID, Title, OrderNumber, AssignmentGroupID, CreatedAt, OpenedAt, DueAt, LateSubmissionAllowed, Body, MaxTextLength)
FROM '/data/assignment_texts.csv'
WITH (FORMAT csv, HEADER true);


COPY AssignmentFile (AssignmentID, FileID)
FROM '/data/assignment_files.csv'
WITH (FORMAT csv, HEADER true);

COPY QuizQuestion (QuizID, Question, FileID, OrderNumber)
FROM '/data/quiz_questions.csv'
WITH (FORMAT csv, HEADER true);

COPY QuizAnswer (QuizID, QuestionID, Answer, FileID, OrderNumber, IsCorrect)
FROM '/data/quiz_answers.csv'
WITH (FORMAT csv, HEADER true);


-- Submissions
COPY Submission (StudentID, AssignmentID, SubmittedAt)
FROM '/data/submissions.csv'
WITH (FORMAT csv, HEADER true);

COPY QuizSubmission ("ID", StudentID, AssignmentID, SubmittedAt, QuestionID, AnswerID, ClickedAt)
FROM '/data/quiz_submissions.csv'
WITH (FORMAT csv, HEADER true);

COPY FileUploadSubmission ("ID", StudentID, AssignmentID, SubmittedAt, FileID)
FROM '/data/file_upload_submissions.csv'
WITH (FORMAT csv, HEADER true);

COPY TextSubmission ("ID", StudentID, AssignmentID, SubmittedAt, "Text")
FROM '/data/text_submissions.csv'
WITH (FORMAT csv, HEADER true);


COPY FileType (FileType)
FROM '/data/file_types.csv'
WITH (FORMAT csv, HEADER true);

COPY AllowedTypesUpload (AssignmentID, FileTypeID)
FROM '/data/allowed_types_uploads.csv'
WITH (FORMAT csv, HEADER true);

COPY StudentProgress (StudentID, SectionItemID)
FROM '/data/student_progress.csv'
WITH (FORMAT csv, HEADER true);



COPY Email (CourseID, SentBy, SentAt, Subject, Body)
FROM '/data/emails.csv'
WITH (FORMAT csv, HEADER true);

COPY EmailReceivers (EmailID, ReceivedBy)
FROM '/data/email_receivers.csv'
WITH (FORMAT csv, HEADER true);

COPY EmailFiles (EmailID, FileID)
FROM '/data/email_files.csv'
WITH (FORMAT csv, HEADER true);

COPY Feedback (InstructorID, SubmissionID, "Text", Grade, GivenAt)
FROM '/data/feedbacks.csv'
WITH (FORMAT csv, HEADER true);

COPY "Comment" (SubmissionID, SentBy, SentAt, "Text")
FROM '/data/comments.csv'
WITH (FORMAT csv, HEADER true);

COPY PageFile ("ID", PageSectionID, Title, OrderNumber, FileID)
FROM '/data/page_files.csv'
WITH (FORMAT csv, HEADER true);

COPY "Link" ("ID", PageSectionID, Title, OrderNumber, URL)
FROM '/data/links.csv'
WITH (FORMAT csv, HEADER true);