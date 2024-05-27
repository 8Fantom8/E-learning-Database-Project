import csv
import random
from datetime import timedelta, datetime

import numpy as np
from faker import Faker

# Initialize Faker and set a fixed seed
fake = Faker()
Faker.seed(42)
random.seed(42)

def create_user(role):
    return [
        fake.first_name(),
        fake.first_name() if random.choice([True, False]) else "",
        fake.last_name(),
        fake.date_of_birth(minimum_age=18, maximum_age=65).strftime('%Y-%m-%d %H:%M'),
        role,
        fake.user_name(),
        fake.sha256(raw_output=False),
        fake.date_this_decade().strftime('%Y-%m-%d %H:%M'),
        fake.date_time_this_month().strftime('%Y-%m-%d %H:%M')
    ]

def create_course():
    return [
        fake.bothify(text='??####'),
        random.choice(['A', 'B', 'C', 'D']),
        random.choice(['Fall', 'Winter', 'Spring', 'Summer']),
        random.randint(2015, 2023),
        fake.boolean()
    ]


def create_time_slot():
    earliest_start_hour = 9
    latest_start_hour = 17

    start_hour = random.randint(earliest_start_hour, latest_start_hour)
    start_minute = random.randint(0, 59)
    start_second = random.randint(0, 59)

    start_time = datetime.now().replace(hour=start_hour, minute=start_minute, second=start_second)

    duration_hours = random.randint(1, 3)
    end_time = start_time + timedelta(hours=duration_hours)

    return [
        random.randint(1, 7),
        start_time.strftime('%H:%M:%S'),
        end_time.strftime('%H:%M:%S')
    ]

def create_page_section(course_idx):
    return [
        course_idx + 1,  # Assuming course IDs start from 1
        fake.catch_phrase(),
        fake.paragraph(nb_sentences=3) if random.choice([True, False]) else "",
        random.randint(1, 10)  # Order number
    ]

def create_section_item(page_section_idx):
    return [
        page_section_idx + 1,  # Assuming page section IDs start from 1
        fake.catch_phrase(),
        random.randint(1, 10)  # Order number
    ]

def create_assignment_group(course_idx):
    return [
        course_idx + 1,  # Assuming course IDs start from 1
        fake.catch_phrase(),
        random.randint(0, 3),  # DropLowestN
        round(random.uniform(5, 30), 2)  # PercentOfGrade
    ]

def create_file():
    return [
        fake.file_path(depth=3, extension='pdf'),  # Generate a file path with a pdf extension
        fake.date_time_this_month().strftime('%Y-%m-%d %H:%M')  # Date added
    ]

def create_assignment(assignment_group_idx, section_item, si_idx):
    created_at = fake.date_time_this_year()
    opened_at = created_at + timedelta(days=random.randint(1, 5))
    due_at = opened_at + timedelta(days=random.randint(10, 30))
    created_at_str = created_at.strftime('%Y-%m-%d %H:%M')
    opened_at_str = opened_at.strftime('%Y-%m-%d %H:%M')
    due_at_str = due_at.strftime('%Y-%m-%d %H:%M')
    return [
        si_idx,
        section_item[0],
        section_item[1],
        section_item[2],
        assignment_group_idx + 1,  # Assuming AssignmentGroup IDs start from 1
        created_at_str,
        opened_at_str,
        due_at_str,
        fake.boolean(),
        fake.text(max_nb_chars=200).replace("\n", " ") if random.choice([True, False]) else ""
    ]

def create_assignment_file(assignment, file_idx):
    return [
        assignment[0],  # Assuming Assignment IDs start from 1
        file_idx + 1  # Assuming File IDs start from 1
    ]

def create_quiz_question(quiz_idx, file_option):
    return [
        quiz_idx,  # QuizID, assuming sequential IDs starting from 1
        fake.sentence(nb_words=10),  # Generate a quiz question
        random.choice(file_option) if random.choice([True, False]) else None,  # Optionally associate a file
        random.randint(1, 10)  # OrderNumber
    ]

