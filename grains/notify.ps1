function ToastNotify([string]$label) {
    #参考
    # ドライブ空き容量をチェックしてトースト通知する
    #  http://jasmin.sakura.ne.jp/blog/0259
    # GetTemplateContentメソッド
    #  https://docs.microsoft.com/en-us/uwp/api/windows.ui.notifications.toastnotificationmanager.gettemplatecontent?view=winrt-19041#Windows_UI_Notifications_ToastNotificationManager_GetTemplateContent_Windows_UI_Notifications_ToastTemplateType_

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null;
    $Temp = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText01)

    # なんかPowerShellライクにいけた。
    # https://docs.microsoft.com/en-us/uwp/api/windows.data.xml.dom.xmldocument?view=winrt-19041
    $Temp.GetElementsByTagName("text") | ForEach-Object {$_.InnerText = $label }
    $Toast = [Windows.UI.Notifications.ToastNotification]::new($Temp)

    $PowerShellID = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe';
    $Toast = [Windows.UI.Notifications.ToastNotification]::new($Temp);
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($PowerShellID).Show($Toast)
}


