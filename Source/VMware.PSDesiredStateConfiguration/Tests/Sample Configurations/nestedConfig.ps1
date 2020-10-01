<#
    Configuration with another nested configuration
#>
Configuration Another {
    Param(
        [Parameter(Mandatory = $true)]
        [string] $Destination,

        [Parameter(Mandatory)]
        [string]
        $Source
    )

    Import-DscResource -ModuleName MyDscResource
    FileResource Test2
    {
        Path = $Destination
        SourcePath = $Source
        Ensure = 'present'
    }
}

Configuration Test
{
    Import-DscResource -ModuleName MyDscResource

    $Path = "path"
    $SourcePath = "source path"
    $Ensure = 'Present'

    Another NestedConfig 
    {
        Destination = 'Some Destination'
        Source = 'Some source'
    }

    FileResource Test 
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
            'NestedConfig',
            'Another',
            '',
            @{},
            @(
                [VmwDscResource]::new(
                    'Test2',
                    'FileResource',
                    'MyDscResource',
                    @{ 
                        Path = "Some Destination"
                        SourcePath = "Some Source"
                        Ensure = "present"
                    }
                )
            )
        ),
        [VmwDscResource]::new(
            'Test',
            'FileResource',
            'MyDscResource',
            @{ 
                Path = "path"
                SourcePath = "source path"
                Ensure = "present"
            }
        )
    )
)
