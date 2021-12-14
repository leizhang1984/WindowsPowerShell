#set csv file path,
#CSV file column header is username
$csvpath = "D:\WVD\users.csv"

#set folder path you need to create
$folderpath = "D:\WVD\"

#Start to Process CSV File
$p = Import-Csv -Path $csvpath

foreach ($rows in $p)
{
        try
        {
               #delete the last \ in folder path
               if($folderpath.EndsWith("\"))
               {
                   $folderpath = $folderpath.Substring(0,$folderpath.Length-1)
               }
               
               #creat folder
               $username = $rows.username
               $newuserfolder = $folderpath + "\" + $username
               New-Item -Path $newuserfolder -ItemType directory 

               #user id
               $userid = $domain + "\" + $username

               #SET File Share
               New-SmbShare -Name $username -Path $newuserfolder

               #SET Access
               Grant-SmbShareAccess -Name $username -AccountName $userid -AccessRight Full -Force
        }
        Catch
        {
                Write-Error "Processing with a Error, Resume Next"
        }
}


Write-Output "Processing Finish"