function Start-UnitTests {
    [CmdletBinding()]
    [OutputType([void])]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ModuleName
    )

    # Runs all unit tests in the module.
    $moduleFolderPath = (Get-Module $ModuleName -ListAvailable).ModuleBase
    $unitTestsFolderPath = Join-Path (Join-Path $moduleFolderPath 'Tests') 'Unit'
    $moduleUnitTestsResult = Invoke-Pester -Path "$unitTestsFolderPath\*" `
                -CodeCoverage @{ Path = "$ModuleFolderPath\$ModuleName.psm1" } `
                -PassThru `
                -EnableExit

    # Gets the coverage percent from the unit tests that were ran.
    $numberOfCommandsAnalyzed = $moduleUnitTestsResult.CodeCoverage.NumberOfCommandsAnalyzed
    $numberOfCommandsMissed = $moduleUnitTestsResult.CodeCoverage.NumberOfCommandsMissed

    $coveragePercent = [math]::Floor(100 - (($numberOfCommandsMissed / $numberOfCommandsAnalyzed) * 100))

    $coveragePercent
}

$script:ProjectRoot = (Get-Item -Path $PSScriptRoot).Parent.FullName

# Adds the Source directory from the repository to the list of modules directories.
$script:SourceRoot = Join-Path -Path $script:ProjectRoot -ChildPath 'Source'
$script:ReadMePath = Join-Path -Path $script:ProjectRoot -ChildPath 'README.md'
$Script:ChangelogDocumentPath = Join-Path -Path $Script:ProjectRoot -ChildPath 'CHANGELOG.md'

$env:PSModulePath = $env:PSModulePath + "$([System.IO.Path]::PathSeparator)$script:SourceRoot"

# Installs Pester.
Install-Module -Name Pester -RequiredVersion 4.10.1 -Scope CurrentUser -Force -SkipPublisherCheck

# Registeres default PSRepository.
Register-PSRepository -Default -ErrorAction SilentlyContinue
