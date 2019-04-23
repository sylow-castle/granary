
#Projファイルと同じディレクトリで打たれることを想定している

#ファイルサーバとかを想定
$RemoteSrc = "Z:\tmp\markdown"
$RemoteDest = "Z:\tmp\html"

#Projファイルにあわせる
$ScrDir = "markdown"
$OutDir = "html"

.\Backups.ps1 -SourceDir $RemoteSrc -Destination $ScrDir -LogDir .\log;
MSBuild.exe .\markdowns.proj -t:Build;
.\Backups.ps1 -SourceDir $OutDir -Destination $RemoteDest -LogDir .\log;
