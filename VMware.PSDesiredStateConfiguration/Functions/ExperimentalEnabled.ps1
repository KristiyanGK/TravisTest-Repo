<#
    .Description
    Checks if required Experimental feature is enabled for powershell core users.
    Windows powershell users do not require the feature to be turned on.
#>
function CheckForExperimentalFeature {
    if ($PSVersionTable['PsEdition'] -eq 'Core') {
        # check if the Invoke-DscResource emperimental feature is enabled
        if (-not [ExperimentalFeature]::IsEnabled('PSDesiredStateConfiguration.InvokeDscResource')) {
            throw $Script:ExperimentalFeatureNotEnabledInPsCore
        }
    }
}

# perform check
CheckForExperimentalFeature
