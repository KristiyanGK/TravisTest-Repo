function Get-ChangedFiles {
    $lastTravisCommit = 1

    # find last travis commit
    while ($true) {
        $commitInfo = git show HEAD~$lastTravisCommit
        $author = $commitInfo[1]

        if ($author.Contains('travis@travis-ci.org')) {
            break
        }

        $lastTravisCommit += 1
    }

    $changedFiles = git diff --name-only HEAD..HEAD~$lastTravisCommit

    $changedFiles
}

$changedFiles = Get-ChangedFiles

foreach ($changedFile in $changedFiles) {
    if ($changedFile.Contains('Source')) {
        # module changes go here

        if ($changedFile.Contains('VMware.PSDesiredStateConfiguration')) {
            
        } elseif ($changedFile.Contains('VMware.vSphereDSC')) {
            
        }
    } elseif ($changedFile.Contains('Build') -or $changedFiles.Contains('.travis.yml')) {
        # build changes go here

    } else {
        # changes for documentation and  go
        
    }
}
