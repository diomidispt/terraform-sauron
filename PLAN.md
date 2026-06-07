# Plan

## Goal
Build a complete AWS infrastructure portfolio using Terraform — starting from a remote state backend and growing into VPC, EC2, ECS, EKS, RDS, two-tier and three-tier applications, disaster recovery, and high availability.

---


## Immediate next steps

- [x] S3 + DynamoDB remote state backend deployed
- [x] GitHub Actions OIDC role deployed — keyless CI/CD auth
- [x] CI/CD workflows: plan on PR, plan + approval + apply on merge to main, manual destroy with approval
- [ ] Build VPC module — networking foundation (subnets, route tables, NAT gateway, internet gateway)
- [ ] Deploy VPC environment
- [ ] Decide on compute: ECS Fargate (simpler, recommended) vs EKS (more complex) vs EC2 (raw)
- [ ] Set up ECR — container registry for the go-app Docker image
- [ ] Deploy ECS Fargate cluster + service to run the go-app
- [ ] Deploy RDS PostgreSQL for the go-app database
- [ ] Wire go-app CI/CD: build Docker image → push to ECR → trigger ECS deploy

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
