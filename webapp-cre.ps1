$AppSeriveName = "Sheik-app-plan"
$Location="westus"
$resourceGroupName="sheik-rg-test1"
$size="b1"
$webappnameapi="Sheik-webapp1"

New-AzureRmAppServicePlan -Name $AppSeriveName -Location $Location -ResourceGroupName $resourceGroupName -Tier $size

New-AzureRmWebApp -Name $webappnameapi -Location $location -AppServicePlan $AppSeriveName -ResourceGroupName $resourceGroupName
 
Set-AzureRmWebApp -Name $webappnameapi -ResourceGroupName $resourceGroupName -Use32BitWorkerProcess $False

Set-AzureRmWebApp -Name $webappnameapi -ResourceGroupName $resourceGroupName -WebSocketsEnabled $true

$website = Get-AzureRmWebApp -Name $webappnameapi -ResourceGroupName $resourceGroupName 
$website.SiteConfig.AlwaysOn=$true
$website | Set-AzureRmWebApp

$VDApp1 = New-Object Microsoft.Azure.Management.WebSites.Models.VirtualApplication 
$VDApp1.VirtualPath = "/Shiptech10.Api.Admin"
$VDApp1.PhysicalPath = "site\wwwroot\Shiptech10.Api.Admin"
$VDApp1.PreloadEnabled ="YES"
$website.siteconfig.VirtualApplications.Add($VDApp1) 
$website | Set-AzureRmWebApp
