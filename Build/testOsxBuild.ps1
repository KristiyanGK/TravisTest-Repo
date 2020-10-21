. (Join-Path $PSScriptRoot 'common.ps1')

# run tests and calculate coverage percent
$coveragePercent = Invoke-UnitTests 'VMware.vSphereDSC'

Write-Host $coveragePercent
