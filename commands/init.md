---
description: Inicializa un proyecto con el sistema de memoria persistente de Claude. Crea CLAUDE.md, .claude/mistakes.md, .claude/patterns.md y .claude/notes/
---

# Init Project

Inicializa el proyecto actual con el sistema de memoria persistente.

## Steps

1. Crear `CLAUDE.md` en la raiz del proyecto si no existe
2. Crear directorio `.claude/` con:
   - `mistakes.md` - Para errores que no debo repetir
   - `patterns.md` - Para patrones de codigo preferidos
   - `notes/` - Para notas por feature/tarea
3. Agregar `.claude/` al `.gitignore` si el usuario lo prefiere (preguntar)

## Template CLAUDE.md

```markdown
# Proyecto: $ARGUMENTS

## Contexto
[Descripcion breve del proyecto]

## Stack
- [Tecnologias usadas]

## Reglas de Codigo
- [Preferencias especificas]

## Comandos Utiles
- `npm run dev` - Iniciar desarrollo
- `npm test` - Ejecutar tests
```

## Template mistakes.md

```markdown
# Errores a Evitar

Documento de errores corregidos. Claude leera esto para no repetirlos.

---

<!-- Las entradas se agregaran automaticamente con /productivity:memory -->
```

## Template patterns.md

```markdown
# Patrones Preferidos

Patrones de codigo que prefiero en este proyecto.

---

<!-- Las entradas se agregaran automaticamente con /productivity:memory -->
```

## After Init

Informar al usuario:
- "Proyecto inicializado con memoria persistente"
- "Usa `/productivity:memory` para gestionar la memoria"
- "Cuando me corrijas, guardare la leccion automaticamente"
