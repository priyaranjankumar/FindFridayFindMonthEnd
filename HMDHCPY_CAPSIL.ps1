<#
.SYNOPSIS
This script updates the header in CSV files and copies them to a different folder.

.DESCRIPTION
The script takes two folder paths as input arguments. It checks if the first folder path exists and if a date argument is provided in the correct format. If no date argument is provided, it uses the current system date.

If the current date is the last day of the month, the script updates the header in CSV files in the first folder path and copies them to the second folder path with an updated name. If the current day is Friday, the script updates the header in CSV files in the first folder path and copies them to the second folder path with an updated name.

.PARAMETER path1
The path of the folder containing the CSV files to be updated.

.PARAMETER path2
The path of the folder where the updated CSV files will be copied.

.PARAMETER date
The date in the format 'yyyy-MM-dd'. If not provided, the current system date will be used.

.EXAMPLE
./findFridayandMonthEnd.ps1 /home/user/folder1/ /home/user/folder2/ 2022-12-31

This command updates the header in CSV files in /home/user/folder1 and copies them to /home/user/folder2 with an updated name. The date argument is provided as '2022-12-31'.

.NOTES
The script assumes that the CSV files have a specific naming convention and are located in the first folder path provided. It also assumes that the updated CSV files will have a specific naming convention and will be copied to the second folder path provided. The script uses a separate executable file 'replaceheader.exe' to update the header in CSV files.

#>
$path1 = $args[0]
$path2 = $args[1]
# Check if a folder path argument was provided and validate it
if (-not $path1) {
    Write-Host "Path1 not provided"
    Write-Host "Usage: ./findFridayandMonthEnd.ps1 <path1> <path2> <date>"
    return
}

if (-not (Test-Path $path1)) {
    Write-Error "Path '$path1' does not exist."
    return
}
if (-not $path2) {
    Write-Host "Path2 not provided"
    return
}
if (-not (Test-Path $path2)) {
    Write-Error "Path '$path2' does not exist."
    return
}
# If a date argument was provided, Verify it is in the correct format
if ($args[2]) {
    $dateString = $args[2].ToString()
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
Write-Host "Provided Date:" $today
Write-Host "Updated Date for header:"$dateString
$today = $date
    $files = Get-ChildItem -Path $path1 -Filter "*.csv"
    # Iterate over the files in the folder
    foreach ($file in $files) {
        #Updating header in file
        $sw = new-object System.Diagnostics.Stopwatch
        $sw.Start()
        & "./replaceheader.exe" $file.FullName $dateString
        $sw.Stop()
        Write-Host "Header updated in " $sw.Elapsed.TotalSeconds "seconds"  $file.FullName
    }
    $t1 = $today.ToString("yyyyMMdd")
    $ts = "_" + $t1 + "_" + $t1 + "_"

    $files = Get-ChildItem -Path $path1
    if ($file.Name.Length -gt 29) {
        foreach ($file in $files) {
            $ilength = $file.Name.Length - 29
            $elength = 10
            $sfile = $file.Name.Substring(0, $ilength)
            $efile = $file.Name.Substring($file.Name.Length - $elength, $elength)
            $destfile = $path2 + $sfile + $ts + $efile
            if (($destfile.Contains("DL_FL") -or $destfile.Contains("DL_FR"))) {
            write-host "Copied :"$destfile
                Copy-Item $FILE.FullName $destfile
            }
        }
    }