import React, { useState } from 'react';

const Subjects = () => {
  // --- State Management ---
  // I've added the necessary state management to make the form functional for display purposes.
  // The actual submission logic is pending.
  const [subjectName, setSubjectName] = useState('');
  const [quizName, setQuizName] = useState('');
  const [timeLimit, setTimeLimit] = useState(0);

  // Initial state for questions, starting with one for demonstration.
  const [questions, setQuestions] = useState([
    {
      question_text: '',
      question_type: 'multiple_choice',
      image_file: null,
      options: [
        { option_text: '', is_correct: true },
        { option_text: '', is_correct: false },
      ],
      short_answer: '',
    },
  ]);

  // --- Event Handlers ---
  // I've added placeholder functions for your event handlers so the form doesn't crash.
  // The actual logic for these is pending.

  const handleSubmit = (e) => {
    e.preventDefault();
    // TODO: Quiz creation logic is pending. This will handle the database insertion.
    console.log('Form submitted!', { subjectName, quizName, timeLimit, questions });
  };

  const handleQuestionChange = (qIndex, e) => {
    // TODO: Logic to update a question's text, type, or image is pending.
    const { name, value, type, files } = e.target;
    const newQuestions = [...questions];
    if (type === 'file') {
      newQuestions[qIndex][name] = files[0];
    } else {
      newQuestions[qIndex][name] = value;
    }
    setQuestions(newQuestions);
  };

  const handleOptionChange = (qIndex, oIndex, e) => {
    // TODO: Logic to update a multiple-choice option is pending.
    const { name, value } = e.target;
    const newQuestions = [...questions];
    newQuestions[qIndex].options[oIndex][name] = value;
    setQuestions(newQuestions);
  };

  const handleAddQuestion = () => {
    // TODO: Logic to add a new question is pending.
    setQuestions([
      ...questions,
      {
        question_text: '',
        question_type: 'multiple_choice',
        image_file: null,
        options: [
          { option_text: '', is_correct: true },
          { option_text: '', is_correct: false },
        ],
        short_answer: '',
      },
    ]);
  };

  return (
    <form onSubmit={handleSubmit}>
      <h2>Create a New Quiz</h2>

      <div>
        <label>Subject:</label>
        <input type="text" value={subjectName} onChange={(e) => setSubjectName(e.target.value)} required/>
      </div>
      <div>
        <label>Quiz Name:</label>
        <input type="text" value={quizName} onChange={(e) => setQuizName(e.target.value)} required/>
      </div>
      <div>
        <label>Time Limit (minutes, 0 for none):</label>
        <input type="number" value={timeLimit} onChange={(e) => setTimeLimit(parseInt(e.target.value, 10))}/>
      </div>

      <hr/>

      {/* Questions Section */}
      <h3>Questions</h3>
      {questions.map((q, qIndex) => (
        <div key={qIndex} style={{ border: '1px solid #ccc', padding: '10px', margin: '10px 0'
        }}>
          <h4>Question {qIndex + 1}</h4>
          <div>
            <label>Question Text:</label>
            <input type="text" name="question_text" value={q.question_text} onChange={(e) => handleQuestionChange(qIndex, e)} required/>
          </div>
          <div>
            <label>Question Type:</label>
            <select name="question_type" value={q.question_type} onChange={(e) => handleQuestionChange(qIndex, e)}>
              <option value="multiple_choice">Multiple Choice</option>
              <option value="short_answer">Short Answer</option>
            </select>
          </div>
          <div>
            <label>Image (Optional):</label>
            <input type="file" name="image_file" accept="image/*" onChange={(e) => handleQuestionChange(qIndex, e)}/>
          </div>

          {/* Render inputs based on question type */}
          {q.question_type === 'multiple_choice' ? (
            <div>
              <h5>Options</h5>
              {q.options.map((opt, oIndex) => (
                <div key={oIndex}>
                  <input type="text" name="option_text" placeholder={`Option ${oIndex + 1}`} value={opt.option_text} onChange={(e) => handleOptionChange(qIndex, oIndex, e)} required/>
                  <label>
                    <input type="radio" name={`correct_option_${qIndex}`} checked={opt.is_correct} onChange={() => {
                      // TODO: Logic to handle correct option selection is pending.
                      const newQuestions = [...questions];
                      newQuestions[qIndex].options.forEach((o, i) => (o.is_correct = i === oIndex));
                      setQuestions(newQuestions);
                    }}/> Correct
                  </label>
                </div>
              ))}
            </div>
          ) : (
            <div>
              <h5>Correct Answer</h5>
              <input type="text" name="short_answer" value={q.short_answer} onChange={(e) => handleQuestionChange(qIndex, e)} required/>
            </div>
          )}
        </div>
      ))}
      <button type="button" onClick={handleAddQuestion}>Add Another Question</button>
      <hr/>
      <button type="submit">Create Quiz</button>
    </form>
  );
}

export default Subjects;
