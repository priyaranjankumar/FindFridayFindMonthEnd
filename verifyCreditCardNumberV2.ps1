$path1 = $args[0]
# Check if a folder path argument was provided and validate it
if (-not $path1) {
    Write-Host "File Path not provided"
    Write-Host "Usage: ./verifyCreditCardNumberV2.ps1 <path1>"
    return
}

if (-not (Test-Path $path1)) {
    Write-Error "File Path '$path1' does not exist."
    return
}

function Test-CreditCard {
    param (
        [Parameter(Mandatory=$true)]
        [string]$CardNumber
    )

    $CardNumber = $CardNumber -replace '\D' # remove non-digits

    if ($CardNumber.Length -lt 13 -or $CardNumber.Length -gt 19) {
        return $false
    }

    $checksum = 0
    for ($i = $CardNumber.Length - 1; $i -ge 0; $i--) {
        $digit = [int]::Parse($CardNumber[$i])
        if (($CardNumber.Length - $i) % 2 -eq 0) {
            $digit *= 2
            if ($digit -gt 9) {
                $digit -= 9
            }
        }
        $checksum += $digit
    }

    return ($checksum % 10 -eq 0)
}

$fileContent=Get-Content -Path $path1
foreach($line in $fileContent){
    $substring=$line.Substring(11,16)
    $substring = $substring -replace '\D'
    if($substring -as [int64]){
        if (Test-CreditCard $substring) {
            Write-Host "Correct Credit Card Number"
        } else {
            Write-Error "Wrong Credit Card Number"
            return
        }
    }
    else{
        
        Write-Error "Wrong Credit Card number"
        return
    }
}
