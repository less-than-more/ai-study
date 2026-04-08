.PHONY: all setup_venv

# Check system family and set variables accordingly
ifeq ($(OS),Windows_NT)
    SYSTEM := Windows
    UV_INSTALL := powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
    VENV_ACTIVATE := .venv\Scripts\activate
    UV := uv
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        SYSTEM := Linux
    endif
    ifeq ($(UNAME_S),Darwin)
        SYSTEM := macOS
    endif
    UV_INSTALL := curl -LsSf https://astral.sh/uv/install.sh | sh
    VENV_ACTIVATE := source .venv/bin/activate
    UV := uv
endif

all: setup_venv

check_uv:
	@command -v uv >/dev/null 2>&1 || { \
		echo >&2 "uv is not installed. Installing..."; \
		$(UV_INSTALL); \
	}

setup_venv: check_uv
	$(UV) venv --python 3.9.7 && \
	source .venv/bin/activate && \
	$(UV) pip install --upgrade pip -i https://mirrors.aliyun.com/pypi/simple/ && \
	$(UV) pip install --no-cache-dir -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/

clean:
	@echo "Removing virtual environment..."
ifeq ($(SYSTEM),Windows)
	@powershell -c "if (Test-Path .venv) { rmdir -r -force .venv }"
else
	@rm -rf .venv
endif
