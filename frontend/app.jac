# frontend/app.jac
import jac_client

component LessonCard {
    has lesson;
    has on_start;
    
    ui {
        <div class="lesson-card">
            <h3>{lesson.title}</h3>
            <p>{lesson.description}</p>
            <div class="difficulty-badge">{lesson.difficulty}</div>
            <button class="start-btn" @click={on_start}>
                Start Learning →
            </button>
        </div>
    }
}

component ProgressDashboard {
    has user;
    has progress_data = [];
    
    ui {
        <div class="dashboard">
            <h2>Welcome back, {user.name}! 👋</h2>
            
            <div class="stats-grid">
                <div class="stat-card">
                    <h4>Mastery Score</h4>
                    <div class="big-number">{user.mastery_score}%</div>
                </div>
                <div class="stat-card">
                    <h4>Topics Learned</h4>
                    <div class="big-number">{progress_data.length}</div>
                </div>
            </div>
            
            <h3>Your Learning Path</h3>
            <div class="lessons-grid">
                {for lesson in progress_data {
                    <LessonCard lesson={lesson} on_start={this.startLesson(lesson)} />
                }}
            </div>
        </div>
    }
    
    can startLesson(lesson) {
        report "Starting lesson: " + lesson.title;
        
        # Call backend walker using spawn
        result = spawn here::walker::get_next_lesson(
            user_id=user.id,
            current_topic=lesson.topic
        );
        
        report "Backend response: " + str(result);
    }
}

# Main app component
component EducopilotApp {
    has current_user = {
        "name": "Hackathon Participant",
        "id": "user_001",
        "mastery_score": 25.0
    };
    
    has lessons = [
        {
            "title": "Jac Language Basics",
            "description": "Learn the fundamentals of Jac programming",
            "difficulty": "beginner",
            "topic": "Jac Basics"
        },
        {
            "title": "OSP Graph Modeling",
            "description": "Master Object-Spatial Programming",
            "difficulty": "intermediate", 
            "topic": "Object-Spatial Programming"
        }
    ];
    
    ui {
        <div class="app-container">
            <header class="app-header">
                <h1>🎓 Educopilot</h1>
                <p>AI-Powered Jaseci Learning Platform</p>
            </header>
            
            <main class="app-main">
                <ProgressDashboard 
                    user={current_user} 
                    progress_data={lessons} 
                />
                
                <div class="quick-actions">
                    <button class="btn-primary" @click={this.generateQuiz}>
                        🧠 Generate Practice Quiz
                    </button>
                    <button class="btn-secondary" @click={this.viewProgress}>
                        📊 View Detailed Progress
                    </button>
                </div>
            </main>
            
            <footer>
                <p>Built with ❤️ for Jaseci AI Hackathon 2025</p>
            </footer>
        </div>
    }
    
    can generateQuiz() {
        report "Generating AI-powered quiz...";
        # This would call byLLM integration
    }
    
    can viewProgress() {
        report "Showing progress analytics...";
    }
}

# Walker to serve the frontend
walker serve_frontend {
    has port = 3000;
    
    with entry {
        report "🌐 Launching Educopilot Frontend...";
        
        # Create app instance
        app = EducopilotApp();
        
        # Serve it
        jac_client.serve(
            component=app,
            port=port,
            title="Educopilot - Learn Jaseci"
        );
        
        report "✅ Frontend running at http://localhost:" + str(port);
    }
}