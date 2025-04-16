# Generated on 04/16/2025 21:38:23 by .\build\orca\Update-OrcaTests.ps1

Describe "ORCA" -Tag "ORCA", "ORCA.123", "EXO", "Security", "All" {
    It "ORCA.123: Unusual Characters Safety Tips is enabled." {
        $result = Test-ORCA123

        if($null -ne $result) {
            $result | Should -Be $true -Because "Unusual Characters Safety Tips is enabled."
        }
    }
}
