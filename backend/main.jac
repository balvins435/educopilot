# backend/main.jac
walker init {
    has port = 8080;
    
    with entry {
        report "🎯 Initializing Educopilot Learning Platform...";
        
        # Create root graph
        root = spawn here::graph;
        std.out("✅ Root graph created");
        
        # Import our models
        import "models.jac";
        
        # Initialize with seed data
        spawn here walker::seed_data;
        
        # Start the API server
        std.out("🚀 Starting server on http://localhost:" + str(port));
        std.jac_serve(graph=root, port=port, hot_reload=true);
    }
}