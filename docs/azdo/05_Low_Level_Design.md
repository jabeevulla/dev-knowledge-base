# 🔧 Low-Level Design (LLD)

This document outlines the **technical implementation blueprint** for Git-based Source Control and Change Management for T24. It includes concrete structures, naming conventions, commit formats, Git policies, CI/CD pipeline structure, and secure secrets handling.

---

## 📁 1. Repository Structure

The T24 implementation follows a **monorepo model** for centralized governance, audit, and cross-domain coordination.

### 🗂️ Suggested Directory Layout
```
t24-core/
├── domains/
│   ├── treasuryloans/
│   │   ├── data-code/
│   │   ├── models/
│   │   ├── templates/
│   │   ├── versions/
│   │   ├── enquiries/
│   │   ├── routines/
│   │   ├── ofs/
│   │   ├── cob/
│   │   └── package/
│   └── payments/...
├── shared-libs/
├── .pipeline/
└── README.md
```

- `domains/`: Organized by business domain (e.g., loans, payments)
- `shared-libs/`: Common scripts or utilities across domains
- `.pipeline/`: YAML templates for CI/CD stages
- `docs/`: Technical design, release notes, and CR mapping

---

## 🌱 2. Branching Strategy (Gitflow)

| Branch Type | Format                       | Purpose                                   |
|-------------|------------------------------|-------------------------------------------|
| `main`      | `main`                       | Production-ready code                     |
| `develop`   | `develop`                    | Latest changes in active development      |
| Feature     | `feature/CR-xxxx-{desc}`     | Per-change customization branch           |
| Release     | `release/x.y.z`              | Pre-release staging for UAT & approval    |
| Hotfix      | `hotfix/{desc}`              | Emergency patch on production             |

### 📌 Example

- `feature/CR-1123-loan-validation`
- `release/1.0.0`
- `hotfix/interest-rounding-bug`

---

## 📝 3. Commit Message Format

All commits must follow semantic + traceable commit format: 

| Type       | Description                              |
| ---------- | ---------------------------------------- |
| `feat`     | A new feature or functionality           |
| `fix`      | A bug fix or correction                  |
| `chore`    | Routine tasks like build config, cleanup |
| `refactor` | Code change that neither fixes nor adds  |
| `docs`     | Changes to documentation only            |
| `test`     | Adding or updating test cases            |
| `style`    | Formatting, missing semi colons, etc.    |
| `perf`     | Performance improvement                  |
| `ci`       | Changes to CI configuration or scripts   |


### ✅ Examples

- `feat(treasuryloans-data-code): enable override [CR-1123]`
- `fix(payments): handle FX calculation bug [CR-1124]`
- `fix(payments): handle edge case in FX validation [CR-1189]`
- `feat(treasuryloans-data-code): implement new loan logic [CR-1123]`

---

## ⚙️ 4. CI/CD Pipeline Structure

Pipelines are defined using modular **multi-stage YAML** templates.

### 🏗️ Pipeline Directory

```
.pipelines/
├── templates/
│   ├── build-template.yml
│   ├── deploy-template.yml
│   └── test-template.yml
├── t24-core-build.yml
├── t24-core-deploy.yml
└── README.md
```

### 🔄 Stages

| Stage       | Tasks                                                 |
|-------------|--------------------------------------------------------|
| Build       | Compile `.b` files, validate structure                |
| Test        | Static analysis, linting, unit tests (where applicable) |
| Deploy      | SCP/Agent deployment to TAFJ or shell-based scripts   |
| Audit       | Store deployment logs, link to CR                     |

---

## 🔐 5. Secrets & Configuration Management

All sensitive data (e.g., deployment credentials, API keys) must be managed **outside of code** using:

### 🔹 Options

| Tool              | Purpose                                 |
|-------------------|-----------------------------------------|
| Azure Key Vault   | Centralized secrets store for pipelines |
| Pipeline Variables| Non-sensitive runtime configs           |
| Variable Groups   | Reused variables across pipelines       |

### 🔐 Best Practices

- Never commit passwords, URLs, or tokens
- Use **library-scoped** variable groups for domain-specific builds
- Set pipeline permissions to **limit write access to secrets**

---

## 🔄 6. Pre-Merge & Pull Request Policies

To maintain repository hygiene and traceability:

- 🔸 Pull Requests required for all merges to `develop`, `main`, and `release/*`
- 🔸 At least **1 mandatory reviewer**
- 🔸 Link every PR to a **CR work item**
- 🔸 Enable build validation before PR can be completed
- 🔸 Auto-tag releases after successful merge into `main`

---

## 🔍 7. Logging, Traceability & Audits

| Artefact        | Where Stored                              |
|------------------|-------------------------------------------|
| CR Reference     | Git branch, commit message, PR title      |
| Deployment Logs  | Pipeline stage logs and environment summary |
| Release Tags     | Git tags + Azure Boards release notes     |
| Approvals        | PR review comments, Azure Boards audit log|

---

## ✅ Summary

This LLD ensures:

- Standardized repo and branching practices
- Developer discipline via commit + PR rules
- Auditability across CR, code, tag, deploy
- Secure, repeatable CI/CD with secrets separation

---