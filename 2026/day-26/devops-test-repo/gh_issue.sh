#!/bin/bash

# Use an existing repo (change this to your actual repo)
REPO="vaibhavg16/devops-test-repo"

# 1. Auto-create issues from a monitoring script
if ! curl -s https://myapp.com/health | grep -q "ok"; then
    gh issue create \
        --repo "$REPO" \
        --title "Health check failed at $(date)" \
        --body "Automated alert: /health endpoint returned non-ok status" \
        --label "critical"
fi

# 2. Count open bugs in CI/CD — fail deployment if too many
BUG_COUNT=$(gh issue list --repo "$REPO" --label "bug" --state open --json number | jq length)
if [ "$BUG_COUNT" -gt 5 ]; then
    echo "Too many open bugs ($BUG_COUNT). Blocking release."
    exit 1
fi

# 3. Auto-close stale issues with a comment
gh issue list --repo "$REPO" --state open --json number,updatedAt | \
    jq '.[] | select(.updatedAt < "2026-01-01")' | \
    jq '.number' | \
    xargs -I{} gh issue close {} --comment "Closing as stale — no activity in 6 months"
