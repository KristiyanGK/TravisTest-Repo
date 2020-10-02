<#
    Configuration containing a composite resource
#>
Configuration Test
{
    Import-DscResource -Name 'CompositeResourceTest'

    CompositeResourceTest Test 
    {
        Value = 'Test Field'
    }
}

$Script:expectedCompiled = [VmwDscConfiguration]::new(
    'Test',
    @(
        [VmwDscResource]::new(
            'Test',
            'CompositeResourceTest',
            'MyDscResource',
            @{},
            @(
                [VmwDscResource]::new(
                    'Test',
                    'MyTestResource',
                    'MyDscResource',
                    @{ 
                        SomeVal = 'Test Field'
                        Ensure = 'Present'
                    }
                )
            )
        )
    )
)