def create_quiz_answer(quiz_idx, question_idx, file_option):
    return [
        quiz_idx,  # QuizID
        question_idx + 1,  # QuestionID
        fake.sentence(nb_words=6),  # Generate a quiz answer
        random.choice(file_option) if random.choice([True, False]) else None,  # Optionally associate a file
        random.randint(1, 5),  # OrderNumber
        random.choice([True, False])  # Randomly decide if this is the correct answer
    ]

def create_submission(student_id, assignment_id):
    return [
        student_id + 1,  # Assuming student IDs start from 1
        assignment[0],  # Assuming assignment IDs start from 1
        fake.date_time_between(start_date='-1y', end_date='now').strftime('%Y-%m-%d %H:%M')  # Timestamp of submission
    ]

def create_quiz_submission(question_id, answer_ids):
    return [
        question_id + 1,  # QuestionID
        random.choice(answer_ids) if answer_ids else None,  # AnswerID, randomly chosen
        fake.date_time_between(start_date='-1y', end_date='now').strftime('%Y-%m-%d %H:%M')  # ClickedAt
    ]

def create_file_upload_submission(file_ids):
    return [
        random.choice(file_ids) + 1  # FileID
    ]

def create_text_submission(max_length):
    return [
        fake.text(max_nb_chars=max_length)  # Text content
    ]

def create_file_type():
    # Define common file types
    types = ['pdf', 'docx', 'txt', 'jpg', 'png']
    return random.choice(types)

def create_allowed_types_upload(assignment_file_upload_ids, file_type_ids):
    return [
        random.choice(assignment_file_upload_ids),  # AssignmentID from AssignmentFileUpload
        random.choice(file_type_ids)  # FileTypeID
    ]

def create_student_progress(student_ids, section_item_ids):
    return [
        random.choice(student_ids),  # StudentID
        random.choice(section_item_ids)  # SectionItemID
    ]

def create_email(user_ids, course_ids):
    return [
        random.choice(course_ids) if random.choice([True, False]) else None,  # CourseID may be null
        random.choice(user_ids),  # SentBy
        fake.date_time_this_year().strftime('%Y-%m-%d %H:%M'),  # SentAt
        fake.sentence(),  # Subject
        fake.paragraph() if random.choice([True, False]) else ""  # Body
    ]

def create_email_receiver(email_ids, user_ids):
    return [
        random.choice(email_ids),  # EmailID
        random.choice(user_ids)  # ReceivedBy
    ]

def create_email_file(email_ids, file_ids):
    return [
        random.choice(email_ids),  # EmailID
        random.choice(file_ids)  # FileID
    ]

def create_feedback(user_ids, submission_ids):
    return [
        random.choice([uid for uid in user_ids if users[uid - 1][4] == 'instructor']),  # InstructorID
        random.choice(submission_ids),  # SubmissionID
        fake.sentence(),  # Text
        round(random.uniform(50, 100), 2),  # Grade
        fake.date_time_this_year().strftime('%Y-%m-%d %H:%M')  # GivenAt
    ]

def create_comment(user_ids, submission_ids):
    return [
        random.choice(submission_ids),  # SubmissionID
        random.choice(user_ids),  # SentBy
        fake.date_time_this_year().strftime('%Y-%m-%d %H:%M'),  # SentAt
        fake.sentence()  # Text
    ]






# Generate users, courses, and timeslots
users = [create_user(random.choice(['instructor', 'student', 'administrator'])) for _ in range(100)]
courses = [create_course() for _ in range(50)]
time_slots = [create_time_slot() for _ in range(30)]

# Generate CourseSchedule
course_schedules = [
    [course_idx + 1, ts_idx + 1]  # Assuming serial IDs start from 1
    for course_idx in range(len(courses))
    for ts_idx in range(len(time_slots))
]


