
<#
 # 一つだけ開放すれば他のオブジェクトも自動で開放してくれるような楽なものが欲しい
 #
 #>
function ExcelEnvelope {
    $excel = New-Object -ComObject Excel.Application;
    $com = New-Object COMEnvelope($excel);
    $com.DisplayAlerts = False;
    $com.Quit = {
        $excel.Quit();
    };
    $excel = $null;

    
    return $com;
}

class COMEnvelope {

    #元となるOCMオブジェクト。解放する必要がある。
    [Object] $core
    #COMEnvelopeの保存先
    [Object] $store
    #リリースフラグ
    [boolean] $released;

    [string] $requested = $null;

    COMEnvelope($com) {
        $this.core = $com;
        $this.store = New-Object PSCustomObject;
        $this.released = $false;
        $this.LazyInherit($this, $com);
    }

    LazyInherit($target, $from) {
        $from |
        Get-Member | 
        ? { $_.MemberType -eq "Property"} | 
        % { $name = $_.Name;
            Add-Member -InputObject $this -MemberType NoteProperty -Name $name -Value $null;
        }
    }

    [COMEnvelope] Load($name) {
        $this.LoadPropety($name);
        return $this;
    }

    LoadPropety($name) {
        if(!$this.released) {
            if($this.store.$name -eq $null) {
                Add-Member -InputObject $this.store -MemberType NoteProperty -Name $name -Value $null;

                $com = $this.core.$name;
                $prop = New-Object COMEnvelope($com);
                $this.store.$name = $prop;
                $this.$name = $prop;
                $com = $null;
                $prop = $null; 
            }
        }
    }

    Release() {
        if($this.released) {
            return;
        }

        $target = $this;

        $this.store |
         Get-Member | 
         ? {$_.MemberType -eq "NoteProperty"} | 
         % {$name = $_.Name; $target.$name.Release();};

        $counter = $this.core | Get-Member | ? {$_.MemberType -eq 'Method' -and $_.Name -eq 'Quit'} | Measure-Object;

        if($counter.Count -gt 0) {
            $this.core.Quit();
        }

        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($this.core);
        $this.core = $null;
        $this.released = $true;
    }

    [Object]GetMember() {
        return ($this | Get-Member);
    }
}

# $excel.store | Get-Member | ? {$_.MemberType -eq "NotePropety"} | % {$name = $_.Name; $excel.$name.GetType()}