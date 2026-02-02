#!/bin/bash
# init-project.sh - Inicializa un proyecto con el sistema de memoria de Claude
# Uso: ./init-project.sh [directorio-proyecto]

set -e

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Directorio del plugin (donde está este script)
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES_DIR="$PLUGIN_DIR/templates"

print_header() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     Claude Productivity - Project Initialization           ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

detect_project_type() {
    local dir="$1"

    if [ -f "$dir/package.json" ]; then
        if grep -q '"next"' "$dir/package.json" 2>/dev/null; then
            echo "nextjs"
        elif grep -q '"react"' "$dir/package.json" 2>/dev/null; then
            echo "react"
        elif grep -q '"vue"' "$dir/package.json" 2>/dev/null; then
            echo "vue"
        else
            echo "node"
        fi
    elif [ -f "$dir/pyproject.toml" ] || [ -f "$dir/requirements.txt" ]; then
        echo "python"
    elif [ -f "$dir/Cargo.toml" ]; then
        echo "rust"
    elif [ -f "$dir/go.mod" ]; then
        echo "go"
    else
        echo "generic"
    fi
}

copy_templates() {
    local target_dir="$1"
    local project_name="$2"

    echo -e "${BLUE}Copiando templates...${NC}"

    # Crear directorio .claude si no existe
    mkdir -p "$target_dir/.claude/notes"

    # Copiar CLAUDE.md si no existe
    if [ ! -f "$target_dir/CLAUDE.md" ]; then
        sed "s/{{PROJECT_NAME}}/$project_name/g; s/{{DATE}}/$(date +%Y-%m-%d)/g" \
            "$TEMPLATES_DIR/CLAUDE.md.template" > "$target_dir/CLAUDE.md"
        echo -e "${GREEN}✓ Creado: CLAUDE.md${NC}"
    else
        echo -e "${YELLOW}⚠ CLAUDE.md ya existe, no se sobrescribió${NC}"
    fi

    # Copiar archivos de .claude
    if [ ! -f "$target_dir/.claude/mistakes.md" ]; then
        cp "$TEMPLATES_DIR/.claude/mistakes.md" "$target_dir/.claude/"
        echo -e "${GREEN}✓ Creado: .claude/mistakes.md${NC}"
    fi

    if [ ! -f "$target_dir/.claude/patterns.md" ]; then
        sed "s/{{DATE}}/$(date +%Y-%m-%d)/g" \
            "$TEMPLATES_DIR/.claude/patterns.md" > "$target_dir/.claude/patterns.md"
        echo -e "${GREEN}✓ Creado: .claude/patterns.md${NC}"
    fi

    # Copiar .gitkeep para notes
    cp "$TEMPLATES_DIR/.claude/notes/.gitkeep" "$target_dir/.claude/notes/" 2>/dev/null || true
}

customize_for_project() {
    local target_dir="$1"
    local project_type="$2"

    local claude_md="$target_dir/CLAUDE.md"

    case "$project_type" in
        nextjs)
            echo -e "${BLUE}Configurando para Next.js...${NC}"
            sed -i '' 's/<!-- Descomenta y completa según tu proyecto -->//' "$claude_md" 2>/dev/null || true
            sed -i '' 's/<!-- - Frontend: React\/Next.js\/Vue/- Frontend: Next.js 14+ (App Router)/' "$claude_md" 2>/dev/null || true
            ;;
        react)
            echo -e "${BLUE}Configurando para React...${NC}"
            sed -i '' 's/<!-- - Frontend: React\/Next.js\/Vue/- Frontend: React/' "$claude_md" 2>/dev/null || true
            ;;
        python)
            echo -e "${BLUE}Configurando para Python...${NC}"
            sed -i '' 's/<!-- - Backend: Node\/Python\/Go/- Backend: Python/' "$claude_md" 2>/dev/null || true
            ;;
        *)
            echo -e "${YELLOW}Proyecto genérico, personaliza CLAUDE.md manualmente${NC}"
            ;;
    esac
}

update_gitignore() {
    local target_dir="$1"
    local gitignore="$target_dir/.gitignore"

    # Verificar si ya tiene las entradas de Claude
    if grep -q ".claude/notes/" "$gitignore" 2>/dev/null; then
        return 0
    fi

    echo "" >> "$gitignore"
    echo "# Claude Code productivity" >> "$gitignore"
    echo "# Keep mistakes.md and patterns.md, ignore personal notes" >> "$gitignore"
    echo "# .claude/notes/*.md" >> "$gitignore"

    echo -e "${GREEN}✓ Actualizado: .gitignore${NC}"
}

print_next_steps() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                 ✓ Proyecto Inicializado!                   ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}Archivos creados:${NC}"
    echo "  • CLAUDE.md           - Reglas y contexto del proyecto"
    echo "  • .claude/mistakes.md - Errores a evitar"
    echo "  • .claude/patterns.md - Patrones preferidos"
    echo "  • .claude/notes/      - Notas por tarea"
    echo ""
    echo -e "${BLUE}Próximos pasos:${NC}"
    echo "  1. Edita CLAUDE.md con las reglas de tu proyecto"
    echo "  2. Cuando Claude cometa un error, dile:"
    echo "     'Guarda esto en tu memoria para no repetirlo'"
    echo "  3. Claude actualizará .claude/mistakes.md automáticamente"
    echo ""
    echo -e "${BLUE}Skills disponibles:${NC}"
    echo "  /tutor     - Modo de aprendizaje socrático"
    echo "  /techdebt  - Escanear deuda técnica"
    echo "  /memory    - Ver/actualizar memoria"
    echo "  /review    - Code review profesional"
    echo ""
}

main() {
    print_header

    # Directorio objetivo (argumento o directorio actual)
    local target_dir="${1:-.}"
    target_dir=$(cd "$target_dir" && pwd)

    local project_name=$(basename "$target_dir")
    local project_type=$(detect_project_type "$target_dir")

    echo -e "${BLUE}Proyecto: $project_name${NC}"
    echo -e "${BLUE}Tipo detectado: $project_type${NC}"
    echo ""

    # Copiar templates
    copy_templates "$target_dir" "$project_name"

    # Personalizar según tipo de proyecto
    customize_for_project "$target_dir" "$project_type"

    # Actualizar gitignore
    if [ -f "$target_dir/.gitignore" ]; then
        update_gitignore "$target_dir"
    fi

    print_next_steps
}

main "$@"
