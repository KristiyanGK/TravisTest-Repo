<#
    Configuration with an invalid dependsOn property
#>
Configuration Test {
    Import-DscResource -ModuleName MyDscResource

    FileResource file 
    {
        Path = 'path'
        SourcePath = 'path'
        Ensure = 'present'
        DependsOn = "Something else"
    }
}
