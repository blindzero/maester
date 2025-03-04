# Generated on 03/04/2025 09:42:24 by .\build\orca\Update-OrcaTests.ps1

Describe "ORCA" -Tag "ORCA", "ORCA235", "EXO", "Security", "All" {
    It "ORCA235: SPF records is set up for all your custom domains." {
        $result = Test-ORCA235

        if($null -ne $result) {
            $result | Should -Be $true -Because "SPF records is set up for all your custom domains."
        }
    }
}
