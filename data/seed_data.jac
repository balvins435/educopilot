# backend/walkers/seed_data.jac
walker seed_data {
    with entry {
        report "📚 Seeding initial learning data...";
        
        # Create topics
        topics = [
            {"name": "Jac Basics", "difficulty": "beginner", 
             "desc": "Introduction to Jac programming language"},
            {"name": "Object-Spatial Programming", "difficulty": "intermediate",
             "desc": "Learn OSP graph modeling"},
            {"name": "byLLM Integration", "difficulty": "advanced",
             "desc": "AI integration with byLLM agents"},
            {"name": "Jac Client", "difficulty": "intermediate",
             "desc": "Building frontends with Jac-Client"}
        ];
        
        for topic_data in topics {
            topic_node = spawn here::topic;
            topic_node.name = topic_data["name"];
            topic_node.description = topic_data["desc"];
            topic_node.difficulty_level = topic_data["difficulty"];
            
            report "Created topic: " + topic_node.name;
        }
        
        # Create a test user
        test_user = spawn here::user;
        test_user.name = "Hackathon Learner";
        test_user.email = "learner@educopilot.ai";
        
        report "Created user: " + test_user.name;
        report "✅ Seed data complete!";
    }
}