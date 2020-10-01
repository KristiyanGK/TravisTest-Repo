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

# paths to all scripts
$scriptPaths = @(
    (Join-Path $PSScriptRoot 'Classes')
    (Join-Path $PSScriptRoot 'Functions')
    (Join-Path $PSScriptRoot 'Tests')
)

# license with comment brackets
$license = Get-Content (Join-Path $PSScriptRoot 'license.txt') -Raw
$license = $license.Trim()
$license = "<`#" + [System.Environment]::NewLine + $license + [System.Environment]::NewLine + "`#>"

Get-ChildItem -Filter '*.ps1' -Path $scriptPaths -Recurse | ForEach-Object {
    # check if all files have their license
    EnsureLicenseInFile $_ $license
}
