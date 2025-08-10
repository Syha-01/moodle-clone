--
--  Subjects Table
--  Stores the categories for quizzes, like 'Mathematics' or 'History'.
--
CREATE TABLE subjects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  -- The user who created this subject.
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE
);

--
--  Quizzes Table
--  Stores the main information for each quiz.
--
CREATE TABLE quizzes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  -- Link to the subjects table. If a subject is deleted, all its quizzes are deleted.
  subject_id UUID REFERENCES subjects(id) ON DELETE CASCADE,
  -- Optional time limit in minutes. NULL means no time limit.
  time_limit_minutes INTEGER,
  created_at TIMESTAMPTZ DEFAULT now(),
  -- The user (teacher) who created this quiz.
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE
);

--
--  Questions Table
--  Stores each question, its type, and an optional image.
--
CREATE TABLE questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  -- Link to the quizzes table. If a quiz is deleted, all its questions are deleted.
  quiz_id UUID REFERENCES quizzes(id) ON DELETE CASCADE NOT NULL,
  question_text TEXT NOT NULL,
  -- Enforces that the question type must be one of the specified values.
  question_type TEXT NOT NULL CHECK (question_type IN ('multiple_choice', 'short_answer')),
  -- URL for an image stored in Supabase Storage.
  image_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

--
--  Question Options Table
--  Stores the possible answers for 'multiple_choice' questions.
--
CREATE TABLE question_options (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  -- Link to the questions table. If a question is deleted, all its options are deleted.
  question_id UUID REFERENCES questions(id) ON DELETE CASCADE NOT NULL,
  option_text TEXT NOT NULL,
  -- Indicates if this is the correct answer for the question.
  is_correct BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

--
--  Short Answers Table
--  Stores the correct answer for 'short_answer' questions.
--
CREATE TABLE short_answers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  -- Link to the questions table.
  question_id UUID REFERENCES questions(id) ON DELETE CASCADE NOT NULL,
  correct_answer TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

--
--  Quiz Attempts Table
--  Tracks each time a user starts a quiz.
--
CREATE TABLE quiz_attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  -- The user taking the quiz.
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  -- The quiz being attempted.
  quiz_id UUID REFERENCES quizzes(id) ON DELETE CASCADE NOT NULL,
  score INTEGER,
  start_time TIMESTAMPTZ DEFAULT now(),
  end_time TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now()
);

--
--  User Answers Table
--  Stores the specific answers a user gives during an attempt.
--
CREATE TABLE user_answers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  -- Link to a specific quiz attempt.
  attempt_id UUID REFERENCES quiz_attempts(id) ON DELETE CASCADE NOT NULL,
  -- The question being answered.
  question_id UUID REFERENCES questions(id) ON DELETE CASCADE NOT NULL,
  -- The chosen option for a multiple choice question.
  chosen_option_id UUID REFERENCES question_options(id) ON DELETE SET NULL,
  -- The text provided for a short answer question.
  short_answer_text TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  -- Ensures that an answer is linked to both an attempt and a question.
  UNIQUE(attempt_id, question_id)
);