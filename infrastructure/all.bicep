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
    vnetId: network.outputs.vnetId
    privateLinkSubnetId: network.outputs.privateLinkSubnetId
  }
}

// module functionApp 'Functions/function.bicep' = {
//   name: functionAppName
//   dependsOn: [
//     storage    
//   ]
//   params: {
//     location: location
//     subnetId: network.outputs.paasSubnetId
//     appName: functionAppName
//     planName: '${functionAppName}plan'
//     storageAccountName: storage.outputs.name
//     storageAccountKey: storage.outputs.key
//     appInsightName: '${functionAppName}-ai'
//     resourceTags: resourceTags
//   }
// }
