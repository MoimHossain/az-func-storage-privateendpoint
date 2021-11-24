param location string = resourceGroup().location
param resourceTags object = {
  Application: 'Vulture'
  CostCenter: 'Az-Sales'  
  Environment: 'Development'
  Owner: 'Moim.Hossain@microsoft.com'
}

var vnetName = 'vulture-vnet'
var storageAcountName = 'vsa${uniqueString(resourceGroup().name)}'
var queuePEName = 'queuepep${storageAcountName}'
var queueDnsZoneName = 'queueDnsZone'
var blobPEName = 'blobpep${storageAcountName}'
var blobDnsZoneName = 'blobDnsZone'

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
  }
}

module queueStoragePrivateEndpoint 'network/storagePE.bicep' = {
  name: queuePEName
  params: {
    location: location
    privateEndpointName: queuePEName
    privateDnsZoneName: queueDnsZoneName
    storageAcountName: storageAcountName
    groupId: 'queue'
    resourceTags: resourceTags
    storageAccountId: storage.outputs.storageId
    vnetId: network.outputs.vnetId
    subnetId: network.outputs.privateLinkSubnetId
  }
  dependsOn: [
    storage
  ]
}

module blobStoragePrivateEndpoint 'network/storagePE.bicep' = {
  name: blobPEName
  params: {
    location: location
    privateEndpointName: blobPEName
    privateDnsZoneName: blobDnsZoneName
    storageAcountName: storageAcountName
    groupId: 'blob'
    resourceTags: resourceTags
    storageAccountId: storage.outputs.storageId
    vnetId: network.outputs.vnetId
    subnetId: network.outputs.privateLinkSubnetId
  }
  dependsOn: [
    storage
  ]
}


