Configuration Test {
    Import-DscResource -ModuleName MyDscResource

    FileResource file1 
    {
        Path = "path"
        SourcePath = "path"
        Ensure = "present"
        DependsOn = '[FileResource]file3'
    }

    FileResource file2
    {
        Path = "path"
        SourcePath = "path"
        Ensure = "present"
    }

    FileResource file3 
    {
        Path = "path"
        SourcePath = "path"
        Ensure = "present"
        DependsOn = '[FileResource]file2'
    }

    FileResource file4
    {
        Path = "path"
        SourcePath = "path"
        Ensure = "present"
    }

    FileResource file5
    {
        Path = "path"
        SourcePath = "path"
        Ensure = "present"
    }

    FileResource file6
    {
        Path = "path"
        SourcePath = "path"
        Ensure = "present"
        DependsOn = '[FileResource]file7'
    }

    FileResource file7
    {
        Path = "path"
        SourcePath = "path"
        Ensure = "present"
        DependsOn = '[FileResource]file8'
    }

    FileResource file8
    {
        Path = "path"
        SourcePath = "path"
        Ensure = "present"
    }
}

# file2 -> file3 -> file1 -> file4 -> file5 -> file8 -> file7 -> file6
$Script:expectedCompiled = [VmwDscConfiguration]::new(
    'Test',
    @(
        [VmwDscResource]::new(
            'file2',
            'FileResource',
            'MyDscResource',
            @{ 
                Path = "path"
                SourcePath = "path"
                Ensure = "present"
            }
        )
        [VmwDscResource]::new(
            'file3',
            'FileResource',
            'MyDscResource',
            @{ 
                Path = "path"
                SourcePath = "path"
                Ensure = "present"
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
        [VmwDscResource]::new(
            'file4',
            'FileResource',
            'MyDscResource',
            @{ 
                Path = "path"
                SourcePath = "path"
                Ensure = "present"
            }
        )
        [VmwDscResource]::new(
            'file5',
            'FileResource',
            'MyDscResource',
            @{ 
                Path = "path"
                SourcePath = "path"
                Ensure = "present"
            }
        )
        [VmwDscResource]::new(
            'file8',
            'FileResource',
            'MyDscResource',
            @{ 
                Path = "path"
                SourcePath = "path"
                Ensure = "present"
            }
        )
        [VmwDscResource]::new(
            'file7',
            'FileResource',
            'MyDscResource',
            @{ 
                Path = "path"
                SourcePath = "path"
                Ensure = "present"
            }
        )
        [VmwDscResource]::new(
            'file6',
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
