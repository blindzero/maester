﻿<#
.SYNOPSIS
    Checks if the default common attadchment types filter is enabled

.DESCRIPTION
    The common attachment types fileter should be enabled

.EXAMPLE
    Test-MtCisAttachmentFilter

    Returns true if the common attachment types filter is enabled.

.LINK
    https://maester.dev/docs/commands/Test-MtCisAttachmentFilter
#>
function Test-MtCisAttachmentFilter {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    if (!(Test-MtConnection ExchangeOnline)) {
        Add-MtTestResultDetail -SkippedBecause NotConnectedExchange
        return $null
    }
    elseif (!(Test-MtConnection SecurityCompliance)) {
        Add-MtTestResultDetail -SkippedBecause NotConnectedSecurityCompliance
        return $null
    }
    elseif ($null -eq (Get-MtLicenseInformation -Product Mdo)) {
        Add-MtTestResultDetail -SkippedBecause NotLicensedMdo
        return $null
    }

    Write-Verbose "Getting Malware Filter Policy..."
    $policy = Get-MtExo -Request MalwareFilterPolicy

    Write-Verbose "Executing checks"
    $fileFilter = $policy | Where-Object {
        $_.EnableFileFilter
    }

    $testResult = ($fileFilter | Measure-Object).Count -ge 1

    $portalLink = "https://security.microsoft.com/presetSecurityPolicies"

    if ($testResult) {
        $testResultMarkdown = "Well done. Your tenant has the common attachment file filter enabled ($portalLink).`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "Your tenant does not have the common attachment file filter enabled ($portalLink).`n`n%TestResult%"
    }

    $resultMd = "| Policy | Result |`n"
    $resultMd += "| --- | --- |`n"

    if ($testResult) {
        $Result = "✅ Pass"
    }
    else {
        $Result = "❌ Fail"
    }

    $resultMd += "| EnableFileFilter | $Result |`n"

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $resultMd

    Add-MtTestResultDetail -Result $testResultMarkdown

    return $testResult
}