#Import AZ Module 
Import-module -Name Az

#Connect to Az Account
Connect-AzAccount 

#Define Azure Variable
$vmName = Read-Host -prompt "Enter VM Name"
$ResourceGroup = Read-host -prompt "Enter Resource Group"

#Create Azure Creds 
$adminCreds = Get-Credential -Message "Enter admin Creds"
$location = "westeurope"

#Machines Needed
[int]$vmNumber = Read-Host -prompt "How many machines are needed?"

#Deploy vm
[int]$i
for ($i = 0; $i -lt $vmNumber; $i++ ) {
    
    Write-Host "Creating VM: " ($vmName + $i)
    New-AzVM -Name ($vmName + $i) -ResourceGroupName $ResourceGroup -Credential $adminCreds -Image CentOS -Location $location -openports 22 -Size standard_B1s

    #Creating a public IP if needed

    Write-Host "Creating a public IP for: " $vmName + $i    
    $ip = @{
        Name = ("mypublicip" + $i)
        ResourceGroupName = $ResourceGroup
        Location = $location
        Sku = "Standard"
        AllocationMethod = "Static"
        IPAddressVersion = "IPv4"
        Zone = 1,2
    }
    New-AzPublicIPAddress @ip
    
}




