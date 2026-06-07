# Plan

## Goal
Build a complete AWS infrastructure portfolio using Terraform — starting from a remote state backend and growing into VPC, EC2, ECS, EKS, RDS, two-tier and three-tier applications, disaster recovery, and high availability.

---


## Immediate next steps

- [ ] Update `common/accounts/DioProjects/account.tfvars` with the real AWS account ID
- [ ] Update `common/accounts/DioProjects/region.us-east-1.tfvars` with the correct region if needed
- [ ] Review and validate the 3 GitHub Actions workflows — check IAM role permissions, secrets names, and Terraform version
- [ ] Write the `modules/solutions/tf-state-backend-s3` module — creates an S3 bucket + DynamoDB table for remote state
- [ ] Write the `modules/resources/s3-bucket` module — reusable atomic S3 bucket resource
- [ ] Run `create_env.sh` to scaffold the first environment under `envs/tf-state-backend-s3/`
- [ ] Deploy the S3 state backend locally (no remote state yet), then migrate state into it with `terraform init -migrate-state`
- [ ] All future environments use the S3 backend automatically after this

---

## Infrastructure roadmap (in order)

| Step | What | Why first |
|------|------|-----------|
| 1 | S3 + DynamoDB remote state backend | Everything else depends on this |
| 2 | VPC + subnets + route tables + NAT | Networking foundation for everything |
| 3 | Security groups | Required before any EC2 or ECS |
| 4 | EC2 instance | Simplest compute, good starting point |
| 5 | Two-tier app (ALB + EC2) | Adds load balancing in front of EC2 |
| 6 | ECS Fargate cluster + ECR | Containerised workloads, deploys go-app |
| 7 | RDS (PostgreSQL) | Managed database for go-app |
| 8 | Three-tier app (ALB + ECS + RDS) | Full production-grade application stack |
| 9 | EKS cluster | Kubernetes, more advanced container orchestration |
| 10 | EMR Serverless | Data processing |
| 11 | Disaster recovery + high availability | Multi-AZ, failover, backups |

---

## Workflow review checklist

Things to verify before the workflows are production-ready:

- [ ] `AWS_ROLE_TO_ASSUME` secret is set in GitHub repository settings
- [ ] `AWS_REGION` secret is set in GitHub repository settings
- [ ] The IAM role has the right permissions for Terraform to plan and apply
- [ ] `terraform-deploy.yml` — verify the changed-files detection logic works correctly for this repo structure
- [ ] `terraform-destroy.yml` — consider adding a manual confirmation step so destroy cannot be triggered accidentally
- [ ] Consider adding `terraform fmt` and `terraform validate` checks to `pr-validation.yml`

---

## Repositories

| Repo | Purpose |
|------|---------|
| `terraform-sauron` | All AWS infrastructure (this repo) |
| `go-app` | Go REST API + HTML frontend — will be deployed here via ECS |
