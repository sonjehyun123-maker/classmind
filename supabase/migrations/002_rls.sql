-- =====================================================
-- StudyNote v1.0 RLS
-- Migration: 002_rls.sql
-- =====================================================

-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE pdf_files ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_attempts ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- Profiles
-- =====================================================

CREATE POLICY "Users can manage own profile"
ON profiles
FOR ALL
USING (auth.uid() = id);

-- =====================================================
-- Courses
-- =====================================================

CREATE POLICY "Users can manage own courses"
ON courses
FOR ALL
USING (auth.uid() = user_id);

-- =====================================================
-- Sessions
-- =====================================================

CREATE POLICY "Users can manage own sessions"
ON sessions
FOR ALL
USING (
EXISTS (
SELECT 1
FROM courses
WHERE courses.id = sessions.course_id
AND courses.user_id = auth.uid()
)
);

-- =====================================================
-- Notes
-- =====================================================

CREATE POLICY "Users can manage own notes"
ON notes
FOR ALL
USING (
EXISTS (
SELECT 1
FROM sessions
JOIN courses
ON sessions.course_id = courses.id
WHERE sessions.id = notes.session_id
AND courses.user_id = auth.uid()
)
);

-- =====================================================
-- PDF Files
-- =====================================================

CREATE POLICY "Users can manage own pdf"
ON pdf_files
FOR ALL
USING (
EXISTS (
SELECT 1
FROM sessions
JOIN courses
ON sessions.course_id = courses.id
WHERE sessions.id = pdf_files.session_id
AND courses.user_id = auth.uid()
)
);

-- =====================================================
-- Chat
-- =====================================================

CREATE POLICY "Users can manage own chat"
ON chat_messages
FOR ALL
USING (
EXISTS (
SELECT 1
FROM sessions
JOIN courses
ON sessions.course_id = courses.id
WHERE sessions.id = chat_messages.session_id
AND courses.user_id = auth.uid()
)
);

-- =====================================================
-- Quiz
-- =====================================================

CREATE POLICY "Users can manage own quiz"
ON quiz_attempts
FOR ALL
USING (auth.uid() = user_id);