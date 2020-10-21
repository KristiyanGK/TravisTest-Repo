. (Join-Path $PSScriptRoot 'common.ps1')

# run tests and calculate coverage percent
$coveragePercent = Invoke-UnitTests $ModuleName

Write-Host $coveragePercent
