# 🧭 Azure Repos Setup & Rollout Runbook

This runbook provides **detailed, step-by-step instructions** (with expected UI references) to **set up Azure Repos and prepare it for rollout** to development and change teams. It is designed for teams **new to Azure DevOps**.

---

## 📌 Objective

Establish a production-ready Git-based SCM using **Azure Repos**, replacing legacy SVN-based practices, while keeping the process manual-friendly and minimal to start.

---

## ✅ What This Runbook Covers

| Section                            | Description                                           |
|------------------------------------|-------------------------------------------------------|
| 1. [Org & Project Setup](#1-org--project-setup)       | Ensure the Azure DevOps organization and project are configured correctly |
| 2. [Repo Creation](#2-repo-creation)                 | Create one or more Git repositories                   |
| 3. [Repo Settings & Policies](#3-repo-settings--policies) | Recommended defaults and protection policies         |
| 4. [Access & Permissions](#4-access--permissions)    | Grant access for dev and change teams                |
| 5. [Manual Git Workflow](#5-manual-git-workflow)     | Simple Git usage model to onboard SVN teams          |
| 6. [Post-Rollout Checks](#6-post-rollout-checks)     | Final validation before team adoption                |

---

## 1️⃣ Org & Project Setup

### 🔹 Step 1: Create or Access Azure DevOps Organization

1. Go to [https://dev.azure.com](https://dev.azure.com)
2. Sign in using your work email
3. If not already created, click **“New organization”**
4. Provide:
   - **Name**: `my-company`
   - **Region**: closest to your team
   - Click **Continue**

### 🔹 Step 2: Create a Project

1. Go to your org home
2. Click **“+ New project”**
3. Fill in:
   - **Project name**: `T24-SCM`
   - **Visibility**: Private
   - **Version control**: Git
   - **Work item process**: Basic or Agile
4. Click **Create**

### ✅ Recommended Project Settings

- **Repositories**: Enabled
- **Artifacts**: Enabled (optional now, useful later)
- **Boards**: Optional
- **Disable YAML pipelines** (if doing only manual steps)

---

## 2️⃣ Repo Creation

### 🔹 Step 1: Create Repos

1. Go to **Repos → Files**
2. Click the dropdown next to current repo → **New repository**
3. Fill:
   - **Name**: `t24-core`
   - **Type**: Git
   - Leave “Add README” checked
4. Repeat for additional repos (`t24-shared`, etc.)

---

## 3️⃣ Repo Settings & Policies

### 🔹 Enable Branch Protection (for `main`)

1. Go to **Project Settings → Repositories**
2. Select `t24-core` → **Policies**
3. Under **Branches**, find `main`
4. Click **... → Branch policies**
   - ✅ Require a minimum of 1 reviewer
   - ✅ Check for linked work items
   - ✅ Enforce merge strategy (e.g., squash or rebase)
   - ✅ Protect from force push
5. Click **Save**

### 🔹 Tag Push Restriction (Optional)

Restrict tag pushes to `main`:
- Use CLI + policy enforcement (manual enforcement for now)

---

## 4️⃣ Access & Permissions

### 🔹 Add Dev & Change Teams

1. Go to **Project Settings → Permissions**
2. Click **+ Add Group**
   - Name: `T24 Developers`, `T24 Change Team`
   - Set:
     - Repos: **Contribute** for devs
     - Repos: **Read-only** or **PR-only** for change team
3. Add individual members via Azure AD or manually

### 🔹 Optional: Restrict Repo Creation

- Go to **Org Settings → Policies → Repositories**
- ✅ Only Project Admins can create repos

---

## 5️⃣ Manual Git Workflow

### 🔹 Git Clone

```bash
git clone https://dev.azure.com/<org>/<project>/_git/t24-core
cd t24-core
```

### 🔹 Branching

```bash
git checkout -b feature/CR-1234
```

### 🔹 Commit & Push

```bash
git add .
git commit -m "[CR-1234] Fix for Login Exception"
git push origin feature/CR-1234
```

### 🔹 Create Pull Request

1. Go to **Repos → Pull Requests**
2. Click **New Pull Request**
3. Set:
   - Source: `feature/CR-1234`
   - Target: `main`
   - Add reviewers from Change Team
4. Click **Create**

---

## 6️⃣ Post-Rollout Checks

| Checklist Item                            | Action                                       |
|-------------------------------------------|----------------------------------------------|
| ✅ Project access tested                   | All users can access repos                   |
| ✅ Git clone/commit/push tested            | Devs can push branches                       |
| ✅ Branch policies enforced                | Main branch protected                        |
| ✅ Change team aware of PR process         | Confirmed onboarding                         |
| ✅ Manual import tested (if needed)        | SVN → Git test clone done (if applicable)    |

---

## 📦 (Optional) Enable Artifacts Later

You can use Azure Artifacts in phase 2. This setup guide keeps focus on Git Repos only.

---

Let me know if you want a visual guide (PDF/screenshots) or setup checklist spreadsheet.
