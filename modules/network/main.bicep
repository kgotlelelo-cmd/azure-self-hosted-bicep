@description('Name of the virtual network.')
param vnetName string

@description('Azure location for the virtual network.')
param location string = resourceGroup().location

@description('Address prefixes for the virtual network.')
param addressPrefixes array = [
  '10.0.0.0/16'
]

@description('Subnet definitions for the virtual network.')
param subnets array = [
  {
    name: 'private'
    addressPrefix: '10.0.1.0/24'
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    nsgId: ''
    routeTableId: ''
    serviceEndpoints: []
    delegations: []
  }
]

@description('Optional DNS server IP addresses for the virtual network.')
param dnsServers array = []

@description('Optional tags to apply to the virtual network.')
param tags object = {}

resource vnet 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    dhcpOptions: empty(dnsServers) ? null : {
      dnsServers: dnsServers
    }
    subnets: [
      for subnet in subnets: {
        name: subnet.name
        properties: {
          addressPrefix: subnet.addressPrefix
          privateEndpointNetworkPolicies: subnet.privateEndpointNetworkPolicies
          privateLinkServiceNetworkPolicies: subnet.privateLinkServiceNetworkPolicies
          networkSecurityGroup: empty(subnet.nsgId) ? null : {
            id: subnet.nsgId
          }
          routeTable: empty(subnet.routeTableId) ? null : {
            id: subnet.routeTableId
          }
          serviceEndpoints: subnet.serviceEndpoints
          delegations: subnet.delegations
        }
      }
    ]
  }
}

output virtualNetworkId string = vnet.id
output subnetIds array = [for subnet in subnets: '${vnet.id}/subnets/${subnet.name}']
output subnetResources array = [
  for subnet in subnets: {
    name: subnet.name
    id: '${vnet.id}/subnets/${subnet.name}'
    addressPrefix: subnet.addressPrefix
  }
]
