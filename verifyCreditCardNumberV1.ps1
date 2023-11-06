$path1 = $args[0]
# Check if a folder path argument was provided and validate it
if (-not $path1) {
    Write-Host "File Path not provided"
    Write-Host "Usage: ./verifyCreditCardNumberV1.ps1 <path1>"
    return
}

if (-not (Test-Path $path1)) {
    Write-Error "File Path '$path1' does not exist."
    return
}
$fileContent=Get-Content -Path $path1
foreach($line in $fileContent){
    $substring=$line.Substring(11,16)
    if($substring -as [int64]){
        $number = [int64]$substring
        if($number -gt 999999){
            Write-Host "Correct Credit Card Number"
        }
        else {
             
            Write-Error "Wrong Credit Card Number"
            return
        }
    }
    else{
        
        Write-Error "Wrong Credit Card number"
        return
    }
}





