# backend/walkers/learning_walkers.jac
walker get_next_lesson {
    has user_id;
    has current_topic;
    
    with entry {
        report "Finding next lesson for user: " + user_id;
        
        # Find user node
        user_node = spawn here -[node::user(name=.*)]->;
        
        if (user_node) {
            # Simple logic: get first topic for now
            topic_node = spawn here -[node::topic]-> ::[0];
            
            if (topic_node) {
                # Create a lesson recommendation
                lesson_rec = {
                    "topic": topic_node.name,
                    "description": topic_node.description,
                    "difficulty": topic_node.difficulty_level,
                    "action": "start_lesson",
                    "message": "Recommended: Start with " + topic_node.name
                };
                
                report lesson_rec;
                take --> lesson_rec;
            }
        }
    }
}

walker update_progress {
    has user_id;
    has topic_name;
    has score;
    
    with entry {
        report "Updating progress for user: " + user_id;
        
        # Find user and topic nodes
        user_node = spawn here -[node::user]-> ::[0];
        topic_node = spawn here -[node::topic(name=topic_name)]->;
        
        if (user_node and topic_node) {
            # Create or update mastery edge
            edge_exists = user_node -[mastery]-> topic_node;
            
            if (edge_exists) {
                edge_exists.proficiency_score = score;
                edge_exists.last_updated = std.time_now();
            } else {
                # Create new mastery edge
                user_node -[mastery(proficiency_score=score)]-> topic_node;
            }
            
            # Update user's overall mastery
            user_node.mastery_score = score;
            
            report "✅ Progress updated! Score: " + str(score);
            report "   User: " + user_node.name;
            report "   Topic: " + topic_node.name;
        }
    }
}