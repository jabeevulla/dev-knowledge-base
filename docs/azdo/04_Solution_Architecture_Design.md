# 🧩 Solution Architecture Design (SAD)

This section defines the **solution architecture** for SCM modernization, including component responsibilities, repository structure, DevOps toolchain, traceability mechanisms, and governance alignment.

---

## 🧱 1. Architectural Objectives

- Enable modern, Git-based SCM across T24 and related systems
- Introduce structured branching, tagging, and CR-linked traceability
- Lay the foundation for CI/CD and automation maturity
- Enforce consistent developer workflows and access control
- Maintain audit compliance and rollback capability


---

## 🗂️ 2. Repository Structure Strategy

### 🔹 Monorepo vs Multi-Repo

| Strategy     | Use Case                                 |
|--------------|------------------------------------------|
| **Monorepo** | ✅ Recommended for T24 artefacts – promotes shared governance and reuse |
| Multi-Repo   | Optional for isolated Java or UI components managed by separate teams |

### 🔹 Recommended Git Layout (Monorepo)

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

> 📌 All artefacts (.b, .xml, COB, routines, templates) are grouped by domain under `domains/`.

---

## 🔁 3. Git Branching & Tagging Strategy

The Git branching strategy adopts a **Gitflow-based model** tailored for traceable change requests (CRs), structured releases, and integration with Azure DevOps workflows.

Gitflow separates ongoing development from production-ready code and introduces a robust structure for managing features, releases, hotfixes, and UAT approvals.

---

### 🔹 Primary Branches

| Branch        | Description                                                 |
|---------------|-------------------------------------------------------------|
| `main`        | Production-ready, stable codebase. Only tagged commits exist here. |
| `develop`     | Integration branch for all completed and tested features. Represents the "next release" in progress. |

---

### 🔹 Supporting Branches

| Branch Type    | Naming Convention             | Purpose                                                  |
|----------------|--------------------------------|----------------------------------------------------------|
| `Feature`        | `feature/CR-xxxx-{desc}`       | Per-CR development branches off `develop`               |
| `Release`        | `release/x.y.z`                | Stabilization for UAT; created from `develop`           |
| `Hotfix`         | `hotfix/{desc}`                | Urgent fixes on `main` (also merged back to `develop`)  |

---

### 🔄 Gitflow Lifecycle

1. Start from `develop`:
   - Create a feature branch: `feature/CR-1234-loan-calculation`
   - Develop and push commits with CR ID
2. Merge to `develop` via Pull Request (PR) when done
3. When preparing for a release:
   - Create `release/1.0.0` from `develop`
   - Perform UAT and last-minute QA
   - Finalize version number
4. Merge `release/1.0.0` into:
   - `main` (production) → tag as `v1.0.0`
   - `develop` (to sync post-release improvements)
5. If an urgent production bug arises:
   - Create `hotfix/fix-login-bug` from `main`
   - Patch and merge into both `main` and `develop`
   - Tag appropriately (e.g., `v1.0.1`)

---

### 🌱 Gitflow Example Diagram

::: mermaid
gitGraph
   commit id: "init"
   branch develop
   commit id: "baseline"

   branch feature/CR-1123-loan-limit
   checkout feature/CR-1123-loan-limit
   commit id: "cr1123-dev"
   commit id: "cr1123-test"
   checkout develop
   merge feature/CR-1123-loan-limit id: "merge-cr1123"

   branch feature/CR-1124-treasury-deal
   checkout feature/CR-1124-treasury-deal
   commit id: "cr1124-dev"
   checkout develop
   merge feature/CR-1124-treasury-deal id: "merge-cr1124"

   branch release/1.0.0
   checkout release/1.0.0
   commit id: "uat-prep"
   checkout main
   merge release/1.0.0 id: "release-merge-1.0.0" tag: "treasuryloans-v1.0.0"
   checkout develop
   merge release/1.0.0 id: "backmerge-1.0.0"

   branch hotfix/fix-interest-rate
   checkout hotfix/fix-interest-rate
   commit id: "hotfix-cr1125"
   checkout main
   merge hotfix/fix-interest-rate id: "merge-hotfix-1.0.1" tag: "treasuryloans-v1.0.1"
   checkout develop
   merge hotfix/fix-interest-rate id: "backmerge-hotfix-1.0.1"

   branch feature/CR-1126-payments-rule
   checkout feature/CR-1126-payments-rule
   commit id: "cr1126-dev"
   checkout develop
   merge feature/CR-1126-payments-rule id: "merge-cr1126"

   branch release/1.1.0
   checkout release/1.1.0
   commit id: "uat-prep-1.1.0"
   checkout main
   merge release/1.1.0 id: "release-merge-1.1.0" tag: "t24-core-v1.1.0"
   checkout develop
   merge release/1.1.0 id: "backmerge-1.1.0"
:::