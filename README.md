# Azure Self-Hosted Bicep

Reusable Azure Bicep templates for deploying self-hosted applications with secure and private infrastructure patterns.

## Repository structure

- `applications/` — application deployment templates and parameter sets.
- `modules/` — reusable infrastructure modules such as networking, container registry, and PostgreSQL.

## Current modules

- `modules/network/` — virtual network and subnet provisioning.
- `modules/container-registry/` — Azure Container Registry deployment.
- `modules/postgres/` — PostgreSQL flexible server deployment.

## Goals

- Keep infrastructure modular and reusable.
- Prefer private networking and secure defaults.
- Support parameterized deployments via Bicep.
- Enable application templates to compose shared modules.

## Getting started

1. Place application-specific Bicep templates in `applications/<app>/`.
2. Reference reusable modules from `modules/`.
3. Use `az bicep build --file <file>.bicep` to validate templates.

## Example

```bicep
module vnet 'modules/network/main.bicep' = {
  name: 'network'
  params: {
    vnetName: 'myVnet'
    location: 'eastus'
    addressPrefixes: [ '10.0.0.0/16' ]
  }
}

module acr 'modules/container-registry/main.bicep' = {
  name: 'registry'
  params: {
    registryName: 'myacr'
    location: 'eastus'
    adminUserEnabled: false
  }
}

module db 'modules/postgres/main.bicep' = {
  name: 'postgres'
  params: {
    serverName: 'mypostgres'
    administratorLoginPassword: 'P@ssword1234!'
    publicNetworkAccess: 'Disabled'
  }
}
```

## Notes

- This repository is designed for fresh starts and modular deployments.
- Add additional modules under `modules/` as needed.
- Add application templates under `applications/` and compose shared modules.
