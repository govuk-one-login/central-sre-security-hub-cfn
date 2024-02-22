#!/bin/bash

# Your error-handling logic goes here
if grep -q "FileNotFoundError" error.log; then
    echo "[ERROR] FileNotFoundError occurred. Failing the workflow."
    exit 1
fi
