---
name: memory
description: Actualiza la memoria persistente de Claude cuando el usuario corrige un error o ensena una preferencia. Gestiona mistakes.md, patterns.md y CLAUDE.md para que Claude aprenda y no repita errores.
---

# Memory Update

Actualiza la memoria persistente de Claude cuando el usuario corrige un error o ensena una preferencia.

## Trigger

- `/productivity:memory` - Ver estado actual de la memoria
- `/productivity:memory add [tipo]` - Agregar manualmente una entrada
- `/productivity:memory search [query]` - Buscar en la memoria
- "Guarda esto en tu memoria" - Trigger natural en conversacion

## Automatic Detection

Cuando el usuario dice algo como:
- "No, hazlo asi..."
- "Siempre usa X en lugar de Y"
- "No vuelvas a hacer eso"
- "Recuerda que prefiero..."
- "Guarda esto para no repetirlo"

Claude DEBE:
1. Reconocer que es una correccion/preferencia
2. Extraer la regla
3. Guardarla en el archivo apropiado
4. Confirmar que se guardo

## Memory Files

### `.claude/mistakes.md`
Para errores que NO debe repetir:

```markdown
#### [Categoria]: [Titulo breve]
- **Fecha**: YYYY-MM-DD
- **Contexto**: [Donde ocurrio]
- X **Error**: [Lo que hizo mal]
- Check **Correccion**: [Lo correcto]
- **Regla**: [Regla general a seguir]
```

### `.claude/patterns.md`
Para patrones preferidos:

```markdown
### [Nombre del Patron]

**Contexto**: [Cuando usar]
**Patron**:
\`\`\`tsx
[codigo ejemplo]
\`\`\`
**Razon**: [Por que es preferido]
```

### `CLAUDE.md`
Para reglas de alto nivel que aplican siempre.

## Example Flows

### Error Correction
```
Usuario: "No uses lodash completo, usa imports especificos"

Claude: "Entendido. Voy a guardar esto en tu memoria.

Guardando en `.claude/mistakes.md`:
---
#### Imports: Lodash especifico
- **Fecha**: 2024-01-15
- **Contexto**: Imports de utilidades
- X **Error**: `import { debounce } from 'lodash'`
- Check **Correccion**: `import debounce from 'lodash/debounce'`
- **Regla**: Siempre usar imports especificos de lodash para tree-shaking
---

Check Guardado. No volvere a hacer ese import."
```

### Preference Learning
```
Usuario: "Siempre quiero que uses 'function' para componentes, no arrow functions"

Claude: "Entendido. Guardando tu preferencia.

Agregando a `CLAUDE.md` seccion 'Reglas de Codigo':
---
- Usar `function ComponentName()` en lugar de `const ComponentName = () =>`
---

Check Guardado. Usare function declarations para componentes."
```

### Manual Add
```
Usuario: /productivity:memory add mistake

Claude: "Que error quieres documentar?

1. Cual fue el error?
2. Cual es la forma correcta?
3. En que contexto aplica?

Escribelo y lo formateo correctamente."
```

## Search Memory
```
Usuario: /productivity:memory search lodash

Claude: "Encontre 2 entradas sobre 'lodash':

1. **mistakes.md** - Import especifico (2024-01-15)
   Regla: Usar imports especificos de lodash

2. **patterns.md** - Debounce pattern (2024-01-10)
   Patron de uso de debounce con cleanup

Quieres ver el detalle de alguna?"
```

## Confirmation Format

Siempre confirmar con:
```
Check Guardado en [archivo]
   Regla: [resumen de la regla]
   Esto aplica a: [contexto]
```

## Memory Stats

Con `/productivity:memory`:
```
Estado de Memoria

CLAUDE.md:
- 12 reglas de codigo
- 5 secciones de contexto
- Ultima actualizacion: hace 2 dias

.claude/mistakes.md:
- 23 errores documentados
- Categorias: TypeScript (8), React (6), API (5), Git (4)
- Ultima entrada: hoy

.claude/patterns.md:
- 15 patrones documentados
- Ultima actualizacion: ayer

.claude/notes/:
- 7 notas de proyecto
- Activa: feature-auth.md
```

## Best Practices

1. **Ser especifico**: "Siempre usa X" es mejor que "a veces usa X"
2. **Incluir razon**: Explicar POR QUE ayuda a aplicar en casos similares
3. **Categorizar**: Usar categorias consistentes para busqueda facil
4. **Actualizar CLAUDE.md**: Mover errores frecuentes a reglas de alto nivel
5. **Limpiar periodicamente**: Eliminar reglas obsoletas o muy especificas
