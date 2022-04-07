#trying https://www.thomasmaurer.ch/2015/03/move-files-to-folder-sorted-by-year-and-month-with-powershell/
# https://github.com/monahk/SortPhotos/blob/master/SortPhotos.ps1

function Get-DateTaken {
  param (
    [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [Alias('FullName')]
    [String]
    $Path
  )

  begin{
    $shell = New-Object -COMObject Shell.Application
  }

  process{
      $returnvalue = 1 | Select-Object -Property DateTaken
      $Name = Split-Path $path -Leaf
      $Folder = Split-Path $path
      $shellfolder = $shell.Namespace($Folder)
      $shellfile = $shellfolder.ParseName($Name)
      $DateTaken = $shellfolder.GetDetailsOf($shellfile, 12)   
 
      if ($DateTaken -eq ''){
          'Empty'
      }
      else{
          $DateTaken = $DateTaken -Replace([char]8206, '')
          $DateTaken = $DateTaken -Replace([char]0, '')
          $DateTaken = $DateTaken -Replace([char]8207, '')
      
          $returnvalue.DateTaken = $DateTaken
     
          [datetime]$returnvalue.DateTaken
      }
  }
}

# Get the files which should be moved, without folders
$files = Get-ChildItem 'C:\Users\Josie Vanpool\Desktop\Test\Test to sort' -Recurse | where {!$_.PsIsContainer}
 
# List Files which will be moved
#$files
 
# Target Filder where files should be moved to. The script will automatically create a folder for the year and month.
$targetPath = 'C:\Users\Josie Vanpool\Desktop\Test\Test Sorted'
 
foreach ($file in $files){

#this does work
 # Get year and Month of the file
 # I used LastWriteTime since this are synced files and the creation day will be the date when it was synced
 #$year = $file.LastWriteTime.Year.ToString()
 #$month = $file.LastWriteTime.Month.ToString()
 
$DateTaken = Get-DateTaken $file.FullName  


#try to use DateTaken first, otherwiae use last write time
If($DateTaken -ne 'Empty'){
    $year = $DateTaken.Year
    $month= $DateTaken.Month
  } 
  Else {
   $year = $file.LastWriteTime.Year.ToString()
   $month = $file.LastWriteTime.Month.ToString()
  }

 
# Set Directory Path
$Directory = $targetPath + "\" + $year + "\" + $month
# Create directory if it doesn't esist
if (!(Test-Path $Directory)){
New-Item $directory -type directory
}
 
# Move File to new location
$file | Move-Item -Destination $Directory
}