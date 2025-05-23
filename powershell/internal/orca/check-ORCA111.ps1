# Generated on 04/16/2025 21:38:23 by .\build\orca\Update-OrcaTests.ps1

using module ".\orcaClass.psm1"

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingEmptyCatchBlock', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSPossibleIncorrectComparisonWithNull', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', '')]
param()




class ORCA111 : ORCACheck
{
    <#
    
        CONSTRUCTOR with Check Header Data
    
    #>

    ORCA111()
    {
        $this.Control="ORCA-111"
        $this.Services=[ORCAService]::MDO
        $this.Area="Microsoft Defender for Office 365 Policies"
        $this.Name="Unauthenticated Sender (tagging)"
        $this.PassText="Anti-phishing policy exists and EnableUnauthenticatedSender is true"
        $this.FailRecommendation="Enable unauthenticated sender tagging in Anti-phishing policy"
        $this.Importance="When the sender email address is spoofed, the message appears to originate from someone or somewhere other than the actual source. It is recommended to enable unauthenticated sender tagging in Office 365 Anti-phishing policies. The feature apply a '?' symbol in Outlook's sender card if the sender fails authentication checks."
        $this.ExpandResults=$True
        $this.CheckType=[CheckType]::ObjectPropertyValue
        $this.ObjectType="Antiphishing Policy"
        $this.ItemName="Setting"
        $this.DataType="Current Value"
        $this.ChiValue=[ORCACHI]::Medium
        $this.Links= @{
            "Microsoft 365 Defender Portal - Anti-phishing"="https://security.microsoft.com/antiphishing"
            "Unverified Sender"="https://aka.ms/orca-atpp-docs-12"
            "Recommended settings for EOP and Office 365 Microsoft Defender for Office 365 security"="https://aka.ms/orca-atpp-docs-6"
        }
    }

    <#
    
        RESULTS
    
    #>

    GetResults($Config)
    {

        ForEach ($Policy in $Config["AntiPhishPolicy"])
        {

            $IsPolicyDisabled = !$Config["PolicyStates"][$Policy.Guid.ToString()].Applies
            $EnableUnauthenticatedSender = $($Policy.EnableUnauthenticatedSender)

            $IsBuiltIn = $false
            $policyname = $Config["PolicyStates"][$Policy.Guid.ToString()].Name
            $identity = $($Policy.Identity)
            $enabled = $($Policy.Enabled)

            # Check objects
            $ConfigObject = [ORCACheckConfig]::new()
            $ConfigObject.Object=$policyname
            $ConfigObject.ConfigItem="EnableUnauthenticatedSender"
            $ConfigObject.ConfigData=$EnableUnauthenticatedSender
            $ConfigObject.ConfigDisabled = $Config["PolicyStates"][$Policy.Guid.ToString()].Disabled
            $ConfigObject.ConfigWontApply = !$Config["PolicyStates"][$Policy.Guid.ToString()].Applies
            $ConfigObject.ConfigReadonly=$Policy.IsPreset
            $ConfigObject.ConfigPolicyGuid=$Policy.Guid.ToString()

            If(($enabled -eq $true -and $EnableUnauthenticatedSender -eq $true) -or ($identity -eq "Office365 AntiPhish Default" -and $EnableUnauthenticatedSender -eq $true))
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Pass")
            }
            Else 
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Fail")
            }
            
            # Add config to check
            $this.AddConfig($ConfigObject)

        }

        If($Config["AnyPolicyState"][[PolicyType]::Antiphish] -eq $False)
        {
            $ConfigObject = [ORCACheckConfig]::new()
            $ConfigObject.Object="No Enabled Policies"
            $ConfigObject.ConfigItem="EnableUnauthenticatedSender"
            $ConfigObject.ConfigData="False"
            $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Fail")
            $this.AddConfig($ConfigObject)
        }
    }

}
