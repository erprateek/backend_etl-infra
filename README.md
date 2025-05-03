# backend_etl-infra

[![tfsec](https://github.com/erprateek/backend_etl-infra/actions/workflows/tfsec.yml/badge.svg)](https://github.com/erprateek/backend_etl-infra/actions/workflows/tfsec.yml)
[![ShellCheck](https://github.com/erprateek/backend_etl-infra/actions/workflows/main.yml/badge.svg)](https://github.com/erprateek/backend_etl-infra/actions/workflows/main.yml)
[![CI](https://github.com/erprateek/backend_etl-infra/actions/workflows/blank.yml/badge.svg)](https://github.com/erprateek/backend_etl-infra/actions/workflows/blank.yml)
[![Bandit](https://github.com/erprateek/backend_etl-infra/actions/workflows/bandit.yml/badge.svg)](https://github.com/erprateek/backend_etl-infra/actions/workflows/bandit.yml)
Infrastructure-as-Code (IaC) repository for provisioning and managing backend infrastructure to support ETL pipelines, using Terraform and supporting shell scripts.

## 📦 Repository Structure

- **`main.tf`** — Terraform configuration to provision core infrastructure.
- **`variables.tf`** — Input variables to customize infrastructure settings.
- **`outputs.tf`** — Outputs generated after infrastructure deployment (e.g., resource IDs, URLs).
- **`iam-policies/`** — IAM policy documents to manage permissions.
- **`deploy.sh`** — Shell script to automate deployment (`terraform init` ➔ `terraform apply`).
- **`destroy.sh`** — Shell script to automate teardown (`terraform destroy`).
- **`.terraform.lock.hcl`** — Lock file ensuring consistent provider versions.
- **`.gitignore`** — Excludes Terraform local files, credentials, and other artifacts.
- **`LICENSE`** — Project license (MIT).

## 🚀 Getting Started

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) installed (>=1.0).
- AWS CLI configured with appropriate credentials (if deploying to AWS).
- Execute permissions for shell scripts (`chmod +x deploy.sh destroy.sh`).

### Deployment

To provision the infrastructure:

```bash
git clone https://github.com/erprateek/backend_etl-infra.git
cd backend_etl-infra
./deploy.sh
```

This will initialize Terraform, plan, and apply your infrastructure.

### Destruction

To tear down all resources:

```bash
./destroy.sh
```

This will safely destroy everything managed by this Terraform project.

### Customization

Modify `variables.tf` or create a `terraform.tfvars` file to override default values:

```hcl
variable_name = "your_value"
```

IAM policies can be customized by editing or adding files in the `iam-policies/` directory.

## 📜 License

This project is licensed under the [MIT License](LICENSE).

## 🙌 Contributing

Pull requests are welcome! Feel free to open an issue or suggest improvements.
