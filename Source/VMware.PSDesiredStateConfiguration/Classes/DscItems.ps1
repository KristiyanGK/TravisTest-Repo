<#
    .Description
    Class that defines a dsc configuration
#>
class VmwDscConfiguration {
    [ValidateNotNullOrEmpty()]
    [string] $InstanceName

    [VmwDscResource[]] $Resources

    VmwDscConfiguration($InstanceName, $Resources) {
        $this.InstanceName = $InstanceName
        $this.Resources = $Resources
    }
}

<#
    .Description
    Class that defines a dsc resource
#>
class VmwDscResource {
    [ValidateNotNullOrEmpty()]
    [string] $InstanceName

    [ValidateNotNullOrEmpty()]
    [string] $ResourceType

    [ValidateNotNull()]
    [Hashtable] $Property

    [string] $ModuleName

    hidden [VmwDscResource[]] $InnerResources

    VmwDscResource($InstanceName, $ResourceType, $ModuleName, $Property, $InnerResources) {
        $this.Init($InstanceName, $ResourceType, $ModuleName, $Property, $InnerResources)
    }

    VmwDscResource($InstanceName, $ResourceType, $ModuleName, $Property) {
        $this.Init($InstanceName, $ResourceType, $ModuleName, $Property, $null)
    }

    VmwDscResource($InstanceName, $ResourceType, $ModuleName) {
        $this.Init($InstanceName, $ResourceType, $ModuleName, @{}, $null)
    }

    # init function sets the values of properties, because powershell does not support chaining constructors
    hidden [void] Init($InstanceName, $ResourceType, $ModuleName, $Property, $InnerResources) {
        $this.InstanceName = $InstanceName
        $this.ResourceType = $ResourceType
        $this.ModuleName = $ModuleName
        $this.Property = $Property
        $this.innerResources = $InnerResources
    }

    # return flag if the dsc resource is composite
    [bool] GetIsComposite() {
        return $null -ne $this.InnerResources
    }

    # returns inner resources for composite dsc resources
    [VmwDscResource[]] GetInnerResources() {
        return $this.innerResources
    }

    # sets innerresources for a composite resource
    [void] SetInnerResources([VmwDscResource[]] $innerResources) {
        if ($null -eq $innerResources) {
            throw '$innerResources must not be null!'
        }
        
        $this.innerResources = $innerResources
    }

    # gets the unique id of the resource
    [string] GetId() {
        return "[$($this.ResourceType)]$($this.InstanceName)"
    }

    [string] ToString() {
        return "$($this.ResourceType) $($this.InstanceName)"
    }
}


<#
    .Description
    Class that represents a result from Test-VmwDscConfiguration cmdlet with -Detailed flag switched 
#>
class DscTestMethodDetailedResult {
    [bool] $InDesiredState

    [VmwDscResource[]] $ResourcesInDesiredState

    [VmwDscResource[]] $ResourcesNotInDesiredState

    DscTestMethodDetailedResult([VmwDscResource[]]$Resources, $StateArr) {
        $this.Init($Resources, $StateArr)
    }

    hidden [void] Init($Resources, $StateArr) {
        $this.InDesiredState = $true
        $resInDesiredState = New-Object -TypeName 'System.Collections.ArrayList'
        $resNotInDesiredState = New-Object -TypeName 'System.Collections.ArrayList'

        for ($i = 0; $i -lt $Resources.Count; $i++) {
            # states can be an array due to composite resources having multiple inner resources
            $states = $StateArr[$i]
            $currInDesiredState = $true

            foreach ($state in $states) {
                if (-not $state.InDesiredState) {
                    $currInDesiredState = $false
                    break
                }
            }

            # add to correct array depending on the desired state
            if ($currInDesiredState) {
                $resInDesiredState.Add($Resources[$i]) | Out-Null
            } else {
                $resNotInDesiredState.Add($Resources[$i]) | Out-Null
                $this.InDesiredState = $false
            }
        }

        $this.ResourcesInDesiredState = $resInDesiredState.ToArray()
        $this.ResourcesNotInDesiredState = $resNotInDesiredState.ToArray()
    }
}
