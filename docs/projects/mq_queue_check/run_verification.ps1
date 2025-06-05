# Default values
param(
    [string]$QueueList = "SWIFTINQUEUE",
    [string]$QueueManager = "QM1",
    [string]$Delimiter = ","
)

# Paths
$Template = "verify_queue_config.mqsc.template"
$ScriptDir = "scripts"
$LogDir = "output"
$TimeStamp = Get-Date -Format "yyyyMMdd_HHmmss"
$SummaryFile = "$LogDir\summary_report_$TimeStamp.log"

# Ensure directories
New-Item -Path $ScriptDir -ItemType Directory -Force | Out-Null
New-Item -Path $LogDir -ItemType Directory -Force | Out-Null

# Split queue names
$Queues = $QueueList.Split($Delimiter)

# Initialize summary log
@"
IBM MQ Queue Configuration Summary Report
Queue Manager: $QueueManager
Generated: $(Get-Date)
------------------------------------------
"@ | Set-Content -Path $SummaryFile

# Loop through each queue
foreach ($Queue in $Queues) {
    $ScriptFile = "$ScriptDir\verify_${Queue}.mqsc"
    $LogFile = "$LogDir\${Queue}_mq_config_check_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

    Write-Host "🔍 Verifying queue: $Queue"

    # Prepare MQSC file
    Get-Content $Template | ForEach-Object { $_ -replace '\{QUEUE_NAME\}', $Queue } | Set-Content $ScriptFile

    # Run MQSC command in Docker
    docker exec -i ibm-mq runmqsc $QueueManager < $ScriptFile > $LogFile

    # Analyze and write to summary
    Add-Content -Path $SummaryFile -Value "`nQueue: $Queue`n----------------------------------"
    $Issues = Select-String -Path $LogFile -Pattern 'BOQNAME\(\)|BOTHRESH\(0\)|DEFPSIST\(NO\)|MAXDEPTH\(0\)|MAXMSGL\(0\)|DEADQ\(\)'
    if ($Issues) {
        foreach ($issue in $Issues) {
            Add-Content -Path $SummaryFile -Value "⚠️  Potential issue: $($issue.Line)"
        }
    }
    else {
        Add-Content -Path $SummaryFile -Value "✅ No critical issues found"
    }
    Add-Content -Path $SummaryFile -Value "✅ Full log: $LogFile"
}

Write-Host "`n✅ All queue checks completed."
Write-Host "📄 Summary report saved to: $SummaryFile"
