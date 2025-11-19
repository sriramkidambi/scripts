#!/bin/bash

# Git auto-commit script that works in current directory
# Adds changes, commits with date, and pushes to main

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Add all changes
git add .

# Get current date for commit message
current_date=$(date "+%Y-%m-%d %H:%M:%S")
commit_message="Auto-commit: $current_date"

# Commit with date
git commit -m "$commit_message"

# Push to main branch
git push origin main

echo "Changes committed and pushed to main"