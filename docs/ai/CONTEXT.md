# AI Engineering Context and Standards

This repository uses AI-assisted development.
All AI tools (Cursor, ChatGPT, Copilot, etc.) must follow this document.

If behavior is not explicitly allowed here or in docs/requirements.md,
it must not be implemented without clarification.

---

## 1. Design Principles
- Correctness over cleverness
- Explicit behavior over implicit assumptions
- Idempotent and safe by default
- Fail loudly, clearly, and early
- Prefer boring, maintainable solutions
- All code should be easily installed and uninstalled
- Adhere to Security best practices
- Adhere to SELinux best practices (semanage over chcon)

---

## 2. Supported Environments
- Primary OS: RHEL 9 / RHEL 10
- Secondary OS: Ubuntu 22.04 (best-effort)
- Shell: bash
- Python: 3.11+

Do not assume additional tools are installed unless explicitly documented.

---

## 3. Bash Standards
- Use `#!/usr/bin/env bash`
- Scripts must start with:
  - `set -euo pipefail`
- Quote all variables
- Never use `eval`
- Validate all inputs early
- Use functions; avoid large monolithic scripts
- Use `trap` for cleanup when modifying system state

---

## 4. Python Standards
- Prefer standard library
- Use type hints for public functions
- Avoid global mutable state
- Use structured logging
- External calls must have timeouts
- Avoid `shell=True`
- CLI tools must support `--help`

---

## 5. Idempotency and Safety
- Scripts must be safe to re-run
- Existing state must be detected, not overwritten blindly
- Partial failures must be handled
- Destructive actions must be explicit and documented
- Provide `--dry-run` where reasonable

---

## 6. Security
- Never log secrets
- credentails and IP addresses should never be hardcoded into scripts, should exist in vars.txt file
- vars.txt file should not be checked into any repo (.gitignore), however an example vars.txt should be created and checked in via git
-  Treat all inputs as untrusted
- Document required permissions
- Use least privilege
- Sanitize file paths and user input

---

## 7. Logging and Exit Codes
- Logs must be actionable and informative
- Logs should exist in /var/log
- Errors must explain what failed and why
- Exit codes:
  - 0: success
  - 1: general failure
  - 2: invalid usage or input
  - 3: missing dependency

---

## 8. Documentation Requirements
README must include:
- Overview
- Include "tested on" shields (from https://img.shields.io/)
- Requirements / dependencies
- Include high level architecture overview 
- Installation
- Uninstall steps
- Usage examples
- Configuration
- Troubleshooting
- Security notes
- License (Apache 2.0)

Operational tools must include docs/runbook.md.

---

## 9. Change Discipline
- Do not invent requirements
- If requirements are unclear, update docs/requirements.md first
- Implementation must map to acceptance criteria

