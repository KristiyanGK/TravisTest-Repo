<#
    .Description
    Checks if file contains the required license
#>
function EnsureLicenseInFile {
    param (
        [System.IO.FileInfo]
        $file,

        [string]
        $license
    )

    $fileContent = Get-Content $file.FullName -Raw

    if (-not $fileContent.StartsWith($license)) {
        # add license to start of file
        #$fileContent = $license + [System.Environment]::NewLine + [System.Environment]::NewLine + $fileContent
        #$fileContent | Out-File $file.FullName -Encoding Default

        # throw if license is not found
        throw "$($file.FullName) does not contain the required license"
    }
}

function Update-ModuleVersion {
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [string] $FilePath
    )

    $fileContent = Get-Content $filePath -Raw
    $moduleVersionPattern = "(?<=ModuleVersion = ')(\d*.\d*.\d*.\d*)"
    $moduleVersionMatch = $FileContent | Select-String -Pattern $moduleVersionPattern

    [System.Version] $currentVersion = $moduleVersionMatch.Matches[0].Value

    $newVersion = (New-Object -TypeName 'System.Version' $currentVersion.Major, $currentVersion.Minor, $currentVersion.Build, ($currentVersion.Revision + 1)).ToString()

    ($fileContent -replace $moduleVersionPattern, $newVersion) | Out-File $FilePath
}

# update module version in manifest
$psd1Path = Join-Path $PSScriptRoot 'VMware.PSDesiredStateConfiguration.psd1'

Update-ModuleVersion $psd1Path
