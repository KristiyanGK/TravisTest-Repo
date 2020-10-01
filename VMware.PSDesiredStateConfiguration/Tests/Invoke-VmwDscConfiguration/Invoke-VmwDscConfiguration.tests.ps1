$root = Split-Path (Split-Path $PSScriptRoot)

$module = Join-Path $root 'VMware.PSDesiredStateConfiguration.psd1'

Import-Module $module -Force

InModuleScope -ModuleName 'VMware.PSDesiredStateConfiguration' {
    Describe 'Invoke-VmwDscResources' {
        $Script:placeholderResource = @(
            [VmwDscResource]::new(
                'testResourceName',
                'testResourceType',
                'testModuleName',
                @{
                    TestField = 'Test'
                }
            )
        )
        Context 'Set' {
            It 'Should not execute if resource is in desired state' {
                # arrange
                Mock Invoke-DscResource {
                    [PSCustomObject]@{
                        InDesiredState = $true
                    }
                } -Verifiable
    
                # act
                $result = Invoke-VmwDscResources $Script:placeholderResource 'Set'                
    
                # assert
                Assert-VerifiableMock
                $result | Should -Be $true
            }
            It 'Should execute if resource is not in desired state' {
                # arrange
                Mock Invoke-DscResource {
                    Param(
                        $Name,
                        $ModuleName,
                        $Property,
                        $Method
                    )

                    if ($Method -eq 'Test') {
                        [PSCustomObject]@{
                            InDesiredState = $false
                        }
                    } else {
                        'completed job'
                    }
                } -Verifiable

                # act
                $result = Invoke-VmwDscResources $Script:placeholderResource 'Set'

                # assert
                Assert-VerifiableMock
                $result | Should -Be 'completed job'
            }
        }
        Context 'Get' {
            It 'Should return correct result' {
                # arrange
                $expectedResource = @(
                    [VmwDscResource]::new(
                        'file',
                        'FileResource',
                        'MyDscResource',
                        @{
                            Path = "new.txt"
                            SourcePath = "original.txt"
                            Ensure = "Present"
                        }
                    )
                )
                Mock Invoke-DscResource {
                    Param(
                        $Property
                    )
                    
                    [PSCustomObject]@{
                        Path = $Property['Path']
                        SourcePath = $Property['SourcePath']
                        Ensure = $Property['Ensure']
                    }
                } -Verifiable

                # act
                $result = Invoke-VmwDscResources $expectedResource 'Get'
    
                # assert
                Assert-VerifiableMock

                ($null -eq $result) | Should -BeFalse
                $result.Path | Should -Be $expectedResource.Property['Path']
                $result.SourcePath | Should -Be $expectedResource.Property['SourcePath']
                $result.Ensure | Should -Be $expectedResource.Property['Ensure']
            }
        }
        Context 'Test' {
            It 'Should return correct result' {
                # arrange
                Mock Invoke-DscResource {
                    [PSCustomObject]@{
                        InDesiredState = $true
                    }
                } -Verifiable
                # act
                $res = Invoke-VmwDscResources $Script:placeholderResource 'Test'
    
                # assert
                Assert-VerifiableMock
                $res | Should -Be $true
            }
        }
        Context 'Composite Resources' {
            It 'Should return innerresources data as a signle entry instead of multiple' {
                # arrange
                $testResource = @(
                    [VmwDscResource]::new(
                        'testComposite',
                        'testType',
                        'testModule',
                        @{
                            SomeProp = 'this'
                        },
                        @(
                            [VmwDscResource]::new(
                                'testInner1',
                                'testInner1Type',
                                'testModule'
                            ),
                            [VmwDscResource]::new(
                                'testInner2',
                                'testInner2Type',
                                'testModule'
                            )
                        )
                    ),
                    [VmwDscResource]::new(
                        'testNormal',
                        'testNormalType',
                        'testNormalModule'
                    )
                )

                Mock InvokeDscResourceUtil {
                    Param(
                        $DscResource,
                        $Method
                    )

                    $DscResource
                } -Verifiable

                # act
                $results = Invoke-VmwDscResources $testResource -Method 'Test'

                # assert
                Assert-VerifiableMock
                $results.Count | Should -Be 2
            }
        }
        It 'Should throw if invalid method is given' {
            # assert
            { Invoke-VmwDscResources $Script:placeholderResource 'invalid method' } | Should -Throw
        }
    }
    Describe 'Test-VmwDscConfiguration' {
        Context 'Detailed switch is off' {
            It 'Should return true if all resources are in desired state' {
                # arrange
                $config = [VmwDscConfiguration]::new(
                    'test',
                    @(
                        [VmwDscResource]::new(
                            'file',
                            'valid',
                            'MyDscResource',
                            @{
                                Property = 'some prop'
                            }
                        )
                    )
                )

                Mock Invoke-DscResource {
                    [PSCustomObject]@{
                        InDesiredState = $true
                    }
                } -Verifiable

                # act
                $res = Test-VmwDscConfiguration $config

                # assert
                Assert-VerifiableMock
                $res | Should -Be $true
            }
            It 'Should return false if at least one resource is not in desired state' {
                # arrange
                $config = [VmwDscConfiguration]::new(
                    'test',
                    @(
                        [VmwDscResource]::new(
                            'file',
                            'valid',
                            'MyDscResource',
                            @{
                                Property = 'some prop'
                            }
                        )
                    )
                )

                Mock Invoke-DscResource {    
                    [PSCustomObject]@{
                        InDesiredState = $false
                    }
                } -Verifiable

                # act
                $res = Test-VmwDscConfiguration $config

                # assert
                Assert-VerifiableMock
                $res | Should -Be $false
            }
        }
        Context 'Detailed switch is on' {
            It 'Should have desired state be false if at least one resource is not in desired state and correctly placed resources in arrays' {
                # arrange
                $config = [VmwDscConfiguration]::new(
                    'test',
                    @(
                        [VmwDscResource]::new(
                            'file',
                            'valid',
                            'MyDscResource',
                            @{
                                Property = 'some prop'
                            }
                        )
                    )
                )
    
                Mock Invoke-DscResource {
                    Param(
                        $Name
                    )
    
                    [PSCustomObject]@{
                        InDesiredState = $false
                    }
                } -Verifiable
    
                # act
                $res = Test-VmwDscConfiguration $config -Detailed
    
                # assert
                Assert-VerifiableMock
                $res.InDesiredState | Should -Be $false
                $res.ResourcesInDesiredState.Count | Should -Be 0
                $res.ResourcesNotInDesiredState.Count | Should -Be 1
            }
            It 'Should place resources in correct arrays and have desired state be true' {
                # arrange
                $config = [VmwDscConfiguration]::new(
                    'test',
                    @(
                        [VmwDscResource]::new(
                            'file',
                            'FileResource',
                            'MyDscResource',
                            @{
                                Path = "new.txt"
                                SourcePath = "original.txt"
                                Ensure = "Present"
                            }
                        )
                        [VmwDscResource]::new(
                            'file2',
                            'FileResource',
                            'MyDscResource',
                            @{
                                Path = "new2.txt"
                                SourcePath = "original.txt"
                                Ensure = "Present"
                            }
                        )
                    )
                )
    
                Mock Invoke-DscResource {
                    Param(
                        $Property
                    )
    
                    [PSCustomObject]@{
                        InDesiredState = $true
                    }
                } -Verifiable
    
                # act
                $res = Test-VmwDscConfiguration $config -Detailed
    
                # assert
                Assert-VerifiableMock
                $res.InDesiredState | Should -Be $true
                $res.ResourcesInDesiredState.Count | Should -Be 2
                $res.ResourcesNotInDesiredState.Count | Should -Be 0
            }
        }
    }
}
