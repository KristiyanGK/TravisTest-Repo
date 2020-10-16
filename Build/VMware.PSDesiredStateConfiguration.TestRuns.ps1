. (Join-Path $PSScriptRoot 'common.ps1')

$moduleName = 'VMware.PSDesiredStateConfiguration'

$moduleRoot = Join-Path $Script:SourceRoot $moduleName

$configPath = Join-Path (Join-Path (Join-Path $moduleRoot 'Tests') 'Required Dsc Resources') 'MyDscResource'

$env:PSModulePath += "$([System.IO.Path]::PathSeparator)$configPath"

$coveragePercent = Start-UnitTests $moduleName

$resultPath = Join-Path $env:TRAVIS_BUILD_DIR $env:PSDS_CODECOVERAGE_RESULTFILE

$coveragePercent | Out-File $resultPath
