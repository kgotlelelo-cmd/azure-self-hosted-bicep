# Azure Self-Hosted Bicep

Reusable Azure Bicep templates for deploying and operating open-source applications on Microsoft Azure.

This repository is intended to provide practical, secure, and repeatable infrastructure-as-code examples for self-hosted platforms such as Grafana, Loki, SonarQube, Moodle, Gitea, Keycloak, Nextcloud, and other open-source tools.

> [!IMPORTANT]
> This project is under active development. Review the status of an application before using its templates in a production environment.

## Goals

- Provide modular and reusable Bicep templates.
- Support development, standard, and production deployment patterns.
- Apply Azure security and operational best practices.
- Make deployments configurable through `.bicepparam` files.
- Include validation, cost considerations, backup guidance, and removal instructions.
- Demonstrate real-world Azure infrastructure-as-code patterns.

## Application catalogue

| Application | Category | Suggested Azure target | Status |
|-------------|----------|------------------------|--------|
| Grafana | Observability | Azure Container Apps or AKS | Planned |
| Loki | Logging | Azure Container Apps or AKS | Planned |
| SonarQube Community Build | Code quality | Container Apps, AKS, or VM | Planned |
| Moodle | Learning management | Container Apps or VM | Planned |
| Uptime Kuma | Availability monitoring | Azure Container Apps | Planned |
| Gitea | Source control | Azure Container Apps | Planned |
| Keycloak | Identity and access management | Azure Container Apps or AKS | Planned |
| Nextcloud | File sharing and collaboration | Container Apps, AKS, or VM | Planned |
| Paperless-ngx | Document management | Azure Container Apps | Planned |
| OpenProject | Project management | Azure Container Apps or AKS | Planned |
| OpenBao | Secrets management | AKS or VM | Planned |
| Harbor | Container registry | AKS | Planned |
| Apache Airflow | Workflow orchestration | AKS | Planned |

Status values used in this repository:

- **Planned** — implementation has not started.
- **In progress** — templates are being developed or tested.
- **Preview** — deployable, but not yet recommended for production.
- **Stable** — documented and tested against the supported configuration.

## Deployment profiles

Applications may provide one or more deployment profiles.

| Profile | Intended use | Typical architecture |
|---------|--------------|----------------------|
| Development | Learning, demos, and short-lived testing | Public networking and low-cost resources |
| Standard | Small teams and internal workloads | Managed database, Key Vault, managed identity, HTTPS, and monitoring |
| Production | Business-critical workloads | Private networking, zone redundancy, autoscaling, backups, WAF, and disaster-recovery guidance |

Not every application will support every profile. Consult the application's own README before deployment.

## Repository structure

```
.
├── applications/
│   ├── gitea/
│   │   ├── dev.bicepparam
│   │   ├── standard.bicepparam
│   │   └── main.bicep
│   ├── keycloak/
│   ├── nextcloud/
│   └── paperless/
├── modules/
│   ├── container-app/
│   ├── key-vault/
│   ├── monitoring/
│   ├── network/
│   ├── postgres/
│   └── storage/
├── scripts/
├── tests/
├── .github/
│   └── workflows/
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```

Each application should use the following structure where applicable:

```
applications/<application>/
├── main.bicep
├── README.md
├── dev.bicepparam
├── standard.bicepparam
├── production.bicepparam
├── modules/
└── tests/
```

## Prerequisites

Before deploying a template, ensure that you have:

- An active Azure subscription.
- Permission to create resources in the target subscription or resource group.
- Azure CLI installed and authenticated.
- A recent Bicep CLI version, either installed separately or through Azure CLI.
- Git installed if you are cloning this repository.

Authenticate and confirm the selected subscription:

```bash
az login
az account show --output table
```

Select a different subscription when required:

```bash
az account set --subscription "<subscription-id>"
```

## Quick start

Clone the repository:

```bash
git clone https://github.com/<github-owner>/azure-self-hosted-bicep.git
cd azure-self-hosted-bicep
```

Choose an application and read its documentation before continuing:

```bash
cd applications/<application>
```

Validate the Bicep file:

```bash
az bicep build --file main.bicep
```

Preview resource-group changes:

```bash
az deployment group what-if \
  --resource-group <resource-group-name> \
  --template-file main.bicep \
  --parameters dev.bicepparam
```

Deploy the selected profile:

```bash
az deployment group create \
  --name <application>-$(date +%Y%m%d%H%M%S) \
  --resource-group <resource-group-name> \
  --template-file main.bicep \
  --parameters dev.bicepparam
```

