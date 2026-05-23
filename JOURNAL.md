# Journal

---

## 23/05/2026

### terraform-sauron

**Repository created from scratch** modelled after a real company Terraform repo structure.

**Folder structure**
- `common/accounts/Sauron/` — holds `account.tfvars` and `region.us-east-1.tfvars`. Account ID is a placeholder — needs to be updated with the real AWS account ID before deploying anything
- `envs/` — where Terraform is actually applied. Each solution gets a folder with a `common/` subfolder for shared code and one folder per environment (e.g. `Sauron-us-east-1-vpc-DEV`)
- `modules/resources/` — atomic building blocks: `s3-bucket`, `vpc`, `subnets`, `ec2-instance`, `security-groups`, `route-tables`, `nat-gateways`
- `modules/solutions/` — higher-level stacks that combine resources: `tf-state-backend-s3`, `vpc`, `two-tier-app`, `three-tier-app`

**3 GitHub Actions workflows created** — may need revisiting as the project grows:
- `pr-validation.yml` — validates PR titles follow conventional commits format (feat, fix, chore, docs etc.) before a PR can be merged
- `terraform-deploy.yml` — on PR: runs `terraform plan` for changed environments. On merge to main: runs `terraform apply` automatically
- `terraform-destroy.yml` — manual trigger only (`workflow_dispatch`), requires passing the environment path. Safety net so nothing is destroyed accidentally

**`create_env.sh`** — interactive shell script that scaffolds a new environment folder in seconds. It asks for environment, account, region, optional unique ID, and stage (DEV/STAG/PROD). Creates the folder, symlinks the shared common files, and writes `state.tf` pointing to the S3 backend (`sauron-cicd-tfstate`). This is how every new environment will be created going forward without doing it manually.

**`.sops.yaml`** — placeholder for future secrets encryption using SOPS + AWS KMS. Not needed yet.

### go-app

- Decided on use case: **Pharmaceutical — Medicine & Prescription System** (Medicines, Patients, Prescriptions)
- Architecture decision: monolith Go REST API + HTML frontend, deployed on ECS Fargate, DB on RDS
- Two repos: `terraform-sauron` (infrastructure) and `go-app` (application)
- Installed Go 1.26.3 via Homebrew
- Initialised Go module (`go mod init`) — equivalent of `package.json` in Node or `pom.xml` in Java
- Created folder structure: `cmd/api/`, `internal/config|handler|service|repository|model/`, `migrations/`, `frontend/`
- Written first Go file `cmd/api/main.go` — HTTP server with `/health` endpoint, port configurable via `PORT` env var
- Set up `docker-compose.yml` — PostgreSQL 16 + pgAdmin (browser UI at http://localhost:5050), env vars read from `.env` (gitignored, never committed)
- Verified: PostgreSQL running and accepting connections, Go server responding `ok` on `/health`
