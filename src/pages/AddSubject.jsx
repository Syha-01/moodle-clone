
import { useState } from 'react';
import {supabase} from "/SupabaseClient.js"


const AddSubject = () => {
 const [subjectName, setSubjectName] = useState('');
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');

  const handleAddSubject = async (e) => {
    e.preventDefault();
    setLoading(true);
    setMessage('');
    setError('');

    if (!subjectName.trim()) {
      setError('Subject name cannot be empty.');
      setLoading(false);
      return;
    }

    try {
      // 1. Get the current logged-in user
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) {
        throw new Error("You must be logged in to add a subject.");
      }

      // 2. Insert the new subject into the database
      const { data, error: insertError } = await supabase
        .from('subjects')
        .insert({
          name: subjectName.trim(),
          user_id: user.id, // Associate the subject with the user
        })
        .select()
        .single(); // Use .single() to get the inserted object back

      if (insertError) {
        // Handle potential database errors, e.g., duplicate name if you have a unique constraint
        if (insertError.code === '23505') { // PostgreSQL unique violation
          throw new Error(`A subject named "${subjectName}" already exists.`);
        }
        throw insertError;
      }

      setMessage(`Successfully added subject: "${data.name}"`);
      setSubjectName(''); // Clear the input field after successful insert

    } catch (error) {
      setError(error.message);
      console.error('Error adding subject:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-100 flex items-center justify-center">
      <div className="w-full max-w-md p-8 space-y-6 bg-white rounded-lg shadow-md">
        <div>
          <h2 className="text-2xl font-bold text-center text-gray-800">
            Add a New Subject
          </h2>
          <p className="mt-2 text-center text-sm text-gray-600">
            Create a new subject to categorize your quizzes.
          </p>
        </div>

        <form className="space-y-6" onSubmit={handleAddSubject}>
          <div>
            <label htmlFor="subjectName" className="text-sm font-medium text-gray-700">
              Subject Name
            </label>
            <input
              id="subjectName"
              name="subjectName"
              type="text"
              required
              value={subjectName}
              onChange={(e) => setSubjectName(e.target.value)}
              className="mt-1 block w-full px-3 py-2 bg-white border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
              placeholder="e.g., World History"
            />
          </div>

          <div>
            <button
              type="submit"
              disabled={loading}
              className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:bg-indigo-400 disabled:cursor-not-allowed"
            >
              {loading ? 'Adding...' : 'Add Subject'}
            </button>
          </div>
        </form>

        {/* Feedback Messages */}
        {message && (
          <div className="mt-4 p-3 text-sm text-green-700 bg-green-100 border border-green-400 rounded-md">
            {message}
          </div>
        )}
        {error && (
          <div className="mt-4 p-3 text-sm text-red-700 bg-red-100 border border-red-400 rounded-md">
            {error}
          </div>
        )}
      </div>
    </div>
  );
}

export default AddSubject
