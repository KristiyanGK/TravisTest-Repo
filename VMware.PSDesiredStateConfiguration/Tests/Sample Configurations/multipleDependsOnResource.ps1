<#
    Basic Configuration with many Resources
#>
Configuration Test {
    Import-DscResource -ModuleName MyDscResource

    FileResource file1
    {
        Path = "path"
        SourcePath = "path"
        Ensure = "present"
        DependsOn = @(
            '[FileResource]file2',
            '[FileResource]file3'
        )
    }

    FileResource file2
    {
        Path = "path2"
        SourcePath = "path2"
        Ensure = "absent"
    }

    FileResource file3
    {
        Path = "path3"
        SourcePath = "path3"
        Ensure = "absent"
    }
}

$Script:expectedCompiled = [VmwDscConfiguration]::new(
    'Test',
    @(
        [VmwDscResource]::new(
            'file2',
            'FileResource',
            'MyDscResource',
            @{ 
                Path = "path2"
                SourcePath = "path2"
                Ensure = "absent"
            }
        )
        [VmwDscResource]::new(
            'file3',
            'FileResource',
            'MyDscResource',
            @{ 
                Path = "path3"
                SourcePath = "path3"
                Ensure = "absent"
            }
        )
        [VmwDscResource]::new(
            'file1',
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
