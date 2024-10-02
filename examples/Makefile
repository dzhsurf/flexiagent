.PHONE: help docker-run docker-build local-run

EXAMPLE ?= "gradio-simple-chatbot"

help: ## show this help.
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'
	@echo ""
	@echo "Default target is 'help', showing this message."

docker-run: ## docker-run
	docker compose -f docker/docker-compose.yaml up --build

docker-build: ## docker-build
	docker build -t flexiagent-example -f docker/Dockerfile .

local-run: ## local-run EXAMPLE=<xxx>
	python main.py $(EXAMPLE)