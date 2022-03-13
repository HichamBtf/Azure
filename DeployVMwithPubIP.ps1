#Import AZ Module 
Import-module -Name Az

#Connect to Az Account
Connect-AzAccount 

#Define Azure Variable
$vmName = Read-Host -prompt "Enter VM Name"
$ResourceGroup = Read-host -prompt "Enter Resource Group"

#Create Azure Creds 
$adminCreds = Get-Credential -Message "Enter admin Creds"
$location = "westeurope"    #Change it if Needed 

#Machines Needed
[int]$vmNumber = Read-Host -prompt "How many machines are needed?"

#Deploy vm
for ($i = 1; $i -le $vmNumber; $i++ ) {
    
    Write-Host "Creating VM: " "$vmName$i"
    New-AzVM -Name "$vmName$i" -ResourceGroupName $ResourceGroup -Credential $adminCreds -Image CentOS -Location $location -openports 22 -Size standard_B1s

        #Creating a public IP if needed
        Write-Host "Creating a public IP for: " "$vmName$i"

        $pip = New-AzPublicIpAddress -Name ("mypublicip-" + "$vmName$i") -ResourceGroupName $ResourceGroup -Location $location -AllocationMethod "Static"
        $nic = Get-AzNetworkInterface -ResourceGroupName $ResourceGroup -Name "$vmName$i" 
        $nic.IpConfigurations[0].PublicIpAddress = $pip
        Set-AzNetworkInterface -NetworkInterface $nic
}
#Give Public IP Adresses for each machine + Ending message
Write-Host "Deployment ended. You may now connect to your machines using SSH."
Get-AzPublicIpAddress -Name $vmName* | format-list Name, IpAddress



