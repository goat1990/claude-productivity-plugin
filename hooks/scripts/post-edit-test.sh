#!/bin/bash
# post-edit-test.sh - Ejecuta tests automáticamente después de editar código
# Uso: Este hook se ejecuta automáticamente después de Write/Edit

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Detectar el tipo de proyecto y runner de tests
detect_test_runner() {
    if [ -f "package.json" ]; then
        # Node.js project
        if grep -q '"vitest"' package.json 2>/dev/null; then
            echo "vitest"
        elif grep -q '"jest"' package.json 2>/dev/null; then
            echo "jest"
        elif grep -q '"mocha"' package.json 2>/dev/null; then
            echo "mocha"
        elif grep -q '"test"' package.json 2>/dev/null; then
            echo "npm-test"
        fi
    elif [ -f "pytest.ini" ] || [ -f "pyproject.toml" ]; then
        echo "pytest"
    elif [ -f "Cargo.toml" ]; then
        echo "cargo"
    elif [ -f "go.mod" ]; then
        echo "go"
    fi
}

# Ejecutar tests según el runner detectado
run_tests() {
    local runner="$1"
    local changed_file="$2"

    case "$runner" in
        vitest)
            # Vitest con modo watch desactivado, solo archivos relacionados
            npx vitest run --reporter=dot --passWithNoTests 2>/dev/null
            ;;
        jest)
            # Jest con modo bail (para en el primer error)
            npx jest --bail --passWithNoTests --silent 2>/dev/null
            ;;
        mocha)
            npx mocha --exit 2>/dev/null
            ;;
        npm-test)
            npm test --silent 2>/dev/null || true
            ;;
        pytest)
            python -m pytest -x -q 2>/dev/null
            ;;
        cargo)
            cargo test --quiet 2>/dev/null
            ;;
        go)
            go test ./... -v 2>/dev/null
            ;;
        *)
            # No test runner detected
            return 0
            ;;
    esac
}

# Main
main() {
    # Archivo que fue editado (pasado como argumento por el hook)
    local changed_file="${1:-}"

    # Detectar runner
    local runner=$(detect_test_runner)

    if [ -z "$runner" ]; then
        # No hay test runner, salir silenciosamente
        exit 0
    fi

    # Ejecutar tests
    echo -e "${YELLOW}Running tests...${NC}"

    if run_tests "$runner" "$changed_file"; then
        echo -e "${GREEN}✓ Tests passed${NC}"
        exit 0
    else
        echo -e "${RED}✗ Tests failed${NC}"
        echo "Fix the failing tests before continuing"
        exit 1
    fi
}

main "$@"
