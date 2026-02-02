#!/bin/bash
# install.sh - Instala el plugin de productividad de Claude Code
# Uso: ./install.sh

set -e

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Directorios
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_CONFIG_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_CONFIG_DIR/skills"

print_header() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║      Claude Productivity Plugin - Installation             ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

check_claude_code() {
    if ! command -v claude &> /dev/null; then
        echo -e "${YELLOW}⚠ Claude Code CLI no detectado${NC}"
        echo "  Asegúrate de tener Claude Code instalado"
        echo "  https://claude.ai/code"
        echo ""
    else
        echo -e "${GREEN}✓ Claude Code detectado${NC}"
    fi
}

install_skills() {
    echo -e "${BLUE}Instalando skills...${NC}"

    mkdir -p "$SKILLS_DIR"

    # Copiar skills
    for skill in "$PLUGIN_DIR/skills/"*.md; do
        local skill_name=$(basename "$skill")
        if [ -f "$skill" ]; then
            cp "$skill" "$SKILLS_DIR/"
            echo -e "${GREEN}  ✓ $skill_name${NC}"
        fi
    done
}

install_hooks() {
    echo -e "${BLUE}Configurando hooks...${NC}"

    local hooks_dir="$CLAUDE_CONFIG_DIR/hooks"
    mkdir -p "$hooks_dir"

    # Copiar hooks
    for hook in "$PLUGIN_DIR/hooks/"*.sh; do
        if [ -f "$hook" ]; then
            cp "$hook" "$hooks_dir/"
            chmod +x "$hooks_dir/$(basename "$hook")"
            echo -e "${GREEN}  ✓ $(basename "$hook")${NC}"
        fi
    done

    # Copiar configuración de hooks
    if [ -f "$PLUGIN_DIR/hooks/hooks-config.json" ]; then
        cp "$PLUGIN_DIR/hooks/hooks-config.json" "$hooks_dir/"
        echo -e "${GREEN}  ✓ hooks-config.json${NC}"
    fi
}

make_scripts_executable() {
    echo -e "${BLUE}Configurando scripts...${NC}"

    chmod +x "$PLUGIN_DIR/scripts/"*.sh 2>/dev/null || true
    echo -e "${GREEN}  ✓ Scripts ejecutables${NC}"
}

add_to_path() {
    local shell_config=""

    if [ -f "$HOME/.zshrc" ]; then
        shell_config="$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        shell_config="$HOME/.bashrc"
    fi

    if [ -z "$shell_config" ]; then
        echo -e "${YELLOW}⚠ No se encontró .zshrc o .bashrc${NC}"
        return 1
    fi

    # Verificar si ya está en PATH
    if grep -q "claude-productivity-plugin" "$shell_config" 2>/dev/null; then
        echo -e "${YELLOW}⚠ Plugin ya está en PATH${NC}"
        return 0
    fi

    echo ""
    read -p "¿Agregar scripts al PATH? (y/n): " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cat >> "$shell_config" << EOF

# Claude Productivity Plugin
export PATH="\$PATH:$PLUGIN_DIR/scripts"
EOF
        echo -e "${GREEN}✓ Agregado al PATH en $shell_config${NC}"
    fi
}

print_completion() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              ✓ Instalación Completada!                     ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}Skills instalados:${NC}"
    echo "  /tutor      - Modo de aprendizaje socrático"
    echo "  /techdebt   - Detector de deuda técnica"
    echo "  /memory     - Sistema de memoria persistente"
    echo "  /review     - Code review profesional"
    echo ""
    echo -e "${BLUE}Scripts disponibles:${NC}"
    echo "  init-project.sh   - Inicializar proyecto con memoria"
    echo "  setup-worktrees.sh - Configurar worktrees"
    echo ""
    echo -e "${BLUE}Uso:${NC}"
    echo "  1. cd tu-proyecto"
    echo "  2. $PLUGIN_DIR/scripts/init-project.sh"
    echo "  3. Empieza a usar Claude con memoria persistente!"
    echo ""
    echo -e "${YELLOW}Reinicia tu terminal o ejecuta:${NC}"
    echo "  source ~/.zshrc  (o ~/.bashrc)"
    echo ""
}

main() {
    print_header
    check_claude_code

    install_skills
    install_hooks
    make_scripts_executable
    add_to_path

    print_completion
}

main "$@"
