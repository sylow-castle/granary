using namespace Windows.UI.Notifications;
using namespace Windows.Data.Xml.Dom;

# 元ネタ：https://qiita.com/magiclib/items/12e2a9e1e1e823a7fa5c
function ShowToast {
    [CmdletBinding()]
    PARAM (
        [Parameter(Mandatory=$true)][String] $title,
        [Parameter(Mandatory=$true)][String] $message1,
        [Parameter(Mandatory=$true)][String] $message2
    )

    #WinRTからのクラスロード
    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

    $appId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
    $icon = "file:///C:/Users/weakhold/Documents/GitHub/granary/grains/instinct_yellow.png";
    $content = @"
<?xml version="1.0" encoding="utf-8"?>
<toast>
    <visual>
        <binding template="ToastGeneric">
            <image placement="appLogoOverride" src="$($icon)" />
            <text>$($title)</text>
            <text>$($message1)</text>
            <text>$($message2)</text>
        </binding>
    </visual>
</toast>
"@
    $xml = New-Object XmlDocument
    $xml.LoadXml($content)
    $toast = New-Object ToastNotification $xml
    [ToastNotificationManager]::CreateToastNotifier($appId).Show($toast)
}