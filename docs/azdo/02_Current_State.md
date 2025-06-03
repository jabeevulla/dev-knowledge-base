## Background and Current Challenges

### 📌 Overview

The current source code and release management process for T24 and other internal systems relies heavily on **SVN (Subversion)** with fragmented manual practices. This legacy setup lacks governance, automation, and traceability—making it difficult to align with DevOps maturity models or regulatory expectations.

Key observations:

- No branching or tagging strategy in SVN; all changes are committed directly to trunk.
- Builds are created manually on developer machines using Temenos Studio.
- Deployments involve replacing `.jar/.war` files manually on runtime servers.
- Rollbacks are achieved by manually restoring renamed artefacts.
- A standalone Selenium regression suite exists but is manually run and outdated.

---

### 🔹 Current State – Workflow Diagram


::: mermaid
flowchart TD
    A[SVN Repository Single Trunk] --> B[Developer Checkout Trunk]
    B --> C[Code Changes in Local]
    C --> D[Commit Directly to Trunk]
    D --> E[Build in Temenos Studio on Dev Machine]
    E --> F[Manually Copy JAR/WAR to Test/Prod Server]
    F --> G[Rename Existing JAR/WAR for Backup]
    G --> H[Restart Application Server Manually]

    subgraph Tester Actions
        I[Run Selenium Regression on Dedicated Machine]
        J[Review and Document Failures]
        K[Manually Log Defects in Tracker]
    end

    F --> I
    J --> L[Fix Issues and Repeat Cycle]

    H --> M[Manual Email/Excel Update for Deployment]
    M --> N[No Traceability or Versioned Artefacts]

:::

### ✴  Key Pain Points

| 🔍 Area                | ⚠️ Challenge                                                                 |
|------------------------|------------------------------------------------------------------------------|
| **Traceability**       | No link between CRs, commits, and deployments                                |
| **Version Control**    | Lack of branching/tagging; direct trunk changes                              |
| **Collaboration**      | Team changes are conflicting and uncoordinated                               |
| **Audit Readiness**    | No logs or history of change ownership and approvals                         |
| **Change Risk**        | No formal release process, test validation, or controlled rollback           |
| **Testing**            | No automated or repeatable test execution integrated into the lifecycle       |
| **Security & Compliance** | Manual secret and artefact handling without access controls                 |

---

### 🗃️ Modernization Need

To transform engineering and delivery capabilities:

- Migrate SCM from SVN to Git with structured workflows.
- Use Azure DevOps for CI/CD, Work Item Linking, and Secure Pipelines.
- Standardize branching strategies (e.g., GitFlow or trunk-based development).
- Automate build, deploy, test cycles with traceability.
- Enforce secure secret management via Azure Key Vault.
- Enable regulatory compliance with SYSC 13.7, PRA SS2/21, GDPR Article 32.

---

### 📑 Summary

> "The current legacy state increases operational risk, slows down delivery, and makes compliance difficult. Migration to Git + Azure DevOps is a critical enabler for productivity, governance, and audit readiness."

---
