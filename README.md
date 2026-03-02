## Repository structure

```
changelog-cli-eval/
├── Dockerfile                        # Full environment definition
├── entrypoint.sh                     # Container entrypoint 
├── test_changelog.py                 # Test source — compiled to .pyc at build time, .py deleted
├── setup/
│   ├── init_testrepo.sh              # Seeds the git testrepo with 4 tags + edge-case commits
│   └── init_tests.sh                 # Compiles test_changelog.py → .pyc, deletes .py source
└── README.md
```