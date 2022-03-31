

Get-ChildItem "D:\OneDrive\" -Recurse -file | select directoryname, Extension -Unique | Export-Csv C:\Temp\Test.csv
