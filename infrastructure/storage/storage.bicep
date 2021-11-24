param location string
param name string
param resourceTags object 

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

output storageId string = storage.id
