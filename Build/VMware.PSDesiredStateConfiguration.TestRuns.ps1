. (Join-Path $PSScriptRoot 'common.ps1')

$moduleName = 'VMware.PSDesiredStateConfiguration'

$coveragePercent = Start-UnitTests $moduleName

$resultPath = Join-Path $env:TRAVIS_BUILD_DIR $env:PSDS_CODECOVERAGE_RESULTFILE

$coveragePercent | Out-File $resultPath
