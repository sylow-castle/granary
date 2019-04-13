Write-Host 'コマンド"msbuild"が使えるか確認します…';
if((Get-Command -CommandType All | Where-Object {$_.Name -like "msbuild.exe"} | Measure-Object).Count -ne 0) {
    Write-Host "msbuildは使用可能です。";
    exit;
} else {
    Write-Host "msbuildは使えません。探します。";
}

$require_verion = @{Major=4;Minor=0};

$latest_msbuild = $null;
Get-ChildItem -Recurse -File -Path 'C:\Windows\Microsoft.NET\Framework64' | 
    Where-Object {$_.Name -like '*msbuild.exe'} |
    ForEach-Object { Write-Output @{FullName=$_.FullName; Command=($_.FullName + " /version")} } |
    ForEach-Object {
        $_.Version = $(Invoke-Expression $_.Command | Where-Object {$_ -like "[0-9].[0-9]*"});
        $_;
    } |
    ForEach-Object {  
        $arr = $_.Version -split "\.";
        $_.Major = [int]$arr[0];
        $_.Minor = [int]$arr[1];
        Write-Output $_;
    } |
    Where-Object { ($_.Major -ge $require_verion.Major) -and ($_.Minor -ge $require_verion.Minor)} | 
    Sort-Object -Property Major, Minor |
    Select-Object -First 1 | 
    Set-Variable latest_msbuild;
if($null -eq $latest_msbuild) {
    Write-Host "対応しているMSbuildが見つかりませんでした。"
    exit;
} else {
    Write-Host "対応しているMSbuildが見つかりました。"
}

Write-Host $latest_msbuild.FullName;
$msbuild = Get-Item -LiteralPath $latest_msbuild.FullName;
$msbuild.DirectoryName;
[string]$response = Read-Host -Prompt ($msbuild.DirectoryName + " への Path（ユーザー環境変数）を通しますか？(Yes/No):");
if(($response -like "yes") -or ($response -like "y")) {
    $env_path = [System.Environment]::GetEnvironmentVariable('Path'); 
    $msbuild = Get-Item -LiteralPath $latest_msbuild.FullName;
    $env_path += [System.IO.Path]::PathSeparator + $msbuild.DirectoryName + [System.IO.Path]::DirectorySeparatorChar;
    [System.Environment]::SetEnvironmentVariable('Path', $env_path, [System.EnvironmentVariableTarget]::User);
    Write-Host "環境変数Pathを変更しました。msbuildを使用するにはPowershellを再起動してください。"
} else {
    Write-Host "環境変数Pathはそのままです。"
}
