Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

$URL = *****
$Port = ***
$Username = *****
$password = *******

## Logging ##
$LogFile = "FTPLog_$(Get-Date -Format "yyyy-MM-dd").txt"
$LogPath = *Local Path*
$FullLogFilePath = Join-Path -Path $LogPath -ChildPath $LogFile

Clear-Variable TestError -Force
Clear-Variable TestInformation -Force
Clear-Variable TestWarning -Force

function LogToFile{
    param (
        $FilePath = $FullLogFilePath,
        $Message
    )
    if(!(Test-Path -Path $FilePath)){
        Set-Content -Path $FilePath -Value "FTP Log File "
    }
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "$TimeStamp - $Message"
    Add-Content -Path $FilePath -Value $LogEntry
}

try{
    
    Start-Transcript -Path $FullLogFilePath -Append -NoClobber
    
    Test-NetConnection `
        -ComputerName $url `
        -Port $Port `
        -ErrorVariable +TestError `
        -ErrorAction Continue `
        -WarningVariable +TestWarning `
        -WarningAction Continue `
        -InformationVariable +TestInformation `
        -InformationLevel Detailed `
        -Verbose 

    Stop-Transcript
    
    if ($TestError -ne $null){
        LogToFile -Message "ErrorVariable: $($NewTestError)"
    } 
    
    if ($TestWarning -ne $null){
        LogToFile -Message "WarningVariable: $($TestWarning)"
    }
    
    if ($TestInformation -ne $null){
        LogToFile -Message "InformationVariable: $($TestInformation)"
    }
}
catch{
    LogToFile -Message "Exception Message: $($_.Exception.Message)"
    LogToFile -Message "StackTrace: $($_.ScriptStackTrace)"
}
