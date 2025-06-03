# 🚀 Implementation Plan

This document outlines the **step-by-step execution plan** for migrating from SVN to Git, adopting Azure DevOps, and enforcing structured change management.

It defines the major phases, key activities, ownership, timelines, and deliverables aligned with the governance, regulatory, and DevOps modernization objectives.

---

## 🗺️ Phased Execution Overview

| Phase | Objective |
|-------|-----------|
| **I. Foundation & Planning** | Finalize Git strategy, prepare tooling and environment |
| **II. SVN Migration** | Perform Git conversion, preserve commit history |
| **III. Git-based BAU Enablement** | Setup repos, workflows, onboarding |
| **IV. CI/CD Infrastructure** | Setup pipelines, agents, and secrets |
| **V. Rollout & Governance** | Enforce PR policies, traceability, dashboards |

---

## 📅 Timeline and Milestones

### MVP Scope
- Phase I Foundation & Planning
- Phase II SVN Migration
- Phase III BAU Enablement on Git

### Future Strategic Plan
- Phase IV CI/CD Implementation
- Phase V Governance & Rollout using Azure Boards and Test plans

::: mermaid
gantt
    title SVN to Git Migration Timeline 
    dateFormat  YYYY-MM-DD
    axisFormat  %b %d

    section Phase I Foundation & Planning
    Repo Strategy Finalized       :m1, 2024-05-28, 1d
    Design SCM Structure          :a1, after m1, 7d
    Tooling Setup & Access        :a2, after a1, 3d

    section Phase II SVN Migration
    Inventory SVN Repos           :a3, 2024-06-07, 2d
    Map Users (authors.txt)       :a4, after a3, 1d
    Clone to Git                  :a5, after a4, 4d
    Validate & Push to Azure      :a6, after a5, 2d

    section Phase III BAU Enablement on Git
    Setup Repo Branching Model    :a7, after a6, 2d
    Add Gitignore & Templates     :a8, after a7, 2d
    Developer Onboarding          :a9, after a8, 3d

    section Phase IV CI/CD Implementation
    Agent Pool Setup              :a10, 2024-06-20, 3d
    Pipeline Template Setup       :a11, after a10, 4d
    Secrets & Config Management   :a12, after a11, 2d

    section Phase V Governance & Rollout
    Define PR & Commit Policies   :a13, after a12, 2d
    Enable Audit & Dashboards     :a14, after a13, 3d
    CR to Tag Traceability        :a15, after a14, 2d
    Go-Live                       :m2, after a15, 1d
:::

## 👥 Roles & Responsibilities

| Role               | Responsibility                                           |
|--------------------|----------------------------------------------------------|
| **Migration Engineer** | Execute `git svn`, validate structure, push to Git       |
| **DevOps Engineer**    | Setup Azure Repos, Pipelines, Key Vault, agent pools     |
| **Developers**         | Adopt Git workflows, PR model, commit standards          |
| **Release Manager**    | Oversee tagging, release notes, audit traceability       |
| **Governance Lead**    | Monitor compliance, enforce branching & PR policies      |

---

## 📦 Key Deliverables

| Deliverable                      | Description                                |
|----------------------------------|--------------------------------------------|
| **Git Repositories in Azure**        | With full SVN commit history               |
| **Structured Git Branching Model**   | With policies, naming, and protections     |
| **Azure Pipelines CI/CD Templates**  | For T24 build & deploy lifecycle           |
| **Documentation & Runbooks**         | Wiki-based handbooks, LLD, SAD, migration  |
| **Deployment Logs & Traceability**   | From CR → Commit → PR → Tag → Deploy       |

---

## 🔄 Pre & Post Migration Tasks

### ✅ Pre-Migration Tasks
- [ ] Finalize repo naming and structure
- [ ] Create `authors.txt` user mapping
- [ ] Setup empty Git repos in Azure DevOps
- [ ] Validate SVN directory structure and branches

### ✅ Post-Migration Tasks
- [ ] Add `.gitignore`, `.editorconfig`, and `README.md`
- [ ] Tag migrated baseline as `pre-migration`
- [ ] Setup protected branches: `main`, `develop`, `release/*`
- [ ] Enforce PR-based changes with linked CRs

---

## 🛡️ Quality Gates & Policies

- All commits must include a CR reference (`[CR-xxxx]`)
- PR reviews are mandatory before merge into `main` or `release/*`
- CI build must succeed before merge is allowed
- Auto-tagging and structured release notes required
- Pipeline secrets must be externalized (e.g., Key Vault)

---

## 🧭 Final Go-Live Checklist

- [x] All SVN code migrated to Git with full history
- [x] Branching and PR policies configured
- [x] Developer onboarding completed
- [x] Pipelines deployed and tested end-to-end
- [x] T24 deployable artefacts validated
- [x] Compliance audit trace setup verified
- [x] GitOps dashboards and documentation published