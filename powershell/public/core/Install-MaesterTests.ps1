﻿<#
.SYNOPSIS
   Installs the latest ready-made Maester tests built by the Maester team.

.DESCRIPTION
    The Maester team maintains a repository of ready made tests that can be used to verify the configuration of your Microsoft 365 tenant.

    The tests can be viewed at https://github.com/maester365/maester/tree/main/tests

.EXAMPLE
    Install-MaesterTests

    Install the latest set of Maester tests in the current directory.

.EXAMPLE
    Install-MaesterTests -Path .\maester-tests

    Installs the latest Maester tests in the specified directory.
#>

Function Install-MaesterTests {
    [CmdletBinding()]
    param(
        # The path to install the Maester tests to, defaults to the current directory.
        [Parameter(Mandatory = $false)]
        [string] $Path = ".\"
    )

    Write-Verbose "Installing Maester tests to $Path"

    $targetFolderExists = (Test-Path -Path $Path)

    # Check if current folder is empty and prompt user to continue if it is not
    if ($targetFolderExists -and (Get-ChildItem -Path $Path).Count -gt 0) {
        $message = "`nThe folder $Path is not empty.`nWe recommend installing the tests in an empty folder.`nDo you want to continue with this folder? (Y/n)"
        $continue = Get-MtConfirmation $message
        if (!$continue) {
            Write-Host "Maester tests not installed." -ForegroundColor Red
            return
        }
    }

    Update-MtMaesterTests -Path $Path -Install

}