# Generate Enrollments
enrollments = [
    [user_idx + 1, course_idx + 1, fake.date_time_this_month().strftime('%Y-%m-%d %H:%M')]
    for user_idx, user in enumerate(users) if user[4] == 'student'  # User Role is 'student'
    for course_idx in random.sample(range(len(courses)), random.sample(range(4, 7), 1)[0])
]

# Generate CourseInstructors
course_instructors = [
    [user_idx + 1, course_idx + 1, random.choice(['Instructor', 'Teaching Assistant'])]
    for user_idx, user in enumerate(users) if user[4] == 'instructor'  # User Role is 'instructor'
    for course_idx in range(len(courses))
]

# Generate data for each new table
page_sections = [
    create_page_section(course_idx)
    for course_idx in range(len(courses))
    for _ in random.sample(range(len(courses)), random.randint(1, 3))  # Each course can have multiple sections
]

assignment_groups = [
    create_assignment_group(course_idx)
    for course_idx in range(len(courses))
    for _ in range(random.randint(1, 3))  # Each course can have multiple assignment groups
]

# Generate files
files = [create_file() for _ in range(100)]  # Adjust the number as needed

# Generate assignments
section_items = [
    create_section_item(ps_idx)
    for ps_idx in range(len(page_sections))
    for _ in range(random.randint(1, 5))  # Each page section can have multiple items
]

section_items_types = np.random.choice(['assignment', 'page_file', 'link'], len(section_items))

assignments = []
page_files = []
links = []

for i, (section_item, section_items_type) in enumerate(zip(section_items, section_items_types), 1):
    if section_items_type == "assignment":
        ag_idx = np.random.choice(range(len(assignment_groups)))
        assignments.append(create_assignment(ag_idx, section_item, i))

    elif section_items_type == "page_file":
        page_files.append([i] + section_item + [random.choice(list(range(len(files)))) + 1])
    elif section_items_type == "link":
        links.append([i] + section_item + [fake.url()])

# Generate assignment files
assignment_files = [
    create_assignment_file(assignment, file_idx)
    for assignment in assignments
    for file_idx in random.sample(range(len(files)), random.randint(0, 3))  # Randomly link files to assignments
]


# Randomly assign type to each assignment while generating it
assignment_types = np.random.choice(['quiz', 'file_upload', 'text'], len(assignments))

# Initialize lists for different types of assignments
assignment_quizzes = []
assignment_file_uploads = []
assignment_texts = []

# Populate subclass-specific lists
for assignment, assignment_type in zip(assignments, assignment_types):
    if assignment_type == 'quiz':
        assignment_quizzes.append( assignment + [
            random.randint(5, 20),  # NumberOfQuestions
            random.choice([True, False]),  # ShuffleAnswers
            random.choice([True, False]),  # ShuffleQuestions
            timedelta(minutes=random.randint(15, 120)).total_seconds()  # TimeLimit in seconds
        ])
    elif assignment_type == 'file_upload':
        assignment_file_uploads.append(assignment + [
            random.randint(1, 5)  # MaxFilesAllowed
        ])
    elif assignment_type == 'text':
        assignment_texts.append(assignment + [
            random.randint(100, 2000)  # MaxTextLength
        ])

# Random file options, either None or some file IDs
file_options = [None] + [i + 1 for i in range(len(files))]  # Using generated files

# Initialize lists for QuizQuestions and QuizAnswers
quiz_questions = []
quiz_answers = []

for quiz in assignment_quizzes:
    num_questions = int(quiz[10])  # quiz[5] is the NumberOfQuestions from quiz generation
    for q in range(num_questions):
        # Create quiz question
        question = create_quiz_question(quiz[0], file_options)
        quiz_questions.append(question)
        
        # Generate answers for each question, at least one correct answer is guaranteed
        num_answers = random.randint(3, 5)
        correct_answer_index = random.randint(0, num_answers - 1)
        for a in range(num_answers):
            is_correct = (a == correct_answer_index)
            answer = create_quiz_answer(quiz[0], q, file_options)
            answer[-1] = is_correct  # Set the correctness of the answer
            quiz_answers.append(answer)


