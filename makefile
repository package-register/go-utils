# Variables
REMOTE_REPO ?=
COMMIT_MSG ?= "Update project"

# Default target
all: help

# Help target
help:
	@echo "\033[1;32mMakefile Usage:\033[0m"
	@echo "  \033[1;32mmake add-remote\033[0m         - Add remote git repository"
	@echo "  \033[1;32mmake commit\033[0m             - Commit changes with a message (include emoji)"
	@echo "  \033[1;32mmake bump-version\033[0m       - Create a new version number"
	@echo "  \033[1;32mmake test\033[0m               - Run all tests"
	@echo "  \033[1;32mmake clean\033[0m              - Clean generated files"

# Add/update remote repository
add-remote:
	@# 捕获并验证URL参数
	@$(eval RAW_ARGS := $(filter-out $@,$(MAKECMDGOALS)))
	@$(eval REMOTE_REPO := $(shell echo '$(RAW_ARGS)' | grep -Eo '(git@|https?://)[a-zA-Z0-9./:@_-]+'))
	
	@if [ -n "$(REMOTE_REPO)" ]; then \
		if git remote | grep -q origin; then \
			git remote set-url origin $(REMOTE_REPO) >/dev/null; \
			echo "✓ Remote origin updated to: $(REMOTE_REPO)"; \
		else \
			git remote add origin $(REMOTE_REPO) >/dev/null; \
			echo "✓ Remote origin added: $(REMOTE_REPO)"; \
		fi; \
		exit 0; \
	fi; \
	
	@if [ -n "$(RAW_ARGS)" ]; then \
		echo "⚠️ Invalid repository URL: '$(RAW_ARGS)'"; \
		echo "Valid formats: git@... or https://..."; \
		exit 1; \
	fi; \
	
	@# 交互模式
	@if git remote | grep -q origin; then \
		current_url=$$(git remote get-url origin); \
		read -p "Current remote: $$current_url\nUpdate? [y/N]: " confirm; \
		if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
			read -p "Enter new URL: " REMOTE_REPO; \
			git remote set-url origin "$$REMOTE_REPO" >/dev/null; \
			echo "✓ Remote URL updated"; \
		else \
			echo "ℹ️ Keeping existing URL"; \
		fi; \
	else \
		read -p "Enter repository URL: " REMOTE_REPO; \
		git remote add origin "$$REMOTE_REPO" >/dev/null; \
		echo "✓ Remote origin added"; \
	fi;

# Commit changes with a message (include emoji)
commit:
	@if [ -z "$$(git status --porcelain)" ]; then \
		echo "No changes to commit. Exiting."; \
		exit 0; \
	fi; \
	echo "Select a commit message:"; \
	echo "1. 🚀 Initial commit"; \
	echo "2. ✨ Add new feature"; \
	echo "3. 🐛 Fix bug"; \
	echo "4. 📝 Update documentation"; \
	echo "5. 🔧 Refactor code"; \
	echo "6. 👍 Other"; \
	read -rp "Enter your choice (1-6): " choice; \
	choice=$$(echo "$$choice" | tr -cd '0-9'); \
	if [ -z "$$choice" ]; then \
		echo "Invalid input. Exiting."; \
		exit 1; \
	elif [ "$$choice" -eq 1 ]; then \
		COMMIT_MSG="🚀 Initial commit"; \
	elif [ "$$choice" -eq 2 ]; then \
		COMMIT_MSG="✨ Add new feature"; \
	elif [ "$$choice" -eq 3 ]; then \
		COMMIT_MSG="🐛 Fix bug"; \
	elif [ "$$choice" -eq 4 ]; then \
		COMMIT_MSG="📝 Update documentation"; \
	elif [ "$$choice" -eq 5 ]; then \
		COMMIT_MSG="🔧 Refactor code"; \
	elif [ "$$choice" -eq 6 ]; then \
		read -rp "Enter custom commit message: " COMMIT_MSG; \
	else \
		echo "Invalid choice. Exiting."; \
		exit 1; \
	fi; \
	git add .; \
	if git commit -m "$$COMMIT_MSG"; then \
		echo "Committed changes with message: $$COMMIT_MSG"; \
	else \
		echo "Commit failed (no changes to commit)."; \
	fi

# Bump version number
bump-version:
	@LATEST_TAG=$$(git describe --tags --abbrev=0 2>/dev/null); \
	if [ -z "$$LATEST_TAG" ]; then \
		NEW_VERSION="v0.1.0"; \
	else \
		NEW_VERSION=$$(echo $$LATEST_TAG | awk -F. '{major=substr($$1,2); print "v"major"."$$2"."($$3+1)}'); \
	fi; \
	git tag -a $$NEW_VERSION -m "Release $$NEW_VERSION"; \
	echo "New version tag $$NEW_VERSION created"

build:
	@echo "Building binaries..."
	@goreleaser build --snapshot --clean

# Run all tests
test:
	@go test ./...
	@echo "All tests completed."

# Clean generated files
clean:
	@go clean -testcache
	@rm -f $(shell find . -name "*.out")
	@rm -f $(shell find . -name "*.test")
	@rm -f $(shell find . -name "VERSION")
	@echo "Cleaned up generated files."
