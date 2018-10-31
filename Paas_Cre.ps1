$vdir=@("/Shiptech10.Api.Admin","/Shiptech10.Api.BusinessAlerts",
"/Shiptech10.Api.Claims","/Shiptech10.Api.Contracts",
"/Shiptech10.Api.Delivery","/Shiptech10.Api.Hangfire",
"/Shiptech10.Api.ImportExport","/Shiptech10.Api.Infrastructure",
"/Shiptech10.Api.Integration","/Shiptech10.Api.Invoice",
"/Shiptech10.Api.Labs","/Shiptech10.Api.Mail",
"/Shiptech10.Api.Masters","/Shiptech10.Api.Procurement",
"/Shiptech10.Api.Recon","/Shiptech10.Api.SellerRating",
"/Shiptech10.Workflow"
)
$pdir=@("site\wwwroot\Shiptech10.Api.Admin","site\wwwroot\Shiptech10.Api.BusinessAlerts",
"site\wwwroot\Shiptech10.Api.Claims","site\wwwroot\Shiptech10.Api.Contracts",
"site\wwwroot\Shiptech10.Api.Delivery","site\wwwroot\Shiptech10.Api.Hangfire",
"site\wwwroot\Shiptech10.Api.ImportExport","site\wwwroot\Shiptech10.Api.Infrastructure",
"site\wwwroot\Shiptech10.Api.Integration","site\wwwroot\Shiptech10.Api.Invoice",
"site\wwwroot\Shiptech10.Api.Labs","site\wwwroot\Shiptech10.Api.Mail",
"site\wwwroot\Shiptech10.Api.Masters","site\wwwroot\Shiptech10.Api.Procurement",
"site\wwwroot\Shiptech10.Api.Recon","site\wwwroot\Shiptech10.Api.SellerRating",
"site\wwwroot\Shiptech10.Workflow")
$spvdir=@("/Shiptech10.Api.SellerPortal")
$sppdir=@("site\wwwroot\Shiptech10.Api.SellerPortal")
$AppSeriveName = "Sheik-app-plan"
$Location="westus"
$resourceGroupName="sheik-rg-test1"
$size="Standard"
$webappnameapi="Sheik-web-api"
$webappnamesp="sheik-web-sp"
$webappnameui="Sheik-web-ui"
$AzureSqlServerNameLowerCase="sheik-sql-svr"
$Airtelip="182.76.145.162"
$Tataip="182.156.199.106"
$dbname=@("Sheik-wf","Sheik-tenent","sheik-Prime")
$dbsize=@("S1","S0","S0")
New-AzureRmAppServicePlan -Name $AppSeriveName -Location $Location -ResourceGroupName $resourceGroupName -Tier $size

New-AzureRmWebApp -Name $webappnameapi -Location $location -AppServicePlan $AppSeriveName -ResourceGroupName $resourceGroupName
 
Set-AzureRmWebApp -Name $webappnameapi -ResourceGroupName $resourceGroupName -Use32BitWorkerProcess $False

Set-AzureRmWebApp -Name $webappnameapi -ResourceGroupName $resourceGroupName -WebSocketsEnabled $true

$website = Get-AzureRmWebApp -Name $webappnameapi -ResourceGroupName $resourceGroupName 
$website.SiteConfig.AlwaysOn=$true
$website | Set-AzureRmWebApp
For($i=0;$i -lt $vdir.Count;$i++)
{
$va=$va+$i
$VD = New-Object Microsoft.Azure.Management.WebSites.Models.VirtualApplication
  $VD.VirtualPath=$vdir[$i]
  $VD.PhysicalPath=$pdir[$i]
  $VD.PreloadEnabled="Yes"
  $website.SiteConfig.VirtualApplications.Add($VD)
  $website|Set-AzureRmWebApp  
  }
New-AzureRmWebApp -Name $webappnamesp -Location $location -AppServicePlan $AppSeriveName -ResourceGroupName $resourceGroupName
$website = Get-AzureRmWebApp -Name $webappnamesp -ResourceGroupName $resourceGroupName 
For($i=0;$i -lt $spvdir.Count;$i++)
{
$va=$va+$i
$VD = New-Object Microsoft.Azure.Management.WebSites.Models.VirtualApplication
  $VD.VirtualPath=$spvdir[$i]
  $VD.PhysicalPath=$sppdir[$i]
  $VD.PreloadEnabled="Yes"
  $website.SiteConfig.VirtualApplications.Add($VD)
  $website|Set-AzureRmWebApp  
  
}

New-AzureRmWebApp -Name $webappnameui -Location $location -AppServicePlan $AppSeriveName -ResourceGroupName $resourceGroupName
New-AzureRmSqlServer -ResourceGroupName $resourceGroupName -ServerName $AzureSqlServerNameLowerCase -Location $Location -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "saadmin", $(ConvertTo-SecureString -String "pass@123" -AsPlainText -Force))
New-AzureRmSqlServerFirewallRule -ResourceGroupName $resourcegroupname -ServerName $AzureSqlServerNameLowerCase -FirewallRuleName "Airtel-IP" -StartIpAddress $Airtelip -EndIpAddress $Airtelip
New-AzureRmSqlServerFirewallRule -ResourceGroupName $resourcegroupname -ServerName $AzureSqlServerNameLowerCase -FirewallRuleName "Tata-IP" -StartIpAddress $Tataip -EndIpAddress $Tataip

For($i=0;$i -lt $dbname.Count;$i++)
{

New-AzureRmSqlDatabase  -ResourceGroupName $resourcegroupname -ServerName $AzureSqlServerNameLowerCase -DatabaseName $dbname[$i] -RequestedServiceObjectiveName $dbsize[$i]
}

