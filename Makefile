# Makefile for setting up Poetry, installing dependencies, and logging output

# Variables
POETRY_INSTALLER_URL := https://install.python-poetry.org
PYTHON_EXECUTABLE := python3
LOG_FILE := setup.log

# Default target
.DEFAULT_GOAL := setup

# Function to log messages to file
define log
	@echo "$(1)" | tee -a $(LOG_FILE)
endef

# Clean the log file at the start
$(shell > $(LOG_FILE))

# Target to check if Poetry is installed
check_poetry:
	$(call log, "Checking if Poetry is installed...")
	@command -v poetry >/dev/null 2>&1 || { $(call log, "Poetry is not installed. Installing..."); $(PYTHON_EXECUTABLE) -c "$$(curl -sSL $(POETRY_INSTALLER_URL))" | tee -a $(LOG_FILE); }

# Target to install Poetry
install_poetry: check_poetry
	$(call log, "Poetry is installed.")

# Target to install dependencies using Poetry
install_dependencies: install_poetry
	$(call log, "Installing dependencies using Poetry...")
	poetry install | tee -a $(LOG_FILE)
	chmod +x .venv/bin/activate
	chmod +x .venv/bin/activate.fish

# Main setup target
setup: install_dependencies
	$(call log, "Setup completed successfully.")

# Clean target to remove virtual environment created by Poetry (optional)
clean:
	$(call log, "Removing Poetry virtual environment...")
	poetry env remove --all | tee -a $(LOG_FILE)

.PHONY: check_poetry install_poetry install_dependencies setup clean
