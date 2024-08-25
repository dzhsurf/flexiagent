.PHONE: install run test format clean

PROJECT_NAME=flexisearch
PYTHON=python3
PIP=$(PYTHON) -m pip

.DEFAULT_GOAL := help

help: ## show this help.
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'
	@echo ""
	@echo "Default target is 'help', showing this message."

install: ## Install dependencies.
	poetry install

run: ## Local run 
	$(PYTHON) $(PROJECT_NAME)/main.py

test: ## Run tests.
	$(PYTHON) -m pytest tests/

format: ## Format project code.
	$(PYTHON) -m black $(PROJECT_NAME)
	$(PYTHON) -m isort $(PROJECT_NAME)

clean: ## Clean up build files.
	@echo "Cleaning up..."
	find . -type f -name '*.pyc' -delete
	find . -type d -name '__pycache__' -exec rm -r {} +
