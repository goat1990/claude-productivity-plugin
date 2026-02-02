# Claude Productivity Plugin

> Sistema de productividad para Claude Code: memoria persistente, aprendizaje socrático, quality gates y worktrees paralelos.

Basado en los tips del equipo de Anthropic para maximizar la productividad con Claude Code.

## Features

### 1. Sistema de Memoria Persistente

Claude recuerda tus correcciones y preferencias entre sesiones.

- **CLAUDE.md** - Reglas del proyecto que Claude lee automáticamente
- **mistakes.md** - Errores corregidos que Claude NO repetirá
- **patterns.md** - Patrones de código preferidos
- **notes/** - Notas por feature/tarea

### 2. Skills Personalizados

| Skill | Comando | Descripción |
|-------|---------|-------------|
| Socratic Tutor | `/tutor` | Aprende con preguntas, no lecturas |
| Tech Debt | `/techdebt` | Escanea deuda técnica y código duplicado |
| Memory | `/memory` | Gestiona la memoria de Claude |
| Review | `/review` | Code review profesional antes de commits |

### 3. Hooks Automáticos

- **Tests automáticos** - Se ejecutan después de cada edición
- **Linting** - Verifica estilo de código
- **Notificaciones** - Alerta cuando termina una tarea larga

### 4. Worktrees Paralelos

Trabaja en múltiples tareas simultáneamente con diferentes sesiones de Claude:

```bash
za  # → worktree de análisis
zb  # → worktree de feature
zc  # → worktree de hotfix
zm  # → repo principal
```

## Instalación

### Opción 1: Instalación Rápida

```bash
git clone https://github.com/goat1990/claude-productivity-plugin.git
cd claude-productivity-plugin
./scripts/install.sh
```

### Opción 2: Manual

1. **Clonar el repositorio**
```bash
git clone https://github.com/goat1990/claude-productivity-plugin.git
```

2. **Copiar skills a Claude Code**
```bash
mkdir -p ~/.claude/skills
cp skills/*.md ~/.claude/skills/
```

3. **Copiar hooks**
```bash
mkdir -p ~/.claude/hooks
cp hooks/*.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh
```

4. **Agregar aliases al shell** (opcional)
```bash
cat scripts/shell-aliases.sh >> ~/.zshrc
source ~/.zshrc
```

## Uso

### Inicializar un Proyecto

```bash
cd tu-proyecto
/path/to/claude-productivity-plugin/scripts/init-project.sh
```

Esto crea:
```
tu-proyecto/
├── CLAUDE.md              # Edita con tus reglas
├── .claude/
│   ├── mistakes.md        # Se llena automáticamente
│   ├── patterns.md        # Tus patrones preferidos
│   └── notes/             # Notas por tarea
```

### Enseñar a Claude

Cuando Claude cometa un error:

```
Tú: "No, usa imports específicos de lodash, no el default"
Tú: "Guarda esto en tu memoria para no repetirlo"

Claude: "Entendido. Guardando en .claude/mistakes.md..."
```

Claude nunca repetirá ese error en este proyecto.

### Modo Tutor

```
> /tutor useEffect

Claude: "Antes de explicarte, ¿qué CREES que hace useEffect?"
[Te guía con preguntas hasta que entiendas]
```

### Escanear Tech Debt

```
> /techdebt

Claude: "Encontré 15 issues:
- 3 TODOs sin resolver
- 2 funciones con código duplicado
- 1 dependencia con vulnerabilidad
..."
```

### Code Review

```
> /review

Claude: "Analizando cambios...

🔴 Critical: Missing null check en users.ts:45
🟡 Suggestion: Considera usar early return
🟢 Nitpick: 'data' → 'userData' para claridad

Verdict: Approve with suggestions"
```

### Worktrees Paralelos

```bash
# En tu proyecto principal
./scripts/setup-worktrees.sh

# Ahora tienes 3 worktrees:
# proyecto-analysis  →  za
# proyecto-feature   →  zb
# proyecto-hotfix    →  zc

# Terminal 1: Análisis
za
claude "Analiza los logs de error"

# Terminal 2: Feature
zb
claude "Implementa la feature de auth"

# Terminal 3: Hotfix urgente
zc
claude "Arregla el bug de login"
```

## Estructura del Plugin

```
claude-productivity-plugin/
├── skills/
│   ├── tutor.md           # Modo aprendizaje socrático
│   ├── techdebt.md        # Detector de deuda técnica
│   ├── memory-update.md   # Sistema de memoria
│   └── review.md          # Code review profesional
├── hooks/
│   ├── hooks-config.json  # Configuración de hooks
│   ├── post-edit-test.sh  # Tests automáticos
│   ├── lint-check.sh      # Linting automático
│   └── notify-complete.sh # Notificaciones
├── templates/
│   ├── CLAUDE.md.template # Template para proyectos
│   └── .claude/
│       ├── mistakes.md    # Template de errores
│       ├── patterns.md    # Template de patrones
│       └── notes/         # Directorio de notas
├── scripts/
│   ├── install.sh         # Instalación del plugin
│   ├── init-project.sh    # Inicializar proyecto
│   └── setup-worktrees.sh # Configurar worktrees
└── README.md
```

## Tips Avanzados

### 1. Múltiples Claudes en Paralelo

Con worktrees, puedes tener 3-5 sesiones de Claude trabajando simultáneamente en diferentes aspectos del mismo proyecto sin conflictos de git.

### 2. Plan Mode

Antes de tareas complejas:
```
> /plan Implementar sistema de auth

Claude escribe el plan, luego un segundo Claude lo revisa como staff engineer.
```

### 3. Challenge Mode

```
> Grill me on these changes

Claude: "Te voy a hacer preguntas difíciles sobre tu código.
No apruebo hasta que respondas bien."
```

### 4. Mantener CLAUDE.md Actualizado

Después de cada corrección:
```
"Actualiza CLAUDE.md para que no repitas este error"
```

### 5. Notas por Feature

```
"Crea una nota en .claude/notes/feature-auth.md con el contexto de esta tarea"
```

Útil para retomar trabajo después de días/semanas.

## Configuración de Hooks

Edita `~/.claude/hooks/hooks-config.json` para personalizar:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "name": "auto-test-on-edit",
        "matcher": "Write|Edit",
        "command": "./hooks/post-edit-test.sh",
        "enabled": true
      }
    ]
  },
  "profiles": {
    "development": { "auto-test-on-edit": true },
    "fast": { "auto-test-on-edit": false }
  }
}
```

## Solución de Problemas

### Skills no se reconocen

Verifica que los archivos están en `~/.claude/skills/`:
```bash
ls ~/.claude/skills/
```

### Hooks no se ejecutan

1. Verifica permisos:
```bash
chmod +x ~/.claude/hooks/*.sh
```

2. Verifica configuración en settings.json

### Aliases no funcionan

```bash
source ~/.zshrc  # o ~/.bashrc
```

## Contribuir

1. Fork el repositorio
2. Crea una rama para tu feature
3. Haz tus cambios
4. Abre un PR

## Licencia

MIT

## Créditos

Basado en los tips del equipo de Claude Code de Anthropic y la comunidad.
