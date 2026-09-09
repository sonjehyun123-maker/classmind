-- =====================================================
-- StudyNote v1.0 Initial Schema
-- Migration: 001_init.sql
-- =====================================================

-- UUID 생성 함수 사용
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- =====================================================
-- 1. User Profile
-- =====================================================
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- 2. Courses
-- =====================================================
CREATE TABLE courses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    course_name TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- 3. Sessions
-- =====================================================
CREATE TABLE sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,

    week INT NOT NULL CHECK (week > 0),
    lecture_date DATE,

    status TEXT NOT NULL DEFAULT 'drafting'
        CHECK (status IN (
            'drafting',
            'ai_ready',
            'finalized',
            'archived'
        )),

    created_at TIMESTAMPTZ DEFAULT NOW(),

    UNIQUE(course_id, week)
);

-- =====================================================
-- 4. Notes
-- =====================================================
CREATE TABLE notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,

    note_type TEXT NOT NULL
        CHECK (note_type IN (
            'original',
            'ai',
            'final'
        )),

    content TEXT NOT NULL,

    version INT NOT NULL DEFAULT 1 CHECK (version > 0),

    change_log TEXT,

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- 5. PDF Files
-- =====================================================
CREATE TABLE pdf_files (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,

    file_url TEXT NOT NULL,

    page_count INT DEFAULT 0 CHECK (page_count >= 0),

    summary TEXT,

    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- 6. Chat Messages
-- =====================================================
CREATE TABLE chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,

    role TEXT NOT NULL
        CHECK (role IN ('user', 'assistant')),

    content TEXT NOT NULL,

    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- 7. Quiz Attempts
-- =====================================================
CREATE TABLE quiz_attempts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    session_id UUID NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,

    quiz_type TEXT NOT NULL
        CHECK (quiz_type IN (
            'ox',
            'blank',
            'short'
        )),

    difficulty TEXT NOT NULL
        CHECK (difficulty IN (
            'easy',
            'normal',
            'hard'
        )),

    score INT NOT NULL CHECK (score BETWEEN 0 AND 100),

    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- Indexes
-- =====================================================
CREATE INDEX idx_courses_user
    ON courses(user_id);

CREATE INDEX idx_sessions_course
    ON sessions(course_id);

CREATE INDEX idx_notes_session
    ON notes(session_id);

CREATE INDEX idx_pdf_session
    ON pdf_files(session_id);

CREATE INDEX idx_chat_session
    ON chat_messages(session_id);

CREATE INDEX idx_quiz_session
    ON quiz_attempts(session_id);

CREATE INDEX idx_quiz_user
    ON quiz_attempts(user_id);