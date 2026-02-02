#!/bin/bash
# lint-check.sh - Ejecuta linter después de guardar archivos
# Uso: Este hook se ejecuta automáticamente después de Write

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Detectar linter disponible
detect_linter() {
    if [ -f "package.json" ]; then
        if grep -q '"eslint"' package.json 2>/dev/null; then
            echo "eslint"
        elif grep -q '"biome"' package.json 2>/dev/null; then
            echo "biome"
        fi
    elif [ -f "pyproject.toml" ]; then
        if grep -q 'ruff' pyproject.toml 2>/dev/null; then
            echo "ruff"
        elif grep -q 'flake8' pyproject.toml 2>/dev/null; then
            echo "flake8"
        fi
    elif [ -f "Cargo.toml" ]; then
        echo "clippy"
    fi
}

# Ejecutar linter
run_linter() {
    local linter="$1"
    local file="$2"

    case "$linter" in
        eslint)
            if [ -n "$file" ]; then
                npx eslint "$file" --fix 2>/dev/null
            else
                npx eslint . --fix 2>/dev/null
            fi
            ;;
        biome)
            npx biome check --apply 2>/dev/null
            ;;
        ruff)
            ruff check --fix 2>/dev/null
            ;;
        flake8)
            flake8 2>/dev/null
            ;;
        clippy)
            cargo clippy --fix --allow-dirty 2>/dev/null
            ;;
        *)
            return 0
            ;;
    esac
}

main() {
    local changed_file="${1:-}"
    local linter=$(detect_linter)

    if [ -z "$linter" ]; then
        exit 0
    fi

    echo -e "${YELLOW}Running $linter...${NC}"

    if run_linter "$linter" "$changed_file"; then
        echo -e "${GREEN}✓ Linting passed${NC}"
        exit 0
    else
        echo -e "${RED}✗ Linting failed${NC}"
        exit 1
    fi
}

main "$@"
