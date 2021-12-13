#ָ��csv�ļ�·����csv�ļ���һ����������Ϊusername
$csvpath = "D:\WVD\users.csv"

#��Ҫ�����ļ��е�·��
$folderpath = "D:\WVD\"

#Start to Process CSV File
$p = Import-Csv -Path $csvpath

foreach ($rows in $p)
{
        try
        {
               #����ļ���·������б��("\")����ȥ��
               if($folderpath.EndsWith("\"))
               {
                   $folderpath = $folderpath.Substring(0,$folderpath.Length-1)
               }
               
               #creat folder
               $username = $rows.username
               $newuserfolder = $folderpath + "\" + $username
               New-Item -Path $newuserfolder -ItemType directory 

               #SET ACL
               #Domain Name
               $domain = "FAREAST"

               #user id
               $userid = $domain + "\" + $username

               $inheritanceFlag = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
               $propagationFlag = [System.Security.AccessControl.PropagationFlags]::None
               $type = [System.Security.AccessControl.AccessControlType]::Allow

               $ace = New-Object System.Security.AccessControl.FileSystemAccessRule($userid,"FullControl",$inheritanceFlag, $propagationFlag,$type)

               $ACL.AddAccessRule($ace)
               $acl = Get-Acl $newuserfolder
               $acl.SetAccessRule($ace)
               Set-Acl $newuserfolder $acl
        }
        Catch
        {
                Write-Error "Processing with a Error, Resume Next"
        }
}


Write-Output "Processing Finish"