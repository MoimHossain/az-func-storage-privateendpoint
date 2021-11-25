param location string
param appName string
param planName string
param appInsightName string
param resourceTags object 

param subnetId string
param storageAccountName string
param storageAccountKey string

@description('Specifies the OS used for the Azure Function hosting plan.')
@allowed([
  'Windows'
  'Linux'
])
param planOS string = 'Windows'

var isReserved = (planOS == 'Linux') ? true : false

module appInsights 'appInsights.bicep' = {
  name: appInsightName
  params: {
    name: appInsightName
    location: location
    resourceTags: resourceTags
  }
}

module plan 'service-plan.bicep'= {
  name: planName
  params: {
    isReserved: isReserved
    planSku: 'EP1'
    location: location
    planName: planName
    resourceTags: resourceTags
  }
}

resource functionApp 'Microsoft.Web/sites@2021-01-01' = {
  location: location
  name: appName
  kind: isReserved ? 'functionapp,linux' : 'functionapp'
  dependsOn: [
    plan
    appInsights
  ]
  properties: {
    serverFarmId: plan.outputs.planId
    reserved: isReserved
    siteConfig: {
      functionsRuntimeScaleMonitoringEnabled: true
      linuxFxVersion: isReserved ? 'dotnet|3.1' : json('null')
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: '${appInsights.outputs.instrumentationKey}'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${storageAccountKey}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${storageAccountKey}'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
        {
          name: 'WEBSITE_VNET_ROUTE_ALL'
          value: '1'
        }
        {
          name: 'WEBSITE_CONTENTOVERVNET'
          value: '1'
        }       
      ]
    }
  }
}

resource planNetworkConfig 'Microsoft.Web/sites/networkConfig@2021-01-01' = {
  parent: functionApp
  name: 'virtualNetwork'
  properties: {
    subnetResourceId: subnetId
    swiftSupported: true
  }
}
