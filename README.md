# AI Automation Template

<img src="https://chrispaquin.com/wp-content/uploads/2026/01/Nobby-the-robot.png" alt="Nobby the Robot" width="50%">

A GitHub Template for creating AI-assisted automation projects with
**governance-first** standards. This template enforces security,
documentation consistency, and quality through automated checks and
explicit AI agent instructions.

![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)
![Python](https://img.shields.io/badge/python-3.11%2B-blue.svg)
![Tested on](https://img.shields.io/badge/tested%20on-RHEL%209%2F10%20%7C%20Ubuntu%2022.04-green.svg)

---

## Overview

This repository provides a structured foundation for AI-assisted development
projects. Unlike traditional templates, this template treats
**documentation as executable instructions** for AI agents. All AI tools
(Cursor, ChatGPT, Copilot, etc.) are required to follow the standards
defined in `docs/ai/CONTEXT.md`, making documentation the authoritative
governance mechanism.

### Core Philosophy

**Governance through Documentation**: In this template, documentation serves
dual purposes:

1. **Human-readable guidance** for developers and operators
2. **Machine-readable instructions** for AI agents

The documentation files (`docs/ai/CONTEXT.md`, `docs/requirements.md`) are not
suggestions—they are **mandatory behavioral contracts** that AI agents must
follow. This approach ensures consistency, security, and maintainability
across all AI-assisted development work.

---

## How This Repository Works

### 1. Template Structure

When you use this template, you get:

- **Governance Documentation**: Standards and requirements that AI agents must follow
- **Security Enforcement**: Strict `.gitignore` policies and pre-commit hooks that prevent secret leakage
- **Quality Gates**: Automated formatting, linting, and safety checks via pre-commit and CI
- **Consistent Standards**: Bash, Python, YAML, and JSON formatting rules enforced automatically

### 2. AI Agent Workflow

AI agents working in this repository follow a strict workflow:

1. **Read Governance Documents First**: `docs/ai/CONTEXT.md` and `docs/requirements.md` are authoritative
2. **Respect Security Boundaries**: `.gitignore` is strictly enforced—violations are security defects
3. **Execute Quality Checks**: Pre-commit must pass using `./scripts/run-precommit.sh`
4. **Update Documentation**: Changes must be reflected in documentation

### 3. Governance Enforcement

Governance is enforced through multiple layers:

| Layer | Mechanism | Purpose |
|-------|-----------|---------|
| **Documentation** | `docs/ai/CONTEXT.md`, `docs/requirements.md` | Defines mandatory AI behavior and requirements |
| **Pre-commit** | `.pre-commit-config.yaml` | Catches issues before commit (formatting, linting, secrets) |
| **CI/CD** | `.github/workflows/ci.yaml` | Enforces checks cannot be skipped, runs on all PRs |
| **Security** | `.gitignore` | Prevents secrets and artifacts from being committed |

---

## Governance: Security and Documentation

### Security Governance

Security is the **highest priority** in this template. All contributors and AI agents must adhere to strict security standards.

#### Credentials and Secrets Management

**Critical Rule**: Credentials, secrets, and sensitive configuration **must never** be committed to the repository.

**How Secrets Are Handled**:

1. **Environment Files**: All secrets must be stored in `.env` files (or equivalent)
   - `.env` files are **never** committed (enforced by `.gitignore`)
   - `.env.example` files **must** be committed to document required variables
   - Example files contain placeholder values, never real secrets

2. **What Is Protected**: The `.gitignore` file protects:
   - Environment files (`.env`, `.env.*`, `vars.env`)
   - Credential files (`.pem`, `.key`, `.crt`, `.pfx`, `.p12`, SSH keys)
   - Cloud credentials (`.aws/`, `.gcp/`, `.azure/`, `terraform.tfvars`)
   - Generic secrets (`secrets.*`, `*.secret`, `*.secrets`)

3. **AI Agent Requirements**: AI agents must:
   - Read `.gitignore` before creating or modifying files
   - Never create, move, or commit ignored files
   - Never log, echo, or persist secret values
   - Use example files (e.g., `.env.example`) for documentation only
   - Treat violations of `.gitignore` rules as security defects

4. **Security Standards from CONTEXT.md**:
   - Never log secrets
   - Credentials and IP addresses must never be hardcoded—use `.env` files
   - Treat all inputs as untrusted
   - Use least privilege
   - Sanitize file paths and user input
   - Document required permissions

#### Security Enforcement

- **Pre-commit hooks** detect private keys and other secrets before commit
- **CI workflows** run the same checks to prevent bypassing local checks
- **`.gitignore` is authoritative**—AI agents must respect it without exception

### Documentation Governance

Documentation in this repository serves as **executable instructions** for AI agents. This creates a governance model where:

1. **Documentation Defines Behavior**: `docs/ai/CONTEXT.md` contains mandatory standards that AI agents must follow
2. **Requirements Are Contracts**: `docs/requirements.md` defines the behavioral contract for the project
3. **Consistency Is Enforced**: All projects using this template follow the same documentation structure
4. **AI Agents Are Accountable**: AI agents cannot deviate from documented standards without explicit clarification

#### Documentation Structure

| File | Purpose | Audience |
|------|---------|----------|
| `docs/ai/CONTEXT.md` | Mandatory AI behavior standards | AI agents (authoritative) |
| `docs/requirements.md` | Project requirements and acceptance criteria | AI agents, developers |
| `docs/ci-and-precommit.md` | Quality enforcement mechanisms | Developers, operators |
| `README.md` | Project overview and usage | All stakeholders |

#### Documentation Requirements

Per `docs/ai/CONTEXT.md`, all projects must include:

- **README.md** with: overview, tested-on shields, requirements/dependencies,
  architecture overview, installation, uninstall steps, usage examples,
  configuration, troubleshooting, security notes, license
- **docs/runbook.md** for operational tools
- **Consistent formatting** enforced by pre-commit (Markdown linting)

---

## Requirements / Dependencies

### System Requirements

- **Primary OS**: RHEL 9 / RHEL 10
- **Secondary OS**: Ubuntu 22.04 (best-effort support)
- **Shell**: bash
- **Python**: 3.11+

### Development Dependencies

- `pre-commit` (for quality checks)
- Python packages as defined in `requirements.txt` or `requirements-dev.txt` (if present)

### Tools Used

- **Ruff**: Python linting and formatting
- **ShellCheck**: Bash script linting
- **shfmt**: Bash script formatting
- **PyMarkdown**: Markdown validation

---

## High-Level Architecture Overview

```text
┌─────────────────────────────────────────────────────────────┐
│                    AI Automation Template                    │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────┐      ┌──────────────┐                    │
│  │  Governance  │      │   Security   │                    │
│  │ Documentation│◄────►│  Enforcement │                    │
│  │              │      │              │                    │
│  │ CONTEXT.md   │      │  .gitignore  │                    │
│  │ requirements │      │  pre-commit  │                    │
│  └──────┬───────┘      └──────┬───────┘                    │
│         │                     │                             │
│         └──────────┬──────────┘                             │
│                    │                                         │
│         ┌──────────▼──────────┐                             │
│         │   AI Agents         │                             │
│         │   (Cursor, etc.)    │                             │
│         └──────────┬──────────┘                             │
│                    │                                         │
│         ┌──────────▼──────────┐                             │
│         │   Quality Gates     │                             │
│         │   (pre-commit, CI)  │                             │
│         └─────────────────────┘                             │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

**Key Components**:

1. **Governance Layer**: Documentation files that define mandatory behavior
2. **Security Layer**: `.gitignore` and pre-commit hooks that prevent secret leakage
3. **AI Agent Layer**: AI tools that follow governance documentation
4. **Quality Gate Layer**: Automated checks that enforce standards

---

## Installation

### 1. Use This Template

Click **"Use this template"** on GitHub to create a new repository from this template.

### 2. Clone Your New Repository

```bash
git clone <your-new-repo-url>
cd <your-repo-name>
```

### 3. Set Up Pre-commit

```bash
pip install pre-commit
pre-commit install
```

### 4. Populate Project-Specific Files

- **`docs/requirements.md`**: Define your project's requirements and acceptance criteria
- **`.env.example`**: Create an example environment file documenting required variables
- **`README.md`**: Update with your project-specific information

### 5. Bootstrap Structure (Optional)

If you need to recreate the template structure:

```bash
./bootstrap-template-structure.sh
```

---

## Uninstall Steps

To remove this template's infrastructure from a project:

1. Remove pre-commit hooks:

   ```bash
   pre-commit uninstall
   ```

2. Remove template-specific files (if desired):
   - `.pre-commit-config.yaml`
   - `.github/workflows/ci.yaml`
   - `docs/ai/CONTEXT.md`
   - `scripts/run-precommit.sh`

3. Remove pre-commit package (if no longer needed):

   ```bash
   pip uninstall pre-commit
   ```

**Note**: Consider keeping the governance documentation and quality checks even if removing other template components.

---

## Usage Examples

### Working with AI Agents

When instructing AI agents to work on this repository, always include:

```markdown
Please follow the standards in docs/ai/CONTEXT.md and implement
the requirements in docs/requirements.md. Ensure pre-commit passes
before completing the work.
```

### Running Pre-commit Checks

**Recommended method** (for AI-assisted workflows):

```bash
./scripts/run-precommit.sh
```

This script:
- Runs all pre-commit hooks
- Captures output to `artifacts/pre-commit.log` for AI review
- Preserves correct exit codes

**Alternative method** (automatic on commit):

```bash
git commit -m "Your message"
# Pre-commit runs automatically if installed
```

### Creating Environment Files

1. Copy the example file:

   ```bash
   cp .env.example .env
   ```

2. Edit `.env` with your actual values (never commit this file)

3. The `.env` file is automatically ignored by `.gitignore`

---

## Configuration

### Pre-commit Configuration

Pre-commit hooks are configured in `.pre-commit-config.yaml`. The default configuration includes:

- **Basic checks**: merge conflicts, YAML/JSON validation, trailing whitespace
- **Python**: Ruff linting and formatting
- **Bash**: ShellCheck and shfmt formatting
- **Markdown**: PyMarkdown validation
- **Security**: Private key detection

### CI/CD Configuration

CI workflows are defined in `.github/workflows/ci.yaml`. The workflow:

- Runs pre-commit checks on all PRs and pushes
- Runs unit tests (if `tests/` directory exists)
- Uploads pre-commit logs as artifacts on failure

### Markdown Configuration

Markdown linting rules are configured in `.pymarkdown.json`:

- Line length: 120 characters
- Headers: First line doesn't need to be a header (md041 disabled)
- Blank lines: Required around lists and headers

---

## Troubleshooting

### Pre-commit Fails

1. **Review the log**: Check `artifacts/pre-commit.log` for detailed error messages
2. **Auto-fix issues**: Many hooks auto-fix issues—run pre-commit again
3. **Manual fixes**: Address remaining issues manually
4. **CI failures**: Same checks run in CI—fix locally first

### Secrets Detected in Pre-commit

If pre-commit detects secrets:

1. **Verify it's a false positive**: Some patterns may match non-secrets
2. **If real secret**: Remove it immediately, rotate the credential
3. **Check git history**: Use `git log` to see if it was ever committed
4. **Clean history if needed**: Consider using `git filter-branch` or BFG Repo-Cleaner

### AI Agent Not Following Standards

If an AI agent violates standards:

1. **Explicitly reference CONTEXT.md**: "Please follow docs/ai/CONTEXT.md section X"
2. **Point to specific rules**: Quote the exact standard being violated
3. **Re-run pre-commit**: Quality gates will catch many violations

---

## Security Notes

### Security-First Design

This template is designed with security as the highest priority:

1. **Secrets Protection**: Comprehensive `.gitignore` prevents accidental secret commits
2. **Automated Detection**: Pre-commit hooks detect private keys and other secrets
3. **Least Privilege**: All scripts should use least privilege principles
4. **Input Validation**: All inputs should be treated as untrusted
5. **Audit Trail**: Pre-commit logs provide an audit trail of quality checks

### Security Best Practices

- **Never hardcode credentials**: Always use `.env` files or secure secret management
- **Never log secrets**: Logging should never include sensitive values
- **Rotate credentials**: If a secret is ever exposed, rotate it immediately
- **Review `.gitignore`**: Ensure all sensitive files are covered
- **Use example files**: Document required variables in `.env.example`

### Reporting Security Issues

If you discover a security vulnerability in this template:

1. **Do not** open a public issue
2. Contact the repository maintainers privately
3. Include details about the vulnerability and potential impact

---

## License

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for full text.

---

## Key Files Reference

| File | Purpose |
|------|---------|
| `docs/ai/CONTEXT.md` | **Authoritative** AI behavior standards (mandatory for AI agents) |
| `docs/requirements.md` | Project requirements and acceptance criteria |
| `.gitignore` | **Authoritative** security rules (secrets, artifacts) |
| `.pre-commit-config.yaml` | Quality check configuration |
| `.github/workflows/ci.yaml` | CI/CD pipeline definition |
| `scripts/run-precommit.sh` | Pre-commit execution wrapper (use this, not `pre-commit` directly) |
| `bootstrap-template-structure.sh` | Recreate template structure |

---

## Contributing

When contributing to this template:

1. Follow all standards in `docs/ai/CONTEXT.md`
2. Ensure pre-commit passes: `./scripts/run-precommit.sh`
3. Update documentation if adding new features
4. Maintain backward compatibility where possible
5. Test on both RHEL 9/10 and Ubuntu 22.04

---

## Additional Resources

- [Pre-commit Documentation](https://pre-commit.com/)
- [Ruff Documentation](https://docs.astral.sh/ruff/)
- [ShellCheck Documentation](https://www.shellcheck.net/)
- [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)
