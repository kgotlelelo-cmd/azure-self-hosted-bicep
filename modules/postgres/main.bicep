@description('Name of the PostgreSQL flexible server.')
param serverName string

@description('Azure location for the PostgreSQL server.')
param location string = resourceGroup().location

@description('Compute SKU family for the PostgreSQL flexible server.')
param skuName string = 'Standard_B1ms'

@description('Compute tier for the PostgreSQL flexible server.')
param tier string = 'Burstable'

@description('Storage size in GB for the PostgreSQL flexible server.')
param storageSizeGB int = 32

@description('Administrator username for the PostgreSQL server.')
param administratorLogin string = 'postgresadmin'

@description('Administrator password for the PostgreSQL server.')
@secure()
param administratorLoginPassword string

@description('Version of PostgreSQL to deploy.')
param version string = '14'

@description('Whether public network access should be enabled.')
param publicNetworkAccess string = 'Disabled'

@description('Optional virtual network subnet resource ID for private networking.')
param subnetId string = ''

@description('Optional tags to apply to the PostgreSQL server.')
param tags object = {}

resource postgresServer 'Microsoft.DBforPostgreSQL/flexibleServers@2024-08-01' = {
  name: serverName
  location: location
  tags: tags
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    version: version
    storage: {
      storageSizeGB: storageSizeGB
    }
    network: empty(subnetId) ? {
      publicNetworkAccess: publicNetworkAccess
    } : {
      publicNetworkAccess: publicNetworkAccess
      delegatedSubnetResourceId: subnetId
      privateDnsZoneArmResourceId: ''
    }
  }
  sku: {
    name: skuName
    tier: tier
  }
}

output postgresServerId string = postgresServer.id
output postgresServerName string = postgresServer.name
output fullyQualifiedDomainName string = postgresServer.properties.fullyQualifiedDomainName
