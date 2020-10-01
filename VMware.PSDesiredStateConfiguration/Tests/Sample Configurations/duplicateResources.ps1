<#
    Configuration with duplicate resource names of the same type
#>
Configuration Test {
    Import-DscResource -ModuleName MyDscResource

    FileResource file 
    {
        Path = "path"
        SourcePath = "path"
        Ensure = "present"
    }

    FileResource file
    {
        Path = "path2"
        SourcePath = "path2"
        Ensure = "absent"
    }
}
