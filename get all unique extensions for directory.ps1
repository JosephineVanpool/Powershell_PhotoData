

Get-ChildItem "D:\OneDrive\Dump" -Recurse -file | select directoryname, Extension -Unique | Export-Csv C:\Temp\Test.csv
