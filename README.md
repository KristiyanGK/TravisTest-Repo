# Desired State Configuration Execution Engine for VMware

## Overview

The **VMware.PSDesiredStateConfiguration** module provides an alternative in-language way to compile and execute DSC Configurations. It does not require the use of LCM and supports powershell core.

## Getting Started

## Requirements

The following table describes the required dependencies for using the Vmware.PSDesiredStateConfiguration module.

 **Required dependency**   | **Minimum version**
-------------------------- | -------------------
`PowerShell`               | 5.1

If you are using a Core version of Powershell then this module depends on the Invoke-DscResource cmdlet and it must be enabled with the following command
 ```
 Enable-ExperimentalFeature PSDesiredStateConfiguration.InvokeDscResource
 ```

## Using VMware.PSDesiredStateConfiguration

# Example

The following example uses [VMHostNtpSettings Resource](https://github.com/vmware/dscr-for-vmware/wiki/VMHostNtpSettings) and configures the NTP Server and the 'ntpd' Service Policy.

1. You need to compile the Configuration to a powershell object
   ```
    $compilationArgs = @{
        ConfigName = VMHostNtpSettings
        CustomParams = @{
            Name = '<VMHost Name>'
            Server 'Server Name>'
            Password '<Password for User>'
        }
    }

    $dscConfiguration = New-VmwDscConfiguration @compilationArgs
   ```
2. To Test if the NTP Settings are in the desired state:
   ```
    Test-VmwDscConfiguration -Configuration $dscConfiguration 
   ```
3. To Apply the NTP Configuration:
   ```
    Start-VmwDscConfiguration -Configuration $dscConfiguration
   ```
4. To get the latest applied configuration on your machine:
   ```
    Get-VmwDscConfiguration -Configuration $dscConfiguration
   ```
## Branches
[![Build Status](https://travis-ci.org/KristiyanGK/TravisTest-Repo.svg?branch=master)](https://travis-ci.org/KristiyanGK/TravisTest-Repo)
VMware.vSphereDsc ![Coverage](https://img.shields.io/badge/coverage-91%25-brightgreen.svg?maxAge=60)
VMware.PSDesiredStateConfiguration ![Coverage](https://img.shields.io/badge/coverage-91%25-brightgreen.svg?maxAge=60)