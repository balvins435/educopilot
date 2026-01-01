# Jac-Client React-style Component
component LessonViewer {
    has lesson_data;
    has user_progress;
    
    # UI rendering with Jac-Client
    ui {
        <div class="lesson-container">
            <h1>{lesson_data.title}</h1>
            <div class="content">
                {lesson_data.content}
            </div>
            
            # Interactive code editor
            <CodeEditor 
                exercise={lesson_data.exercises[0]}
                onComplete={this.handleExerciseComplete}
            />
            
            # Progress visualization
            <ProgressBar 
                value={user_progress.current_proficiency}
                max={100}
            />
            
            # Navigation buttons with Spawn() calls
            <button 
                onClick={this.nextLesson}
                disabled={!user_progress.can_advance}
            >
                Next Lesson
            </button>
        </div>
    }
    
    # Spawn walker for backend operations
    can handleExerciseComplete(response) {
        # Call backend walker via Spawn()
        result = spawn here::walker::evaluate_user_response(
            question=lesson_data.exercise_question,
            user_answer=response,
            context=lesson_data.context
        );
        
        # Update local state
        this.user_progress = result.updated_progress;
    }
    
    can nextLesson() {
        # Spawn walker to get next lesson
        next_lesson = spawn here::walker::recommend_next_lesson(
            user_id=this.user_id,
            current_topic=lesson_data.topic
        );
        
        navigateTo(`/lesson/${next_lesson.id}`);
    }
}