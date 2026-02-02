# Tech Debt Scanner

Escanea el proyecto en busca de deuda técnica, código duplicado, y áreas de mejora.

## Trigger
- `/techdebt` - Escaneo completo del proyecto
- `/techdebt [path]` - Escaneo de un directorio específico
- `/techdebt --quick` - Escaneo rápido (solo issues críticos)

## What to Scan

### 1. Código Duplicado

Buscar patrones repetidos que podrían extraerse:
- Funciones similares en diferentes archivos
- Lógica copy-paste con pequeñas variaciones
- Componentes que hacen lo mismo con diferentes props

```
Encontrado: Lógica de formateo de fecha duplicada
- src/utils/format.ts:45
- src/helpers/date.ts:12
Recomendación: Consolidar en un solo helper
```

### 2. TODOs y FIXMEs

Buscar comentarios pendientes:
```bash
grep -r "TODO\|FIXME\|HACK\|XXX" --include="*.ts" --include="*.tsx"
```

Reportar con contexto:
```
TODO sin resolver (15 encontrados):
- src/api/auth.ts:67 - "TODO: implement refresh token" (hace 3 meses)
- src/components/Modal.tsx:23 - "FIXME: memory leak" (hace 1 semana)
```

### 3. Dependencias Desactualizadas

```bash
npm outdated
```

Clasificar por severidad:
- CRITICAL: Vulnerabilidades de seguridad
- HIGH: Major versions atrasados
- MEDIUM: Minor versions atrasados
- LOW: Patch versions

### 4. Complejidad Ciclomática

Identificar funciones demasiado complejas:
- Funciones con más de 50 líneas
- Más de 4 niveles de anidación
- Más de 10 ramas condicionales

### 5. Cobertura de Tests

Si hay tests configurados:
```bash
npm test -- --coverage --silent
```

Reportar archivos sin tests o con baja cobertura.

### 6. Tipos Débiles

Buscar uso de tipos pobres:
- `any` explícitos
- `as unknown as X` casts
- `// @ts-ignore` o `// @ts-expect-error`

### 7. Console.logs Olvidados

```bash
grep -r "console.log\|console.warn\|console.error" --include="*.ts" --include="*.tsx" src/
```

### 8. Imports No Utilizados

Detectar imports que no se usan (ESLint/TypeScript debería marcar esto).

### 9. Variables de Entorno

Verificar que `.env.example` tenga todas las variables necesarias.

### 10. Archivos Grandes

Archivos con más de 300 líneas que podrían dividirse.

## Output Format

```markdown
# Tech Debt Report - {{PROJECT_NAME}}
> Generado: {{DATE}}

## Resumen Ejecutivo

| Categoría | Critical | High | Medium | Low |
|-----------|----------|------|--------|-----|
| Duplicación | 0 | 2 | 5 | 3 |
| TODOs | 1 | 4 | 8 | 2 |
| Dependencias | 0 | 1 | 3 | 12 |
| Complejidad | 0 | 3 | 7 | 15 |
| Tests | 2 | 5 | 10 | - |
| Tipos | 0 | 8 | 15 | 20 |

**Total Issues**: 125
**Health Score**: 72/100

## Issues Críticos (Resolver AHORA)

### [CRITICAL] Vulnerabilidad en lodash@4.17.15
- Ubicación: package.json
- Acción: `npm update lodash`
- CVE: CVE-2021-23337

## Issues Altos (Resolver esta semana)

### [HIGH] Código duplicado: formatDate
- src/utils/format.ts:45-67
- src/helpers/date.ts:12-34
- **Sugerencia**: Crear `src/lib/date-utils.ts`

## Deuda Técnica Menor (Backlog)

[... lista de issues medium/low ...]

## Recomendaciones

1. Crear ticket para resolver vulnerabilidades de seguridad
2. Dedicar 20% del sprint a reducir TODOs
3. Agregar pre-commit hook para prevenir console.logs

## Próximo Escaneo

Ejecutar `/techdebt` después de cada merge a main.
```

## Automatic Scheduling

Sugerir al usuario agregar esto a su workflow:
- Final de cada sesión de trabajo
- Antes de cada PR
- Semanalmente como rutina

## Integration with Memory

Si encuentra issues, ofrecer:
```
"¿Quieres que agregue estos patterns a evitar en .claude/mistakes.md?"
```