# List of student IDs who are students
student_ids = [idx for idx, user in enumerate(users) if user[4] == 'student']

# Collect IDs for file uploads and generate more files if needed
file_ids = [i for i in range(len(files))]

# Generate submissions
submissions = [create_submission(random.choice(student_ids), random.choice(assignments))
               for _ in range(1000)]  # Generate 1000 submissions

# Split submissions into subclass types
quiz_submissions = []
file_upload_submissions = []
text_submissions = []

submission_types = np.random.choice(['quiz', 'file_upload', 'text'], len(submissions))

for i, (submission, submission_type) in enumerate(zip(submissions, submission_types), 1):
    if submission_type == 'quiz':
        # Quiz submissions
        question_id = random.choice(range(len(quiz_questions)))  # Random quiz question
        answer_ids = [a[1] for a in quiz_answers if a[0] == question_id]  # Filter answers for the question
        quiz_submissions.append([i] + submission + create_quiz_submission(question_id, answer_ids))
    elif submission_type == 'file_upload':
        # File upload submissions
        file_upload_submissions.append([i] + submission + create_file_upload_submission(file_ids))
    elif submission_type == 'text':
        # Text submissions
        text_submissions.append([i] + submission + create_text_submission(1000))  # Max text length


# Generate unique file types
file_types = list(set([create_file_type() for _ in range(20)]))  # More than needed to ensure diversity
file_type_ids = list(range(1, len(file_types) + 1))

# Generate AllowedTypesUpload data assuming you have assignment_file_uploads data
assignment_file_upload_ids = [afu[0] for afu in assignment_file_uploads]  # Extract IDs from assignment_file_uploads
allowed_types_uploads = [create_allowed_types_upload(assignment_file_upload_ids, file_type_ids) for _ in range(50)]

# Generate StudentProgress data
student_progress_entries = [create_student_progress(student_ids, [si + 1 for si in range(len(section_items))]) for _ in range(500)]

# Assume these IDs based on previous data generation
user_ids = list(range(1, len(users) + 1))
course_ids = list(range(1, len(courses) + 1))
file_ids = list(range(1, len(files) + 1))
submission_ids = list(range(1, len(submissions) + 1))


# Generate emails
emails = [create_email(user_ids, course_ids) for _ in range(100)]

email_ids = list(range(1, len(emails) + 1))

# Generate email receivers
email_receivers = [create_email_receiver(email_ids, user_ids) for _ in range(300)]

# Generate email files
email_files = [create_email_file(email_ids, file_ids) for _ in range(150)]

# Generate feedbacks
feedbacks = [create_feedback(user_ids, submission_ids) for _ in range(200)]

# Generate comments
comments = [create_comment(user_ids, submission_ids) for _ in range(300)]




