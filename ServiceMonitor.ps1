function Write-Alert([string]$Alert) {
    Write-Host "<-Start Result->"
    Write-Host "Service="$Alert
    Write-Host "<-End Result->"
}

# $list = "alg, bits, cphs, dps; efs, cagservice; snmptrap" 

$services = @()
$exitCode = 0

$Env:List -split ',\s*|;\s*' | ForEach-Object {
    $services += Get-Service $_ -ErrorAction SilentlyContinue | Where-Object {
        $_.Status -ne 'Running'
    }
}

if ($services.Count -gt 0) {
    Write-Alert "Some services not running"

    Write-Host "<-Start Diagnostic->"
    ForEach ($srv in $services) {
        if ($srv) {
            Write-Host $srv.DisplayName "["$srv.Name"] is " $srv.Status
        }
    }
    Write-Host "<-End Diagnostic->"
    $exitCode = 1
} else {
    Write-Alert "Services running OK"
}

Exit $exitCode