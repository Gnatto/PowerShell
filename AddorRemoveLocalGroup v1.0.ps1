
#Ask for credentials to access servers
$cred = Get-Credential -Message "Please enter the credentials to log into the server"
$GroupArray = @()
$LoopArray = @()
DO 
{
    $Computer = Read-Host "Please enter the server you wish to add or remove a group or user."
    IF(-not(Test-Connection $Computer -Quiet -Count 1 -ErrorAction Continue ))
    {
        Write-Host "$Computer is not reachable(PING) or server name does not exist"
        $repeat = Read-Host "Would you like to look up another server?(Y\N)"
    }
    ELSE   
    { 
        #Local Group object is formatted and placed into an array
        [int]$i = 0
        $GroupChild = [ADSI]"WinNT://$Computer"
        $Groups = $GroupChild.psbase.Children | Where-Object {$_.psbase.schemaClassName -eq "group"}
        ForEach ($Group In $Groups)
        {
            $GroupArray += $Group.Name
            $i++
            $LoopArray += "[$i]Group: " + $Group.Name
        }
        DO    
        {
            #Loop through the list of groups
            $LoopArray
            $input = Read-Host "Please select a group by typing in the corresponding number or type EXIT to cancel"
            IF($input -eq "EXIT")
            {
                $bool = Read-Host "Would you like to look up another local group?[Y/N]"
            }
            ELSE     
            {
                $input = $input - 1
                $localgroup = $GroupArray[$input]
                Try
                {
                    $Members = ($Groups[$input].psbase.Invoke("Members"))
                }
                Catch
                {
                  $input = $input + 1
                  Write-Host "[ERROR] $input is not an option" 
                  $bool = Read-Host "Would you like to look up another local group?[Y\N]"
                  continue
                }
                    #Display the members of a group and type of class
                    ForEach ($Member In $Members)
                    {
                        $Class = $Member.GetType().InvokeMember("Class", 'GetProperty', $Null, $Member, $Null)
                        $Name = $Member.GetType().InvokeMember("Name", 'GetProperty', $Null, $Member, $Null)
                        "Member: $Name ($Class)"
                    }
                DO  
                {
                    #Add or Remove users from the local group selected
                    $adrmOption = Read-Host "Please type ADD if you want to add a member and REMOVE if you want to remove a member or type EXIT to cancel"
                    IF($adrmOption -eq "ADD")
                    { 
                        $addMember = Read-Host "Please enter the name of the user you would like to add or type in EXIT to cancel"
                        IF($addMember -eq "EXIT")
                        {
                           break 
                        }
                        ELSE 
                        {
                            Invoke-Command -ComputerName $Computer -Credential $cred -ScriptBlock {
                                net localgroup $Using:localgroup $Using:addMember /add
                            }
                        }
                    }
                    ELSEIF($adrmOption -eq "REMOVE") 
                    {
                        $removeMember = Read-Host "Please enter the name of the user you would like to remove or type EXIT to cancel"
                        IF($removeMember -eq "EXIT")
                        {
                            exit
                        }
                        ELSE    
                        {
                            Invoke-Command -ComputerName $Computer -Credential $cred -ScriptBlock {
                                net localgroup $Using:localgroup $Using:removeMember /delete
                            }
                        }
                    }
                } UNTIL($adrmOption -eq "EXIT")
                $bool = Read-Host "Would you like to look up another local group?[Y/N]"
            }
        } WHILE ($bool -eq "Y")
        #Arrays cleared out to go through the loop again
        $GroupArray = $Null
        $LoopArray = $Null
        $repeat = Read-Host "Would you like to look up another server?(Y\N)"
    }
} WHILE ($repeat -eq "Y")


