# Historial de Errores Corregidos

> Este archivo mantiene un registro de errores que Claude ha cometido y fueron corregidos.
> Claude lee este archivo para NO repetir los mismos errores.

## Cómo Usar

Cuando corrijas a Claude, dile:
```
"Guarda esto en .claude/mistakes.md para no repetirlo"
```

Claude agregará automáticamente una entrada con el formato correcto.

---

## Errores por Categoría

### TypeScript / Tipos

<!-- Ejemplo:
#### Tipo genérico incorrecto
- **Fecha**: 2024-01-15
- **Contexto**: Creando un hook de fetch
- ❌ **Error**: `useState<any>(null)`
- ✅ **Corrección**: `useState<User | null>(null)`
- **Regla**: Siempre tipar explícitamente, nunca usar `any`
-->

### Imports / Módulos

<!-- Ejemplo:
#### Import barrel innecesario
- **Fecha**: 2024-01-16
- **Contexto**: Importando utilidades
- ❌ **Error**: `import { formatDate } from '@/utils'`
- ✅ **Corrección**: `import { formatDate } from '@/utils/date'`
- **Regla**: Importar desde el archivo específico, no del barrel
-->

### React / Hooks

<!-- Ejemplo:
#### useEffect sin cleanup
- **Fecha**: 2024-01-17
- **Contexto**: Subscripción a WebSocket
- ❌ **Error**: No retornar función de cleanup
- ✅ **Corrección**: `return () => ws.close()`
- **Regla**: Siempre agregar cleanup para subscripciones/listeners
-->

### API / Backend

<!-- Errores relacionados con APIs, fetch, etc. -->

### Testing

<!-- Errores en tests, mocks, assertions -->

### Estilos / CSS

<!-- Errores de CSS, Tailwind, etc. -->

### Git / Workflow

<!-- Errores de proceso, commits, etc. -->

---

## Estadísticas

| Categoría | Errores | Último |
|-----------|---------|--------|
| TypeScript | 0 | - |
| Imports | 0 | - |
| React | 0 | - |
| API | 0 | - |
| Testing | 0 | - |
| Estilos | 0 | - |
| Git | 0 | - |

---

> Este archivo se actualiza automáticamente cuando usas el skill `/memory-update`