Some templates may use subscription-scope deployment instead. Always follow the commands in the application's README.

## Configuration

Use `.bicepparam` files for environment-specific, non-secret values. Examples may include:

- Azure region
- Resource naming prefix
- Workload environment
- Resource SKUs
- Scaling limits
- Custom domains
- Network address ranges
- Backup retention periods

Do not commit passwords, access keys, tokens, connection strings, private certificates, or other secrets. Store sensitive values in Azure Key Vault and use managed identities wherever the application supports them.

## Design principles

### Modular infrastructure

Shared concerns such as networking, storage, monitoring, identity, databases, and Key Vault should be implemented as reusable modules. Application templates should compose those modules rather than duplicate resource definitions.

### Secure defaults

Templates should prefer:

- Managed identities instead of stored credentials.
- Key Vault references instead of plain-text secrets.
- HTTPS-only ingress.
- Minimum required role assignments.
- Private endpoints for supported production resources.
- Disabled public access where the selected architecture permits it.
- Diagnostic settings and centralised logging.

### Predictable deployments

Templates should be idempotent and use pinned application image versions. Avoid using floating image tags such as `latest` in stable or production profiles.

### Operational readiness

A stable application deployment should document:

- Health and readiness checks
- Logs and metrics
- Backup and restore procedures
- Scaling behaviour
- Upgrade process
- Rollback process
- Expected Azure resources
- Known limitations
- Approximate cost drivers
- Safe teardown procedure

## Cost management

Deploying the templates can create billable Azure resources. Cost varies by region, SKU, usage, storage, network traffic, redundancy, and retention settings.

Before deployment:

1. Review the resources in the application's README.
2. Inspect the selected parameter file.
3. Run an Azure deployment `what-if` operation.
4. Estimate the resources with the Azure Pricing Calculator.
5. Configure Azure Cost Management budgets and alerts.

Development profiles aim to reduce cost, but they are not necessarily free. Remove unused environments and verify that persistent disks, public IP addresses, snapshots, and backup data are no longer required.

## Validation and testing

Contributions should pass the following checks where applicable:

```bash
az bicep format --file applications/<application>/main.bicep
az bicep lint --file applications/<application>/main.bicep
az bicep build --file applications/<application>/main.bicep
```

Before merging a new or changed deployment:

- Run static validation.
- Run `what-if` against a test resource group.
- Deploy into an isolated Azure environment.
- Verify application health and persistence.
- Test upgrade and removal procedures.
- Ensure no secrets or generated deployment outputs are committed.

## Roadmap

The initial roadmap focuses on progressively more complex deployment patterns:

1. Uptime Kuma on Azure Container Apps.
2. Gitea with Azure Database for PostgreSQL.
3. Keycloak with PostgreSQL and Azure Key Vault.
4. Grafana, Loki, Prometheus, and OpenTelemetry Collector.
5. Moodle with managed database and persistent content storage.
6. SonarQube with PostgreSQL and production tuning guidance.
7. Nextcloud with PostgreSQL, Valkey, and persistent storage.
8. Paperless-ngx with web, worker, queue, database, and document storage services.
9. Harbor and Apache Airflow on Azure Kubernetes Service.
10. Production profiles with private networking, availability zones, WAF, and disaster recovery.

## Contributing

Contributions are welcome. Before opening a pull request:

1. Open or reference an issue describing the application or change.
2. Keep application-specific resources inside the relevant application directory.
3. Reuse shared modules where practical.
4. Add or update documentation and parameter examples.
5. Run formatting, linting, build, and deployment validation.
6. Include upgrade, backup, cost, and security considerations.

Do not include application binaries, container images, copyrighted branding, credentials, or customer-specific information in a contribution.

## Support boundaries

This project deploys third-party applications but does not maintain them. Application behaviour, compatibility, licensing, security updates, and support remain governed by the respective upstream projects.

Before using an application commercially or in production:

- Review its current licence.
- Consult its official deployment and sizing documentation.
- Pin a supported version.
- Review published security advisories.
- Test the complete deployment in your own Azure environment.

## Disclaimer

The templates are provided as examples and without warranty. You are responsible for reviewing the generated Azure resources, securing the deployed environment, protecting data, complying with applicable licences, and monitoring cost.

## Licence

Repository licence to be confirmed. Add a `LICENSE` file before accepting external contributions or distributing the templates for general reuse. The MIT License is a common choice for infrastructure-as-code repositories, but it should be selected intentionally.

---

Built and maintained by [CompileGrid](https://compilegrid.com).
