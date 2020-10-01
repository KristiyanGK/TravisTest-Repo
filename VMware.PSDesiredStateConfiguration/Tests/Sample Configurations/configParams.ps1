<#
    Configuration with parameters
#>
Configuration Test {
    Param(
        $Path,
        $SourcePath,
        $Ensure
    )

    Import-DscResource -ModuleName MyDscResource

    FileResource file 
    {
        Path = $Path
        SourcePath = $SourcePath
        Ensure = $Ensure
    }
}

$Script:expectedCompiled = [VmwDscConfiguration]::new(
    'Test',
    @(
        [VmwDscResource]::new(
            'file',
            'FileResource',
            'MyDscResource'
        )
    )
)
