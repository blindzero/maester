# Generated on 03/04/2025 09:42:24 by .\build\orca\Update-OrcaTests.ps1

Describe "ORCA" -Tag "ORCA", "ORCA223", "EXO", "Security", "All" {
    It "ORCA223: User impersonation action is set to move to Quarantine." {
        $result = Test-ORCA223

        if($null -ne $result) {
            $result | Should -Be $true -Because "User impersonation action is set to move to Quarantine."
        }
    }
}
