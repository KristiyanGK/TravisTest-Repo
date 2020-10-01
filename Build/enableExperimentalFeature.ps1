Write-Host ('________________________PS VERSION IS:' + $PSVersionTable['psversion'])

if ($PSVersionTable['PsEdition'] -eq 'Core') {
    # check if the Invoke-DscResource emperimental feature is enabled
    if (-not [ExperimentalFeature]::IsEnabled('PSDesiredStateConfiguration.InvokeDscResource')) {
        Enable-ExperimentalFeature PSDesiredStateConfiguration.InvokeDscResource
        Write-Host ('____________________InvokeDscResource is enabled')
    }
}
