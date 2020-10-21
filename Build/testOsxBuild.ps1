. (Join-Path $PSScriptRoot 'common.ps1')

# Updating the content of the psm1 and psd1 files via the build module file.
$moduleName = 'VMware.vSphereDSC'
$moduleRoot = Join-Path $Script:SourceRoot $moduleName
$buildModuleFilePath = Join-Path -Path $moduleRoot -ChildPath "$moduleName.build.ps1"
. $buildModuleFilePath

# run tests and calculate coverage percent
$coveragePercent = Invoke-UnitTests $ModuleName

Write-Host $coveragePercent
