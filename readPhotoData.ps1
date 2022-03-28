
#get created date time from a .jpg file (date taken)
#get date created datetime from a .jpg file (created time)
#get last modified datetime from a .jpg file (date modified)

#Defining function Get-DateTaken that will get the Date Taken of a JPG file
function Get-DateTaken
{
#Define Parameters of this function 
  param
  (
#This will allow the function to be compatible to use in a Pipeline
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
 
#Define the path of the photos
$Path = "D:\OneDrive\Pictures (camera roll)\Test to sort"
#To get all the .JPG files from the folder specified
$Files = Get-ChildItem $Path "*.jpg"
#Define a counter to name Photos taken on the same date with the Counter following the date.  
#For example 02-02-2021.JPG, 02-02-2021-1.JPG, 02-02-2021-2.JPG
#$Counter = 1
Foreach($File in $Files){
    $FilePath = $Path + "\" + $File.name
    $DateTaken = Get-ChildItem $Path\$File | Get-DateTaken

    return $DateTaken
   
   #I don't want to to rename my files, just get date taken
   #region  #The DateTaken has a format of mm/DD/yyyy.  The '/' will throw an error because it is part of a path.  
    #we will replace the '/' with a '-'
   # $NewName = ($DateTaken.DateTaken.substring(0,$DateTaken.DateTaken.IndexOf(' '))).replace('/','-') + ".jpg"
   # If(-Not(Test-Path $Path\$NewName)){
   #     Rename-Item -Path $FilePath -NewName $NewName
   #     Write-Progress "$FilePath has been renamed to $NewName."
    #}
    #Else{
    #    $NewName = ($DateTaken.DateTaken.substring(0,$DateTaken.DateTaken.IndexOf(' '))).replace('/','-') + "-" + $counter + ".jpg"
    #    Rename-Item -Path $FilePath -NewName $NewName
    #    Write-Progress "$FilePath has been renamed to $NewName."
    #    $Counter = $Counter + 1
   # }
}



