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
