## Introduction

### Purpose

This document outlines the strategic approach to modernize source code management (SCM) and change management processes for Temenos T24 systems. The goal is to establish traceability, auditability, and automation readiness through structured Git-based workflows and Azure DevOps integration.

### Scope

The focus is on transitioning from legacy SVN to Git, introducing structured branching, tagging, and documentation practices, and incrementally moving toward full CI/CD adoption. This strategy applies to T24 core, integrations, and supporting artefacts managed by the bank.

### Audience

This document is intended for:

* T24 developers and maintainers
* Technical leads and architects
* Change managers and release coordinators
* DevOps engineers and platform owners

### Strategic Phasing

The modernization will occur in the following phases:

1. **Phase 1:** Establish Git-based SCM and traceable change control (no CI/CD)
2. **Phase 2:** Introduce Azure DevOps for structured governance and traceability
3. **Phase 3:** Incremental rollout of CI/CD pipelines for T24 artefact automation

---