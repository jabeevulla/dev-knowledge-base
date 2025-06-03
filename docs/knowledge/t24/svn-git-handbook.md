# SVN to Git Migration Handbook (Azure DevOps)

This runbook guides teams through the **end-to-end migration of a monorepo from SVN to Azure Repos Git**, preserving full commit history, branches, and tags.

---

## 📘 Table of Contents

1. Overview
2. Prerequisites
3. User Mapping
4. Repository Analysis
5. Migration Process

   * Clone SVN to Git
   * Validate & Cleanup
   * Push to Azure Repos
6. Post-Migration Steps
7. Common Issues & Troubleshooting
8. Appendix: Script Template

---

## 1. Overview

* **Objective:** Move SVN monorepo to Azure DevOps Git with full history and traceability.
* **Scope:** One-time migration of all modules and branches from SVN to Azure Repos.

---

## 2. Prerequisites

| Requirement               | Description                                 |
| ------------------------- | ------------------------------------------- |
| Git installed             | Version 2.20+                               |
| SVN client installed      | Optional (for `svn log` validation)         |
| `git svn` installed       | Use via Git CLI or install manually         |
| Azure DevOps Repo Created | Create an empty target Git repo per project |
| SVN URL                   | Full URL of the SVN monorepo                |
| Branch/tag layout         | Confirm structure: trunk, branches/, tags/  |
| Access credentials        | Ensure access to both SVN and Azure DevOps  |

---

## 3. User Mapping File (authors.txt)

Create a file `authors.txt` to map SVN usernames to Git format:

```
svnuser1 = John Doe <john.doe@bank.com>
svnuser2 = Jane Smith <jane.smith@bank.com>
```

Store this file locally and reference it during `git svn clone`.

---

## 4. Repository Analysis

Before migration, run the following:

```bash
svn list https://<svn-host>/repos/project/branches
svn list https://<svn-host>/repos/project/tags
```

Document active branches and tags. Archive any stale ones.

---

## 5. Migration Process

### 5.1 Clone SVN to Git with History

```bash
git svn clone https://svn.company.com/repos/project \
  --trunk=trunk \
  --branches=branches \
  --tags=tags \
  --authors-file=authors.txt \
  --no-metadata \
  monorepo-git
```

* `--trunk`, `--branches`, `--tags` ensure full structure mapping
* `--no-metadata` avoids extra git-svn info in commit messages

📁 After completion, inspect `monorepo-git/.git/config` to ensure remotes are correctly linked.

---

### 5.2 Validate & Cleanup

```bash
cd monorepo-git
git log --graph --oneline --all
```

Optional:

* Rename long `remotes/svn/branchname` to `branchname`
* Remove unnecessary remote tracking references

---

### 5.3 Push to Azure Repos

Create an empty Git repo in Azure DevOps (e.g., `monorepo`):

```bash
git remote add origin https://dev.azure.com/<repo-url>
git push origin --all
git push origin --tags
```

Ensure `main` or `master` is set as default branch in Azure.

---

## 6. Post-Migration Steps

| Task                    | Action                                        |
| ----------------------- | --------------------------------------------- |
| Add .gitignore          | Based on build tools used (Java, Maven, etc.) |
| Protect main branch     | Enable policies in Azure Repos settings       |
| Create branch templates | `feature/*`, `release/*`, `hotfix/*`          |


---

## 7. Common Issues & Fixes

| Problem                            | Fix                                                |
| ---------------------------------- | -------------------------------------------------- |
| SVN username not found             | Update `authors.txt`                               |
| Tags appear as branches            | Tags in SVN are often soft-copied; rename manually |
| `fatal: ambiguous argument` errors | Use `git fsck` to detect corruption                |

---

## 8. Appendix: Script Template

```bash
#!/bin/bash
SVN_URL=$1
TARGET_DIR=$2

if [ -z "$SVN_URL" ] || [ -z "$TARGET_DIR" ]; then
  echo "Usage: ./svn-to-git.sh <svn-url> <target-dir>"
  exit 1
fi

git svn clone "$SVN_URL" \
  --trunk=trunk \
  --branches=branches \
  --tags=tags \
  --authors-file=authors.txt \
  --no-metadata \
  "$TARGET_DIR"
```

---

> 📘 **Recommendation**: Test migration in a sandbox repo first, validate builds and history, then replicate to the final Azure Repos environment.
