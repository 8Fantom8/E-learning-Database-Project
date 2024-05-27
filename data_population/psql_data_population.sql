\copy "User" (FirstName, MiddleName, LastName, DOB, "Role", Username, PasswordHash, RegDate, LastAccess) FROM 'data/users.csv' WITH (FORMAT csv, HEADER true);

\copy Course (Code, "Section", Semester, "Year", IsGraded) FROM 'data/courses.csv' WITH (FORMAT csv, HEADER true);

\copy TimeSlot (WeekdayNumber, StartTime, EndTime) FROM 'data/time_slots.csv' WITH (FORMAT csv, HEADER true);

\copy CourseSchedule (CourseID, TimeSlotID) FROM 'data/course_schedules.csv' WITH (FORMAT csv, HEADER true);

\copy Enrollment (UserID, CourseID, EnrolledAt) FROM 'data/enrollments.csv' WITH (FORMAT csv, HEADER true);

\copy CourseInstructors (UserID, CourseID, "InstructorRole") FROM 'data/course_instructors.csv' WITH (FORMAT csv, HEADER true);

\copy PageSection (CourseID, Title, Description, OrderNumber) FROM 'data/page_sections.csv' WITH (FORMAT csv, HEADER true);

\copy AssignmentGroup (CourseID, Title, DropLowestN, PercentOfGrade) FROM 'data/assignment_groups.csv' WITH (FORMAT csv, HEADER true);

\copy "File" (Filepath, DateAdded) FROM 'data/files.csv' WITH (FORMAT csv, HEADER true);

\copy SectionItem (PageSectionID, Title, OrderNumber) FROM 'data/section_items.csv' WITH (FORMAT csv, HEADER true);

\copy "Assignment" ("ID", PageSectionID, Title, OrderNumber, AssignmentGroupID, CreatedAt, OpenedAt, DueAt, LateSubmissionAllowed, Body) FROM 'data/assignments.csv' WITH (FORMAT csv, HEADER true);

\copy AssignmentQuiz ("ID", PageSectionID, Title, OrderNumber, AssignmentGroupID, CreatedAt, OpenedAt, DueAt, LateSubmissionAllowed, Body, NumberOfQuestions, ShuffleAnswers, ShuffleQuestions, TimeLimit) FROM 'data/assignment_quizzes.csv' WITH (FORMAT csv, HEADER true);

\copy AssignmentFileUpload ("ID", PageSectionID, Title, OrderNumber, AssignmentGroupID, CreatedAt, OpenedAt, DueAt, LateSubmissionAllowed, Body, MaxFilesAllowed) FROM 'data/assignment_file_uploads.csv' WITH (FORMAT csv, HEADER true);

\copy AssignmentText ("ID", PageSectionID, Title, OrderNumber, AssignmentGroupID, CreatedAt, OpenedAt, DueAt, LateSubmissionAllowed, Body, MaxTextLength) FROM 'data/assignment_texts.csv' WITH (FORMAT csv, HEADER true);

\copy AssignmentFile (AssignmentID, FileID) FROM 'data/assignment_files.csv' WITH (FORMAT csv, HEADER true);

\copy QuizQuestion (QuizID, Question, FileID, OrderNumber) FROM 'data/quiz_questions.csv' WITH (FORMAT csv, HEADER true);

\copy QuizAnswer (QuizID, QuestionID, Answer, FileID, OrderNumber, IsCorrect) FROM 'data/quiz_answers.csv' WITH (FORMAT csv, HEADER true);

\copy Submission (StudentID, AssignmentID, SubmittedAt) FROM 'data/submissions.csv' WITH (FORMAT csv, HEADER true);

\copy QuizSubmission ("ID", StudentID, AssignmentID, SubmittedAt, QuestionID, AnswerID, ClickedAt) FROM 'data/quiz_submissions.csv' WITH (FORMAT csv, HEADER true);

\copy FileUploadSubmission ("ID", StudentID, AssignmentID, SubmittedAt, FileID) FROM 'data/file_upload_submissions.csv' WITH (FORMAT csv, HEADER true);

\copy TextSubmission ("ID", StudentID, AssignmentID, SubmittedAt, "Text") FROM 'data/text_submissions.csv' WITH (FORMAT csv, HEADER true);

\copy FileType (FileType) FROM 'data/file_types.csv' WITH (FORMAT csv, HEADER true);

\copy AllowedTypesUpload (AssignmentID, FileTypeID) FROM 'data/allowed_types_uploads.csv' WITH (FORMAT csv, HEADER true);

\copy StudentProgress (StudentID, SectionItemID) FROM 'data/student_progress.csv' WITH (FORMAT csv, HEADER true);

\copy Email (CourseID, SentBy, SentAt, Subject, Body) FROM 'data/emails.csv' WITH (FORMAT csv, HEADER true);

\copy EmailReceivers (EmailID, ReceivedBy) FROM 'data/email_receivers.csv' WITH (FORMAT csv, HEADER true);

\copy EmailFiles (EmailID, FileID) FROM 'data/email_files.csv' WITH (FORMAT csv, HEADER true);

\copy Feedback (InstructorID, SubmissionID, "Text", Grade, GivenAt) FROM 'data/feedbacks.csv' WITH (FORMAT csv, HEADER true);

\copy "Comment" (SubmissionID, SentBy, SentAt, "Text") FROM 'data/comments.csv' WITH (FORMAT csv, HEADER true);

\copy PageFile ("ID", PageSectionID, Title, OrderNumber, FileID) FROM 'data/page_files.csv' WITH (FORMAT csv, HEADER true);

\copy "Link" ("ID", PageSectionID, Title, OrderNumber, URL) FROM 'data/links.csv' WITH (FORMAT csv, HEADER true);
