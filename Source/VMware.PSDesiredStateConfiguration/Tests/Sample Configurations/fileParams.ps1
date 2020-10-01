<#
    Configuration file with parameters
#>
Param(
    $PathToUse
)

Configuration Test {
    Import-DscResource -ModuleName MyDscResource

    FileResource file 
    {
        Path = $PathToUse
        SourcePath = 'some path'
        Ensure = 'present'
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
                Path = $PathToUse
                SourcePath = "some path"
                Ensure = "present"
            }
        )
    )
)
