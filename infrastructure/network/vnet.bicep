param location string
param vnetName string
param resourceTags object 
param vnetAddressSpace string = '10.200.0.0/24'

var privateLinkSubnetName = 'privatelink-subnet'
param privateLinkSubnetAddressSpace string = '10.200.0.0/27'

var paasSubnetName = 'paas-subnet'
param paasSubnetAddressSpace string = '10.200.0.32/28'

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
          addressPrefix: privateLinkSubnetAddressSpace
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: paasSubnetName
        properties: {
          addressPrefix: paasSubnetAddressSpace
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          delegations: [
            {
              name: 'webapp'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      }
    ]
  }
}

output vnetId string = vnet.id
output privateLinkSubnetId string = '${vnet.id}/subnets/${privateLinkSubnetName}'
output paasSubnetId string = '${vnet.id}/subnets/${paasSubnetName}'
