# Infrastructure as Code with Terraform & Terragrunt

This repository contains the infrastructure code for deploying a Kubernetes cluster on AWS using Terraform, wrapped with Terragrunt for better environment management.

## Repository Structure

```
├── environments
│   ├── dev
│   ├── staging
│   └── prod
│
├── modules
│   ├── vpc
│   ├── eks
│   ├── rds
│   └── other-modules...
│
├── terragrunt.hcl
└── README.md
```

- **`environments/`** - Defines different environments (e.g., dev, staging, production) with specific configurations.
- **`modules/`** - Contains reusable Terraform modules for infrastructure components (VPC, EKS, RDS, etc.).
- **`terragrunt.hcl`** - The main Terragrunt configuration file.

## Prerequisites

Ensure you have the following installed:

- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)
- AWS CLI configured with proper credentials.

## Usage

### 1. Initialize the Environment
```sh
cd environments/dev  # Change to the desired environment
tg init
```

### 2. Plan the Infrastructure
```sh
tg plan
```

### 3. Apply the Infrastructure
```sh
tg apply
```

### 4. Destroy the Infrastructure (if needed)
```sh
tg destroy
```

## Best Practices

- **Modularization:** Each infrastructure component is defined as a reusable module.
- **Environment Segregation:** Using Terragrunt to manage multiple environments efficiently.
- **State Management:** Terraform state is stored in AWS S3 for reliability and remote collaboration.

## Contributions
Feel free to open issues or submit PRs to improve this repository!
