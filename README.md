# 📅 FindFridayFindMonthEnd

PowerShell Script: `findFridayandMonthEnd.ps1` 📜
This script updates the header in CSV files and copies them to a different folder based on the current date and day of the week. 🔄

## Usage

### Parameters

- `path1`: The path of the folder containing the CSV files to be updated. 📁
- `path2`: The path of the folder where the updated CSV files will be copied. 📂
- `date`: The date in the format 'yyyy-MM-dd'. If not provided, the current system date will be used. 📆

### Notes

The script assumes that the CSV files have a specific naming convention and are located in the first folder path provided. It also assumes that the updated CSV files will have a specific naming convention and will be copied to the second folder path provided. 📝

The script uses a separate executable file `replaceheader.exe` to update the header in CSV files. 🛠️

### Example

This command updates the header in CSV files in `/home/user/folder1` and copies them to `/home/user/folder2` with an updated name. The date argument is provided as `2022-12-31`. 💻

## License

This script is licensed under the MIT License. 📜
