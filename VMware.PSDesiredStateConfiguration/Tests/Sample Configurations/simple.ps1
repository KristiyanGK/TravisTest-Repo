<#
    Basic Configuration with only a single resource
#>
Configuration Test 
{
    Import-DscResource -ModuleName MyDscResource

    FileResource file 
    {
        Path = "path"
        SourcePath = "path"
        Ensure = "present"
    }
}

$Script:expectedCompiled = [VmwDscConfiguration]::new(
    'Test',
    @(
        [VmwDscResource]::new(
            'file',
            'FileResource',
            'MyDscResource',
            @{ 
                Path = "path"
                SourcePath = "path"
                Ensure = "present"
            }
        )
    )
)
