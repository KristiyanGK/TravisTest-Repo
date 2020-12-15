$filesLoc = 'C:\repos\tr test\Source\VMware.vSphereDSC\Classes'

$files = Get-ChildItem $filesLoc -Recurse -File

$regex = "(?<LogType>(Write-WarningLog)|(Write-VerboseLog)) -Message (?<Message>[\`"\{\} \$\w.]+)(?<Arguments>[\[\].$\w, '\(\-\)Arguments@\d]*)"

foreach ($file in $files) {
    $content = Get-Content $file

    $foundMatches = $content | Select-String -Pattern $regex -AllMatches

    if ($null -eq $foundMatches -or $foundMatches.Count -eq 0) {
        continue
    }

    $replacement = [System.Collections.ArrayList]::new($content)

    for ($i = $foundMatches.Length - 1; $i -ge 0; $i--) {
        $matchFound = $foundMatches[$i].Matches
        $groups = $matchFound.Groups
        $arguments = $null
        try {
            $groupArgs = ($groups | Where-Object { $_.Name -eq 'Arguments' } | Select-Object -First 1).Value
            if (-not [string]::IsNullOrEmpty($groupArgs)) {
                $arguments = $groupArgs.Split('-Arguments')[1].Trim()
            }
        }
        catch { }

        $message = ($groups | Where-Object { $_.Name -eq 'Message' } | Select-Object -First 1).Value.Trim()

        $logType = ($groups | Where-Object { $_.Name -eq 'LogType' } | Select-Object -First 1).Value.Split('-')[1]
        $logType = $logType.Substring(0, $logType.IndexOf('Log'))

        $addition = @(
            ""
            "`$writeToLogFilesplat = @{"
            "    Connection = `$this.ConnectionName"
            "    ResourceName = `$this.GetType().ToString()"
            "    LogType = '$logType'"
            "    Message = $message"
            if (-not [string]::IsNullOrEmpty($arguments)) {
                "    Arguments = $arguments"
            }
            "}"
            ""
            "Write-LogToFile @writeToLogFilesplat"
        )

        $spacesLength = 0

        for ($j = 0; $j -lt $foundMatches[$i].Line.Length; $j++) {
            if ($foundMatches[$i].Line[$j] -ne ' ') {
                break
            }

            $spacesLength++
        }

        if ($replacement[$foundMatches[$i].LineNumber].Trim() -ne '}') {
            $replacement.Insert($foundMatches[$i].LineNumber, '')
        }

        for ($j = $addition.Count - 1; $j -ge 0; $j--) {
            $item = $addition[$j]

            if ($item -ne '') {
                $item = $item.PadLeft($addition[$j].Length + $spacesLength, ' ')
            }

            $replacement.Insert($foundMatches[$i].LineNumber, $item)
        }
    }

    $replacement | Out-File $file.FullName
}
