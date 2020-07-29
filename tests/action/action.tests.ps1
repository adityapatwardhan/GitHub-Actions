# This is a rather strange test file.
# The tests are generated based on whether an environmenet variable is found.
# If no variable is found, that's a problem, so we'll produce an error

    # this mocks what the workflow does
    $vName,$vValue = $test -split "::"
    Set-Content env:$vName $vValue

# collect the variables which were created
$vars = Get-ChildItem env:ActionTest_*

Describe "Tests for passing values to the action" {
    It "Some configuration should be used" {
        $vars | Should -NotBeNullOrEmpty
    }
    
    # This is the test bit
    # if we don't find any variables, nothing will be run, that's why we have the test above.
    foreach ( $variable in $variables ) {
        $tag,$testname,$property = $variable.Name -split "_"
        $expected = $variable.Value
        # this is the actual test to run
        $sb = [scriptblock]::Create("It '$testname' { $eValue = $expected -eq 'null' ? '' : $expected; Get-ActionInput $property | Should -Be '$eValue'}")
        & $sb
        # Open switch - do we need to remove the variable once it's been tested?
    }
}
