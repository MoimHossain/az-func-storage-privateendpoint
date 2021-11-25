param location string = resourceGroup().location
param resourceTags object = {
  Application: 'Vulture'
  CostCenter: 'Az-Sales'  
  Environment: 'Development'
  Owner: 'Moim.Hossain@microsoft.com'
}

var functionAppName = 'vulfumsft001'
var vnetName = 'vulture-vnet'
var storageAcountName = 'vsa${uniqueString(resourceGroup().name)}'
var functionContentShareName = 'func-contents'


module network 'network/vnet.bicep' = {
  name: vnetName
  params: {
    resourceTags: resourceTags
    vnetName: vnetName
    location: location
  }
}


module storage 'storage/storage.bicep' = {
  name: storageAcountName
  params: {
    resourceTags: resourceTags
    location: location
    name: storageAcountName
    fileShareName: functionContentShareName
    vnetId: network.outputs.vnetId
    privateLinkSubnetId: network.outputs.privateLinkSubnetId
  }
}

module functionApp 'Functions/function.bicep' = {
  name: functionAppName
  dependsOn: [
    storage    
  ]
  params: {
    appName: functionAppName
    planName: '${functionAppName}plan'
    location: location    
    subnetId: network.outputs.paasSubnetId
    storageAccountName: storage.outputs.name
    storageAccountKey: storage.outputs.key
    contentShareName: functionContentShareName
    appInsightName: '${functionAppName}-ai'
    resourceTags: resourceTags
  }
}
