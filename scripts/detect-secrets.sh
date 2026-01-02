#!/usr/bin/env bash
###############################################################################
# detect-secrets.sh
#
# Pre-commit hook to detect secrets, API keys, and access tokens in staged
# files. This script implements the requirements from docs/ai/CONTEXT.md
# Section 7.1.4 - Code and Script Scanning Requirements.
#
# This script distinguishes between:
# - Real secrets (high-entropy strings, known token patterns)
# - False positives (variable names, example values, API call patterns)
###############################################################################

set -euo pipefail

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Patterns that indicate secrets (high confidence)
declare -a SECRET_PATTERNS=(
  # API Keys (various formats)
  'sk_live_[a-zA-Z0-9]{24,}'
  'sk_test_[a-zA-Z0-9]{24,}'
  'pk_live_[a-zA-Z0-9]{24,}'
  'pk_test_[a-zA-Z0-9]{24,}'
  'AIza[0-9A-Za-z_-]{35}'
  'AKIA[0-9A-Z]{16}'
  'sk-[a-zA-Z0-9]{32,}'
  'xox[baprs]-[0-9]{10,13}-[0-9]{10,13}-[a-zA-Z0-9]{24,}'

  # GitHub tokens
  'ghp_[a-zA-Z0-9]{36}'
  'gho_[a-zA-Z0-9]{36}'
  'ghu_[a-zA-Z0-9]{36}'
  'ghs_[a-zA-Z0-9]{36}'
  'ghr_[a-zA-Z0-9]{36}'

  # AWS tokens
  'AKIA[0-9A-Z]{16}'
  'ASIA[0-9A-Z]{16}'

  # Generic high-entropy strings (32+ chars, mixed case, numbers)
  '[a-zA-Z0-9+/=]{40,}'

  # JWT tokens
  'eyJ[a-zA-Z0-9_-]{10,}\.[a-zA-Z0-9_-]{10,}\.[a-zA-Z0-9_-]{10,}'

  # Private keys (PEM format)
  '-----BEGIN (RSA |EC |DSA |OPENSSH )?PRIVATE KEY-----'

  # OAuth tokens
  'ya29\.[a-zA-Z0-9_-]+'
  '1//[a-zA-Z0-9_-]+'
)

# Patterns that are likely false positives (allowlist)
declare -a ALLOWLIST_PATTERNS=(
  # Example/placeholder values
  'YOUR_API_KEY_HERE'
  'your-api-key-here'
  'example\.com'
  'test_key'
  'demo_key'
  'placeholder'
  'CHANGE_ME'
  'REPLACE_ME'

  # Variable names (not values)
  'api_key\s*='
  'API_KEY\s*='
  'access_token\s*='
  'secret\s*='

  # Common API call patterns (URLs, endpoints)
  'https?://[a-zA-Z0-9.-]+'
  'api/v[0-9]+'
  '/api/'

  # Documentation/comments
  '^\s*#.*(api|key|token|secret)'
  '^\s*//.*(api|key|token|secret)'
  '^\s*\*.*(api|key|token|secret)'

  # Test files
  'test.*\.(py|js|sh)$'
  '.*test\.(py|js|sh)$'
  'mock.*\.(py|js|sh)$'

  # Example files
  '\.example$'
  '\.sample$'
  'example\.'
)

# Files to exclude from scanning
declare -a EXCLUDE_PATTERNS=(
  '\.git/'
  '\.env\.example$'
  '\.gitignore$'
  'artifacts/'
  '\.pre-commit-cache/'
  'node_modules/'
  '\.venv/'
  'venv/'
  '__pycache__/'
  '\.pytest_cache/'
  '\.mypy_cache/'
  'dist/'
  'build/'
)

# Function to check if file should be excluded
should_exclude_file() {
  local file="$1"
  for pattern in "${EXCLUDE_PATTERNS[@]}"; do
    if [[ "${file}" =~ ${pattern} ]]; then
      return 0
    fi
  done
  return 1
}

# Function to check if pattern matches allowlist
is_allowlisted() {
  local line="$1"
  for pattern in "${ALLOWLIST_PATTERNS[@]}"; do
    if echo "${line}" | grep -qiE "${pattern}"; then
      return 0
    fi
  done
  return 1
}

# Function to calculate entropy (simple approximation)
calculate_entropy() {
  local str="$1"
  local len=${#str}
  if [[ ${len} -lt 16 ]]; then
    echo "0"
    return
  fi

  # Count unique characters
  local unique_chars
  unique_chars=$(echo "${str}" | fold -w1 | sort -u | wc -l)
  # Simple entropy approximation
  echo "${unique_chars}"
}

# Main detection function
detect_secrets() {
  local found_secrets=0
  local files_checked=0

  # Get list of staged files
  local staged_files
  staged_files=$(git diff --cached --name-only --diff-filter=ACM 2> /dev/null || true)

  if [[ -z "${staged_files}" ]]; then
    echo -e "${GREEN}✓ No staged files to check${NC}"
    return 0
  fi

  while IFS= read -r file; do
    [[ -z "${file}" ]] && continue

    # Skip excluded files
    if should_exclude_file "${file}"; then
      continue
    fi

    # Skip if file doesn't exist (might be deleted)
    [[ ! -f "${file}" ]] && continue

    files_checked=$((files_checked + 1))

    # Check each line for secret patterns
    local line_num=0
    while IFS= read -r line || [[ -n "${line}" ]]; do
      line_num=$((line_num + 1))

      # Skip allowlisted patterns
      if is_allowlisted "${line}"; then
        continue
      fi

      # Check against secret patterns
      for pattern in "${SECRET_PATTERNS[@]}"; do
        if echo "${line}" | grep -qE "${pattern}"; then
          # Additional check: high entropy
          local matched_part
          matched_part=$(echo "${line}" | grep -oE "${pattern}" | head -1)
          local entropy
          entropy=$(calculate_entropy "${matched_part}")

          # If it's a high-entropy match, flag it
          if [[ ${entropy} -gt 8 ]] || echo "${pattern}" | grep -qE "(BEGIN|PRIVATE|KEY|ghp_|sk_|AIza|AKIA)"; then
            echo -e "${RED}✗ Potential secret found in ${file}:${line_num}${NC}"
            echo -e "  ${YELLOW}Pattern:${NC} ${pattern}"
            echo -e "  ${YELLOW}Context:${NC} ${line:0:100}..."
            echo ""
            found_secrets=$((found_secrets + 1))
            break
          fi
        fi
      done
    done < "${file}"
  done <<< "${staged_files}"

  if [[ ${found_secrets} -gt 0 ]]; then
    echo -e "${RED}❌ Found ${found_secrets} potential secret(s) in staged files${NC}"
    echo -e "${YELLOW}If these are false positives, add them to the allowlist in scripts/detect-secrets.sh${NC}"
    echo -e "${YELLOW}Or use example placeholders like: YOUR_API_KEY_HERE${NC}"
    return 1
  fi

  if [[ ${files_checked} -gt 0 ]]; then
    echo -e "${GREEN}✓ Checked ${files_checked} file(s) - no secrets detected${NC}"
  fi

  return 0
}

# Run detection
main() {
  detect_secrets
}

main "$@"
