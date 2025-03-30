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

# Add remote repository
add-remote:
	@if git remote | grep -q origin; then \
		echo "Remote origin already exists."; \
	else \
		if [ -z "$(REMOTE_REPO)" ]; then \
			read -p "Enter remote repository URL: " REMOTE_REPO; \
		fi; \
		git remote add origin $(REMOTE_REPO); \
		echo "Added remote origin."; \
	fi

# Commit changes with a message (include emoji)
commit:
	@echo "Select a commit message:"
	@echo "1. 🚀 Initial commit"
	@echo "2. ✨ Add new feature"
	@echo "3. 🐛 Fix bug"
	@echo "4. 📝 Update documentation"
	@echo "5. 🔧 Refactor code"
	@echo "6. 👍 Other"
	@read -rp "Enter your choice (1-6): " choice && choice=$$(echo "$$choice" | tr -d '[:space:]'); \
	if [ "$$choice" = "1" ]; then \
		COMMIT_MSG="🚀 Initial commit"; \
	elif [ "$$choice" = "2" ]; then \
		COMMIT_MSG="✨ Add new feature"; \
	elif [ "$$choice" = "3" ]; then \
		COMMIT_MSG="🐛 Fix bug"; \
	elif [ "$$choice" = "4" ]; then \
		COMMIT_MSG="📝 Update documentation"; \
	elif [ "$$choice" = "5" ]; then \
		COMMIT_MSG="🔧 Refactor code"; \
	elif [ "$$choice" = "6" ]; then \
		read -rp "Enter custom commit message: " COMMIT_MSG; \
	else \
		echo "Invalid choice. Exiting."; \
		exit 1; \
	fi; \
	git add .; \
	git commit -m "$$COMMIT_MSG"; \
	echo "Committed changes with message: $$COMMIT_MSG"

# Bump version number
bump-version:
	@if [ -f VERSION ]; then \
		CURRENT_VERSION=$$(cat VERSION); \
		NEW_VERSION=$$(echo $$CURRENT_VERSION | awk -F. '{print $$1"."$$2"."($$3+1)}'); \
	else \
		NEW_VERSION="0.1.0"; \
	fi; \
	echo $$NEW_VERSION > VERSION; \
	@echo "Version bumped to $$NEW_VERSION"

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
