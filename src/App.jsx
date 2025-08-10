
import {supabase} from "/SupabaseClient.js"
  import { useState, useEffect } from 'react'
  import { Auth } from '@supabase/auth-ui-react'
  import { ThemeSupa } from '@supabase/auth-ui-shared'

import AddSubject from "./pages/AddSubject.jsx"

function App() {
      const [session, setSession] = useState(null)
      useEffect(() => {
      supabase.auth.getSession().then(({ data: { session } }) => {
        setSession(session)
      })
      const {
        data: { subscription },
      } = supabase.auth.onAuthStateChange((_event, session) => {
        setSession(session)
      })
      return () => subscription.unsubscribe()
    }, [])

    // console.log(session)

    const signOut = async () => {
      const {error} = await supabase.auth.signOut()
      if (error) {
        console.log(error)
      }
    }


     if (!session) {
      return (<Auth supabaseClient={supabase} appearance={{ theme: ThemeSupa }} />)
    }
    else {
      return (
      <div>
        Welcome {session.user.user_metadata.full_name}
        <button onClick={signOut}>Sign Out</button>
        <AddSubject />
      </div>)
    }
}

export default App
