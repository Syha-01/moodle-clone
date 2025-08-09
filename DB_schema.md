# Database Schema

Here is a description of the necessary tables and their columns:

## 1. subjects

This table will store the different subjects that quizzes can belong to.

| Column Name  | Data Type                | Constraints                      | Description                                  |
|--------------|--------------------------|----------------------------------|----------------------------------------------|
| id           | bigint                   | Primary Key, Auto-incrementing   | A unique identifier for each subject.        |
| name         | text                     | Not Null, Unique                 | The name of the subject (e.g., "Mathematics", "History"). |
| created_at   | timestamp with time zone | Default: now()                   | The date and time when the subject was created. |

## 2. profiles

This table will hold public user data and roles, extending Supabase's built-in `auth.users` table.

| Column Name | Data Type | Constraints                             | Description                                       |
|-------------|-----------|-----------------------------------------|---------------------------------------------------|
| id          | uuid      | Primary Key, Foreign Key to auth.users.id | The user's unique ID from the authentication table. |
| role        | text      | Not Null, Default: 'student'            | The user's role, either 'admin' or 'student'.     |
| full_name   | text      |                                         | The user's full name.                             |

## 3. quizzes

This table contains the core information about each quiz.

| Column Name        | Data Type                | Constraints                             | Description                                  |
|--------------------|--------------------------|-----------------------------------------|----------------------------------------------|
| id                 | bigint                   | Primary Key, Auto-incrementing          | A unique identifier for each quiz.           |
| title              | text                     | Not Null                                | The name of the quiz.                        |
| subject_id         | bigint                   | Not Null, Foreign Key to subjects.id    | Links the quiz to a subject.                 |
| author_id          | uuid                     | Not Null, Foreign Key to profiles.id    | The admin who created the quiz.              |
| time_limit_minutes | integer                  | Not Null                                | The duration of the quiz in minutes.         |
| created_at         | timestamp with time zone | Default: now()                          | The date and time when the quiz was created. |

## 4. questions

This table stores the individual questions for all quizzes.

| Column Name     | Data Type                | Constraints                             | Description                                  |
|-----------------|--------------------------|-----------------------------------------|----------------------------------------------|
| id              | bigint                   | Primary Key, Auto-incrementing          | A unique identifier for each question.       |
| quiz_id         | bigint                   | Not Null, Foreign Key to quizzes.id     | Links the question to a specific quiz.       |
| question_text   | text                     | Not Null                                | The content of the question itself.          |
| question_type   | text                     | Not Null                                | The type of question, e.g., 'multiple_choice' or 'short_answer'. |
| image_url       | text                     | Nullable                                | A URL to an associated image, which can be stored in Supabase Storage. |
| created_at      | timestamp with time zone | Default: now()                          | The date and time when the question was created. |

## 5. options

This table is for the potential answers in multiple-choice questions.

| Column Name   | Data Type | Constraints                             | Description                                  |
|---------------|-----------|-----------------------------------------|----------------------------------------------|
| id            | bigint    | Primary Key, Auto-incrementing          | A unique identifier for each option.         |
| question_id   | bigint    | Not Null, Foreign Key to questions.id   | Links the option to a specific question.     |
| option_text   | text      | Not Null                                | The text of the answer option.               |
| is_correct    | boolean   | Not Null, Default: false                | A true/false value indicating if this is the correct answer. |

## 6. quiz_attempts

This table tracks each time a student attempts a quiz.

| Column Name | Data Type                | Constraints                             | Description                                  |
|-------------|--------------------------|-----------------------------------------|----------------------------------------------|
| id          | bigint                   | Primary Key, Auto-incrementing          | A unique identifier for each quiz attempt.   |
| user_id     | uuid                     | Not Null, Foreign Key to profiles.id    | The student who is taking the quiz.          |
| quiz_id     | bigint                   | Not Null, Foreign Key to quizzes.id     | The quiz being attempted.                    |
| start_time  | timestamp with time zone | Not Null, Default: now()                | When the student started the quiz.           |
| end_time    | timestamp with time zone | Nullable                                | When the student finished the quiz.          |
| score       | integer                  | Nullable                                | The final calculated score for the attempt.  |

## 7. user_answers

This table stores the specific answers given by a user for each question during an attempt.

| Column Name          | Data Type | Constraints                               | Description                                  |
|----------------------|-----------|-------------------------------------------|----------------------------------------------|
| id                   | bigint    | Primary Key, Auto-incrementing            | A unique identifier for each user answer.    |
| quiz_attempt_id      | bigint    | Not Null, Foreign Key to quiz_attempts.id | Links the answer to a specific quiz attempt. |
| question_id          | bigint    | Not Null, Foreign Key to questions.id     | The question that was answered.              |
| selected_option_id   | bigint    | Nullable, Foreign Key to options.id       | The chosen option for a multiple-choice question. |
| short_answer_text    | text      | Nullable                                  | The text provided for a short-answer question. |
| is_correct           | boolean   | Nullable                                  | Whether the provided answer was correct. This is determined during auto-grading. |

## How It All Works Together

- An **Admin** creates a quiz after selecting a subject.
- The admin then adds questions to that quiz.
- If the `question_type` is 'multiple_choice', they will also create several options, marking one as `is_correct`.
- If it's a 'short_answer' question, they might store the correct answer within the question table (in a new column) or handle the logic in your application.
- A **Student** (a profile with the 'student' role) can start a quiz, which creates a new entry in `quiz_attempts`.
- As the student answers each question, a new row is inserted into `user_answers`.
- When the quiz is submitted or the `time_limit_minutes` is reached, you can run a function to calculate the score by comparing the `user_answers` with the correct options and update the `score` in the `quiz_attempts` table.
