# Journal

---

## 23/05/2026

### terraform-sauron

- Repo created modelled after a real company Terraform structure
- `modules/resources/` — atomic building blocks (s3-bucket, vpc, subnets, ec2, security-groups, route-tables, nat-gateways)
- `modules/solutions/` — higher-level stacks (tf-state-backend-s3, vpc, two-tier-app, three-tier-app)
- `envs/` — where Terraform is applied. Each solution has a `common/` folder + one folder per env instance
- `common/accounts/DioProjects/` — account-level tfvars
- `create_env.sh` — scaffolds new env folders with symlinks automatically
- 3 workflows: `pr-validation.yml`, `terraform-deploy.yml`, `terraform-destroy.yml`

### go-app

- Use case: Pharmaceutical — Medicine & Prescription System
- Architecture: monolith Go REST API + HTML frontend, ECS Fargate, RDS
- Repos: `terraform-sauron` (infra) and `go-app` (application)
- Go 1.26.3 installed, module initialised, folder structure created
- First file: `cmd/api/main.go` — HTTP server with `/health` endpoint
- `docker-compose.yml` — PostgreSQL 16 + pgAdmin, env vars from `.env` (gitignored)

---

## 07/06/2026

### AWS Account Setup

- Created AWS account, logged in as root
- Enabled MFA on root user (authenticator app, device named `iphone-root`)
- Root is only used for initial setup — never again after this

### IAM Identity Center (SSO)

- Enabled IAM Identity Center → Enable with AWS Organizations (free)
- Created `AdministratorAccess` permission set
- Created SSO user + `Admins` group, assigned group + permission set to `DioProjects` account
- Accepted email invite, set password + MFA on phone
- Login URL: `https://d-xxxxxxxxxx.awsapps.com/start` (bookmark this — never use console.aws.amazon.com directly)

```bash
aws configure sso
# session: sauron | start URL: <portal URL> | region: us-east-1 | profile: sauron-admin
aws sts get-caller-identity --profile sauron-admin   # confirmed DioProjects account
```

### S3 + DynamoDB State Backend

Bootstrapped with local state, then migrated to S3:

```bash
cd envs/tf-state-backend-s3/DioProjects-us-east-1-sauron-cicd-tfstate
export AWS_PROFILE=sauron-admin
terraform init && terraform apply        # creates bucket + DynamoDB
# updated state.tf to add S3 backend config
terraform init -migrate-state            # state moved to S3
```

Creates: `sauron-cicd-tfstate` S3 bucket (versioned, encrypted, TLS enforced) + DynamoDB table (state locking).

### GitHub Actions CI Role

```bash
cd envs/github-actions-ci-role/DioProjects-us-east-1-sauron-github-actions-ci-role
terraform init && terraform apply
```

Creates in IAM:
- OIDC provider — AWS trusts GitHub's identity system
- Role `github-actions-ci` — only `diomidispt/terraform-sauron` can assume it via OIDC
- Policy `github-actions-ci` — Terraform permissions for all planned infrastructure

No long-lived keys. GitHub gives each workflow run a short-lived JWT, AWS validates it, returns 1-hour credentials.

### GitHub Repo Config

- **Secret** `AWS_ROLE_TO_ASSUME` — ARN of `github-actions-ci` role
- **Variable** `AWS_REGION` — `us-east-1`

### CI/CD Behaviour

| Event | Result |
|---|---|
| Push to `main` | plan + apply on changed env folders |
| Pull request | plan only |
| Manual trigger | destroy on specified env path |