# Save to CSV
with open('data/users.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['FirstName', 'MiddleName', 'LastName', 'DOB', 'Role', 'Username', 'PasswordHash', 'RegDate', 'LastAccess'])
    writer.writerows(users)

with open('data/courses.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['Code', 'Section', 'Semester', 'Year', 'IsGraded'])
    writer.writerows(courses)

with open('data/time_slots.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['WeekdayNumber', 'StartTime', 'EndTime'])
    writer.writerows(time_slots)

with open('data/course_schedules.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['CourseID', 'TimeSlotID'])
    writer.writerows(course_schedules)

with open('data/enrollments.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['UserID', 'CourseID', 'EnrolledAt'])
    writer.writerows(enrollments)

with open('data/course_instructors.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['UserID', 'CourseID', 'InstructorRole'])
    writer.writerows(course_instructors)

with open('data/page_sections.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['CourseID', 'Title', 'Description', 'OrderNumber'])
    writer.writerows(page_sections)

with open('data/section_items.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['PageSectionID', 'Title', 'OrderNumber'])
    writer.writerows(section_items)

with open('data/assignment_groups.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['CourseID', 'Title', 'DropLowestN', 'PercentOfGrade'])
    writer.writerows(assignment_groups)

with open('data/files.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['Filepath', 'DateAdded'])
    writer.writerows(files)

with open('data/assignments.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['ID', 'PageSectionID', 'Title', 'OrderNumber', 'AssignmentGroupID', 'CreatedAt', 'OpenedAt', 'DueAt', 'LateSubmissionAllowed', 'Body'])
    writer.writerows(assignments)

with open('data/assignment_files.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['AssignmentID', 'FileID'])
    writer.writerows(assignment_files)

with open('data/assignment_quizzes.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['ID', 'PageSectionID', 'Title', 'OrderNumber', 'AssignmentGroupID', 'CreatedAt', 'OpenedAt', 'DueAt','LateSubmissionAllowed', 'Body',\
        'NumberOfQuestions', 'ShuffleAnswers', 'ShuffleQuestions', 'TimeLimit'])
    writer.writerows(assignment_quizzes)

with open('data/assignment_file_uploads.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['ID', 'PageSectionID', 'Title', 'OrderNumber', 'AssignmentGroupID', 'CreatedAt', 'OpenedAt', 'DueAt','LateSubmissionAllowed', 'Body',\
        'MaxFilesAllowed'])
    writer.writerows(assignment_file_uploads)

with open('data/assignment_texts.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['ID', 'PageSectionID', 'Title', 'OrderNumber', 'AssignmentGroupID', 'CreatedAt', 'OpenedAt', 'DueAt','LateSubmissionAllowed', 'Body',\
        'MaxTextLength'])
    writer.writerows(assignment_texts)


with open('data/quiz_questions.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['QuizID', 'Question', 'FileID', 'OrderNumber'])
    writer.writerows(quiz_questions)

with open('data/quiz_answers.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['QuizID', 'QuestionID', 'Answer', 'FileID', 'OrderNumber', 'IsCorrect'])
    writer.writerows(quiz_answers)

with open('data/submissions.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['StudentID', 'AssignmentID', 'SubmittedAt'])
    writer.writerows(submissions)

with open('data/quiz_submissions.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['ID', 'StudentID', 'AssignmentID', 'SubmittedAt', 'QuestionID', 'AnswerID', 'ClickedAt'])
    writer.writerows(quiz_submissions)

with open('data/file_upload_submissions.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['ID', 'StudentID', 'AssignmentID', 'SubmittedAt', 'FileID'])
    writer.writerows(file_upload_submissions)

with open('data/text_submissions.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['ID', 'StudentID', 'AssignmentID', 'SubmittedAt', 'Text'])
    writer.writerows(text_submissions)

with open('data/file_types.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['FileType'])
    for idx, ft in enumerate(file_types):
        writer.writerow([ft])

with open('data/allowed_types_uploads.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['AssignmentID', 'FileTypeID'])
    writer.writerows(allowed_types_uploads)

with open('data/student_progress.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['StudentID', 'SectionItemID'])
    writer.writerows(student_progress_entries)

with open('data/emails.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['CourseID', 'SentBy', 'SentAt', 'Subject', 'Body'])
    writer.writerows(emails)

with open('data/email_receivers.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['EmailID', 'ReceivedBy'])
    writer.writerows(email_receivers)

with open('data/email_files.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['EmailID', 'FileID'])
    writer.writerows(email_files)

with open('data/feedbacks.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['InstructorID', 'SubmissionID', 'Text', 'Grade', 'GivenAt'])
    writer.writerows(feedbacks)

with open('data/comments.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['SubmissionID', 'SentBy', 'SentAt', 'Text'])
    writer.writerows(comments)

with open('data/page_files.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['ID', 'PageSectionID', 'Title', 'OrderNumber', 'FileID'])
    writer.writerows(page_files)

with open('data/links.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['ID', 'PageSectionID', 'Title', 'OrderNumber', 'URL'])
    writer.writerows(links)