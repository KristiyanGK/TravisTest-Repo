$root = Split-Path (Split-Path $PSScriptRoot)

$module = Join-Path $root 'VMware.PSDesiredStateConfiguration.psd1'

Import-Module $module -Force

InModuleScope -ModuleName 'VMware.PSDesiredStateConfiguration' {
    try {
        $rootTestPath = Split-Path $PSScriptRoot

        $Script:configFolder = Join-Path $rootTestPath 'Sample Configurations'
    
        $util = Join-Path $rootTestPath 'Utility.ps1'
        . $util
    
        $Global:OldProgressPreference = $ProgressPreference
        $Global:ProgressPreference = 'SilentlyContinue'
    
        Describe 'New-VmwDscConfiguration' {
            It 'Should Compile configuration with a single correctly' {
                # arrange
                $configToUse = 'simple.ps1'
                $configFile = Join-Path $Script:configFolder $configToUse
    
                . $configFile
    
                # act
                $res = New-VmwDscConfiguration 'Test'
    
                # assert
    
                Script:AssertConfigurationEqual $res $Script:expectedCompiled
            }
            It 'Should Compile configuration with multiple resources correctly' {
                # arrange
                $configToUse = 'manyResources.ps1'
                $configFile = Join-Path $Script:configFolder $configToUse
    
                . $configFile
    
                # act
                $res = New-VmwDscConfiguration 'Test'
    
                # assert
    
                Script:AssertConfigurationEqual $res $Script:expectedCompiled
            }
            It 'Should Compile configuration with parameters in file correctly' {
                # arrange
                $configToUse = 'fileParams.ps1'
                $configFile = Join-Path $Script:configFolder $configToUse
    
                . $configFile 'Test path'
    
                # act
                $res = New-VmwDscConfiguration 'Test'
    
                # assert
    
                Script:AssertConfigurationEqual $res $Script:expectedCompiled
            }
            It 'Should Compile configuration with a dependsOn correctly and order resources properly' {
                # arrange
                $configToUse = 'dependsOnOrder.ps1'
                $configFile = Join-Path $Script:configFolder $configToUse
    
                . $configFile
    
                # act
                $res = New-VmwDscConfiguration 'Test'
    
                # assert
    
                Script:AssertConfigurationEqual $res $Script:expectedCompiled
            }
            It 'Should compile configuration with parameters correctly' {
                # arrange
                $configToUse = 'configParams.ps1'
                $configFile = Join-Path $Script:configFolder $configToUse
                $paramsToUse = @{
                    Path = 'parameter path'
                    SourcePath = 'parameter sourcepath'
                    Ensure = 'present'
                }
    
                . $configFile
    
                $Script:expectedCompiled.Resources[0].Property = $paramsToUse
    
                # act
                $res = New-VmwDscConfiguration 'Test' -CustomParams $paramsToUse
    
                # assert
    
                Script:AssertConfigurationEqual $res $Script:expectedCompiled
            }
            It 'Should compile configuration with multiple DependsOn resources in a single resource' {
                # arrange
                $configToUse = 'multipleDependsOnResource.ps1'
                $configFile = Join-Path $Script:configFolder $configToUse
    
                . $configFile
                # act
                $res = New-VmwDscConfiguration 'Test' -CustomParams $paramsToUse
    
                # assert
                Script:AssertConfigurationEqual $res $Script:expectedCompiled
            }
            #TODO Remove when node logic is implemented
            It 'Should throw if configuration contains nodes' {
                # arrange
                $configToUse = 'manyNodes.ps1'
                $configFile = Join-Path $Script:configFolder $configToUse
    
                . $configFile
    
                # assert
    
                { New-VmwDscConfiguration 'Test' } | Should -Throw
            }
            It 'Should throw if given an invaid configuration name' {
                # arrange
                $configName = 'Non-Existing Configuration'
    
                # assert
    
                { New-VmwDscConfiguration $configName } | Should -Throw ($Script:ConfigurationNotFoundException -f $configName)
            }
            It 'Should throw if given a configuration with duplicate resources' {
                # arrange
                $configToUse = 'duplicateResources.ps1'
                $configFile = Join-Path $Script:configFolder $configToUse
    
                . $configFile
    
                # assert
    
                { New-VmwDscConfiguration 'Test' } | Should -Throw ($Script:DuplicateResourceException -f 'file', 'FileResource')
            }
            It 'Should throw if given a configuration with a resource that contains an invalid dependsOn property' {
                # arrange
                $configToUse = 'invalidDependsOn.ps1'
                $configFile = Join-Path $Script:configFolder $configToUse
    
                . $configFile
    
                # assert
                { New-VmwDscConfiguration 'Test' } | Should -Throw ($Script:DependsOnResourceNotFoundException -f 'file', 'Something else')
                #"DependsOn resource of $($Resources[$key]) with name $dependency was not found"
            }
            It 'Should throw if configuration contains code that causes an exception' {
                # arrange
                $configToUse = 'innerException.ps1'
                $configFile = Join-Path $Script:configFolder $configToUse
    
                . $configFile
    
                # assert
                { New-VmwDscConfiguration 'Test' } | Should -Throw
            }
            It 'Should throw if configName is not a configuration' {
                # arrange
                function ImpostorConfig { }
    
                # assert
                { New-VmwDscConfiguration 'ImpostorConfig' } | Should -Throw ($Script:CommandIsNotAConfigurationException -f 'ImpostorConfig', 'function')
            }
            Context 'Nested Configurations' {
                It 'Should compile nested configuration correctly' {
                    # arrange
                    $configToUse = 'nestedConfig.ps1'
                    $configFile = Join-Path $Script:configFolder $configToUse
    
                    . $configFile
                    # act
                    $res = New-VmwDscConfiguration 'Test'
    
                    # assert
                    Script:AssertConfigurationEqual $res $Script:expectedCompiled
                }
                It 'Should compile composite resource correctly' {

                    $os = $PSVersionTable['Platform']

                    if (-not $os.Contains('Microsoft Windows')) {
                        Write-Warning 'Composite Resources are not discoverable in non windows OS due to a bug in Powershell'

                        $true | Should -Be $true
                        return
                    }

                    # arrange
                    $configToUse = 'compositeResourceConfig.ps1'
                    $configFile = Join-Path $Script:configFolder $configToUse
    
                    .$configFile
                    # act
                    $res = New-VmwDscConfiguration 'Test'
    
                    # assert
                    Script:AssertConfigurationEqual $res $Script:expectedCompiled
                }
            }
        }
    }
    finally {
        $Global:ProgressPreference = $Global:OldProgressPreference
    }
}
