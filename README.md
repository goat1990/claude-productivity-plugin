# Claude Productivity Plugin

> Plugin de productividad para Claude Code: memoria persistente, aprendizaje socratico, quality gates y worktrees paralelos.

Basado en los tips del equipo de Anthropic para maximizar la productividad con Claude Code.

## Instalacion

### Opcion 1: Desde GitHub (recomendado)

```bash
# Clonar el plugin
git clone https://github.com/goat1990/claude-productivity-plugin.git

# Probar localmente
claude --plugin-dir ./claude-productivity-plugin
```

### Opcion 2: Instalacion permanente

```bash
# Clonar a directorio de plugins
git clone https://github.com/goat1990/claude-productivity-plugin.git ~/.claude/plugins/productivity

# Agregar a settings.json
# En ~/.claude/settings.json, agregar:
# "plugins": ["~/.claude/plugins/productivity"]
```

### Opcion 3: Test rapido

```bash
claude --plugin-dir https://github.com/goat1990/claude-productivity-plugin
```

## Features

### 1. Sistema de Memoria Persistente

Claude recuerda tus correcciones y preferencias entre sesiones.

- **CLAUDE.md** - Reglas del proyecto que Claude lee automaticamente
- **mistakes.md** - Errores corregidos que Claude NO repetira
- **patterns.md** - Patrones de codigo preferidos
- **notes/** - Notas por feature/tarea

### 2. Skills Disponibles

| Skill | Comando | Descripcion |
|-------|---------|-------------|
| Tutor | `/productivity:tutor` | Aprende con preguntas, no lecturas |
| Tech Debt | `/productivity:techdebt` | Escanea deuda tecnica y codigo duplicado |
| Memory | `/productivity:memory` | Gestiona la memoria de Claude |
| Review | `/productivity:review` | Code review profesional antes de commits |

### 3. Comandos

| Comando | Descripcion |
|---------|-------------|
| `/productivity:init` | Inicializa proyecto con memoria persistente |
| `/productivity:worktrees` | Configura worktrees para trabajo paralelo |

### 4. Hooks Automaticos

- **Tests automaticos** - Se ejecutan despues de cada edicion
- **Notificaciones** - Alerta cuando termina una tarea larga

## Uso

### Inicializar un Proyecto

```
> /productivity:init Mi Proyecto

Claude: "Proyecto inicializado con memoria persistente.
- Creado CLAUDE.md
- Creado .claude/mistakes.md
- Creado .claude/patterns.md
- Creado .claude/notes/

Cuando me corrijas, guardare la leccion automaticamente."
```

### Ensenar a Claude

Cuando Claude cometa un error:

```
Tu: "No, usa imports especificos de lodash, no el default"
Tu: "Guarda esto en tu memoria para no repetirlo"

Claude: "Entendido. Guardando en .claude/mistakes.md..."
```

Claude nunca repetira ese error en este proyecto.

### Modo Tutor

```
> /productivity:tutor useEffect

Claude: "Antes de explicarte, que CREES que hace useEffect?"
[Te guia con preguntas hasta que entiendas]
```

### Escanear Tech Debt

```
> /productivity:techdebt

Claude: "Encontre 15 issues:
- 3 TODOs sin resolver
- 2 funciones con codigo duplicado
- 1 dependencia con vulnerabilidad
..."
```

### Code Review

```
> /productivity:review

Claude: "Analizando cambios...

Critical: Missing null check en users.ts:45
Suggestion: Considera usar early return
Nitpick: 'data' -> 'userData' para claridad

Verdict: Approve with suggestions"
```

### Worktrees Paralelos

```
> /productivity:worktrees

Claude configura 3 worktrees:
# proyecto-analysis  ->  za
# proyecto-feature   ->  zb
# proyecto-hotfix    ->  zc

# Ahora puedes tener 3 Claudes trabajando en paralelo
```

## Estructura del Plugin

```
claude-productivity-plugin/
├── .claude-plugin/
│   └── plugin.json          # Manifest del plugin
├── skills/
│   ├── tutor/
│   │   └── SKILL.md         # Modo aprendizaje socratico
│   ├── techdebt/
│   │   └── SKILL.md         # Detector de deuda tecnica
│   ├── memory/
│   │   └── SKILL.md         # Sistema de memoria
│   └── review/
│       └── SKILL.md         # Code review profesional
├── commands/
│   ├── init.md              # Inicializar proyecto
│   └── worktrees.md         # Configurar worktrees
├── hooks/
│   ├── hooks.json           # Configuracion de hooks
│   └── scripts/
│       ├── post-edit-test.sh
│       └── notify-complete.sh
├── templates/
│   ├── CLAUDE.md.template
│   └── .claude/
│       ├── mistakes.md
│       ├── patterns.md
│       └── notes/
├── scripts/
│   ├── install.sh           # Instalacion legacy
│   ├── init-project.sh
│   └── setup-worktrees.sh
└── README.md
```

## Tips Avanzados

### 1. Multiples Claudes en Paralelo

Con worktrees, puedes tener 3-5 sesiones de Claude trabajando simultaneamente en diferentes aspectos del mismo proyecto sin conflictos de git.

### 2. Plan Mode

Antes de tareas complejas:
```
> /plan Implementar sistema de auth

Claude escribe el plan, luego un segundo Claude lo revisa como staff engineer.
```

### 3. Challenge Mode

```
> Grill me on these changes

Claude: "Te voy a hacer preguntas dificiles sobre tu codigo.
No apruebo hasta que respondas bien."
```

### 4. Mantener CLAUDE.md Actualizado

Despues de cada correccion:
```
"Actualiza CLAUDE.md para que no repitas este error"
```

### 5. Notas por Feature

```
"Crea una nota en .claude/notes/feature-auth.md con el contexto de esta tarea"
```

Util para retomar trabajo despues de dias/semanas.

## Desarrollo

Para contribuir o modificar el plugin:

```bash
# Clonar
git clone https://github.com/goat1990/claude-productivity-plugin.git
cd claude-productivity-plugin

# Probar cambios
claude --plugin-dir .

# Los cambios en skills/ y commands/ se reflejan inmediatamente
```

## Solucion de Problemas

### Plugin no se carga

Verificar que existe `.claude-plugin/plugin.json`:
```bash
cat .claude-plugin/plugin.json
```

### Skills no aparecen

Los skills deben tener la estructura:
```
skills/nombre/SKILL.md
```
Con frontmatter YAML valido.

### Hooks no se ejecutan

Verificar permisos:
```bash
chmod +x hooks/scripts/*.sh
```

## Licencia

MIT

## Creditos

Basado en los tips del equipo de Claude Code de Anthropic y la comunidad.
