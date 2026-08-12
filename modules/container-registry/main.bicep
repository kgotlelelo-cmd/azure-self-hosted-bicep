@description('Name of the Container Registry.')
param registryName string

@description('Azure location for the Container Registry.')
param location string = resourceGroup().location

@description('SKU for the Container Registry.')
param skuName string = 'Standard'

@description('Enable admin user for the Container Registry.')
param adminUserEnabled bool = false

@description('Public network access for the Container Registry.')
param publicNetworkAccess string = 'Disabled'

@description('Optional tags to apply to the Container Registry.')
param tags object = {}

@description('Optional network access rules for the Container Registry.')
param networkRuleSet object = {
  defaultAction: 'Deny'
  ipRules: []
  virtualNetworkRules: []
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: registryName
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  properties: {
    adminUserEnabled: adminUserEnabled
    publicNetworkAccess: publicNetworkAccess
    networkRuleSet: networkRuleSet
  }
}

output registryId string = containerRegistry.id
output loginServer string = containerRegistry.properties.loginServer
output adminUserEnabledOutput bool = containerRegistry.properties.adminUserEnabled
