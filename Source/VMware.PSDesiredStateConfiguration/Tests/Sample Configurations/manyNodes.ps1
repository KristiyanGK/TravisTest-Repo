<#
    Configuration with multiple nodes
#>
Configuration Test
{
    Import-DscResource -ModuleName MyDscResource
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node 'MyNode' 
    {
        FileResource 'file'
        {
            Path = 'path'
            SourcePath = 'path2'
            Ensure = 'present'
        }

        Service 'MyNode service' 
        {
            Name = 'Spooler'
            State = 'Running'
        }
    }

    Node 'Other'
    {
        Service 'Test service' 
        {
            Name = 'Spooler'
            State = 'Running'
        }
    }

    FileResource file {
        Path = 'no path'
        SourcePath = 'no source'
        Ensure = 'absent'
    }
}
