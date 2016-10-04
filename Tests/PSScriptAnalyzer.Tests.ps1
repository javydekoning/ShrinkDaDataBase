#---------------------------------# 
# PSScriptAnalyzer tests          # 
#---------------------------------# 
$Modules = Get-ChildItem “$PSScriptRoot\..\” -Filter ‘*.psm1’ | Where-Object {$_.name -NotMatch ‘Tests.psm’}
$Rules   = Get-ScriptAnalyzerRule | Where-Object {$_.RuleName -notmatch '(PSUseApprovedVerbs)'}

if ($Modules.count -gt 0) {
  Describe ‘PSScriptAnalyzer rule-tests’ {
    foreach ($module in $modules) {
      Context “'$($module.FullName)'” {
        foreach ($rule in $rules) {
          It “passes the PSScriptAnalyzer Rule $rule“ {
            (Invoke-ScriptAnalyzer -Path $module.FullName -IncludeRule $rule.RuleName ).Count | Should Be 0
          }
        }
      }
    }
  }
}