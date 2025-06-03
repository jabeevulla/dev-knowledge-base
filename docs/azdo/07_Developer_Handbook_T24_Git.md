# 🧑‍💻 T24 Developer Handbook – Git & Azure DevOps

This handbook guides T24 developers on how to work in the new Git-based SCM setup integrated with Azure DevOps. It includes onboarding steps, configuration, Git workflow commands, and daily best practices.

---

## 🔐 1. Developer Onboarding

### 🔹 Access Required

| System               | How to Get Access                     |
|----------------------|----------------------------------------|
| Azure DevOps Project | Request via your team lead / AD group |
| Git Repo (Azure Repos) | Inherited from project access         |
| TafJ / Temenos Studio | Installed on your machine             |
| Git Client            | Installed on your machine             |

### 🔹 Initial Onboarding Steps

1. Confirm access to Azure DevOps: [https://dev.azure.com](https://dev.azure.com)
2. Ask for the repo SSH URL or get it from the “Clone” menu.
3. Set up your local machine (see below).

---

## 🛠️ 2. Daily Tools Required

| Tool                   | Purpose                     | Notes                             |
|------------------------|-----------------------------|-----------------------------------|
| **Git CLI (v2.30+)**   | Code versioning             | [https://git-scm.com](https://git-scm.com) |
| **TafJ Temenos Studio**| COB/Version development     | Provided by platform team         |
| **VS Code (Optional)** | YAML/docs editing           | Useful for reading markdown       |

---

## 🧪 3. Setup Verification & SSH Key Configuration

To interact with Azure Repos via Git over SSH, developers must ensure SSH access is properly set up and verified.

### 🔹 Step 1: Check If You Already Have an SSH Key

```bash
ls ~/.ssh/id_rsa.pub
```

If it exists, skip to **Step 3**.

If not, proceed to generate a new key.

### 🔹 Step 2: Generate a New SSH Key (if needed)

```bash
ssh-keygen -t rsa -b 4096 -C "your.email@company.com" -f ~/.ssh/azdo_repo_key
```

### 🔹 Step 3: Add the SSH Key to the SSH Agent

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/azdo_repo_key
```

### 🔹 Step 4: Add the SSH Key to Azure DevOps

1. Copy the public key:
   ```bash
   cat ~/.ssh/azdo_repo_key.pub
   ```

2. Go to: [https://dev.azure.com](https://dev.azure.com)  
   → Click your **profile picture** → **Security**  
   → Under **SSH Public Keys**, click **+ Add**  
   → Paste the key and name it (e.g., `laptop-git-key`)

### 🔹 Step 5: Configure SSH in `~/.ssh/config`

```ssh
Host azdo_repo_key
  HostName ssh.dev.azure.com
  User git
  IdentityFile ~/.ssh/azdo_repo_key
  IdentitiesOnly yes
```

### 🔹 Step 6: Verify Connectivity

```bash
ssh -T git@azdo_repo_key
```

Expected output:

```
You've successfully authenticated, but Azure DevOps does not provide shell access.
```

### 🔹 Step 7: Clone Using Custom Host

```bash
git clone git@azdo_repo_key:v3/<org>/<project>/<repo>
```

---

## ⚙️ 4. Configuration Guidelines

```bash
git config --global user.name "Your Name"
git config --global user.email "you@yourcompany.com"
```

(Optional) Setup `.editorconfig`, `.gitignore`, and preferred IDE plugins.

---

## 🌱 5. Working with Git – Full Cycle

### 🔹 Create a Feature Branch (per CR)

```bash
git checkout -b feature/CR-1234-loan-logic
```

### 🔹 Make Your Changes

Use **TafJ Temenos Studio** to develop T24 artefacts like routines, enquiries, versions, templates, etc.

### 🔹 Commit Your Work

**Optionally** consider using Gitmoji icons in git commit message. You can refer to this website for Gitmoji guide - https://gitmoji.dev/

 ⚠️ HINT: To open the Windows emoji panel, use the keyboard shortcut Windows key + . (period) or Windows key + ; (semicolon).

```bash
git add .
git commit -m "feat(loans): add override logic [CR-1234]"
```

### 🔹 Push Your Branch

```bash
git push -u origin feature/CR-1234-loan-logic
```
### 🔹 Create a Pull Request (PR)

Once you’ve committed and pushed your feature branch, follow these steps to create a pull request for review and merge.

---

#### ✅ Step-by-Step Instructions

1. **Open Azure DevOps**  
   Navigate to your project:  
   [https://dev.azure.com](https://dev.azure.com)

2. **Go to Repos → Pull Requests**

3. **Click “New Pull Request”**

4. **Select source and target branches:**
   - **Source:** Your feature branch (`feature/CR-1234-loan-logic`)
   - **Target:** `develop` branch (default unless otherwise instructed)

5. **Fill in PR details:**
   - **Title:** Start with the CR ID and a short description  
     _Example:_ `CR-1234: Add loan override routine`
   - **Description:** 
     - What was changed?
     - Why it was changed?
     - Impact (if any)
     - Reference to the associated CR
     - Optional: Mention reviewers or test coverage

6. **Link to Work Item:**
   - Click “+ Link Work Items”
   - Search for and select the relevant **Change Request (CR)** or Azure Board item

7. **Add Reviewers:**
   - Select domain lead or peer reviewers
   - Multiple reviewers can be added for approval

8. **Ensure Build Validation is Enabled**
   - Your PR should trigger the configured CI pipeline
   - Wait for the build to complete successfully

9. **Click “Create” to open the PR**

10. **Respond to Review Feedback:**
    - Make required changes in your feature branch
    - Push commits again — the PR auto-updates
    - Resolve or reply to review comments as needed

11. **Approve & Complete PR (if permitted):**
    - Choose **“Squash merge”** or **“Rebase and fast-forward”** (based on repo policy)
    - ✅ Check “Delete branch after merge” (recommended)

---

#### 🧭 What Happens After Merge?

| Action             | Outcome                                       |
|--------------------|-----------------------------------------------|
| PR Merged          | Code is now in `develop` branch               |
| Pipeline Passed     | CI ensures build/test validation              |
| Tagged Release     | When merged to `main` via `release/*`, tags are created for production |

---

---

## 🛑 6. Best Practices

- ✅ Use meaningful commit messages with `[CR-xxxx]`
- ✅ Push frequently and in small increments
- ✅ Review PR feedback and resolve comments
- 🚫 Never push directly to `main` or `release/*`
- 🚫 Avoid force-pushes unless absolutely required

---

## 🔁 7. Useful Git Commands

| Task | Command |
|------|---------|
| Pull latest changes | `git pull origin develop` |
| Add changes | `git add .` |
| Check status | `git status` |
| View commit log | `git log --oneline --graph` |
| Undo last commit (soft) | `git reset --soft HEAD~1` |
| Rebase latest from develop | `git fetch origin && git rebase origin/develop` |

---

## 📘 8. Additional Help

| Resource      | Location                  |
|---------------|---------------------------|
| Git Handbook  | [https://git-scm.com/doc](https://git-scm.com/doc) |
| Azure DevOps Docs | [https://learn.microsoft.com/en-us/azure/devops](https://learn.microsoft.com/en-us/azure/devops) |
| Internal Docs | See Azure Wiki → [Implementation Plan](./06_Implementation_Plan.md) |

---

