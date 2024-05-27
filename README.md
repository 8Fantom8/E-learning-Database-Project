# E-Learning Platform Database System
## Overview
This project aims to create a robust database system for an e-learning platform, ensuring efficient and reliable data management. The platform will support both students and instructors by providing various online tools for course management and learning facilitation.

# Team
- Shahramanyan Alexander
- Abovyan Ara
- Papyan Vram

# Date
February 10, 2024 - May 13, 2024

# Objective
The project’s objective is creating a database system for an e-learning platform (which doesn’t crash). The online learning platform will facilitate learning for the students and course management for the instructors by utilizing various online tools. The database will serve as the foundation of the platform, ensuring fast and efficient data management.

# How to use our project
As we used syndetically generalized data, you should first go to the data folder and run `data_pօpulation.py`, creating a folder called data filled with CSV files within the same path. If you have your data, please skip this step, just create data folder in `data_pօpulation` folder and upload there. Then follow the instructions in `README.txt` in `data_population`.

# Basic Operations
- User Authentication and Authorization: The DBMS will manage user authentication to secure access to the site and utilize authorization mechanisms to control user privileges based on roles (student, instructor, teaching assistant, administrator, etc.).
- Course Management: The system will support operations related to creating, updating, and deleting courses, as well as managing  course material, such as different kinds of assignments, quizzes, exams and so on.
- Student Enrollment and Progress Tracking: The DBMS will control student enrollment in courses (similar to how the course registration is done in Jenzabar Sonis) and track their progress. It will maintain records of completed assignments, grades, and overall performance to provide valuable insights to both students and instructors.

# Main End-Users of the DBMS
The e-learning system's main end-users are students, instructors (including teaching assistants), and administrators. Students access course materials, submit assignments, engage in discussions, and monitor their academic progress. Instructors utilize the system to develop and administer courses, deliver lectures, evaluate student performance, and communicate with their classes. Administrators oversee the system's functionality, managing user accounts, configuring settings, generating reports, and ensuring security and stability.

# Functionality
Students can perform specific operations such as browsing available courses with detailed descriptions, enrollment options, and instructor information; view their courses they are enrolled in; track their progress for each course; submit assignments; and so on.

Instructors can create and update course materials, grade assignments, and provide feedback to students.
Administrators have the capability to manage user accounts, configure system settings, generate reports on course enrollment and performance metrics, and ensure data security and integrity through regular backups.

# Information Management
From an information management perspective, our system will enforce consistency requirements to maintain data integrity and eliminate redundancies. For instance, when a student completes a course, their enrollment and progress data will be updated accordingly, ensuring accurate records of academic achievements. Similarly, if an instructor updates course materials or schedule changes, these modifications will be reflected across the platform to avoid confusion or discrepancies. Additionally, if a user account is deactivated or removed, associated data such as enrollment records and discussion forum posts will be automatically handled to prevent orphaned data and maintain database integrity. These consistency measures help enhance user experience by ensuring reliable and up-to-date information within the e-learning platform.

# Key Features and Entities
Below is a list of potential entities for our project we came up with:
Users: Stores information about all users registered on the platform, including students, instructors, teaching assistants, and administrators.
Roles: Defines various roles within the system (e.g., student, instructor, administrator) and their corresponding permissions.
Courses: Contains details about all courses offered on the platform, including course name, description, instructor(s), enrollment capacity, and schedule.
CourseMaterials: Stores course-related materials such as assignments, quizzes, exams, lecture notes, and other instructional content.
Enrollments: Tracks the enrollment of students in specific courses, including enrollment date and status.
Progress: Records the progress of each student within a course, including completed assignments, grades, and overall performance metrics.
Messages: Manages communication among users through messaging functionality, storing message content, sender, receiver, timestamp, etc.
Forums: Stores discussion forum topics, threads, and replies, allowing users to engage in course-specific or general discussions.
Assignments: Tracks assignments assigned to students, including details such as assignment type, deadline, submission status, and instructor feedback.
Grades: Records grades assigned to students for various assessments, including assignments, quizzes, exams, and overall course grades.
Settings: Stores system configuration settings, preferences, and parameters that can be modified by administrators to customize the platform.

# Problem-Solving
Throughout the project lifecycle, we encountered various technical challenges and unforeseen obstacles. Using different problem-solving approaches enabled us to overcome these problems as a team effectively. One of the most heartbreaking issues we couldn’t wrap our heads around for quite some time was this serious Postgres limitation described [here](https://www.postgresql.org/docs/current/ddl-inherit.html#DDL-INHERIT-CAVEATS:~:text=A%20serious%20limitation,the%20above%20example%3A).
