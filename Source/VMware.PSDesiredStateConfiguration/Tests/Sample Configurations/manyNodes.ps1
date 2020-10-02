<#
    Configuration with multiple nodes
#>
Configuration Test
{
    Import-DscResource -ModuleName MyDscResource

    Node 'MyNode' 
    {
        FileResource 'file'
        {
            Path = 'path'
            SourcePath = 'path2'
            Ensure = 'present'
        }
    }

    Node 'Other'
    {
        FileResource file {
            Path = 'no path'
            SourcePath = 'no source'
            Ensure = 'absent'
        }
    }

    FileResource file {
        Path = 'no path'
        SourcePath = 'no source'
        Ensure = 'absent'
    }
}
