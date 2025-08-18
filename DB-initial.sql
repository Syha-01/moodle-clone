-- Create a table for user profiles
CREATE TABLE public.profiles (
  id UUID NOT NULL REFERENCES auth.users ON DELETE CASCADE,
  full_name TEXT,
  avatar_url TEXT,
  role TEXT NOT NULL DEFAULT 'student', -- 'student' or 'admin'
  PRIMARY KEY (id)
);

-- Set up Row Level Security (RLS)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public profiles are viewable by everyone." ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Users can insert their own profile." ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Users can update own profile." ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- Create a table for educational levels
CREATE TABLE public.levels (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

-- Insert the predefined levels
INSERT INTO public.levels (name) VALUES
('Associates'),
('Bachelors'),
('Masters');

-- Create a table for subjects
CREATE TABLE public.subjects (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  level_id INTEGER NOT NULL REFERENCES public.levels(id) ON DELETE CASCADE
);

-- Create a table for quizzes
CREATE TABLE public.quizzes (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  subject_id INTEGER NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
  time_limit_minutes INTEGER NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create an ENUM type for question types
CREATE TYPE public.question_type AS ENUM ('multiple_choice', 'short_answer');

-- Create a table for questions
CREATE TABLE public.questions (
  id SERIAL PRIMARY KEY,
  quiz_id INTEGER NOT NULL REFERENCES public.quizzes(id) ON DELETE CASCADE,
  question_text TEXT NOT NULL,
  question_type public.question_type NOT NULL,
  image_url TEXT
);

-- Create a table for multiple-choice options
CREATE TABLE public.options (
  id SERIAL PRIMARY KEY,
  question_id INTEGER NOT NULL REFERENCES public.questions(id) ON DELETE CASCADE,
  option_text TEXT NOT NULL,
  is_correct BOOLEAN NOT NULL DEFAULT FALSE
);

-- Create a table for quiz attempts by students
CREATE TABLE public.quiz_attempts (
  id SERIAL PRIMARY KEY,
  student_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  quiz_id INTEGER NOT NULL REFERENCES public.quizzes(id) ON DELETE CASCADE,
  start_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  end_time TIMESTAMPTZ,
  score INTEGER,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create a table for student answers
CREATE TABLE public.student_answers (
  id SERIAL PRIMARY KEY,
  attempt_id INTEGER NOT NULL REFERENCES public.quiz_attempts(id) ON DELETE CASCADE,
  question_id INTEGER NOT NULL REFERENCES public.questions(id) ON DELETE CASCADE,
  selected_option_id INTEGER REFERENCES public.options(id) ON DELETE CASCADE, -- For multiple choice
  short_answer_text TEXT -- For short answers
);

-- Enable Row Level Security for all tables
ALTER TABLE public.levels ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subjects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.options ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_answers ENABLE ROW LEVEL SECURITY;

-- Define RLS policies for admins and students
-- Admins should have full access
CREATE POLICY "Admins can manage all levels." ON public.levels FOR ALL USING ( (SELECT role FROM public.profiles WHERE id = auth.uid()) = 'admin' );
CREATE POLICY "Admins can manage all subjects." ON public.subjects FOR ALL USING ( (SELECT role FROM public.profiles WHERE id = auth.uid()) = 'admin' );
CREATE POLICY "Admins can manage all quizzes." ON public.quizzes FOR ALL USING ( (SELECT role FROM public.profiles WHERE id = auth.uid()) = 'admin' );
CREATE POLICY "Admins can manage all questions." ON public.questions FOR ALL USING ( (SELECT role FROM public.profiles WHERE id = auth.uid()) = 'admin' );
CREATE POLICY "Admins can manage all options." ON public.options FOR ALL USING ( (SELECT role FROM public.profiles WHERE id = auth.uid()) = 'admin' );

-- Students should have read-only access to quiz structure
CREATE POLICY "Students can view levels." ON public.levels FOR SELECT USING ( (SELECT role FROM public.profiles WHERE id = auth.uid()) = 'student' );
CREATE POLICY "Students can view subjects." ON public.subjects FOR SELECT USING ( (SELECT role FROM public.profiles WHERE id = auth.uid()) = 'student' );
CREATE POLICY "Students can view quizzes." ON public.quizzes FOR SELECT USING ( (SELECT role FROM public.profiles WHERE id = auth.uid()) = 'student' );
CREATE POLICY "Students can view questions." ON public.questions FOR SELECT USING ( (SELECT role FROM public.profiles WHERE id = auth.uid()) = 'student' );
CREATE POLICY "Students can view options." ON public.options FOR SELECT USING ( (SELECT role FROM public.profiles WHERE id = auth.uid()) = 'student' );

-- RLS for attempts and answers
CREATE POLICY "Students can manage their own quiz attempts." ON public.quiz_attempts FOR ALL USING ( student_id = auth.uid() );
CREATE POLICY "Students can manage their own answers." ON public.student_answers FOR ALL USING ( (SELECT student_id FROM public.quiz_attempts WHERE id = attempt_id) = auth.uid() );
CREATE POLICY "Admins can view all quiz attempts and answers." ON public.quiz_attempts FOR SELECT USING ( (SELECT role FROM public.profiles WHERE id = auth.uid()) = 'admin' );
CREATE POLICY "Admins can view all student answers." ON public.student_answers FOR SELECT USING ( (SELECT role FROM public.profiles WHERE id = auth.uid()) = 'admin' );