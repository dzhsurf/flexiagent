.PHONE: install run test mypy ruff format clean 

PROJECT_NAME=flexisearch
PYTHON=python3
MYPY=mypy
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

mypy: ## Run mypy checker
	$(MYPY) --check-untyped-defs --ignore-missing-imports $(PROJECT_NAME)

ruff: ## Run ruff check
	$(PYTHON) -m ruff check $(PROJECT_NAME)

format: ## Format project code.
	$(PYTHON) -m ruff format $(PROJECT_NAME)
# $(PYTHON) -m isort $(PROJECT_NAME)

clean: ## Clean up build files.
	@echo "Cleaning up..."
	find . -type f -name '*.pyc' -delete
	find . -type d -name '__pycache__' -exec rm -r {} +
