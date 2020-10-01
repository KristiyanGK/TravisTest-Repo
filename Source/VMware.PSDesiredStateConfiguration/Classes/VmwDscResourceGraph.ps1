<#
    .Description
    This graph is used to sort Resources by their 'DependsOn' key in the 'Property' property
#>
class VmwDscResourceGraph {
    [System.Collections.Specialized.OrderedDictionary] 
    hidden $Edges

    [System.Collections.Specialized.OrderedDictionary]
    hidden $Resources

    VmwDscResourceGraph([System.Collections.Specialized.OrderedDictionary] $Resources) {
        $this.Resources = $Resources
        $this.FillEdges()
    }

    <#
        .Description
        Sorts the resources in the graph so that
        the resources get ordered based on their dependencies
    #>
    [System.Array] TopologicalSort() {
        # bool array for keeping track of visited resources
        $visited = New-Object 'System.Collections.Generic.HashSet[string]'
        # hashtable for detecting circular dependencies
        $cycles = New-Object 'System.Collections.Generic.HashSet[string]'
        # resource keys wil be kept inside this stack
        $sortedResourceKeys = New-Object -TypeName 'System.Collections.Stack'

        $keysArr = @($this.Edges.Keys)

        for ($i = 0; $i -lt $keysArr.Count; $i++) {
            $ind = $this.edges.Count - 1 - $i
            $key = $keysArr[$ind]
            $this.TopologicalSortUtil($key, $sortedResourceKeys, $visited, $cycles)
        }

        $result = New-Object -TypeName 'System.Collections.Arraylist'

        foreach ($resKey in $sortedResourceKeys) {
            $result.Add($this.Resources[$resKey]) | Out-Null
        }

        return $result.ToArray()
    }

    <#
        .Description
        Uses DFS in order to traverse the graph
    #>
    [void] hidden TopologicalSortUtil(
    [string] $ResKey,
    [System.Collections.Stack] $sortedResourceKeys,
    [System.Collections.Generic.HashSet[string]] $Visited,
    [System.Collections.Generic.HashSet[string]] $Cycles) {
        if ($Cycles.Contains($ResKey)) {
            throw "Cycle detected with key: $ResKey"
        }
    
        if ($Visited.Contains($ResKey)) {
            return
        }
    
        $Visited.Add($ResKey) | Out-Null
        $Cycles.Add($ResKey) | Out-Null 
    
        foreach ($child in $this.Edges[$ResKey]) {
            $this.TopologicalSortUtil($child, $sortedResourceKeys, $visited, $cycles)
        }
    
        $Cycles.Remove($ResKey) | Out-Null
        $SortedResourceKeys.Push($ResKey) | Out-Null
    }

    <#
        .Description
        Fills $Edges ordered dictionary from $Resources ordered dictionary
    #>
    [void] hidden FillEdges() {
        # adjecency list representing dependencies between resources
        $this.Edges = [ordered]@{}

        # initialize lists
        foreach ($key in $this.Resources.Keys) {
            $children = New-Object -TypeName 'System.Collections.ArrayList'
            $this.Edges[$key] = $children
        }

        # insert dependencies into edges
        foreach ($key in $this.Resources.Keys) {
            if (-not $this.Resources[$key].Property.ContainsKey('DependsOn')) {
                continue
            }

            $dependencies = $this.Resources[$key].Property['DependsOn']

            foreach ($dependency in $dependencies) {
                if (-not $this.Edges.Contains($dependency)) {
                    throw ($Script:DependsOnResourceNotFoundException -f $this.Resources[$key].InstanceName, $dependency)
                }
        
                # remove DependsOn item so that it does not conflict with Invoke-DscResource later on
                $this.Resources[$key].Property.Remove('DependsOn') | Out-Null
        
                $this.Edges[$dependency].Add($key) | Out-Null
            }
        }
    }
}
