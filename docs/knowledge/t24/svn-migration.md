# Migrating T24 Artefacts from SVN to Git using Azure DevOps

> A hands-on guide for Temenos developers and DevOps teams modernizing source control workflows.

---

## 📌 Background

Many Temenos T24 environments have traditionally relied on **SVN (Subversion)** for source control of artefacts like TAFJ components, routines, and scripts. However, as enterprise development practices modernize, **Git-based workflows** with **Azure DevOps** offer a more robust, collaborative, and CI/CD-enabled approach.

This blog guides you through the **SVN to Git migration journey**, with a focus on Temenos artefacts and Azure DevOps integration. It covers:
- Git setup for T24 artefacts
- Azure DevOps repository structure
- CI/CD with cloud and on-prem agents
- Boards and Test Plan integration

---

## 🛠️ Prerequisites

Ensure you have the following ready before starting:

| Tool | Purpose | Download Link |
|------|---------|---------------|
| Azure CLI + DevOps Extension | Manage Azure DevOps via CLI | [Install Guide](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) |
| Git | Distributed version control | [git-scm.com](https://git-scm.com/downloads) |
| TortoiseSVN / SVN CLI | Access old T24 SVN repository | [tortoisesvn.net](https://tortoisesvn.net/) |
| Temenos Design Studio | T24 artefact development | [Temenos Partner Portal](https://community.temenos.com/s/) |
| Azure DevOps Agent (optional) | Run pipelines locally or on-prem | [Install Agent](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/v2-windows) |
| Azure DevOps Account | Host Git repos, pipelines, boards | [dev.azure.com](https://dev.azure.com) |
| Java SDK  | Compile Java-based TAFJ artefacts | [] |

---

## 🚀 Step-by-Step Migration Guide

### 1. Clone Your SVN Repo (Export for Migration)

```bash
svn checkout https://your-svn-server/path/to/repo t24-svn-export