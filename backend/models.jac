# backend/models.jac
node user {
    has name;
    has email;
    has user_type = "learner";  # learner, instructor, admin
    has created_at = std.time_now();
    has mastery_score = 0.0;
    
    # Methods
    can update_mastery(score) {
        .mastery_score = score;
        report "Updated mastery to: " + str(score);
    }
}

node topic {
    has name;
    has description;
    has difficulty_level;  # beginner, intermediate, advanced
    has prerequisite_topics = [];
    has learning_materials = [];
}

node lesson {
    has title;
    has content;
    has topic_parent;
    has estimated_completion_time;
    has exercises = [];
}

node quiz {
    has questions = [];
    has topic_reference;
    has difficulty;
    has generated_by = "byLLM";
}

# Edge types
edge mastery {
    has proficiency_score = 0.0;
    has last_updated = std.time_now();
    has completed_lessons = 0;
}

edge prerequisite {
    has required_proficiency = 0.7;
}