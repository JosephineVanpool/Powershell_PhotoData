
#get created date time from a .jpg file (date taken)
#get date created datetime from a .jpg file (created time)
#get last modified datetime from a .jpg file (date modified)

##Defining function Get-DateTaken that will get the Date Taken of a JPG file
function Get-DateTaken
{
##Define Parameters of this function 
  param
  (
##This will allow the function to be compatible to use in a Pipeline
    [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [String]
    $Path
  )
   
  begin
 {
     $shell = New-Object -COMObject Shell.Application
  }
   
  process
  {
    $FileProperties = 1 | Select-Object -Property Name, DateTaken, Folder
    $FileProperties.Name = Split-Path $path -Leaf
    $FileProperties.Folder = Split-Path $path
    $shellfolder = $shell.Namespace($FileProperties.Folder)
    $shellfile = $shellfolder.ParseName($FileProperties.Name)
    $FileProperties.DateTaken = $shellfolder.GetDetailsOf($shellfile, 12)
    $FileProperties
  }
}
 
##Define the path of the photos
$Path = "C:\Users\Josie Vanpool\Desktop\Test\Test to sort"
##To get all the .JPG files from the folder specified
$Files = Get-ChildItem $Path "*.jpg"

Foreach($File in $Files){
    #$FilePath = $Path + "\" + $File.name
    $DateTaken = Get-ChildItem $Path\$File | Get-DateTaken
    return $DateTaken
}


