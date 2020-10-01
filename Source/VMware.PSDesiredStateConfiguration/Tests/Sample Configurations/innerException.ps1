<#
    Configuration that causes inner exception during runtime
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

    InvalidCall
}
