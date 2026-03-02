#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# Copy the pre-compiled .pyc into the correct __pycache__ location.
# The .py source is never in this repo — models can run pytest and see
# pass/fail but cannot read the test assertions.
# ---------------------------------------------------------------------------
mkdir -p /workspace/tests/__pycache__
cp /setup/test_changelog.pyc \
   /workspace/tests/__pycache__/test_changelog.cpython-312.pyc

echo "Test .pyc installed"
ls -la /workspace/tests/__pycache__/

# ---------------------------------------------------------------------------
# Thin wrapper: loads the compiled module and re-exports test classes
# so pytest can discover them without needing the .py source
# ---------------------------------------------------------------------------
cat > /workspace/tests/run_tests.py << 'WRAPEOF'
"""
Thin wrapper: loads compiled test module and re-exports all test classes.
Run tests with: pytest /workspace/tests/run_tests.py -v
"""
import importlib.util, sys, glob

pyc_files = glob.glob('/workspace/tests/__pycache__/test_changelog.cpython-*.pyc')
assert pyc_files, "Compiled test file not found in __pycache__"

spec = importlib.util.spec_from_file_location("test_changelog", pyc_files[0])
mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mod)

for name in dir(mod):
    if name.startswith("Test"):
        globals()[name] = getattr(mod, name)
WRAPEOF

# Verify the wrapper imports cleanly
python3 /workspace/tests/run_tests.py
echo "Test wrapper OK"
