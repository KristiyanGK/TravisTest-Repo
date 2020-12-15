$filesLoc = 'C:\repos\tr test\Source\VMware.vSphereDSC\DSCResources'

$files = Get-ChildItem $filesLoc -Recurse -File

foreach ($file in $files) {
    $content = Get-Content $file

    $content = $content -replace 'Connection = \$this\.Connection\.Name', 'Connection = $this.ConnectionName'

    $content | Out-File $file.FullName
}
