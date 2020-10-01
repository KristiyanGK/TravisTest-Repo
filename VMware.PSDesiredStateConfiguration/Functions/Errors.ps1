$Script:ConfigurationNotFoundException = "Configuration with name {0} not found"
$Script:CommandIsNotAConfigurationException = "{0} is not a configuration. It is a {1}"
$Script:DuplicateResourceException = "Duplicate resources found with name {0} and type {1}"
$Script:DependsOnResourceNotFoundException = "DependsOn resource of {0} with name {1} was not found"
$Script:DscResourceNotFoundException = "Resource of type: {0} was not found. Try importing it in the configuration file with Import-DscResource"
$Script:ExperimentalFeatureNotEnabledInPsCore = 'This module depends on the Invoke-DscResource cmdlet and in order to use it must be enabled with "Enable-ExperimentalFeature PSDesiredStateConfiguration.InvokeDscResource"'
