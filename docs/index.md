site_name: Jabeevulla | Hands-on Engineer & Architect
theme:
  name: material
  features:
    - navigation.instant
    - navigation.sections
    - navigation.top
    - search.suggest
    - search.highlight
    - content.code.copy
    - content.tabs.link
  palette:
    - media: "(prefers-color-scheme: light)"
      scheme: default
      primary: indigo
      accent: deep orange
    - media: "(prefers-color-scheme: dark)"
      scheme: slate
      primary: indigo
      accent: deep orange
markdown_extensions:
  - admonition
  - codehilite
  - footnotes
  - meta
  - toc:
      permalink: true
repo_url: https://github.com/jabeevulla/dev-knowledge-base
edit_uri: ""
nav:
  - Home: index.md
  - Resume: resume.md
  - Projects:
      - Overview: projects/index.md
      - Rasois App: projects/rasois-app.md
  - Cheatsheets:
      - Spring Boot: cheatsheets/spring-boot.md
  - Handbooks:
      - Azure DevOps: handbooks/azure-devops.md
  - Skills:
      - IAM Migration: skills/iam-migration.md