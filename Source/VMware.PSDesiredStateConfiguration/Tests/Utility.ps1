<#
    .Description
    Performs an assert on two [VmwDscResource] objects to check if they're equal
#>
function Script:AssertResourceEqual {
    param (
        [VmwDscResource]
        $resultRes,

        [VmwDscResource]
        $expectedRes
    )
    
    # assert regular properties
    $resultRes.InstanceName | Should -Be $expectedRes.InstanceName
    $resultRes.ModuleName | Should -Be $expectedRes.ModuleName
    $resultRes.ResourceType | Should -Be $expectedRes.ResourceType

    $resultRes.Property.Keys.Count | Should -Be $expectedRes.Property.Keys.Count

    # assert key value pairs in 'Property' property are equal
    foreach ($key in $resultRes.Property.Keys) {
        $resultResPropVal = $resultRes.Property[$key]

        $isKeyContained = $expectedRes.Property.ContainsKey($key)
        $isKeyContained | Should -Be $true

        $resultResPropVal | Should -Be $expectedRes.Property[$key]
    }

    $resultRes.GetIsComposite() | Should -Be $expectedRes.GetIsComposite()

    if ($resultRes.GetIsComposite()) {
        $resultResInnerRes = $resultRes.GetInnerResources()
        $expectedResInnerRes = $expectedRes.GetInnerResources()

        $resultResInnerRes.Count | Should -Be $expectedResInnerRes.Count

        for ($j = 0; $j -lt $resultResInnerRes.Count; $j++) {
            # assert inner Resources equal
            Script:AssertResourceEqual $resultResInnerRes[$j] $expectedResInnerRes[$j]
        }
    } else {
        $resultRes.GetInnerResources() | Should -Be $null
    }
}

<#
    .Description
    Performs an assert on two [VmwDscConfiguration] objects to check if they're equal
#> 
function Script:AssertConfigurationEqual {
    param (
        [VmwDscConfiguration]
        $result,

        [VmwDscConfiguration]
        $expected
    )

    # assert regular properties
    $result.InstanceName | Should -Be $expected.InstanceName
    $result.Resources.Count | Should -Be $expected.Resources.Count

    for ($i = 0; $i -lt $result.Resources.Count; $i++) {
        # assert resources array of configuration
        Script:AssertResourceEqual $result.Resources[$i] $expected.Resources[$i]
    }
}
