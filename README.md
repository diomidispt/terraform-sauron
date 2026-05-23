# terraform-sauron

Personal infrastructure portfolio — modular, DRY Terraform for AWS.

## Architecture

```
.
├── common/
│   └── accounts/
│       └── Sauron/
│           ├── account.tfvars
│           └── region.us-east-1.tfvars
├── envs/
│   └── <solution>/
│       ├── common/
│       └── <account>-<region>-<solution>-[<id>-]<stage>/
│           ├── common.account.auto.tfvars  (symlink)
│           ├── common.main.tf              (symlink)
│           ├── common.provider.tf          (symlink)
│           ├── common.region.auto.tfvars   (symlink)
│           ├── common.variables.tf         (symlink)
│           ├── state.tf
│           └── terraform.tfvars
├── modules/
│   ├── resources/       # Atomic building blocks
│   └── solutions/       # Opinionated higher-level stacks
└── create_env.sh
```

## Modules

### Resources (atomic)
| Module | Description |
|--------|-------------|
| `s3-bucket` | S3 bucket |
| `vpc` | VPC |
| `subnets` | Public / private subnets |
| `ec2-instance` | EC2 instance |
| `security-groups` | Security groups |
| `route-tables` | Route tables |
| `nat-gateways` | NAT gateways |

### Solutions (higher-level stacks)
| Module | Description |
|--------|-------------|
| `tf-state-backend-s3` | S3 + DynamoDB remote state backend |
| `vpc` | Full VPC with subnets, routing, and NAT |
| `two-tier-app` | Web tier + app tier (ALB → EC2) |
| `three-tier-app` | Web tier + app tier + data tier (ALB → EC2 → RDS) |

## Environments

| Env | Description |
|-----|-------------|
| `tf-state-backend-s3` | Remote state backend (bootstrap, deploy first) |
| `vpc` | Networking foundation |
| `ec2` | EC2 instances |

## Workflow

### Bootstrap (first time)
1. Fill in your AWS account ID in [common/accounts/Sauron/account.tfvars](common/accounts/Sauron/account.tfvars)
2. Deploy `tf-state-backend-s3` locally (no remote state yet):
   ```bash
   cd envs/tf-state-backend-s3/<env-folder>
   terraform init
   terraform apply
   terraform init -migrate-state   # migrate local state → S3
   ```
3. All subsequent environments use the S3 backend automatically.

### Creating a new environment
```bash
./create_env.sh
```
Follow the prompts — it scaffolds the folder, symlinks shared files, and writes `state.tf`.

### Deploying
```bash
cd envs/<solution>/<env-folder>
terraform init
terraform plan -var-file="common.account.auto.tfvars" -var-file="common.region.auto.tfvars"
terraform apply -var-file="common.account.auto.tfvars" -var-file="common.region.auto.tfvars"
```

## CI/CD

GitHub Actions workflows live in [.github/workflows/](.github/workflows/):

| Workflow | Trigger | Action |
|----------|---------|--------|
| `pr-validation.yml` | PR opened/edited | Validates PR title format |
| `terraform-deploy.yml` | PR / push to `main` | Plan on PR, apply on merge |
| `terraform-destroy.yml` | Manual (`workflow_dispatch`) | Destroy a specific env |

Required GitHub secrets:
- `AWS_ROLE_TO_ASSUME` — IAM role ARN for OIDC authentication
- `AWS_REGION` — e.g. `us-east-1`

## Secrets (SOPS + KMS)

Encrypted secrets use [SOPS](https://github.com/getsops/sops) with AWS KMS.

1. Update `.sops.yaml` with your KMS key ARN.
2. Encrypt: `sops --encrypt --in-place secrets.json`
3. Reference in Terraform via the `sops_file` data source.
