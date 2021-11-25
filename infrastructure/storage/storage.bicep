param location string
param name string
param resourceTags object 
param vnetId string
param privateLinkSubnetId string

var queuePEName = 'queuepep${name}'
var blobPEName = 'blobpep${name}'
var filePEName = 'filepep${name}'
var tablePEName = 'tablepep${name}'

resource storage 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  location: location
  name: name
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  tags: resourceTags
  properties: {
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false        
  }
}

module queueStoragePrivateEndpoint '../network/storagePE.bicep' = {
  name: queuePEName
  params: {
    location: location
    privateEndpointName: queuePEName
    privateDnsZoneName: 'queueDnsZone'
    storageAcountName: name
    groupId: 'queue'
    resourceTags: resourceTags
    storageAccountId: storage.id
    vnetId: vnetId
    subnetId: privateLinkSubnetId
  }
  dependsOn: [
    storage
  ]
}

module blobStoragePrivateEndpoint '../network/storagePE.bicep' = {
  name: blobPEName
  params: {
    location: location
    privateEndpointName: blobPEName
    privateDnsZoneName: 'blobDnsZone'
    storageAcountName: name
    groupId: 'blob'
    resourceTags: resourceTags
    storageAccountId: storage.id
    vnetId: vnetId
    subnetId: privateLinkSubnetId
  }
  dependsOn: [
    storage
  ]
}

module tableStoragePrivateEndpoint '../network/storagePE.bicep' = {
  name: tablePEName
  params: {
    location: location
    privateEndpointName: tablePEName
    privateDnsZoneName: 'tableDnsZone'
    storageAcountName: name
    groupId: 'table'
    resourceTags: resourceTags
    storageAccountId: storage.id
    vnetId: vnetId
    subnetId: privateLinkSubnetId
  }
  dependsOn: [
    storage
  ]
}

module fileStoragePrivateEndpoint '../network/storagePE.bicep' = {
  name: filePEName
  params: {
    location: location
    privateEndpointName: filePEName
    privateDnsZoneName: 'fileDnsZone'
    storageAcountName: name
    groupId: 'file'
    resourceTags: resourceTags
    storageAccountId: storage.id
    vnetId: vnetId
    subnetId: privateLinkSubnetId
  }
  dependsOn: [
    storage
  ]
}

output filePrivateEndpointId string = fileStoragePrivateEndpoint.name
output storageId string = storage.id
output name string = name
output key string = storage.listKeys().keys[0].value

output queuePEOutputId string = queueStoragePrivateEndpoint.outputs.privateEndpointId
output blobPEOutputId string = blobStoragePrivateEndpoint.outputs.privateEndpointId
output filePEOutputId string = fileStoragePrivateEndpoint.outputs.privateEndpointId
output tablePEOutputId string = tableStoragePrivateEndpoint.outputs.privateEndpointId
