Param($SourceDir, $Destination, $LogDir = "", $IPG = 100, [switch]$DryRun, [switch]$Debug);

#引数バリデーション
#コピー元ない
if(!(Test-Path $SourceDir -PathType Container)) {
    exit;
} 
$src = Get-Item $SourceDir;

#コピー先なければ作る
if(!(Test-Path $Destination -PathType Container)) {
    New-Item -Path $Destination -ItemType Directory
    if(!(Test-Path $Destination -PathType Container)) {
        exit;
    }
}
$dest = Get-Item $Destination;

#ログ出力するのに指定されたログディレクトリが不正
if(($LogDir -ne "") -and !(Test-Path -PathType Container -LiteralPath $LogDir)) {
    exit;
}
$logs = Get-Item $LogDir

Filter Enclose($string) {
    ('"' + $string + '"')
}

# robocopyのオプション設定
$commonOpts = "/MIR /R:3 /NP /XJD /XJF /DCOPY:DAT";
if($DryRun) {
    $dryOpt = "/L "
} else {
    $dryOpt = ""
}

if($LogDir -eq "") { 
    $logOpts = "/NDL";
} else {
    $LogName = "BackUpScript_Log_$(Get-Date -Format 'yyyy-MMdd-HHmmss').log"
    $logPath =  $logs.FullName + '\' +$LogName;
    $logOpts = "/LOG:" + (Enclose $logPath) + " /TEE /NDL" ;
}

$command = @('robocopy',(Enclose $src.FullName), (Enclose $dest.FullName) ,("/IPG:${IPG}"), $commonOpts, $logOpts, $dryOpt) -join ' ';
if($Debug) {
    Write-Host $command;
} else {
    Invoke-Expression $command;
}

