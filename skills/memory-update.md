# Memory Update

Actualiza la memoria persistente de Claude cuando el usuario corrige un error o enseña una preferencia.

## Trigger
- `/memory` - Ver estado actual de la memoria
- `/memory add [tipo]` - Agregar manualmente una entrada
- `/memory search [query]` - Buscar en la memoria
- "Guarda esto en tu memoria" - Trigger natural en conversación

## Automatic Detection

Cuando el usuario dice algo como:
- "No, hazlo así..."
- "Siempre usa X en lugar de Y"
- "No vuelvas a hacer eso"
- "Recuerda que prefiero..."
- "Guarda esto para no repetirlo"

Claude DEBE:
1. Reconocer que es una corrección/preferencia
2. Extraer la regla
3. Guardarla en el archivo apropiado
4. Confirmar que se guardó

## Memory Files

### `.claude/mistakes.md`
Para errores que NO debe repetir:

```markdown
#### [Categoría]: [Título breve]
- **Fecha**: YYYY-MM-DD
- **Contexto**: [Dónde ocurrió]
- ❌ **Error**: [Lo que hizo mal]
- ✅ **Corrección**: [Lo correcto]
- **Regla**: [Regla general a seguir]
```

### `.claude/patterns.md`
Para patrones preferidos:

```markdown
### [Nombre del Patrón]

**Contexto**: [Cuándo usar]
**Patrón**:
\`\`\`tsx
[código ejemplo]
\`\`\`
**Razón**: [Por qué es preferido]
```

### `CLAUDE.md`
Para reglas de alto nivel que aplican siempre.

## Example Flows

### Error Correction
```
Usuario: "No uses lodash completo, usa imports específicos"

Claude: "Entendido. Voy a guardar esto en tu memoria.

Guardando en `.claude/mistakes.md`:
---
#### Imports: Lodash específico
- **Fecha**: 2024-01-15
- **Contexto**: Imports de utilidades
- ❌ **Error**: `import { debounce } from 'lodash'`
- ✅ **Corrección**: `import debounce from 'lodash/debounce'`
- **Regla**: Siempre usar imports específicos de lodash para tree-shaking
---

✅ Guardado. No volveré a hacer ese import."
```

### Preference Learning
```
Usuario: "Siempre quiero que uses 'function' para componentes, no arrow functions"

Claude: "Entendido. Guardando tu preferencia.

Agregando a `CLAUDE.md` sección 'Reglas de Código':
---
- Usar `function ComponentName()` en lugar de `const ComponentName = () =>`
---

✅ Guardado. Usaré function declarations para componentes."
```

### Manual Add
```
Usuario: /memory add mistake

Claude: "¿Qué error quieres documentar?

1. ¿Cuál fue el error?
2. ¿Cuál es la forma correcta?
3. ¿En qué contexto aplica?

Escríbelo y lo formateo correctamente."
```

## Search Memory
```
Usuario: /memory search lodash

Claude: "Encontré 2 entradas sobre 'lodash':

1. **mistakes.md** - Import específico (2024-01-15)
   Regla: Usar imports específicos de lodash

2. **patterns.md** - Debounce pattern (2024-01-10)
   Patrón de uso de debounce con cleanup

¿Quieres ver el detalle de alguna?"
```

## Confirmation Format

Siempre confirmar con:
```
✅ Guardado en [archivo]
   Regla: [resumen de la regla]
   Esto aplica a: [contexto]
```

## Memory Stats

Con `/memory`:
```
📊 Estado de Memoria

CLAUDE.md:
- 12 reglas de código
- 5 secciones de contexto
- Última actualización: hace 2 días

.claude/mistakes.md:
- 23 errores documentados
- Categorías: TypeScript (8), React (6), API (5), Git (4)
- Última entrada: hoy

.claude/patterns.md:
- 15 patrones documentados
- Última actualización: ayer

.claude/notes/:
- 7 notas de proyecto
- Activa: feature-auth.md
```

## Best Practices

1. **Ser específico**: "Siempre usa X" es mejor que "a veces usa X"
2. **Incluir razón**: Explicar POR QUÉ ayuda a aplicar en casos similares
3. **Categorizar**: Usar categorías consistentes para búsqueda fácil
4. **Actualizar CLAUDE.md**: Mover errores frecuentes a reglas de alto nivel
5. **Limpiar periódicamente**: Eliminar reglas obsoletas o muy específicas
