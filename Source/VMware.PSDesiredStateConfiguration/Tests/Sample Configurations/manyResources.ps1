<#
    Basic Configuration with many Resources
#>
Configuration Test {
    Import-DscResource -ModuleName MyDscResource

    FileResource file 
    {
        Path = "path"
        SourcePath = "path"
        Ensure = "present"
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
            'file',
            'FileResource',
            'MyDscResource',
            @{ 
                Path = "path"
                SourcePath = "path"
                Ensure = "present"
            }
        )
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
    )
)
