.PHONY: all check_uv setup_venv clean
.DEFAULT_GOAL := all

PYTHON_VERSION ?= 3.9.7
PIP_INDEX_URL ?= https://mirrors.aliyun.com/pypi/simple/

ifeq ($(OS),Windows_NT)
    SYSTEM := Windows
    UV_BIN := $(shell powershell -NoProfile -Command 'if (Get-Command uv -ErrorAction SilentlyContinue) { (Get-Command uv).Source } else { Join-Path $$env:USERPROFILE ".local\bin\uv.exe" }')
    PYTHON_BIN := .venv/Scripts/python.exe
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        SYSTEM := Linux
    else ifeq ($(UNAME_S),Darwin)
        SYSTEM := macOS
    else
        SYSTEM := $(UNAME_S)
    endif
    UV_BIN := $(shell if command -v uv >/dev/null 2>&1; then command -v uv; else echo $$HOME/.local/bin/uv; fi)
    PYTHON_BIN := .venv/bin/python
endif

all: setup_venv

check_uv:
ifeq ($(OS),Windows_NT)
	@powershell -NoProfile -ExecutionPolicy Bypass -Command "if (Get-Command uv -ErrorAction SilentlyContinue) { exit 0 } else { Write-Host 'uv is not installed. Installing...'; irm https://astral.sh/uv/install.ps1 | iex }"
else
	@command -v uv >/dev/null 2>&1 || { \
		echo "uv is not installed. Installing..."; \
		curl -LsSf https://astral.sh/uv/install.sh | sh; \
	}
endif

setup_venv: check_uv
	@echo "Setting up virtual environment on $(SYSTEM)..."
	@"$(UV_BIN)" venv --python $(PYTHON_VERSION)
	@"$(UV_BIN)" pip install --python "$(PYTHON_BIN)" --upgrade pip -i "$(PIP_INDEX_URL)"
	@"$(UV_BIN)" pip install --python "$(PYTHON_BIN)" --no-cache-dir -r requirements.txt -i "$(PIP_INDEX_URL)"

clean:
	@echo "Removing virtual environment..."
ifeq ($(OS),Windows_NT)
	@powershell -NoProfile -Command "if (Test-Path .venv) { Remove-Item -Recurse -Force .venv }"
else
	@rm -rf .venv
endif
