# Mock Moodle App

This project is a clone of Moodle, with a primary focus on creating and taking quizzes. It's designed to be a lightweight and modern alternative for educational institutions.

## Features

### User Authentication
- Secure login system for students and administrators.

### Admin Dashboard
Admins have full control over the quiz creation and management process.
- **Create Quizzes:** Build new quizzes from scratch.
- **Quiz Details:** Assign a name, subject, and other relevant details to each quiz.
- **Question Management:**
    - **Multiple Choice:** Add questions with four options and designate the correct answer.
    - **Image-Based Questions:** Upload images for students to analyze and answer questions about.
    - **Short Answer Questions:** Include open-ended questions for written responses.
- **Timed Quizzes:** Set a time limit for each quiz session.
- **Study Materials:** Upload PDF documents of past tests or other study materials, organized by subject.

### Student Experience
- **Take Quizzes:** Students can take quizzes assigned to them.
- **Timed Sessions:** Quizzes are timed to ensure a fair testing environment.
- **Automatic Grading:** Multiple choice questions are graded automatically upon quiz completion.
- **Access Study Materials:** Students can download and view PDF study guides uploaded by admins.

## To-Do List

- [ ] **Backend Development**
    - [ ] Set up the database schema for users, quizzes, questions, and subjects.
    - [ ] Implement user authentication (login/registration).
    - [ ] Create API endpoints for admin actions (quiz/question creation, PDF uploads).
    - [ ] Create API endpoints for student actions (fetching quizzes, submitting answers).
    - [ ] Implement automatic grading logic.
    - [ ] Implement quiz timer logic.
- [ ] **Frontend Development**
    - [ ] Build the login page.
    - [ ] Develop the admin dashboard for creating and managing quizzes.
    - [ ] Create the student view for taking quizzes.
    - [ ] Implement the quiz-taking interface with a timer.
    - [ ] Build the page for viewing and downloading study materials.
- [ ] **Deployment**
    - [ ] Choose a hosting provider.
    - [ ] Deploy the backend application.
    - [ ] Deploy the frontend application.
    - [ ] Configure the production environment.

## Project Structure

- **`public/`**: Contains static assets that are publicly accessible, such as `index.html` and images.
- **`src/`**: Contains the main source code for the React application.
  - **`assets/`**: Stores static assets like images and fonts that are imported into components.
  - **`components/`**: Reusable UI components (e.g., buttons, forms, layout elements).
  - **`pages/`**: Top-level components that correspond to different pages of the application (e.g., `HomePage`, `LoginPage`, `AdminDashboard`).
  - **`services/`**: Modules for interacting with external APIs, such as Supabase.
  - **`utils/`**: Helper functions and utility modules.
  - **`App.jsx`**: The root component of the application.
  - **`main.jsx`**: The entry point of the application where the React app is mounted to the DOM.

## Tech Stack

- **Frontend:** React
- **Backend & Database:** Supabase

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/moodle-clone.git
   cd moodle-clone
   ```
2. **Install dependencies:**
   ```bash
   npm install
   ```
3. **Set up environment variables:**
   Create a `.env` file in the root directory and add your Supabase project URL and anon key.
   ```
   VITE_SUPABASE_URL=your-supabase-url
   VITE_SUPABASE_ANON_KEY=your-supabase-anon-key
   ```
4. **Run the development server:**
   ```bash
   npm run dev
   ```
5. Open your browser and navigate to `http://localhost:5173`.
