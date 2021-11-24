param location string
param vnetName string
param resourceTags object 
param vnetAddressSpace string = '10.200.0.0/24'
param coreSubnetAddressSpace string = '10.200.0.0/27'

var privateLinkSubnetName = 'privatelink-subnet'

resource vnet 'Microsoft.Network/virtualNetworks@2021-03-01' = {
  name: vnetName
  location: location
  tags: resourceTags
  properties: {
    enableDdosProtection: false
    addressSpace: {
      addressPrefixes: [
        vnetAddressSpace
      ]
    }
    subnets: [
      {
        name: privateLinkSubnetName
        properties: {
          addressPrefix: coreSubnetAddressSpace
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

output vnetId string = vnet.id
output privateLinkSubnetId string = '${vnet.id}/subnets/${privateLinkSubnetName}'
