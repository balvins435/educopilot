# test_jac.jac
walker test_install {
    has test = "Jaseci is working!";
    
    with entry {
        report test;
        std.out("Installation successful!");
    }
}