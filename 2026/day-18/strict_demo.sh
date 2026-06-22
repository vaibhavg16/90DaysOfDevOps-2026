#!/bin/bash

echo "========================================"
echo " DEMO 1: set -e (exit on error)"
echo "========================================"
bash -c '
set -e # If any command fails (returns non‑zero), immediately stop the script.Don’t continue to the next command
echo "Step 1: Before the failing command"
ls /this/path/does/not/exist
echo "Step 2: This will NEVER print — set -e stopped the script above"
' 2>&1 || true

echo ""
echo "========================================"
echo " DEMO 2: set -u (undefined variable)"
echo "========================================"
bash -c '
set -u # If you try to use a variable that hasn’t been defined, treat that as an error and stop.
echo "Step 1: Before using an undefined variable"
echo "$UNDEFINED_VAR"
echo "Step 2: This will NEVER print — set -u stopped the script above"
' 2>&1 || true

echo ""
echo "========================================"
echo " DEMO 3: set -o pipefail"
echo "========================================"
bash -c '
echo "--- WITHOUT pipefail ---"
cat /nonexistent/file 2>/dev/null | sort
echo "Exit code bash sees: $?"

echo ""
echo "--- WITH pipefail ---"
set -o pipefail      # If any command in a pipeline fails, the pipeline’s exit code should reflect that failure (typically the first non-zero exit).
cat /nonexistent/file 2>/dev/null | sort
echo "Exit code bash sees: $?"
' 2>&1 || true

echo ""
echo "========================================"
echo " ALL 3 FLAGS TOGETHER: set -euo pipefail"
echo "========================================"
bash -c '
set -euo pipefail
echo "Step 1: Script starts fine"
echo "Step 2: Now using an undefined variable..."
echo "$UNDEFINED_VAR"
echo "Step 3: This will NEVER print"
' 2>&1 || true

echo ""

