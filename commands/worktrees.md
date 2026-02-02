---
description: Configura git worktrees para trabajar en multiples tareas simultaneamente con diferentes sesiones de Claude
---

# Setup Worktrees

Configura git worktrees paralelos para trabajar en multiples tareas simultaneamente.

## What are Worktrees?

Git worktrees permiten tener multiples copias de trabajo del mismo repo. Esto permite:
- Trabajar en feature mientras arreglas un bug urgente
- Tener multiples sesiones de Claude en paralelo sin conflictos
- Cambiar de contexto rapidamente

## Setup

1. Crear 3 worktrees estandar:
   - `{project}-analysis` - Para investigacion y analisis
   - `{project}-feature` - Para desarrollo de features
   - `{project}-hotfix` - Para arreglos urgentes

2. Sugerir aliases de shell:
   ```bash
   # Agregar a ~/.zshrc o ~/.bashrc
   alias za='cd ../{project}-analysis'
   alias zb='cd ../{project}-feature'
   alias zc='cd ../{project}-hotfix'
   alias zm='cd ../{project}'  # main
   ```

## Commands

```bash
# Desde el repo principal
git worktree add ../{project}-analysis main
git worktree add ../{project}-feature main
git worktree add ../{project}-hotfix main
```

## Usage Pattern

```
Terminal 1 (za - analysis):
> claude "Analiza los logs de error de la ultima semana"

Terminal 2 (zb - feature):
> claude "Implementa el sistema de autenticacion"

Terminal 3 (zc - hotfix):
> claude "Arregla el bug critico de login"
```

## Notes

- Cada worktree es un directorio independiente
- Comparten el mismo .git
- Los cambios en uno no afectan a los otros hasta hacer merge
- Ideal para tener 3-5 Claudes trabajando en paralelo
