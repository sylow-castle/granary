function ClipImageToBase64() {
    Param(
        [string]
        [ValidateSet('base64', 'Markdown', 'dataURI')]
        $Format = 'base64',
        [switch]
        $Clip
    )   
    $image = Get-Clipboard -Format Image;
    $ms = New-Object -TypeName System.IO.MemoryStream;
    $image.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png);
    
    $encoded = [System.Convert]::ToBase64String($ms.GetBuffer());
    $image.Dispose();
    $ms.Dispose();

    switch ($format) {
        'base64' {
            $dataUri = $encoded;
        }
        'dataURI' {
            $dataUri = "data:image/png;base64," + $encoded;
        }
        'Markdown' {
            $dataUri = "![](data:image/png;base64," + $encoded + ")";
        }
    }

    if($Clip) {
        $dataUri | Set-Clipboard
    }
}