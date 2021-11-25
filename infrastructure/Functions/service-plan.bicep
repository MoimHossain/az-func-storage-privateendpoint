param location string
param planName string
param resourceTags object 

@description('Specifies the Azure Function hosting plan SKU.')
@allowed([
  'EP1'
  'EP2'
  'EP3'
])
param planSku string = 'EP1'
param isReserved bool


resource plan 'Microsoft.Web/serverfarms@2021-01-01' = {
  location: location
  tags: resourceTags
  name: planName
  sku: {
    name: planSku
    tier: 'ElasticPremium'
    size: planSku
    family: 'EP'
  }
  kind: 'elastic'
  properties: {
    maximumElasticWorkerCount: 20
    reserved: isReserved
  }
}

output planId string = plan.id
