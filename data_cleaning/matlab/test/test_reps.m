function test_reps()
% TEST_REPS unit test for the reps function.
    x = [1, 3, 4];
    y = [1, 3, 2, 3, 4, 4, 5, 6, 4];

    z = reps(x, y);
    
    assert(all(z == [1, 2, 3])); % throw error if wrong
    printf('Ok!')
end