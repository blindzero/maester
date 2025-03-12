<#
.SYNOPSIS
    Safe Links is enabled for emails.

.DESCRIPTION
    Generated on 03/12/2025 10:47:33 by .\build\orca\Update-OrcaTests.ps1

.EXAMPLE
    Test-ORCA236

    Returns true or false

.LINK
    https://maester.dev/docs/commands/Test-ORCA236
#>
function Test-ORCA236{
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    Write-Verbose "Test-ORCA236"
    if(!(Test-MtConnection ExchangeOnline)){
        Add-MtTestResultDetail -SkippedBecause NotConnectedExchange
        return = $null
    }
    if(Test-MtConnection SecurityCompliance){
        $SCC = $true
    } else {
        $SCC = $false
    }

    if(($__MtSession.OrcaCache.Keys|Measure-Object).Count -eq 0){
        Write-Verbose "OrcaCache not set, Get-ORCACollection"
        $__MtSession.OrcaCache = Get-ORCACollection -SCC:$SCC # Specify SCC to include tests in Security & Compliance
    }
    $Collection = $__MtSession.OrcaCache
    $obj = New-Object -TypeName ORCA236
    try { # Handle "SkipInReport" which has a continue statement that makes this function exit unexpectedly
        $obj.Run($Collection)
    } catch {
        Write-Error "An error occurred during ORCA236: $($_.Exception.Message)"
        throw
    } finally {
        if($obj.SkipInReport) {
            Add-MtTestResultDetail -SkippedBecause 'Custom' -SkippedCustomReason 'The statement "SkipInReport" was specified by ORCA.'
        }
    }

    if($obj.CheckFailed) {
        Add-MtTestResultDetail -SkippedBecause 'Custom' -SkippedCustomReason $obj.CheckFailureReason
        return $null
    }elseif(-not $obj.Completed) {
        Add-MtTestResultDetail -SkippedBecause 'Custom' -SkippedCustomReason 'Possibly missing license for specific feature.'
        return $null
    }elseif($obj.SCC -and -not $SCC) {
        Add-MtTestResultDetail -SkippedBecause NotConnectedSecurityCompliance
        return = $null
    }

    $testResult = ($obj.ResultStandard -eq "Pass" -or $obj.ResultStandard -eq "Informational")

    if($testResult){
        $resultMarkdown += "Well done! Safe Links is enabled for emails.`n`n%ResultDetail%"
    }else{
        $resultMarkdown += "The configured settings are not set as recommended.`n`n%ResultDetail%"
    }

    # Return early if we don't need to expand the results
    if (!$obj.ExpandResults) {
        Add-MtTestResultDetail -Result $resultMarkdown.TrimEnd("%ResultDetail%")
        return $testResult
    }

    $passResult = "`u{2705} Pass"
    $failResult = "`u{274C} Fail"
    $skipResult = "`u{1F5C4} Skip"
    $showObject = ""+$obj.CheckType -eq "ObjectPropertyValue"

    $resultDetail = "`n`n"
    if ($showObject) { $resultDetail += "|$($obj.ObjectType)" }
    $resultDetail += "|$($obj.ItemName)|$($obj.DataType)|Result|`n"

    if ($showObject) { $resultDetail += "|-" }
    $resultDetail += "|-|-|-|`n"

    ForEach ($result in $obj.Config) {
        If ($result.ResultStandard -eq "Pass") {
            $objResult = $passResult
        } ElseIf($result.ResultStandard -eq "Informational") {
            $objResult = $skipResult
        } Else {
            $objResult = $failResult
        }
        If ($showObject) { $resultDetail += "|$($result.Object)" }
        $resultDetail += "|$($result.ConfigItem)|$($result.ConfigData)|$objResult|`n"
    }
    $resultMarkdown = $resultMarkdown -replace "%ResultDetail%", $resultDetail

    Add-MtTestResultDetail -Result $resultMarkdown

    return $testResult
}
