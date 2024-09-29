.PHONE: install run test unittest mypy ruff format isort clean 

PROJECT_NAME=flexiagent
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
	$(PYTHON) -m pytest -s tests/

unittest: ## Run unittest.
	$(PYTHON) -s tests/test_text2sql_unittest.py

mypy: ## Run mypy checker
	$(MYPY) --check-untyped-defs --ignore-missing-imports $(PROJECT_NAME)

ruff: ## Run ruff check
	$(PYTHON) -m ruff check $(PROJECT_NAME)

format: ## Format project code.
	$(PYTHON) -m ruff format $(PROJECT_NAME) examples tests

isort: ## Format imports
	$(PYTHON) -m isort $(PROJECT_NAME) examples tests
	$(PYTHON) -m ruff format $(PROJECT_NAME) examples tests

clean: ## Clean up build files.
	@echo "Cleaning up..."
	find . -type f -name '*.pyc' -delete
	find . -type d -name '__pycache__' -exec rm -r {} +
