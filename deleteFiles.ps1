$path1 = $args[0]
# Check if a folder path argument was provided and validate it
if (-not $path1) {
    Write-Host "Path1 not provided"
    Write-Host "Usage: ./deleteFiles.ps1 <path1> <date>"
    return
}

if (-not (Test-Path $path1)) {
    Write-Error "Path '$path1' does not exist."
    return
}
# If a date argument was provided, Verify it is in the correct format
if ($args[1]) {
    $dateString = $args[1].ToString()
    $format = "dd-MM-yyyy"
    $date = [DateTime]::MinValue
    if ([DateTime]::TryParseExact($dateString, $format, $null, [System.Globalization.DateTimeStyles]::None, [ref]$date)) {
        # If the date is valid, use it
        Write-Host "Valid date: $($date.ToString($format))"
        $dateString = $date.ToString("yyyy-MM-dd")
    }
    else {
        # If the date is invalid, stop the script
        Write-Host "Error: Invalid date argument provided. Please use the format 'dd-MM-yyyy'."
        return
    }
}
# If no date argument was provided, use the current system date
else {
    $date = Get-Date
    $dateString = $date.ToString("yyyy-MM-dd")
    Write-Host "No date argument was provided, using the current system date." $dateString
}

$today = $date
$lastDayOfMonth = ((Get-Date -Day 1 -Month $today.Month -Year $today.Year).AddMonths(1).AddDays(-1)).Day
if ($today.Day -eq $lastDayOfMonth) {
    Write-Host "Today is the last day of the month. Deleting Monthnly files"
    $files = Get-ChildItem -Path $path1
    
        foreach ($file in $files) {
            if ($file.FullName.Contains("_QL_") -or ($file.FullName.Contains("_ML_"))) {
            write-host "Deleted :"$file   
                Remove-Item $FILE.FullName 
            }
        }

}
else {
    Write-Host "Today is not the last day of the month. No Monthy Files Deleted"
}
# Check for Friday
$day = $today.DayOfWeek

if ($day -eq "Friday") {
    Write-Host "Today is Friday. Deleting Weekly Files"
    $files = Get-ChildItem -Path $path1
    foreach ($file in $files) {

            if ($file.Name.Contains("CAPSIL") -And ($file.Name.Contains("_WL_"))) {
            write-host "Deleted :"$file
            Remove-Item $FILE.FullName
            }
        
    }
}
else {
    Write-Output "Today is not Friday. No Weekly Files Deleted"
}
