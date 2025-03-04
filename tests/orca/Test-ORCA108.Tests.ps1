# Generated on 03/04/2025 09:42:23 by .\build\orca\Update-OrcaTests.ps1

Describe "ORCA" -Tag "ORCA", "ORCA108", "EXO", "Security", "All" {
    It "ORCA108: DKIM signing is set up for all your custom domains." {
        $result = Test-ORCA108

        if($null -ne $result) {
            $result | Should -Be $true -Because "DKIM signing is set up for all your custom domains."
        }
    }
}
