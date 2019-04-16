Param($Path, $TargetPth);


if(!(Test-Path $Path)) {
    New-Item $Path -ItemType File
}

"<style>" |Out-String |  %{[Text.Encoding]::UTF8.GetBytes($_)} | Set-Content -Path $TargetPth -Encoding Byte -Force
Get-Content -Path $Path -Encoding UTF8 | Out-File -Append -FilePath $TargetPth -Encoding utf8
"</style>" | Out-File -Append -FilePath $TargetPth -Encoding utf8