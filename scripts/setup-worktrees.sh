#!/bin/bash
# setup-worktrees.sh - Crea worktrees para trabajo paralelo con Claude
# Uso: ./setup-worktrees.sh [nombre-base]

set -e

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Configuración
DEFAULT_WORKTREES=("analysis" "feature" "hotfix")

print_header() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║         Claude Code Worktrees Setup                        ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "${RED}Error: No estás en un repositorio git${NC}"
        exit 1
    fi
}

get_main_branch() {
    # Detectar la rama principal (main o master)
    if git show-ref --verify --quiet refs/heads/main; then
        echo "main"
    elif git show-ref --verify --quiet refs/heads/master; then
        echo "master"
    else
        git branch --show-current
    fi
}

create_worktree() {
    local name="$1"
    local branch="$2"
    local base_dir="$3"
    local worktree_path="${base_dir}-${name}"

    if [ -d "$worktree_path" ]; then
        echo -e "${YELLOW}⚠ Worktree '$name' ya existe en $worktree_path${NC}"
        return 0
    fi

    echo -e "${BLUE}Creating worktree: $name${NC}"

    # Crear worktree
    git worktree add "$worktree_path" "$branch" 2>/dev/null || \
    git worktree add -b "worktree-$name" "$worktree_path" "$branch"

    echo -e "${GREEN}✓ Created: $worktree_path${NC}"
}

setup_aliases() {
    local base_name="$1"
    local shell_config=""

    # Detectar shell config file
    if [ -f "$HOME/.zshrc" ]; then
        shell_config="$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        shell_config="$HOME/.bashrc"
    else
        echo -e "${YELLOW}⚠ No se encontró .zshrc o .bashrc${NC}"
        return 1
    fi

    # Verificar si los aliases ya existen
    if grep -q "# Claude Code Worktree Aliases" "$shell_config" 2>/dev/null; then
        echo -e "${YELLOW}⚠ Aliases ya configurados en $shell_config${NC}"
        return 0
    fi

    echo ""
    echo -e "${BLUE}¿Quieres agregar aliases de navegación rápida?${NC}"
    echo "Esto agregará za, zb, zc a tu $shell_config"
    read -p "Agregar aliases? (y/n): " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cat >> "$shell_config" << 'EOF'

# Claude Code Worktree Aliases
# Navega rápidamente entre worktrees
alias za='cd "$(git rev-parse --show-toplevel 2>/dev/null | sed "s/-[^-]*$/-analysis/")" 2>/dev/null || echo "Not in a git repo"'
alias zb='cd "$(git rev-parse --show-toplevel 2>/dev/null | sed "s/-[^-]*$/-feature/")" 2>/dev/null || echo "Not in a git repo"'
alias zc='cd "$(git rev-parse --show-toplevel 2>/dev/null | sed "s/-[^-]*$/-hotfix/")" 2>/dev/null || echo "Not in a git repo"'
alias zm='cd "$(git rev-parse --show-toplevel 2>/dev/null | sed "s/-[^-]*$//")" 2>/dev/null || echo "Not in a git repo"'

# Función para listar worktrees
worktrees() {
    git worktree list
}

# Función para crear nuevo worktree
wt-new() {
    local name="${1:-temp}"
    local branch="${2:-$(git branch --show-current)}"
    local base="$(basename $(git rev-parse --show-toplevel))"
    git worktree add "../${base}-${name}" "$branch"
    cd "../${base}-${name}"
}

# Función para eliminar worktree
wt-remove() {
    local name="${1}"
    if [ -z "$name" ]; then
        echo "Usage: wt-remove <worktree-name>"
        return 1
    fi
    local base="$(basename $(git rev-parse --show-toplevel) | sed 's/-[^-]*$//')"
    git worktree remove "../${base}-${name}" --force
}
EOF

        echo -e "${GREEN}✓ Aliases agregados a $shell_config${NC}"
        echo -e "${YELLOW}Ejecuta 'source $shell_config' o abre una nueva terminal${NC}"
    fi
}

print_usage() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    ✓ Setup Complete!                       ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}Worktrees creados:${NC}"
    git worktree list
    echo ""
    echo -e "${BLUE}Uso rápido:${NC}"
    echo "  za  →  Ir a worktree de análisis"
    echo "  zb  →  Ir a worktree de feature"
    echo "  zc  →  Ir a worktree de hotfix"
    echo "  zm  →  Ir al repo principal"
    echo ""
    echo -e "${BLUE}Comandos útiles:${NC}"
    echo "  worktrees      →  Listar todos los worktrees"
    echo "  wt-new <name>  →  Crear nuevo worktree"
    echo "  wt-remove <n>  →  Eliminar worktree"
    echo ""
    echo -e "${BLUE}Workflow recomendado:${NC}"
    echo "  1. za → Claude para análisis/investigación"
    echo "  2. zb → Claude para desarrollo de feature"
    echo "  3. zc → Claude para hotfixes urgentes"
    echo ""
}

main() {
    print_header
    check_git_repo

    local main_branch=$(get_main_branch)
    local repo_root=$(git rev-parse --show-toplevel)
    local base_name=$(basename "$repo_root")

    echo -e "${BLUE}Repositorio: $base_name${NC}"
    echo -e "${BLUE}Rama principal: $main_branch${NC}"
    echo ""

    # Crear worktrees
    for wt_name in "${DEFAULT_WORKTREES[@]}"; do
        create_worktree "$wt_name" "$main_branch" "$repo_root"
    done

    # Configurar aliases
    setup_aliases "$base_name"

    # Mostrar uso
    print_usage
}

main "$@"
